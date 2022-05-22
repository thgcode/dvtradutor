{-------------------------------------------------------------}
{
{    Modulo genérico de conexão
{
{    Autor: Jose' Antonio Borges
{
{    Em 14/05/98
{
{-------------------------------------------------------------}

unit dvinet;

interface
uses windows, shellApi, sysUtils,
     dvcrt, dvWin, winsock, dvssl;

const
    MAXBUF = 4096;

type
    TbufRede = record
        sock: integer;
        buf: array [0..MAXBUF-1] of char;
        p: integer;
        lidos: integer;
    end;

    PbufRede = ^TbufRede;

function abreWinSock: boolean;
procedure fechaWinSock;

procedure descobreMeuIp (var ip, nomeComput: string);
function nomeParaIp (nomeComput: string): longint;

function abreConexao (nomeComput: string; porta: word): integer;
function abreConexaoSSL (nomeComput: string; porta: word): integer;
procedure fechaConexao (sock: integer);
function escutaConexao (porta: word): integer;
function aceitaConexao (sock: integer): integer;

function chegouRede (sock: integer): boolean;
function readlnRede (sock: integer): string;
function writeRede (sock: integer; s: string): boolean;
function writelnRede (sock: integer; s: string): boolean;

function abreConexaoUDP: integer;
function escutaConexaoUDP (porta: word): integer;
function enviaUDP (sock: integer; buf: PChar; len: integer;
                   ipDestino: longint; porta: word): integer;
function recebeUDP (sock: integer; buf: PChar; tamBuf: integer; var ipOrigem: longint): integer;

function inicBufRede (sock: integer): PbufRede;
procedure fimBufRede (pbuf: PBufRede);
function temDadoBufRede (pbuf: PbufRede): boolean;
function readlnBufRede (pbuf: PbufRede; var s: string; maxTempo: integer): boolean;
function leCaracBufRede (pbuf: PbufRede; var c: char): boolean;

var
    debugConexao: boolean;
    enderLocal, enderRemoto: longint;
                {atualizado quando se conecta ou aceita}
    timeoutChegouRede: integer;

implementation

{-------------------------------------------------------------}
{                     abre Windows Sockets
{-------------------------------------------------------------}

function abreWinSock: boolean;
var
    wsaData: TWSADATA;
begin
    abreWinSock := WSAStartup ($0101, wsaData) = 0;
end;

{-------------------------------------------------------------}
{                    fecha Windows Sockets
{-------------------------------------------------------------}

procedure fechaWinSock;
begin
    WSACleanup;
end;

{-------------------------------------------------------------}
{               transforma nome em ip
{-------------------------------------------------------------}

function nomeParaIp (nomeComput: string): longint;
var
    hip: phostent;                        { retorna o endereco IP do soquete }
    hostName: array [0..128] of char;
    enderRemoto: longint;

begin
    { Descobre endereco IP do computador }
    strPCopy (hostName, nomeComput);
    if (hostName[0] >= '0') and (hostName[0] <= '9')  then
        enderRemoto := inet_addr (hostName)
    else
        begin
            hip := gethostbyname (hostName);
            if (hip = NIL)  then
                begin
                    nomeParaIp := 0;
                    exit;
                end;
            move (hip^.h_addr_list^^, enderRemoto, 4);
        end;

    nomeParaIp := enderRemoto;
end;

{---------------------------------------------------------------}
{               descobre meu número IP (string)
{---------------------------------------------------------------}

procedure descobreMeuIp (var ip, nomeComput: string);
var
    HEnt: pHostEnt;
    HName: array [0..100] of char;
    i: integer;
begin
    if GetHostName(@HName, SizeOf(HName)) = 0 then
        begin
            HEnt := GetHostByName(HName);
            for i := 0 to HEnt^.h_length - 1 do
                 ip := Concat(ip, IntToStr(Ord(HEnt^.h_addr_list^[i])) + '.');
            delete (ip, Length(ip), 1);
            nomeComput := strPas (HName);
          end
      else
          begin
              ip := '127.0.0.1';
              nomeComput := 'localhost';
          end;
end;

{-------------------------------------------------------------}
{                abre a conexao (-1 = não abriu)
{-------------------------------------------------------------}

function abreConexao (nomeComput: string; porta: word): integer;
var
    localAddr,                          { descricao dos endereços local e remoto }
    remoteAddr: sockaddr_in;
    ret: integer;
    sock: integer;
    tam: integer;
    s: string;
    erro: integer;
begin
    abreConexao := -1;

    { cria socket e seleciona porta }

    sock := socket (AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sock = -1) then exit;

    fillchar (localAddr, sizeof (localAddr), 0);
    with localAddr do
        begin
            sin_family := AF_INET ;
            sin_addr.s_addr := htonl (INADDR_ANY);
            sin_port := htons (0);
        end;

    ret := bind (sock, localAddr, sizeof(localAddr));
    if (ret = -1)  then exit;

    { Descobre endereco IP do computador }

    enderRemoto := nomeParaIp (nomeComput);
    if enderRemoto = 0 then exit;

    { conecta com servidor }

    fillchar (remoteAddr, sizeof (remoteAddr), 0);
    with remoteAddr do
        begin
            sin_family := AF_INET;
            move (enderRemoto, sin_addr, 4);
            sin_port := word (htons (porta));
        end;

    if (connect (sock, remoteAddr, sizeof (remoteAddr)) = -1) then
         exit;

    tam := sizeof (localAddr);
    getSockName (sock, localAddr, tam);
    enderLocal := localAddr.sin_addr.s_addr;

    timeoutChegouRede := 20000;
    s := sintAmbiente ('DOSVOX', 'TIMEOUT_REDE');
    if s <> '' then
        begin
             val (s, timeoutChegouRede, erro);
             if erro <> 0 then
                 timeoutChegouRede := 20000;
        end;

    abreConexao := sock;
end;

{-------------------------------------------------------------}
{               abre uma conexão SSL
{-------------------------------------------------------------}

function abreConexaoSSL (nomeComput: string; porta: word): integer;
var sock: integer;
begin
    sock := abreConexao (nomeComput, porta);
    abreConexaoSSL := sock;

    if sock <= 0 then exit;

    if not conectaSSL (sock, nomeComput) then
        begin
            closeSocket (sock);
            abreConexaoSSL := -1;
            fechaSSL;
        end;
end;

{-------------------------------------------------------------}
{               espera algum cliente conectar
{-------------------------------------------------------------}

function escutaConexao (porta: word): integer;
var
    localAddr: sockaddr_in;           { descricao dos endereços local e remoto }
    ret: integer;
    sock: integer;
    tam: integer;

begin
    escutaConexao := -1;

    { cria socket e seleciona porta }

    sock := socket (AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (sock = -1) then exit;

    fillchar (localAddr, sizeof (localAddr), 0);
    with localAddr do
        begin
            sin_family := AF_INET ;
            sin_addr.s_addr := htonl (INADDR_ANY);
            sin_port := word (htons (porta));
        end;

    ret := bind (sock, localAddr, sizeof(localAddr));
    if (ret = -1)  then exit;

    { conecta com servidor }

    if (listen (sock, 3) = -1) then
         exit;

    tam := sizeof (localAddr);
    getSockName (sock, localAddr, tam);
    enderLocal := localAddr.sin_addr.s_addr;

    escutaConexao := sock;
end;

{--------------------------------------------------------}
{                fecha a conexao
{--------------------------------------------------------}

procedure fechaConexao (sock: integer);
begin
    if sock >= 0 then
        closeSocket (sock);
    if sock = sslSock then
        begin
            fechaSSL;
            sslSock := 0;
        end;
end;

{-------------------------------------------------------------}
{                      aceita a conexao
{-------------------------------------------------------------}

function aceitaConexao (sock: integer): integer;
var
    localAddr,
    remoteAddr: TSockAddr;
    tam: integer;
    newsock: integer;
begin
    aceitaConexao := -1;
    tam := sizeof (remoteAddr);

    newsock := accept (sock, @remoteAddr, @tam);
    if newSock = -1 then exit;

    enderRemoto := remoteAddr.sin_addr.s_addr;

    tam := sizeof (localAddr);
    getSockName (newsock, localAddr, tam);
    enderLocal := localAddr.sin_addr.s_addr;

    aceitaConexao := newsock;
end;

{-------------------------------------------------------------}
{                abre a conexao (-1 = não abriu)
{-------------------------------------------------------------}

function abreConexaoUDP: integer;
var
    sock: integer;

begin
    abreConexaoUDP := -1;

    { cria socket e seleciona porta }

    sock := socket (AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sock = -1) then exit;

    abreConexaoUDP := sock;
end;

{-------------------------------------------------------------}
{               espera algum cliente conectar
{-------------------------------------------------------------}

function escutaConexaoUDP (porta: word): integer;
var
    localAddr: sockaddr_in;               { descricao dos endereços local e remoto }
    ret: integer;
    sock: integer;

begin
    escutaConexaoUDP := -1;

    sock := socket (AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sock = -1) then exit;

    fillchar (localAddr, sizeof (localAddr), 0);
    with localAddr do
        begin
            sin_family := AF_INET ;
            sin_addr.s_addr := htonl (INADDR_ANY);
            sin_port := word (htons (porta));
        end;

    ret := bind (sock, localAddr, sizeof(localAddr));
    if ret = -1 then exit;

    escutaConexaoUDP := sock;
end;

{-------------------------------------------------------------}
{               ve se chegou dado ou conexao
{-------------------------------------------------------------}

function chegouRede (sock: integer): boolean;
var
    entradas: TFDset;
    tempoZero: timeVal;
begin
    if temDadoSSL then
        begin
            chegouRede := true;
            exit;
        end;

    with tempoZero do
        begin
            tv_sec := 0;
            tv_usec := timeoutChegouRede;
        end;

    FD_ZERO (entradas);         { monitora soquete }
    FD_SET (sock, entradas);
    select (sock+1, @entradas, NIL, NIL, @tempoZero);

    chegouRede := FD_ISSET (sock, entradas);
    keypressed;
end;

{-------------------------------------------------------------}
{           escreve uma string pequena em um socket
{-------------------------------------------------------------}

function writeRede (sock: integer; s: string): boolean;
var p: pointer;
begin
    p := @s[1];
    writeRede := sendBuf (sock, p, length (s), 0) > 0;
end;

{-------------------------------------------------------------}
{           escreve uma linha pequena num socket
{-------------------------------------------------------------}

function writelnRede (sock: integer; s: string): boolean;
var p: pointer;
begin
    s := s + #$0d + #$0a;
    p := @s[1];
    writelnRede := sendBuf (sock, p, length (s), 0) > 0;
end;

{-------------------------------------------------------------}
{      le uma linha pequena de um socket (remove crlf)
{-------------------------------------------------------------}

function readlnRede (sock: integer): string;
var buf: array [0..MAXBUF] of char;
    lidos: integer;
    s: string;
begin
     lidos := receiveBuf (sock, buf, MAXBUF, 0);
     if lidos <= 0 then
         begin
             readlnRede := '<desconectado>';
             exit;
         end;

     buf[lidos] := #$0;
     s := buf;
     if s [length(s)] = #$0a then delete (s, length (s), 1);
     if s [length(s)] = #$0d then delete (s, length (s), 1);
     readlnRede := s;
end;

{-------------------------------------------------------------}
{               envia dados para um socket udp
{-------------------------------------------------------------}

function enviaUDP (sock: integer; buf: PChar; len: integer;
                   ipDestino: longint; porta: word): integer;
var remoteAddr: sockaddr_in;
begin
    fillchar (remoteAddr, sizeof (remoteAddr), 0);
    with remoteAddr do
        begin
            sin_family := AF_INET;
            move (ipDestino, sin_addr, 4);
            sin_port := word (htons (porta));
        end;

    enviaUDP := sendto(sock, buf^, len, 0, remoteAddr, sizeof (remoteAddr));
end;

{-------------------------------------------------------------}
{               recebe dados de um socket udp
{-------------------------------------------------------------}

function recebeUDP (sock: integer; buf: PChar; tamBuf: integer; var ipOrigem: longint): integer;
var fromAddr: sockaddr_in;
    tam: integer;
begin
    tam := sizeof (fromAddr);
    fillchar (fromAddr, sizeof (fromAddr), 0);
    with fromAddr do
        begin
            sin_family := AF_INET ;
            sin_addr.s_addr := htonl (INADDR_ANY);
            sin_port := htons (0);
        end;

     recebeUDP := recvfrom (sock, buf^, tamBuf, 0, fromAddr, tam);
     ipOrigem := fromAddr.sin_addr.s_addr;
end;

{-------------------------------------------------------------}
{                inicializa o buffer de rede
{-------------------------------------------------------------}

function inicBufRede (sock: integer): PbufRede;
var pbuf: PBufRede;
begin
    getMem (pbuf, sizeof (TBufRede));
    pbuf^.p := MAXBUF;
    pbuf^.lidos := 0;
    pbuf^.sock := sock;
    inicBufRede := pbuf;
end;

{-------------------------------------------------------------}
{                     desaloca o buffer
{-------------------------------------------------------------}

procedure fimBufRede (pbuf: PbufRede);
begin
    freeMem (pbuf, sizeof (TBufRede));
end;

{-------------------------------------------------------------}
{                   vê se chegou algum dado
{-------------------------------------------------------------}

function temDadoBufRede (pbuf: PbufRede): boolean;
begin
    temDadoBufRede := false;
    if pbuf = NIL then exit;

    with pbuf^ do
        temDadoBufRede := (p < lidos) or chegouRede (sock);
end;

{-------------------------------------------------------------}
{                   lê um caractere do buffer
{-------------------------------------------------------------}

function leCaracBufRede (pbuf: PbufRede; var c: char): boolean;
begin
    leCaracBufRede := false;
    c := #$0;
    if pbuf = NIL then exit;

    with pbuf^ do
        begin
            if p >= lidos then
                begin
                    p := 0;
                    lidos := receiveBuf (sock, buf, MAXBUF, 0);
                    if lidos <= 0 then exit;
                end;

            c := buf [p];
            p := p + 1;
        end;

    leCaracBufRede := true;
end;

{-------------------------------------------------------------}
{         pega uma linha da rede com timeout
{-------------------------------------------------------------}

function readlnBufRede (pbuf: PbufRede; var s: string; maxTempo: integer): boolean;
var c: char;
    contaTempo: integer;
begin
    readlnBufRede := false;
    s := '';

    contaTempo := 0;
    repeat
        while not temDadoBufRede (pbuf) do
            begin
                delay (100);
                contaTempo := contaTempo + 1;
                if maxTempo <> 0 then
                    if contaTempo > (maxTempo*10) then exit;
            end;

        if not leCaracBufRede (pbuf, c) then
        begin
            if s = '' then exit else break
        end;

        if c = #$0a then break;

        s := s + c
    until false;

    if (s <> '') and (s[length(s)] = #$0d) then
        delete (s, length (s), 1);

    readlnBufRede := true;
end;

begin
    debugConexao := false;
end.

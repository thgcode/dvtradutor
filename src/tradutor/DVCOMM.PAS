{--------------------------------------------------------}
{
{     Rotinas de comunicacao serial
{
{     Autor:  José Antonio Borges
{
{     Em 26/04/98
{
{--------------------------------------------------------}

Unit dvComm;

interface
uses
    windows, messages, sysUtils;

function inicLink (porta: word; vel: longint;  nbits, nstop: byte;  tipoParid: byte): integer;
			    { Obs: nbits= 5, 6, 7, 8; nstop = 1, 2 }
			    { paridade: 0-sem,  1-impar,  2-par }
                            { erros:   0 = ok }
                            {    ERRO_DCB_COMM  = erro ao montar dcb }
                            {    ERRO_ABRE_COMM = erro ao abrir porta com }
                            {    ERRO_CONF_COMM = erro ao configurar porta com }


procedure finalLink;
procedure escLink (c: char);
Function  chegouLink: boolean;
procedure leLink (var c: char);
function erroLink: integer;

var
    comId: integer;

const
    ERRO_DCB_COMM  = 1;    { erro ao montar dcb }
    ERRO_ABRE_COMM = 2;    { erro ao abrir porta com }
    ERRO_CONF_COMM = 3;    { erro ao configurar porta com }


Implementation

{ constantes, tipos e variaveis }

const
    TAMBUFREC   = 65000;  // 8192;          { tamanho dos buffers }
    TAMBUFTRANS = 4096;

var
    modemDCB: TDCB;              { controles da comunicacao }
    erroCom: boolean;

    ncBufLocal: integer;          { controles do intermediário de recepçao }
    pbuf: integer;

{--------------------------------------------------------}
{              inicializacao das interrupcoes
{--------------------------------------------------------}

function inicLink (porta: word;
                    vel: longint;  nbits, nstop: byte;
		            tipoParid: byte): integer;
var
    modemInit: array [0..80] of char;
    cmdOpen: array [0..5] of char;
    num: string [7];

    {--------------------------------------------------------}

    function configDCB: boolean;
    const dcb_Binary = $00000001;
(*
      DWORD fBinary  :1;
      DWORD fParity  :1;
      DWORD fOutxCtsFlow  :1;
      DWORD fOutxDsrFlow  :1;

      DWORD fDtrControl  :2;
      DWORD fDsrSensitivity  :1;
      DWORD fTXContinueOnXoff  :1;

      DWORD fOutX  :1;
      DWORD fInX  :1;
      DWORD fErrorChar  :1;
      DWORD fNull  :1;

      DWORD fRtsControl  :2;
      DWORD fAbortOnError  :1;
      DWORD fDummy2  :17;
*)

    var
        cmd: string;
        par: char;
    begin

        case tipoParid of
           1: par := 'O';
           2: par := 'E';
        else
           par := 'N';
        end;

        cmd := 'baud=' + intToStr (vel) +
               ' parity=' + par +
               ' data=' + intToStr (nbits) +
               ' stop=' + intToStr (nstop);

        strPCopy (modemInit, cmd);
        if not buildCommDCB (modemInit, modemDCB) then
            begin
                result := false;
                exit;
            end;

        modemDCB.flags := modemDCB.flags or $1011;
        result := true;
    end;

    {--------------------------------------------------------}

begin
    if porta <= 0 then
        begin
            inicLink := ERRO_CONF_COMM;
            exit;
        end;

    strCopy (cmdOpen, 'COM');
    str (porta, num);   num := num + #$0;
    strCat (cmdOpen, @num[1]);

    try
        comId := CreateFile(cmdOpen,
                         GENERIC_READ or GENERIC_WRITE,
                         0, // Not shared
                         nil, // No security attributes
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0 // No template
                        ) ;
    except
        comId := -1;
    end;
    
    if comId < 0 then
        begin
            inicLink := ERRO_ABRE_COMM;
            exit;
        end;

    if not configDCB then
        begin
            inicLink := ERRO_DCB_COMM;
            exit;
        end;

    if not setCommState (comId, modemDCB) then
        begin
            inicLink := ERRO_CONF_COMM;
            exit;
        end;

    SetupComm(comId, TAMBUFREC, TAMBUFTRANS);

    inicLink := 0;
    erroCom := false;

    ncBufLocal := 0;
    pbuf := 1;
end;

{--------------------------------------------------------}
{              finalizacao das comunicações
{--------------------------------------------------------}

procedure finalLink;
begin
    if comId = 0 then exit;
    CloseHandle (comId);
    comId := 0;
end;

{--------------------------------------------------------}
{              escreve um byte na porta serial
{--------------------------------------------------------}

procedure escLink (c: char);
var nSent: DWORD;
begin
    if comId = 0 then exit;
    WriteFile(comId, c, 1, nSent, nil );
    erroCom := nSent = 0;
end;

{--------------------------------------------------------}
{            ativa processamento do windows
{--------------------------------------------------------}

procedure processWindowsQueue;
var
    M: TMsg;
begin
    while PeekMessage(M, 0, 0, 0, pm_Remove) do
        begin
            TranslateMessage(M);
            DispatchMessage(M);
        end;
end;

{--------------------------------------------------------}
{           ve se chegou dado na porta serial
{--------------------------------------------------------}

function chegouLink: boolean;
var
    dummy: DWORD;
    comStat: TCOMSTAT;

begin
    processWindowsQueue;
    chegouLink := false;
    if comId = 0 then exit;
    ClearCommError(comId, dummy, @comStat);
    chegouLink := comStat.cbInQue <> 0;
end;

{--------------------------------------------------------}
{             le um dado do buffer local
{--------------------------------------------------------}

procedure leLink (var c: char);
var nRead: DWORD;
begin
    if comId <> 0 then
        begin
            repeat
                processWindowsQueue;
            until chegoulink;
            ReadFile (comId, c, 1, nRead, nil);
        end
    else
        nread := 0;
    erroCom := nRead = 0;
end;

{--------------------------------------------------------}
{             verifica o erro e zera ele
{--------------------------------------------------------}

function erroLink: integer;
begin
    erroLink := integer (erroCom) and 1;
    erroCom := false;
end;

end.

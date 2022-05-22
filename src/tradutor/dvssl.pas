{-------------------------------------------------------------}
{
{    Interface simplificada para Secure Sockets Layer
{
{    Restrição: apenas 1 conexão por vez
{
{    Autor: Jose' Antonio Borges
{
{    Em 15/02/2008
{
{-------------------------------------------------------------}


unit dvssl;

interface

uses
    dvcrt,
    sysutils,
    windows,
    winSock,
    ssl_openssl_lib;
//    syssllib;

function conectaSSL (sock: integer; host: string): boolean;
procedure fechaSSL;
function recebeSSL (buf: PChar; len: integer): integer;
function enviaSSL (buf: PChar; len: integer): integer;
function temDadoSsl: boolean;
function receiveBuf (sock: integer; buf: PChar; len: integer; flags: integer): integer;
function sendBuf (sock: integer; buf: pchar; len: integer; flags: integer): integer;

const
    portaSSLPOP3  = 995;
    portaSSLSMTP  = 465;
    portaSSLHTTPS = 443;
    portaSSLFTPS  = 990;

var
//    meth: PSSL_METHOD;                          { método SSL V23 }
    SSLctx: PSSL_CTX;                           { contexto SSL }
    ssl: PSSL;                                  { soquete SSL }
    sslSock: integer;                           { soquete origem da conexão SSL }

implementation

var
    SSLActive: boolean;                         { bibliotecas SSL já ativadas }
    SSLConnected: boolean;

{-------------------------------------------------------------}

function inicializa_ctx_SSL: boolean;
begin
    inicializa_ctx_SSL := true;

    if not SSLActive then
        begin
            SSLLibraryInit;
            SSLLoadErrorStrings;
            SSLctx := SslCtxNew(SslMethodTLS);
            if SSLctx = NIL then
                SSLctx := SslCtxNew(SslMethodV23);
            SSLActive := SSLctx <> NIL;
        end;
end;

{-------------------------------------------------------------}

function conectaSSL (sock: integer; host: string): boolean;
var conOk: boolean;
begin
    if not inicializa_ctx_SSL then
        begin
            result := false;
            exit;
        end;

    ssl := SSLnew(SSLctx);
    SslSetFd(ssl, sock);

    SSLCtrl(ssl, SSL_CTRL_SET_TLSEXT_HOSTNAME, TLSEXT_NAMETYPE_host_name,
            PAnsiChar(AnsiString(host)));

    conOk := SSLconnect(ssl) > 0;
    conectaSSL := conOk;
    if conOk then sslSock := sock;
    SSLConnected := conOk;
end;

{-------------------------------------------------------------}

procedure fechaSSL;
begin
    if SSLctx <> NIL then
        SSLCtxFree(SSLctx);
    SSLshutdown(ssl);
    SSLfree(ssl);
    sslSock := 0;
    SSLConnected := false;
    SSLActive := false;
end;

{-------------------------------------------------------------}

function recebeSSL (buf: PChar; len: integer): integer;
var
    readBlocked: boolean;
    r, e: integer;

begin
    repeat
        readBlocked := false;
        r := SSLread (ssl, buf, len);

        e := SSLgetError (ssl, r);
        case e of

            SSL_ERROR_NONE:
                begin
                    buf[r] := #$0;
                    break;
                end;

            SSL_ERROR_SYSCALL,      (* Retornado pelo gmail *)
            SSL_ERROR_ZERO_RETURN:  (* End of data *)
                begin
                    r := -1;
                    break;
                end;

            SSL_ERROR_WANT_READ:    readBlocked := true;
            SSL_ERROR_WANT_WRITE:   ;

        else
            writeln ('Erro SSL: ', e);
            r := -1;
            break;
        end;

        delay (100);

    until not readBlocked;

    recebeSSL := r;
end;

{-------------------------------------------------------------}

function enviaSSL (buf: PChar; len: integer): integer;
var
    writeBlocked: boolean;
    r, e: integer;

begin
    repeat
        writeBlocked := false;

        r := SslWrite(ssl, buf, len);
        e := SSLgetError (ssl, r);
        case e of

            SSL_ERROR_NONE:
                    break;

            SSL_ERROR_SYSCALL,      (* Retornado pelo gmail *)
            SSL_ERROR_ZERO_RETURN:  (* End of data *)
                begin
                    r := -1;
                    break;
                end;

            SSL_ERROR_WANT_READ:    ;
            SSL_ERROR_WANT_WRITE:   writeBlocked := true;

        else
            r := -1;
            break;
        end;

        delay (100);

    until not writeBlocked;

    enviaSSL := r;
end;

{-------------------------------------------------------------}

function temDadoSsl: boolean;
begin
    if SSLConnected then
        temDadoSSL := SSLPending (ssl) <> 0
    else
        temDadoSSL := false;
end;

{-------------------------------------------------------------}

function receiveBuf (sock: integer; buf: PChar; len: integer; flags: integer): integer;
begin
    if SSLConnected and (sock = sslSock) then
        receiveBuf := RecebeSSL (buf, len)
    else
        receiveBuf := winSock.recv (sock, buf^, len, flags);
end;

{-------------------------------------------------------------}

function sendBuf (sock: integer; buf: pchar; len: integer; flags: integer): integer;
begin
    if SSLConnected and (sock = sslSock) then
        sendBuf := enviaSSL (buf, len)
    else
        sendBuf := winsock.send (sock, buf^, len, flags);
end;

begin
    SSLActive := false;
    SSLConnected := false;
    sslSock := 0;
end.

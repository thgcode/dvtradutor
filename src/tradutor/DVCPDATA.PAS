{------------------------------------------------------------}
{    Rotinas de tratamento de WM_COPYDATA
{    Usadas na comunicação entre aplicações 16 e 32 bits
{    Autor: José Antonio Borges
{    Em 8/10/2000
{------------------------------------------------------------}

unit dvcpdata;

interface

uses dvCrt, Windows, Messages, SysUtils;

type
    PCOPYDATASTRUCT = ^TCOPYDATASTRUCT;
    TCOPYDATASTRUCT = record
        dwData: longint;
        cbData: longint;
        lpData: pointer;
    end;

function CopyDataGetWindow (CDhandshakeMsg: Cardinal): hWnd;
procedure acceptCopyData (opt: boolean);
procedure SendWMCopyData (w: hWnd; msg: longint; conta: longint; data: pointer);
procedure SendWMCDString (w: hWnd; msg: longint; s: string);
procedure SendWMCDPchar (w: hWnd; msg: longint; p: pchar);

var
    CDData: TCOPYDATASTRUCT;
    CDDataAvailable: boolean;

var
    Recipients: DWord = BSM_APPLICATIONS;

implementation

var
    CDWindow: integer;
    CDhskMsg: Cardinal;

procedure myAlternateWinProc
                (Window: HWnd; Message, WParam: Word; LParam: Longint;
                 var resultx: longint);  far;

begin
    resultx := 0;
    if message = CDhskMsg then
        CDWindow := wparam;
end;

function CopyDataGetWindow (CDhandshakeMsg: Cardinal): hWnd;
var i: integer;
begin
    alternateWinProc := myAlternateWinProc;
    hasAlternateWinProc := true;

    CDWindow := 0;
    CDhskMsg := CDhandshakeMsg;

    broadcastSystemMessage (BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE,
        @Recipients, CDhandshakeMsg, crtWindow, 0);

    for i := 1 to 10 do
        begin
            delay (50);
            if CDWindow <> 0 then break;
        end;

    hasAlternateWinProc := false;
    copyDataGetWindow := CDWindow;
end;

procedure SendWMCopyData (w: hWnd; msg: longint; conta: longint; data: pointer);
var info: TCOPYDATASTRUCT;
begin
    info.dwData := msg;
    info.cbData := conta;
    info.lpData := data;
    sendMessage (w, WM_COPYDATA, crtWindow, longint (@info));
end;

procedure SendWMCDString (w: hWnd; msg: longint; s: string);
begin
    s := s + #$0;
    SendWMCopyData (w, msg, length(s)+1, @s[1]);
end;

procedure SendWMCDPchar (w: hWnd; msg: longint; p: pchar);
begin
    SendWMCopyData (w, msg, strlen(p), p);
end;

procedure handleCopyData (Window: HWnd; wParam: Word; lParam: Longint); far;
var p: pchar;
begin
    with CDData do
        begin
            if cbData <> 0 then
                freeMem (lpData, cbData);

            move (PCOPYDATASTRUCT (lparam)^, CDData, sizeOf (TCOPYDATASTRUCT));
            if cbData <> 0 then
                begin
                    getMem (p, cbData);
                    move (lpData^, p^, cbData);
                    lpData := p;
                end;
        end;
    CDDataAvailable := true;
end;

procedure acceptCopyData (opt: boolean);
begin
    hasCopyDataCallback := opt;
end;

begin
    hasCopyDataCallback := false;
    CopyDataCallback := handleCopyData;
    CDDataAvailable := false;
    fillChar (CDData, 0, sizeof (CDData));
end.

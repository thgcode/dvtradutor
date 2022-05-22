{--------------------------------------------------------}
{
{   Rotinas de gerenciamento do mouse
{
{   Autores:  José Antonio Borges
{             Júlio Tadeu Carvalho da Silveira
{
{   Versão 5.0: Em junho/2015
{
{--------------------------------------------------------}

unit dvMouse;

interface

uses
    Windows,
    Messages,
    dvCrt,
    sysUtils;

var
    mouseEnabled: boolean;             { mouse is enabled }
    gotFocusByClick: boolean;

{------------------------------------------------------------------------------}

function dvMouseProcEvent (Message: UINT; WParam: WPARAM; LParam: LPARAM): boolean;

implementation

uses
    dvWin;

procedure mouseLButtonDown (LParam: LPARAM);
begin
    if gotFocusByClick then
        gotFocusByClick := False
    else
        insertKeyBuf (ENTER);
end;

procedure mouseRButtonDown (LParam: LPARAM);
begin
    if gotFocusByClick then
        gotFocusByClick := False
    else
        insertKeyBuf (ESC);
end;

procedure mouseMButtonDown (LParam: LPARAM);
begin
    if gotFocusByClick then
        gotFocusByClick := False
    else
    begin
        insertKeyBuf (#$0);
        insertKeyBuf (F9);
    end;
end;

procedure mouseWheel (WParam: WPARAM; LParam: LPARAM);
var
    wRot:   integer;
begin
    if gotFocusByClick then
        begin
            gotFocusByClick := False;
            exit;
        end;
    wRot := short (WParam shr 16);
    if wRot = 0 then
        exit;

    insertKeyBuf (#$0);
    if wRot < 0 then
        insertKeyBuf (BAIX)
    else
        insertKeyBuf (CIMA);
end;

{------------------------------------------------------------------------------}
function dvMouseProcEvent (Message: UINT; WParam: WPARAM; LParam: LPARAM): boolean;
begin
    result := mouseEnabled;
    if not result then
        exit;

    case Message of
        WM_LBUTTONDOWN: mouseLButtonDown (LParam);
        WM_RBUTTONDOWN: mouseRButtonDown (LParam);
        WM_MBUTTONDOWN: mouseMButtonDown (LParam);
        WM_MOUSEWHEEL:  mouseWheel       (WParam, LParam);
    else
        result := false;
    end;
end;

begin
    mouseEnabled := True;
    gotFocusByClick := False;
end.


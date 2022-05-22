{--------------------------------------------------------}
{
{     Módulo de acesso simplificado ao MSAA
{     Autor: Antonio Borges
{     Em 23/3/2003
{
{--------------------------------------------------------}

unit dvmsaa;

interface

uses dvcrt, dvwin, Windows, messages, activex, oleacc, variants, jwawinable;

function MSAAMonitora (ativa: boolean): boolean;
function MSAAPegaPonto (x, y: integer): boolean;
function MSAAPegaEvento: boolean;
procedure MSAACoord (var x, y, dx, dy: integer);
function umaLinha (valor: string): string;

var
    MSAANome, MSAATipo, MSAAStatus, MSAAValor: string;
    MSAAcodTipo: DWORD;

implementation

type
    HWINEVENTHOOK = DWORD;

    TEvento = record
        ev_event: DWORD;
        ev_hwndMsg: HWND;
        ev_idObject: DWORD;
        ev_idChild: DWORD;
    end;

var
    filaEventos: array [0..100] of TEvento;
    pinsEvento, pretEvento: integer;

    hevHook: HWINEVENTHOOK;

    piacc: IAccessible;
    idObject: DWORD;
    idChild: DWORD;
    hwndMsg: HWND;
    v: variant;
    xob, yob, dxob, dyob: integer;

{--------------------------------------------------------}
{              inicializa as informações
{--------------------------------------------------------}

procedure inicInfo;
begin
    MSAANome := '';
    MSAATipo := '';
    MSAAStatus := '';
    MSAAValor := '';
    MSAAcodTipo := 0;
end;

{--------------------------------------------------------}
{              trata os eventos do MSAA
{--------------------------------------------------------}

procedure WinEventProc(hEvent: HWINEVENTHOOK;
                       event: DWORD;
                       hwndMsg: HWND;
                       idObject: DWORD;
                       idChild: DWORD;
                       idThread: DWORD;
                       dwmsEventTime: DWORD);    stdcall;

var p: ^TEvento;
begin
    if (event <> EVENT_SYSTEM_FOREGROUND) and
       (event <> EVENT_OBJECT_FOCUS) then exit;

    p := @filaEventos [pinsEvento];
    pinsEvento := (pinsEvento + 1) mod 100;

    p^.ev_event := event;
    p^.ev_hwndMsg := hwndMsg;

    p^.ev_idObject := idObject;
    p^.ev_idChild := idChild;
end;

{--------------------------------------------------------}
{              controla monitoração do MSAA
{--------------------------------------------------------}

function MSAAmonitora (ativa: boolean): boolean;
begin
    MSAAmonitora := true;
    if ativa then
        begin
            { Set up event call back }
            hEvHook := SetWinEventHook(EVENT_MIN,              // We want all events
                                       EVENT_MAX,              //
                                       GetModuleHandle(NIL),   // Use our own module
                                       @WinEventProc,          // Our callback function
                                       dword(0),               // All procresses
                                       dword(0),               // All threads
                                       WINEVENT_OUTOFCONTEXT   // Receive async events
                                      );

            MSAAmonitora := hEvHook <> 0;
        end
    else
        begin
            UnhookWinEvent(hEvHook);

            if piacc <> NIL then
                begin
                    piacc._Release;
                    piacc := NIL;
                end;
        end;
end;

{--------------------------------------------------------}
{              obtém os dados acessíveis
{--------------------------------------------------------}

procedure capturaDados;
var
    pszName: BSTR;
    vRole, vState: Variant;
    vid: Variant;
    wc: array [0..200] of wchar;
    dw: DWORD;

begin
    inicInfo;
    if piacc = NIL then exit;

    if succeeded (piacc.get_accRole (v, vRole)) then
        begin
            if varType(vRole) <> 3 then
                MSAAcodTipo := 8
            else
		begin
	            MSAAcodTipo := vRole;
	            if MSAAcodTipo = 0 then exit;
	            getRoleTextW (vRole, wc, 200);
	            MSAAtipo := wideCharToString (wc);
	        end;
	end;

    piacc.accLocation(xob, yob, dxob, dyob, vid);

    pszName := NIL;
    if succeeded (piacc.get_accName (v, pszName)) then
        MSAANome := pszName;
    if pszName <> NIL then
        begin
            SysFreeString(pszName);
            pszName := NIL;
        end;

    if succeeded (piacc.get_accState(v, vState)) then
        begin
            dw := vState;
            if (dw and STATE_SYSTEM_CHECKED) <> 0 then
                MSAAStatus := 'marcado';
            if (dw and STATE_SYSTEM_UNAVAILABLE) <> 0 then
                MSAAStatus := 'indisponível';
        end;

    pszName := NIL;
    if succeeded (piacc.get_accValue(v, pszName)) then
        MSAAvalor := pszName;
    if pszName <> NIL then
        begin
            SysFreeString(pszName);
            pszName := NIL;
        end;
end;

{--------------------------------------------------------}
{              obtém um objeto do cursor
{--------------------------------------------------------}

function MSAAPegaPonto (x, y: integer): boolean;
var pt: TPoint;
begin
    pt.X := x;  pt.y := y;
    MSAApegaPonto := AccessibleObjectFromPoint (pt, piacc, v) = S_OK;
    capturaDados;
end;

{--------------------------------------------------------}
{              obtém um evento da fila
{--------------------------------------------------------}

function MSAAPegaEvento: boolean;
var
    hr: HResult;
    p: ^TEvento;

begin
    MSAAPegaEvento := false;
    if pinsEvento = pretEvento then exit;

    p := @filaEventos [pretEvento];
    pretEvento := (pretEvento + 1) mod 100;

    hwndMsg := p^.ev_hwndMsg;
    idObject := p^.ev_idObject;
    idChild := p^.ev_idChild;

    processWindowsQueue;
    hr := AccessibleObjectFromEvent(hwndMsg, idObject, idChild, pIAcc, v);
    if hr <> S_OK then
        begin
            piacc := NIL;
            exit;
        end;

    piacc._AddRef;
    capturaDados;
    processWindowsQueue;
    piacc._Release;
    piacc := NIL;
    processWindowsQueue;

    MSAAPegaEvento := true;
end;

{--------------------------------------------------------}
{              obtém as coordenadas do evento
{--------------------------------------------------------}

procedure MSAACoord (var x, y, dx, dy: integer);
begin
    x := xob;
    y := yob;
    dx := dxob;
    dy := dyob;
end;

{--------------------------------------------------------}
{          pega a primeira linha entre múltiplas
{--------------------------------------------------------}

function umaLinha (valor: string): string;
var x: integer;
begin
    if valor <> '' then
        begin
            x := pos (#$0d, valor);
            if x <> 0 then valor := copy (valor, 1, x-1);
            x := pos (#$0a, valor);
            if x <> 0 then valor := copy (valor, 1, x-1);
        end;
    umaLinha := valor;
end;

begin
    inicInfo;
end.

{--------------------------------------------------------}
{
{    Modulo de execução externa
{
{    Autor: Jose' Antonio Borges
{
{    Em 24/06/97
{
{--------------------------------------------------------}

unit dvExec;

interface
uses dvCrt, dvWin,
     windows, sysUtils, shellApi;

function executaProg (nomeProg, nomeDir, nomeArq: string): THandle;
function executaProgEx (nomeProg, nomeDir, nomeArq: string; modoJanela: integer): THandle;
function esperaProgAtivar: HWnd;
procedure esperaProgVoltar;

implementation

{--------------------------------------------------------}
{        Executa o programa controlando janela
{--------------------------------------------------------}

function executaProgEx (nomeProg, nomeDir, nomeArq: string; modoJanela: integer): THandle;
var
    pprog, pdir, pparam: array [0..511] of char;
    erro: tHandle;
    p: integer;
    paramExtra: string;

begin
    nomeProg := trim (nomeProg);
    if copy (nomeProg, 1, 1) = '"' then
        begin
            p := pos ('"', copy (nomeProg, 2, 999)) + 1;
            if p <> 0 then
                begin
                    paramExtra := trim (copy (nomeProg, p+1, 999));
                    delete (nomeProg, p+1, 999);
                    if paramExtra <> '' then
                        nomeArq := paramExtra + ' ' + nomeArq;
                end;
        end;

    strPcopy (pprog, nomeProg);
    strPCopy (pdir, nomeDir);
    strPcopy (pparam, nomeArq);

    erro := ShellExecute(crtWindow, 'open', pprog, pparam, pdir, modoJanela);
    executaProgEx := erro;
end;

{--------------------------------------------------------}
{        Executa o programa em janela visível
{--------------------------------------------------------}

function executaProg (nomeProg, nomeDir, nomeArq: string): THandle;
begin
    result := executaProgEx (nomeProg, nomeDir, nomeArq, SW_SHOWNORMAL);
end;

{--------------------------------------------------------}
{        espera o titulo da janela mudar
{--------------------------------------------------------}

function esperaProgAtivar: HWnd;
var n: integer;
    jan: HWnd;
begin
    n := 50;
    repeat
        delay (100);
        dec(n);
        jan := getForegroundWindow;
    until (n = 0) or (jan <> crtWindow);
    result := jan;
end;

{--------------------------------------------------------}
{        espera o titulo da janela ficar o mesmo
{--------------------------------------------------------}

procedure esperaProgVoltar;
var
    s: string;
    erro, tempoEspera: integer;
begin
    esperaProgAtivar;
    repeat
        delay (100);
    until getForegroundWindow = crtWindow;
    s := sintAmbiente ('DOSVOX', 'TEMPOESPERAPROGVOLTAR');
    val (s, tempoEspera, erro);
    if erro <> 0 then tempoEspera := 1000;
    if (tempoEspera < 0) or (tempoEspera > 1000) then tempoEspera := 1000;
    delay (tempoEspera);
end;

end.

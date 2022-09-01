{--------------------------------------------------------}
{
{     Rotinas de fala do DOSVOX para Windows
{
{     Autores:  José Antonio Borges
{               Júlio Tadeu Carvalho da Silveira
{
{     Versão 1.0:   Em Janeiro/98
{     Versão 5.0:   Em junho/2015
{
{--------------------------------------------------------}

unit dvwin;

interface

uses Windows, SysUtils, messages, shellApi,
     dvcrt, dvwav, dvAmplia,
     dvtradut, dvinter, dvlenum, dvhora, minireg,
{$IfNDef VIDENTE}
     dvsapi,
{$EndIf}
     classes, mmsystem, activex;

function sintDirAmbiente: string;
function sintAmbienteArq (nomeSecao, nomeAmbiente, default, nomeArqIni: string): string;
procedure sintGravaAmbienteArq (secao, item, valor, nomeArqIni: string);
procedure sintRemoveAmbienteArq (secao, item, nomeArqIni: string);
procedure sintTranscreveAmbiente (ini_filename: string);
function sintItensAmbienteArq (nomeSecao, nomeArqIni: string): TStringList;

function sintAmbiente (nomeSecao, nomeAmbiente: string): string;
procedure sintGravaAmbiente (secao, item, valor: string);
procedure sintRemoveAmbiente (secao, item: string);

procedure sintInic (veloc: integer; dirSons: string);
procedure sintReinic (veloc: integer; usaSapi: boolean;
                      tipoSapi, vozSapi, velSapi, tomSapi: integer);
procedure sintFim;
procedure sintParam (quanto, minimo, interv: integer; corta, acelera: boolean);
procedure sintVeloc (n: integer);

function  sintFalando: boolean;
procedure sintMem (p: pchar);
procedure sintCarac (c: char);
procedure sintSom (nomeSom: string);
procedure sintCut;
procedure sintPara;

procedure geraCabWav (pvet: pchar; tamSom: longint; veloc, bits, canais: integer);
procedure sintClek;
procedure sintBip;
procedure sintSoletra (s: string);
procedure sintetiza (s: string);

function sintEditaCampo (var campo: string; x, y, tamanho, tamVisual: integer;
                     altera: boolean): char;
function  sintEdita (var campo: string; x, y, tamanho: integer;
                         altera: boolean): char;
procedure sintReadLn (var s: string);
function  sintReadKey: char;
procedure sintLeTecla (var c1, c2: char);
procedure sintSenha (var s: string);

procedure sintWrite (s: string);
procedure sintWriteLn (s: string);
procedure sintWriteint (n: longint);
procedure sintWriteReal (var x: real; tamNumero, casasDec: integer);
procedure sintReadint (var n: integer);
procedure sintReadReal (var n: real);
procedure sintTelefona (s: string);
procedure sintBateria;
procedure sintTeclaCorta (corta: boolean);

function existeArqSom (nomeSom: string): boolean;

function maiuscAnsi (s: string): string;
function semAcentos (s: string): string;
procedure limpaBufTec;
procedure executaArquivo (nome: string);

const
    TAMCABWAV = 44;

var
    sintAceitaLegado: boolean;
    sintTipoSapi: integer;
    sintNomeArq: string;

    sintFalaPont: boolean;
    sintCursorX: integer;
    sapiPresente: boolean;
    falandoSapi: boolean;
    velocAtual: integer;
    sintApagaAuto: boolean;
    ctrl_cv_fechaCampo: boolean;

    sintAcumulaFala: boolean;
    sintFalaAcumulada: string;

    pausaPonto: integer;
    pausaVirg: integer;
    pausaDoisPontos: integer;

const
    ALTF1 = #104;

    CTLF1 = #94;
    CTLF2 = #95;
    CTLF3 = #96;
    CTLF4 = #97;
    CTLF5 = #98;
    CTLF6 = #99;
    CTLF7 = #100;
    CTLF8 = #101;
    CTLF9 = #102;
    CTLF10 = #103;
    CTLF11 = #104;
    CTLF12 = #105;

    F1    = #59;
    F2    = #60;
    F3    = #61;
    F4    = #62;
    F5    = #63;
    F6    = #64;
    F7    = #65;
    F8    = #66;
    F9    = #67;
    F10   = #68;
    F11   = #69;
    F12   = #70;

    INS   = #82;
    DEL   = #83;
    HOME  = #71;
    TEND  = #79;
    PGUP  = #73;
    PGDN  = #81;
    CIMA  = #72;
    BAIX  = #80;
    ESQ   = #75;
    DIR   = #77;
    ENTER = #13;
    BS    = #08;
    ESC   = #27;
    TAB   = #09;

    CTLPGUP  = #132;
    CTLPGDN  = #118;
    CTLESQ   = #115;
    CTLDIR   = #116;
    CTLUP    = #113;
    CTLDOWN  = #114;
    CTLBS    = #127;
    CTLENTER = #10;

    SHIFTINS = #$FE;
    CTLINS   = #$FF;

    GOTFOCUS = #$DE;
    NOFOCUS  = #$DF;

implementation
uses videovox;

var
    nomeDirSom      : string;
    falando         : boolean;

{$IfNDef VIDENTE}
    fon: string;
    nomeDirLetras   : string;
    falaCancelada   : boolean;
{$EndIf}

const
    TAMCLEK = 256;
var
    clek: array [-TAMCABWAV..TAMCLEK-1] of byte;

{--------------------------------------------------------}
{                seleciona a velocidade
{--------------------------------------------------------}

procedure sintParam (quanto, minimo, interv: integer; corta, acelera: boolean);
{$IfDef VIDENTE}
begin
end;
{$Else}
begin
    paramFala (quanto, minimo, interv);
    speedUpWaves := acelera;
    compactWaves := corta;
end;
{$EndIf}

{--------------------------------------------------------}
{                seleciona a velocidade
{--------------------------------------------------------}

procedure sintVeloc (n: integer);
{$IfDef VIDENTE}
begin
end;
{$Else}
var
    c, m, i, erro: integer;
    corta, acelera: boolean;
    sn: string[2];
    s: string;
begin
    velocAtual := n;

    str (n, sn);
    sintBDSom := sintAmbiente ('SINTETIZADOR', 'DIFONES'+sn);
    val (sintAmbiente ('SINTETIZADOR', 'CORTEFON'+sn), c, erro);
    val (sintAmbiente ('SINTETIZADOR', 'SOBRAFON'+sn), m, erro);
    if erro <> 0 then m := 0;
    val (sintAmbiente ('SINTETIZADOR', 'INTERPAL'+sn), i, erro);
    if erro <> 0 then i := 0;
    s := sintAmbiente ('SINTETIZADOR', 'CORTAFALA'+sn);
    corta := (s <> '') and (upcase(s[1]) <> 'N');
    s := sintAmbiente ('SINTETIZADOR', 'RAPIDINHO'+sn);
    acelera := (s <> '') and (upcase(s[1]) <> 'N');

    sintParam (c, m, i, corta, acelera);

    s := sintAmbiente ('SINTETIZADOR', 'PAUSAPONTO'+sn);
    val (s, pausaPonto, erro);
    if erro <> 0 then pausaPonto := 250;
    s := sintAmbiente ('SINTETIZADOR', 'PAUSAVIRG'+sn);
    val (s, pausaVirg, erro);
    if erro <> 0 then pausaVirg := 150;
    s := sintAmbiente ('SINTETIZADOR', 'PAUSADOISPONTOS'+sn);
    val (s, pausaDoisPontos, erro);
    if erro <> 0 then pausaDoisPontos := 200;
end;
{$EndIf}

{--------------------------------------------------------}
{       configuração da ampliação para baixa visão
{--------------------------------------------------------}

procedure amplPreConfig;
var s: string;
    erro: integer;
    ampliacao, corLetra, corFundo, corCursor: integer;
begin
    s := sintAmbiente ('BAIXAVISAO', 'AMPLIACAO');
    val (s, ampliacao, erro);
    if s = '' then
        ampliacao := 0
    else
    if (erro > 0) or (ampliacao < 0) or (ampliacao > 10) then
         ampliacao := 3;

    s := sintAmbiente ('BAIXAVISAO', 'CORLETRA');
    val (s, corLetra, erro);
    if (erro > 0) or (corLetra < 0) or (corLetra > 15) then
         corLetra := YELLOW;

    s := sintAmbiente ('BAIXAVISAO', 'CORFUNDO');
    val (s, corFundo, erro);
    if (erro > 0) or (corFundo < 0) or (corFundo > 15) then
         corFundo := BROWN;

    s := sintAmbiente ('BAIXAVISAO', 'CORCURSOR');
    val (s, corCursor, erro);
    if (erro > 0) or (corCursor < 0) or (corCursor > 15) then
         corCursor := CYAN;

    amplCores (corLetra, corFundo, corCursor);
    if ampliacao <> 0 then
        begin
            InitWinCrt;
            amplInic (1, ampliacao);
        end;
end;

{--------------------------------------------------------}
{                inicializa sistema de fala
{--------------------------------------------------------}

procedure sintInic (veloc: integer; dirSons: string);
{$IfDef VIDENTE}
begin
end;
{$Else}
var n: integer;
    vozSapi, velocSapi, tomSapi, tipoSapi: integer;
    s: string;
    erro: integer;
begin
    amplPreConfig;
    sintAceitaLegado :=
        upperCase (copy (sintAmbiente ('DOSVOX', 'LEGADO'), 1, 1)) = 'S';

    if veloc < 1 then
         val (sintAmbiente ('TRADUTOR', 'VELOCIDADE'), veloc, n);

    if (veloc < 1) or (veloc > 5) then veloc := 3;
    sintVeloc (veloc);

    n := tradinic;
    if n <> 0 then
        begin
            writeln ('Erro de inicialização: ', n );
            writeln ('Banco de dados de voz: ', sintBDSom);
            tradfim;

            readln;
            doneWincrt;
        end;

    nomeDirSom := dirSons;
    if nomeDirSom <> '' then
        if nomeDirSom [length (nomeDirSom)] <> '\' then
            nomeDirSom := nomeDirSom + '\';

    nomeDirLetras := sintAmbiente ('TRADUTOR', 'DIRLETRAS');
    if nomeDirLetras = '' then
        nomeDirLetras := 'c:\winvox\som\letras';
    if nomeDirLetras [length(nomeDirLetras)] <> '\' then
        nomeDirLetras := nomeDirLetras + '\';

    sintVeloc (veloc);

    sapiPresente := false;
    s := sintAmbiente ('TRADUTOR', 'SAPI');
    if (s <> '') and (upcase(s[1]) <> 'N') then
        begin
            s := sintAmbiente ('SERVFALA', 'VOZ');
            val (s, vozSapi, erro);
            s := sintAmbiente ('SERVFALA', 'VELOCIDADE');
            val (s, velocSapi, erro);
            s := sintAmbiente ('SERVFALA', 'TOM');
            val (s, tomSapi, erro);
            s := sintAmbiente ('SERVFALA', 'TIPOSAPI');
            val (s, tipoSapi, erro);
            if (tipoSapi <> 4) and (velocSapi > 10) then
                velocSapi := 0;
            sapiPresente := sapiInic (vozSapi, velocSapi, tomSapi, tipoSapi, sintNomeArq);
            sintTipoSapi := tipoSapi;
        end;
end;
{$EndIf}

{--------------------------------------------------------}
{                reinicializa sistema de fala
{--------------------------------------------------------}

procedure sintReinic (veloc: integer; usaSapi: boolean;
                      tipoSapi, vozSapi, velSapi, tomSapi: integer);
{$IfDef VIDENTE}
begin
end;
{$Else}
begin
    sintPara;
    if sapiPresente then sapiFim;
    sapiPresente := false;

    sintVeloc (veloc);
    if usaSapi then
        begin
            if not sapiPresente then
                CoInitialize (NIL);
            if vozSapi = 0 then
                vozSapi := strToInt (sintAmbiente ('SERVFALA', 'VOZ'));
            sapiPresente := sapiInic (vozSapi, velSapi, tomSapi, tipoSapi, sintNomeArq);
            sintTipoSapi := tipoSapi;
        end;
end;
{$EndIf}

{--------------------------------------------------------}
{                finaliza sistema de fala
{--------------------------------------------------------}

procedure sintFim;
{$IfDef VIDENTE}
begin
end;
{$Else}
begin
    if sintFalaAcumulada <> '' then sintetiza ('');
    while sintFalando do waitMessage;
    sintPara;

    if sapiPresente then
        begin
            sapiFim;
            sapiPresente := false;
            // CoUnInitialize;
        end;

    tradfim;
end;
{$EndIf}

{--------------------------------------------------------}
{             gera cabecalho do formato WAV
{--------------------------------------------------------}

procedure geraCabWav (pvet: pchar; tamSom: longint; veloc, bits, canais: integer);
const
    cabWav: array [0..43] of byte = (
        $52, $49, $46, $46, $ff, $ff, $ff, $ff, $57, $41, $56, $45, $66, $6d, $74, $20,
        $10, $00, $00, $00, $01, $00, $01, $00, $11, $2b, $00, $00, $11, $2b, $00, $00,
        $01, $00, $08, $00, $64, $61, $74, $61, $ff, $ff, $ff, $ff);

var
    lpFormat: PPCMWAVEFORMAT;

var l: longint;
begin
    move (cabWav, pvet^, 44);

    l := tamSom;
    move (l, pvet[40], 4);
    l := l + 36;
    move (l, pvet[4], 4);

    lpFormat := @pvet[20];

    lpFormat^.wBitsPerSample := bits;
    lpFormat^.wf.nChannels := canais;
    lpFormat^.wf.nSamplesPerSec := veloc;
    lpFormat^.wf.nAvgBytesPerSec := veloc * canais * (bits div 8);
end;

{--------------------------------------------------------}
{ pega lista de configurações a partir de um certo .INI
{--------------------------------------------------------}

function sintItensAmbienteArq (nomeSecao, nomeArqIni: string): TStringList;
var
    returnString: array [0..10000] of char;
    sl: TStringList;
    pp: pchar;
begin
    sl := TStringList.Create;
    if nomeSecao = '' then
        GetPrivateProfileString(NIL, NIL, '', returnString, 10000, pchar(nomeArqIni))
    else
        GetPrivateProfileString(pchar(nomeSecao), NIL, '', returnString, 10000, pchar(nomeArqIni));

    pp := returnString;
    while pp^ <> #$0 do
        begin
            sl.Add(strpas(pp));
            pp := pp + strlen(pp) + 1;
        end;
    result := sl;
end;

{--------------------------------------------------------}
{       pega configuração a partir de um certo .INI
{--------------------------------------------------------}

function sintAmbienteArq (nomeSecao, nomeAmbiente, default, nomeArqIni: string): string;
var
    returnString: array[0..255] of char;
begin
    GetPrivateProfileString(pchar(nomeSecao), pchar(nomeAmbiente),
         pchar(default), returnString, 255, pchar(nomeArqIni));

    result := strPas(returnString);
end;

{--------------------------------------------------------}
{           grava configuração num certo .INI
{--------------------------------------------------------}

procedure sintGravaAmbienteArq (secao, item, valor, nomeArqIni: string);
begin
    writePrivateProfileString (pchar(secao), pchar(item), pchar(valor), pchar(nomeArqIni));
end;

{--------------------------------------------------------}
{           remove configuração num certo .INI
{--------------------------------------------------------}

procedure sintRemoveAmbienteArq (secao, item, nomeArqIni: string);
begin
    if item = '' then
        writePrivateProfileString (pchar(secao), NIL, NIL, pchar(nomeArqIni))
    else
        writePrivateProfileString (pchar(secao), pchar(item), NIL, pchar(nomeArqIni));
end;

{--------------------------------------------------------}
{       descobre o diretório para o ambiente padrão
{--------------------------------------------------------}

function sintDirAmbiente: string;
begin
    result := dosvoxIniDir;
end;

{--------------------------------------------------------}
{       pega configuração a partir de um .INI padrão
{--------------------------------------------------------}

function sintAmbiente (nomeSecao, nomeAmbiente: string): string;
var
    s, d: string;
    p: integer;
    pnome: array [0..255] of char;
    dirOriginal: string;
label tiraArrobas;

begin
    s := sintAmbienteArq (nomeSecao, nomeAmbiente, '', dosvoxIniDir + '\Dosvox.ini');

    { se não achou no ambiente novo, tenta no ini de \windows }
    if (s = '') and (sintAceitaLegado) then
        s := sintAmbienteArq (nomeSecao, nomeAmbiente, '', 'Dosvox.ini');

    getModuleFileName (hinstance, pnome, 255);
    dirOriginal := extractFileDir (pnome);

tiraArrobas:
    if s = '@' then
        s := dirOriginal
    else
        repeat
            p := pos ('@@\', s); //Neno
            if p <> 0 then
                begin
                    delete (s, p, 2);
                    insert (sintDirAmbiente, s, p);
                end;
            p := pos ('@\', s);
            if p <> 0 then
                begin
                    delete (s, p, 1);
                    d := sintAmbiente ('DOSVOX', 'PGMDOSVOX');
                    if (d = '') or (d[1] = '@') then d := dirOriginal;
                    insert (d, s, p);
                    goto tiraArrobas;
                end;
        until p = 0;

    sintAmbiente := s;
end;

{--------------------------------------------------------}
{    transcreve configuração antiga para pasta padrão
{--------------------------------------------------------}

procedure sintTranscreveAmbiente (ini_filename: string);
var sl: TStringList;
    pwindir: array [0..255] of char;
    windir: string;
    filename: string;
begin
    GetWindowsDirectory(pwindir, 255);
    windir := strPas(pwindir);

    // se arquivo ini não existe tenta copiar do \windows
    // para recuperar antigas configurações não migradas

    filename := ExtractFileName(ini_filename);
    if FileExists(windir + '\' + filename) then
        begin
            sl := TStringList.Create;
            sl.LoadFromFile(windir + '\' + filename);
            sl.SaveToFile(ini_filename);
            sl.Free;
        end;
end;

{--------------------------------------------------------}
{           grava configuração num .INI padrão
{--------------------------------------------------------}

procedure sintGravaAmbiente (secao, item, valor: string);
var windir: string;
    pwindir: array [0..255] of char;
begin
    sintGravaAmbienteArq(secao, item, valor, dosvoxIniDir + '\Dosvox.ini');

    // em futuras versões, o trecho a seguir será removido: legado não será considerado
    if sintAceitaLegado then
        begin
            GetWindowsDirectory(pwindir, 255);
            windir := strPas(pwindir);            // pelo legado, guardo também no windows
            if fileExists(windir+'\Dosvox.ini') then
                sintGravaAmbienteArq(secao, item, valor, 'Dosvox.ini');
        end;
end;

{--------------------------------------------------------}
{           remove configuração num .INI padrão
{--------------------------------------------------------}

procedure sintRemoveAmbiente (secao, item: string);
begin
    sintRemoveAmbienteArq(secao, item, sintDirAmbiente + '\Dosvox.ini');
    if sintAceitaLegado then
        sintRemoveAmbienteArq(secao, item, 'Dosvox.ini');
end;

{--------------------------------------------------------}
{                     ve se falando
{--------------------------------------------------------}

function sintFalando: boolean;
{$IfDef VIDENTE}
begin
    if keypressed then   { ativa looping de mensagens do Windows }
        begin
            sndplaysound (NIL, snd_async);
            sintFalando := false;
        end
    else
        sintFalando := not sndplaysound (NIL, snd_sync+snd_nostop);
    keypressed;          { ativa looping do Windows }
end;
{$Else}
begin
    if keypressed then
        begin
            sintPara;
            result := false;
        end
    else
        if sapiPresente then
            result := waveIsPlaying or sapiAtivo (0)
        else
            result := waveIsPlaying;
end;
{$EndIf}

{--------------------------------------------------------}
{             espera o SAPI terminar de falar
{--------------------------------------------------------}

procedure esperaSapi;
{$IfDef VIDENTE}
begin
end;
{$Else}
begin
    if falandoSapi then
        begin
            while sintFalando do waitMessage;
            falandoSapi := false;
        end;
end;
{$EndIf}

{--------------------------------------------------------}
{           sintetiza um buffer em formato WAV
{--------------------------------------------------------}

procedure sintMem (p: pchar);
{$IfDef VIDENTE}
begin
end;
{$Else}
var l: integer;
begin
    esperaSapi;

    move (p[40], l, 4);
    wavePlayMem (p);
    while sintFalando do waitMessage;
end;
{$EndIf}

{--------------------------------------------------------}
{                ecoa um Caractere
{--------------------------------------------------------}

procedure sintCarac (c: char);
{$IfDef VIDENTE}
begin
end;
{$Else}
var
    s: string;
begin
    esperaSapi;
    if ord(c) in [1..11, 13..31] then exit;
    
    str (ord(c), s);
    s := dirletras + '_' + s + '.wav';
    if FileExists(s) then
        wavePlayFile (s)
    else
        wavePlayFile (dirletras + '_unknown.wav');
end;
{$EndIf}

{--------------------------------------------------------}
{           sintetiza som testando keypressed
{--------------------------------------------------------}

procedure sintSom (nomeSom: string);
{$IfDef VIDENTE}
begin
end;
{$Else}
begin
    esperaSapi;

    if nomeSom[1] = '_' then
        begin
            nomeSom := nomeDirLetras + nomeSom + '.wav';
            wavePlayFile (nomeSom);
        end
    else
        begin
            nomeSom := nomeDirSom + nomeSom + '.wav';
            wavePlayFile (nomeSom);
        end;
end;
{$EndIf}

{--------------------------------------------------------}
{           cancela a execucao de um som
{--------------------------------------------------------}

procedure sintPara;
{$IfDef VIDENTE}
begin
end;
{$Else}
begin
    waveStop;
    falaCancelada := true;
    if sapiPresente then
        if sapiAtivo (0) or (sintTipoSapi = 3) then sapiReset;
    postMessage (crtWindow, WM_USER+99, 0, 0);
end;
{$EndIf}

{--------------------------------------------------------}
{         corta a execucao de um som na teclagem
{--------------------------------------------------------}

procedure sintCut;
{$IfDef VIDENTE}
begin
end;
{$Else}
begin
    sintPara;
    falaCancelada := true;
    if sapiPresente then
        if sapiAtivo (0) or (sintTipoSapi = 3) then sapiReset;
    postMessage (crtWindow, WM_USER+99, 0, 0);
end;
{$EndIf}

{--------------------------------------------------------}
{           verifica se existe arquivo de som
{--------------------------------------------------------}

function existeArqSom (nomeSom: string): boolean;
{$IfDef VIDENTE}
begin
        existeArqSom := false
end;
{$Else}
begin
    if copy (nomeSom, 1, 1) = '_' then
        nomeSom := nomeDirLetras + nomeSom + '.wav'
    else
        nomeSom := nomeDirSom + nomeSom + '.wav';
    existeArqSom := fileExists (nomeSom);
end;
{$EndIf}

{--------------------------------------------------------}
{                    faz um clek
{--------------------------------------------------------}

procedure SintClek;
{$IfDef VIDENTE}
begin
end;
{$Else}
var salva: boolean;
begin
    esperaSapi;

    salva := compactWaves;
    compactWaves := false;

    geraCabWav (@clek, TAMCLEK, 11025, 8, 1);
    wavePlayMem (@clek);
    while sintFalando do waitMessage;
    compactWaves := salva;
end;
{$EndIf}

{--------------------------------------------------------}
{                   toca um bip
{--------------------------------------------------------}

Procedure SintBip;
{$IfDef VIDENTE}
begin
end;
{$Else}
const
    TAMBIP = 512;
var i: integer;
    bip:  array [-TAMCABWAV..TAMBIP-1] of byte;
begin
    esperaSapi;

    while keypressed do readkey;
    i := 0;
    while i < TAMBIP do
        begin
            bip[i] := $80; inc (i);
            bip[i] := $70; inc (i);
            bip[i] := $60; inc (i);
            bip[i] := $50; inc (i);
            bip[i] := $40; inc (i);
            bip[i] := $50; inc (i);
            bip[i] := $60; inc (i);
            bip[i] := $70; inc (i);
        end;

    bip[TAMBIP-1] := $80;

    geraCabWav (@bip, TAMBIP, 11025, 8, 1);
    wavePlayMem (@bip);
    while sintFalando do waitMessage;
end;
{$EndIf}

{--------------------------------------------------------}
{                soletra uma cadeia
{--------------------------------------------------------}

procedure sintSoletra (s: string);
{$IfDef VIDENTE}
begin
end;
{$Else}
var i: integer;
begin
    for i := 1 to length (s) do
        begin
            if keypressed then exit;
            sintCarac (s[i]);
        end;
end;
{$EndIf}

{--------------------------------------------------------}
{         le uma tecla falando, sem ecoar na tela
{--------------------------------------------------------}

function sintReadKey: char;
{$IfDef VIDENTE}
begin
        sintReadKey := readkey
end;
{$Else}
var c: char;
begin
    if sintFalaAcumulada <> '' then
        sintetiza ('');
    c := readkey;
    sintCut;
    sintCarac (c);
    sintReadKey := c;
end;
{$EndIf}

{--------------------------------------------------------}
{               escreve e fala uma cadeia
{--------------------------------------------------------}

procedure sintWrite (s: string);
begin
    write (s);
{$IfNDef VIDENTE}
    sintetiza (s);
{$EndIf}
end;

{--------------------------------------------------------}
{        escreve e fala uma cadeia pulando linha
{--------------------------------------------------------}

procedure sintWriteLn (s: string);
begin
    sintWrite (s);
    writeln;
{$IfNDef VIDENTE}
    if sintFalaAcumulada <> '' then sintetiza ('');
{$EndIf}
end;

{--------------------------------------------------------}
{        escreve e fala um numero pulando linha
{--------------------------------------------------------}

procedure sintWriteint (n: longint);
var s: string;
begin
    str (n, s);
    sintWrite (s);
end;

{--------------------------------------------------------}
{                escreve ecoando um numero real
{--------------------------------------------------------}

procedure sintWriteReal (var x: real; tamNumero, casasDec: integer);
var
    s: string;
    n, i: integer;
begin
    n := trunc (x);
    sintWriteInt (n);
    if frac(x) <> 0 then
        begin
            str (frac(abs(x)):tamNumero:casasDec, s);
            s := trim (s);
            delete (s, 1, 1);
            for i := 1 to length (s) do
                sintWrite (s[i]);
        end;
end;

{--------------------------------------------------------}
{              trata os sinais de pontuacao
{--------------------------------------------------------}

procedure trataPontuacao (s: string);

    procedure espera (n: integer);
    var i: integer;
    begin
        for i := 1 to n div 50 do
            if not keypressed then delay (50);
    end;

begin
    if keypressed then exit;

    while sintFalando do waitMessage;

    if sintFalaPont then sintcarac (s[1]);

    case s[1] of
        '.':   if (length (s) > 1) and (s[2] = ' ') then
                   espera (PausaPonto)
               else
                   if not sintFalaPont then sintCarac (s[1]);   { evita repetir letra }

        ',', '-':   if (length (s) > 1) and (s[2] = ' ') then
                   espera (pausaVirg)
               else
                   if not sintFalaPont then sintCarac (s[1]);   { evita repetir letra }

        ';', ':', '(', ')':   espera (pausaDoisPontos);
    end;
end;

{--------------------------------------------------------}
{                   sintetiza uma cadeia
{--------------------------------------------------------}

procedure sintetiza (s: string);
{$IfDef VIDENTE}
begin
end;
{$Else}
var
    encontrouHifen: boolean;
    subcad: string;
    erro: integer;
    x: longint;
    c: char;

    ultLetra: char;
    nrepUlt: integer;

const
    alfa: set of char = [' ', 'A'..'Z', 'a'..'z', #128..#255];
    alfapuro: set of char = ['A'..'Z', 'a'..'z', #128..#255];

label fim;

begin
    if sintAcumulaFala then
        begin
            if s <> '' then
                begin
                    if not (s[1] in alfapuro) then
                        sintFalaAcumulada := sintFalaAcumulada + s
                    else
                        sintFalaAcumulada := sintFalaAcumulada + ' ' + s;
                    exit;
                end
            else
                begin
                    s := sintFalaAcumulada;
                    sintFalaAcumulada := '';
                end;
        end;

    if sapiPresente then
        begin
            while sintFalando do waitMessage;
            if not keypressed then
                begin
                    sapiFala (s);
                    falandoSapi := true;
                end;
            exit;
        end;

    ultLetra := ' ';
    nrepUlt := 0;

    s := s + ' ';
    falaCancelada := false;
    while not (falaCancelada) and (s <> '') do
        begin
            if keypressed then
                begin
                    sintPara;
                    goto fim;
                end;

            while s[1] = '0' do
                begin
                    sintSom ('_zero');
                    delete (s, 1, 1);
                end;

            if (s <> '') and (s[1] in ['1'..'9']) then
                begin
                    encontrouHifen := false;
                    subcad := '';
                    while (s <> '') and (s[1] in ['0'..'9', '-']) do
                        begin
                            subcad := subcad + s[1];
                            if s[1] = '-' then
                                encontrouHifen := true;
                            delete (s, 1, 1);
                        end;
                    if encontrouHifen then  { provavel numero de telefone }
                        sintSoletra (subcad)
                    else
                        begin
                            if length (subcad) >= 7 then
                                sintSoletra (subcad)
                            else
                                begin
                                    val (subcad, x, erro);
                                    falaNumeroConv (numeroParaString (x), MASCULINO);
                                end;
                        end;
                end
            else

            if (s <> '') and (s[1] in alfa) then
                begin
                    subcad := '';
                    while (s <> '') and (s[1] in Alfa) do
                        begin
                            subcad := subcad + s[1];
                            delete (s, 1, 1);
                        end;

                    if subcad <> '' then
                         begin
                             if maiuscAnsi (subcad) = 'WWW' then
                                 sintSoletra (subcad)
                             else
                                 begin
                                     compilaFonemas (copy (subcad, 1, 999), fon);
                                     falaFonemas (fon, false);
                                 end;
                         end;

                    if (s <> '') and (s[1] = '-') and (s[2] in alfapuro) then
                        delete (s, 1, 1);
                end
            else

                begin
                    c := ' ';
                    if s <> '' then c := s[1];

                    if ultLetra = c then
                        begin
                            nrepUlt := nrepUlt + 1;
                            if nrepUlt > 3 then
                                begin
                                    sintClek;
                                    c := ' ';
                                end;
                        end
                    else
                        begin
                            nrepUlt := 0;
                            ultLetra := c;
                        end;

                    if copy (s, 1, 1) = '-' then
                        begin
                            if length (s) > 2 then c := s[2] else c := ' ';
                            if (c = ' ') or (c = '-') then
                                trataPontuacao (s)
                            else
                            if c in ['0'..'9'] then
                                sintSom ('_MENOS')
                            else
                                sintCarac ('-');
                        end
                    else
                    if copy (s, 1, 3) = '://' then
                        sintSoletra (s[1])
                    else
                    if c in ['.', ',', ';', ':', '(', ')'] then
                        trataPontuacao (s)
                    else
                    if (c <> ' ') and (c <> #$0d) and (c <> #$0a) and
                       (c <> #$09) and (not keypressed) then
                        sintCarac (c);

                    delete (s, 1, 1);
                end;
        end;

fim:
end;
{$EndIf}

{--------------------------------------------------------}
{             calcula uma string em maiuscula
{--------------------------------------------------------}

function maiuscAnsi (s: string): string;
var x: string;
    i: integer;
begin
    x := s;
    for i:= 1 to length (s) do
        if x[i] in ['a'..'z'] then
            x[i] := upcase (x[i])
        else
            if x[i] in [#$e0..#$ff] then
                x[i] := chr (ord(x[i]) - $20);
    maiuscAnsi := x;
end;

{--------------------------------------------------------}
{               remove os acentos de uma cadeia
{--------------------------------------------------------}

function semAcentos (s: string): string;
const
    tabMaiuscPC: array [#$80..#$ff] of char = (

    'C','U','E','A','A','A','A','C','E','E','E','I','I','I','A','A',
    'E','þ','þ','O','O','O','U','U','Y','O','U','þ','þ','þ','þ','þ',
    'A','I','O','U','N','N','þ','þ','þ','þ','þ','þ','þ','þ','þ','þ',
    'þ','þ','þ','þ','þ','þ','þ','þ','þ','þ','þ','þ','þ','þ','þ','þ',
    'A','A','A','A','A','A','‘','C','E','E','E','E','I','I','I','I',
    'þ','N','O','O','O','O','O','X','þ','U','U','U','U','Y','þ','þ',
    'A','A','A','A','A','A','‘','C','E','E','E','E','I','I','I','I',
    'þ','N','O','O','O','O','O','X','þ','U','U','U','U','Y','þ','þ');

var
    s2: string;
    i: integer;

begin
    s2 := s;
    for i := 1 to length (s2) do
        if s2[i] in ['a'..'z'] then
            s2[i] := upcase (s2[i])
        else
        if s2[i] >= #$80 then
            s2[i] := tabMaiuscPC [s2[i]];

    semAcentos := s2;
end;

{--------------------------------------------------------}
{                limpa o buffer do teclado
{--------------------------------------------------------}

procedure limpaBufTec;
begin
    while keypressed do readkey;
end;

{--------------------------------------------------------}
{                 le uma tecla, ecoando
{--------------------------------------------------------}

procedure sintLeTecla (var c1, c2: char);
{$IfDef VIDENTE}
begin
    c2 := ' ';
    c1 := readkey;
    if c1 = #0 then c2 := readkey;
    if c1 in [#32..#126, #127..#255] then
        write (c1);
end;
{$Else}
label inicio;
begin
inicio:
    while sintFalando do waitMessage;     { permite fechamento do dispositivo de som }
    c2 := ' ';
    c1 := readkey;
    if (c1 = GOTFOCUS) or (c1 = NOFOCUS) then goto inicio;

    if c1 = #0 then
        begin
            c2 := readkey;
            if c2 in [#16..#18] then      { teclado braille }
                c1 := readkey;
        end;

    if (c1 = #0) and (c2 = F8) then
        begin
            falaHora;
            goto inicio;
        end;

    if c1 in [#32..#126, #127..#255] then
        begin
            write (c1);
            sintCarac (c1);
        end;
end;
{$EndIf}

{--------------------------------------------------------}
{                produz sinais dtmf
{--------------------------------------------------------}

procedure sintTelefona (s: string);
{$IfDef VIDENTE}
begin
end;
{$Else}
var i: integer;
    c: char;
    salva: boolean;
begin
    salva := speedUpWaves;
    speedUpWaves := false;
    for i := 1 to length (s) do
        begin
            c := upcase (s[i]);
            if c in ['0'..'9', {'A'..'D',} '#', '*'] then
                begin
                    if c = '*' then c := 'X';
                    wavePlayFile (dirletras + 'dtmf_' + c + '.wav');
                    while sintFalando do waitMessage;
                    delay (100);
                end
            else
                if c = ',' then
                    delay (1000);
        end;
    speedUpWaves := salva;
end;
{$EndIf}

{--------------------------------------------------------}
{                fala o nível da bateria
{--------------------------------------------------------}

procedure sintBateria;
var
    powerStatus: _SYSTEM_POWER_STATUS;
begin
    getSystemPowerStatus (powerStatus);
    if powerStatus.BatteryFlag = 128 then
        sintSom ('_SEMBAT')   // sem bateria
    else
        sintetiza (intToStr (powerStatus.BatteryLifePercent) + '%');
    if powerStatus.ACLineStatus = 0 then
        sintSom ('_SEMENER');   // energia desligada.
end;

{--------------------------------------------------------}
{                seleciona a velocidade
{--------------------------------------------------------}

procedure sintTeclaCorta (corta: boolean);
begin
    keyStopsWave := corta;
end;

{--------------------------------------------------------}
{                       executa um arquivo
{--------------------------------------------------------}

procedure executaArquivo (nome: string);
var extensao: string[3];
    nomeArq, nomeProg, nomeDir: string[255];
    p: integer;
    drive: string [10];
    snomeArq, snomeProg, sNomeDir: array [0..255] of char;
label exec;
begin
    nomeArq := nome;
    getdir (0, nomeDir);

    if (copy (nomeArq, 1, 7) = 'http://') or
       (copy (nomeArq, 1, 8) = 'https://') or
       (copy (nomeArq, 1, 4) = 'www.') then
        begin
            nomeProg := sintAmbiente ('DOSVOX', 'PROG.HTM');
            goto exec;
        end;

    p := pos ('.', nomeArq);
    extensao := maiuscAnsi (copy (nomeArq, p+1, 3));
    if (extensao = 'EXE') or (extensao = 'COM') then
        begin
            drive := copy (nomeArq, 1, 3) + '   ';
            if ((upcase(drive[1]) in ['A'..'Z']) and (drive[2] = ':')) or
               (drive[1] = '\')  then
                nomeProg := nomeArq
            else
                if nomeDir [length (nomeDir)] = '\' then
                    nomeProg := nomedir + nomeArq
                else
                    nomeProg := nomedir + '\' + nomeArq;
            nomeArq := '';
        end
    else
        begin
            nomeProg := sintAmbiente ('DOSVOX', 'PROG.' + extensao);
            if nomeProg = '' then
                begin
                    nomeProg := nomeArq;
                    nomeArq := '';
                end;
    end;

exec:
    while sintFalando do waitMessage;
    strPCopy (sNomeProg, nomeProg);
    strPCopy (sNomeArq, nomeArq);
    strPCopy (sNomeDir, nomeDir);
    ShellExecute (crtWindow, 'open', snomeProg, snomeArq, snomeDir, SW_SHOWNORMAL);
    while sintFalando do waitMessage;
end;

{--------------------------------------------------------}
{                    edita um item
{--------------------------------------------------------}

function sintEditaCampo (var campo: string; x, y, tamanho, tamVisual: integer;
                     altera: boolean): char;
var c, c2: char;
    curx, i: integer;
    primeiraVez: boolean;
    colInic: integer;

label fechaCampo;

{--------------------------------------------------------}

    procedure caracComum (c: char);
    begin
        if not altera then
            exit;

        if curx > tamanho then
            begin
                sintBip;
                exit;
            end;

        insert (c, campo, curx);
        delete (campo, tamanho+1, 1);

        gotoxy (x+curx-1, y);
        write (c);

        if falando then
            sintCarac (c);
        curx := curx + 1;
    end;

{--------------------------------------------------------}

    procedure delCarac (comDel: boolean);
    var campoPc: string;
        c: char;
    begin
        if not altera then
            exit;

        c := campo [curx];
        delete (campo, curx, 1);
        campo := campo + ' ';

        gotoxy (x, y);
        campoPC := copy (campo, colinic, tamVisual);
        write (campoPC);

        if comDel then sintSom ('_DEL');
        sintCarac(c);
    end;

{--------------------------------------------------------}

    function temVogal (s: string): boolean;
    const
        CONSOANTES: set of char =
        ['B','C','D','F','G','H','J','K','L','M',
         'N','P','Q','R','S','T','V','X','Z'];

    var i: integer;

    begin
        temVogal := true;
        for i := 1 to length (s) do
             if not (upcase (s[i]) in CONSOANTES) then exit;
        temVogal := false;
    end;

{--------------------------------------------------------}

    procedure falaPalavra;
    var palavra: string;
        c: char;
        salvacur: integer;
    begin
        campo := campo + #0;
        salvacur := curx;
        while campo [curx] = ' ' do
            curx := curx + 1;

        c := upcase (campo [curx]);
        case c of
            #0: sintBip;

            'A'..'Z', #128..#255:
                begin
                    palavra := '';
                    repeat
                        palavra := palavra + campo[curx];
                        curx := curx + 1;
                    until not (upcase (campo[curx]) in
                            ['A'..'Z', #128..#255]);
                    if temVogal (palavra) then
                        sintetiza (palavra)
                    else
                        sintSoletra (palavra);
                end;

            '0'..'9', '-':
                begin
                    palavra := '';
                    repeat
                        palavra := palavra + campo[curx];
                        curx := curx + 1;
                    until not (campo[curx] in ['0'..'9']);
                    sintetiza (palavra);
                end;

        else
            begin
                palavra := campo [curx];
                curx := curx + 1;
                sintSoletra (palavra);
            end;
        end { case };

        campo := copy (campo, 1, length(campo)-1);
        if c = #0 then
            curx := salvacur;
    end;

{--------------------------------------------------------}

    procedure avancaPalavra;
    var tam: integer;
        c: char;
    begin
        tam := length (campo);
        campo := campo + ' @';

        c := campo [curx];
        if c <> ' ' then
            if c in ['0'..'9'] then
                repeat
                    curx := curx + 1;
                    c := campo [curx];
                until not (c in ['0'..'9'])
            else
                repeat
                    curx := curx + 1;
                    c := campo [curx];
                until not (c in ['a'..'z', 'A'..'Z', #128..#255]);

        if c = ' ' then
            repeat
                curx := curx + 1;
                c := campo [curx];
            until c <> ' ';

        campo := copy (campo, 1, tam);

        if curx > tam+1 then
            begin
                curx := length(campo)+1;
                repeat
                    curx := curx - 1;
                until (curx = 0) or (campo[curx] <> ' ');
                curx := curx + 1;
                sintBip;
            end
        else
            sintClek;
    end;

{--------------------------------------------------------}

    procedure recuaPalavra;
    var tam: integer;
        c: char;
    begin
        tam := length (campo);
        campo := ' @' + campo;
        curx := curx + 2;

        repeat
            curx := curx - 1;
            c := campo [curx];
        until c <> ' ';

        if c in ['0'..'9'] then
            repeat
                curx := curx - 1;
                c := campo [curx];
            until not (c in ['0'..'9'])
        else
            repeat
                curx := curx - 1;
                c := campo [curx];
            until not (c in ['a'..'z', 'A'..'Z', #128..#255]);

        campo := copy (campo, 3, tam);
        curx := curx - 1;

        if curx <= 0 then
            begin
                curx := 1;
                sintBip;
            end
        else
            sintClek;
    end;

{--------------------------------------------------------}

var campoPc: string;
    buf: array [0..2048+2] of char;
    xx: integer;
    temLetras: boolean;
    sn: string;
    v: integer;
    salvaCampo: string;
    nl: integer;
    x1, x2: integer;
    comando: string;
    iniMarca, fimMarca: integer;
    atr: word;
    apertouShift: boolean;
    saveQWav: boolean;

const
    espurios: set of char = ['<', '"', '(', '{', '[', '-', '=', '.', '_', '>', '*'];

label moveu, processaC2;

     procedure troca (var x1, x2: integer);
     var temp: integer;
     begin
         temp := x1;  x1 := x2;  x2 := temp;
     end;

begin
    if tamanho > 2048 then tamanho := 2048;

    if tamVisual > tamanho then
        tamVisual := tamanho;
    with currentWindow do
        if (y = bottom-top+1) and (x+tamVisual > right-left+1) then
            tamVisual := tamVisual - 1;

    campo := copy (campo, 1, tamanho);
    while length (campo) < tamanho do
        campo := campo + ' ';

    primeiraVez := true;
    curx := 1;
    colInic := 1;
    salvaCampo := campo;
    c2 := ' ';

    iniMarca := 0;
    fimMarca := 0;

    saveQwav := queueingWaves;
    queueingWaves := true;
    repeat
        if curx < colInic then colInic := curx;
        if curx > colinic+tamVisual then colInic := curx-tamVisual;
        campoPC := copy (campo, colinic, tamVisual);

        amplCampo(campo, curx-colInic+1);

        gotoxy (x, y);

        x1 := iniMarca - colInic;
        x2 := fimMarca - colInic;
        if iniMarca > fimMarca then troca (x1, x2);

        if (fimMarca = 0) or (x1 >= tamVisual) or (x2 < 0) then
            write (campoPC)
        else
            begin
                atr := textAttr;
                if x1 > 0 then
                    write (copy (campoPC, 1, x1));
                TextBackGround (DARKGRAY);
                write (copy (campoPC, x1+1, x2-x1));
                textAttr := atr;
                write (copy (campoPC, x2+1, 999));
             end;

        if length (campoPC) < 80 then clreol;
        gotoxy (curx-colinic+x, y);

        if sintFalaAcumulada <> '' then
            sintetiza ('');

        c := readkey;
        sintCut;
        apertouShift := GetKeyState(VK_SHIFT) < 0;

        if c = #0 then
            begin
                c2 := readkey;
                if c2 in [#16..#18] then
                    c := readkey; {ALT-GR q,w,e}
            end;

        if c = #0 then
            begin
                sintPara;

                if not apertouShift then
                    begin
                        if (c2 <> CTLINS) and (c2 <> SHIFTINS) then
                            begin
                                iniMarca := 0;
                                fimMarca := 0;
                            end;
                    end
                else
                    begin
                        if iniMarca <= 0 then iniMarca := curx;
                    end;

processaC2:
                case c2 of
                    ESQ: if curx <= 1 then
                              sintBip
                          else
                              begin
                                  curx := curx - 1;
                                  sintCarac (campo [curx]);
                              end;

                    DIR: begin
                              if curx > length (campo) then
                                  sintBip
                              else
                                  begin
                                      if (not (upcase(campo [curx]) in ['A'..'Z', 'a'..'z'])) or
                                         (getKeyState (vk_Menu) >= 0) then
                                          sintCarac(campo [curx])
                                      else
                                          sintSom('_FON' + intToStr(ord(campo [curx])));
                                      curx := curx + 1;
                                  end;
                         end;

                    HOME:  curx := 1;

                    TEND:  begin
                              curx := length (campo)+1;
                              repeat
                                  curx := curx - 1;
                              until (curx = 0) or (campo[curx] <> ' ');
                              curx := curx + 1;
                          end;

                    DEL: if (iniMarca > 0) and (fimMarca > 0) then
                             begin
                                  if iniMarca > fimMarca then troca(iniMarca, fimMarca);
                                  curx := iniMarca;
                                  sintSom ('_DEL');
                                  for i := iniMarca to fimMarca-1 do
                                      delCarac (false);
                                  fimMarca := iniMarca;
                             end
                         else
                             delCarac (true);

                    F1:  begin
                             if (getKeyState (VK_MENU) shr 15) <> 0 then
                                 begin
                                     c2 := ALTF1;
                                     goto fechaCampo;
                                 end;
                             falaPalavra;
                         end;

                 CTLF11: sintBateria;

                    F12:
                         begin
                             x1 := curx;
                             while (x1 > 1) and (campo[x1-1] <> ' ') do
                                 x1 := x1 - 1;
                             x2 := curx;
                             while (x2 < length(campo)) and (campo[x2] <> ' ') do
                                  x2 := x2 + 1;
                             if campo[x2] = ' ' then x2 := x2 - 1;
                             comando := copy (campo, x1, x2-x1+1);

                            while (comando <> '') and (comando[1] in espurios) do
                                delete (comando, 1, 1);
                            while (comando <> '') and (comando[length(comando)] in espurios) do
                                delete (comando, length(comando), 1);

                             if comando = '' then
                                 sintBip
                             else
                                 executaArquivo (comando);
                         end;

                    F4:  begin
                             falando := not falando;
                             if falando then
                                 sintSom ('_FALACI')   {Fala acionada}
                             else
                                 sintSom ('_FALDLG');  {Fala desligada}
                         end;

                    CTLF4:  begin
                                sintSom ('_VELOC');    {Qual a velocidade de 1 a 4 ? }
                                repeat
                                    c := sintReadkey;
                                until not keypressed;
                                if (c <> ESC) and (c <> ENTER) then
                                    begin
                                        sintFim;
                                        v := ord (c) - ord('0');
                                        sintInic (v, nomeDirSom);
                                    end;
                            end;
                    F8:     falaHora;
                    CTLF8:  falaDia;

                    CTLF9:  if getKeyState (vk_Menu) < 0 then
                                leitorDeTela
                            else
                                goto fechaCampo;

                    CTLDIR: avancaPalavra;

                    CTLESQ: recuaPalavra;

                    CTLF1:  sintetiza (campo);

                    CTLINS:   begin
                                  if (iniMarca <= 0) or (fimMarca <= 0) then   // não marcado
                                      begin
                                           xx := length (campo);
                                           repeat
                                               xx := xx - 1;
                                           until (xx = 0) or (campo[xx] <> ' ');
                                           for i := 1 to xx do
                                               buf[i-1] := campo[i];
                                           buf [xx] := #$0d;   xx := xx + 1;
                                           buf [xx] := #$0a;   xx := xx + 1;
                                           buf [xx] := #$0;
                                      end
                                  else
                                      begin
                                           if iniMarca > fimMarca then troca(iniMarca, fimMarca);
                                           for i := 1 to (fimMarca-iniMarca) do
                                               buf[i-1] := campo[i+iniMarca-1];
                                           buf [fimMarca-iniMarca] := #$0;
                                      end;

                                  putClipboard (@buf);
                              end;

                    SHIFTINS:  begin
                                   getClipboard (@buf, length(campo)+1);
                                   sn := strPas (buf);
                                   for i := 1 to length (sn) do
                                        if (sn[i] = #$0d) or (sn[i] = #$0a) then
                                             begin
                                                 delete (sn, i, 999);
                                                 break;
                                             end;

                                   if primeiraVez and sintApagaAuto then
                                       begin
                                           sintClek;
                                           sintClek;
                                           for i := 1 to length (campo) do
                                                campo [i] := ' ';
                                       end;

                                  if iniMarca <= 0 then
                                      begin
                                           iniMarca := curx;
                                           fimMarca := curx;
                                      end
                                  else
                                      curx := iniMarca;

                                  xx := fimMarca;
                                  fimMarca := iniMarca + length(sn);
                                  sn := copy (campo, 1, iniMarca-1) +
                                        sn + copy (campo, xx, 999);

                                  fillchar (campo[1], length (campo), ' ');
                                  sn := copy (sn, 1, length (campo));  // o que for menor
                                  for i := 1 to length (sn) do
                                      campo[i] := sn[i];
                               end;

                    #120..#129: ;

                else
                    goto FechaCampo;
                end;

                if apertouShift then
                    fimMarca := curx;
            end
        else
            begin
                if not (c in [^C, ^V, NOFOCUS, GOTFOCUS]) then
                    begin
                        iniMarca := 0;
                        fimMarca := 0;
                    end;

                c2 := c;
                case c of
                    NOFOCUS: ;
                    GOTFOCUS:  begin
                                   while sintFalando do waitMessage;
                                   sintetiza (campo);
                               end;

                    ^b, ENTER, CTLENTER, ESC: begin
                                    c2 := c;
                                    goto FechaCampo;
                                end;

                    CTLBS:  begin
                                if (curx > 1) and (campo [curx-1] <> ' ') then
                                    recuaPalavra;
                                x1 := curx;
                                avancaPalavra;
                                x2 := curx;
                                recuaPalavra;
                                for i := x1 to x2-1 do
                                    delCarac (i=x1);
                            end;

                    TAB:   goto fechaCampo;

                    BS:    begin
                               if curx = 1 then
                                   sintBip
                               else
                                   begin
                                       curx := curx - 1;
                                       delCarac (true);
                                   end;
                           end;

                    ^K:    begin
                               str (curx, sn);
                               sintetiza (sn);
                           end;

                    ^D:    if altera then
                           begin
                               for i := curx to length (campo) do
                                   campo [i] := ' ';
                               sintSom ('_APFCPO');
                           end;

                    ^S:    if altera then
                           begin
                               nl := length(campo)-curx+1;
                               for i := 1 to nl do
                                   campo [i]:= campo [curx+i-1];
                               for i := nl+1 to length(campo) do
                                   campo [i] := ' ';
                               curx := 1;
                               sintSom ('_APICPO');
                           end;

                    ^U:    if altera then
                                begin
                                    campo := salvaCampo;
                                    curx := 1;
                                    sintBip;
                                    sintBip;
                                    sintBip;
                                end;

                    ^Y:    if altera then
                           begin
                               for i := 1 to length (campo) do
                                   campo [i] := ' ';
                               sintSom ('_CPOAPA');
                               curx := 1;
                           end;

                    ^C:    begin
                               if ctrl_cv_fechaCampo then
                                   goto fechaCampo;
                               c2 := CTLINS;
                               goto processaC2;
                           end;

                    ^V:    begin
                               if ctrl_cv_fechaCampo then
                                   goto fechaCampo;
                               c2 := SHIFTINS;
                               goto processaC2;
                           end;

                    ^\:    for i := 1 to length (campo) do
                               sintTelefona (campo [i]);

                else
                    if primeiraVez and sintApagaAuto then
                        begin
                             temLetras := false;
                             for i := curx to length (campo) do
                                 if campo [i] <> ' ' then
                                     temLetras := true;
                             if temLetras then
                                 begin
                                     sintClek;
                                     sintClek;
                                     if (c >= #$20) and altera then
                                         for i := 1 to length (campo) do
                                             campo [i] := ' ';
                                 end;
                        end;

                    if c >= #$20 then
                        caracComum (c);
                end;
            end;

        primeiraVez := false;
    until false;

fechaCampo:
    sintEditaCampo := c2;
    sintCursorX := curx;
    amplEsconde;

    gotoxy (x, y);
    campoPC := copy (campo, 1, tamVisual);
    write (campoPC);
    gotoxy (x, y);

    curx := tamanho+1;
    repeat
        curx := curx - 1;
    until (curx = 0) or (campo[curx] <> ' ');

    if curx = 0 then
        campo := ''
    else
        campo := copy (campo, 1, curx);

    queueingWaves := false;
    sintPara;
    queueingWaves := saveQwav; 
end;

{--------------------------------------------------------}
{                    edita um item
{--------------------------------------------------------}

function sintEdita (var campo: string; x, y, tamanho: integer;
                     altera: boolean): char;
var
    tamVisual: integer;
begin
    with currentWindow do
        tamVisual := right-(left+x);
    sintEdita := sintEditaCampo (campo, x, y, tamanho, tamVisual, altera);
end;

{--------------------------------------------------------}
{                le uma cadeia ecoando
{--------------------------------------------------------}

procedure sintReadLn (var s: string);
var i: integer;
begin
    s := '';
    if sintEdita (s, wherex, wherey, 255, true) = ESC then
        begin
            gotoxy (wherex, wherey);
            for i := 1 to length (s) do write (' ');
            gotoxy (wherex, wherey);
            s := '';
        end;
    writeln;
end;

{--------------------------------------------------------}
{                le um numero ecoando
{--------------------------------------------------------}

procedure sintReadint (var n: integer);
var 
    erro: integer;
    s: string;
begin
    s := '';
    sintEdita (s, wherex, wherey, 255, true);
    s := trim(s);
    if s <> '' then
        val (s, n, erro);
    writeln;
end;

{--------------------------------------------------------}
{                le um numero real ecoando
{--------------------------------------------------------}

procedure sintReadReal (var n: real);
var
    erro: integer;
    s: string;
begin
    s := '';
    sintEdita (s, wherex, wherey, 255, true);
    s := trim(s);
    if s <> '' then
        val (s, n, erro);
    writeln;
end;

{--------------------------------------------------------}
{                    lê uma senha
{--------------------------------------------------------}

procedure sintSenha (var s: string);
var
    c: char;
begin
    s := '';
    repeat
        c := readkey;
        if c = ENTER then
            break
        else
        if c = ESC then
            begin
                s := '';
                break;
            end
        else
        if c = #$0 then
            begin
                readkey;
                sintBip;
            end
        else
        if c = BS then
            begin
                if s = '' then
                    sintBip
                else
                    begin
                        delete (s, length(s), 1);
                        sintSom ('_DEL');
                        gotoxy (wherex-1, wherey);
                        write (' ');
                        gotoxy (wherex-1, wherey);
                    end;
            end
        else
            begin
                 s := s + c;
                 write ('.');
                 sintSoletra ('.');
            end;
    until false;

    writeln;
end;

var i: integer;
begin
    CoInitialize (NIL);
    falando := true;
    sintFalaPont := true;
    sintNomeArq := '';
    falandoSapi := true;
    sintApagaAuto := true;
    sintAcumulaFala := false;
    sintFalaAcumulada := '';
    sintAceitaLegado := false;

    for i := 0 to TAMCLEK div 4 do
        clek[i] := $80 + random(60);
    for i := TAMCLEK div 4 to TAMCLEK-1 do
        clek[i] := $80;

    sintTipoSapi := 5;
    sintAceitaLegado := true;
end.

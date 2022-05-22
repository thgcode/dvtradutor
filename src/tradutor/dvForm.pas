{--------------------------------------------------------}
{
{    Tratamento padronizado de formulários
{
{    Autor: Jose' Antonio Borges
{
{    Adendos de Julio Tadeu C. da Silveira
{
{    Original em agosto/2001
{
{    Versão atual em 13/08/2015
{
{--------------------------------------------------------}

Unit dvform;

interface
uses
    windows, classes, sysUtils,
    dvcrt, dvwin, dvmidi, dvAmplia, videovox;

{--- formulários ---}

procedure formCria;
procedure formCampo (nomeArqSom: string; nome: string;
                     var valor: shortstring; tamanho: integer);
procedure formCampoLong (nomeArqSom: string; nome: string; var valor: longint);
procedure formCampoInt (nomeArqSom: string; nome: string; var valor: integer);
procedure formCampoReal (nomeArqSom: string; nome: string; var valor: real; ncasas: integer);
procedure formCampoBool (nomeArqSom: string; nome: string; var valor: boolean);
procedure formCampoLista (nomeArqSom: string; nome: string;
                          var valor: shortString;
                          tamanho: integer; listaSepBarraVert: string);
function formEdita (alterando: boolean): char;

{--- lista de opções (respeite o tamanho da tela) ---}

procedure opcoesCria (x, y, tam: integer);
procedure opcoesAdiciona (nomeArqSom: string; nome: string);
function opcoesSelecInic (opcaoInicial: integer): integer;
function opcoesSeleciona: integer;
procedure opcoesOrdena;

{--- popup menu (respeite o tamanho da tela) ---}

procedure popupMenuCria (x, y, tam, nopcoesTela, corFundo: integer);
procedure popupMenuAdiciona (nomeArqSom: string; nome: string);
function popupMenuSeleciona: integer;
procedure popupMenuOrdena;

{--- uso típico: SNT (sim, não, todos)  ---}

function popupMenuPorLetra (letras: string): char;

{--- folheamento: permite número grande de itens e edição dinâmica ---}

procedure folheiaCria (xmin, ymin, xmax, ymax: integer);
procedure folheiaDestroi;
procedure folheiaAltera (nItem: integer; novoItem: string);
procedure folheiaAlteraAtribs (nItem: integer;
          novoItem: string;  estaSelecionado: boolean; oQueFalar: string);
procedure folheiaInsere (nItem: integer; novoItem: string);
procedure folheiaAdiciona (novoItem: string);
procedure folheiaAdicionaEspecial (novoItem: string; estaSelecionado: boolean; oQueFalar: string);
procedure folheiaSeleciona (nItem: integer; sel: boolean);
function folheiaExecuta (itemInic: integer;
          var nItem: integer; var c1, c2: char; falaPrimeiroItem: boolean): boolean;
procedure folheiaRemoveItem (nItem: integer);
procedure folheiaObtemItem (nItem: integer;
          var item: string; var selec: boolean);
function folheiaNumItens: integer;
function folheiaNumSelec (var primeiroSelec: integer): integer;
procedure folheiaLimpa;
procedure folheiaCorDoMeio (xmin, xmax, cor: integer);
procedure folheiaPreview (itemInic: integer);


{--- evita que um formulário seja colocado fora da tela ---}

procedure garanteEspacoTela (nlinhas: integer);

{--- memória para usar em comandos repetitivos ---}

procedure insereNosUltimosComandos (comando: string; secao, item: string);
function pegaUltimosComandos (var comando: string; secao, item: string;
                              inserindo: boolean = true): char;
{--- clear to end of screen ---}

procedure limpaBaixo (y: integer);

{--- rotina de feedback de progresso ---}

procedure inicializaProgresso (quantosPontos, tPontos, tSons: integer;
                               fazClek: boolean; instrMIDI: integer);  // marimba
function mostraProgresso (acumulado, total: Int64): boolean;
procedure finalizaProgresso;

type
     TFolheiaPreencheItemOnline = procedure
                (nItem: integer; var conteudo, fala: string; var selec: boolean);
var
     FolheiaPreencheItemOnline: TFolheiaPreencheItemOnline = NIL;

var
    tamRotulosForm: integer;
    opcoesItemSelecionado: string;

implementation

const
    brancos = '                                                                                 ';

type
    TIPOSCAMPO = (TIPOSTR, TIPOINT, TIPOLONG, TIPOBOOL, TIPOREAL);

    PCampo = ^Tcampo;
    TCampo = record
        somCampo: string;
        nomeCampo: string;
        valorCampo: string;
        opcoesValorCampo: string;
        tamanhoCampo: integer;
        tipoCampo: TIPOSCAMPO;
        case TIPOSCAMPO of
            TIPOSTR:   (ps: ^shortString);
            TIPOLONG:  (pl: ^integer);
            TIPOINT:   (pi: ^longint);
            TIPOBOOL:  (pb: ^boolean);
            TIPOREAL:  (pr: ^real);
    end;

    POpcoes = ^TOpcoes;
    TOpcoes = record
        numInicial: integer;
        somOpcao: string;
        nomeOpcao: string;
    end;

var
    ncampos: integer;
    campos: array [1..200] of PCampo;
    yform: integer;

    nopcoes: integer;
    tamOpcoes: integer;
    xopcoes, yopcoes, yvis: integer;
    opcoes: array of POpcoes;

    salvaCor: word;
    psaveScreenChar, psaveScreenAttrib: pchar;
    xmenu, ymenu, xantMenu, yantMenu: integer;
    xmaxMenu, ymaxMenu: integer;

    listaFol, aFalar: TStringList;
    selecionado: packed array [0..60000] of boolean;
    itemFolheado: integer;
    primItemTela, nItensTela: integer;
    xfolMin, xfolMax, yfolMin, yfolMax: integer;
    xmeioMin, xmeioMax, corMeio: integer;

{--------------------------------------------------------}
{       cria o formulário
{--------------------------------------------------------}

procedure formCria;
begin
    ncampos := 0;
    yform := wherey;
end;

{--------------------------------------------------------}
{       insere um campo string
{--------------------------------------------------------}

procedure formCampo (nomeArqSom: string; nome: string;
                     var valor: shortstring; tamanho: integer);
begin
    ncampos := ncampos + 1;

    new (campos [ncampos]);
    with campos [ncampos]^ do
        begin
            somCampo := nomeArqSom;
            nomeCampo := nome;
            valorCampo := valor;
            opcoesValorCampo := '';
            ps := @valor;
            tamanhoCampo := tamanho;
            tipoCampo := TIPOSTR;
        end;
end;

{--------------------------------------------------------}
{       insere um campo inteiro
{--------------------------------------------------------}

procedure formCampoInt (nomeArqSom: string; nome: string; var valor: integer);
var valorTrab: shortString;
begin
    str (valor, valorTrab);
    formCampo (nomeArqSom, nome, valorTrab, 10);

    with campos [ncampos]^ do
        begin
            tipoCampo := TIPOINT;
            pi := @valor;
        end;
end;

{--------------------------------------------------------}
{       insere um campo inteiro
{--------------------------------------------------------}

procedure formCampoReal (nomeArqSom: string; nome: string; var valor: real; ncasas: integer);
var valorTrab: shortString;
begin
    str (valor:0:ncasas, valorTrab);
    formCampo (nomeArqSom, nome, valorTrab, 10);

    with campos [ncampos]^ do
        begin
            tipoCampo := TIPOREAL;
            pr := @valor;
        end;
end;

{--------------------------------------------------------}
{       insere um campo inteiro
{--------------------------------------------------------}

procedure formCampoLong (nomeArqSom: string; nome: string; var valor: longint);
var valorTrab: shortString;
begin
    str (valor, valorTrab);
    formCampo (nomeArqSom, nome, valorTrab, 20);

    with campos [ncampos]^ do
        begin
            tipoCampo := TIPOLONG;
            pi := @valor;
        end;
end;

{--------------------------------------------------------}
{       insere um campo booleano
{--------------------------------------------------------}

procedure formCampoBool (nomeArqSom: string; nome: string; var valor: boolean);
var valorTrab: shortString;
begin
    if valor then
        valorTrab := 'SIM'
    else
        valorTrab := 'NÃO';
    formCampo (nomeArqSom, nome, valorTrab, 10);
    campos [ncampos].opcoesValorCampo := 'SIM|NÃO';

    campos [ncampos].tipoCampo := TIPOBOOL;
    campos [ncampos].pb := @valor;
end;

{--------------------------------------------------------}
{       insere um campo lista
{--------------------------------------------------------}

procedure formCampoLista (nomeArqSom: string; nome: string;
                          var valor: shortString;
                          tamanho: integer; listaSepBarraVert: string);
begin
    formCampo (nomeArqSom, nome, valor, tamanho);
    campos [ncampos].opcoesValorCampo := listaSepBarraVert;
end;

{--------------------------------------------------------}
{   garante a existência de espaço livre para os campos
{--------------------------------------------------------}

procedure garanteEspacoTela (nlinhas: integer);
var x, i: integer;
begin
    x := wherex;
    for i := 1 to nlinhas do writeln;
    gotoxy (x, wherey-nlinhas);
end;

{--------------------------------------------------------}
{       altera campo por menu
{--------------------------------------------------------}

function alteraPorMenu (qualCampo: integer; valor: string): string;
var x, y: integer;
    nopc: integer;
    ov: string;
    p, larg: integer;
begin
    ov := campos[qualCampo]^.opcoesValorCampo;
    if ov <> '' then
        begin
            nopc := 0;
            larg := 1;
            ov := ov + '|';
            while ov <> '' do
                 begin
                     nopc := nopc + 1;
                     p := pos ('|', ov);
                     if p > larg then larg := p - 1;
                     delete (ov, 1, p);
                 end;

            x := wherex;
            y := wherey;
            if nopc > screenSize.y   then  nopc := screenSize.y;
            if y+nopc > screenSize.y then  y := screenSize.y-nopc+1;

            popupMenuCria(x, y, larg, nopc, MAGENTA);
            ov := campos[qualCampo]^.opcoesValorCampo + '|';
            while ov <> '' do
                 begin
                     p := pos ('|', ov);
                     popupMenuAdiciona('', copy (ov, 1, p-1));
                     delete (ov, 1, p);
                 end;

            if popupMenuSeleciona > 0 then
                valor := opcoesItemSelecionado;
        end;

     result := valor;
end;

{--------------------------------------------------------}
{       edita os campos
{--------------------------------------------------------}

function formEdita (alterando: boolean): char;
var qualCampo: integer;
    acabou: boolean;
    tamVisual: integer;
    c: char;
    i, erro: integer;
    salvaCor: integer;
    x: integer;
    deslocVisib, maxDesloc: integer;

    procedure redesenhaCampos;
    var i, y: integer;
    begin
        for i := 1 to ncampos do
            begin
                y := i + yform - 1 - deslocVisib;
                if (y < yform) or (y > screenSize.y) then continue;

                with campos [i]^ do
                    begin
                         tamVisual := tamanhoCampo;
                         if tamVisual+tamRotulosForm >= 80 then
                              tamVisual := 79-tamRotulosForm;
                         salvaCor := textAttr;

                         textBackground (RED);
                         gotoxy (1, yform+i-1 - deslocVisib);
                         write (nomeCampo+' ': tamRotulosForm);
                         textBackground (BLACK);
                         write (copy (valorCampo+brancos, 1, tamVisual));
			 clreol;

                         textAttr := salvaCor;
                    end;
            end;
    end;

label movimentos;
begin
    qualcampo := 1;
    deslocVisib := 0;
    maxDesloc := nCampos - (screensize.y-yform)-1;
    acabou := false;
    redesenhaCampos;
    while keypressed do readkey;

    repeat
        if qualCampo < 1 then
             begin
                 gotoxy (1, yform);
                 sintBip;
                 c := readkey;
                 if c = #0 then c := readkey;
                 goto movimentos;
             end
        else
        if qualCampo > nCampos then
             begin
                 gotoxy (1, yform+ncampos-1 - deslocVisib);
                 sintBip;
                 c := readkey;
                 if c = #0 then c := readkey;
                 goto movimentos;
             end
        else
        with campos [qualCampo]^ do
            begin
                 tamVisual := tamanhoCampo;
                 if tamVisual+tamRotulosForm >= 80 then
                      tamVisual := 79-tamRotulosForm;
                 salvaCor := textAttr;

                 textBackground (RED);
                 gotoxy (1, yform+qualCampo-1 - deslocVisib);
                 write (nomeCampo+' ': tamRotulosForm);
                 textBackground (BLACK);
                 textColor (YELLOW);
                 write (copy (valorCampo+brancos, 1, tamVisual));

                 if existeArqSom (somCampo) then
                     sintSom (somCampo)
                 else
                     sintetiza (nomeCampo);

                 while sintFalando do waitMessage;
                 sintetiza (valorCampo);

                 c := sintEditaCampo  (valorCampo, tamRotulosForm+1, yform+qualCampo-1 - deslocVisib,
                      tamanhoCampo, tamVisual, alterando);

                 if c = F9 then
                     valorCampo := alteraPorMenu (qualCampo, valorCampo);

                 textColor (salvaCor);
                 gotoxy (tamRotulosForm+1, yform+qualCampo-1 - deslocVisib);
                 write (copy (valorCampo+brancos, 1, tamVisual));
            end;

movimentos:
        case c of
            CIMA:              qualCampo := qualCampo - 1;
            BAIX, TAB, ENTER:  qualCampo := qualCampo + 1;
            CTLUP:             qualCampo := 1;
            CTLDOWN:           qualCampo := ncampos;
            PGUP, PGDN, ESC:   acabou := true;
        end;

        if qualCampo < 1 then
            qualCampo := 0;
        if qualCampo > ncampos then
            qualCampo := ncampos+1;

        while qualcampo+yform-1-deslocVisib > screensize.y do
            begin
                if deslocVisib >= maxDesloc then break;
                deslocvisib := deslocVisib + 1;
                redesenhaCampos;
            end;

        while qualcampo+yform-1-deslocVisib < yform do
            begin
                if deslocVisib = 0 then break;
                deslocvisib := deslocVisib - 1;
                redesenhaCampos;
            end;

    until acabou;
    formEdita := c;

    for i := 1 to ncampos do
        with campos [i]^ do
            begin
                if tipoCampo <> TIPOSTR then
                    valorCampo := trim (valorCampo);

                case tipoCampo of
                    TIPOSTR:  ps^ := valorCampo;
                    TIPOINT:  val (valorCampo, pi^, erro);
                    TIPOREAL: begin
                                  x := pos (',', valorCampo);
                                  if x <> 0 then
                                      valorCampo := copy (valorCampo, 1, x-1) + '.' +
                                                    copy (valorcampo, x+1, 999);
                                  val (valorCampo, pr^, erro);
                              end;
                    TIPOBOOL: if valorCampo <> '' then
                                  pb^ := copy (maiuscAnsi(valorCampo), 1, 1) <> 'N';
                end;
            end;

    gotoxy (1, yform+ncampos - deslocVisib);
    for i := 1 to ncampos do
        dispose (campos[i]);
end;

{--------------------------------------------------------}
{       cria as opcoes
{--------------------------------------------------------}

procedure opcoesCria (x, y, tam: integer);
begin
   xOpcoes := x;
   yOpcoes := y;
   if yOpcoes < 1 then yOpcoes := 1;
   tamOpcoes := tam;
   yvis := 1;
   nopcoes := 0;
   setLength (opcoes, 1);    // o primeiro elemento não será usado
   new(opcoes[0]);
   opcoes[0].nomeOpcao := '';
end;

{--------------------------------------------------------}
{       adiciona uma opcão
{--------------------------------------------------------}

procedure opcoesAdiciona (nomeArqSom: string; nome: string);
begin
    nopcoes := nopcoes + 1;

    if length (opcoes) < nopcoes+1 then
        setLength (opcoes, length(opcoes) + 100);

    new (opcoes[nopcoes]);
    with opcoes[nopcoes]^ do
        begin
            numInicial := nopcoes;
            nomeOpcao := nome;
            somOpcao := nomeArqSom;
        end;
end;

{--------------------------------------------------------}
{       seleciona uma opcao
{--------------------------------------------------------}

function opcoesSelecInic (opcaoInicial: integer): integer;
var qualOpcao: integer;
    acabou, achou: boolean;
    c, c2: char;
    s: string;
    i: integer;
label jaFala;

    procedure mostraTodasOpcoes;
    var y, yt: integer;
    begin
        for y := 1 to nOpcoes do
            begin
                yt := yOpcoes+y-yvis;
                if yt < yopcoes then continue;
                if yt > screensize.y then exit;
                gotoxy (xopcoes, yt);
                textColor (WHITE);
                write (copy (opcoes[y]^.nomeOpcao+brancos, 1, tamOpcoes));
            end;
    end;

    procedure checaAreaVisivel;
    var novoyvis, y, yt: integer;
    begin
        novoyvis := yvis;
        if (qualOpcao >= 1) and (qualOpcao < yvis) then
            novoyvis := qualOpcao
        else
            while yOpcoes+qualOpcao-novoyvis > screensize.y do
                novoyvis := novoyvis + 1;
        if yvis = novoyvis then exit;

        yvis := novoyvis;
        for y := 1 to nOpcoes do
            begin
                yt := yOpcoes+y-yvis;
                if yt < yOpcoes then continue;
                if yt > screensize.y then continue;
                gotoxy (xopcoes, yt);
                textColor (WHITE);
                write (copy (opcoes[y]^.nomeOpcao+brancos, 1, tamOpcoes));
            end;
    end;

begin
    opcoesItemSelecionado := '';
    qualOpcao := opcaoInicial;
    acabou := false;
    c := ' ';
    c2 := ' ';
    mostraTodasOpcoes;
    checaAreaVisivel;
    if qualOpcao <> 0 then goto jaFala;

    repeat
        c := readkey;
        c2 := ' ';
        sintPara;
        if c = #$0 then c2 := readkey;
jaFala:
        gotoxy (xOpcoes, yOpcoes+qualOpcao-yvis);
        if (qualOpcao >= 1) and (qualOpcao <= nOpcoes) then
            begin
                textColor (WHITE);
                write (opcoes[qualOpcao]^.nomeOpcao);
            end;

        case c of
            ESC, ENTER:       acabou := true;
            NOFOCUS:          while not keypressed do waitMessage;
            #0:
                case c2 of
                    CTLF9:      if getKeyState (vk_Menu) < 0 then leitorDeTela;
                    CIMA:       qualOpcao := qualOpcao - 1;
                    BAIX, TAB:  qualOpcao := qualOpcao + 1;
                    HOME, CTLPGUP:     qualOpcao := 1;
                    TEND, CTLPGDN:     qualOpcao := nOpcoes;
                    PGUP:       qualOpcao := qualOpcao - 10;
                    PGDN:       qualOpcao := qualOpcao + 10;
                end
        else
            if upcase(c) in ['0'..'9', 'A'..'Z', ^A..^Z, '+', '-', '*', '/'] then
                begin
                     if qualOpcao > nOpcoes then qualOpcao := 0;
                     repeat
                         qualOpcao := qualOpcao + 1;
                         achou := qualOpcao > nOpcoes;
                         if not achou then
                             begin
                                 s := opcoes[qualOpcao]^.nomeOpcao;
                                 while (s <> '') and (s[1] = ' ') do delete (s, 1, 1);
                                 achou := (s <> '') and (upcase (s[1]) = upcase(c));
                             end;
                     until achou;
                end;
        end;

        if qualOpcao <= 0 then
            begin
                qualOpcao := 1;
                sintBip;
            end
        else
        if qualOpcao > nOpcoes then
            begin
                qualOpcao := nopcoes;
                sintBip;
            end;

        if (c <> ESC) and (c <> ENTER) then
        with opcoes[qualOpcao]^ do
            begin
                 checaAreaVisivel;

                 gotoxy (xOpcoes, yOpcoes+qualOpcao-yvis);
                 textColor (YELLOW);
                 write (nomeOpcao);
                 gotoxy (xOpcoes, yOpcoes+qualOpcao-yvis);

                 amplCampo(nomeOpcao, 0);

                 if c2 = DIR then
                     sintSoletra (nomeOpcao)
                 else
                     if existeArqSom (somOpcao) then
                         sintSom (somOpcao)
                     else
                         begin
                             if (length(somOpcao) > 1) and
                                (somOpcao[2] = '|') and
                                (existeArqSom(copy (somOpcao, 3, 99))) then
                                    begin
                                        sintSoletra (somOpcao[1]);
                                        sintSom (copy (somOpcao, 3, 99));
                                    end
                             else
                                    sintetiza (nomeOpcao);
                         end;
            end;

    until acabou;

    if (qualOpcao < 1) or (qualOpcao > nOpcoes) or (c = ESC) then
        begin
            opcoesSelecInic := 0;
            opcoesItemSelecionado := '';
        end
    else
        begin
            gotoxy (xOpcoes, yOpcoes+qualOpcao-yvis);
            textColor (YELLOW);
            write (opcoes[qualOpcao]^.nomeOpcao);
            textColor (WHITE);

            opcoesSelecInic := opcoes[qualOpcao]^.numInicial;
            opcoesItemSelecionado := opcoes[qualOpcao]^.nomeOpcao;
        end;

    if yopcoes+nopcoes > screensize.y then
        gotoxy (1, screensize.y)
    else
        gotoxy (1, yopcoes+nopcoes);

    for i := 1 to nopcoes do
        dispose (opcoes[i]);
end;

{--------------------------------------------------------}
{                 ordena as opcoes
{--------------------------------------------------------}

Procedure opcoesOrdena;   // shellsort
Var
    i, j, step: Integer;
    tmp: POpcoes;
    tmps: string;

begin  // nota: opcoes[0] não contém nada
    step := nopcoes div 2;
    while step > 0 do
        begin
            for i:=step to nopcoes do
                begin
                    tmp := opcoes[i];
                    tmps := maiuscAnsi(semAcentos(tmp^.nomeOpcao));
                    j := i;
                    while (j>=step) and (maiuscAnsi(semAcentos(opcoes[j-step]^.nomeOpcao))>tmps) Do
                        begin
                            opcoes[j] := opcoes[j-step];
                            dec(j, step);
                        end;
                   opcoes[j]:=tmp;
                end;
            step:=step div 2;
        end;
end;

{--------------------------------------------------------}
{       seleciona a partir da opção zero
{--------------------------------------------------------}

function opcoesSeleciona: integer;
begin
    opcoesSeleciona := opcoesSelecInic (0);
end;

{--------------------------------------------------------}
{       cria um popup menu
{--------------------------------------------------------}

procedure popupMenuCria (x, y, tam, nopcoesTela, corFundo: integer);
var i, xx, yy: integer;
begin
    xantMenu := wherex;
    yantMenu := wherey;
    if x+tam     > 80 then x := 80-tam;
    if y+nopcoesTela > screensize.y then y := screensize.y-nopcoesTela+1;
    if y < 1 then y := 1;

    xmenu := x;
    ymenu := y;

    salvaCor := textAttr;
    textBackground (corFundo);
    opcoesCria (x, y, tam);

    xmaxMenu := x+tam-1;
    ymaxMenu := y+nopcoesTela-1;
    if ymaxMenu > screensize.y then ymaxMenu := screensize.y;

    getmem (psaveScreenChar,   (xmaxMenu-xmenu+1) * (ymaxMenu-ymenu+1));
    getmem (psaveScreenAttrib, (xmaxMenu-xmenu+1) * (ymaxMenu-ymenu+1));

    i := 0;
    for yy := ymenu to ymaxMenu do
        for xx := xmenu to xmaxMenu do
            begin
                 psaveScreenChar[i]   := getScreenChar (xx, yy);
                 psaveScreenAttrib[i] := chr (getScreenAttrib (xx, yy));
                 i := i + 1;
            end;
end;

{--------------------------------------------------------}
{       adiciona uma opção de popup menu
{--------------------------------------------------------}

procedure popupMenuAdiciona (nomeArqSom: string; nome: string);
begin
    opcoesAdiciona (nomeArqSom, nome);
end;

{--------------------------------------------------------}
{             ordena as opcoes do menu
{--------------------------------------------------------}

procedure popupMenuOrdena;
begin
    opcoesOrdena;
end;


{--------------------------------------------------------}
{         popupMenu com texto e letras das opçoes
{--------------------------------------------------------}

function popupMenuPorLetra (letras: string): char;
var
    escolhida: integer;
    c1, c2: char;
    i: integer;
    nomeSom: string;
    tamanho: integer;
    letra: char;
begin
    sintLeTecla (c1, c2);
    if c1 <> #0 then
        begin
            writeln;
            result := upcase(c1);
            exit;
        end;

    garanteEspacoTela(length(letras));

    tamanho := 1;
    for i := 1 to length(letras) do
         if ord(letras[i]) < 32 then
             begin
                 tamanho := 6;
                 break;
             end;

    popupMenuCria(wherex,wherey,tamanho, length(letras),RED);

    for i := 1 to length(letras) do
       begin
            if ord(letras[i]) < 32 then {controls}
                begin
                    letra := chr(ord('@') + ord(letras[i]));
                    nomeSom := '_' + intToStr(ord(letras[i]));
                    popupMenuAdiciona(nomeSom, 'Ctrl-' + letra);
                end
            else
                begin
                    nomeSom := '_' + intToStr(ord(letras[i]));
                    popupMenuAdiciona(nomeSom, letras[i]);
                end;
       end;

    escolhida := popupMenuSeleciona;
    if escolhida <= 0 then
        begin
            result := ESC;
            writeln;
        end
    else
        begin
            result := letras[escolhida];
            writeln (letras[escolhida]);
        end;
end;

{--------------------------------------------------------}
{       seleciona uma opcao de popup menu, ao fim apaga
{--------------------------------------------------------}

function popupMenuSeleciona: integer;
var i, x, y, xx, yy: integer;
    cor, ultCor: word;
    s: string [80];
begin
    popupMenuSeleciona := opcoesSelecInic (1);

    x := xmenu;
    y := ymenu;

    ultCor := 255;
    i := 0;
    for yy := y to ymaxMenu do
        begin
            gotoxy (x, yy);
            s := '';
            for xx := x to xmaxMenu do
                begin
                     cor := word(psaveScreenAttrib[i]);
                     if cor <> ultCor then
                         begin
                             if s <> '' then write (s);
                             s := '';
                             ultCor := cor;
                             textColor (cor and $f);
                             textBackground (cor shr 4);
                         end;
                     s := s + psaveScreenChar[i];
                     i := i + 1;
                end;
            if s <> '' then write (s);
            s := '';
        end;

    freemem (psaveScreenChar,   (xmaxMenu-xmenu+1) * (ymaxMenu-ymenu+1));
    freemem (psaveScreenAttrib, (xmaxMenu-xmenu+1) * (ymaxMenu-ymenu+1));

    textAttr := salvaCor;
    gotoxy (xantMenu, yAntMenu);
    amplEsconde;
end;

{--------------------------------------------------------}
{       cria o folheamento
{--------------------------------------------------------}

procedure folheiaCria (xmin, ymin, xmax, ymax: integer);
begin
    listaFol := TStringList.Create;
    aFalar := TStringList.Create;
    xfolMin := xmin;
    xfolMax := xmax;
    yfolMin := ymin;
    yfolMax := ymax;
    itemFolheado := 0;
    primItemTela := 0;
    nItensTela := ymax - ymin + 1;
    xmeioMin := 0;
    xmeioMax := 0;
    corMeio := WHITE;
end;

{--------------------------------------------------------}
{       destrói o folheamento
{--------------------------------------------------------}

procedure folheiaDestroi;
begin
    if listaFol <> NIL then
        begin
            listaFol.Destroy;
            aFalar.Destroy;
        end;
    listaFol := NIL;
end;

{--------------------------------------------------------}
{       obtem um item do folheamento
{--------------------------------------------------------}

procedure folheiaObtemItem (nItem: integer;
          var item: string; var selec: boolean);
begin
    nItem := nItem - 1;
    if (nItem < 0) or (nitem >= listaFol.Count) then
        begin
            item := '';
            selec := false;
        end
    else
        begin
            item := listaFol[nItem];
            selec := selecionado[nItem];
        end;
end;

{--------------------------------------------------------}
{           altera um item no folheamento
{--------------------------------------------------------}

procedure folheiaAltera (nItem: integer; novoItem: string);
begin
    listaFol[nItem-1] := novoItem;
    aFalar[nItem-1] := novoItem;
end;

{--------------------------------------------------------}
{             altera atributos de um item
{--------------------------------------------------------}

procedure folheiaAlteraAtribs (nItem: integer;
          novoItem: string;  estaSelecionado: boolean; oQueFalar: string);
begin
    listaFol[nItem-1] := novoItem;
    aFalar[nItem-1] := oQueFalar;
    selecionado[nitem-1] := estaSelecionado;
end;

{--------------------------------------------------------}
{           insere um item no folheamento
{--------------------------------------------------------}

procedure folheiaInsere (nItem: integer; novoItem: string);
begin
    listaFol.insert (nItem-1, novoItem);
    aFalar.insert (nItem-1, novoItem);
    selecionado[nItem-1] := false;
end;

{--------------------------------------------------------}
{       adiciona um item do folheamento ao final
{--------------------------------------------------------}

procedure folheiaAdiciona (novoItem: string);
begin
    listaFol.add (novoItem);
    aFalar.add (novoItem);
    selecionado[listaFol.count-1] := false;
end;

{--------------------------------------------------------}
{    adiciona um item do folheamento com parâmetros
{--------------------------------------------------------}

procedure folheiaAdicionaEspecial (novoItem: string;
          estaSelecionado: boolean; oQueFalar: string);
begin
    listaFol.add (novoItem);
    aFalar.add (oQueFalar);
    selecionado[listaFol.count-1] := estaSelecionado;
end;

{--------------------------------------------------------}
{       seleciona um item do folheamento
{--------------------------------------------------------}

procedure folheiaSeleciona (nItem: integer; sel: boolean);
begin
    selecionado[nItem-1] := sel;
end;

{--------------------------------------------------------}
{       preenche a tela com o folheamento
{--------------------------------------------------------}

procedure folheiaExibe (falando: boolean);
var i, y: integer;
    oQueFalar, s: string;
    bipa: boolean;
    cor: integer;

    procedure trataItensOnline;
    var
        oQueFalar, s: string;
        selec: boolean;
    begin
        if @folheiaPreencheItemOnline <> NIL then
            if (i >= 0) and (i < listaFol.count) then
                begin
                    s := listaFol[i];
                    oQueFalar := afalar[i];
                    selec := selecionado[i];
                    folheiaPreencheItemOnline (i+1, s, oQueFalar, selec);
                        // externamente as estruturas são indexadas a partir de 1
                    listaFol[i] := s;
                    afalar[i] := oQueFalar;
                    selecionado[i] := selec;
                end;
    end;

begin
    oQueFalar := '';
    bipa := false;
    y := yfolMin;
    for i := primItemTela to primItemTela+nItensTela-1 do
        begin
            trataItensOnline;

            if i < listaFol.Count then
                s := copy (listaFol[i]+brancos, 1, xfolMax-xfolMin+1)
            else
                s := copy (brancos, 1, xfolMax-xfolMin+1);

            if i = itemFolheado then
                begin
                     y := yfolMin+i-primItemTela;
                     cor := yellow;
                     if itemFolheado < aFalar.Count then
                         begin
                             oQueFalar := aFalar[itemFolheado];
                             bipa := selecionado[i];
                         end;
                end
            else
                if selecionado[i] then
                    cor := green
                else
                    cor := salvaCor and $f;

            gotoxy (xfolMin, yfolMin+i-primItemTela);
            textcolor (cor);
            if xmeioMax > 0 then
                begin
                    write (copy (s, 1, xMeioMin-1));
                    textcolor (corMeio);
                    write (copy (s, xMeioMin, xMeioMax-xMeioMin+1));
                    textcolor (cor);
                    write (copy (s, XMeioMax+1, 999));
                end
            else
                write (s);
        end;

    if falando then
        begin
            if bipa then sintBip;
            amplCampo(oQueFalar, 1);
            sintetiza (oQueFalar);
        end;
    gotoxy (xfolMin, y);
end;

{--------------------------------------------------------}
{       exibe o folheamento sem processar
{--------------------------------------------------------}

procedure folheiaPreview (itemInic: integer);
begin
    salvaCor := textAttr;
    itemFolheado := itemInic-1;

    if itemFolheado < primItemTela then
        primItemTela := itemFolheado
    else
    if itemFolheado >= primItemTela+nItensTela then
        primItemTela := itemFolheado-nItensTela+1;

    if itemFolheado < 0 then itemFolheado := -1;
    if primItemTela < 0 then primItemTela := 0;

    folheiaExibe (false);
    textAttr := salvaCor;
end;

{--------------------------------------------------------}
{       remove um item do folheamento
{--------------------------------------------------------}

procedure folheiaRemoveItem (nItem: integer);
var i: integer;
begin
    nItem := nItem - 1;
    if nItem < 0 then exit;
    if nItem > listaFol.Count then exit;

    for i := nItem to listaFol.Count-2 do
        selecionado[i] := selecionado[i+1];
    listaFol.Delete(nItem);
    aFalar.Delete(nItem);

    folheiaExibe (false);
end;

{--------------------------------------------------------}
{       executa o folheamento
{--------------------------------------------------------}

function folheiaExecuta (itemInic: integer;
          var nItem: integer; var c1, c2: char; falaPrimeiroItem: boolean): boolean;

var folheando, itemValido: boolean;
    i: integer;
    podeFalar: boolean;

begin
    salvaCor := TextAttr;
    itemFolheado := itemInic-1;    { a estrutura interna indexa a partir de zero }

    folheando := true;
    podeFalar := falaPrimeiroItem;
    while folheando do
        begin
            if itemFolheado < primItemTela then
                primItemTela := itemFolheado
            else
                if itemFolheado >= primItemTela+nItensTela then
                     primItemTela := itemFolheado-nItensTela+1;

            if itemFolheado < 0 then itemFolheado := -1;
            if primItemTela < 0 then primItemTela := 0;

            folheiaExibe (podeFalar);
            podeFalar := true;
            itemValido := (itemFolheado >= 0) and (itemFolheado < listaFol.count);

            c2 := #$0;
            c1 := readkey;
            if c1 <> #0 then
                 begin
                     case c1 of
                        ' ':  if itemValido then selecionado [itemFolheado] := not selecionado [itemFolheado];
                        '+':  if itemValido then selecionado [itemFolheado] := true;
                        '-':  if itemValido then selecionado [itemFolheado] := false;
                        '*':  for i := 0 to listaFol.count-1 do
                                  selecionado [i] := true;
                        '/':  for i := 0 to listaFol.count-1 do
                                  selecionado [i] := false;
                     else
                         folheando := false;
                     end
                 end
            else
                 begin
                      c2 := readkey;
                      sintPara;
                      case c2 of
                          DIR, ESQ,
                          CTLF1..CTLF8,
                          CTLF10..CTLF12,
                          F1..F12:    folheando := false;
                          CTLF9:
                             if getKeyState (vk_Menu) < 0 then
                                 leitorDeTela
                             else
                                 folheando := false;
                          CIMA:       itemFolheado := itemFolheado - 1;
                          BAIX, TAB:  itemFolheado := itemFolheado + 1;

                          HOME, CTLPGUP:    begin
                                                sintBip;
                                                itemFolheado := 0;
                                            end;

                          TEND, CTLPGDN:    begin
                                                sintBip;
                                                itemFolheado := listaFol.count-1;
                                            end;
                          PGUP:       itemFolheado := itemFolheado - 10;
                          PGDN:       itemFolheado := itemFolheado + 10;
                      end;

                      if itemFolheado < 0 then
                          begin
                               itemFolheado := -1;
                               sintBip;
                          end;

                      if itemFolheado >= listaFol.Count then
                          begin
                               itemFolheado := listaFol.Count;
                               sintBip;
                          end;
                 end;
        end;

    textAttr := salvaCor;
    nitem := itemFolheado+1;
    folheiaExecuta := (nitem >= 1) and (nitem <= listaFol.Count);
    amplEsconde;
end;

{--------------------------------------------------------}
{       limpa a área do folheamento
{--------------------------------------------------------}

procedure folheiaLimpa;
var y: integer;
    s: string;
begin
    s := copy (brancos, 1, xfolMax-xfolMin+1);
    for y := yfolMin to yFolMax do
         begin
             gotoxy (xfolMin, y);
             write (s);
         end;
    gotoxy (xfolMin, yfolMin);
end;

{--------------------------------------------------------}
{       ve quantos itens tem no folheamento
{--------------------------------------------------------}

function folheiaNumItens: integer;
begin
    folheiaNumItens := listaFol.count;
end;

{--------------------------------------------------------}
{ Retorna quantos itens selecionados e o primeiro deles.
{--------------------------------------------------------}

function folheiaNumSelec (var primeiroSelec: integer): integer;
var
    i: integer;
    dummy: string;
    sel: boolean;
begin
    result := 0;
    for i := folheiaNumItens downto 1 do
    begin
        folheiaObtemItem(i, dummy, sel);
        if sel then
        begin
            inc (result);
            primeiroSelec := i;
        end;
    end;
end;

{--------------------------------------------------------}
{       ve quantos itens tem no folheamento
{--------------------------------------------------------}

procedure folheiaCorDoMeio (xmin, xmax, cor: integer);
begin
    xmeioMin := xmin;
    xmeioMax := xmax;
    corMeio := cor;
end;

{--------------------------------------------------------}
{        agrega novo comando aos últimos registrados
{--------------------------------------------------------}

procedure insereNosUltimosComandos (comando: string; secao, item: string);
var sl: TStringList;
    i, max: integer;
    s, chave: string;
begin
    if comando = '' then
        exit;

    sl := TStringList.Create;

    sl.Clear;
    for i := 0 to 9 do
         begin
             s := sintAmbiente (secao, item+intToStr(i));
             if comando <> s then
                 sl.add(s);
         end;

    sl.Insert(0, comando);
    max := 9;
    if max > sl.count-1 then
        max := sl.count-1;

    for i := 0 to max do
         begin
             chave := item + intToStr (i);
             s := sl[i];
             if s = '' then
                 sintRemoveAmbiente(secao, chave)
             else
                 sintGravaAmbiente (secao, chave, s);
        end;

    sl.Free;
end;

{--------------------------------------------------------}
{       recupera um dos últimos comandos dados
{--------------------------------------------------------}

function pegaUltimosComandos (var comando: string; secao, item: string;
                              inserindo: boolean = true): char;
var sl: TStringList;
    i: integer;
    s: string;
    c: char;
    x, y: integer;
begin
    if (secao = '') or (item = '') then
        begin
             pegaUltimosComandos := ESC;
             exit;
        end;

    sl := TStringList.Create;

    repeat
        c := sintEditaCampo (comando, wherex, wherey, 255, 80, true);

        if c = ESC then
            comando := ''

        else
        if (c = CIMA) or (c = BAIX) then
            begin
                sl.Clear;
                for i := 0 to 9 do
                     begin
                         s := sintAmbiente (secao, item+intToStr(i));
                         if s <> '' then
                             if (comando = '') or (pos (comando, s) = 1) then
                                  sl.add(s);
                     end;

                garanteEspacoTela(sl.count+1);
                x := wherex;
                y := wherey;

                popupMenuCria(wherex, wherey, 80, sl.count+1, RED);
                for i := 0 to sl.Count-1 do
                    popupMenuAdiciona ('', copy (sl[i], 1, 81));   // só posso mostrar 80...
                i := popupMenuSeleciona;

                if i > 0 then comando := sl[i-1];

                gotoxy (x, y);
                clreol;
                write (copy (comando, 1, 79-x));
                gotoxy (x, y);

                if existeArqSom ('_REEDIT') then
                    sintSom ('_REEDIT')   {'Reedite e tecle Enter'}
                else
                    sintetiza ('Reedite e tecle enter');
            end;

    until (c = ENTER) or (c = ESC);

    sl.Free;

    if inserindo then
        insereNosUltimosComandos (comando, secao, item);
    pegaUltimosComandos := c;

    writeln;
end;

{--------------------------------------------------------}

procedure limpaBaixo (y: integer);
var
    i: integer;
begin
    if y = -1 then
        y := whereY;

    for i := y to ScreenSize.Y do
        begin
            gotoxy (1, i);
            clreol;
        end;
    gotoxy (1, y);
end;

{--------------------------------------------------------}

var
    xSalva, ySalva: integer;

procedure salvaXY;
begin
    xSalva := whereX;
    ySalva := whereY;
end;

procedure restauraXY;
begin
    if ysalva <> 0 then
        gotoXY (xSalva, ySalva);
    ysalva := 0;
end;

{--------------------------------------------------------}
{     Rotinas genéricas de exibição de progresso
{--------------------------------------------------------}

const
    DXPERCENT   = 30;       {* ' 100% de .......' *}

var
    numPontosTela: integer;
    xPosPercent: integer;
    feedbackSonoro: boolean;
    progressoFazSintClek: boolean;

    tempoPtos: integer;     {* Temporização: retorno visual a cada tempoPtos chamadas *}
    tempoSons: integer;     {* Temporização: retorno sonoro a cada tempoSons chamadas *}

    nota,
    pontoAtual,
    numChamadas: integer;
    percentProgresso: integer;
    totalProgresso: Int64;

{--------------------------------------------------------}
procedure mostraPercentual (fala: boolean);
var
    strTotal: string;
begin
    if percentProgresso = -1 then
        exit;
    if totalProgresso <= 1024 then
        strTotal := IntToStr (totalProgresso)
    else
        strTotal := IntToStr (totalProgresso div 1024) + 'K';

    GotoXY (xPosPercent, WhereY);
    if fala then
        sintWrite (IntToStr (percentProgresso)+'% de ' + strTotal)
    else
        Write (IntToStr (percentProgresso)+'% de ' + strTotal);
    GotoXY (pontoAtual, WhereY);
end;

{--------------------------------------------------------}
procedure inicializaProgresso (quantosPontos, tPontos, tSons: integer;
                               fazClek: boolean; instrMIDI: integer);
begin
    numPontosTela := quantosPontos;
    if numPontosTela > ScreenSize.X-1 - DXPERCENT then
        numPontosTela := ScreenSize.X-1 - DXPERCENT;
    xPosPercent := numPontosTela +2;

    feedbackSonoro := true;
    progressoFazSintClek := fazClek;
    if not progressoFazSintClek then
    begin
        abreMidi (0);
        if not instrMIDI in [1..127] then
            instrMIDI := 10;
        selInstrumento(instrMIDI);
    end;

    numChamadas := 0;
    pontoAtual  := 1;
    percentProgresso := -1;
    totalProgresso := 0;

    tempoPtos := tPontos;
    if tempoPtos < 0 then    tempoPtos := 1;
    if tempoPtos > 1000 then tempoPtos := 1000;

    tempoSons := tSons;
    if tempoSons < 0 then    tempoSons := 1;
    if tempoSons > 1000 then tempoSons := 1000;
    nota := 0;


    salvaXY;
    GotoXY(1, WhereY);
    ClrEol;
    limpaBufTec;
end;

{--------------------------------------------------------}
function mostraProgresso (acumulado, total: Int64): boolean;
var
    c: char;
begin
    result := True;
    numChamadas := numChamadas +1;
    if (acumulado * total) = 0 then
        percentProgresso := -1
    else
    begin
        percentProgresso := Round (acumulado / total * 100);
        totalProgresso := total;
        if percentProgresso < 0 then
            percentProgresso := 0
        else
        if percentProgresso > 100 then
            percentProgresso := -1
    end;

    if numChamadas mod tempoPtos = 0 then        { "Hora" de exibir }
    begin
        if pontoAtual = 1 then
        begin
            write (#13);
            ClrEol;
            if percentProgresso <> -1 then
                mostraPercentual (false);
        end;
        write ('.');
        pontoAtual := pontoAtual +1;
        if pontoAtual > numPontosTela then
            pontoAtual := 1;
    end;

    if keypressed then
         begin
             c := readkey;
             limpaBufTec;
             case c of
                 ESC:   begin
                            result := False;
                            exit;
                        end;
                 ENTER: if percentProgresso <> -1 then
                            mostraPercentual (true);
                 ' ':   feedbackSonoro := not feedbackSonoro;
             end;
         end;

    if feedbackSonoro and (numChamadas mod tempoSons = 0) then     { "Hora" de "Tocar" }
        if progressoFazSintClek then
            sintClek
        else
        begin
            if percentProgresso = -1 then
            begin
                nota := nota +1;
                if nota > 50 then nota := 0;
            end
            else
                nota := percentProgresso div 2;
            tocaNota (2, nota, 50)

        end;
end;

{--------------------------------------------------------}
procedure finalizaProgresso;
begin
    if not progressoFazSintClek then
        fechaMidi;
    restauraXY;
    ClrEol;
end;

begin
    tamRotulosForm := 28;
end.


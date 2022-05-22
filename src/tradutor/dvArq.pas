{--------------------------------------------------------}
{
{    Rotinas básicas para seleção de arquivos
{    Autor: José Antonio Borges
{    Em novembro/2001
{
{--------------------------------------------------------}

unit dvarq;

interface
uses
  dvwin,
  dvcrt,
  dvAmplia,
  windows,
  sysUtils,
  classes;

  type
    TMySearchRec = record
        sr: TRawbyteSearchRec;
        marcado: boolean;
    end;

    PMySearchRec = ^TMySearchRec;

function obtemNomeArqMasc (dy: integer; masc: string): string;
function obtemNomeArq (dy: integer): string;
function selecArq (xmin, ymin, xmax, ymax: integer;
                   mascSelecao: string;
                   atribArq: word; tipoOrdem: integer): string;

function semAcentos (s: string): string;
function criaListArq (mascMultipla: string; atribArq: word): TList;
function obtemListArq: TList;
procedure liberaListArq;

procedure preparaTelaArq (xmin, ymin, xmax, ymax: integer);
procedure redesenhaListArq (qualOpcao: integer; forcaRedesenho: boolean);
procedure ordenaListArq (tipo: integer);

procedure escolheFuncaoListArq (var qualOpcao: integer; var c1, c2: char);
function escolheListArq (qualOpcao: integer): integer;

procedure salvaTelaArq;
procedure recuperaTelaArq;

var
    listArqPersistente: boolean;    // para poder consultar a lista após a seleção
                                    // neste caso, depois de consultar, chamar
                                    // obrigatoriamente a rotina liberaListArq

    teclaObtemNomeArq: char;        // só para a função obtemNomeArq
    brAntes: string;

implementation

uses Math;

var
    psr: ^TMySearchRec;
    listArq: TList;
    xMinTela, xmaxTela, yminTela, ymaxTela: integer;
    yminVis, ymaxVis: integer;

    salvaCor: word;
    psaveScreenChar, psaveScreenAttrib: pchar;
    salvax, salvay: integer;

    largLinha: integer;
    cc1: string;

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

function criaListArq (mascMultipla: string; atribArq: word): TList;
var sr: TRawbyteSearchRec;
    mascSelecao: string;
    p: integer;
begin
    listArq := TList.Create;
    criaListArq := listArq;

    repeat
        p := pos ('|', mascMultipla);
        if p = 0 then
            begin
                mascSelecao := mascMultipla;
                mascMultipla := '';
            end
        else
            begin
                mascSelecao := copy (mascMultipla, 1, p-1);
                delete (mascMultipla, 1, p);
            end;

        if pos ('.', mascSelecao) = 0 then
            mascSelecao := mascSelecao + '*.*'
        else
            mascSelecao := mascSelecao + '*';

        if FindFirst(mascSelecao, atribArq, sr) = 0 then
            repeat
                if (((sr.Attr and atribArq) = atribArq) or
                   ((sr.Attr and (FaDirectory+FaVolumeId) = 0) and (atribArq = FaArchive))) and                    ((sr.Name <> '.') and (sr.Name <> '..')) then
                    begin
                        new (psr);
                        psr^.sr := sr;
                        psr^.marcado := false;
                        listArq.Add (psr);
                    end;
            until FindNext(sr) <> 0;
        FindClose(sr);
    until mascMultipla = '';
end;

{--------------------------------------------------------}

procedure preparaTelaArq (xmin, ymin, xmax, ymax: integer);
begin
    xMinTela := xmin;
    yMinTela := ymin;
    xmaxTela := xmax;
    ymaxTela := ymax;

    yminVis := 0;
    ymaxVis := yminVis + ymaxTela-yminTela;

    largLinha := xmaxTela-xminTela+1;

    if yminVis = ymaxVis then
        brAntes := ''
    else
        brAntes := ' ';
end;

{--------------------------------------------------------}

procedure desenhaListArq;
var y: integer;
    s: string;
    psr: PMySearchRec;
const
    BRANCOS = '                                        ' +
              '                                        ';
begin
    for y := yminVis to ymaxVis do
        begin
            gotoxy (xminTela, yminTela+y-yminVis);
            textColor (WHITE);
            textBackground (6);

            if y < listArq.count then
                begin
                    psr := listArq.list[y];
                    if (psr^.sr.Attr and FaDirectory) <> 0 then
                         textColor (CYAN);
                    if psr^.marcado then
                        textColor (GREEN);
                    s := psr^.sr.name + BRANCOS;
                    s := brAntes + copy (s, 1, largLinha-length(brAntes));
                    write (s);
                end;
        end;
end;

{--------------------------------------------------------}

procedure redesenhaListArq (qualOpcao: integer; forcaRedesenho: boolean);
var alterouTela: boolean;
begin
    alterouTela := false;
    while (qualOpcao < yminVis) and (yminVis > 0) do
        begin
            dec (yminVis);
            dec (ymaxVis);
            alterouTela := true;
        end;

    while (qualOpcao > ymaxVis) and (ymaxVis < listArq.count-1) do
        begin
            inc (yminVis);
            inc (ymaxVis);
            alterouTela := true;
        end;
    if alterouTela or forcaRedesenho then
        desenhaListArq;
end;

{--------------------------------------------------------}

        procedure acrescentaZeros (var s: string);
        const zeros = '000000000000000';
        var nnum, i: integer;
        begin
            s := s + '.';
            for i := 1 to length(s) do
                 if not (s[i] in ['0'..'9']) then
                      begin
                          nnum := i-1;
                          break;
                      end;
            delete (s, length(s), 1);
            s := copy (zeros, 1, 15-nnum) + s;
        end;

        function comparaNome (Item1, Item2: Pointer): Integer;
        var
            nome1, nome2: string;
        begin
            nome1 := semAcentos(PMySearchRec(item1)^.sr.name);
            nome2 := semAcentos(PMySearchRec(item2)^.sr.name);

            if nome1[1] in ['0'..'9'] then acrescentaZeros(nome1);
            if nome2[1] in ['0'..'9'] then acrescentaZeros(nome2);
            Result := compareText (nome1, nome2);
        end;

        function comparaExtensao (Item1, Item2: Pointer): Integer;
        var ext1, ext2: string;
            n: integer;

            function retornaExtensao (s: string): string;
            var i: integer;
            begin
                if pos ('.', s) = 0 then s := ''
                else
                    begin
                        i := length (s);
                        while s[i] <> '.' do i := i - 1;
                        delete (s, 1, i);
                    end;
                    retornaExtensao := s;
            end;

        begin
            ext1 := PMySearchRec(item1)^.sr.name;
            ext1 := retornaExtensao (ext1);
            ext2 := PMySearchRec(item2)^.sr.name;
            ext2 := retornaExtensao (ext2);

            n := compareText (ext1, ext2);
            if n <> 0 then result := n
                      else result := comparaNome (Item1, Item2);
        end;

        function comparaTamanho (Item1, Item2: Pointer): Integer;
        begin
            Result := PMySearchRec(item1)^.sr.Size - PMySearchRec(item2)^.sr.Size;
        end;

        function comparaData (Item1, Item2: Pointer): Integer;
        begin
            Result := PMySearchRec(item1)^.sr.Time - PMySearchRec(item2)^.sr.Time;
        end;

procedure ordenaListArq (tipo: integer);
begin
    case tipo of
        1: listArq.sort (@ComparaExtensao);
        2: listArq.sort (@ComparaTamanho);
        3: listArq.sort (@ComparaData);
    else
        listArq.sort (@ComparaNome);
    end;
end;

{--------------------------------------------------------}

procedure salvaTelaArq;
var i, xx, yy: integer;
begin
    salvaCor := textAttr;
    salvax := wherex;
    salvay := wherey;

    getmem (psaveScreenChar,   largLinha * (ymaxTela-yminTela+1));
    getmem (psaveScreenAttrib, largLinha * (ymaxTela-yminTela+1));
    i := 0;
    for yy := yminTela to ymaxTela do
        for xx := xminTela to xmaxTela do
            begin
                 psaveScreenChar[i]   := getScreenChar (xx, yy);
                 psaveScreenAttrib[i] := chr (getScreenAttrib (xx, yy));
                 i := i + 1;
            end;
end;

{--------------------------------------------------------}

procedure recuperaTelaArq;
var i, xx, yy: integer;
    cor, ultCor: word;
    s: string [80];
begin
    ultCor := 255;
    i := 0;
    for yy := yminTela to ymaxTela do
        begin
            gotoxy (xminTela, yy);
            s := '';
            for xx := xminTela to xmaxTela do
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

    freemem (psaveScreenChar,   largLinha * (ymaxTela-yminTela+1));
    freemem (psaveScreenAttrib, largLinha * (ymaxTela-yminTela+1));

    textAttr := salvaCor;
    gotoxy (salvax, salvay);
end;

{--------------------------------------------------------}

function pegaPalavraMudo (var palavra: string): char;
var
    c: char;
begin
    palavra := '';
    repeat
        c := readkey;
        case c of
            #$0: begin
                     sintBip;
                     readkey;
                 end;

            ' '..#255:
                    begin
                        if (c <> NOFOCUS) and (c <> GOTFOCUS) then
                            begin
                                sintCarac(c);
                                palavra := palavra+ c;
                            end;
                    end;

            BS:
                    if palavra = '' then
                        sintBip
                    else
                        begin
                            sintSom('_DEL');
                            sintCarac(palavra[length(palavra)]);
                            delete (palavra, length(palavra), 1);
                        end;

            ESC:
                begin
                    palavra := '';
                    sintBip; sintBip;
                    break;
                end;

            ENTER:
                    break;
        end;
    until false;

    pegaPalavraMudo := c;
end;

{--------------------------------------------------------}

procedure escolheFuncaoListArq (var qualOpcao: integer;
                                var c1, c2: char);
var
    acabou: boolean;
    nome1, nome2: string;
    psr2: ^TMySearchRec;
    i: integer;

        procedure desenhaItem;
        begin
            gotoxy (xminTela, yminTela+qualOpcao-yminVis);
            if psr^.marcado then
                textColor (GREEN)
            else
            if (psr^.sr.Attr and FaDirectory) <> 0 then
                textColor (CYAN)
            else
                textColor (WHITE);
            write (brAntes + copy (psr^.sr.name, 1, largLinha-length(brAntes)));
        end;

        procedure desceCursor;
        begin
            if (GetKeyState(VK_SHIFT) < 0) and
               (qualOpcao >= 0) and (qualOpcao < listArq.count) then
                begin
                   psr := listArq.list[qualOpcao];
                   if not psr^.marcado then sintBip;
                   psr^.marcado := true;
                   desenhaItem;
                end;
            qualOpcao := qualOpcao + 1;
            if (GetKeyState(VK_SHIFT) < 0) and
               (qualOpcao >= 0) and (qualOpcao < listArq.count) then
                begin
                   // sintBip;
                   psr := listArq.list[qualOpcao];
                   psr^.marcado := true;
                   desenhaItem;
                end;
        end;

        procedure sobeCursor;
        begin
            if (GetKeyState(VK_SHIFT) < 0) and
               (qualOpcao >= 0) and (qualOpcao < listArq.count) then
                begin
                   psr := listArq.list[qualOpcao];
                   if psr^.marcado then sintClek;
                   psr^.marcado := false;
                   desenhaItem;
                end;
            qualOpcao := qualOpcao - 1;
        end;

        procedure buscaPorInicial (continuando, noMeio: boolean);
        var
            nome: string;
            achou: boolean;
            salvaPos: integer;
        begin
            if not continuando then
                begin
                    sintSom('_BUSCAR');
                    if (pegaPalavraMudo (cc1) = ESC) or (cc1 = '') then
                        exit;
                end;

            achou := false;
            salvaPos := qualOpcao;
            repeat
                qualOpcao := qualOpcao + 1;
                if qualOpcao < listArq.count then
                    begin
                        psr := listArq.list[qualOpcao];
                        cc1 := semAcentos(ansiuppercase(cc1));
                        nome := semAcentos(ansiuppercase(psr^.sr.name));
                        if noMeio then
                            achou := pos(ansiUpperCase(cc1),nome) <> 0
                        else
                            achou := pos(ansiUpperCase(cc1),nome) = 1;
                    end;
            until (qualOpcao >= listArq.count) or achou;

            if achou then
                sintSom('_ACHEI')
            else
                begin
                    sintSom('_NAOACH');
                    qualOpcao := salvaPos;
                end;
        end;

label jaFala;

begin
    if qualOpcao < 0 then qualOpcao := 0;
    if qualOpcao >= listArq.Count then qualOpcao := listArq.Count-1;

    redesenhaListArq (qualOpcao, true);

    acabou := false;
    gotoxy (xminTela, yminTela+qualOpcao-yminVis);
    c1 := GOTFOCUS;
    goto jaFala;

    amplCampo('', 0);
    repeat
        while sintFalando and not keypressed  do
            waitMessage;  // controle das paradas de fala

        c1 := readkey;
        c2 := ' ';
        if c1 = #$0 then c2 := readkey;
        sintPara;                   //@@@TESTESOM

jaFala:
        if (qualOpcao >= 0) and (qualOpcao < listArq.count) then
            begin
                psr := listArq.list[qualOpcao];
                desenhaItem;
            end;

        if c1 <> #0 then
            case c1 of
                ' ':   if (qualOpcao >= 0) and (qualOpcao < listArq.count) then
                            psr^.marcado := not psr^.marcado;
                '+':   if (qualOpcao >= 0) and (qualOpcao < listArq.count) then
                            psr^.marcado := true;
                '-':   if (qualOpcao >= 0) and (qualOpcao < listArq.count) then
                            psr^.marcado := false;
                '*':   begin
                           for i := 0 to listArq.count-1 do
                                begin
                                    psr2 := listArq.list[i];
                                    psr2^.marcado := true;
                                end;
                           desenhaListArq;
                       end;
                '/':   begin
                            for i := 0 to listArq.count-1 do
                                begin
                                    psr2 := listArq.list[i];
                                    psr2^.marcado := false;
                                end;
                            desenhaListArq;
                        end;

                NOFOCUS:    while not keypressed do waitMessage;
                GOTFOCUS:   ;
            else
                acabou := true;
            end
        else
            case c2 of
                F5:      if (GetKeyState(VK_SHIFT) < 0) then
                             buscaPorInicial (false, true)
                         else
                             buscaPorInicial (false, false);

                CTLF5:   if (GetKeyState(VK_SHIFT) < 0) then
                             buscaPorInicial (true, true)
                         else
                             buscaPorInicial (true, false);

                CIMA:       sobeCursor;
                BAIX:       desceCursor;

                DIR, ESQ:   ;

                PGUP:       for i := 1 to 10 do sobeCursor;
                PGDN:       for i := 1 to 10 do desceCursor;

                HOME, CTLPGUP:
                    begin
                        if (GetKeyState(VK_SHIFT) < 0) then
                            begin
                                if qualOpcao > listArq.Count-1 then
                                    qualOpcao := listArq.Count-1;
                                for i := 0 to qualOpcao do
                                     begin
                                         psr2 := listArq.list[i];
                                         psr2^.marcado := false;
                                     end;
                                sintBip;
                                desenhaListArq;
                            end;

                        qualOpcao := 0;
                    end;

                TEND, CTLPGDN:
                    begin
                        if (GetKeyState(VK_SHIFT) < 0) then
                            begin
                                for i := qualOpcao to listArq.count-1 do
                                    if (i >= 0) and (i < listArq.count) then
                                        begin
                                            psr2 := listArq.list[i];
                                            psr2^.marcado := true;
                                        end;
                                sintBip;
                                desenhaListArq;
                            end;

                        qualOpcao := listArq.count-1;
                    end;

            else
                acabou := true;
            end;

        if qualOpcao < 0 then qualOpcao := -1;
        if qualOpcao >= listArq.count then qualOpcao := listArq.count;

        if (qualOpcao < 0) or (qualOpcao = listArq.count) then
            begin
                sintBip;
                redesenhaListArq (qualOpcao, false);
                gotoxy (xmaxTela, ymaxTela);
                amplCampo('', 0);
            end
        else
            begin
                redesenhaListArq (qualOpcao, false);

                if not acabou then
                    begin
                        psr := listArq.list[qualOpcao];
                        nome1 := psr^.sr.name;
                        nome2 := psr^.sr.name;
                        amplCampo(psr^.sr.Name, 0);

                        gotoxy (xminTela, yminTela+qualOpcao-yminVis);
                        textColor (YELLOW);
                        write (brAntes + copy (nome1, 1, largLinha-length(brAntes)));
                        gotoxy (xminTela, qualOpcao+yminTela-yminVis);

                        if c2 = DIR then  sintSoletra (nome1)
                        else
                        if c2 = ESQ then  sintSoletra (nome2)
                        else
                                begin
                                    if psr^.marcado then sintbip;
                                    sintetiza (nome1);
                                end;
                    end;
            end;
    until acabou;

    amplEsconde;

    if (qualOpcao < 0) or (qualOpcao = listArq.count) or (c1 = ESC) then
        qualOpcao := -1
    else
        begin
            gotoxy (xminTela, yminTela+qualOpcao-yminVis);
            textColor (YELLOW);
            write (brAntes + copy (nome1, 1, largLinha-length(brAntes)));
            textColor (WHITE);
        end;
end;

{--------------------------------------------------------}

function escolheListArq (qualOpcao: integer): integer;
var c1, c2: char;
begin
    repeat
         escolheFuncaoListArq (qualOpcao, c1, c2);
    until (c1 = ESC) or (c1 = TAB) or (c1 = ENTER);
    if c1 = #0 then
        teclaObtemNomeArq := c2
    else
        teclaObtemNomeArq := c1;

    if c1 = TAB then
        escolheListArq := -2
    else
    if c1 = ESC then
        escolheListArq := -1
    else
        escolheListArq := qualOpcao;
end;

{--------------------------------------------------------}

procedure liberaListArq;
var
    i: integer;
begin
    if listArq = NIL then
         exit;
    for i := 0 to listArq.count-1 do
        dispose (PMySearchRec(listArq[i]));
    listArq.Free;
    listArq := NIL;
end;

{--------------------------------------------------------}

function selecArq (xmin, ymin, xmax, ymax: integer;
                   mascSelecao: string;
                   atribArq: word; tipoOrdem: integer): string;
var n: integer;
    dirAtual, dirPedido: string;
begin
    getDir (0, dirAtual);
    dirPedido := mascSelecao;
    while (dirPedido <> '') and (dirPedido [length(dirPedido)] <> '\') and
                                (dirPedido [length(dirPedido)] <> ':') do
        delete (dirPedido, length(dirPedido), 1);

    delete (mascSelecao, 1, length(dirPedido));
    if dirPedido <> '' then
        begin
            {$I-} chdir (dirPedido); {$I+}
            if ioresult <> 0 then
                begin
                    selecArq := '';
                    exit;
                end;
        end;

    getDir (0, dirPedido);

    criaListArq (mascSelecao, atribArq);
    if listArq.count = 0 then
        begin
            if not listArqPersistente then
                liberaListArq;
            selecArq := '';
            exit;
        end;

    ordenaListArq(tipoOrdem);

    if (xmax = 80) and (ymax = 25) then xmax := 79;
    preparaTelaArq (xmin, ymin, xmax, ymax);

    salvaTelaArq;

    n := escolheListArq (0);
    if n = -2 then
        selecArq := '@TAB@'
    else
    if n >= 0 then
        begin
            if dirPedido = dirAtual then
                dirPedido := ''
            else
                if dirPedido [length(dirPedido)] <> '\' then
                    dirPedido := dirPedido + '\';
            selecArq := dirPedido + PMySearchRec(listArq[n]).sr.name;
        end
    else
        selecArq := '';

    if not listArqPersistente then
        liberaListArq;

    recuperaTelaArq;

    {$I-} chdir (dirAtual); {$I+}
    if ioresult <> 0 then;
end;

{--------------------------------------------------------}

function obtemNomeArqMasc (dy: integer; masc: string): string;
var c: char;
    nomeArq, diretorio: string;
    p: integer;
label deNovo;
begin
deNovo:
    nomeArq := '';
    c := sintEdita (nomeArq, wherex, wherey, 255, true);
    teclaObtemNomeArq := c;

    if c = TAB then goto deNovo;
    if c = ESC then
        begin
            amplEsconde;
            obtemNomeArqMasc := '';
            exit;
        end;

    obtemNomeArqMasc := nomeArq;
    if c = ENTER then exit;

    if (c <> CIMA) and (c <> BAIX) then exit;

    nomeArq := trim (nomeArq);
    if (nomeArq <> '') and (DirectoryExists (nomeArq))
         and (nomeArq[length(nomeArq)] <> '\')
         and (nomeArq[length(nomeArq)] <> ':') then
        nomeArq := nomeArq + '\';

    diretorio := '';
    if length (nomeArq) > 0 then
        begin
            p := length (nomeArq);
            while (p > 0) and (nomeArq[p] <> '\') do p := p - 1;
            if p > 0 then
                 diretorio := copy (nomeArq, 1, p);
        end;

    if (nomeArq = '') or (nomeArq[length(nomeArq)] = '\') then
        nomeArq := nomeArq+masc;

    if (c <> ENTER) or (pos ('*', nomeArq) <> 0) then
        nomeArq := selecArq (wherex, wherey, 80, wherey+dy-1, nomeArq, faArchive, 0);

    if nomeArq = '@TAB@' then
        begin
            sintClek; sintClek;
            goto deNovo;
        end;

    if (pos('\', nomeArq) <> 0) or (pos (':', nomeArq) <> 0) then
        obtemNomeArqMasc := nomeArq
    else
        obtemNomeArqMasc := diretorio + nomeArq;
end;

function obtemNomeArq (dy: integer): string;
begin
    obtemNomeArq := obtemNomeArqMasc (dy, '*.*');
end;

function obtemListArq: TList;
begin
    result := listArq;
end;

end.

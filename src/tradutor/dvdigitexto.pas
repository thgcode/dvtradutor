{--------------------------------------------------------}
{                                                        }
{    Componente de edição de textos                      }
{                                                        }
{    Autor: José Antonio Borges                          }
{                                                        }
{    Em abril/2014                                       }
{                                                        }
{--------------------------------------------------------}

unit dvdigitexto;

interface
uses
  dvcrt,
  dvwin,
  dvarq,
  windows,
  classes,
  sysutils;

procedure molduraTexto (x, y, dx, dy: integer; corMoldura: byte; limpaFundo: boolean);

procedure digiTexto (texto: TStringList; autoJunta: boolean;
                     x0, y0, ncol, nlin: integer;
                     corfundo, corletra, coredicao, corbloco: integer;
                     nomeArqRascunho: string; readonly: boolean;
                     linInic: integer);

procedure digiTextoArq (nomeArq: string; autoJunta: boolean;
                        x0, y0, ncol, nlin: integer;
                        corfundo, corletra, coredicao, corbloco: integer;
                        readonly: boolean);

procedure popupDigiTexto (texto: TStringList; autoJunta, comMoldura: boolean;
                          x, y, ncol, nlin: integer; readonly: boolean);

implementation

var
    psaveScreenChar, psaveScreenAttrib: pchar;
    salvaCorOriginal: word;
    iniBloco, fimBloco: integer;
    linhaPerg: integer;
    corPerg: byte;
    ncolLivre: integer;

const
    PONTINHO = #$B7;

procedure juntaTodosOsParagrafos (texto: TStringList); forward;

{--------------------------------------------------------}

function perguntaCarac (s: string): char;
var salva: byte;
    c: char;
begin
    salva := textAttr;
    gotoxy (1, linhaPerg);
    textBackground (RED);
    textColor (corPerg);

    clreol;
    sintWrite (s);
    c := sintReadKey;
    write (c);
    limpaBufTec;

    textAttr := salva;
    result := c;
end;

{--------------------------------------------------------}

function pergunta (s: string): string;
var salva: byte;
    lido: string;
begin
    salva := textAttr;
    gotoxy (1, linhaPerg);
    textBackground (RED);
    textColor (corPerg);

    clreol;
    sintWrite (s);
    sintEditaCampo(lido, wherex, wherey, 200, ncolLivre-wherex, true);

    limpaBufTec;
    textAttr := salva;
    result := lido;
end;

{--------------------------------------------------------}

function perguntaArquivo (s: string): string;
var salva: byte;
    lido: string;
    c, c2: char;
begin
    salva := textAttr;
    gotoxy (1, linhaPerg);
    textBackground (RED);
    textColor (corPerg);

    clreol;
    sintWrite (s);

    lookupKeyBuf(c, c2);
    if c <> #0 then
        sintReadln(lido)
    else
        begin
            lido := selecArq (wherex, wherey,
                          currentWindow.Right-currentWindow.Left, wherey,
                          '*.*', faArchive, 0);
            write (lido);
        end;
    limpaBufTec;

    textAttr := salva;
    result := lido;
end;

{--------------------------------------------------------}

procedure salvaRegiaoTela (x, y, dx, dy: integer);
var i, xx, yy: integer;
begin
if crtwindow = 0 then clrscr;
    salvaCorOriginal := textAttr;

    if x+dx > ScreenSize.x+1 then dx := ScreenSize.x+1-x;
    if y+dy > ScreenSize.y+1 then dy := ScreenSize.Y+1-y;
    salvaCorOriginal := textAttr;

    getmem (psaveScreenChar,   dx*dy);
    getmem (psaveScreenAttrib, dx*dy);

    i := 0;
    for yy := y to y+dy-1 do
        for xx := x to x+dx-1 do
            begin
                 psaveScreenChar[i]   := getScreenChar (xx, yy);
                 psaveScreenAttrib[i] := chr (getScreenAttrib (xx, yy));
                 i := i + 1;
            end;
end;

{--------------------------------------------------------}

procedure recupRegiaoTela (x, y, dx, dy: integer);
var i, xx, yy: integer;
    cor, ultCor: word;
    s: string [80];
begin
    ultCor := 255;
    i := 0;
    for yy := y to y+dy-1 do
        begin
            gotoxy (x, yy);
            s := '';
            for xx := x to x+dx-1 do
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

    freemem (psaveScreenChar,   dx*dy);
    freemem (psaveScreenAttrib, dx*dy);

    textAttr := salvaCorOriginal;
end;

{--------------------------------------------------------}

procedure molduraTexto (x, y, dx, dy: integer; corMoldura: byte; limpaFundo: boolean);
var salva: word;
    i: integer;
    s: string;
begin
    salva := textAttr;
    textBackground (corMoldura);
    gotoxy (x, y);
    for i := x to x+dx-1 do
        write (' ');
    gotoxy (x, y+dy-1);
    for i := x to x+dx-1 do
        write (' ');
    for i := y+1 to y+dy-2 do
        begin
            gotoxy (x, i);
            write (' ');
            gotoxy (x+dx-1, i);
            write (' ');
        end;
    gotoxy (x+1, y+1);
    textAttr := salva;
    if limpaFundo then
        begin
            s := '';
            for i := x+1 to x+dx-2 do
                s := s + ' ';
            for i := y+1 to y+dy-2 do
                begin
                    gotoxy (x+1, i);
                    write (s);
                end;
        end;
end;

{--------------------------------------------------------}

procedure expandeTabs (texto: TStringList);
var
    i, j: integer;
    s, sai: string;
begin
    for i := 0 to texto.count-1 do
        begin
            sai := '';
            s := texto[i];
            for j := 1 to length(s) do
                if s[j] = TAB then
                    sai := sai + '        '
                else
                    begin
                         sai := sai + copy (s, j, 9999);
                         break;
                    end;
            texto[i] := sai;
        end;
end;

{--------------------------------------------------------}

procedure juntaTodosOsParagrafos (texto: TStringList);
var
    i: integer;
    s: string;
    recemPulou: boolean;

begin
    s := '';
    recemPulou := true;
    for i := 0 to texto.count-1 do
        if texto[i] = '' then
            begin
                if recemPulou then
                    s := s + ^m^j
                else
                    s := s + ^m^j + ^m^j;
                recemPulou := true;
            end
        else
        if (texto[i][1] = ' ') or (texto[i][1] = TAB) then
            begin
                if recemPulou then
                    s := s + texto[i]
                else
                    s := s + ^m^j + texto[i];
                recemPulou := false;
            end
        else
            begin
                if not recemPulou then
                   s := s + ' ';
                s := s + texto[i];
                recemPulou := false;
            end;
    s := s + ^m^j;
    texto.Text := s;
end;

{--------------------------------------------------------}

procedure divideUmaLinha (s: string; tam: integer; sdiv: TStringList);
var
    primeira: boolean;
    fim, antFim: integer;
    sai: string;

begin
    primeira := true;
    fim := 1;
    while length (s) > 0 do
        begin
            antFim := fim-1;
            repeat
                fim := fim + 1;
            until (fim > length(s)) or (s[fim] = ' ');

            if fim > tam+1 then
                begin
                    if antFim = 0 then antFim := tam;
                    sai := copy (s, 1, antFim);
                    delete (s, 1, antFim);

                    if primeira then
                       begin
                            tam := tam - 1;
                            primeira := false;
                       end
                    else
                        sai := PONTINHO + sai;

                    sdiv.add (sai);
                    fim := 1;
                end;
        end;
end;

{--------------------------------------------------------}

procedure redivideParagrafo (texto: TStringList; linha: integer; ncol: integer;
                             var tamParagGerado: integer);
var
    s: string;
    i: integer;
    sdiv: TStringList;

    function tiraPontinho (s: string): string;
    begin
        if (s <> '') and (s[1] = PONTINHO) then
            delete (s, 1, 1);
        result := s;
    end;

begin
    tamParagGerado := 1;
    if (linha < 0) or (linha >= texto.count) then exit;   // preventivo

    s := texto[linha];
    if s = '' then exit;

    texto.Delete(linha);

    while (linha < texto.Count) and (copy (texto[linha], 1, 1) = PONTINHO) do
        begin
            s := s + tiraPontinho(texto[linha]);
            texto.delete (linha);
        end;

    sdiv := TStringList.create;
    divideUmaLinha (s, ncol, sdiv);
    for i := 0 to sdiv.Count-1 do
        texto.Insert(linha+i, sdiv[i]);

    tamParagGerado := sdiv.count;
    sdiv.Free;
end;

{--------------------------------------------------------}

procedure geraTextoFinal (texto: TStringList);
var i, nlinFinal: integer;
    s: string;
begin
    if texto.Count = 0 then exit;
    nlinFinal := 0;
    s := texto[0];
    for i := 1 to texto.Count-1 do
        begin
            if (texto[i] = '') or (texto[i][1] <> PONTINHO) then
                begin
                    texto[nlinFinal] := s;
                    nlinFinal := nlinFinal + 1;
                    s := texto[i];
                end
            else
                s := s + copy (texto[i], 2, 9999);
        end;

    texto[nlinFinal] := s;
    nlinFinal := nlinFinal + 1;

    for i := texto.Count-1 downto nlinFinal do
        texto.Delete(i);
end;

{--------------------------------------------------------}

procedure processaInsereLinha (texto: TStringList; linAtual: integer);
var
   s: string;
begin
    if linAtual >= texto.count then
        texto.Add('')
    else
    if (texto[linAtual] <> '')
         and (texto[linAtual][1] = PONTINHO) then
        begin
            s := texto[linAtual];
            delete (s, 1, 1);
            while (s <> '') and (s[1] = ' ') do
                delete (s, 1, 1);
            texto[linAtual] := s;
        end
    else
        texto.Insert(linAtual, '');
    sintetiza ('Nova linha');
end;

{--------------------------------------------------------}

procedure processaQuebraLinha (texto: TStringList; linAtual, posicao: integer);
var s1, s2: string;
begin
    s1 := copy (texto[linAtual], 1, posicao-1);
    s2 := copy (texto[linAtual], posicao, 999);
    texto.insert (linAtual, s1);
    texto[linAtual+1] := s2;
    sintetiza ('Linha quebrada');
end;

{--------------------------------------------------------}

procedure processaRemoveLinha (texto: TStringList; linAtual: integer);
var s: string;
    continuacao: boolean;
begin
    if linAtual = texto.Count-1 then
        begin
            if texto[linAtual] = '' then
                begin
                    sintClek;
                    exit;
                end;
            texto[linAtual] := '';
        end
    else
        begin
            continuacao := copy (texto[linAtual], 1, 1) = PONTINHO;
            texto.delete (linAtual);
            s := texto[linAtual];
            if not continuacao and
                (s <> '') and (s[1] = PONTINHO) then
                    begin
                        delete (s, 1, 1);
                        while (s <> '') and (s[1] = ' ') do
                            delete (s, 1, 1);
                        texto[linAtual] := s;
                    end;
        end;

     sintetiza ('Linha removida');
end;

{--------------------------------------------------------}

procedure processaJuntaAnterior (texto: TStringList; var linAtual: integer; ncol: integer);
var
    l, tamParagGerado: integer;
    s: string;
begin
    l := linAtual;
    while (l > 0) and (texto[l] <> '') and (texto[l][1] = PONTINHO) do
        l := l - 1;

    if (l > 0) and (texto[l] <> '') and (texto[l][1] <> PONTINHO) then
        begin
            s := texto[l];
            if texto[l-1] = '' then
                texto.delete (l-1)
            else
                begin
                    insert (PONTINHO + ' ', s, 1);
                    texto[l] := s;
                    redivideParagrafo(texto, l-1, ncol, tamParagGerado);
                end;
            linAtual := l - 1;
            sintetiza ('Parágrafos juntados');
        end
    else
        begin
            sintBip;
            sintetiza ('Não posso juntar dois parágrafos aqui');
        end;
end;

{--------------------------------------------------------}

function dentroDoBloco (linAtual, iniBloco, fimBloco: integer): boolean;
begin
     result := (linAtual >= iniBloco)  and  (linAtual <= fimBloco);
end;

{--------------------------------------------------------}

function blocoValido (texto: TStringList; iniBloco, fimBloco: integer): boolean;
begin
     result := (inibloco >= 0) and
               (inibloco <= texto.Count-1) and
               (fimbloco >= 0) and
               (fimbloco <= texto.Count-1) and
               (iniBloco <= fimBloco);
end;

{--------------------------------------------------------}

procedure salvaBloco (texto: TStringList; iniBloco, fimBloco: integer);
var
    textoCopia: TStringList;
    i: integer;
    nomeArqBloco: string;
begin
    nomeArqBloco := trim(pergunta('Arquivo a gravar: '));
    if nomeArqBloco = '' then
        begin
            sintBip;
            exit;
        end;

    textoCopia := TStringList.Create;
    textoCopia.Assign(texto);
    if fimBloco < textoCopia.Count then
        for i := textoCopia.Count-1 downto fimBloco do
            textoCopia.Delete(i);
    if iniBloco > 0 then
        for i := iniBloco-1 downto 0 do
            textoCopia.Delete(i);

    geraTextoFinal(textoCopia);
    try
        textoCopia.SaveToFile(nomeArqBloco);
        sintetiza ('Bloco gravado.');
    except
        sintetiza('Erro ao gravar o bloco.');
    end;
    textoCopia.free;
end;

{--------------------------------------------------------}

procedure leBloco (texto: TStringList; linAtual: integer;
                          var iniBloco, fimBloco: integer);
var
    textoCopia: TStringList;
    i: integer;
    nomeArqBloco: string;
begin
    nomeArqBloco := trim(perguntaArquivo('Arquivo a ler: '));
    if nomeArqBloco = '' then
        begin
            sintBip;
            exit;
        end;

    textoCopia := TStringList.Create;
    try
        textoCopia.LoadFromFile(nomeArqBloco);
        sintetiza ('Bloco lido.');

        expandeTabs (textoCopia);

        inibloco := linAtual;
        fimBloco := linAtual + textoCopia.Count-1;
        for i := 0 to textoCopia.Count-1 do
            texto.insert (linAtual+i, textoCopia[i]);
    except
        pergunta ('Erro de leitura, aperte enter');
    end;

    textoCopia.Free;
end;

{--------------------------------------------------------}

procedure funcoesDeBloco (texto: TstringList; linAtual: integer);
var c: char;
    tambloco: integer;
    i: integer;

begin
    sintetiza ('Bloco');
    c := readkey;
    case upcase (c) of
        'I': begin
                 sintetiza ('Início');
                 iniBloco := linAtual;
             end;
        'F': begin
                 sintetiza ('Fim');
                 fimBloco := linAtual;
             end;
        'D': begin
                 sintetiza ('Desmarcar');
                 iniBloco := -1;
                 fimBloco := -1;
             end;
        'T': begin
                 sintetiza ('Tudo marcado');
                 iniBloco := 0;
                 fimBloco := texto.count-1;
             end;

   'C', 'M': begin
                 if upcase(c) = 'C' then
                     sintetiza ('Copiar')
                 else
                     sintetiza ('Mover');

                 if blocoValido (texto, iniBloco, fimBloco) and
                    not dentroDoBloco (linAtual, iniBloco, fimBloco) then
                     begin
                         tamBloco := fimBloco-inibloco+1;
                         for i := 1 to tambloco do
                             texto.insert (linAtual, '');

                         if linAtual < iniBloco then
                             begin
                                 inibloco := inibloco + tambloco;
                                 fimbloco := fimbloco + tambloco;
                             end;

                         for i := 0 to tambloco-1 do
                             texto[linAtual+i] := texto[inibloco+i];

                         if upcase(c) = 'M' then
                             begin
                                 for i := 0 to tambloco-1 do
                                     texto.delete(inibloco);
                                 inibloco := linAtual;
                                 fimbloco := inibloco+tamBloco-1;
                             end;
                     end;
             end;
        'G': begin
                 if blocoValido (texto, iniBloco, fimBloco) then
                     salvaBloco (texto, iniBloco, fimBloco)
                 else
                     sintBip;
             end;
        'L': leBloco (texto, linAtual, iniBloco, fimBloco);

   else
        sintetiza ('Erro: operações válidas:');
        sintetiza ('i - Início');
        sintetiza ('f - Fim');
        sintetiza ('t - Marca tudo');
        sintetiza ('d - Desmarcar');
        sintetiza ('c - Copiar');
        sintetiza ('m - Mover');
        sintetiza ('g - Gravar');
        sintetiza ('l - Ler');
   end;
end;

{--------------------------------------------------------}

procedure letudo (texto: TStringList; var linAtual: integer);
var i: integer;
    s, s2: string;
begin
    if linAtual >= texto.Count then exit;

    clrscr;
    s := texto[linAtual];
    if (s <> '') and (s[1] = PONTINHO) then
        delete (s, 1, 1);
    writeln (s);

    for i := linAtual+1 to texto.Count-1 do
        begin
            if keypressed then break;
            if (texto[i] = '') or (texto[i][1] <> PONTINHO) then
                begin
                    sintetiza(s);
                    while sintFalando do waitMessage;
                    s := texto[i];
                    writeln (s);
                    if s = '' then delay (200);
                end
            else
                begin
                    s2 := copy (texto[i], 2, 9999);
                    s := s + s2;
                    writeln (s2);
                end;
        end;

    if not keypressed then
        sintetiza(s)
    else
        sintPara;

    while sintFalando do waitMessage;

    linAtual := i;
    if linAtual >= texto.Count then
        begin
            sintbip; sintbip; sintbip;
            limpaBufTec;
            sintetiza ('Fim de leitura');
            linAtual := texto.count-1;
        end;
end;

{--------------------------------------------------------}

procedure salvaRascunho (texto: TStringList; var nomeArqRascunho: string);
var
    textoCopia: TStringList;
begin
    if nomeArqRascunho = '' then
        begin
            nomeArqRascunho := pergunta('Arquivo a gravar: ');
            if nomeArqRascunho = '' then
                 nomeArqRascunho := 'rascunho.$$$';
        end;

    textoCopia := TStringList.Create;
    textoCopia.Assign(texto);
    geraTextoFinal(textoCopia);
    try
        textoCopia.SaveToFile(nomeArqRascunho);
        sintetiza ('Rascunho gravado.');
    except
        sintetiza('Erro ao gravar o rascunho.');
    end;
    textoCopia.free;
end;

{--------------------------------------------------------}

procedure ajuda (ncol: integer);

    procedure divi (s: string);
    var sdiv: TStringList;
        i: integer;
    begin
        sdiv := TStringList.Create;
        divideUmaLinha (s, ncol, sdiv);
        for i := 0 to sdiv.count-1 do
            writeln (sdiv[i]);
        sintetiza (s);
        sdiv.free;
    end;

var c: char;
label fim;
begin
    sintbip; sintbip;
    clrscr;
    limpaBufTec;

    textColor (YELLOW);
    divi ('Orientações sobre o DIGITEXTO');
    writeln;
    divi ('Esta é a função mais básica de edição do Dosvox, '+
          'para processar textos compostos por parágrafos. ' +
          'Ele mostra cada parágrafo como diversas linhas na tela. '+
          'Digite, e use as setas normalmente para posicionar. '+
          'Para ler o texto de forma corrida, aperte control-baixo.');
    c := readkey; limpaBufTec;
    if c = ESC then goto fim;
    writeln;
    textColor (WHITE);
    divi ('Para apagar uma linha aperte F7. ' +
          'Para juntar um parágrafo com o anterior use control-F7. '+
          'Para inserir um parágrafo abaixo, aperte enter. '+
          'Para quebrar um parágrafo em dois, aperte control-enter.');
    c := readkey; limpaBufTec;
    if c = ESC then goto fim;
    writeln;
    textColor (YELLOW);
    divi ('As linhas de continuação do parágrafo possuem um pontinho visual '+
          'ao início que soa como clek quando se chega nelas. '+
          'Linhas em branco também soam como clek.');
    c := readkey; limpaBufTec;
    if c = ESC then goto fim;
    writeln;
    textColor (WHITE);
    divi ('Para processar blocos de linhas use control-B seguido de '+
          'uma letra, indicando Início, Fim, Copiar, Mover, Desmarcar, ' +
          'Gravar e Ler.');
    readkey; limpaBufTec;
fim:
    sintBip; sintBip;
    textColor (WHITE);
    clrscr;
end;

{--------------------------------------------------------}

procedure digiTexto (texto: TStringList; autoJunta: boolean;
                     x0, y0, ncol, nlin: integer;
                     corfundo, corletra, coredicao, corbloco: integer;
                     nomeArqRascunho: string; readonly: boolean;
                     linInic: integer);
var
    lin, tamParagGerado: integer;
    i: integer;
    editando: boolean;
    s: string;
    c, c2, retorno: char;
    lin0tela, linAtual: integer;
    sai: string;
    sltrab: TStringList;

label mvcima, mvbaixo, insereLinha, achou, buscaDeNovo;

    {--------------------------------------------------------}
    function precisaEditar: boolean;
    begin
        lookupKeyBuf (c, c2);
        result :=
                (c = TAB) or (c = ^D) or
                (c >= #32) or
                ((c = #0) and (c2 in [
                    ESQ, DIR, HOME, TEND, DEL,
                    F1, F4, F12, F8,
                    CTLF1, CTLF4, CTLF8, CTLF9, CTLDIR, CTLESQ,
                    CTLINS, SHIFTINS]));

    end;

{--------------------------------------------------------}
var salvaCores: byte;
    busca: string;
    prekey: char;
label digitacao;

begin
    ctrl_cv_fechaCampo := true;
    ncolLivre := ncol;
    salvaCores := textAttr;
    linhaPerg := nlin;
    corPerg := coredicao;

    sintetiza ('Editando, F9 ajuda');

    expandeTabs (texto);
    if autoJunta then
        juntaTodosOsParagrafos (texto);

    lin := 0;
    while (lin < texto.Count) do
        begin
            redivideParagrafo (texto, lin, ncol, tamParagGerado);
            lin := lin + tamParagGerado;
        end;

    sintApagaAuto := false;
    editando := true;

    if (linAtual < 0) then
        linAtual := 0;
    if (linAtual >= texto.Count) then
        linAtual := texto.Count-1;
    linAtual := linInic;
    lin0tela := linAtual-(nlin div 2);
    if lin0tela < 0 then lin0Tela := 0;

    iniBloco := -1;
    fimBloco := -1;

    if texto.Count = 0 then texto.add('');

    window (x0, y0, x0+ncol-1, y0+nlin-1);
    textBackground (corFundo);

    while editando do
        begin
            for i := 0 to nlin-1 do
                begin
                    gotoxy (1, i+1);
                    if lin0tela+i = linAtual then
                        textColor(corEdicao)
                    else
                    if blocoValido (texto, inibloco, fimBloco) and
                       dentroDoBloco(lin0tela+i, iniBloco, fimBloco) then
                        textColor(corbloco)
                    else
                        textColor(corletra);

                    clreol;
                    if lin0Tela+i < texto.count then
                        write (copy (texto[lin0tela+i], 1, ncol));
                end;

            gotoxy (1, 1+linAtual-lin0tela);

            s := texto [linAtual];
            if (s = '') or (s[1] = PONTINHO) then
                sintclek;
            if not keypressed then
                if s = '' then
//                    sintClek
                else
                if s[1] = PONTINHO then
                    sintetiza (copy(s, 2, 999))
                else
                    sintetiza (s);

            if precisaEditar then
                begin
digitacao:
                    textColor (coredicao);
                    if (s <> '') and (s[1] = PONTINHO) then
                        begin
                            delete (s, 1, 1);
                            retorno := sintEditaCampo (s, 2, 1+linAtual-lin0tela, 4096, ncol-1, true);
                            s := PONTINHO + s;
                        end
                    else
                        retorno := sintEditaCampo (s, 1, 1+linAtual-lin0tela, 4096, ncol, true);
                    textColor (corletra);

                    texto [linAtual] := s;
                    redivideParagrafo (texto, linAtual, ncol, tamParagGerado);
                end
            else
                begin
                    waitMessage;
                    lookupKeyBuf (prekey, retorno);
                    if prekey <> #0 then goto digitacao;

                    readkey;
                    retorno := readkey;
                    sintPara;
                end;

            case retorno of
                { cuidado: F4 é tratado pela rotina de edicao }

                CIMA:
                     begin
    mvcima:
                         linAtual := linAtual - 1;
                         if linAtual < 0 then
                             begin
                                 sintBip;
                                 delay (200);
                                 linAtual := 0;
                             end;
                         if lin0tela < 0 then
                             lin0Tela := 0
                         else
                         if linAtual < lin0tela then
                             lin0Tela := linAtual;
                         sintCursorX := 1;
                     end;
                BAIX:
                     begin
    mvbaixo:
                         linAtual := linAtual + 1;
                         if linAtual >= texto.count then
                             begin
                                 sintBip;
                                 delay (200);
                                 linAtual := texto.count-1;
                             end;
                         if lin0Tela >= texto.Count then
                            lin0Tela := texto.count-1
                         else
                         if linAtual >= lin0tela+nlin then
                             lin0Tela := linAtual-nlin+1;
                         sintCursorX := 1;
                     end;
                PGUP:
                     begin
                         linAtual := linAtual - nlin+1;
                         lin0tela := lin0Tela - nlin;
                         goto mvcima;
                     end;

                PGDN:
                     begin
                         linAtual := linAtual + nlin-1;
                         lin0tela := lin0Tela + nlin;
                         goto mvbaixo;
                     end;

                CTLPGUP:  begin
                              linAtual := 0;
                              lin0tela := linAtual;
                              goto mvcima;
                          end;

                CTLPGDN:  begin
                              linAtual := texto.Count-1;
                              lin0tela := linAtual;
                              goto mvbaixo
                          end;

                CTLENTER: if sintCursorX = 1 then
                              processaInsereLinha (texto, linAtual)
                          else
                              processaQuebraLinha (texto, linAtual, sintCursorX);

                ENTER:    begin
                              processaInsereLinha (texto, linAtual+1);
                              goto mvBaixo;
                          end;

            CTLF2:  begin
                         nomeArqRascunho := '';
                         salvaRascunho (texto, nomeArqRascunho);
                     end;

                F2:  salvaRascunho (texto, nomeArqRascunho);

                F5:  begin
                        busca := ansiUpperCase (
                            pergunta('Qual o texto a buscar: '));
    buscaDeNovo:
                        if busca <> '' then
                            begin
                                for i := linAtual+1 to texto.Count-1 do
                                    if pos (busca, ansiUpperCase (texto[i])) <> 0 then
                                        begin
                                            linAtual := i-1;
                                            break;
                                        end;
                                if linAtual <> i-1 then
                                    begin sintBip; sintbip; end;
                                goto mvbaixo;
                            end;
                     end;

             CTLF5:  goto buscaDeNovo;

            ^Y, F7:  processaRemoveLinha (texto, linAtual);

             CTLF7:  processaJuntaAnterior (texto, linAtual, ncol);

                F9:  ajuda (ncol);

           CTLDOWN:  leTudo (texto, linAtual);

                ^C:  if blocoValido(texto, iniBloco, fimBloco) then
                         begin
                             sai := '';
                             for i := iniBloco to FimBloco do
                                 begin
                                     s := texto[i];
                                     if s = '' then
                                         sai := sai + ^m^j
                                     else
                                     if s[1] = PONTINHO then
                                          sai := sai + copy (s, 2, 999)
                                     else
                                         if sai = '' then
                                             sai := sai + s
                                         else
                                             sai := sai + ^m^j + s;
                                 end;
                             putClipBoard(pchar(sai));
                         end;

                ^V:  begin
                         setLength(s, 65000);
                         getClipBoard(pchar(s), 65000);
                         setLength(s, strLen(pchar(s)));
                         sltrab := TstringList.Create;
                         sltrab.text := s;
                         for i := 0 to sltrab.count-1 do
                             begin
                                 s := sltrab[i];
                                 texto.Insert(linAtual, s);
                                 redivideParagrafo (texto, linAtual, ncol, tamParagGerado);
                                 linAtual := linAtual + tamParagGerado;
                             end;
                         sltrab.free;
                     end;

                ESC:
                     begin
                         if readonly then
                             editando := false
                         else
                             editando := 
                                (upcase(perguntaCarac ('Confirma fim da edição? ')) <> 'S');
                         limpaBufTec;
                     end;

                ^B:  funcoesDeBloco (texto, linAtual);
            else
                begin
                    sintBip;
                    sintetiza ('Operação inválida');
                end;
            end;
        end;

    geraTextoFinal (texto);
    clrscr;

    window (1, 1, 80, 25);
    gotoxy (x0, y0);
    textAttr := salvaCores;
    ctrl_cv_fechaCampo := false;
end;

{--------------------------------------------------------}

procedure digiTextoArq (nomeArq: string; autoJunta: boolean;
                        x0, y0, ncol, nlin: integer;
                        corfundo, corletra, coredicao, corbloco: integer;
                        readonly: boolean);
var
    sl: TStringList;
    c: char;
begin
    sl := TStringList.Create;
    if fileExists (nomeArq) then
        sl.LoadFromFile(nomeArq);

    dvdigitexto.digiTexto(sl, false, wherex, wherey, 80, 24-wherey,
                          black, white, yellow, green, nomeArq, readonly, 0);

    if not readonly then
        begin
            c := perguntaCarac ('Confirma gravação? ');
            if (upcase(c) = 'N') or (c = ESC) then
                sintetiza ('Desistiu.')
            else
                try
                    sl.SaveToFile(nomeArq);
                    sintetiza ('Ok.');
                except
                    sintetiza ('Erro de gravação');
                end;
        end;

    sl.free;
end;

{--------------------------------------------------------}

procedure popupDigiTexto (texto: TStringList; autoJunta, comMoldura: boolean;
                          x, y, ncol, nlin: integer; readonly: boolean);
begin
    salvaRegiaoTela (x, y, ncol, nlin);
    if comMoldura then
        begin
            molduraTexto (x, y, ncol, nlin, LIGHTGRAY, true);
            digitexto (texto, autoJunta, x+1, y+1, ncol-2, nlin-2,
                      BLACK, WHITE, YELLOW, GREEN, '', readonly, 0);
        end
    else
            digitexto (texto, autoJunta, x, y, ncol, nlin,
                      BLACK, WHITE, YELLOW, GREEN, '', readonly, 0);
    recupRegiaoTela (x, y, ncol, nlin);
    gotoxy (x, y);
end;

end.


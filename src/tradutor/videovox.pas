{--------------------------------------------------------}
{
{   Leitor de telas offline
{
{   Autor: Jose' Antonio Borges
{
{   Baseado no programa original em assembler de
{       Orlando Jose' Rodrigues Alves
{
{   Em 2/1/95
{
{--------------------------------------------------------}

unit videovox;
interface

uses
    dvcrt, dvWin, dvAmplia, sysutils;

procedure leitorDeTela;
function letela (linha, coluna: integer): char;
function leAtrib(linha, coluna: integer): byte;

implementation

var txtBuscLeit: string;

{--------------------------------------------------------}
{          le um caractere da memoria de video
{--------------------------------------------------------}

function letela (linha, coluna: integer): char;
begin
    if (linha < 1) or (linha > screenSize.y) or
       (coluna < 1) or (coluna > 80) then
        letela := ' '
    else
        leTela := getScreenChar (coluna, linha);
end;

{--------------------------------------------------------}
{          le um atributo da memoria de video
{--------------------------------------------------------}

function leAtrib(linha, coluna: integer): byte;
begin
    if (linha < 1) or (linha > screenSize.y) or
       (coluna < 1) or (coluna > 80) then
        leAtrib := 0
    else
        leAtrib := getScreenAttrib (coluna, linha);
end;


{--------------------------------------------------------}

procedure leitorDeTela;
var
    linha, coluna: integer;
    salvax, salvay: integer;
    col1, col2: integer;
    c, c2: char;
    s: string;
    s2: string[3];

const
    MANTEMCURSOR = TRUE;
    ANDACURSOR   = FALSE;

    F1   = #59;
    F2   = #60;
    F3   = #61;
    F4   = #62;
    F5   = #63;
    F6   = #64;
    F7   = #65;
    F8   = #66;
    F9   = #67;
    F10  = #68;

    INS  = #82;
    DEL  = #83;
    HOME = #71;
    TEND = #79;
    PGUP = #73;
    PGDN = #81;
    CIMA = #72;
    BAIX = #80;
    ESQ  = #75;
    DIR  = #77;

    BKTAB    = #15;
    CTLENTER = #10;

    CTLPGUP = #132;
    CTLPGDN = #118;
    CTLESQ  = #115;
    CTLDIR  = #116;

    CTLF1   =  #94;
    CTLF2   =  #95;
    CTLF4   =  #97;
    CTLF5   =  #98;
    CTLF9   =  #102;
    CTLF10  =  #103;

    {--------------------------------------------------------}

    function alfanum (c: char): boolean;
    begin
        alfanum := (c in ['a'..'z','ç','ñ',
                          'á','é','í','ó','ú','â','ê','ô','ã','õ','à']) or
                   (c in ['A'..'Z','Ç','Ñ',
                          'Á','É','Í','Ó','Ú','Â','Ê','Ô','Ã','Õ','À']) or
                   (c in ['0'..'9']);
    end;

    {--------------------------------------------------------}

    function soConsoantes (s: string): boolean;
    var i: integer;
    begin
        soConsoantes := true;
        for i := 1 to length (s) do
            begin
                if not (s [i] in [
                    'B'..'D','F'..'H','J'..'N', 'P'..'T', 'V'..'Z',
                    'b'..'d','f'..'h','j'..'n', 'p'..'t', 'v'..'z']) then
                        begin
                            soConsoantes := false;
                            exit;
                        end;
            end;
    end;

    {--------------------------------------------------------}

    procedure falaLetra (linha, coluna: integer);
    var c: char;
    begin
        c := letela (linha, coluna);
        sintCarac (c);
    end;

    {--------------------------------------------------------}

    procedure posUltColuna;
    begin
        coluna := 81;
        repeat
            coluna := coluna - 1;
        until (coluna < 1) or (letela (linha, coluna) <> ' ');
        coluna := coluna + 1;

        if coluna < 1 then
           sintClek;
    end;

    {--------------------------------------------------------}

    procedure falaPalavra;
    var c: char;
    begin
        s := '';
        repeat
            c := letela (linha, coluna);
            if (c = ' ') and (coluna < 80) then
                coluna := coluna + 1;
        until (c <> ' ') or (coluna >= 80);

        if coluna >= 80 then exit;

        repeat
            gotoxy (coluna, linha);
            s := s + c;
            coluna := coluna + 1;

            c := letela (linha, coluna);

        until (not alfanum(c)) or (coluna > 80);

        if length (s) = 1 then
            begin
                repeat
                     if coluna > 80 then c := ' '
                     else
                         begin
                             c := letela (linha, coluna);
                             if c = s[1] then
                                 begin
                                     coluna := coluna + 1;
                                     s := s + c;
                                     if length (s) > 3 then delete (s, 3, 1);
                                 end;
                         end;
                until c <> s[1];

                sintetiza (s);
                if length (s) > 3 then
                    begin sintclek; sintclek; sintclek; end;
            end
        else
            begin
                if soConsoantes (s) then
                    sintSoletra (s)
                else
                    sintetiza (s);
            end;
    end;

    {--------------------------------------------------------}

    procedure delimitaCampo (var col1, col2: integer);
    const
        DELIMCAMPO: set of char = ['!', '?', ':', '|', #176..#223];
    var atrib: byte;
    begin
        atrib := leAtrib (linha, coluna);

        col1 := coluna+1;
        repeat
            col1 := col1 - 1;
        until (col1 < 1) or
              (leAtrib (linha, col1) <> atrib) or
              (leTela (linha, col1) in DELIMCAMPO);
        col1 := col1 + 1;

        col2 := coluna-1;
        repeat
            col2 := col2 +1;
        until (col2 > 80) or
              (leAtrib (linha, col2) <> atrib) or
              (leTela (linha, col2) in DELIMCAMPO);
        col2 := col2 - 1;
    end;

    {--------------------------------------------------------}

    procedure ampliaLinha (linha, coluna: integer);
    var s: string;
        col, letrasElim:integer;
    begin
        s := '';
        for col := 1 to 80 do
            s := s + leTela (linha, col);
        s := trimleft (s);

        letrasElim := 80 - length(s);
        if coluna <= letrasElim then
             coluna := 1
        else
             coluna := coluna - letrasElim;

        amplCampo (s, coluna);
    end;

    {--------------------------------------------------------}

    procedure falaTrecho (lin1, col1, lin2, col2: integer; mantem: boolean);
    var
        salvacol, salvalin,
        ultcol, l, col: integer;
        s: string;

    label interrompe;

    begin
        if (lin1 = lin2) and (col2 < col1) then
            begin
                sintBip;
                exit;
            end;

        salvacol := coluna;
        salvalin := linha;

        coluna := col1;

        for l := lin1 to lin2 do
            begin
                linha := l;
                if linha = lin2 then
                    ultcol := col2
                else
                    ultcol := 80;

                ampliaLinha (linha, wherex);
                if sapiPresente then
                    begin
                        s := '';
                        for col := col1 to ultCol do
                            s := s + leTela (linha, col);
                        sintetiza (s);
                    end
                else
                    if coluna <= ultcol then
                        repeat
                            falaPalavra;

                            while (coluna <= ultcol) and
                                  (leTela (linha, coluna) = ' ') do
                                coluna := coluna + 1;

                        until (coluna > ultcol) or (keypressed);

                if keypressed then
                   goto interrompe;
                coluna := 1;
                sintClek;
            end;

interrompe:
        sintFalando;    { interrompe fala }
        if col2 >= 80 then
             posUltColuna;

        if mantem then
            begin
                coluna := salvacol;
                linha  := salvalin;
            end;
    end;

    {--------------------------------------------------------}

    procedure leTodaTela;
    begin
        falaTrecho (1, 1, screenSize.y, 80, ANDACURSOR);
    end;

    {--------------------------------------------------------}

    procedure leInicioTela;
    begin
        falaTrecho (1, 1, linha, coluna-1, ANDACURSOR);
    end;

    {--------------------------------------------------------}

    procedure leFimTela;
    begin
        falaTrecho (linha, coluna, screenSize.y, 80, ANDACURSOR);
    end;

    {--------------------------------------------------------}

    procedure leTodaLinha;
    begin
        falaTrecho (linha, 1, linha, 80, MANTEMCURSOR);
    end;

    {--------------------------------------------------------}

    procedure leInicioLinha;
    begin
        falaTrecho (linha, 1, linha, coluna-1, MANTEMCURSOR);
    end;

    {--------------------------------------------------------}

    procedure leFimLinha;
    begin
        falaTrecho (linha, coluna, linha, 80, MANTEMCURSOR);
    end;

    {--------------------------------------------------------}

    procedure leTodoCampo;
    begin
        delimitaCampo (col1, col2);
        falaTrecho (linha, col1, linha, col2, MANTEMCURSOR);
    end;

    {--------------------------------------------------------}

    procedure leInicioCampo;
    begin
        delimitaCampo (col1, col2);
        falaTrecho (linha, col1, linha, coluna, MANTEMCURSOR);
    end;

    {--------------------------------------------------------}

    procedure leFimCampo;
    begin
        delimitaCampo (col1, col2);
        falaTrecho (linha, coluna, linha, col2, MANTEMCURSOR);
    end;

    {--------------------------------------------------------}

    procedure posProxCampo;
    begin
        delimitaCampo (col1, col2);
        coluna := col2 + 2;
        if coluna > 80 then
            posUltColuna
        else
            sintClek;
    end;

    {--------------------------------------------------------}

    procedure posCampoAnt;
    begin
        delimitaCampo (col1, col2);
        coluna := col1 - 2;
        sintClek;
    end;

    {--------------------------------------------------------}

    procedure posPalavraAnt;
    begin
        repeat
            coluna := coluna- 1;
        until (coluna < 1) or (letela (linha, coluna) <> ' ');
        if coluna < 1 then
            begin
                sintBip;
                coluna := 1;
                exit;
            end;

        repeat
            coluna := coluna - 1;
        until (coluna < 1) or (letela (linha, coluna) = ' ');
        if coluna < 1 then
            sintBip
        else
            sintClek;

        coluna := coluna + 1;
    end;

    {--------------------------------------------------------}

    procedure posProxPalavra;
    begin
        while (coluna < 81) and (letela (linha,coluna) <> ' ') do
            coluna := coluna + 1;

        while (coluna < 81) and (letela (linha,coluna) = ' ') do
            coluna := coluna + 1;

        if coluna = 81 then
            begin
                sintBip;
                posUltColuna;
            end
        else
            sintClek;
    end;

    {--------------------------------------------------------}

    procedure entraLinCol;
    var l: integer;
        label erro;
    begin
        s := 'Entre linha e coluna';
        sintetiza (s);

        for l := 1 to 4 do
            begin
               s[l] := readkey;
               if (s[l] >= '0') and (s[l] <= '9') then
                   sintCarac (s[l])
               else
                   begin
                       sintBip; sintBip;
                       goto erro;
                   end;
               end;

        linha := (ord(s[1]) and $f) * 10 + (ord(s[2]) and $f);
        coluna:= (ord(s[3]) and $f) * 10 + (ord(s[4]) and $f);
erro:
    end;

    {--------------------------------------------------------}

    procedure buscaPrimLetra;
    var l, c: integer;
    begin
        for l:= 1 to screenSize.y do
            for c:= 1 to 80 do
                 if upcase(leTela (l, c)) in ['A'..'Z'] then
                     begin
                         linha := l;
                         coluna := c;
                         exit;
                     end;
    end;

    {--------------------------------------------------------}

    procedure rebuscaTexto;
    var
        s: string;
        x, y: integer;
    begin
        for y := wherey to screenSize.y do
            begin
                s := '';
                for x := 1 to 80 do
                    s := s + leTela (y, x);
                if (y = wherey) then
                    for x := 1 to wherex do s[x] := #$0;
                x := pos (txtBuscLeit, s);
                if x <> 0 then
                    begin
                        linha := y;
                        coluna := x;
                        sintClek;
                        exit;
                    end;
            end;

        sintBip; sintBip;
    end;

    {--------------------------------------------------------}

    procedure buscaTexto;
    var c: char;
        s: string;
    begin
        s := 'Qual texto';
        sintetiza (s);

        txtBuscLeit := '';
        repeat
            c := readkey;
            if c = #$1b then exit;
            if c = BS then   { Backspace }
                begin
                    if txtBuscLeit <> '' then
                        begin
                            sintSom ('_DEL');
                            sintCarac (txtBuscLeit [length(txtBuscLeit)]);
                            delete (txtBuscLeit, length (txtBuscLeit), 1);
                        end;
                end
            else
                if c <> ENTER then
                    begin
                        txtBuscLeit := txtBuscLeit + c;
                        sintCarac (c);
                    end;
        until c = ENTER;

        rebuscaTexto;
    end;

    {--------------------------------------------------------}

    procedure buscaUltLetra;
    var l, c: integer;
    begin
        for l:= screenSize.y downto 1 do
            for c:= 80 downto 1 do
                 if upcase(leTela (l, c)) in ['A'..'Z'] then
                     begin
                         linha := l;
                         coluna := c;
                         exit;
                     end;
    end;

    {--------------------------------------------------------}

    procedure comandoExtenso (c: char);
    var s: string[2];
    label erro;
    begin
        c := upcase (c);
        if not (c in ['L', 'I', 'T', 'F']) then
           goto erro;
        if c = 'L' then c := 'T';

        c2 := upcase (readkey);

        if not (c2 in ['T', 'L', 'C']) then
           goto erro;

        s := c + c2;

        if s = 'IT' then leInicioTela
        else
        if s = 'IL' then leInicioLinha
        else
        if s = 'IC' then leInicioCampo
        else

        if s = 'TT' then leTodaTela
        else
        if s = 'TL' then leTodaLinha
        else
        if s = 'TC' then leTodoCampo
        else

        if s = 'FT' then leFimTela
        else
        if s = 'FL' then leFimLinha
        else
        if s = 'FC' then leFimCampo;

        exit;
erro:
        sintBip; sintClek; sintBip;
    end;

    {--------------------------------------------------------}

    procedure ignoraTeclas;
    begin
        while keypressed do readkey;
    end;

label fim, erro;
var p: pchar;
    lin, col, ipch: integer;

begin
    sintBip;

    linha  := wherey;
    coluna := wherex;
    salvax := coluna;
    salvay := linha;

    repeat
        gotoxy (coluna, linha);
        ampliaLinha(linha, coluna);

        c := readkey;  c2 := ' ';
        if c = #0 then c2 := readkey;

        case c of
            #$1b:  ;

            'a'..'z',
            'A'..'Z':  comandoExtenso (c);

            ' ':  leTodaLinha;

            ^C:   begin
                      getmem (p, 40 * 82);
                      ipch := 0;
                      for lin := 1 to screenSize.y do
                          begin
                              for col := 1 to screenSize. x do
                                  begin
                                      p[ipch] := letela (lin, col);
                                      ipch := ipch + 1;
                                  end;
                              p[ipch] := #$0d;
                              ipch := ipch + 1;
                              p[ipch] := #$0a;
                              ipch := ipch + 1;
                          end;
                      p[ipch] := #$0;
                      putClipBoard(p);
                      freeMem (p, 40 * 82);
                  end;

            ^H:   begin
                      if coluna > 1 then
                          falaLetra (linha, coluna-1)
                      else
                          sintBip;
                      coluna := coluna - 1;
                  end;

            ^K,^L:   begin
                     str (linha, s);
                     str (coluna, s2);
                     s := s + ' ' + s2;
                     sintetiza (s);
                  end;

            ^M:  begin
                     linha := linha + 1;
                     coluna := 1;
                     sintClek;
                 end;

            ^I:  posProxCampo;

            #$0: case c2 of
                     CIMA:  begin
                                linha := linha - 1;
                                coluna := 1;
                                if linha > 0 then
                                    leTodaLinha
                                else
                                    begin
                                        sintBip;
                                        linha := 1;
                                    end;
                            end;
                     BAIX:  begin
                                linha := linha + 1;
                                coluna := 1;
                                sintClek;
                                if linha <= screenSize.y then
                                    leTodaLinha
                                else
                                    begin
                                        sintBip;
                                        linha := screenSize.y;
                                    end;
                            end;

                     ESQ:   begin
                                if coluna > 1 then
                                    falaLetra (linha, coluna-1)
                                else
                                    sintBip;
                                coluna := coluna - 1;
                            end;

                     DIR:   begin
                                if coluna <= 81 then
                                    falaLetra (linha, coluna)
                                else
                                    sintBip;
                                coluna := coluna + 1;
                            end;


                     PGUP: begin
                                  linha := 1;    coluna := 1;
                                  leTodaLinha;
                              end;

                     PGDN: begin
                                  linha := screenSize.y;   coluna := 1;
                                  leTodaLinha;
                              end;

                     CTLPGUP:  begin
                                   buscaPrimLetra;
                                   leTodaLinha;
                               end;
                     CTLPGDN:  begin
                                   buscaUltLetra;
                                   leTodaLinha;
                               end;

                     CTLESQ: posPalavraAnt;
                     CTLDIR: posProxPalavra;
                     BKTAB:  posCampoAnt;

                     HOME:   coluna := 1;
                     TEND:   posUltColuna;

                     F5:     buscaTexto;
                     CTLF5:  rebuscaTexto;
                     F6:     entraLinCol;

                     F1:     begin
                                  if (not keypressed) or (not sapiPresente) then
                                       falaPalavra;
                                  if coluna >= 80 then
                                      begin
                                         sintClek;
                                         posUltColuna;
                                      end;
                             end;


                     CTLF1:  begin
                                 delimitaCampo (col1, col2);
                                 falaTrecho (linha, col1, linha, col2,
                                            MANTEMCURSOR);
                             end;

                 else
                     goto erro;
                 end

        else
            begin
erro:            sintbip; sintClek; sintBip;
            end;
        end;

        if coluna < 1 then
            begin  sintBip;  ignoraTeclas; coluna := 1;  end;
        if coluna > 81 then
            begin  sintBip;  ignoraTeclas; coluna := 80;  end;
        if linha < 1 then
            begin  sintBip;  ignoraTeclas; linha := 1;  end;
        if linha > screenSize.y then
            begin  sintBip;  ignoraTeclas; linha := screenSize.y;  end;

    until (c = #$1b);

fim:
    sintBip;  sintBip;
    amplEsconde;

    gotoxy (salvax, salvay);
end;

end.

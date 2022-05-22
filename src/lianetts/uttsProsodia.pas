unit uttsProsodia;

interface
uses Classes, sysUtils, dialogs;

function inicProsodia (arqConfigProsodia: string): boolean;
function inicListaDifones(arq_difones: string): boolean;
procedure fimProsodia;
function preProsodia (texto: string): TStringList;
procedure aplicaProsodia (fonemas: TStringList; var mbrolaCmd: TStringList;
                          perc_duracao, perc_pitch: real);
function calculaCurvaProsodia (palavrasComCodigos: TStringList;
                               comProsodia:boolean): TStringList;

implementation

procedure showMessage(s: string);
    begin
    writeln(s);
    readln;
end;

type
    str2 = string[2];
    str3 = string[3];

    TDuracao = record
         dif: string[2];
         dur: integer;
    end;

type
    TChave = record
         palavra: string;
         funcao: str2;
    end;

type
    TProsodia = record
         codAnt, codAtual, codProx: str3;
         codificacao: string;
    end;

var maxFon: integer;
    tabDur: array [1..100] of TDuracao;
    maxChaves: integer;
    tabChaves: array [1..1000] of TChave;
    maxProsodia: integer;
    tabProsodia: array [1..300] of TProsodia;
    lista_difones: TStringList;
    ult_dif, dif_atual: shortString;

var
    hertz: integer;
    tabHertz: array ['0'..'9'] of integer;

{--------------------------------------------------------}

procedure ordenaChaves;
var i, j: integer;
    temp: TChave;
begin
    for i := 1 to maxChaves-1 do
        for j := i+1 to maxChaves do
            if tabChaves[i].palavra > tabChaves[j].palavra then
                begin
                    temp := tabChaves[i];
                    tabChaves[i] := tabChaves[j];
                    tabChaves[j] := temp;
                end;
end;

{--------------------------------------------------------}

function buscaChave (qual: string): str2;
var ini, fim, meio: integer;
begin
    qual := AnsiUpperCase(qual);
    ini := 1;
    fim := maxChaves;

    buscaChave := '';
    while ini <= fim do
        begin
            meio := (ini + fim) div 2;
            if tabChaves[meio].palavra = qual then
                begin
                    buscaChave := tabChaves[meio].funcao;
                    ini := fim + 1;
                end
            else
            if tabChaves[meio].palavra > qual then
                 fim := meio-1
            else
                 ini := meio+1;
        end;
end;

{--------------------------------------------------------}

function inicListaDifones(arq_difones: string): boolean;
var i, j, k: integer;
    s: string;
    d1, d2: string;
begin
    inicListaDifones := false;
    lista_difones := TStringList.create;

    if not FileExists(arq_difones) then exit;
    try
        lista_difones.LoadFromFile (arq_difones);
    except
        exit;
    end;

    for i := lista_difones.count-1 downto 0 do
        begin
           s := trim (lista_difones[i]);
           if (s = '') or (s[1] in ['*', ';', '!']) then
               lista_difones.Delete(i)
           else
               begin
                   for j := 1 to length(s) do
                       if not (upcase(s[j]) in ['A'..'Z', '2', '@', '_']) then
                           break;
                   d1 := copy (s, 1, j-1);
                   for k := j+1 to length(s) do
                       if upcase(s[k]) in ['A'..'Z', '2', '@', '_'] then
                           break;
                   j := k;
                   for k := j+1 to length(s) do
                       if not (upcase(s[k]) in ['A'..'Z', '2', '@', '_']) then
                           break;
                   d2 := copy (s, j, k-j);
                   lista_difones[i] := d1+'-'+d2;
               end;
        end;

    lista_difones.sort;
    inicListaDifones := true;
end;

{--------------------------------------------------------}

function inicProsodia (arqConfigProsodia: string): boolean;
var arqProsodia: textFile;
    s, sequencia: string;
    p: integer;
    c: char;

label achouDuracao, achouChaves, achouProsodia, fim;
begin
    inicProsodia := false;

    maxFon := 0;
    maxChaves := 0;
    maxProsodia := 0;
    hertz := 230;

    assignFile (arqProsodia, arqConfigProsodia);
    {$I-}  reset (arqProsodia);  {$I+}
    if ioresult <> 0 then
        begin
            showMessage ('Configuração da prosódia não foi achada');
            exit;
        end;

    while not eof (arqProsodia) do
        begin
            readln (arqProsodia, s);
            if trim(s) = '[DURAÇÃO]' then goto achouDuracao;
        end;

    showMessage ('Duração dos difones errada ou ausente');
    goto fim;

achouDuracao:
    while not eof (arqProsodia) do
        begin
           readln (arqProsodia, s);
           if (s = '') or (s[1] = '*') or (s[1] = ';') then
               continue;
           if s[1] = '[' then break;

           maxFon := maxFon + 1;
           with tabDur [maxFon] do
               begin
                   p := pos ('=', s);
                   if p = 0 then
                       begin
                           showMessage ('Configuração da prosódia: fonema errado: ' + s);
                           goto fim;
                       end;
                   dif := trim (copy (s, 1, p-1));
                   try
                       dur := strToInt (trim (copy (s, p+1, 999)));
                   except
                       showMessage ('Configuração da prosódia: fonema errado: ' + s);
                       dur := 100;
                   end;
               end;
        end;

    closeFile (arqProsodia);

{---------------------------}

    reset (arqProsodia);
    while not eof (arqProsodia) do
        begin
            readln (arqProsodia, s);
            if trim(s) = '[CHAVES]' then goto achouChaves;
        end;

    showMessage ('Prosódia: palavras chaves ausentes');
    goto fim;

achouChaves:
    while not eof (arqProsodia) do
        begin
           readln (arqProsodia, s);
           if (s = '') or (s[1] = ';') or (s[1] = '*') then
               continue;
           if s[1] = '[' then break;

           maxChaves := maxChaves + 1;
           with tabChaves [maxChaves] do
               begin
                   p := pos ('=', s);
                   if p = 0 then
                       begin
                           showMessage ('Configuração da prosódia: chave errada: ' + s);
                           goto fim;
                       end;
                   palavra := ansiUppercase (trim (copy (s, 1, p-1)));
                   funcao := ansiUppercase (trim (copy (s, p+1, 999)));
               end;
        end;

    close (arqProsodia);
    ordenaChaves;

{---------------------------}

    reset (arqProsodia);
    while not eof (arqProsodia) do
        begin
            readln (arqProsodia, s);
            if trim(s) = '[PROSÓDIA]' then goto achouProsodia;
        end;

    showMessage ('Prosódia: especificações ausentes');
    goto fim;

achouProsodia:
    while not eof (arqProsodia) do
        begin
           readln (arqProsodia, s);
           if (s = '') or (s[1] = ';') or (s[1] = '*') then
               continue;
           if s[1] = '[' then break;
           s := ansiUpperCase (s);

           if copy (s, 1, 6) = 'HERTZ=' then
               begin
                   delete (s, 1, 6);
                   s := trim (s);
                   hertz := strToInt (s);
                   continue;
               end;

           if copy (s, 1, 9) = 'TABHERTZ=' then
               begin
                   delete (s, 1, 9);
                   s := s + ',';
                   for c := '0' to '9' do
                       begin
                           p := pos (',', s);
                           tabHertz[c] := strToInt (trim(copy (s, 1, p-1)));
                           delete (s, 1, p);
                       end;
                   continue;
               end;

           maxProsodia := maxProsodia + 1;
           with tabProsodia [maxProsodia] do
               begin
                   p := pos ('=', s);
                   if p = 0 then
                       begin
                           showMessage ('Configuração da prosódia: chave errada: ' + s);
                           exit;
                       end;

                   codificacao := trim (copy (s, p+1, 999));
                   sequencia := trim (copy (s, 1, p-1)) + '|||';

                   p := pos ('|', sequencia);
                   codAnt := copy (sequencia, 1, p-1);
                   delete (sequencia, 1, p);
                   p := pos ('|', sequencia);
                   codAtual := copy (sequencia, 1, p-1);
                   delete (sequencia, 1, p);
                   p := pos ('|', sequencia);
                   codProx := copy (sequencia, 1, p-1);
               end;
        end;

    inicProsodia := true;
fim:
    closeFile (arqProsodia);
end;

{--------------------------------------------------------}

procedure fimProsodia;
begin
    lista_difones.Free;
    lista_difones := NIL;
end;

{--------------------------------------------------------}

function preProsodia (texto: string): TStringList;
const
   alfabeto: set of char =
        ['A','E','I','O','U','À','Á','Â','Ã','É','Ê','Ì','Í','Ó','Ô','Õ','Ù','Ú','Ü',
         'a','e','i','o','u','à','á','â','ã','é','ê','ì','í','ó','ô','õ','ù','ú','ü',
         'b'..'d','f'..'h','j'..'n','p'..'t','v'..'z', 'ç', 'ñ',
         'B'..'D','F'..'H','J'..'N','P'..'T','V'..'Z', 'Ç', 'Ñ'];

   fimDeFrase: set of char = ['.', '!' , '?'];

var pt: integer;
    saida: TStringList;
    pal: string;
    e_especial: boolean;
    ch: str2;

    procedure pegaPalavra (var palavra: string; var especial: boolean);
    var s: string;
    begin
        s := '';
        especial := true;
        while (pt <= length (texto)) and (texto[pt] = ' ') do
            pt := pt + 1;

        if (pt < length (texto)) and
                 (texto[pt] = '.') and (texto[pt+1] = '.') then
            begin
                palavra := '.-';
                while (pt <= length (texto)) and (texto[pt] = '.') do
                    pt := pt + 1;
                exit;
            end;

        if (pt <= length (texto)) and (not (texto[pt] in alfabeto)) then
            begin
                palavra := texto[pt] + texto[pt];
                especial := true;
                pt := pt + 1;
                exit;
            end;

        while (pt <= length (texto)) and (texto[pt] in alfabeto) do
            begin
                s := s + texto[pt];
                pt := pt + 1;
            end;

        palavra := s;
        especial := false;
    end;

begin
    pt := 1;
    saida := TStringList.Create;
    saida.add ('[--]');   { início de frase normal }

    while pt <= length (texto) do
        begin
            pegaPalavra (pal, e_especial);
            if pal = '' then break;

            if e_especial then
                begin
                    ch := pal;
                    pal := ch[1];
                end
            else
                begin
                    ch := buscaChave(pal);
                    if ch = '' then
                        ch := 'XX';
                end;

            saida.Add ('[' + ch + ']' + pal);
            if (pal <> '') and (pal[1] in fimDeFrase) then
                begin
                   saida.Add ('[--]');
                end;
        end;

    preProsodia := saida;
end;

{--------------------------------------------------------}

function calculaCurvaProsodia (palavrasComCodigos: TStringList;
                               comProsodia:boolean): TStringList;
var s0, s, sp, cod: string;
    cAnt, cAtual, cProx: str2;
    i, ult, pr: integer;
    ultValor: char;
    listaComCurva: TStringList;

begin
    s  := '';
    sp := '';
    ultValor := '5';
    listaComCurva := TStringList.create;

    ult := palavrasComCodigos.count-1;
    for i := 0 to ult+1 do
        begin
            if (i <= ult) and (palavrasComCodigos[i] = '') then continue;

            s0 := s;
            s := sp;
            if i > ult then sp := ''
                       else sp := palavrasComCodigos[i];

            if s = '' then continue;

            cAnt   := copy (s0, 2, 2);
            cAtual := copy (s , 2, 2);
            cProx  := copy (sp, 2, 2);

            cod := '';
            if comProsodia then
                begin
                    for pr := 1 to maxProsodia do
                        with tabProsodia[pr] do
                            begin
                                if ((codAnt   = '') or (codAnt   = cAnt  )) and
                                   ((codAtual = '') or (codAtual = cAtual)) and
                                   ((codProx  = '') or (codProx  = cProx )) then
                                        begin
                                            cod := codificacao;
                                            break;
                                        end;
                            end;
                end;

            if cod = '' then
                cod := '555'
            else
            if cod[1] = '?' then
                cod[1] := ultValor;

            ultValor := cod[3];
            listaComCurva.add (cod + '|' + copy (s, 5, 999));
        end;

    calculaCurvaProsodia := listaComCurva;
end;

{--------------------------------------------------------}

procedure aplicaProsodia (fonemas: TStringList; var mbrolaCmd: TStringList;
                          perc_duracao, perc_pitch: real);
var i: integer;
    s, prosodia: string;
    duracao, amplif: integer;
    cod: str3;
    estado: (inicio, estavel, tonica, fim);
    ultimaLetra: boolean;
    tamanho, index: integer;

label guarda;

    function calculaProsodia: string;
    var pitch, h: integer;
        posic: integer;
    begin
        calculaProsodia := '';

        h := 0;
        posic := 0;
        case estado of
            inicio:   begin
                          h := tabHertz[cod[1]];
                          posic := 50;
                          estado := estavel;
                      end;

            tonica:   begin
                          h := tabHertz[cod[2]];
                          posic := 80;
                          estado := fim;
                      end;

            fim:      if ultimaLetra then
                          begin
                              h := tabHertz[cod[3]];
                              posic := 50;
                          end;
        end;

        if h <> 0 then
            begin
                pitch := trunc (perc_pitch * h * hertz) div 100;
                calculaProsodia := intToStr(posic) + ' ' + intToStr(pitch);
            end;
    end;


    procedure checaDifonesErrados;
    begin
        (* Nota: eventualmente tem que colocar um y depois de
                 lh  m  nh  r  rr  z   *)

            if (dif_atual <> '') then
                begin
                    if not lista_difones.Find(ult_dif + '-' + dif_atual, index) then
                        begin
                            if (ult_dif = 'r2') and
                               (lista_difones.Find(ult_dif + '-' + '_', index)) then
                                mbrolaCmd.Add('_ 50')
                            else
                            if lista_difones.Find(ult_dif + '-' + 'y', index) then
                                mbrolaCmd.Add('y 50')
                            else
                                mbrolaCmd.Add('_ 50');
                        end;

                    if s <> '' then
                        ult_dif := dif_atual;
                end;
    end;


    function buscaDuracao (s: string): integer;
    var f: integer;
    begin
        for f := 1 to maxFon do
            if s = tabDur[f].dif then
                begin
                    buscaDuracao := tabdur[f].dur;
                    exit;
                end;
        buscaDuracao := 100;
    end;


label deNovo;
begin
    mbrolaCmd := TStringList.create;
    amplif := 100;
    cod := '555';
    estado := inicio;
    tamanho := 0;
    ult_dif := '_';

    for i := 0 to fonemas.count-1 do
        begin
deNovo:
            prosodia := '';

            s := fonemas[i];
            ultimaLetra := (i = fonemas.count-1) or (fonemas[i+1] = '');

            if s = '' then
                begin
                    amplif := 100;
                    dif_atual := s;
                    goto guarda;
                end;

            if (copy (s, 1, 1) = ';') and (copy (s, 5, 1) = '|') then
                begin
                    cod := copy (s, 2, 3);
                    delete (s, 2, 4);
                    tamanho := length (s);
                    estado := inicio;
                    goto guarda;
                end;

            if s[1] = '>' then
                begin
                     amplif := 145;
                     delete (s, 1, 1);
                     if (s <> '') and (s[1] = '¨') then
                         delete (s, 1, 1);
                     estado := tonica;
                end
            else
                if s[1] = '¨' then
                     begin
                         delete (s, 1, 1);
                         amplif := 100;
                     end;

            if s[1] = '_' then
                begin
                    if length (s) = 1 then s := '_ 100';
                    if s[2] = ' ' then
                        duracao := strToInt (trim (copy(s, 3, 999)))
                    else
                        duracao := buscaDuracao (s);
                    s := '_';
                end
            else
                begin
                    duracao := buscaDuracao (s);
                    if estado < tonica then
                    if tamanho > 13 then
                        duracao := duracao * 80 div 100
                    else
                        if tamanho > 9 then
                            duracao := duracao * 90 div 100;
                end;

            dif_atual := s;
            duracao := trunc (duracao * amplif * perc_duracao) div 100;
            s := dif_atual + ' ' + intToStr (duracao);

            prosodia := calculaProsodia;
            if prosodia <> '' then
                 s := s + ' ' + prosodia;

    guarda:
            checaDifonesErrados;
            mbrolaCmd.Add (s);
        end;
end;

end.

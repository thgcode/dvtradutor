unit uttsPreproc;

interface
uses sysUtils;

function inicAbrev (nomeArqAbrev: string): boolean;
function soletragem (c: char): string;
function preProcessa (texto: string): string;

{--------------------------------------------------------}

implementation

type strNome = string [20];

const
    tabUnid: array [0..9] of strNome =
          ('zero', 'um', 'dois', 'tr�s', 'quatro',
           'cinco', 'seis', 'sete', 'oito', 'nove');

    tabDez: array [0..9] of strNome =
          ('dez','onze','doze','treze','quatorze',
           'quinze','dezesseis','dezessete','dezoito','dezenove');

    tabDezena: array [2..9] of strNome =
          ('vinte','trinta','quarenta','cinq�enta',
           'sessenta','setenta','oitenta','noventa');

    tabCentena: array [0..9] of strNome =
          ('cem','cento','duzentos','trezentos','quatrocentos','quinhentos',
           'seiscentos','setecentos','oitocentos','novecentos');

    tabMil: array [0..4] of strNome =
          ('trilh�o ','bilh�o ','milh�o ','mil ','');

    tabMils: array [0..4] of strNome =
          ('trilh�es ','bilh�es ','milh�es ','mil ','');

    e: strNome = ' e ';

    traco = 'tra�o';

var
    nabrevs: integer;
    tabAbrev: array [1..2000] of record
         abrev: string;
         expandido: string;
    end;

{--------------------------------------------------------}

function inicAbrev (nomeArqAbrev: string): boolean;
var
    arqAbrevs: text;
    s: string;
    p: integer;
begin
    nabrevs := 0;
    inicAbrev := false;
    if fileExists (nomeArqAbrev) then
        begin
            assign (arqAbrevs, nomeArqAbrev);
            reset (arqAbrevs);
            if ioresult <> 0 then exit;

            while not eof (arqAbrevs) do
                begin
                    readln (arqAbrevs, s);
                    s := trim (s);
                    if (s = '') or (s[1] = ';') then continue;

                    p := pos ('=', s);
                    nabrevs := nabrevs + 1;
                    tabAbrev[nabrevs].abrev := AnsiUpperCase (trim (copy (s, 1, p-1)));
                    tabAbrev[nabrevs].expandido := trim (copy (s, p+1, 999));
                end;

            inicAbrev := true;
        end;
end;

{--------------------------------------------------------}

function numeroParaString (v: int64): string;
var num, s: string;
    posConector: boolean;

    {--------------------------------------------------------}

    function convmil (s: strNome): string;
    var conv: string;
    label fim;
    begin
        conv := '';

        if s = '000' then
            goto fim;

        if s = '100' then
            begin
               conv := tabCentena [0];
               goto fim;
            end;

        if s[1] <> '0' then
            begin
                conv := tabCentena [ord(s[1]) - ord('0')];
                if copy (s, 2, 2) = '00' then
                    goto fim;
                conv := conv + e;
                posConector := true;
            end;

        if s[2] = '1' then
            begin
                conv := conv + tabDez [ord(s[3]) - ord('0')];
                goto fim;
            end;

        if s[2] <> '0' then
            begin
                conv := conv + tabDezena [ord(s[2]) - ord('0')];
                if copy (s, 3, 1) = '0' then
                    goto fim;
                conv := conv + e;
                posConector := true;
            end;


        if s[3] > '0' then
            conv := conv + tabUnid [ord(s[3]) - ord('0')];

    fim:
        convMil := conv;
    end;

    {--------------------------------------------------------}

    function conv3 (s: string; i: integer): string;
    var conv: string;
        tresdig: strNome;

    begin
        tresdig := copy (s, 1+i*3, 3);
        conv := convmil (tresdig);
        if tabMil [i] <> '' then
           if tresdig <> '000' then
               if tresdig = '001' then
                   conv := conv + ' ' + tabMil [i]
               else
                   conv := conv + ' ' + tabMils [i];

        conv3 := conv;
    end;

    {--------------------------------------------------------}

var
    i, ultMilhar: integer;
    smils: array [0..4] of string;
    conect : strNome;

begin
    if v = 0 then
        begin
            numeroParaString := tabUnid [0];
            exit;
        end;

    str (v, num);
    num := '00000000000000' + num;
    num := copy (num, length(num)-14, 15);
    s := '';

    ultMilhar := 4;

    for i := 0 to 4 do
        begin
            smils[i] := conv3 (num, i);
            if smils[i] <> '' then
                ultMilhar := i;
        end;

    conect := '';
    for i := 0 to ultMilhar do
        begin
            posConector := false;

            if (i = ultMilhar) and (smils [i] <> '') and (not posconector) then
                s := s + conect + smils[i]
            else
                s := s + smils[i];

            if smils[i] <> '' then    // esta heur�stica n�o est� boa
                conect := 'e ';
        end;

    if (copy (s, 1, 6) = 'um mil') and (copy (s, 1, 7) <> 'um milh') then
         delete (s, 1, 3);

    numeroParaString := s;
end;

{--------------------------------------------------------}

function numeroFeminino (s: string): string;
begin
    if copy (s, length(s)-1, 2) = 'um' then
       numeroFeminino := s + 'a'
    else

    if copy (s, length(s)-3, 4) = 'dois' then
        numeroFeminino := copy (s, 1, length(s)-4) + 'duas'

    else
        numeroFeminino := s;
end;

{--------------------------------------------------------}

function ordinal(n: int64; genero: char): string;
const
    tab_ordinais_1: array [1..9] of string = (
         'primeiro', 'segundo', 'terceiro', 'quarto', 'quinto',
         'sexto', 's�timo', 'oitavo', 'nono'
    );
    tab_ordinais_10: array [1..9] of string = (
         'd�cimo',  'vig�simo', 'trig�simo', 'quadrag�simo', 'quinquag�simo',
         'sexag�simo', 'septuag�simo ', 'octag�simo', 'nonag�simo'
    );
    tab_ordinais_100: array [1..9] of string = (
         'cent�simo', 'ducent�simo', 'tricent�simo', 'quadrigent�simo',
         'quingent�simo', 'seiscent�simo', 'septigent�simo', 'octigent�simo',
         'nongent�simo'
    );
    milesimo: string = 'mil�simo';

var
    trad: string;
    v: integer;

    function trataFeminino (s: string): string;
    begin
        if genero = 'f' then
            begin
                delete (s, length(s), 1);
                s := s + 'a';
            end;
        trataFeminino := s;
    end;

begin
    if n >= 2000 then
        begin
            ordinal := '' + numeroParaString (n);
            exit;
        end;

    if n = 0 then
        begin
            ordinal := 'zero';
            exit;
        end;

    v := n mod 10;
    n := n div 10;
    if v > 0 then
        trad := trataFeminino (tab_ordinais_1[v]) + ' ' + trad;

    v := n mod 10;
    n := n div 10;
    if v > 0 then
        trad := trataFeminino (tab_ordinais_10[v]) + ' ' + trad;

    v := n mod 10;
    n := n div 10;
    if v > 0 then
        trad := trataFeminino (tab_ordinais_100[v]) + ' ' + trad;

    v := n mod 10;
    if v > 0 then
        trad := trataFeminino (milesimo) + ' ' + trad;

    ordinal := trim (trad);
end;

{--------------------------------------------------------}

function numeroParaTexto (texto: string; var i: integer): string;
var inicio, saida: string;
    j: integer;
    n: int64;
    soletra: boolean;
label numeral;


begin
    saida := '';

    soletra := false;
    j := i;
    while j <= length (texto) do
        begin
            if texto[j] = '-' then
                soletra := true
            else
            if not (texto[j] in ['0'..'9']) then
                break;
            j := j + 1;
        end;

    if soletra then
        begin
            while i < j do
                begin
                    if texto[i] = '-' then
                        saida := saida + ' ' + TRACO
                    else
                        saida := saida + ' ' + tabUnid[ord(texto[i]) - ord('0')];
                    i := i + 1;
                end;
            result := saida;
            exit;
        end;

    n := 0;
    inicio := '';
    while (i < length (texto)) and (texto[i] = '0') and
                                   (texto[i+1] in ['0'..'9']) do
        begin
            inicio := inicio + tabUnid[0] + ' ';
            i := i + 1;
        end;

    for j := i to length (texto) do
        begin
            if texto[j] in ['0'..'9'] then
                begin
                    if n < 1000000000000000 then
                        n := (n * 10) + (ord(texto[j]) - ord('0'))
                    else
                        break;
                end
            else
            if (length(texto) >= j+3) and (texto[j] = '.') and
                (texto[j+1] in ['0'..'9']) and
                (texto[j+2] in ['0'..'9']) and
                (texto[j+3] in ['0'..'9']) and
                (  (length(texto) = j+3) or
                   (not (texto[j+3] in ['0'..'9']))) then
                    continue
            else
                 break;
            i := j+1;
        end;


    if (i > length(texto)) or (texto[i] = ' ') then
        goto numeral;

    { --- ordinais --- }

    if (texto[i] = '�') then
         begin
            numeroParaTexto := ordinal(n, 'm');
            i := i + 1;
            exit;
         end;

    if (texto[i] = '�') then
         begin
            numeroParaTexto := ordinal(n, 'f');
            i := i + 1;
            exit;
         end;

    if copy (texto, i, 2) = 'o.' then
         begin
            numeroParaTexto := ordinal(n, 'm');
            i := i + 2;
            exit;
         end;

    if copy (texto, i, 2) = 'a.' then
         begin
            numeroParaTexto := ordinal(n, 'f');
            i := i + 2;
            exit;
         end;

    if copy (texto, i, 3) = 'os.' then
         begin
            numeroParaTexto := ordinal(n, 'm') + 's';
            i := i + 3;
            exit;
         end;

    if copy (texto, i, 3) = 'as.' then
         begin
            numeroParaTexto := ordinal(n, 'f') + 's';
            i := i + 3;
            exit;
         end;

    { --- numeral --- }

numeral:
    numeroParaTexto := inicio + numeroParaString (n);
end;

{--------------------------------------------------------}

function soletragem (c: char): string;
const
    nomesLetras: array [' '..'~'] of string = (
        { } 'espa�o',
        {!} 'exclama��o',
        {"} 'aspas',
        {#} 'sustenido',
      { $ } 'cifr�o',
        {%} 'porcento',
        {&} '� comercial',
        {'} 'ap�strofo',
        {(} 'abre par�nteses',
        {)} 'fecha par�nteses',
        {*} 'asterisco',
        {+} 'mais',
        {,} 'v�rgula',
        {-} 'tra�o',
        {.} 'ponto',
        {/} 'barra',

        'z�ro','um','dois','tr�s','quatro','cinco','seis','s�te','oito','n�ve',

        {:} 'dois pontos',
        {;} 'ponto e v�rgula',
        {<} 'menor que',
        {=} 'igual',
        {>} 'maior que',
        {?} 'interroga��o',
        {@} 'arr�ba',

        'a', 'b�',' s�',' d�','�','�fe','j�','ag�','i','j�ta','c�','�le','�me',
        '�ne','�','p�','qu�','�rre','�sse','t�','u','v�','d�bliu','xis','�psilon','z�',

        {[} 'abre colchete',
        {\} 'barra invertida',
        {]} 'fecha colchete',
        {^} 'circunflexo',
        {_} 'sublinhado',
        {`} 'crase',

        'a', 'b�',' s�',' d�','�','�fe','j�','ag�','i','jota','c�','�le','�me',
        'ene','�','p�','qu�','�rre','�sse','t�','u','v�','d�bliu','xis','�psilon','z�',

        { } 'abre chave',
        {|} 'barra vertical',
        { } 'fecha chave',
        {~} 'til'
    );

    nomesAcentuadas: array ['�'..'�'] of string = (

        {�}    'A grave',
        {�}    'A agudo',
        {�}    'A circunflexo',
        {�}    'A com til',
        {�}    'A com trema',
        {�}    'A bola',
        {�}    'A �',
        {�}    'C� cedilha',
        {�}    '� grave',
        {�}    '� agudo',
        {�}    '� circunflexo',
        {�}    '� com trema',
        {�}    'I grave',
        {�}    'I agudo',
        {�}    'I circunflexo',
        {�}    'I com trema',
        {�}    'D� cortado',
        {�}    'N com til',
        {�}    '� grave',
        {�}    '� agudo',
        {�}    '� circunflexo',
        {�}    '� com til',
        {�}    '� tremado',
        {�}    'vezes',
        {�}    '� cortado',
        {�}    'U grave',
        {�}    'U agudo',
        {�}    'U circunflexo',
        {�}    'U com trema'
    );

    nomesEspeciais: array [#$A1..#$BF] of string = (
        {�}    'exclama��o reversa',
        {�}    'centavos de d�lar',
        {�}    'libras',
        {�}    's�mbolo de moeda',
        {�}    'iene',
        {�}    'barra interrompida',
        {�}    'par�grafo',
        {�}    'trema',
        {�}    'copyright',
        {�}    'ordinal feminino',
        {�}    'Aspas angulares esquerdas',
        {�}    'nega��o',
        {�}    'h�fen',
        {�}    'Marca registrada',
        {�}    'm�cron',
        {�}    'grau',
        {�}    'mais ou menos',
        {�}    'elevado ao quadrado',
        {�}    'elevado ao cubo',
        {�}    'acento agudo',
        {�}    'mi',
        {�}    'pi',
        {�}    'ponto no meio',
        {�}    'cedilha',
        {�}    'expoente um',
        {�}    'ordinal masculino',
        {�}    'aspas angulares direitas',
        {�}    'um quarto',
        {�}    'um meio',
        {�}    'tr�s quartos',
        {�}    'interroga��o reversa'
    );

begin
    if c in [' '..'~'] then
        soletragem := nomesLetras [c]
    else
    if c in ['�'..'�'] then
        soletragem := nomesAcentuadas [c]
    else
    if c in [#$A1..#$BF] then
        soletragem := nomesEspeciais [c]
    else
    if ord (c) > $e0 then
        soletragem := soletragem (chr (ord (c) - 32))
    else
        soletragem := ' c�digo ' + numeroParaString (ord(c));
end;

{--------------------------------------------------------}

function buscaAbreviatura (palavra: string): string;
var i: integer;
begin
    for i := 1 to nabrevs do
        begin
            if AnsiUpperCase(palavra) = tabAbrev[i].abrev then
                begin
                    buscaAbreviatura := tabAbrev[i].expandido;
                    exit;
                end;
        end;
    buscaAbreviatura := '';
end;

{--------------------------------------------------------}

function preProcessa (texto: string): string;
var
    i: integer;
    palavra, textoSai, abr: string;
const
    alfabeto: set of char =
        ['A','E','I','O','U','�','�','�','�','�','�','�','�','�','�','�','�','�','�',
         'a','e','i','o','u','�','�','�','�','�','�','�','�','�','�','�','�','�','�',
         'b'..'d','f'..'h','j'..'n','p'..'t','v'..'z', '�', '�',
         'B'..'D','F'..'H','J'..'N','P'..'T','V'..'Z', '�', '�'];

    pontuacoes: set of char =
        ['.', ',', '?', '!', ';', ':', '(', ')', ' '];

   consoante: set of char =
        ['b'..'d','f'..'h','j'..'n','p'..'t','v'..'z', '�', '�',
         'B'..'D','F'..'H','J'..'N','P'..'T','V'..'Z', '�', '�'];

         function pegaPalavra (var i: integer): string;
         var i0, k: integer;
             palavra: string;
             soConsoantes: boolean;
         begin
             i0 := i;
             soConsoantes := true;
             while (i <= length(texto)) and (texto[i] in alfabeto) do
                 begin
                     if not (texto[i] in consoante) then
                         soConsoantes := false;
                     i := i + 1;
                     if (i <= length(texto)) and (texto[i] = '-') then i := i + 1;
                 end;

             palavra := copy (texto, i0, i-i0);
             if soConsoantes and
                ((copy (texto, i, 1) <> '.') or (buscaAbreviatura (palavra) = '')) then
                 begin
                     palavra := '';
                     for k := i0 to i-1 do
                         palavra := palavra  + soletragem(texto[k]);
                 end;

             pegaPalavra := palavra;
         end;

begin
    if length (texto) = 1 then
        begin
            texto := soletragem(texto[1]);
        end;

    i := 1;
    textoSai := '';
    while i <= length (texto) do
        begin
            if copy (texto, i-1, 3) = ' - ' then
                begin
                    textoSai := textoSai + ',';
                    i := i + 1;
                end
            else
            if (texto[i] = '-') and (length(texto) > i) and
                (texto[i+1] in ['0'..'9']) then
                begin
                    textoSai := textoSai + 'menos ';
                    i := i + 1;
                end
            else
            if texto[i] in ['0'..'9'] then
                begin
                    textoSai := textoSai + numeroParaTexto (texto, i) + ' ';
                    while (i <= length(texto)-1) and
                         (( (texto[i] = ',') and (texto[i+1] in ['0'..'9']) )
                                              or (texto[i] = '.')) and
                           (texto[i+1] in ['0'..'9']) do
                        begin
                            if texto[i] = ',' then
                                textoSai := textoSai + 'v�rgula '
                            else
                            if texto[i] = '.' then
                                textoSai := textoSai + 'ponto ';
                            i := i + 1;
                            textoSai := textoSai + numeroParaTexto (texto, i) + ' ';
                        end;
                end
            else
            if texto[i] in alfabeto then
                begin
                    palavra := pegaPalavra (i);
                    if (i > length (texto)) or (texto[i] <> '.') then
                        textoSai := textoSai + palavra
                    else
                        if copy (texto, i, 2) = '. ' then
                            begin
                                abr := buscaAbreviatura (palavra);
                                if abr = '' then
                                    textoSai := textoSai + palavra
                                else
                                    begin
                                        textoSai := textoSai + abr;
                                        i := i + 1;
                                    end;
                            end
                        else
                            textoSai := textoSai + palavra;
                end
            else
            if copy (texto, i, 3) = '...' then
                begin
                    textoSai := textoSai + '...' + ' ';
                    i := i + 3;
                end
            else
                begin
                    if (texto[i] = '.') and
                       (i < length(texto)) and (copy (texto,i+1, 1) <> ' ') then
                        textoSai := textoSai + ' ' + soletragem(texto[i]) + ' '
                    else
                    if texto[i] in pontuacoes then
                        textoSai := textoSai + texto[i]
                    else
                        begin
                            if not (texto[i] in [#$0d, #$0a, #$09]) then
                                textoSai := textoSai + ' ' + soletragem(texto[i]) + ' ';
                        end;
                    i := i + 1;
                end;
        end;

(*
    textoSai := trim(textoSai);
    if (textoSai <> '') and
       (not (textoSai [length(textoSai)] in
             ['-', '.', ',', ';', ':', '?', '!', '(', ')'])) then
        textoSai := textoSai + '.';
*)

    preProcessa := textoSai;
end;

end.

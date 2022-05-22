{--------------------------------------------------------}
{   Converte numero para cadeia
{   Autor:  Jose' Antonio Borges
{   Em 30/12/94
{--------------------------------------------------------}

unit dvlenum;

interface
uses dvCrt, Windows, sysutils;

const
    MASCULINO = 0;
    FEMININO  = 1;

function numeroParaString (v: longint): string;
function numeroFeminino (s: string): string;
procedure falaNumeroConv (s: string; sexo: byte);

{--------------------------------------------------------}

implementation
uses dvWin, dvInter;

type strNome = string[20];
     str3 = string[3];

const
    tabUnid: array [0..9] of strNome =
          ('zero', 'um', 'dois', 'tres', 'quatro',
           'cinco', 'seis', 'sete', 'oito', 'nove');

    tabDez: array [0..9] of strNome =
          ('dez','onze','doze','treze','quatorze',
           'quinze','dezesseis','dezessete','dezoito','dezenove');

    tabDezena: array [2..9] of strNome =
          ('vinte','trinta','quarenta','cinquenta',
           'sessenta','setenta','oitenta','noventa');

    tabCentena: array [0..9] of strNome =
          ('cem','cento','duzentos','trezentos','quatrocentos','quinhentos',
           'seiscentos','setecentos','oitocentos','novecentos');

    tabMil: array [0..4] of strNome =
          ('trilhão ','bilhão ','milhão ','mil ','');

    tabMils: array [0..4] of strNome =
          ('trilhões ','bilhões ','milhões ','mil ','');

    e: string[3] = ' e ';

var posconector: boolean;

{--------------------------------------------------------}
{              transforma numero em cadeia
{--------------------------------------------------------}

function numeroParaString (v: longint): string;
var num, s: string;

{--------------------------------------------------------}

    function convmil (s: str3): string;
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
        tresdig: str3;

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
    conect : str3;

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

            if smils [i] <> '' then conect := 'e ';
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

procedure falaNumeroConv (s: string; sexo: byte);
const
    maxSom = 30000;
label fim;

var i: longint;
    cadeia: string;
    nomeSom: string;
    pvetSom: pchar;
    tamSom, ncVetSom: word;
    arqSom: file;

begin
    getmem (pvetSom, maxSom+TAMCABWAV);
    ncVetSom := 0;

    s := s + ' *';  { bandeirolas finais }
    i := 1;

    while i < (length (s)-1) do
        begin
            while s[i] = ' ' do
                i := i + 1;

            if i >= length (s) then goto fim;

            cadeia := '';
            while s[i] <> ' ' do
                begin
                    if s[i] = 'ã' then s[i] := 'a'
                    else
                    if s[i] = 'õ' then s[i] := 'o';

                    cadeia := cadeia + s[i];
                    i := i + 1;
                end;

            if cadeia = 'dezessete' then cadeia := 'dezeset';
                        { so' 7 letras, para nao confundir com dezesseis }

            cadeia := copy ('_' + cadeia, 1, 8);   { diretorio de letras }

            if (sexo = FEMININO) and (i > length(s) - 2) then
                begin
                    if cadeia = '_um' then cadeia := '_uma'
                    else
                    if cadeia = '_dois' then cadeia := '_duas';
                end;

            nomeSom := dirLetras + cadeia + '.wav';
            assign (arqSom, nomeSom);
            {$i-} reset (arqSom, 1); {$I+}
            if ioresult = 0 then
                begin
                    seek (arqSom, 44);
                    tamSom := filesize (arqSom) - 44;
                    if longInt (tamSom) + longInt (ncVetSom) > maxSom then
                        begin
                            geraCabWav (pchar(pvetSom), ncVetSom, 11025, 8, 1);
                            sintMem (pvetSom);
                            while sintFalando do waitMessage;
                            ncVetSom := 0;
                        end;

                    blockRead (arqSom, pvetSom[ncVetSom+TAMCABWAV], tamSom);
                    ncVetSom := ncVetSom + tamSom;
                end;
            {$I-}  close (arqSom);  {$I+}
            if ioresult <> 0 then;
        end;
fim:

    if ncVetSom <> 0 then
        begin
            geraCabWav (pchar(pvetSom), ncVetSom, 11025, 8, 1);
            sintMem (pvetSom);
            while sintFalando do waitMessage;
        end;

    freemem (pvetSom, maxSom+TAMCABWAV);
end;

end.

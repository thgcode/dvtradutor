{--------------------------------------------------------}
{
{   Sistema de Sintese da Fala
{
{   Funcao : A partir do texto compilado pelo modulo
{            traduvox, falar o texto
{
{   Autor  :  Jose' Antonio Borges
{   Data de criacao : Junho de 1994
{
{   Alterado por : Kelly Christine Correa
{   Data de Alteracao : outubro de 1994
{
{   Transcrito para Windows por Jose' Antonio Borges
{   Data de Alteracao: janeiro de 1998
{
{--------------------------------------------------------}

unit dvinter;
interface
uses windows, sysutils, dvtradut, dvcrt;

function tradInic: integer;
procedure tradFim;

procedure falaFonemas (fonemas: string; comPontuacao: boolean);
procedure paramFala (quanto, minimo, interv: integer);

var dirLetras, dirDifones: string [144];
var sintBDSom: string [8];

implementation

uses dvwin;

{--------------------------------------------------------}
{           modulo de interpretacao da fala
{--------------------------------------------------------}

const
    TAMBUFFALA = 64000;

const
    VOGAIS: set of char = ['a','e','i','o','u','w','y',
                           'A','E','I','O','U'];

    VOGAIS_MESMO: set of char = ['a','e','i','o','u',
                                'A','E','I','O','U'];

    CONSOANTES: set of char = ['b','c','d','f','g','j','k','l','m','n',
                               'p','q','r','s','t','v','x','z'];

    SEMIVOGAIS: set of char = ['y','w'];

    ACENTOS: set of char = ['~', '^'];

type
    INFODIFONE = packed record
        nomedifo: string[8];
        tamdifo: word;
        posdifo: longint;
    end;

    TABDIFONES = array [0..2000] of INFODIFONE;

    stringPeq = string[40];
    stringuinha = string[12];

var
    tabDifo: ^TABDIFONES;
    tamTabDifo: integer;

    arqDifones: integer;

    pf: integer;
    silabaForte: integer;

    intPonto, intVirgula, intPtVirgula, intDoisPontos: integer;

    intervalo: integer;
    quantoCorta, minimoResto: integer;

    tamFalaFinal: longint;

    hsom: THandle;
    pvetSom: pchar;
    Pant: pchar;
    TamArqAnt: word;

{-------------------------------------------------------------}
{              descarrega fala até ali
{-------------------------------------------------------------}

procedure descarregaFala;
begin
    if tamFalaFinal = TAMCABWAV then exit;   // dados ainda não inicializados

    geraCabWav (pchar(pvetSom), tamFalaFinal-TAMCABWAV, 11025, 8, 1);
    sintMem (pvetSom);

    tamFalaFinal := TAMCABWAV;
end;

{-------------------------------------------------------------}
{              checa se cabe no buffer de fala
{-------------------------------------------------------------}

procedure checaTamFala (tam: integer);
begin
    if tamFalaFinal+tam >= TAMBUFFALA then
         begin
             descarregaFala;
             while sintFalando do waitMessage;
         end;
end;

{--------------------------------------------------------}
{                     trata silencio
{--------------------------------------------------------}

Procedure silencio (espaco: integer);
var i: integer;
    som: array [0..99] of byte;
begin
    fillchar (som, 100, $80);
    for i := 1 to espaco div 100 do
        begin
            checaTamFala (100);
            move (som, pvetSom[tamFalaFinal], 100);
            tamFalaFinal := tamFalaFinal + 100;
        end;
end;

{--------------------------------------------------------}
{           carrega o buffer de fala do arquivo
{--------------------------------------------------------}

procedure falaRuido;
const
    TAMRUIDO = 300;
var
    i: integer;
    som: array [0..TAMRUIDO-1] of byte;

begin
    checaTamFala (TAMRUIDO);
    for i := 0 to TAMRUIDO-1 do
        som[i] := $80 + random(80) - 40;
    move (som, pvetSom[tamFalaFinal], TAMRUIDO);
    tamFalaFinal := tamFalaFinal + TAMRUIDO;
end;

{--------------------------------------------------------}

function processaCabWave (arq: integer): integer;
var
    buf: array [0..100] of char;
    size: longint;
    transf: integer;
    achou: boolean;

begin
    processaCabWave := 0;
    buf[0] := 'x';

    fileRead (arq, buf, 12);              { checa cabeçalho RIFF }
    if strlicomp (buf, pchar('RIFF'), 4) <> 0 then exit;
    fileRead (arq, buf, 8);                 { checa fmt }
    if strlicomp (buf, 'fmt ', 4) <> 0 then exit;

    move (buf[4], size, 4);
    transf := fileRead (arq, buf, size);   { checa fmt }
    if size <> transf then exit;

    repeat
        transf := fileRead (arq, buf, 8);     { ignora chunks até data }
        if transf < 8 then exit;
        achou := strlicomp (buf, 'data', 4) = 0;
        move (buf[4], size, 4);
        if not achou then
            begin
               transf := fileRead (arq, buf, size);     { checa fmt }
               if size <> transf then exit;
            end;
    until achou;

    processaCabWave := size;
end;

{--------------------------------------------------------}

function falaLetra (nomearq: stringuinha): boolean;
var arq: integer;
    tamArq: word;
    Pmem: pchar;
const
    tamMaxLetra = 64000;

begin
    falaLetra := false;

    arq := fileOpen (dirLetras + nomearq+'.wav', fmOpenRead or fmShareDenyNone);
    if arq > 0 then
        begin
            tamArq := processaCabWave (arq);
            if tamArq = 0 then
                begin
                    fileClose (arq);
                    exit;
                end;

            getmem (PMem, TamMaxLetra);
            tamArq := fileRead (arq, Pmem^, tamArq) ;

            checaTamFala (TamArq);
            move (pmem^, pvetSom[tamFalaFinal], TamArq);
            tamFalaFinal := tamFalaFinal + tamArq;
            fileClose (arq);

            freemem (PMem, TamMaxLetra);
            falaLetra := true;
        end;
end;

{--------------------------------------------------------}

function falaDifone (nomearq: stringuinha; silabaForte: integer;
                     perc: real): boolean;
var
    inicio, fim, indTab: integer;
    tamArq, i: integer;
    posArq: longint;
    Pmem: pchar;

label achou;

begin
    for i := 1 to length (nomearq) do
         nomearq[i] := upcase (nomearq[i]);

    falaDifone := true;
    inicio := 0;
    fim := tamTabDifo;
    indTab := 0;

    while (inicio <= fim) do
        begin
            indTab := (inicio + fim) div 2;

            with tabDifo^[indTab] do
                begin
                    if nomeDifo = nomearq then
                        goto achou;
                    if nomearq > nomeDifo then
                        inicio := indTab+1
                    else
                        fim := indTab-1;
                end;
        end;

    falaDifone := false;
    exit;

achou:
    with tabDifo^[indTab] do
        begin
            posArq := posDifo;
            TamArq := tamDifo;

            if (silabaForte < 2) and (length (nomearq) > 2) then
                begin
                    tamArq := tamDifo - quantocorta;
                    if (tamArq < minimoResto) then
                        if tamDifo < minimoResto then
                            tamArq := tamDifo
                        else
                            TamArq := minimoResto;

                end;

            fileSeek (arqDifones, posArq, 0);
            tamArq := trunc (tamArq * perc);

            getmem (pmem, TamArq);
            fileRead (arqDifones, Pmem^, TamArq);

            checaTamFala (TamArq);
            move (pmem^, pvetSom[tamFalaFinal], TamArq);
            tamFalaFinal := tamFalaFinal + TamArq;

            freemem (pmem, TamArq);
        end;
end;

{--------------------------------------------------------}

Procedure CarregaBufFala (nomearq: stringuinha;
                          Perc: real; silabaForte: integer);
var
    leu: boolean;
    vogal: char;

begin
    if nomearq [1] = '_' then
        leu := falaLetra (nomearq)
    else
        leu := falaDifone (nomearq, silabaForte, perc);

    if (not leu) and (length (nomearq) <= 2) then
        begin
            falaRuido;     { nao houve jeito de sintetizar }
            exit;
        end;

    if not leu then   { se nao existe difone, sintetiza mais ou menos }
        begin
            if nomearq [length (nomearq)] in VOGAIS then
                 begin
                     carregaBufFala (copy (nomearq, 1, length(nomearq)-1),
                                                    Perc*0.9, silabaForte);
                     carregaBufFala ('$'+nomearq[length(nomearq)],
                                                    Perc, silabaForte);
                     exit;
                 end;

            if (copy (nomearq, length (nomearq)-3, 4) = 'CIRC') and
                     (length (nomearq) > 6) then
                begin
                    CarregaBufFala (copy (nomearq, 1, length (nomearq)-5),
                                                   perc*0.9, silabaForte);
                    carregaBufFala ('$'+ copy (nomearq,
                                   length (nomearq)-4, 5), Perc, silabaForte);
                    exit;
                end;

            if copy (nomearq, length (nomearq)-2, 3) = 'TIL' then
                begin
                    nomearq := copy (nomearq, 1, length(nomearq)-3);
                    vogal := upcase (nomearq [length (nomearq)]);
                    if (vogal = 'I') or (vogal = 'U') then
                        carregaBufFala (nomearq, Perc*0.9, silabaForte)
                    else
                        carregaBufFala (nomearq+'CIRC', Perc*0.9, 2);

                    carregaBufFala ('$nn', 0.9, 1);
                    exit;
                end;
       end;
end;

{--------------------------------------------------------}
{         seleciona arquivos para carga na memoria
{--------------------------------------------------------}

const
    MAIUSCULAS: set of char = ['A','E','I','O','U'];

Procedure CarregaFala (s: stringuinha; Perc: real);
var
    i: integer;
    nomearq: stringuinha;
    tonica: boolean;
begin
    tonica := false;

    nomearq := '$';
    if s[1] = '_' then
        begin
            str (ord(s[2]), nomearq);
            nomearq := '_' + nomearq;
        end
    else
        for i := 1 to length (s) do
            begin
                if (s[i] in MAIUSCULAS) then
                    begin
                        tonica := true;
                        silabaForte := 2;   { para garantir dois acentos }
                    end;

                case s[i] of
                    '^' :  begin
                             carregaBufFala (nomearq+'CIRC', Perc, silabaForte);
                             nomearq := '$';
                           end;

                    '~' :  begin
                             carregaBufFala (nomearq+'TIL', Perc,silabaForte);
                             nomearq := '$';
                           end;
                else
                    nomearq := nomearq + s[i];
                end;

    end;

    if nomearq <> '$' then
        carregaBufFala (nomearq, Perc, silabaForte);

    if tonica then
        silabaForte := 0;
end;

{--------------------------------------------------------}
{    traduz do fonema compilado para nome de arquivos
{--------------------------------------------------------}

procedure traduzSilaba (s: stringPeq; Perc: real);
begin
    if (length (s) = 0) then exit;

    if length (s) = 1 then
        begin
            carregaFala (s, Perc);
            exit;
        end;

    if length (s) > 2 then
        begin
            if (s[1] in CONSOANTES) and (s[2] in CONSOANTES) then
                begin
                    if (copy (s, 1, 2) <> 'dj') and
                       (copy (s, 1, 2) <> 'nh') and
                       (copy (s, 1, 2) <> 'rr') and
                       (copy (s, 1, 2) <> 'ks') and
                       (copy (s, 1, 3) <> 'tch') then
                       begin
                           carregaFala (s[1], 1.0);
                           traduzSilaba (copy (s, 2, length(s)-1),Perc);
                           exit;
                       end;
                end;

            if copy (s, length(s)-1, 2) = 'rr' then
                begin
                    traduzSilaba (copy (s, 1, length(s)-2),Perc);
                    carregaFala ('rr',Perc);
                    exit;
                end;

            if s[length(s)] in CONSOANTES then
                begin
                    traduzSilaba (copy (s, 1, length(s)-1),Perc);
                    traduzSilaba (s[length(s)],Perc);
                    exit;
                end;
        end;

    if s[length(s)] in SEMIVOGAIS then
        begin
            if s[length(s)-1] in VOGAIS then
                begin
                    if length (s) > 2 then
                        begin
                            traduzSilaba (copy (s, 1, length(s)-1), 0.6);
                            CarregaFala (copy (s, length(s)-1, 2), Perc);
                            exit;
                        end;
                end;

            if s[length(s)-1] in ACENTOS then
                if length (s) > 3 then
                    begin
                        if s [length(s)-1] = '~' then
                            traduzSilaba (copy (s, 1, length(s)-2)+'^', 0.6)
                        else
                            traduzSilaba (copy (s, 1, length(s)-1), 0.6);
                        carregaFala (s[length(s)-2]+s[length(s)]
                                     +s[length(s)-1],Perc);
                        exit;
                    end
                else
                    begin
                        carregaFala (s[1]+s[3]+s[2],Perc);
                        exit;
                    end;

        end;

    if (s <> '_s') and (s[length(s)] = 's') then
        begin
            traduzSilaba (copy (s, 1, length(s)-1), 0.7);
            carregaFala ('s',Perc);
            exit;
        end;

    CarregaFala (s, Perc);
end;

{--------------------------------------------------------}
{                   rotina geral de fala
{--------------------------------------------------------}

procedure falaFonemas (fonemas: string; comPontuacao: boolean);

{--------------------------------------------------------}

    function isolaSilaba: stringPeq;
    var s: stringPeq;
        pequeno: boolean;
    begin
        if fonemas [pf] = '[' then
            begin
                silabaForte := 1;
                pf := pf + 1;
            end;

        s := '';
        pequeno := true;
        while (not (fonemas [pf] in [ ']', ' '])) and pequeno do
            begin
                case fonemas [pf] of
                    '_':  begin
                              pf := pf + 1;
                              s := s + '_' + fonemas [pf];
                          end;

                    '|':  s := '_TRACO';

                    '/':  begin
                              pequeno := length (s) <= 8;
                              if not pequeno then pf := pf - 1;
                          end;
                else
                          s := s + fonemas [pf];
                end;

                pf := pf + 1;
            end;

        pf := pf + 1;

        if (not comPontuacao) and (s[1] = '_') and (length(s) = 2) then
                case s[2] of
                    ',':  begin
                              s := '';  silencio (intVirgula);
                          end;

                    '.':  begin
                              s := '';  silencio (intPonto);
                          end;

                    ';':  begin
                              s := '';  silencio (intPtVirgula);
                          end;

                    ':':  begin
                              s := '';  silencio (intDoisPontos);
                          end;
                end;

        isolaSilaba := s;
    end;

{--------------------------------------------------------}

var fon: stringPeq;

begin
    tamFalaFinal := TAMCABWAV;

    pf := 1;
    silabaForte := 1;
    Pant := nil;
    tamArqAnt := 0;

    While pf <= length (fonemas) do
        begin
            fon := isolaSilaba;
            traduzSilaba (fon, 1.0);

            if (pf <= length (fonemas)) and (pf > 1) and
               (fonemas[pf-1] <> ' ') then
                 silencio (intervalo);
        end;

    descarregaFala;
end;

{--------------------------------------------------------}
{               inicializa os diretorios
{--------------------------------------------------------}

function inicFonemas: boolean;
var dir, dirDiscoLetras: string;
    arqIndice: file;
    tamArq: longint;

label fim;

begin
    tabDifo := NIL;
    inicFonemas := false;

    getdir (0, dir);

    dirLetras[0] := chr (GetPrivateProfileString ('TRADUTOR', 'dirLetras',
          '', @dirLetras[1], 80, pchar(dosvoxIniDir+'\dosvox.ini')));

    {$I-}  chdir (copy (dirLetras, 1, 2)); {$I+}
    if ioresult <> 0 then;
    getdir (0, dirDiscoLetras);

    {$I-} chdir (dirLetras); {$I+}
    if ioresult <> 0 then
        goto fim;
    if dirLetras [length (dirLetras)] <> '\' then
        dirLetras:= dirLetras + '\';

    dirDifones[0] := chr (GetPrivateProfileString ('TRADUTOR', 'DIRDIFONES',
          'c:\winvox\som\difones', @dirDifones[1], 80, pchar(dosvoxIniDir+'\dosvox.ini')));
    {$I-} chdir (dirDifones); {$I+}
    if ioresult <> 0 then
        goto fim;
    if dirDifones [length (dirDifones)] <> '\' then
        dirDifones:= dirDifones + '\';

    assignFile (arqIndice, dirDifones + sintBDsom + '.IND');
    {$I-}  reset (arqIndice, 1);  {$I+}
    if ioresult <> 0 then goto fim;

    tamArq := filesize (arqIndice);
    tamTabDifo := tamArq div sizeof (INFODIFONE);
    getMem (tabdifo, tamArq);
    blockread (arqIndice, tabdifo^, tamArq);
    closeFile (arqIndice);

    arqDifones := fileOpen (dirDifones + sintBDSom + '.DIF', fmOpenRead or fmShareDenyNone);
    if arqDifones < 0 then goto fim;

    inicFonemas := true;

fim:
    chdir (dirDiscoLetras);
    chdir (dir);
end;

{--------------------------------------------------------}
{               corta um pouco da fala                   }
{--------------------------------------------------------}

procedure paramFala (quanto, minimo, interv: integer);
begin
    quantoCorta := quanto;
    minimoResto := minimo;
    intervalo := interv;
end;

{--------------------------------------------------------}
{               fecha o arquivo de fonemas               }
{--------------------------------------------------------}

procedure tradFim;
begin
    if pvetSom <> NIL then
        begin
            globalUnlock (hsom);
            globalFree (hsom);
        end;
    pvetSom := NIL;

    libMemTradutor;
    fileClose (arqDifones);

    if tabDifo <> NIL then
        freemem (tabDifo, tamTabDifo * sizeof (INFODIFONE));
    tabDifo := NIL;
end;

{--------------------------------------------------------}
{               inicializacao do tradutor
{--------------------------------------------------------}

function tradInic: integer;
begin
    sintBDSom := 'DIFONES2';

    if not inicFonemas then
        begin
            tradinic := 1;
            exit;
        end;

    if not inicTradutor (dirDifones + 'regras.rgr') then
        begin
            tradinic := 2;
            exit;
        end;

    if not carregaExcessoes (dirDifones + 'portug.exc') then
        begin
            tradinic := 2;
            exit;
        end;

    tradinic := 0;

    hsom := globalAlloc (GMEM_MOVEABLE or GMEM_SHARE, TAMBUFFALA);
    pvetSom := globalLock (hsom);
end;

begin
    intervalo := 100;
    intPonto  := 8000;
    intVirgula := 4000;
    intPtVirgula := 6000;
    intDoisPontos  := 8000;
    sintParam (400, 0, 100, false, false);
    tabDifo := NIL;
    pvetSom := NIL;
end.

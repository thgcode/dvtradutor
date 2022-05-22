{--------------------------------------------------------}
{
{   Sistema Tradutor Fonetico N.R.L.
{
{   Funcao : Traduzir um texto, escrito em uma linguagem qualquer,
{            para a transcricao fonetica correspondente
{
{   Autores :
{       . Alexandre Plastino de Carvalho
{       . Sylvia de Oliveira e Cruz
{       . Veronica Lourenco de Herval Costa
{
{   Trabalho de Fim de Curso de Informatica
{   Orientador Academico: Jose' Antonio Borges
{
{   Data de criacao : Julho de 1987
{   Data de aprovacao : Dezembro de 1987
{   Adaptado para o DOSVOX em Maio de 1994 por:
{        . Jose' Antonio Borges
{
{--------------------------------------------------------}

unit dvTradut;
interface

    function inicTradutor (nomeArq: string): boolean;
    function carregaExcessoes (nomeArq: string): boolean;
    procedure libMemTradutor;
    procedure compilaFonemas (aCompilar: string; var fonemas: string);
    procedure falaEspeciais (opcao: boolean);

implementation

{--------------------------------------------------------}
{                   variaveis gerais
{--------------------------------------------------------}

const
   MAX_EXCESSOES = 15000;
   TRACO = ^@;

type
   simbolos = ' '..'_';                { Todos os caracteres previstos para
                                         aparecer no texto }
   pt_regras = ^ forma_regra;

   forma_regra = record                { Forma da entrada do vetor REGRAS }
                    contexto_a_esquerda : string[5];
                    contexto            : string[5];
                    contexto_a_direita  : string[5];
                    fonemas             : string[11];
                    prox                : pt_regras;
                 end;

   palavra_alias = record              { pronuncia nao padronizada }
                      palav: string;
                      alias: string;
                   end;

var
   regras  : array [simbolos] of
                          pt_regras;   { ponteiros para listas de regras }

   pt_aux : pt_regras;                 { Ponteiro auxiliar }

   pos_letra,           { Numero de caracteres da palavra a ser traduzida }
   pos_i,               { Posicao sendo traduzida }
   letra_corrente,      { Caracter da palavra que esta sendo traduzido }
   num_vogais,          { Numero de vogais da palavra }

   ind_teste_contexto : integer;
                        { indice para o caracter da palavra
                          a ser testado no teste de contexto }

   tem_acento,          { Indica se a palavra e acentuada ou nao }
   satisfeito,          { Indica se a regra satisfaz ou nao }
   aceito : boolean;    { Indica se a regra foi aceita ou nao }

   palavra : array [-2..256]  of char; { Vetor onde e armazenada a palavra
                                         lida no texto }

   vog_maiuscula,     { 'A' , 'E' , 'I' , 'O' , 'U' }
   vog_minuscula,     { 'a' , 'e' , 'i' , 'o' , 'u' }
   vogal,             { vog_maiuscula + vog_minuscula }
   consoante,         { Consoantes maiusculas e minusculas }
   vogal_cons,        { vogal + consoante }
   acentos,           { ''' , '^' , '~' , '`' , '"' }
   numeros,           { '0' , '1' , '2' , '3' , '4' ,
                        '5' , '6' , '7' , '8' , '9' }
   delimitadores,     { ',' , ':' , ';' , '.' , '!' , '?' }
   alfabeto,          { consoante + vogal + acentos }
   QG,                { 'q' , 'g' }
   AO,                { 'A' , 'O' , 'a' , 'o' }
   EI                 { 'E' , 'I' , 'e' , 'i' }
       : set of char;

   tab_excessoes: array [1..MAX_EXCESSOES] of palavra_alias;
                       { palavras com pronuncia diferente }
   n_excessoes: integer;              { numero de excessoes tratadas }
   traduzEspec: boolean;  { traduz simbolos especiais }


{--------------------------------------------------------}
{          informa se traduz especiais por #xxx
{--------------------------------------------------------}

procedure falaEspeciais (opcao: boolean);
begin
    traduzEspec := opcao;
end;

{--------------------------------------------------------}
{                separa acentos das letras
{--------------------------------------------------------}

function separaAcentos (s: string): string;
var
   sai: string;
   trad: string[2];
   i: integer;
   c: char;

label proximaLetra;

const
   tabnum: array [0..9] of char = ('0', '1', '2', '3', '4',
                                   '5', '6', '7', '8', '9');

   tabTrad: array [#$80..#$ff] of string[2] = (
      {80} 'ç',   'u"',  'e''', 'a^',  'a~',  'a`',  'a''', 'ç',
           'e^',  'e"',  'e`' , 'i"',  'i^',  'i`',  'a~',  'a''',

      {90} 'e''', 'ae',  '-'  , 'o^',  'o~',  'o`',  'u^',  'u`',
           'y-',  'o~',  'u"' , '',    '',    '',    '',    '',

      {A0} 'a''', 'i''', 'o''', 'u''', 'nh',  'nh',  '',    #$a7,
           '?',   '',    '',    #$aa,  '',    '!',   '"',   '"',

      {B0} '',    '',    '',    '',    '',    '',    '',    '',
           '',    '',    '',    #$ba,  '',    '',    '',    '?',

      {C0} 'a`',  'a''', 'a^',  'a~',  'a~',  'a',   'ae',  'ç',
           'e`',  'e''', 'e^',  'e"',  'i`',  'i''', 'i^',  'i"',

      {D0} '',    'nh',  'o`',  'o''', 'o^',  'o~',  'o`',   'x',
           '0',   'u`',  'u''', 'u^',  'u',  '',    '',     '',

      {E0} 'a`',  'a''', 'a^',  'a~',  'a~',  'a',   'ae',  'ç',
           'e`',  'e''', 'e^',  'e"',  'i`',  'i''', 'i^',  'i"',

      {F0} '',    'nh',  'o`',  'o''', 'o^',  'o~',  'o`',   'x',
           '0',   'u`',  'u''', 'u^',  'u',  '',    '',     ''   );


begin
   sai := '';
   for i := 1 to length (s) do
      begin
         c := s[i];

         if upcase(c) = 'W' then
             begin
                 if ((i > 1) and (s[i-1] in vogal_cons)) or
                    ((i < length(s)) and (s[i+1] in vogal_cons)) then
                        s[i] := 'u';
             end
         else
         if upcase(c) = 'Y' then
             begin
                 if ((i > 1) and (s[i-1] in vogal_cons)) or
                    ((i < length(s)) and (s[i+1] in vogal_cons)) then
                        s[i] := 'i'
                 else
                 if ((i > 1) and (s[i-1] = ' ') or (i = 1)) and
                    ((i < length(s)) and (s[i+1] = ' ') or (i = length(s))) then
                        trad := 'i';
             end;

         if (c = '''') and (upcase(s[i-1]) = 'D') then
             goto proximaLetra
         else
         if c in [#$00..#$1f] then
             trad := ''
         else
         if c in [#$80..#$ff] then
             begin
                 trad := tabTrad [c];
                 if (trad = 'ç') or (trad = 'Ç') then
                     trad := 'ss';
             end
         else
             trad := s[i];

         if trad <> '' then
             sai := sai + trad
         else
             if traduzEspec then
                   begin
                       sai := sai + '#' +
                                    tabnum [ord(c) div 100] +
                                    tabnum [(ord(c) mod 100) div 10] +
                                    tabnum [ord(c) mod 10] + ' ';
                   end
              else
                  sai := sai + ' ' + TRACO + ' ';
proximaLetra:
           ;
      end;

   separaAcentos := sai;
end;

{--------------------------------------------------------}
{                inicialização das regras
{--------------------------------------------------------}

procedure inic_regras;
var ind_regra: char;
begin
   ind_regra := #$1f;
   repeat
      ind_regra := succ ( ind_regra );
      regras[ ind_regra ] := nil;
   until ind_regra = '_';
end;

{--------------------------------------------------------}
{         inicializacao das variaveis e conjuntos
{--------------------------------------------------------}

procedure inicializa;
begin
   vog_maiuscula := [ 'A' , 'E' , 'I' , 'O' , 'U' ];
   vog_minuscula := [ 'a' , 'e' , 'i' , 'o' , 'u' ];
   vogal := vog_maiuscula + vog_minuscula;
   consoante := [ 'b'..'d','f'..'h','j'..'n','p'..'t','v'..'z',
                  'B'..'D','F'..'H','J'..'N','P'..'T','V'..'Z' ];
   vogal_cons := vogal + consoante;
   delimitadores := [' ',',',';',':','.','?','!'];
   acentos := [ '''','`','^','~','"' ];
   numeros := ['0', '1', '2', '3', '4', '5', '6', '7' , '8' , '9'];

   alfabeto := vogal + consoante + acentos;
   QG := [ 'q' , 'g' ];
   EI := [ 'E' , 'I' , 'e' , 'i' ];
   AO := [ 'A' , 'O' , 'a' , 'o' ];

   inic_regras;
   n_excessoes := 0;
   traduzEspec := false;
end;

{--------------------------------------------------------}
{            extrai campos de uma regra lida
{--------------------------------------------------------}

procedure extraiCampos (var linha: string; var regra: forma_regra);
var
   pos: integer;

label 1, 2, 3, 4;

begin
    with regra do
       begin
          contexto_a_esquerda := '';
          for pos := 1 to length (linha) do
             if linha[pos] = '(' then
                 goto 1
             else
                 contexto_a_esquerda := contexto_a_esquerda + linha[pos];
          pos := 9999;

      1:
          contexto := '';
          for pos := pos+1 to length (linha) do
             if linha[pos] = ')' then
                 goto 2
             else
                 contexto := contexto + linha[pos];
          pos := 9999;

      2:
          contexto_a_direita := '';
          for pos := pos+1 to length (linha) do
             if linha[pos] = '=' then
                 goto 3
             else
                 contexto_a_direita := contexto_a_direita + linha[pos];
          pos := 9999;

      3:
          fonemas := '';
          for pos := pos+1 to length (linha) do
             if linha[pos] = '|' then
                 goto 4
             else
                 fonemas := fonemas + linha[pos];

      4:
          prox := nil;
      end;
end;

{--------------------------------------------------------}
{                   le arquivo de regras
{--------------------------------------------------------}

function inicTradutor (nomeArq: string): boolean;
var
   ind_regra : char;                   { Ind p/ a entrada corrente de REGRS }
   regra : forma_regra;                { Regra lida }
   pt_aux,                             { Ponteiro auxiliar }
   novo_reg : pt_regras;               { Regra auxiliar }
   arq_regras: text;                   { Arquivo de regras }
   linha: string;                      { Linha lida do arquivo }

label fim;

begin
   inicializa;
   inicTradutor := false;

   assign (arq_regras, nomeArq);
   {$i-} reset (arq_regras); {$i+}
   if ioresult <> 0 then
       exit;

   pt_aux := regras['A'];
   while not eof ( arq_regras ) do
      begin
         readln ( arq_regras , linha );
         if copy (linha, 1, 1) = ';' then continue;
         
         extraiCampos (linha, regra);

         ind_regra := regra.contexto[1];
         if regras [ind_regra] = nil then
            begin
               new (regras[ind_regra]);
               with regras[ind_regra]^ do
                  begin
                     contexto_a_esquerda := regra.contexto_a_esquerda;
                     contexto            := regra.contexto;
                     contexto_a_direita  := regra.contexto_a_direita;
                     fonemas             := regra.fonemas;
                     prox                := nil;
                  end;

               pt_aux := regras[ind_regra];
            end
         else
            begin
               new (novo_reg);
               with novo_reg^ do
                  begin
                     contexto_a_esquerda := regra.contexto_a_esquerda;
                     contexto            := regra.contexto;
                     contexto_a_direita  := regra.contexto_a_direita;
                     fonemas             := regra.fonemas;
                     prox                := nil;
                  end;

               pt_aux^.prox := novo_reg;
               pt_aux       := pt_aux^.prox;
            end;
      end;

fim:
   close( arq_regras );
   inicTradutor := true;
end;

{--------------------------------------------------------}
{                ordena usando quicksort
{--------------------------------------------------------}

procedure ordenaExcessoes;

    procedure Sort(l, r: Integer);
    var
        i, j: integer;
        x: string;
        salva: palavra_alias;
    begin
        i := l;
        j := r;
        x := tab_excessoes[(l+r) DIV 2].palav;
        repeat
            while tab_excessoes[i].palav < x do i := i + 1;
            while x < tab_excessoes[j].palav do j := j - 1;
            if i <= j then
                begin
                    salva := tab_excessoes [i];
                    tab_excessoes [i] := tab_excessoes [j];
                    tab_excessoes [j] := salva;
                    i := i + 1;
                    j := j - 1;
                end;
        until i > j;
        if l < j then Sort(l, j);
        if i < r then Sort(i, r);
    end;

begin {QuickSort};
    Sort(1, n_excessoes);
end;

{--------------------------------------------------------}
{                carrega tabela de excessoes
{--------------------------------------------------------}

function carregaExcessoes (nomeArq: string): boolean;
var
   i: integer;
   arq: text;
   texto: shortString;
   palavra, pal_alias: shortString;

begin
   n_excessoes := 0;
   carregaExcessoes := true;

   assign (arq, nomeArq);
   {$i-} reset (arq); {$i+}
   if ioresult <> 0 then
      begin
         carregaExcessoes := false;
         exit;
      end;

   while not eof (arq) and (n_excessoes < MAX_EXCESSOES) do
      begin
         readln (arq, texto);
         if texto <> '' then
            begin
               texto := texto + '|=|';
               palavra := '';
               pal_alias := '';

               i := 1;
               while texto[i] <> '=' do
                   begin
                      palavra := palavra + texto[i];
                      i := i + 1;
                   end;

               i := i + 1;
               while texto[i] <> '|' do
                   begin
                      pal_alias := pal_alias + texto[i];
                      i := i + 1;
                   end;

               n_excessoes := n_excessoes + 1;
               with tab_excessoes [n_excessoes] do
                   begin
                       palav := palavra;
                       alias := pal_alias;
                   end;

            end;
      end;
   close (arq);

   ordenaExcessoes;
end;

{--------------------------------------------------------}
{               libera memoria do tradutor
{--------------------------------------------------------}

procedure libMemTradutor;
var
    preg, prox : pt_regras;
    ind_regra: char;

begin
    for ind_regra := ' ' to '_' do
        begin
            preg := regras [ind_regra];
            while preg <> NIL do
                begin
                    prox := preg^.prox;
                    dispose (preg);
                    preg := prox;
                end;
            regras [ind_regra] := NIL;
        end;

(*
    for i := 1 to n_excessoes do
        with tab_excessoes [i] do
            begin
                if palav <> NIL then
                    begin
                        tam := length (palav^)+1;
                        freemem (palav, tam);
                        palav := NIL;
                        tam := length(alias^)+1;
                        freemem (alias, tam);
                        alias := NIL;
                    end;
            end;
*)
end;

{--------------------------------------------------------}
{               marca a silaba tonica
{--------------------------------------------------------}

procedure marca_tonica;

var
   estado : integer;                   { Indica estado corrente do diagrama }
   marcou : boolean;                   { Indica se a vogal tonica ja foi
                                         marcada }
begin
   if not tem_acento and
      ((num_vogais > 1) or
      ((num_vogais = 1) and
      (palavra [pos_letra] = 'l'))) then

      begin
         estado := 0;
         marcou := false;
         letra_corrente := pos_letra;

         while (not marcou) and (letra_corrente > 0) do
            begin
               case estado of

                  0 : case palavra [letra_corrente] of
                         'n', 'r', 'x', 'l', 'z' : estado := 1;
                         'm'                     : estado := 2;
                         'i', 'u'                : estado := 3;
                         's'                     : estado := 4;
                         'a', 'e', 'o'           : estado := 5;
                         else                      ;
                      end;

                  1 : if palavra [letra_corrente] in vogal then
                         estado := 6;

                  2 : case palavra [letra_corrente] of
                         'i', 'u' : estado := 3;
                         'a', 'e' : estado := 5;
                         'o'      : estado := 6;
                         else       ;
                      end;

                  3 : if ( palavra [letra_corrente] in consoante ) or    (****)
                         (( palavra[letra_corrente - 1] = 'u' ) and
                          ( palavra[letra_corrente - 2] in QG )) then
                         estado := 7

                      else
                         estado := 6;

                  4 : case palavra [letra_corrente] of
                         'a', 'e', 'o' : estado := 5;
                         'i', 'u'      : estado := 3;
                         else            ;
                      end;

                  5 : case palavra [letra_corrente] of
                         'a', 'e', 'o' : estado := 6;
                         'i', 'u'      : estado := 8;
                         else            ;
                      end;

                  6 : begin
                         palavra [letra_corrente + 1] :=
                            upcase (palavra [letra_corrente + 1]);
                         marcou := true;
                      end;

                  7 : begin
                         palavra [letra_corrente + 2] :=
                            upcase (palavra [letra_corrente + 2]);
                         marcou := true;
                      end;

                  8 : if (palavra [letra_corrente] in consoante) or
                         ((palavra [letra_corrente] = 'u') and
                          (palavra [letra_corrente - 1] in QG)) or
                         (palavra [letra_corrente + 2] in
                                               ['l','m','n','r','z']) and
                         (((palavra [letra_corrente + 2] = 'n') and
                           (palavra [letra_corrente + 3] = 'h')) or
                          ((palavra [letra_corrente + 2] = 'r') and
                           (palavra [letra_corrente + 3] = 'r')) or
                          ((palavra [letra_corrente + 3] in consoante) and
                           (palavra [letra_corrente + 3] <> 'h'))) then
                          estado := 7

                       else
                          estado := 6;
               end;

               letra_corrente := letra_corrente - 1;
            end;
      end;
end;

{--------------------------------------------------------}
{              testa fim ou inicio de palavra
{--------------------------------------------------------}

procedure testa_lim_palavra;
begin
   if ( ind_teste_contexto <> 0 ) and ( ind_teste_contexto <> pos_letra + 1 ) then
      aceito := false;
end;

{--------------------------------------------------------}
{               testa se aparece um "a" ou "o"
{--------------------------------------------------------}

procedure testa_a_ou_o;
begin
   if ( ind_teste_contexto <> 0 ) and
      ( ind_teste_contexto <> pos_letra + 1 ) then
      if ( palavra[ind_teste_contexto] in AO ) then

         ind_teste_contexto := ind_teste_contexto - 1

      else
         if ( palavra[ind_teste_contexto] in acentos ) and
            ( palavra[ind_teste_contexto] in AO ) then

            ind_teste_contexto := ind_teste_contexto - 2

         else
            aceito := false

   else
      aceito := false;
end;

{--------------------------------------------------------}
{                testa se atingiu fim de silaba
{--------------------------------------------------------}

procedure testa_fim_silaba;
begin
   if ( ind_teste_contexto <> pos_letra + 1 ) and
      ( ( not ( palavra[ind_teste_contexto] in consoante ) ) or
        ( palavra[ind_teste_contexto] = 'h' ) ) then

         aceito := false;
end;

{--------------------------------------------------------}
{                  testa consoante muda
{--------------------------------------------------------}

procedure testa_consoante_muda;
begin
   if ( ind_teste_contexto = 0 ) or
      ( ind_teste_contexto = pos_letra + 1 ) then
      aceito := false

   else
      if ( not ( palavra[ind_teste_contexto] in consoante ) ) or
         ( palavra[ind_teste_contexto] = 'r' ) or
         ( palavra[ind_teste_contexto] = 'l' ) then

         aceito := false;
end;

{--------------------------------------------------------}
{                 testa se aparece "e" ou "i"
{--------------------------------------------------------}

procedure testa_e_ou_i;
begin
   if ( ind_teste_contexto = 0 ) or
      ( ind_teste_contexto = pos_letra + 1 ) then
          aceito := false

   else
      if ( not ( palavra[ind_teste_contexto] in EI ) ) then
         aceito := false

      else
         if ( palavra[ ind_teste_contexto + 1 ] in acentos ) then
            ind_teste_contexto := ind_teste_contexto + 2

         else
            ind_teste_contexto := ind_teste_contexto + 1;
end;

{--------------------------------------------------------}
{                 testa se aparece uma vogal
{--------------------------------------------------------}

procedure testa_vogal ( incremento : integer );
begin
   if ( ind_teste_contexto <> 0 ) and ( ind_teste_contexto <> pos_letra + 1 ) then

      if ( not ( palavra[ind_teste_contexto] in vogal ) ) and
         ( not ( palavra[ind_teste_contexto] in acentos ) ) then

         aceito := false

      else
         repeat

            ind_teste_contexto := ind_teste_contexto + incremento;

         until ( ( ind_teste_contexto = 0 ) or
                 ( ind_teste_contexto = pos_letra + 1 ) or
                 ( ( not ( palavra[ind_teste_contexto] in vogal ) ) and
                   ( not ( palavra[ind_teste_contexto] in acentos ) ) ) )

   else
      aceito := false;
end;

{--------------------------------------------------------}
{     testa se aparece "s" ou se palavra ja' acabou
{--------------------------------------------------------}

procedure testa_s;
begin
   if ( ind_teste_contexto <= pos_letra ) then

      if ( palavra[ind_teste_contexto] = 's') then

         ind_teste_contexto := ind_teste_contexto + 1;
end;

{--------------------------------------------------------}
{        testa se aparece "l", "n", "m", "r" ou "z"
{--------------------------------------------------------}

procedure testa_lnmrz;
begin
   if ( ind_teste_contexto < pos_letra + 1 ) then

      if ( palavra[ind_teste_contexto] <> 'l' ) and
         ( palavra[ind_teste_contexto] <> 'n' ) and
         ( palavra[ind_teste_contexto] <> 'm' ) and
         ( palavra[ind_teste_contexto] <> 'r' ) and
         ( palavra[ind_teste_contexto] <> 'z' ) then

         aceito := false

      else
         ind_teste_contexto := ind_teste_contexto + 1

   else
      aceito := false;
end;

{--------------------------------------------------------}
{      testa se vogal ou se atingido inicio da palavra
{--------------------------------------------------------}

procedure testa_vogal_ou_inic_palavra;
begin

   if not ( ind_teste_contexto = 0 ) then
      if ( palavra[ ind_teste_contexto ] in vogal ) then

         ind_teste_contexto := ind_teste_contexto - 1

      else
         if ( palavra[ ind_teste_contexto ] in acentos ) and
            ( palavra[ ind_teste_contexto - 1 ] in vogal ) then

            ind_teste_contexto := ind_teste_contexto - 2

         else
            aceito := false;
end;

{--------------------------------------------------------}
{             testa se aparece "n", "r" ou "s"
{--------------------------------------------------------}

procedure testa_antecessor_l;
begin

   if ( ind_teste_contexto <> 0 ) and
      ( palavra[ind_teste_contexto] in ['n','r','s'] ) then

      ind_teste_contexto := ind_teste_contexto - 1

   else
      aceito := false;
end;

{--------------------------------------------------------}
{       verifica se contexto `a direita satisfaz
{--------------------------------------------------------}

function contexto_a_direita_satisfaz : boolean;
var
   j : integer;                        { Variavel auxiliar }

begin

   with pt_aux^ do
      begin
         aceito := true;
         ind_teste_contexto := pos_i + length ( contexto );
         j := 1;

         while ( aceito ) and ( j <= length ( contexto_a_direita ) ) do
            begin

               case contexto_a_direita[j] of
                  '[' : testa_fim_silaba;
                  '*' : testa_consoante_muda;
                  '+' : testa_e_ou_i;
                  '%' : testa_lim_palavra;
                  '#' : testa_vogal ( 1 ) ;
                  '\' : testa_s;
                  '&' : testa_lnmrz;

                  else if ( ind_teste_contexto < pos_letra + 1 ) and
                          ( contexto_a_direita[j] =
                              upcase ( palavra[ind_teste_contexto] ) ) then

                          ind_teste_contexto := ind_teste_contexto + 1

                       else
                          aceito := false;
               end;

               j := j + 1;
            end;

         contexto_a_direita_satisfaz := aceito;
      end;
end;

{--------------------------------------------------------}
{       verifica se contexto `a esquerda satisfaz
{--------------------------------------------------------}

function contexto_a_esquerda_satisfaz : boolean;

var
   j : integer;                        { Variavel auxiliar }

begin
   with pt_aux^ do
      begin
         aceito := true;
         ind_teste_contexto := pos_i - 1;
         j := length ( contexto_a_esquerda );

         while ( aceito ) and ( j > 0 ) do
            begin

               case contexto_a_esquerda[j] of
                  '%' : testa_lim_palavra;
                  '#' : testa_vogal ( -1 );
                  ']' : testa_a_ou_o;
                  '_' : testa_vogal_ou_inic_palavra;
                  '|' : testa_antecessor_l;

                  else if ( ind_teste_contexto <> 0 ) and
                          ( contexto_a_esquerda[j] = upcase ( palavra[ind_teste_contexto] ) ) then
                          ind_teste_contexto := ind_teste_contexto - 1

                       else
                          aceito := false;
               end;

               j := j - 1;
            end;

         contexto_a_esquerda_satisfaz := aceito
      end;
end;

{--------------------------------------------------------}
{                verifica se contexto satisfaz
{--------------------------------------------------------}

function contexto_satisfaz : boolean;
var
   j : integer;                        { Variavel auxiliar }

begin
   with pt_aux^ do
    begin
      aceito := true;
      j := 1;

      while ( aceito ) and ( j <= length ( contexto ) ) do

         if ( ( pos_i + j - 1) > pos_letra ) or
            ( contexto[j] <> upcase ( palavra[ pos_i + j - 1 ] ) ) then

            aceito := false

         else
            j := j + 1;

      contexto_satisfaz := aceito;
    end
end;

{--------------------------------------------------------}
{                    traduz uma palavra
{--------------------------------------------------------}

procedure traduz (var fonemas: string);
var
   j : integer;                        { Variavel auxiliar }

   seq_fonemas : string[11];           { Var. p/ onde sao lidos os fonemas
                                         existentes na regra selecionada   }
   ind_regra: char;
begin
   pos_i := 1;
   fonemas := fonemas + '[';

   while pos_i <= pos_letra do
      begin
         ind_regra := upcase(palavra[pos_i] );
         seq_fonemas := ' /_' + ind_regra;
         satisfeito := false;

         if ind_regra in [' '..'_'] then
             pt_aux := regras[ind_regra]
         else
             pt_aux := NIL;

         while ( not satisfeito ) and ( pt_aux <> nil ) do

            if contexto_satisfaz and
               contexto_a_esquerda_satisfaz and
               contexto_a_direita_satisfaz then

               satisfeito := true

            else
               pt_aux := pt_aux^.prox;

         if pt_aux <> NIL then
             seq_fonemas := pt_aux^.fonemas;

         if ( palavra[pos_i] in vogal ) and
            ( palavra[pos_i] in [ 'A'..'Z' ] ) then
            begin
               j := 1;
               while ( not( seq_fonemas[j] in vogal ) ) and
                     ( j < length( seq_fonemas ) ) do
                  j := j + 1;

               if ( seq_fonemas[j] in vogal ) then
                  seq_fonemas[j] := upcase ( seq_fonemas[j] );
            end;

         for j := 1 to length ( seq_fonemas ) do
            fonemas := fonemas + seq_fonemas[j];

         if pt_aux <> NIL then
             pos_i := pos_i + length ( pt_aux^.contexto )
         else
             pos_i := pos_i + 1;

         if pos_i <= pos_letra then
            fonemas := fonemas + '/';
      end;

   fonemas := fonemas + ']';
end;

{--------------------------------------------------------}
{                   transforma para minuscula
{--------------------------------------------------------}

function minuscula (ch : char) : char; { Caracter que deve ser convertido
                                           para minusculo }
begin
   if ( ch in ['A'..'Z'] ) then
      ch := chr ( ord ( ch ) + $20 );
   minuscula := ch;
end;

{--------------------------------------------------------}
{                isola uma palavra num texto
{--------------------------------------------------------}

function le_palavra (textoi: string; var ind_textoi: integer): boolean;
var
   c: char;
   acabou: boolean;            { Indica se o texto acabou ou nao }
label outros;

begin
   le_palavra := false;
   repeat
       acabou := ( ind_textoi > length( textoi ) );
       if acabou then
          c := '|'
       else
           c := textoi [ind_textoi];
       if c = ' ' then
           ind_textoi := ind_textoi + 1;
   until c <> ' ';

   num_vogais := 0;
   tem_acento := false;
   pos_letra := 0;

   if not acabou then
      begin
         c := minuscula(textoi [ind_textoi]);
         le_palavra := true;

         if c in vogal_cons then
            begin

               while (not acabou) and (c in alfabeto) do
                  begin
                      pos_letra := pos_letra + 1;
                      palavra[pos_letra] := c;
                      if c in vogal then
                            num_vogais := num_vogais + 1;

                     ind_textoi := ind_textoi + 1;
                     acabou := ( ind_textoi > length( textoi ) );
                     if not acabou then
                         begin
                             c := minuscula( textoi[ind_textoi] );
                             if ( c in acentos ) and ( c <> '"' ) then
                                 tem_acento := true;
                         end;
                  end;
            end
         else
            begin
outros:
               pos_letra := pos_letra + 1;
               palavra[pos_letra] := c;
               ind_textoi := ind_textoi + 1;
            end
      end;
end;

{--------------------------------------------------------}
{                       trata excessoes
{--------------------------------------------------------}

procedure trata_excessoes;
var i, esq, dir, meio: integer;
    excessao, removido: string;
    letra_final: char;
label deNovo, fim;
begin
   excessao := '';
   for i := 1 to pos_letra do
      excessao := excessao + palavra[i];

deNovo:
   esq := 1;
   dir := n_excessoes;
   while esq <= dir do
       begin
           meio := (esq + dir) div 2;
           with tab_excessoes[meio] do
               begin
                   if excessao = palav then
                       begin
                           excessao := alias;
                           goto fim;
                       end
                   else
                   if excessao > palav then
                       esq := meio + 1
                   else
                       dir := meio - 1;
                end;
       end;

     letra_final := excessao [length(excessao)]; 		
     if (letra_final = 's') or (letra_final = 'm') then
         begin
              removido := letra_final + removido;
              delete (excessao, length(excessao), 1);
              if excessao <> '' then goto deNovo;
         end;

fim:
     excessao := excessao + removido;
     pos_letra := length (excessao);
     for i := 1 to pos_letra do
         palavra [i] := excessao[i];
end;

{--------------------------------------------------------}
{           ve se palavra so' tem consoantes
{--------------------------------------------------------}

function soConsoantes: boolean;
var i: integer;
begin
    if palavra[1] <> TRACO then
        for i := 1 to pos_letra do
            if not ((palavra[i] in consoante) or
                   (palavra[i] in delimitadores)) then
                begin
                    soConsoantes := false;
                    exit;
                end;
    soConsoantes := true;
end;

{--------------------------------------------------------}
{                      gera soletragem
{--------------------------------------------------------}

procedure geraSoletragem (var fonemas: string);
var i: integer;
begin
    for i := 1 to pos_letra do
        fonemas := fonemas + '[ /_' + palavra[i] + ']';
end;

{--------------------------------------------------------}
{                 compilacao de um texto
{--------------------------------------------------------}

procedure compilaFonemas (aCompilar: string; var fonemas: string);
var posTexto: integer;
    texto: string;
begin
    fonemas := '';
    posTexto := 1;

    texto := separaAcentos (aCompilar);
    while le_palavra (texto, posTexto) do
       begin
          trata_excessoes;
          marca_tonica;

          if soConsoantes then
              geraSoletragem (fonemas)
          else
              traduz (fonemas);
       end;
end;

begin
   inic_regras;
   n_excessoes := 0;
end.

{--------------------------------------------------------}
{                                                        }
{   Sistema Tradutor Fonético (N.R.L.)                   }
{                                                        }
{   Função : Traduzir um texto, escrito em português     }
{            para a transcrição fonética correspondente  }
{                                                        }
{   Autores :                                            }
{       . Alexandre Plastino de Carvalho                 }
{       . Sylvia de Oliveira e Cruz                      }
{       . Veronica Lourenco de Herval Costa              }
{                                                        }
{   Trabalho de Fim de Curso de Informática              }
{   Orientador Acadêmico: José Antonio Borges            }
{                                                        }
{   Data de criação : Julho de 1987                      }
{   Data de aprovação : Dezembro de 1987                 }
{                                                        }
{   Adaptado para o DOSVOX por                           }
{        . José Antonio Borges, em Maio de 1994          }
{   Adaptado para o Sintetizador do Serpro por           }
{        . José Antonio Borges, em Maio de 2006          }
{                                                        }
{--------------------------------------------------------}

unit uttsPortug;
interface
uses sysUtils, classes,
     uttsInic, uttsExcessoes, uttsPreproc, uttsTonica, uttsProsodia;

function inicTradutor (nomeArqRegras, nomeArqExcessoes: string): boolean;
procedure compilaFonemas (textoMarcado: TStringList; var fonemas: TStringList);
procedure fimTradutor;

implementation

{--------------------------------------------------------}
{                   variaveis gerais                     }
{--------------------------------------------------------}

var
   pt_aux : pt_regras;  { Ponteiro auxiliar }
   pos_i,               { Posicao sendo traduzida }
   pos_f,               { Posição final da sequencia de tradução }

   ind_teste_contexto : integer;
                        { indice para o caracter da palavra
                          a ser testado no teste de contexto }

   satisfeito,          { Indica se a regra satisfaz ou nao }
   aceito : boolean;    { Indica se a regra foi aceita ou nao }


   traduzEspec: boolean;  { traduz simbolos especiais }

{--------------------------------------------------------}
{             inicializacao dos conjuntos                }
{--------------------------------------------------------}

const
   CRLF = #$0d + #$0a;

   alfabeto: set of char =
        ['A','E','I','O','U','À','Á','Â','Ã','É','Ê','Ì','Í','Ó','Ô','Õ','Ù','Ú','Ü',
         'a','e','i','o','u','à','á','â','ã','é','ê','ì','í','ó','ô','õ','ù','ú','ü',
         'b'..'d','f'..'h','j'..'n','p'..'t','v'..'z', 'ç', 'ñ',
         'B'..'D','F'..'H','J'..'N','P'..'T','V'..'Z', 'Ç', 'Ñ'];

   delimitadores: set of char = [' ', ',' , ':' , ';' , '.' , '!' , '?', '(', ')'];

   consoante: set of char =
        ['b'..'d','f'..'h','j'..'n','p'..'t','v'..'z', 'ç', 'ñ',
         'B'..'D','F'..'H','J'..'N','P'..'T','V'..'Z', 'Ç', 'Ñ'];

   vogal: set of char =
        ['A','E','I','O','U','À','Á','Â','Ã','É','Ê','Ì','Í','Ó','Ô','Õ','Ù','Ú','Ü',
         'a','e','i','o','u','à','á','â','ã','é','ê','ì','í','ó','ô','õ','ù','ú','ü'];

   acentos: set of char =
        ['Á','Â','Ã','É','Ê','Í','Ó','Ô','Õ','Ú',
         'á','â','ã','é','ê','í','ó','ô','õ','ú'];

   incombinantes: set of char =
       ['b','c','d','f','g','j','k','m','n','p','q','s','t','v','x','z'];

   QG: set of char = ['q' , 'g'];

   AO: set of char = ['A' , 'O' , 'a' , 'o',
                      'Á' , 'Ó' , 'á' , 'ó',
                      'Â' , 'Ô' , 'â' , 'ô'];

   EI: set of char = ['E' , 'I' , 'e' , 'i',
                      'É' , 'Í' , 'é' , 'í'];

   RL: set of char = ['R' , 'L' , 'r' , 'l'];

   S:  set of char = ['S' , 's'];

   H:  set of char = ['H' , 'h'];

   LMNRZ: set of char = ['L','M','N','R','Z',  'l','m','n','r','z'];

   NRS: set of char = ['N', 'R', 'S',  'n','r','s'];


{--------------------------------------------------------}
{               corpo do tradutor NRL                    }
{--------------------------------------------------------}

procedure traduz (palavra: string; tonica: integer; var fonemas: TStringList);

{--------------------------------------------------------}
{       verifica se contexto `a direita satisfaz         }
{--------------------------------------------------------}

function contexto_a_direita_satisfaz : boolean;

        {--------------------------------------------------------}

        procedure testa_fim_silaba;
        begin
           if (ind_teste_contexto <= pos_f) and
              ((not (palavra[ind_teste_contexto] in consoante)) or
                (palavra[ind_teste_contexto] in H)) then
                     aceito := false;
        end;

        {--------------------------------------------------------}

        procedure testa_consoante_muda;
        begin
           if (ind_teste_contexto = 0) or
              (ind_teste_contexto > pos_f) then
                  aceito := false
           else
              if (not (palavra[ind_teste_contexto] in consoante)) or
                 (palavra[ind_teste_contexto] in RL) then
                     aceito := false;
        end;

        {--------------------------------------------------------}

        procedure testa_e_ou_i;
        begin
           if (ind_teste_contexto = 0) or
              (ind_teste_contexto > pos_f) or
              (not (palavra[ind_teste_contexto] in EI))  then
               aceito := false
           else
               ind_teste_contexto := ind_teste_contexto + 1;
        end;
        {--------------------------------------------------------}

        procedure testa_vogal_seguinte;
        begin
           if (ind_teste_contexto <> 0) and (ind_teste_contexto <= pos_f) then
              begin
                  if not (palavra[ind_teste_contexto] in vogal) then
                      aceito := false
                  else
                      ind_teste_contexto := ind_teste_contexto + 1;
              end
           else
              aceito := false;
        end;

        {--------------------------------------------------------}

        procedure testa_s;
        begin
           if ( ind_teste_contexto <= pos_f) then
              if ( palavra[ind_teste_contexto] in S) then
                 ind_teste_contexto := ind_teste_contexto + 1;
        end;

        {--------------------------------------------------------}

        procedure testa_lnmrz;
        begin
           if (ind_teste_contexto <= pos_f) then
              if not (palavra[ind_teste_contexto] in LMNRZ) then
                  aceito := false
              else
                  ind_teste_contexto := ind_teste_contexto + 1
           else
              aceito := false;
        end;

        {--------------------------------------------------------}

        procedure testa_lim_palavra;
        begin
           if (ind_teste_contexto <> 0) and
              (ind_teste_contexto <= pos_f) then
                  aceito := false;
        end;

   {--------------------------------------------------------}

   {.... corpo da rotina ....}

var
   j : integer;
begin
   with pt_aux^ do
      begin
         aceito := true;
         ind_teste_contexto := pos_i + length (contexto);
         j := 1;

         while aceito and (j <= length (contexto_a_direita)) do
            begin
               case contexto_a_direita[j] of
                  '[' : testa_fim_silaba;
                  '*' : testa_consoante_muda;
                  '+' : testa_e_ou_i;
                  '%' : testa_lim_palavra;
                  '#' : testa_vogal_seguinte ;
                  '\' : testa_s;
                  '&' : testa_lnmrz;
               else
                   if (ind_teste_contexto < pos_f + 1) and
                      (contexto_a_direita[j] = upcase (palavra[ind_teste_contexto])) then
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
{       verifica se contexto `a esquerda satisfaz        }
{--------------------------------------------------------}

function contexto_a_esquerda_satisfaz : boolean;

        {--------------------------------------------------------}

        procedure testa_lim_palavra;
        begin
           if (ind_teste_contexto <> 0) and
              (ind_teste_contexto <= pos_f) then
                  aceito := false;
        end;

        {--------------------------------------------------------}

        procedure testa_vogal_antes;
        begin
           if (ind_teste_contexto <> 0) and (ind_teste_contexto <= pos_f) then
              begin
                  if not (palavra[ind_teste_contexto] in vogal) then
                     aceito := false
                  else
                     ind_teste_contexto := ind_teste_contexto - 1;
              end
           else
              aceito := false;
        end;

        {--------------------------------------------------------}

        procedure testa_a_ou_o;
        begin
           if (ind_teste_contexto = 0) or
              (ind_teste_contexto > pos_f) or
              (not (palavra[ind_teste_contexto] in AO))  then
               aceito := false
           else
               ind_teste_contexto := ind_teste_contexto + 1;
        end;

        {--------------------------------------------------------}

        procedure testa_vogal_ou_inic_palavra;
        begin
           if not (ind_teste_contexto = 0) then
              if (palavra[ind_teste_contexto] in vogal) then
                 ind_teste_contexto := ind_teste_contexto - 1
              else
                  aceito := false;
        end;

        {--------------------------------------------------------}

        procedure testa_antecessor_l;
        begin
           if ( ind_teste_contexto <> 0) and
              ( palavra[ind_teste_contexto] in NRS) then
              ind_teste_contexto := ind_teste_contexto - 1
           else
              aceito := false;
        end;

var
   j : integer;
begin
   with pt_aux^ do
      begin
         aceito := true;
         ind_teste_contexto := pos_i - 1;
         j := length (contexto_a_esquerda);

         while (aceito) and (j > 0) do
            begin
               case contexto_a_esquerda[j] of
                  '%' : testa_lim_palavra;
                  '#' : testa_vogal_antes;
                  ']' : testa_a_ou_o;
                  '_' : testa_vogal_ou_inic_palavra;
                  '|' : testa_antecessor_l;

                  else if (ind_teste_contexto <> 0) and
                          (contexto_a_esquerda[j] = upcase (palavra[ind_teste_contexto])) then
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
{                verifica se contexto satisfaz           }
{--------------------------------------------------------}

function contexto_satisfaz: boolean;
var
   j : integer;                        { Variavel auxiliar }

begin
   with pt_aux^ do
      begin
          aceito := true;
          j := 1;

          while (aceito) and (j <= length (contexto)) do
              begin
                  if ((pos_i + j - 1) > pos_f) or
                     (contexto[j] <> upcase (palavra[pos_i + j - 1])) then
                          aceito := false
                 else
                          j := j + 1;
               end;

          contexto_satisfaz := aceito;
      end;
end;

{--------------------------------------------------------}

procedure adicionaFonema (s: string);
begin
    fonemas.add (s);
end;


{--------------------------------------------------------}
{                    traduz uma palavra                  }
{--------------------------------------------------------}

// ..... corpo da procedure traduz
var
   j : integer;                        { Variavel auxiliar }
   seq_fonemas : string[11];           { Var. p/ onde sao lidos os fonemas                                         existentes na regra selecionada   }
   ind_regra: char;
   f: string;

begin
   pos_i := 1;
   pos_f := length (palavra);
   f := '';
   if tonica < 1 then tonica := 9999;

   while pos_i <= pos_f do
      begin
         ind_regra := palavra[pos_i];
         satisfeito := false;

         if ind_regra in [' '..#255] then
             pt_aux := regras[ind_regra]
         else
             pt_aux := NIL;

         while (not satisfeito) and (pt_aux <> nil) do

            if contexto_satisfaz and
               contexto_a_esquerda_satisfaz and
               contexto_a_direita_satisfaz then

               satisfeito := true

            else
               pt_aux := pt_aux^.prox;

         if pt_aux <> NIL then
             begin
                 seq_fonemas := pt_aux^.fonemas;
                 for j := 1 to length (seq_fonemas) do
                     begin
                         if pos_i >= tonica then
                             begin
                                 f := f + '>';
                                 tonica := 255;
                             end;

                     //  if seq_fonemas[j] <> '¨' then
                             if seq_fonemas[j] = '&' then
                                 begin
                                     adicionaFonema (f);
                                     f := '';
                                 end
                             else
                                 f := f + seq_fonemas[j];
                     end;

                 if seq_fonemas <> '' then
                     begin
                         adicionaFonema (f);
                         f := '';
                     end;
             end;

         if pt_aux <> NIL then
             pos_i := pos_i + length (pt_aux^.contexto)
         else
             pos_i := pos_i + 1;
      end;

   adicionaFonema (f);
end;

{--------------------------------------------------------}

procedure pausaPontuacao (c: char; var fonemas: TStringList);
begin
    case c of
        ',': fonemas.add ('_,');
        ':': fonemas.add ('_:');
        ';': fonemas.add ('_;');
        '.': fonemas.add ('_.');
        '(': fonemas.add ('_(');
        ')': fonemas.add ('_)');
        '!': fonemas.add ('_!');
        '?': fonemas.add ('_?');
    end;
end;

{--------------------------------------------------------}

function destonifica (palavra: string): boolean;
begin
    destonifica := (length (palavra) < 3) or
                   (palavra = 'POR') or (palavra = 'DAS') or
                   (palavra = 'DOS') or (palavra = 'COM') OR
                   (palavra = 'NÃO') or (palavra = 'SIM');
end;

{--------------------------------------------------------}

procedure coarticula (var fonemas: TStringList);
var s, s2: string;
    i: integer;

begin
    i := 3;
    while i < fonemas.count-1 do
        begin
            s := fonemas[i];
            if (s <> '') and (s[1] = ';') then
                begin
                    i := i + 1;
                    s := fonemas[i];
                    if (s <> '') and (s[1] in ['a', 'e', 'i', 'o', 'u', 'w', 'y']) then
                        begin
                            s2 := fonemas [i-3];
                            if s2 = 'r2' then fonemas[i-3] := 'r'
                            else
                            if s2 = 's2' then fonemas[i-3] := 'z';
                        end;
                end;

            i := i + 1;
        end;

end;

{--------------------------------------------------------}

procedure compilaFonemas (textoMarcado: TStringList; var fonemas: TStringList);
var
    posTexto: integer;
    tonica: integer;
    palavra, ultPalavra: string;

begin
    fonemas := TStringList.create;
    ultPalavra := '';

    for posTexto := 0 to textoMarcado.Count-1 do
       begin
          fonemas.add (';' + textoMarcado[posTexto]);
          palavra := AnsiUpperCase(copy (textoMarcado[posTexto], 5, 999));
          if palavra = '' then
              begin
                  fonemas.add ('__');
                  fonemas.add ('');
                  continue;
              end;

          if palavra[1] in delimitadores then
              pausaPontuacao (palavra[1], fonemas)
          else
              begin
                  trata_excessoes (palavra);

                  if destonifica (palavra) then
                      tonica := 0
                  else
                      begin
                          tonica := descobreTonica (palavra);
//                          if (tonica > 1) and (palavra[tonica-1] in consoante) then
//                              tonica := tonica - 1;  // melhora prosódia
                      end;


                  traduz (palavra, tonica, fonemas);
              end;

          ultPalavra := palavra;
       end;

    fonemas.add ('__');
    coarticula (fonemas);
end;

{--------------------------------------------------------}

procedure falaEspeciais (opcao: boolean);
begin
    traduzEspec := opcao;
end;

{--------------------------------------------------------}

function inicTradutor (nomeArqRegras, nomeArqExcessoes: string): boolean;
var ok: boolean;
begin
    n_excessoes := 0;

    ok := inicVarsTradutor(nomeArqRegras);
    if ok then
        ok := carregaExcessoes(nomeArqExcessoes);

    inicTradutor := ok;
end;

procedure fimTradutor;
begin
    libMemTradutor;
end;

end.

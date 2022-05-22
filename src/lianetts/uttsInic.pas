unit uttsInic;

interface

function inicVarsTradutor (nomeArq: string): boolean;
procedure libMemTradutor;

const
   TRACO = ^A;

type
   simbolos = #20..#255;                { Todos os caracteres previstos para
                                         aparecer no texto }
   pt_regras = ^ forma_regra;

   forma_regra = record                { Forma da entrada do vetor REGRAS }
                    contexto_a_esquerda : string[5];
                    contexto            : string[5];
                    contexto_a_direita  : string[5];
                    fonemas             : string[20];
                    prox                : pt_regras;
                 end;

var
   regras  : array [simbolos] of
                          pt_regras;   { ponteiros para listas de regras }

implementation

                 
{--------------------------------------------------------}
{            extrai campos de uma regra lida             }
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
{                   le arquivo de regras                 }
{--------------------------------------------------------}

function inicVarsTradutor (nomeArq: string): boolean;
var
   ind_regra : char;                   { Ind p/ a entrada corrente de REGRS }
   regra : forma_regra;                { Regra lida }
   pt_aux,                             { Ponteiro auxiliar }
   novo_reg : pt_regras;               { Regra auxiliar }
   arq_regras: text;                   { Arquivo de regras }
   linha: string;                      { Linha lida do arquivo }

label fim;

begin
   inicVarsTradutor := false;

   ind_regra := #$1f;
   repeat
      ind_regra := succ ( ind_regra );
      regras[ ind_regra ] := nil;
   until ind_regra = #255;

   assign (arq_regras, nomeArq);
   {$i-} reset (arq_regras); {$i+}
   if ioresult <> 0 then
       exit;

// pt_aux := regras['A'];
   while not eof (arq_regras) do
      begin
         readln (arq_regras, linha);
         if (linha <> '') and (linha[1] = ';') then continue;
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

               pt_aux := regras[ind_regra];
               while pt_aux^.prox <> NIL do
                   pt_aux := pt_aux^.prox;

               pt_aux^.prox := novo_reg;
            end;
      end;

fim:
   close( arq_regras );
   inicVarsTradutor := true;
end;

{--------------------------------------------------------}
{               libera memoria do tradutor               }
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

(*  hoje é um array dinâmico, não precisa desalocar.

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

end.

unit uttsExcessoes;

interface

uses sysutils;

const
   MAX_EXCESSOES = 15000;

type
   palavra_alias = record              { pronuncia nao padronizada }
                      palav: string;
                      alias: string;
                   end;

var
   tab_excessoes: array [1..MAX_EXCESSOES] of palavra_alias;
                       { palavras com pronuncia diferente }
   n_excessoes: integer;              { numero de excessoes tratadas }


function carregaExcessoes (nomeArq: string): boolean;
procedure trata_excessoes (var excessao: string);

implementation

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
         texto := AnsiUpperCase(texto);
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

procedure trata_excessoes (var excessao: string);
var esq, dir, meio: integer;
    removido: string;
    letra_final: char;
label deNovo, fim;
begin

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
     if (letra_final = 'S') or (letra_final = 'M') then
         begin
              removido := letra_final + removido;
              delete (excessao, length(excessao), 1);
              if excessao <> '' then goto deNovo;
         end;

fim:
     excessao := excessao + removido;
end;

end.

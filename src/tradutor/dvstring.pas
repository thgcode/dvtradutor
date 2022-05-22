{-------------------------------------------------------------}
{
{    Rotinas genéricas de tratamento de strings
{
{    Autores:   Jose' Antonio Borges
{               Júlio Tadeu Silveira
{
{    Em 26/09/2014
{
{-------------------------------------------------------------}

unit dvstring;

interface

uses
    sysutils;

function primeiraLetra (s: string): char;
function globalTrim (const sOrig: shortString): string;

implementation

{--------------------------------------------------------}
function primeiraLetra (s: string): char;
begin
    s := trim(s);
    if s <> '' then
        primeiraLetra := upcase(s[1])
    else
        primeiraLetra := ' ';
end;

{--------------------------------------------------------}
function globalTrim (const sOrig: shortString): string;
var
    i, esq, dir: integer;
    espacolido: boolean;
    s: string;

label
    continue;
begin
    s := TrimLeft (sOrig);
    i := 1;
    espacolido := true;

    while i <= length(s) do
        begin
            if s[i] = ' ' then
                begin
                    if not espacolido then
                        espacolido := true
                    else
                        begin
                            esq := i;
                            dir := i+1;
                            while (dir <= length(s)) and (s[dir] = ' ') do
                                dir := dir +1;
                            if dir > length(s) then
                                i := dir
                            else
                                begin
                                    i := esq;
                                    espacolido := false;
                                    while dir <= length(s) do
                                        begin
                                            s[esq] := s[dir];
                                            esq := esq +1;
                                            dir := dir +1;
                                        end;
                                    while esq <= length(s) do
                                        begin
                                            s[esq] := ' ';
                                            esq := esq +1;
                                        end;
                                end;
                            goto continue;
                        end
                end
            else
                espacolido := false;

            i := i +1;
continue:
        end;    // while i <= length(s)

    result := TrimRight (s);

end;

end.

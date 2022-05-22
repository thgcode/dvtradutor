{-------------------------------------------------------------}
{
{    Procedimento padronizado de senha para programas
{    Autor: José Antonio Borges
{    Em 12/10/99
{
{-------------------------------------------------------------}

unit dvsenha;

interface
uses winprocs, wintypes, winDos, dvcrt, dvwin;

function copiaRegistrada (aplicativo, nomeArq, semente: string; var nomeUsuario: string): boolean;
function registraCopia (aplicativo, nomeArq, semente, nomeUsuario, senha: string): boolean;
function calculaSenhaOficial (dia, mes, ano: word; nomeArq: string): string;

implementation

const
    traduz: string =
        'eroiuqwfnxzvpaoaerasdnaeroidfkhfjhasdlryweuihvckaeoiruyfjhaweroiuyakjhfasdkfjhf';

{-------------------------------------------------------------}

function calculaSenhaOficial (dia, mes, ano: word; nomeArq: string): string;
var l: longint;
    i: integer;
    senha: string;
begin
     l := 0;
     for i := 1 to length (nomeArq) do
          l := (l shr 1) xor ord(nomeArq[i]);
     l := l + (longint(dia) * 7 * longint(mes) * 7 * longint(ano)) + 1 + longint(10000000);
     str (l, senha);
     calculaSenhaOficial := senha;
end;

{-------------------------------------------------------------}

procedure decrementaData (var dia, mes, ano: word);
begin
    dia := dia - 1;
    if dia = 0 then
        begin
            mes := mes - 1;
            dia := 31;    {aproximado, evita erros do usuário}
            if mes = 2 then dia := 29;
            if mes = 0 then
                begin
                    mes := 12;
                    ano := ano - 1;
                end;
        end;
end;

{-------------------------------------------------------------}

function pegaSenhaRegistrada (aplicativo: string): string;
var i, n: integer;
    nomeSecao, chave: string;
begin
    nomeSecao := 'PASSWORDS' + #$0;
    aplicativo := aplicativo + #$0;
    n := GetPrivateProfileString(@nomeSecao[1], @aplicativo[1],
         '', @chave[1], 80, 'WIN.INI');
    chave[0] := chr(n);
    for i := 1 to n do
         chave [i] := chr (ord (chave[i]) and $7f);
    pegaSenhaRegistrada := chave;
end;

{-------------------------------------------------------------}

procedure registraSenha (aplicativo, chave: string);
var i: integer;
    nomeSecao: string;
begin
    nomeSecao := 'PASSWORDS' + #$0;
    aplicativo := aplicativo + #$0;
    for i := 1 to length (chave) do
         chave [i] := chr (ord (chave[i]) or $80);
    if chave = '' then
        WritePrivateProfileString(@nomeSecao[1], @aplicativo[1], NIL, 'WIN.INI')
    else
        begin
            chave := chave + #$0;
            WritePrivateProfileString(@nomeSecao[1], @aplicativo[1], @chave[1], 'WIN.INI');
        end;
end;

{-------------------------------------------------------------}

procedure pegaDataDoArquivo (var arq: text; var dia, mes, ano: word);
var t: longint;
    dt: TDateTime;
begin
    getFTime (arq, t);
    unpackTime (t, dt);
    dia := dt.day;
    mes := dt.month;
    ano := dt.year;
end;

{-------------------------------------------------------------}

function copiaRegistrada (aplicativo, nomeArq, semente: string; var nomeUsuario: string): boolean;
var arq: text;
    dia, mes, ano: word;
    registro, senha: string;
    i: integer;
begin
    copiaRegistrada := false;
    nomeUsuario := '';

    assign (arq, nomearq);
    {$I-} reset (arq);  {$I+}
    if ioresult <> 0 then
        exit;

    {$I-} readln (arq, nomeUsuario); {$I+}
    if ioresult <> 0 then
        exit;

    for i := 1 to length (nomeUsuario) do
         nomeUsuario [i] :=
              chr (ord (nomeUsuario [i]) xor (ord (traduz[i]) and $1f));

    pegaDataDoArquivo (arq, dia, mes, ano);
    close (arq);

    registro := pegaSenhaRegistrada (aplicativo);
    if registro <> '' then
        begin
            senha := calculaSenhaOficial (dia, mes, ano, semente);
            if registro = senha then
                begin
                    copiaRegistrada := true;
                    exit;
                end;
        end;

    nomeUsuario := '';
end;

{-------------------------------------------------------------}

function registraCopia (aplicativo, nomeArq, semente, nomeUsuario, senha: string): boolean;
var arq: text;
    i: integer;
    registro, senhaOficial, senhaAltern: string;
    dia, mes, ano, sem: word;
    time: longint;
    dt: TDateTime;
begin
    registraCopia := false;

    assign (arq, nomeArq);
    {$I-}  rewrite (arq);  {$I+}
    if ioresult <> 0 then exit;
    for i := 1 to length (nomeUsuario) do
         nomeUsuario [i] :=
              chr (ord (nomeUsuario [i]) xor (ord (traduz[i]) and $1f));
    {$I-}  writeln (arq, nomeUsuario);  {$I+}
    if ioresult <> 0 then exit;

    pegaDataDoArquivo (arq, dia, mes, ano);
    close (arq);

    senhaOficial := calculaSenhaOficial (dia, mes, ano, semente);
    for i := 1 to 10 do
        begin
            senhaAltern := calculaSenhaOficial (dia, mes, ano, semente);
            if senhaAltern = senha then
                begin
                    registraSenha (aplicativo, senhaOficial);
                    registraCopia := true;
                    exit;
                end;
            decrementaData (dia, mes, ano);
        end;

    registraSenha (aplicativo, '');
end;

end.

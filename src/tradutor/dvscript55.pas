{--------------------------------------------------------}
{
{    Interpretador de script
{
{    Autor: José Antonio Borges
{
{    Em 23/06/2000
{
{--------------------------------------------------------}

{------------------------------------------------------------------------------------------}
{
{    Resumo da sintaxe
{
{    Interações com o usuário
{        escreve [MUDO] ["frase" ou variavel]...  {terminado por & nao pula linha
{        fala ["frase" ou variavel]
{        le [MUDO ou SENHA] [variavel]            {terminado por & lê só uma tecla
{        tela [limpa ou minimizada ou normal ou @x,y]
{        cursor [CAPTURA] x y
{        bipa [tipoBip]                           {0 = bip  1 = clek
{        cor ["valor" ou variavel]
{        fundo ["valor" ou variavel]
{        observa TECLADO [variavel]    {0: não foi teclado nada   1: requer leitura
{
{    Menu interativo
{        menu CRIA xmin ymin xmax ymax
{        menu ADICIONA ["valor" ou variavel]
{        menu EXECUTA [variavel] [variavel] [variavel]    { retornados:
{                                        número do item, letra teclada e item }
{        menu TERMINA
{
{    Operações com arquivo
{        abre #n arquivo     {terminado por & arquivo e' criado ou acrescentado se existir
{        fecha #n
{        le #n variavel
{        escreve #n [variavel]                 {terminado por & nao pula linha
{        remove ["nomeArquivo" ou variavel]    {terminado por & não dá erro se não apagar
{        renomeia ["nomeArquivo" ou variavel] ["novoNome" ou variavel]
{                                              {terminado por & não dá erro se não renomear
{        replica ["nomeArquivo" ou variavel] ["novoNome" ou variavel]
{                                              {terminado por & não dá erro se não renomear
{        busca [variavel] [DIR] [["nomeArqs" ou variável] ou PRÓXIMO]
{                            { se omitido nome ou PRÓXIMO devolve diretório atual
{        dir [CRIA, REMOVE, TROCA] ["nomeDiretorio" ou variavel]
{                                  {terminado por & não dá erro
{        checa [variavel]          {resultado da última operacao le, escreve
{                                  {0: Não houve problemas    > 0: erro
{
{    Operações com Internet
{        internet [INICIA, TERMINA]
{        conecta #n [SSL] ["valor" ou variavel] ["porta" ou variavel]
{        serve #n ["porta" ou variavel] [&]
{        aceita #n #p
{        observa #n [variavel]    {0: porta não requer atenção   1: requer leitura
{        ip [LOCAL, REMOTO] #n [variavel]
{
{    Processamento da porta serial (para arduíno)
{        serial #n porta [veloc nbits nstops parid]
{                       nbits: 5 6 7 8; nstops: 1 2; parid 0 sem 1 impar 2 par
{        observa #n [variavel]    {0: sem dados   1: requer leitura
{
{    Processamento de desvios
{        executa ["programa" ou variavel]     {terminado por & nao espera terminar
{        desvia [SCRIPT] [@rotulo ou variavel]
{        chama [@rotulo ou variavel]
{        chama remoto ["valor" ou variavel] ["valor" ou variavel]
{                          exemplo: chama remoto "rotina" "parametros"
{        retorna
{        se [NÃO] [variavel] [comparador] ["valor" ou variavel] comando
{        cmd [variavel]
{        termina [mudo]
{        debug [-]
{
{    Processamentos de comandos múltiplos e repetições
{        se [NÃO] [variavel] [comparador] ["valor" ou variavel]
{               senão     opcional
{               fim se        marca o final
{        enquanto [NÃO] [variavel] [comparador] ["valor" ou variavel]
{               fim enquanto        marca o final
{        repete [variavel] ["valor" ou variavel]
{               fim repete          marca o final
{
{    Processamento de variáveis
{        [seja] [variavel] [ = ] [expressão]
{        ou
{        [seja] [variavel] [ = ] [funcaoOpcional] [valor ou variavel]...
{                * após as funções DATA, HORA e DIA não se coloca [valor ou variavel]
{                é opcional usar um sinal de = após a variável
{        soma [variavelDest] [valor ou variavel]
{                na soma, eventuais prefixos alfabéticos da variável são mantidos
{        subtrai [variavelDest] [valor ou variavel]
{        multiplica [variavelDest] [valor ou variavel]
{        divide [variavelDest] [valor ou variavel]
{        concatena [variavelDest] [valor ou variavel]
{        copia [variavelDest] [variavel] [caracinicio] [caracfim]
{        transfere [DE, PARA] [variavel]
{        substitui [variavel] [valor antigo] [valor novo]
{        troca [variavelDest] [valor novo] [caracinicio] [caracfim]
{        randomiza
{        converte [variavel] [PARA/DE] [UTF8, URL, MIME, QP]
{
{    Operações com janelas
{        espera [tempo] [MS]    {normalmente em segundos
{        espera [tempo] ["nome janela" ou variavel]
{        janela [FECHA, MINIMIZA, MAXIMIZA, NORMAL] ["nome janela" ou variavel]
{        captura [TÍTULO ou ATIVA, CAMPO, FOCO] [variavel]
{
{    Ações do teclado e mouse
{        digita "frase" [enter]
{        aciona [tecla virtual]
{        clica [DUPLO, DIREITA, NULO] [onde]    // pode-se usar também mouse ou rato
{        mouse CAPTURA [onde]
{
{    Ações de multimídia
{        toca "frase" ou variável                 {terminado por & nao espera terminar
{        mci [variavelRetorno] ["frase" ou variável]
{        sensor [variavel]      {informa o sensor ativo (1..32) da matriz Mapavox}
{
{    Processamento MSAA
{        MSAA captura x y
{        MSAA monitora
{        MSAA fim
{        MSAA checa
{        MSAA nome [variavel]
{        MSAA codigo [variavel]
{        MSAA tipo [variavel]
{        MSAA estado [variavel]
{        MSAA valor [variavel]
{        MSAA area  [variavel x] [variavel y] [variavel larg] [variavel alt]
{
{    Ações de mostrar imagem
{        IMAGEM ""                     -> limpa a imagem
{        IMAGEM "arq_bmp_ou_jpg" x y [COLA]
{                      -> se x y omitido, vale (1,1), mas não pode colar
{                      -> se terminado por & ignora erro de arquivo
{    Ações com listas
{       seja l = []
{       seja l = [valor, valor, valor...]
{       seja l[posicao] = valor
{       seja l[] = valor  -> insere ao final
{       le LISTA l [terminador] --> todas as linhas do arquivo são lidas
{                      para uma lista nova até encontrar terminador (opcional).
{
{       escreve LISTA l   --> todas as posições da lista são escritas
{       seja t = |l|
{       insere l n valor
{       retira l 3
{       procura posic l n valor {PARCIAL, MAIUSC}
{           --> iniciando n+1, atualizando posic;
{           --se não existe posic := -1 ;
{       anexa l_destino l_a_anexar
{       ordena l {DECRESCENTE, NUMÉRICO}
{       separa variavel l separador --> uma variavel contendo subcadeias
{                divididas por um separador é transformada numa lista
{       concatena variavel LISTA l [separador]
{
{------------------------------------------------------------------------------------------}
{
{    [valor]     "cadeia de caracteres" ou número ou (expressão) ou posição de vetor
{    [expressão] expressão inteira com os operadores (+-*/) e parênteses
{    [funcaoOpcional]    TAMANHO, MAIUSC, RAND, TRIM, POS [variavel ou valor],
{                        DATA, DIA, HORA, TEMPO, PALAVRA
{    [variavel]  letra de a-z (maiusculas = minusculas)
{                ou $ seguido por várias letras de a-z ou 0-9
{                ou posição de vetor
{    [comparador] '=' '<>' '<' '>' '>=' '<='
{                 '==' '*=*' '=*' '*='
{    [rotulo]  qualquer coisa começada por '@'
{    [arquivo]  frase ou variavel
{    comentario: linha começada por *
{    [Onde]
{        x, y
{        tela x, y
{
{------------------------------------------------------------------------------------------}

unit dvscript55;

interface
uses dvwin, dvcrt, windows, classes, synacode,
     messages, sysUtils, mmsystem,
     {$IFDEF VER150}
     dateutils,
     {$ENDIF}
     dvmacro, dvexec, winsock, dvinet, dvmsaa, dvform, dvjpeg, dvcomm,
     pngImage, jpeg;

const
    VERSAO_DVSCRIPT = '5.5b';

    SCR_OK = 0;
    SCR_ERROEXEC = 1;
    SCR_SEMARQUIVO = 2;
    SCR_ROTULOINVALIDO = 3;

type
    RotinaExterna = function (str : string): string;

var
    fimScript, fimScriptMudo: boolean;
    rotinaExternaPtr : RotinaExterna;

function cmdScript (lido: string): boolean;
function executaScript (nomeArq, rotulo: string;
        var ultLinhaProc: integer; var linhaProc: string): integer;
function executaScriptList (scriptOriginal: TStringList; rotulo: string;
        var ultLinhaProc: integer; var linhaProc: string): integer;
function executaScriptControlador (nomeArq: string; rotina: RotinaExterna;
        var ultLinhaProc: integer; var linhaProc: string): integer;
procedure zeraVarScript;

function extraiValor (var lido: string; var valor: string): boolean;
function guardaValor (var lido: string; valor: string): boolean;

{-------------------------------------------------------------------------------}
{   Evitar acessar esta rotina e estas variáveis diretamente!                   }
{   em versões posteriores do sistema, não estarão mais disponíveis!            }
{-------------------------------------------------------------------------------}

function extraiVariavel (var lido: string; var v: char; var idx: integer): boolean;

var
    varScript: array ['A'..chr(ord('Z') + 101)] of string;
    listaScript: array ['A'..chr(ord('Z') + 101)] of TStringList;
    nomeVarLonga: TStringList;

implementation

const
    MAXSCRIPT = 5000;
    MAXRETORNO = 20;

const
    PROX_INDEX = -2;
    SEM_INDEX  = -1;

const
    DEBUG_DESLIGADO    = 'Debug desligado';
    DEBUG_LIGADO       = 'Debug ligado';
    ERRO_ABRE          = 'Erro na abertura do arquivo';
    ERRO_FECHA         = 'Erro no fechamento do arquivo';
    ERRO_ARQUIVO       = 'Erro no processamento de arquivo';
    ERRO_ESCRITA       = 'Erro na escrita de arquivo';
    ERRO_APAGA         = 'Erro no apagamento do arquivo ';
    ERRO_DIR           = 'Erro no processamento do diretório ';
    ERRO_CONEXAO       = 'Erro de conexao';
    ERRO_HTTP          = 'Erro no processamento HTTP';
    ERRO_PORTA         = 'Erro na porta TCP/IP';
    DIVISAO_ZERO       = 'Divisão por zero';
    STACK_OVERFLOW     = 'Muitas chamadas sem retorno';
    STACK_UNDERFLOW    = 'Retorno sem chamada';
    COMANDO_INVALIDO   = 'Comando inválido: ';
    INDICE_INVALIDO    = 'Índice inválido em lista: ';
    ERRO_TRUNC         = 'Cópia para transferência truncada a 10000 caracteres';
    LELISTA_SODISCO    = 'Leitura em lista só é permitida para arquivos em disco';
    LISTA_INEXISTE     = 'Lista inexistente';
    SEPARA_INVALIDO    = 'Separador inválido';
    LOOP_INVALIDO      = 'Fim de repetição sem início';
    LOOP_ABERTO        = 'Faltou o fim da repetição';
    FALTOU_FIMSE       = 'Comando FIM SE faltando';
    FALTOU_SENAO_FIMSE = 'Comando SENÃO ou FIM SE faltando';
    SENAO_ERRADO       = 'Comando SENÃO não pode ter adendos nesta versão';
    MANUAL_PARCIAL     = 'Ajudas por comando ainda não disponíveis, vou abrir o manual.';
    ERRO_URL           = 'Esse não parece ser um site válido.';

type
    TARQ = record
        aberto: boolean;
        serial: boolean;
        internet: boolean;
        soquete: longint;
        pbuf: pBufRede;
        arq: text;
    end;

var
    script: TStringList;
    linhaAtual: integer;
    topoRetorno: integer;
    pilhaRetorno: array [1..MAXRETORNO] of integer;
    debug: boolean;
    erroProc: boolean;
    cmd: string;
    arq: text;
    statusUltIO: integer;
    itemInic: integer;
    precisaDeIgual: boolean;

    tempo0: longint;
    semana0: word;

    arquivo: array ['0'..'9'] of TARQ;

    dirInfo: TSearchRec;
    atribBusca: word;

    BMPGlobal: TBitmap;

type
    TPilha = class(TList)
        function empty: boolean;
        procedure push (i: integer);
        function pop: integer;
    end;

var
    pilhaEnquanto, pilhaRepete: TPilha;

{--------------------------------------------------------}
{               implementação de uma pilha
{--------------------------------------------------------}

function TPilha.empty: boolean;
begin
    result := count = 0;
end;

function TPilha.pop: integer;
begin
    if empty then
        result := -1
    else
        begin
            result := integer(items[count-1]);
            delete(count-1);
        end;
end;

procedure TPilha.push(i: integer);
begin
   Add(pointer(i));
end;

{--------------------------------------------------------}
{               rotinas pré-declaradas
{--------------------------------------------------------}

function calculaExpressao (var lido: string; var valor: string): boolean;  forward;

{--------------------------------------------------------}
{             carrega um script na memoria
{--------------------------------------------------------}

function carregaScript (nomeArq: string): boolean;
var
    lido: string;
begin
    assign (arq, nomeArq);
    {$I-} reset (arq);  {$I+}
    if ioresult <> 0 then
        begin
            result := false;
            exit;
        end;

    while (not eof (arq)) do
        begin
            readln (arq, lido);
            script.Add(trim (lido));
        end;

    close (arq);
    result := true;
end;

{--------------------------------------------------------}
{                 libera a area de script
{--------------------------------------------------------}

procedure liberaScript;
begin
    script.Clear;
end;

{--------------------------------------------------------}
{       ignora um certo caractere na cadeia lida
{--------------------------------------------------------}

procedure ignoraCarac (var lido: string; c: char);
begin
    lido := trim(lido);
    if (lido <> '') and (lido[1] = c) then
        delete (lido, 1, 1);
    lido := trim(lido);
end;

{--------------------------------------------------------}
{   pega primeira palavra de uma string, em maiúsulos
{--------------------------------------------------------}

function pegaPalavraMaiusc (var lido: string): string;
var
    pal: string;
    c: char;
begin
    pal := '';
    lido := trim(lido);
    if lido <> '' then
        repeat
            c := lido [1];
            delete (lido, 1, 1);
            if c <> ' ' then
                pal := pal + c;
        until (c = ' ') or (c = '=') or (lido = '');
    result := ansiUpperCase(pal);
end;

{--------------------------------------------------------}
{             busca um rótulo no arquivo
{--------------------------------------------------------}

function buscaRotulo (rotulo: string): boolean;
var i: integer;
    lido: string;
begin
    rotulo := maiuscAnsi (rotulo);
    for i := 0 to script.Count-1 do
        begin
            lido := script[i];
            if (lido <> '') and (lido[1] = '@') then
                 begin
                     if maiuscAnsi (copy (lido, 2, length (lido)-1)) = rotulo then
                         begin
                             result := true;
                             linhaAtual := i;
                             exit;
                         end;
                 end;
        end;
     result := false;
end;

{--------------------------------------------------------}
{              extrai uma variavel do comando
{--------------------------------------------------------}

function varLonga (var lido: string; var v: char): boolean;
var nome: string;
    n: integer;
begin
    // lido já vem sem o "$" inicial da variável longa

    result := false;
    if lido = '' then exit;

    while (lido <> '') and (upcase(lido[1]) in ['A'..'Z', '0'..'9', '_']) do
        begin
            nome := nome + upcase(lido[1]);
            delete (lido, 1, 1);
        end;

    if length (nome) = 0 then exit;

    n := nomeVarLonga.indexOf(nome);
    if n < 0 then
        begin
            nomeVarLonga.Add(nome);
            n := nomeVarLonga.count-1;
        end;

    v := chr (n+1 + ord('Z'));
    lido := trim (lido);
    result := true;
end;

{--------------------------------------------------------}

function extraiNomeVar (var lido: string; var v: char): boolean;
begin
    result := false;
    v := ' ';

    lido := trim (lido);
    if lido = '' then exit;

    v := upcase(lido[1]);
    delete (lido, 1, 1);

    if not (v in ['$', 'A'..'Z']) then
        exit;  // variável inválida

    if v = '$' then
        begin
            if not varLonga (lido, v) then exit;
        end
    else
        begin
            if (lido <> '') and    // tentativa de uso de variável longa sem $
               (upcase (lido[1]) in ['A'..'Z', '0'..'9', '_']) then exit;
        end;

    lido := trim (lido);
    result := true;
end;

{--------------------------------------------------------}

function extraiVariavel (var lido: string; var v: char; var idx: integer): boolean;
var s: string;
    erro: integer;
begin
    idx := SEM_INDEX;
    extraiVariavel := false;
    if not extraiNomeVar (lido, v) then
        exit;

    if (lido <> '') and (lido[1] = '[') then
        begin
            delete (lido, 1, 1);
            lido := trim (lido);
            if (lido <> '') and (lido[1] = ']') then
                begin
                    idx := PROX_INDEX;
                    delete (lido, 1, 1);
                end
            else
            if (lido <> '') and (lido[1] <> ']') then
                begin
                    if not calculaExpressao (lido, s)  then exit;
                    val (s, idx, erro);
                    if erro <> 0 then exit;
                    if (length(lido) < 1) or (lido[1] <> ']') then exit;

                    delete (lido, 1, 1);
                    lido := trim (lido);

                    if (listaScript[v] = NIL) or (listaScript[v].Count <= idx) then
                        begin
                            sintWriteln (INDICE_INVALIDO + ' ' + intToStr(idx));
                            exit;
                        end;
                end;
        end;

    lido := trim (lido);
    extraiVariavel := true;
end;

{--------------------------------------------------------}

function guardaVar (v: char; idx: integer; valor: string): boolean;
begin
    result := false;
    if idx = SEM_INDEX then
         varScript[v] := valor
    else
    if idx = PROX_INDEX then
        begin
            if listaScript[v] <> NIL then
                listaScript[v].add(valor)
            else
                begin
                    sintWriteln (LISTA_INEXISTE);
                    exit;
                end;
        end
    else
    if (listaScript[v] = NIL) or (listaScript[v].Count <= idx) then
        begin
            sintWriteln (INDICE_INVALIDO + ' ' + intToStr(idx));
            exit;
        end
    else
        listaScript[v][idx] := valor;

    result := true;
end;

{--------------------------------------------------------}

function pegaVar (v: char; idx: integer; var valor: string): boolean;
begin
    result := false;
    if idx = SEM_INDEX then
         valor := varScript[v]
    else
    if (listaScript[v] = NIL) or (listaScript[v].Count <= idx) or
       (idx = PROX_INDEX) then
        begin
            sintWriteln (INDICE_INVALIDO + ' ' + intToStr(idx));
            exit;
        end
    else
        valor := listaScript[v][idx];

    result := true;
end;

{--------------------------------------------------------}
{        calcula a string do início do trecho lido
{--------------------------------------------------------}

function calculaString (var lido: string; var valor: string): boolean;
var
    tam: integer;
begin
    valor := '';
    repeat
        delete (lido, 1, 1);

        tam := pos ('"', lido);
        if tam = 0 then
            begin
                valor := lido;
                lido := '';
                result := false;
                exit;
            end;

        valor := valor + copy (lido, 1, tam-1);
        delete (lido, 1, tam);

        if (lido <> '') and (lido[1] = '"') then
            valor := valor + '"';

    until (lido = '') or (lido[1] <> '"');

    lido := trim (lido);
    calculaString := true;
end;

{--------------------------------------------------------}
{        calcula a string do início do trecho lido
{--------------------------------------------------------}

function calculaCardin (var lido: string; var valor: integer): boolean;
var v: char;
begin
   calculaCardin := false;
   valor := 0;

   if (lido <> '') and (lido[1] <> '|') then exit;
   delete (lido, 1, 1);
   if not extraiNomeVar (lido, v) then exit;
   if listaScript[v] = NIL then valor := -1
                           else valor := listaScript[v].count;
   if (lido <> '') and (lido[1] <> '|') then exit;

   delete (lido, 1, 1);
   lido := trim (lido);
   calculaCardin := true;
end;

{--------------------------------------------------------}
{       calcula o valor do início do trecho lido
{--------------------------------------------------------}

function calculaVariavel (var lido: string; var valor: string): boolean;
var
    v: char;
    idx: integer;
label loopAspas;
begin
    calculaVariavel := false;
    valor := '';
    lido := trim (lido);
    if lido = '' then exit;

    if extraiVariavel(lido, v, idx) then
        begin
            if idx = PROX_INDEX then exit;
            if idx = SEM_INDEX  then  valor := varScript[v]
                                else  valor := listaScript[v][idx];
            calculaVariavel := true;
        end;
end;

{--------------------------------------------------------}
{         transforma o lido numero de arquivo
{--------------------------------------------------------}

function extraiNumArq (var lido: string; var arqSel: char): boolean;
var s: string;
begin
    extraiNumArq := false;

    lido := trim (lido);
    if lido = '' then exit;
    arqSel := ' ';

    if lido[1] <> '#' then exit;

    delete (lido, 1, 1);
    if lido = '' then
        exit;

    if not extraiValor(lido, s) then exit;
    if (length (s) <> 1) or (s[1] < '0') or (s[1] > '9') then exit;
    arqsel := s[1];

    lido := trim(lido);

    extraiNumArq := true;
end;

{--------------------------------------------}
{ Avaliador de expressão aritmética          }
{ Por Antonio Borges e Bernard Condorcet     }
{ Consultor: Antonio Anibal Teles            }
{ Em março/2007                              }
{--------------------------------------------}

(*      Sintaxe para a expressão aritmética LL(1)

        <Exp> ::= <Term> <s_Exp>
        <s_Exp> ::= + <Exp> | - <Exp> | nil
        <Term> ::= <Factor> <op_Term>
        <op_Term> ::= * <Term> | / <Term> | % <Term> |  nil
        <Factor> ::= x | y | ... |  ( <Exp> ) |  - <Factor>
*)

function calculaExpressao (var lido: string; var valor: string): boolean;
type
    TToken = char;  { + - * % / ( ) # @ NIL }

var
    follow: TToken;
    vfollow: integer;
    followString: string;
    lidoAnt: string;

{-----------------------------------}

function calc_Exp (var v: integer): boolean;   forward;
function calc_Term (var v: integer): boolean;  forward;

{-----------------------------------}

procedure nextToken;
var error: integer;
begin
    vfollow := 0;
    follow := '?';

    lido := trimLeft(lido);
    lidoAnt := lido;
    if lido = '' then
        follow := #$0
    else
    if lido[1] in ['+', '-', '*', '/', '%', '(', ')'] then
        begin
            follow := lido[1];
            delete (lido, 1, 1);
        end
    else
    if lido[1] in ['0'..'9'] then
        begin
            follow := '#';
            repeat
                vfollow := (vfollow * 10) + (ord(lido[1]) - ord('0'));
                delete (lido, 1, 1);
            until (lido = '') or not (lido[1] in ['0'..'9']);
        end
    else
    if lido[1]= '|' then
        begin
            vfollow := 0;
            if calculaCardin(lido, vfollow) then
                follow := '#'
            else
                follow := '?';
        end
    else
    if lido[1]= '"' then
        begin
            vfollow := 0;
            if calculaString(lido, followString) then
                follow := '@'
            else
                follow := '?';
        end
    else
    if upcase(lido[1]) in ['A'..'Z', '$'] then
        begin
            follow := '?';
            vfollow := 0;
            if calculaVariavel (lido, followString) then
                begin
                    val (followString, vfollow, error);
                    if error = 0 then
                        follow := '#'
                    else
                        follow := '@';
                end
        end;
end;

{-----------------------------------}

function calc_factor (var v: integer): boolean;
var op: TToken;
begin
    calc_factor := false;
    v := 0;
    op := follow;

    case op of
        '#': begin
                v := vfollow;
                nextToken;
                calc_factor := true;
             end;

        '-': begin
                nextToken;
                if calc_factor (v) then
                    begin
                         v := -v;
                         calc_factor := true;
                    end;
             end;

        '(': begin
                 nextToken;
                 if calc_exp (v) then
                     if follow = ')' then
                         begin
                             calc_factor := true;
                             nextToken;
                         end;
             end;
    end;
end;

{-----------------------------------}

function calc_Term (var v: integer): boolean;
var v1, v2: integer;
    op: char;
begin
    calc_Term := false;
    if calc_factor (v1) then
        begin
            calc_Term := true;
            op := follow;
            v := v1;
            while (op = '*') or (op = '/') or (op = '%')do
                begin
                    nextToken;
                    if calc_factor (v2) then
                        begin
                            case op of
                                '*': v := v1 * v2;
                                '/': v := v1 div v2;
                                '%': v := v1 mod v2;
                            end;
                        end
                    else
                        if (follow = '*') or (follow = '/') or (follow = '%') then  // evita ** e outros
                            begin
                                calc_Term := false;
                                exit;
                            end;
                    op := follow;
                    v1 := v;
                end;
        end;
end;

{-----------------------------------}

function calc_Exp (var v: integer): boolean;
var v1, v2: integer;
    op: char;
begin
    calc_Exp := false;
    if calc_term (v1) then
        begin
            calc_Exp := true;
            op := follow;
            v := v1;
            while (op = '+') or (op = '-') do
                begin
                    nextToken;
                    if calc_term (v2) then
                        begin
                            case op of
                                '+': v := v1 + v2;
                                '-': v := v1 - v2;
                            end;
                        end
                    else
                        if (follow = '-') or (follow = '-') then  // evita ++. -- e outros
                            begin
                                calc_Exp := false;
                                exit;
                            end;
                    op := follow;
                    v1 := v;
                end;
        end;
end;

{-----------------------------------}

var
    v: integer;
begin
    nextToken;
    if follow = '@' then
        begin
            valor := followString;
            result := true;
        end
    else
        begin
            v := 0;
            result := calc_Exp (v); {and (follow = #$0)}
            valor := intToStr(v);
            lido := lidoAnt;
        end;
end;

{--------------------------------------------------------}

function extraiValor (var lido: string; var valor: string): boolean;
begin
    extraiValor := calculaExpressao (lido, valor);
end;

{--------------------------------------------------------}

function guardaValor (var lido: string; valor: string): boolean;
var
    v: char;
    idx: integer;
begin
    guardaValor := extraiVariavel(lido, v, idx) and guardaVar(v, idx, valor);
end;

{--------------------------------------------------------}

function extraiValorInteiro (var lido: string; var valorInteiro: integer): boolean;
var valor: string;
    erro: integer;
begin
    extraiValorInteiro := false;
    valorInteiro := 0;
    if lido = '' then exit;

    if calculaExpressao (lido, valor) then
        begin
            val (valor, valorInteiro, erro);
            if erro = 0 then
                begin
                    extraiValorInteiro := true;
                    exit;
                end;
        end;
end;

{--------------------------------------------------------}
{              inicializa uma lista
{--------------------------------------------------------}

function inicLista (var lido: string; var v: char): boolean;
var valor: string;
begin
    inicLista := false;

    if listaScript[v] <> NIL then
        listaScript[v].free;
    listaScript[v] := TStringList.Create;

    delete (lido, 1, 1);   // remove "[" inicial
    lido := trim (lido);
    while (lido <> '') and (lido[1] <> ']') do
         begin
             if not calculaExpressao(lido, valor) then exit;
             listaScript[v].Add(valor);

             if lido = '' then exit;           // não fechou a lista
             if (lido[1] = ']') then  break;   // fechou a lista
             if (lido[1] <> ',') then exit;

             delete (lido, 1, 1);
             lido := trim(lido);
         end;

    delete (lido, 1, 1);
    lido := trim(lido);
    inicLista := true;
end;

{--------------------------------------------------------}
{                    Comando Debug
{--------------------------------------------------------}

function processaDebug (lido: string): boolean;
begin
    if (lido = '-') or
       (copy (lido, 1, 1) = 'N') then
        begin
            debug := false;
            sintWriteln (DEBUG_DESLIGADO);
        end
    else
        begin
            debug := true;
            sintWriteln (DEBUG_LIGADO);
        end;

    processaDebug := true;
end;

{--------------------------------------------------------}
{                   comando randomiza
{--------------------------------------------------------}

function processaRandomiza (lido: string): boolean;
begin
    processaRandomiza := false;
    if lido <> '' then exit;

    randomize;
    processaRandomiza := true;
end;

{--------------------------------------------------------}
{                   comando seja
{--------------------------------------------------------}

function processaSeja (lido: string): boolean;
var v: char;
    i, p, nc: integer;
    r: longint;
    erro: integer;
    s, fun, valor, busc: string;
    ano, mes, dia, semana: word;
    hora, minuto, segundo, cent: word;
    ndias: integer;
    tempo: longint;
    {$IFDEF VER150}
    date_and_time: TDateTime;
    {$ENDIF}
    idx: integer;
const
    tabSemana: array [0..6] of string[9] =
        ('Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado');
begin
    processaSeja := false;
    if not extraiVariavel (lido, v, idx) then exit;

    if lido = '' then exit;
    if precisaDeIgual and (lido[1] <> '=') then
        exit;

    if lido[1] = '=' then
        begin
            delete (lido, 1, 1);
            lido := trim (lido);
        end;

    if (lido <> '') and (lido[1] = '[') then
        begin
            processaSeja := inicLista (lido, v);
            exit;
        end;

    if lido = '' then exit;

    if maiuscAnsi (lido) = 'DATA' then
        begin
       {$IFDEF VER150}
            date_and_time := now;
            decodeDate (date_and_time, ano, mes, dia);
       {$ELSE}
            getDate(ano, mes, dia, semana);
       {$ENDIF}
            str (dia, s);
                if length (s) = 1 then s := '0' + s;
                valor := s;
            str (mes, s);
                if length (s) = 1 then s := '0' + s;
                valor := valor + '/' + s;
            str (ano, s);
                if length (s) = 1 then s := '0' + s;
                valor := valor + '/' + s;

            processaSeja := guardaVar(v, idx, valor);
            exit;
        end;

    if maiuscAnsi (lido) = 'HORA' then
        begin
       {$IFDEF VER150}
            date_and_time := now;
            decodeTime (date_and_time, hora, minuto, segundo, cent);
       {$ELSE}
            gettime (hora, minuto, segundo, cent);
       {$ENDIF}
            str (hora, s);
                if length (s) = 1 then s := '0' + s;
                valor := s;
            str (minuto, s);
                if length (s) = 1 then s := '0' + s;
                valor := valor + ':' + s;
            str (segundo, s);
                if length (s) = 1 then s := '0' + s;
                valor := valor + ':' + s;
            processaSeja :=  guardaVar(v, idx, valor);
            exit;
        end;

    if maiuscAnsi (lido) = 'DIA' then
        begin
       {$IFDEF VER150}
            date_and_time := now;
            semana := dayOfTheWeek (date_and_time);
       {$ELSE}
            getDate(ano, mes, dia, semana);
       {$ENDIF}
            processaSeja := guardaVar(v, idx, tabSemana[semana]);
            exit;
        end;

    if maiuscAnsi (lido) = 'TEMPO' then
        begin
        {$IFDEF VER150}
            date_and_time := now;
            decodeDate (date_and_time, ano, mes, dia);
            semana := dayOfTheWeek (date_and_time);
            decodeTime (date_and_time, hora, minuto, segundo, cent);
        {$ELSE}
            getDate(ano, mes, dia, semana);
            gettime (hora, minuto, segundo, cent);
        {$ENDIF}

            ndias := semana - semana0;
            if ndias < 0 then ndias := ndias + 7;
            hora := hora + ndias*24;

            tempo := ((hora*60+minuto)*60+segundo)*100+cent;
            tempo := tempo - tempo0;

            processaSeja :=  guardaVar(v, idx, intToStr(tempo));
            exit;
        end;

    nc := 0;
    if maiuscAnsi (copy (lido, 1, 8)) = 'TAMANHO ' then nc := 8
    else
    if maiuscAnsi (copy (lido, 1, 7)) = 'MAIUSC ' then nc := 7
    else
    if maiuscAnsi (copy (lido, 1, 5)) = 'TRIM ' then nc := 5
    else
    if maiuscAnsi (copy (lido, 1, 4)) = 'POS ' then nc := 4
    else
    if maiuscAnsi (copy (lido, 1, 5)) = 'RAND ' then nc := 5
    else
    if maiuscAnsi (copy (lido, 1, 8)) = 'PALAVRA ' then nc := 8;

    if nc <> 0 then
        begin
            fun := maiuscAnsi (copy (lido, 1, nc-1));
            delete (lido, 1, nc);
            lido := trim (lido);
            if not extraiValor (lido, valor) then exit;

            if fun = 'POS' then
                begin
                    busc := valor;
                    if not extraiValor (lido, valor) then exit;
                    processaSeja := guardaVar(v, idx, intToStr(pos (busc, valor)));
                end
            else
            if fun = 'TAMANHO' then
                processaSeja := guardaVar(v, idx, intToStr(length(valor)))
            else
            if fun = 'MAIUSC' then
                processaSeja := guardaVar(v, idx, maiuscAnsi (valor))
            else
            if fun = 'TRIM' then
                processaSeja := guardaVar(v, idx, trim (valor))
            else
            if fun = 'RAND' then
                begin
                    val (valor, r, erro);
                    if erro <> 0 then exit;
                    processaSeja := guardaVar(v, idx, intToStr (random (r)))
                end
            else
            if fun = 'PALAVRA' then
                begin
                    busc := valor;
                    if not extraiValor (lido, valor) then exit;

                    val (busc, r, erro);
                    if erro <> 0 then exit;
                    if r < 1 then exit;
                    for i := 1 to r-1 do
                        begin
                            p := pos (' ', valor);
                            if p <> 0 then
                                begin
                                    delete (valor, 1, p);
                                    valor := trim (valor);
                                end
                            else
                                valor := '';
                        end;

                    p := pos (' ', valor);
                    if p <> 0 then delete (valor, p, 999);
                    processaSeja := guardaVar(v, idx, valor);
                end
        end
    else
        begin
            if lido[1] = '"' then
                begin
                    if not calculaString (lido, valor) then exit;
                end
            else
                begin
                    if not calculaExpressao(lido, valor) then exit;
                end;

            processaSeja := guardaVar(v, idx, valor);
        end;

    if trim (lido) <> '' then
        processaSeja := false;
end;

{--------------------------------------------------------}
{                   comando soma
{--------------------------------------------------------}

function processaSoma (lido: string): boolean;
var v: char;
    idx: integer;
    s, norig: string;
    n, o: longint;
    erro: integer;
begin
    result := false;

    if not extraiVariavel (lido, v, idx) then exit;
    if not pegaVar(v, idx, s) then exit;

    if not extraiValorInteiro (lido, n) then exit;

    norig := '';
    while (s <> '') and (s[length (s)] in ['0'..'9']) do
        begin
            norig := s[length(s)] + norig;
            delete (s, length(s), 1);
        end;
    if (s <> '') and (s[length (s)] = '-') then
         begin
            norig := s[length(s)] + norig;
            delete (s, length(s), 1);
         end;
    val (norig, o, erro);

    str (o+n, norig);
    processaSoma := guardaVar(v, idx, s + norig);
end;

{--------------------------------------------------------}
{           comandos subtrai, multiplica, divide
{--------------------------------------------------------}

function processaContas (lido: string; operador: char): boolean;
var v, r: char;
    idx, idxr: integer;
    norig: string;
    n, o: longint;
    erro: integer;
    valor, resto: string;
begin
    processaContas := false;

    if not extraiVariavel (lido, v, idx) then exit;
    if lido = '' then exit;
    if not pegaVar(v, idx, valor) then exit;
    val (valor, o, erro);
    if erro <> 0 then exit;

    if not extraiValor (lido, valor) then exit;
    val (valor, n, erro);
    if erro <> 0 then exit;

    case operador of
         '-':  str (o-n, norig);
         '*':  str (o*n, norig);
         '/':  begin
                   if n = 0 then
                       begin
                           sintWriteln (DIVISAO_ZERO);  {'Divisão por zero'}
                           exit;
                       end;
                   str (o div n, norig);
                   if lido <> '' then
                      begin
                          if not extraiVariavel (lido, r, idxr) then exit;
                          str (o mod n, resto);
                          guardaVar(r, idxr, resto);
                      end;
               end;
    end;

    processaContas := guardaVar(v, idx, norig) and (lido = '');
end;

{--------------------------------------------------------}
{                   comando concatena
{--------------------------------------------------------}

function processaConcatena (lido: string): boolean;
var v, v2: char;
    idx: integer;
    valorOrig, valor: string;
    i: integer;
    separador: string;
    emLista: boolean;
begin
    processaConcatena := false;

    if not extraiVariavel (lido, v, idx) then exit;
    if not pegaVar(v, idx, valorOrig) then exit;

    emLista := false;
    if upperCase (copy(lido, 1, 6)) = 'LISTA ' then
        begin
            delete (lido, 1, 6);
            lido := trim(lido);
            if (not extraiNomeVar (lido, v2)) or
               (listaScript[v2] = NIL) then
                   begin
                       sintWriteln (LISTA_INEXISTE);
                       exit;
                   end;
            valor := '';
            emLista := true;
        end
    else
        if not extraiValor (lido, valor) then exit;

    separador := '';
    if lido <> '' then
        if not extraiValor(lido, separador) then
            begin
               sintWriteln (SEPARA_INVALIDO);
               exit;
            end;

    if emLista then
        for i := 0 to listaScript[v2].count-1 do
            valor := valor + separador + listaScript[v2][i];

    processaConcatena := guardaVar(v, idx, valorOrig + valor) and (lido = '');
end;

{--------------------------------------------------------}
{                  comando copia
{--------------------------------------------------------}

function processaCopia (lido: string): boolean;
var vdest, vorig: char;
    idxd, idxo: integer;
    c1, c2: string;
    i1, i2, erro: integer;
    valorOrig: string;
begin
    processaCopia := false;

    if not extraiVariavel (lido, vdest, idxd) then exit;
    if not extraiVariavel (lido, vorig, idxo) then exit;
    if not pegaVar(vorig, idxo, valorOrig) then exit;

    if not extraiValor (lido, c1) then exit;
    if not extraiValor (lido, c2) then exit;
    c1 := trim(c1);
    c2 := trim(c2);

    val (c1, i1, erro);
    if erro <> 0 then exit;
    val (c2, i2, erro);
    if erro <> 0 then exit;

    processaCopia := guardaVar(vdest, idxd, copy (valorOrig, i1, (i2-i1+1)));
end;

{--------------------------------------------------------}
{                  comando substitui
{--------------------------------------------------------}

function processaSubstitui (lido: string): boolean;
var vorig: string;
    v: char;
    idx: integer;
    c1, c2: string;
    i: integer;
begin
    processaSubstitui := false;

    if not extraiVariavel (lido, v, idx) then exit;
    if not extraiValor (lido, c1) then exit;
    if not extraiValor (lido, c2) then exit;

    vorig := varScript[v];
    for i := length(vorig)-length(c1)+1 downto 1 do
        if copy(vorig, i, length(c1)) = c1 then
            begin
                delete (vorig, i, length(c1));
                insert (c2, vorig, i);
            end;

    processaSubstitui := guardaVar(v, idx, vorig);
end;

{--------------------------------------------------------}
{                  comando troca
{--------------------------------------------------------}

function processaTroca (lido: string): boolean;
var vdest: char;
    idxd: integer;
    c1, c2: string;
    i1, i2, erro: integer;
    valorDest, valorNovo: string;
begin
    processaTroca := false;

    if not extraiVariavel (lido, vdest, idxd) then exit;
    if not pegaVar(vdest, idxd, valorDest) then exit;
    if not extraiValor (lido, valorNovo) then exit;

    if not extraiValor (lido, c1) then exit;
    if not extraiValor (lido, c2) then exit;
    c1 := trim(c1);
    c2 := trim(c2);

    val (c1, i1, erro);
    if erro <> 0 then exit;
    val (c2, i2, erro);
    if erro <> 0 then exit;

    delete (valorDest, i1, (i2-i1+1));
    insert (valorNovo, valorDest, i1);
    processaTroca := guardaVar(vdest, idxd, valorDest);
end;

{--------------------------------------------------------}
{                  comando toca
{--------------------------------------------------------}

function processaToca (lido: string): boolean;
var
    retornoMci: array [0..255] of char;
    ficaTocando: boolean;
    nomeArq: string;

    procedure sendString (s: string);
    var p: array [0..255] of char;
    begin
        strPcopy (p, s);
        mciSendString (p, retornoMci, 255, 0);
    end;

    procedure toca (nomeArq: string; ficaTocando: boolean);
    begin
        if ficaTocando then
            sendString ('play ' + nomeArq)
        else
            begin
                sendString ('open "' + nomearq + '" alias myfile');
                sendString ('play myfile');
                repeat
                    delay (100);
                    sendString ('status myfile mode');
                until keypressed or (strPas (retornoMci) <> 'playing');
                while keypressed do readkey;

                sendString ('stop myfile');
                sendString ('close myfile');
            end;
    end;

begin
    processaToca := false;
    ficaTocando := false;
    if (lido <> '') and (lido[length(lido)] = '&') then
        begin
            ficaTocando := true;
            delete (lido, length (lido), 1);
            lido := trim (lido);
        end;

    if not extraiValor (lido, nomeArq) then exit;
    if lido <> '' then exit;

    toca (nomeArq, ficaTocando);
    processaToca := true;
end;

{--------------------------------------------------------}
{                  comando mci
{--------------------------------------------------------}

function processaMci (lido: string): boolean;
var
    cmd: string;
    retornoMci: array [0..255] of char;
    v: char;
    idx: integer;

    procedure sendString (s: string);
    var p: array [0..255] of char;
    begin
        strPcopy (p, s);
        mciSendString (p, retornoMci, 255, 0);
    end;

begin
    processaMci := false;

    if not extraiVariavel (lido, v, idx) then exit;
    if not extraiValor (lido, cmd) then exit;
    if lido <> '' then exit;

    sendString (cmd);
    guardaVar(v, idx, strPas (retornoMci));
    processaMci := true;
end;

{--------------------------------------------------------}
{                  comando abre
{--------------------------------------------------------}

function processaAbre (lido: string): boolean;
var arqSel: char;
    adiciona: boolean;
    nomeArq: string;

label erro;
begin
    processaAbre := true;
    adiciona := false;
    nomeArq := '';
    statusUltIO := 0;

    if (lido <> '') and (lido [length(lido)] = '&') then
        begin
            adiciona := true;
            delete (lido, length(lido), 1);
            lido := trim (lido);
        end;

    if not extraiNumArq (lido, arqSel) then goto erro;

    if lido = '' then goto erro;

    if not extraiValor (lido, nomeArq) then goto erro;
    if nomeArq = '' then goto erro;

    with arquivo [arqsel] do
        begin
            assign (arq, nomeArq);
            {$I-}
            if adiciona then
                begin
                    append (arq);
                    if ioresult <> 0 then rewrite (arq);
                 end
            else
                reset (arq);
            if ioresult <> 0 then goto erro;
            {$I+}

            aberto := true;
            internet := false;
            serial := false;
        end;

    exit;

erro:
    sintWriteln (ERRO_ABRE + ' ' + nomearq);  {'Erro na abertura do arquivo'}
    statusUltIO := 1;
    processaAbre := false;
end;

{--------------------------------------------------------}
{                  comando Internet
{--------------------------------------------------------}

function processaInternet (lido: string): boolean;
begin
    processaInternet := true;
    if maiuscAnsi (lido) = 'INICIA' then
        abreWinSock
    else
    if maiuscAnsi (lido) = 'TERMINA' then
        fechaWinSock
    else
        processaInternet := false;
end;
{--------------------------------------------------------}
{                  comando Conecta
{--------------------------------------------------------}

function processaConecta (lido: string): boolean;
var arqSel: char;
    nomeComput, portaComput: string;
    porta: word;
    cod: integer;
    comSSL: boolean;
label erro, erro2;
begin
    processaConecta := true;
    comSSL := false;

    if not extraiNumArq (lido, arqSel) then goto erro;

    if lido = '' then goto erro;

    if maiuscAnsi (copy (lido, 1, 4)) = 'SSL ' then
        begin
            comSSL := true;
            delete (lido, 1, 4);
        end;

    if not extraiValor (lido, nomeComput) then goto erro;
    if not extraiValor (lido, portaComput) then goto erro;

    val (portaComput, porta, cod);
    if cod <> 0 then goto erro2;

    with arquivo [arqSel] do
        begin
            if comSSL then
                soquete := abreConexaoSSL (nomeComput, porta)
            else
                soquete := abreConexao (nomeComput, porta);
            if soquete < 0 then goto erro;

            pBuf := inicBufRede (soquete);
            internet := true;
            serial := false;
            aberto := true;
        end;
    exit;

erro:
    sintWriteln (ERRO_CONEXAO);  {'Erro de conexao'}
    processaConecta := false;
    exit;

erro2:
    sintWriteln (ERRO_PORTA);  {'Erro na porta TCP/IP'}
    processaConecta := false;
end;

{--------------------------------------------------------}
{                  comando Serve
{--------------------------------------------------------}

function processaServe (lido: string): boolean;
var arqSel: char;
    portaComput: string;
    porta: word;
    soq: longint;
    cod: integer;
    esperaCliente: boolean;
label erro, erro2;
begin
    processaServe := true;

    esperaCliente := true;
    if (lido <> '') and (lido[length(lido)] = '&') then
        begin
            esperaCliente := false;
            delete (lido, length(lido), 1);
            lido := trim(lido);
        end;

    if not extraiNumArq (lido, arqSel) then goto erro;

    if lido = '' then goto erro;
    if not extraiValor (lido, portaComput) then goto erro;
    val (portaComput, porta, cod);
    if cod <> 0 then goto erro2;

    with arquivo [arqSel] do
        begin
            if esperaCliente then
                begin
                    soq := escutaConexao (porta);
                    if soq < 0 then goto erro;
                    soquete := aceitaConexao (soq);
                    fechaConexao (soq);
                    if soquete < 0 then goto erro;
                    pBuf := inicBufRede (soquete);
                end
            else
                begin
                    soquete := escutaConexao (porta);
                    if soquete < 0 then goto erro;
                    pBuf := NIL;
                end;

            internet := true;
            serial := false;
            aberto := true;
            exit;
        end;

erro:
    sintWriteln (ERRO_CONEXAO);  {'Erro de conexao'}
    processaServe := false;
    exit;

erro2:
    sintWriteln (ERRO_PORTA);  {'Erro na porta TCP/IP'}
    processaServe := false;
end;

{--------------------------------------------------------}
{                  comando Aceita
{--------------------------------------------------------}

function processaAceita (lido: string): boolean;
var arqEscuta, arqSel: char;
label erro, erro2;
begin
    processaAceita := true;

    if not extraiNumArq (lido, arqEscuta) then goto erro;
    if not extraiNumArq (lido, arqSel) then goto erro;

    with arquivo[arqSel] do
        begin
            soquete := aceitaConexao (arquivo[arqEscuta].soquete);
            if soquete < 0 then goto erro;

            pBuf := inicBufRede (soquete);
            internet := true;
            serial := false;
            aberto := true;
        end;
    exit;

erro:
    sintWriteln (ERRO_CONEXAO);  {'Erro de conexao'}
    processaAceita := false;
    exit;

erro2:
    sintWriteln (ERRO_PORTA);  {'Erro na porta TCP/IP'}
    processaAceita := false;
end;

{--------------------------------------------------------}
{                  comando observa
{--------------------------------------------------------}

function processaObserva (lido: string): boolean;
var arqSel: char;
    v: char;
    idx: integer;
    teclado: boolean;
    valor: string;
begin
    processaObserva := false;
    teclado := false;
    if maiuscAnsi (copy (lido, 1, 8)) = 'TECLADO ' then
        begin
            teclado := true;
            delete (lido, 1, 8);
        end
    else
        if not extraiNumArq (lido, arqSel) then exit;

    lido := trim (lido);
    if not extraiVariavel (lido, v, idx) then exit;
    if lido <> '' then exit;

    if teclado then
        valor := chr (ord (keypressed) + ord ('0'))
    else
        with arquivo [arqsel] do
            begin
                if internet then
                    str (integer(chegouRede(arquivo[arqsel].soquete)
                        or temDadoBufRede(pbuf)), valor)
                else
                if serial then
                    str (integer(chegouLink), valor)
                else
                if not aberto then
                    valor := '0';
            end;

    processaObserva := guardaVar(v, idx, valor);
end;

{--------------------------------------------------------}
{                  comando Checa
{--------------------------------------------------------}

function processaCheca (lido: string): boolean;
var
    v: char;
    idx: integer;
    valor: string;
begin
    processaCheca := false;
    if not extraiVariavel (lido, v, idx) then exit;
    if lido <> '' then exit;

    str (statusUltIO, valor);
    processaCheca := guardaVar(v, idx, valor);
end;

{--------------------------------------------------------}
{                  comando Fecha
{--------------------------------------------------------}

function processaFecha (lido: string): boolean;
var arqSel: char;
label erro;
begin
    if not extraiNumArq (lido, arqSel) then goto erro;

    with arquivo [arqsel] do
        begin
            {$I-}
            if aberto then
                if internet then
                    begin
                        if pbuf <> NIL then
                            fimBufRede (pbuf);
                        pbuf := NIL;
                        fechaConexao (soquete);
                    end
                else
                if serial then
                    finalLink
                else
                    close (arq);
            {$I+}
            aberto := false;
        end;

    if ioresult <> 0 then goto erro;

    processaFecha := true;
    exit;

erro:
    sintWriteln (ERRO_FECHA);  {'Erro no fechamento do arquivo'}
    processaFecha := false;
end;

{--------------------------------------------------------}
{                  comando escreve
{--------------------------------------------------------}

function processaEscreve (lido: string): boolean;
var pulaLinha: boolean;
    arqSel: char;
    mudo, emLista: boolean;
    valor: string;
    saida: string;
    v: char;
    i: integer;

    function escreveArq (s: string; pulando: boolean): boolean;
    label erro;
    var i: integer;
    begin
        escreveArq := false;

        if arqSel = ' ' then
            begin
                if pulando then
                    writeln (s)
                else
                    write (s);
                if not mudo then sintetiza (s);
            end
        else
            with arquivo[arqSel] do
                begin
                    if not aberto then goto erro;
                    if internet then
                        begin
                            if pulando then
                                statusUltIO := ord (writelnRede(soquete, s))
                            else
                                statusUltIO := ord (writeRede (soquete, s));
                        end
                    else
                    if serial then
                        begin
                            if pulando then
                                s := s + #$0d + #$0a;
                            for i := 1 to length(s) do
                                escLink (s[i]);
                            statusUltIO := ord (erroLink);
                        end
                    else
                        begin
                            {$I-}
                            if pulando then writeln (arq, s)
                                       else write (arq, s);
                            {$I+}
                            statusUltIO := ioresult;
                        end;
                end;

        escreveArq := true;
        exit;

erro:
        sintWrite (ERRO_ARQUIVO);  {'Erro no processamento do arquivo'}
        sintWriteln (' #' + arqSel);
    end;

begin
    statusUltIO := 0;
    processaEscreve := false;
    mudo := false;
    emLista := false;

    pulaLinha := true;
    if (lido <> '') and (lido[length(lido)] = '&') then
        begin
            pulaLinha := false;
            delete (lido, length (lido), 1);
            lido := trim (lido);
        end;

    arqSel := ' ';
    if (lido <> '') and (lido[1] = '#') then
        begin
            if not extraiNumArq (lido, arqSel) then
                begin
                    sintWrite (ERRO_ARQUIVO);  {'Erro no processamento do arquivo'}
                    sintWriteln (' #' + arqSel);
                    exit;
                end;
        end
    else
        if maiuscAnsi (copy (lido, 1, 5)) = 'MUDO ' then
            begin
                delete (lido, 1, 5);
                mudo := true;
            end;

    if maiuscAnsi (copy (lido, 1, 6)) = 'LISTA ' then
        begin
            delete (lido, 1, 6);
            emLista := true;
        end;

    lido := trim (lido);
    if lido = '' then
        escreveArq ('', true)
    else
    if emLista then
        begin
            extraiNomeVar(lido, v);
            if listaScript[v] <> NIL then
                for i := 0 to listaScript[v].count-1 do
                    escreveArq (listaScript[v][i], pulaLinha);
            if lido <> '' then exit;
        end
    else
        begin
            saida := '';
            while extraiValor (lido, valor) do
                begin
                    saida := saida + valor;
                    if (lido <> '') and (lido[1] = ',') then
                        begin
                            saida := saida + ' ';
                            delete (lido, 1, 1);
                            lido := trim(lido);
                        end;
                end;
            escreveArq (saida, pulaLinha);
            if lido <> '' then exit;
    end;

    while sintFalando do;
    processaEscreve := true;
end;

{--------------------------------------------------------}
{                  comando fala
{--------------------------------------------------------}

function processaFala (lido: string): boolean;
var
    esperando: boolean;
    valor: string;
    saida: string;

begin
    processaFala := false;

    esperando := true;
    if (lido <> '') and (lido[length(lido)] = '&') then
        begin
            esperando := false;
            delete (lido, length (lido), 1);
            lido := trim (lido);
        end;

    if lido = '' then
        begin
            sintPara;
            if esperando then
                while sintFalando do waitMessage;
            processaFala := true;
            exit;
        end;

    saida := '';
    while extraiValor (lido, valor) do
        begin
            saida := saida + valor;
            if (lido <> '') and (lido[1] = ',') then
                begin
                    saida := saida + ' ';
                    delete (lido, 1, 1);
                    lido := trim(lido);
                end;
        end;
    sintetiza (saida);

    if esperando then
        while sintFalando do waitMessage;

    if lido = '' then
        processaFala := true;
end;

{--------------------------------------------------------}
{                  comando bipa
{--------------------------------------------------------}

function processaBipa (lido: string): boolean;
var tipo: string;
begin
    processaBipa := false;

    if lido = '' then
        tipo := '0'
    else
        if not extraiValor (lido, tipo) then exit;

    if tipo = '1' then
        sintClek
    else
        sintBip;

    processaBipa := true
end;

{--------------------------------------------------------}
{                  comando cor
{--------------------------------------------------------}

function processaCor (lido: string): boolean;
var valor: string;
    cor, erro: integer;
begin
    processaCor := false;

    if lido = '' then exit;
    if not extraiValor (lido, valor) then exit;
    val (valor, cor, erro);
    if erro <> 0 then exit;

    textColor (cor);

    processaCor := true
end;

{--------------------------------------------------------}
{                  comando Fundo
{--------------------------------------------------------}

function processaFundo (lido: string): boolean;
var valor: string;
    cor, erro: integer;
begin
    processaFundo := false;

    if lido = '' then exit;
    if not extraiValor (lido, valor) then exit;
    val (valor, cor, erro);
    if erro <> 0 then exit;

    textBackground (cor);

    processaFundo := true
end;

{--------------------------------------------------------}
{                     comando Tela
{--------------------------------------------------------}

function processaTela (lido: string): boolean;
var
    p, x, y, erro: integer;
    s: string;
begin
    processaTela := false;
    if lido = '' then exit;

    lido := maiuscAnsi (lido);
    if (length (lido) = 1) and (upcase(lido[1]) in ['A'..'Z']) then
        lido := varScript[upcase(lido[1])];

    if lido = 'LIMPA' then
        clrscr
    else
    if lido = 'MINIMIZADA' then
        showWindow (crtWindow, SW_HIDE)
    else
    if lido = 'NORMAL' then
        begin
            showWindow (crtWindow, SW_RESTORE);
            bringWindowToTop (crtWindow);
        end
    else
    if (lido <> '') and (lido [1] = '@') then
        begin
            delete (lido, 1, 1);
            p := pos (',', lido);
            s := copy (lido, 1, p-1);
            s := trim(s);
            delete (lido, 1, p);
            lido := trim (lido);

            val (s, x, erro);
            if erro <> 0 then exit;
            val (lido, y, erro);
            if erro <> 0 then exit;

            gotoxy (x, y);
        end
    else
        exit;

    processaTela := true;
end;

{--------------------------------------------------------}
{                     comando CURSOR
{--------------------------------------------------------}

function processaCursor (lido: string): boolean;
var
    v: char;
    idx: integer;
    x, y: integer;
    capturando: boolean;
begin
    processaCursor := false;
    if lido = '' then exit;

    capturando := false;
    if upperCase(copy (lido, 1, 8)) = 'CAPTURA ' then
        begin
            capturando := true;
            delete (lido, 1, 8);
            lido := trim (lido);
        end;

    if capturando then
        begin
            if not extraiVariavel(lido, v, idx) then exit;
            guardaVar(v, idx, intToStr(wherex));
            if not extraiVariavel(lido, v, idx) then exit;
            guardaVar(v, idx, intToStr(wherey));
        end
    else
        begin
            if not extraiValorInteiro (lido, x) then exit;
            if not extraiValorInteiro (lido, y) then exit;
            gotoxy (x, y);
        end;

    processaCursor := lido = '';
end;

{--------------------------------------------------------}
{                  comando remove
{--------------------------------------------------------}

function processaRemove (lido: string): boolean;
var
    nomeArq: string;
    arq: file;
    ignoraErro: boolean;

begin
    processaRemove := false;
    if lido = '' then exit;

    ignoraErro := false;
    if lido[length(lido)] = '&' then
        begin
           ignoraErro := true;
           delete (lido, length (lido), 1);
           lido := trim (lido);
        end;

    if not extraiValor (lido, nomeArq) then exit;
    if nomeArq = '' then exit;

    assign (arq, nomearq);
    {$I-}  erase (arq);  {$I+}
    if (ioresult <> 0) and not (ignoraErro) then
        begin
            sintWriteln (ERRO_APAGA + nomeArq);
            exit;
        end;

    processaRemove := true;
end;

{--------------------------------------------------------}
{                  le a posição do mouse
{--------------------------------------------------------}

function processaMouse (lido: string): boolean;
var
    pt: TPOINT;
    rect: TRECT;
    xorig, yorig: integer;
    v1, v2: char;
    idx1, idx2: integer;
    var1, var2: string;
    lendoPosicao, clicando, duplo, direita: boolean;
    x, y: integer;
begin
    lendoPosicao := false;
    if maiuscAnsi (copy (lido, 1, 8)) = 'CAPTURA ' then
        begin
            delete (lido, 1, 8);
            lido := trim (lido);
            lendoPosicao := true;
        end;

    clicando := false;
    duplo := false;
    direita := false;
    if maiuscAnsi (copy (lido, 1, 6)) = 'CLICA ' then
        begin
            delete (lido, 1, 6);
            lido := trim (lido);
            clicando := true;

            if maiuscAnsi (copy (lido, 1, 6)) = 'DUPLO ' then
                begin
                    delete (lido, 1, 6);
                    lido := trim (lido);
                    duplo := true;
                end
            else
            if maiuscAnsi (copy (lido, 1, 8)) = 'DIREITA ' then
                begin
                    delete (lido, 1, 8);
                    lido := trim (lido);
                    direita := true;
                end
        end;

    if maiuscAnsi (copy (lido, 1, 5)) = 'TELA ' then
        begin
            xorig := 0;
            yorig := 0;
            delete (lido, 1, 5);
            lido := trim (lido);
        end
    else
        begin
            getWindowRect (getForegroundWindow, rect);
            xorig := rect.left+getSystemMetrics (SM_CXFRAME);
            yorig := rect.top+SM_CYCAPTION;
        end;

    processaMouse:= false;
    if lendoPosicao then
        begin
            GetCursorPos(pt);

            if not extraiVariavel (lido, v1, idx1) then exit;
            str (pt.x-xorig, var1);
            if not guardaVar(v1, idx1, var1) then exit;

            if not extraiVariavel (lido, v2, idx2) then exit;
            str (pt.y-yorig, var2);
            if not guardaVar(v2, idx2, var2) then exit;
        end
    else
        begin
            if not extraiValor (lido, var1) then exit;
            if not extraiValor (lido, var2) then exit;
            x := strToInt(var1);
            y := strToInt(var2);

            if not clicando then
                mouseMove(x-xorig, y-yorig)
            else
                begin
                    if duplo then
                        mouseDoubleClick(x-xorig, y-yorig)
                    else
                    if direita then
                        mouseDoubleClick(x-xorig, y-yorig)
                    else
                        mouseMove(x-xorig, y-yorig)
                end;
        end;

    if lido <> '' then exit;

    processaMouse:= true;
end;

{--------------------------------------------------------}
{                      comando le
{--------------------------------------------------------}

function processaLe (lido: string): boolean;
var
    leLetra, leDeArquivo, editando, mudo, senha, emLista: boolean;
    terminador: string;
    arqSel: char;

    v: char;
    idx: integer;

label erro;

    {--------------------------------------------------------}

    function pegaParametros: boolean;
    begin
        pegaParametros := false;
        if lido [1] = '#' then
            begin
                if not extraiNumArq (lido, arqSel) then exit;
                if lido = '' then exit;
                leDeArquivo := true;
            end
        else
            begin
                if maiuscAnsi (copy (lido, 1, 6)) = 'EDITA ' then
                    begin
                        delete (lido, 1, 6);
                        editando := true;
                    end
                else
                if maiuscAnsi (copy (lido, 1, 5)) = 'MUDO ' then
                    begin
                        delete (lido, 1, 5);
                        mudo := true;
                    end
                else
                if maiuscAnsi (copy (lido, 1, 6)) = 'SENHA ' then
                    begin
                        delete (lido, 1, 6);
                        mudo := true;
                        senha := true;
                    end;
            end;

        if maiuscAnsi (copy (lido, 1, 6)) = 'LISTA ' then
            begin
                delete (lido, 1, 6);
                lido := trim(lido);
                emLista := true;
            end;

        lido := trim (lido);
        if not extraiVariavel (lido, v, idx) then exit;

        if emLista then
            begin
                if listaScript[v] <> NIL then
                    listaScript[v].Clear
                else
                    listaScript[v] := TStringList.Create;

                if lido <> '' then
                    if not extraiValor(lido, terminador) then exit;
            end;

        if trim(lido) = '' then
            pegaParametros := true;
    end;

    {--------------------------------------------------------}

    function letraParaString (c: char): string;
    begin
        if (c >= ' ') then
            result := c
        else
        if c = #$0 then
            begin
                c := readkey;
                str (ord(c), result);
                result := '#0#' + result;
            end
        else
            begin
                str (ord(c), result);
                result := '#' + result;
            end;
    end;

    {--------------------------------------------------------}

    function procLeitInternet: boolean;
    var s: string;
        c: char;
    begin
        with arquivo[arqSel] do
            begin
                if emLista then
                {----------- leitura de várias linhas até terminador ----------}
                    begin
                        repeat
                            statusUltIO := ord (not readlnBufRede (pbuf, s, 30));
                            if statusUltIO <> 0 then break;
                                listaScript[v].Add(s);
                        until s = terminador;

                        procLeitInternet := true;
                        exit;
                    end
                else
                if leLetra then
                {----------- leitura letra a letra ----------}
                    begin
                        statusUltIO := ord (not leCaracBufRede (pbuf, c));
                        s := letraParaString(c);
                        guardaVar(v, idx, s);
                    end
                else
                {----------- leitura de uma linha ----------}
                    begin
                        statusUltIO := ord (not readlnBufRede (pbuf, s, 30));
                        guardaVar(v, idx, s);
                    end;
            end;

        procLeitInternet := true;
    end;

    {--------------------------------------------------------}

    function procLeitSerial: boolean;

        function leLinhaSerial: string;
        var c: char;
            s: string;
        begin
            s := '';
            repeat
                leLink (c);
                statusUltIO := ord (erroLink);
                if (statusUltIO = 0) and (c <> #$0a) then
                    s := s + c;
            until (statusUltIO <> 0) or (c = #$0a);
            if (length(s) <> 0) and (s[length(s)] = #$0d) then
                delete (s, length(s), 1);

            leLinhaSerial := s;
        end;

    var s: string;
        c: char;

    begin
        with arquivo[arqSel] do
            begin
                if emLista then
                {----------- leitura de várias linhas até terminador ----------}
                    begin
                        repeat
                            s := leLinhaSerial;
                            if s <> terminador then
                                listaScript[v].Add(s);
                        until s = terminador;

                        procLeitSerial := true;
                        exit;
                    end
                else
                if leLetra then
                {----------- leitura letra a letra ----------}
                    begin
                        if erroLink <> 0 then
                            statusUltIO := 1
                        else
                            begin
                                leLink (c);
                                guardaVar(v, idx, letraParaString(c));
                                statusUltIO := ord (erroLink);
                            end;
                    end
                else
                {----------- leitura linha a linha ----------}
                    begin
                        s := leLinhaSerial;
                        guardaVar(v, idx, s);
                    end;
            end;

        procLeitSerial := true;
    end;

    {--------------------------------------------------------}

    function procLeitArquivo: boolean;
    var s: string;
    begin
        with arquivo[arqSel] do
            begin
                if not aberto then
                    begin
                         sintWriteln (ERRO_ARQUIVO);
                         procLeitArquivo := false;
                         exit;
                    end;

                if emLista then
                {----------- leitura de várias linhas até terminador ----------}
                    begin
                        if eof (arq) then
                            statusUltIO := 1
                        else
                            repeat
                                readln (arq, s);
                                if s <> terminador then
                                   listaScript[v].Add(s);
                            until eof(arq) or (s = terminador);
                    end
                else
                    begin
                        if eof (arq) then
                            statusUltIO := 1
                        else
                            begin
                                {$I-} readln (arq, s); {$I+}
                                statusUltIO := ioresult;
                            end;

                        guardaVar(v, idx, s);
                    end;
            end;

        procLeitArquivo := true;
    end;

    {--------------------------------------------------------}

    function procLeitTeclado: boolean;
    var
        salvaCor: word;
        s: string;
        c: char;

    begin
        procLeitTeclado := false;

        if emLista then
        {----------- leitura de várias linhas até terminador ----------}
            begin
                repeat
                    sintReadln (s);
                    if s <> terminador then
                        listaScript[v].Add(s);
                until s = terminador;

                procLeitTeclado := true;
                exit;
            end
        else
        if leLetra then
        {----------- leitura letra a letra ----------}
            begin
                if mudo then
                    c := readKey
                else
                    c := sintReadkey;
                s := letraParaString(c);
             end
        else
            begin
                salvaCor := textAttr;
                if senha then textAttr := 0;
                if mudo then
                    readln (s)
                else
                    if editando then
                         begin
                              if not pegaVar(v, idx, s) then exit;
                              c := sintEdita (s, wherex, wherey, 80, true);
                              if c = ESC then s := '';
                         end
                    else
                        sintReadln (s);
                textAttr := salvaCor;
            end;

        if not emLista then
            guardaVar(v, idx, s);

        procLeitTeclado := true;
    end;

    {--------------------------------------------------------}

begin
    processaLe := false;

    statusUltIO := 0;
    mudo := false;
    senha := false;
    emLista := false;
    editando := false;
    leLetra := false;
    leDeArquivo := false;

    lido := trim (lido);
    if lido = '' then
        begin
            readln;
            processaLe := true;
            exit;
        end;

    if lido [length(lido)] = '&' then
        begin
            leLetra := true;
            delete (lido, length(lido), 1);
            lido := trim (lido);
        end;

    if not pegaParametros then
        exit;

    // ------ processa a leitura ------ //

    if leDeArquivo then
        begin
            if arquivo[arqSel].internet then
                processaLe := procLeitInternet
            else
            if arquivo[arqSel].serial then
                processaLe := procLeitSerial
            else
                processaLe := procLeitArquivo;
        end
    else
        processaLe := procLeitTeclado;
end;

{--------------------------------------------------------}
{                  comando cmd
{--------------------------------------------------------}

function processaCmd (lido: string): boolean;   {recursivo, provavelmente}
var s: string;
begin
    processaCmd := false;

    if not extraiValor (lido, s) then exit;
    if lido <> '' then exit;

    processaCmd := cmdScript (s);
end;

{--------------------------------------------------------}
{                  Comando espera
{--------------------------------------------------------}

function processaEspera (lido: string): boolean;
var
    erro: integer;
    i, n: longint;
    s, nomeJan: string;
    titulo: array [0..250] of char;
begin
    processaEspera := false;
    if lido = '' then exit;
    statusUltIO := 0;

    if not extraiValor (lido, s) then exit;
    val (s, n, erro);
    if erro <> 0 then exit;

    processaEspera := true;

    lido := trim (lido);
    if uppercase(lido) = 'MS' then
        begin
            delay (n);   // limitado a 65535
            exit;
        end
    else
    if lido = '' then
        begin
            for i := 1 to n do delay (1000);
            exit;
        end;

    if not extraiValor (lido, nomeJan) then exit;
    nomeJan := maiuscAnsi (nomeJan);

    n := n * 2;
    for i := 1 to n do
        begin
            getWindowText (getForegroundWindow, titulo, 250);
            if pos (nomeJan, maiuscAnsi (strPas (titulo))) <> 0 then exit;
            delay (500);
        end;

    statusUltIO := 1;   { não chegou... }
end;

{--------------------------------------------------------}
{                  Comando digita
{--------------------------------------------------------}

function processaDigita (lido: string): boolean;
var s: string;
    poeEnter: boolean;
begin
    processaDigita := false;

    poeEnter := true;
    if (lido <> '') and (lido[length(lido)] = '&') then
        begin
            poeEnter := false;
            delete (lido, length (lido), 1);
            lido := trim (lido);
        end;

    if not extraiValor (lido, s) then exit;
    if lido <> '' then exit;

    keyboardString (s, 100);
    if poeEnter then
        keyboardVirtKey (VK_RETURN, false, false, false, 100);

    processaDigita := true;
end;

{--------------------------------------------------------}
{                  Comando aciona
{--------------------------------------------------------}

function processaAciona (lido: string): boolean;
var s: string;
    letra: char;
    n, erro: integer;
    comCtl, comShift, comAlt: boolean;

begin
    processaAciona := false;
    if not extraiValor (lido, s) then exit;
    if s = '' then exit;
    if lido <> '' then exit;

    if length (s) = 1 then
        keyboardClick (s[1])
    else
        begin
            s := maiuscAnsi (s);

            comCtl := false;
            if copy (s, 1, 5) = 'CTRL+' then
                begin
                    comCtl := true;
                    delete (s, 1, 5);
                end;
            comShift := false;
            if copy (s, 1, 6) = 'SHIFT+'   then
                begin
                    comShift := true;
                    delete (s, 1, 6);
                end;

            comAlt := false;
            if copy (s, 1, 4) = 'ALT+'     then
                begin
                    comAlt := true;
                    delete (s, 1, 4);
                end;

            if s = '' then exit;

            if s = 'UP'        then n := VK_UP       else
            if s = 'DOWN'      then n := VK_DOWN     else
            if s = 'LEFT'      then n := VK_LEFT     else
            if s = 'RIGHT'     then n := VK_RIGHT    else
            if s = 'ESCAPE'    then n := VK_ESCAPE   else
            if s = 'ESC'       then n := VK_ESCAPE   else
            if s = 'ENTER'     then n := VK_RETURN   else
            if s = 'RETURN'    then n := VK_RETURN   else
            if s = 'BACKSPACE' then n := VK_BACK     else
            if s = 'TAB'       then n := VK_TAB      else
            if s = 'F1'        then n := VK_F1       else
            if s = 'F2'        then n := VK_F2       else
            if s = 'F3'        then n := VK_F3       else
            if s = 'F4'        then n := VK_F4       else
            if s = 'F5'        then n := VK_F5       else
            if s = 'F6'        then n := VK_F6       else
            if s = 'F7'        then n := VK_F7       else
            if s = 'F8'        then n := VK_F8       else
            if s = 'F9'        then n := VK_F9       else
            if s = 'F10'       then n := VK_F10      else
            if s = 'F11'       then n := VK_F11      else
            if s = 'F12'       then n := VK_F12      else
            if s = 'INS'       then n := VK_INSERT   else
            if s = 'HOME'      then n := VK_HOME     else
            if s = 'DEL'       then n := VK_DELETE   else
            if s = 'DELETE'    then n := VK_DELETE   else
            if s = 'HOME'      then n := VK_HOME     else
            if s = 'END'       then n := VK_END      else
            if s = 'PAGEUP'    then n := VK_PRIOR    else
            if s = 'PAGEDN'    then n := VK_NEXT     else
            if s = 'PRIOR'     then n := VK_PRIOR    else
            if s = 'NEXT'      then n := VK_NEXT     else
            if s = 'SNAPSHOT'  then n := VK_SNAPSHOT
            else
                begin
                    letra := upcase(s[1]);
                    n := ord (letra);
                    delete (s, 1, 1);
                    if letra = '#' then
                        begin
                            val (s, n, erro);
                            if erro <> 0 then exit;
                        end
                    else
                        if s <> '' then exit;
                end;

            keyboardVirtKey (n, comCtl, comShift, comAlt, 100);
        end;

    processaAciona := true;
end;

{--------------------------------------------------------}
{                  Comando Clica
{--------------------------------------------------------}

function processaClica (lido: string): boolean;
var rect: TRect;
    s: string;
    x, y, xorig, yorig, erro: integer;
    estiloClick: (SIMPLES, DUPLO, DIREITA, NULO);
begin
    processaClica := false;

    estiloClick := SIMPLES;

    lido := trim (lido);
    if maiuscAnsi (copy (lido, 1, 5)) = 'DUPLO' then
        begin
            estiloClick := DUPLO;
            delete (lido, 1, 5);
        end
    else
    lido := trim (lido);
    if maiuscAnsi (copy (lido, 1, 7)) = 'DIREITA' then
        begin
            estiloClick := DIREITA;
            delete (lido, 1, 5);
        end
    else
    if maiuscAnsi (copy (lido, 1, 4)) = 'NULO' then
        begin
            estiloClick := NULO;
            delete (lido, 1, 4);
        end;

    lido := trim (lido);
    if maiuscAnsi (copy (lido, 1, 4)) = 'TELA' then
        begin
            xorig := 0;
            yorig := 0;
            delete (lido, 1, 4);
        end
    else
        begin
            getWindowRect (getForegroundWindow, rect);
            xorig := rect.left+getSystemMetrics (SM_CXFRAME);
            yorig := rect.top+SM_CYCAPTION;
        end;

    if not extraiValor (lido, s) then exit;
    val (s, x, erro);
    if erro <> 0 then exit;

    lido := trim (lido);
    if (lido <> '') and (lido[1] = ',') then delete (lido, 1, 1);

    if not extraiValor (lido, s) then exit;
    val (s, y, erro);
    if erro <> 0 then exit;

    case estiloClick of
        SIMPLES:  mouseClick (x+xorig, y+yorig);
        DUPLO:    mouseDoubleClick (x+xorig, y+yorig);
        DIREITA:  mouseRightClick (x+xorig, y+yorig);
        NULO:     mouseMove (x+xorig, y+yorig);
    end;

    if lido <> '' then exit;
    processaClica := true;
end;

{--------------------------------------------------------}
{                  Comando Transfere
{--------------------------------------------------------}

function processaTransfere (lido: string): boolean;
var v: char;
    idx: integer;
    p: array [0..10000] of char;
    trazendo: boolean;
    valor: string;
begin
    processaTransfere := false;
    if lido = '' then exit;

    if maiuscAnsi (copy (lido, 1, 3)) = 'DE ' then
        begin
            trazendo := false;
            delete (lido, 1, 3);
        end
    else
    if maiuscAnsi (copy (lido, 1, 5)) = 'PARA ' then
        begin
            trazendo := true;
            delete (lido, 1, 5);
        end
    else
        exit;

    if not extraiVariavel (lido, v, idx) then exit;
    lido := trim (lido);
    if lido <> '' then exit;

    if trazendo then
        begin
            getClipBoard (p, 10000);
            guardaVar(v, idx, strPas (p));
        end
    else
        begin
            if not pegaVar(v, idx, valor) then exit;
            if length(valor) > 10000 then
                sintWriteln (ERRO_TRUNC);
            strPCopy (p, copy (valor, 1, 10000));
            putClipBoard (p);
        end;

    processaTransfere := true;
end;

{--------------------------------------------------------}
{                  Comando janela
{--------------------------------------------------------}

function processaJanela (lido: string): boolean;
var
    currWnd: hwnd;
    txt: array [0..144] of char;
    p: integer;
    opcao, titulo, s: string;
    aoInicio, aoFim, visivel, iconica: boolean;

label prox, achou;

begin
    processaJanela := false;
    statusUltIO := 0;
    if lido = '' then exit;

    opcao := '';
    while (lido <> '') and (lido[1] <> ' ') do
       begin
           opcao := opcao + lido[1];
           delete (lido, 1, 1);
       end;
    opcao := maiuscAnsi (opcao);

    lido := trim (lido);
    if not extraiValor (lido, s) then exit;

    CurrWnd := GetWindow(crtWindow, GW_HWNDFIRST);

    aoInicio := false;
    aoFim := false;
    if (s <> '') and (s[1] = '*') then
        begin
            aoInicio := true;
            delete (s, 1, 1);
        end;

    if (s <> '') and (s[length(s)] = '*') then
        begin
            aoFim := true;
            delete (s, length (s), 1);
        end;

    While CurrWnd <> 0 do
        begin
            if isWindowEnabled (currWnd) then
                begin
                    visivel := isWindowVisible (currWnd);
                    iconica := isIconic (currWnd);
                    GetWindowText(CurrWnd, txt, 144);
                    titulo := maiuscAnsi (strPas (txt));

                    if ((visivel or iconica) and (length (titulo) <> 0)) then
                        begin
                            p := pos (s, titulo);
                            if (p = 0)  or
                               ((p <> 1) and aoInicio) or
                               ((p <> (length(titulo) - length(s) + 1)) and aoFim) then
                                          goto prox;

                            goto achou;
                        end;
                end;
prox:
           CurrWnd := GetWindow(CurrWnd, GW_HWNDNEXT);
        end;

    processaJanela := true;
    statusUltIO := 1;
    exit;   { não achou }

achou:
    if opcao = 'FECHA' then
        sendMessage (currWnd, WM_CLOSE, 0, 0)
    else
    if opcao = 'NORMAL' then
        begin
            ShowWindow(currWnd, SW_SHOWNORMAL);
            setActiveWindow (currWnd);
        end
    else
    if opcao = 'MAXIMIZA' then
        begin
            ShowWindow(currWnd, SW_MAXIMIZE);
            setActiveWindow (currWnd);
        end
    else
    if opcao = 'MINIMIZA' then
        ShowWindow(currWnd, SW_MINIMIZE)
    else
        exit;

    processaJanela := true;
end;

{--------------------------------------------------------}
{                  Comando Captura
{--------------------------------------------------------}

function processaCaptura (lido: string): boolean;
var v: char;
    idx: integer;
    p: array [0..255] of char;
    opcao: string;
begin
    processaCaptura := false;
    if lido = '' then
        exit;

    opcao := '';
    while (lido <> '') and (lido[1] <> ' ') do
       begin
           opcao := opcao + lido[1];
           delete (lido, 1, 1);
       end;
    opcao := maiuscAnsi (opcao);

    if not extraiVariavel (lido, v, idx) then exit;

    if (opcao = 'TÍTULO') or (opcao = 'TITULO') or (opcao = 'ATIVA') then
        getWindowText (getForegroundWindow, p, 255)
    else
    if (opcao = 'FOCO') then
        begin
            strcopy (p, '');
            if getFocus <> 0 then
                getWindowText (getFocus, p, 255);
        end
    else
    if (opcao = 'CAMPO') then
        begin
            keyboardVirtKey (VK_HOME, false, false, false, 100);
            keyboardVirtKey (VK_END, false, true, false, 100);
            keyboardVirtKey (VK_INSERT, true, false, false, 100);
            getClipBoard (p, 255);
        end;

    guardaVar(v, idx, strPas (p));
    processaCaptura := true;
end;

{--------------------------------------------------------}
{                  Comando desvia
{--------------------------------------------------------}

function processaDesvia (lido: string): boolean;
var s: string;
begin
    processaDesvia := false;
    if fimScript then exit;   { processamento fora de arquivo }
    if lido = '' then exit;

    if maiuscAnsi (copy (lido, 1, 6)) = 'SCRIPT' then
         begin
             delete (lido, 1, 6);
             if (lido = '') or (lido[1] <> ' ') then exit;
             if not extraiValor (lido, s) then exit;

             processaDesvia := carregaScript(s);
             linhaAtual := -1;
         end;

    if (lido <> '') and (lido[1] = '@') then
        begin
            delete (lido, 1, 1);
            s := lido;
            if pos (' ', s) <> 0 then exit;  {rotulo com brancos}
        end
    else
        begin
            if not extraiValor (lido, s) then exit;
            if lido <> '' then exit;
        end;

    processaDesvia := buscaRotulo (s);
end;

{--------------------------------------------------------}
{        procedimentos comuns de se e enquanto
{--------------------------------------------------------}

function processaTestes (var lido: string; var resultado: boolean): boolean;
var valor1, valor2, mv1, mv2, v1: string;
    operador: string[3];
    nega: boolean;

    function compensaNumero (s: string): string;
    var i: integer;
    begin
        compensaNumero := s;
        for i := 1 to length (s) do
            if not (s[i] in ['0'..'9']) then exit;

        s := '00000000000000000000' + s;
        s := copy (s, length(s)-20, 255);
        compensaNumero := s;
    end;

label ok, fim;
begin
    processaTestes := false;
    resultado := false;
    if lido = '' then exit;

    nega := false;
    if (maiuscAnsi (copy (lido, 1, 3)) = 'NÃO') or
       (maiuscAnsi (copy (lido, 1, 3)) = 'NAO') then
        begin
            delete (lido, 1, 3);
            lido := trim (lido);
            if lido = '' then exit;
            nega := true;
        end;

    if not extraiValor (lido, valor1) then exit;
    if lido = '' then exit;

    if copy (lido, 1, 2) = '>='  then operador := '>='  else
    if copy (lido, 1, 2) = '<='  then operador := '<='  else
    if copy (lido, 1, 2) = '=='  then operador := '=='  else
    if copy (lido, 1, 2) = '<>'  then operador := '<>'  else
    if copy (lido, 1, 3) = '*=*' then operador := '*=*' else
    if copy (lido, 1, 2) = '=*'  then operador := '=*'  else
    if copy (lido, 1, 2) = '*='  then operador := '*='  else
    if lido[1] = '=' then operador := '=' else
    if lido[1] = '<' then operador := '<' else
    if lido[1] = '>' then operador := '>'
    else
        exit;

    delete (lido, 1, length (operador));
    lido := trim (lido);
    if lido = '' then exit;

    if not extraiValor (lido, valor2) then exit;

    mv1 := compensaNumero (maiuscAnsi(valor1));
    mv2 := compensaNumero (maiuscAnsi(valor2));

    if (operador = '=')   and (nega xor (mv1 = mv2)) then goto ok;
    if (operador = '<')   and (nega xor (mv1 < mv2)) then goto ok;
    if (operador = '>')   and (nega xor (mv1 > mv2)) then goto ok;

    if (operador = '<=')  and (nega xor (mv1 <= mv2))         then goto ok;
    if (operador = '>=')  and (nega xor (mv1 >= mv2))         then goto ok;
    if (operador = '<>')  and (nega xor (mv1 <> mv2))         then goto ok;

    if (operador = '==')  and (nega xor (valor1 = valor2))    then goto ok;
    if (operador = '*=*') and (nega xor (pos (valor2, valor1) <> 0)) then goto ok;
    if (operador = '=*')  and (nega xor (pos (valor2, valor1) = 1))  then goto ok;
    if operador = '*=' then
        begin
            v1 := copy (valor1+^@, length(valor1)-length(valor2)+1,
                        length(valor2));
            if nega xor ((v1 = valor2) and (length(valor2) <> 0)) then goto ok;
        end;

    goto fim;   { com resultado falso }

ok:
    resultado := true;
fim:
    processaTestes := true;
    lido := trim (lido);
end;

{--------------------------------------------------------}
{                  busca fimSe
{--------------------------------------------------------}

function buscaFimSeRecursivo (var linha: integer): boolean;
var
    lido: string;
    verdadeiro: boolean;
    cmd: string;
begin
    buscaFimSeRecursivo := false;

    linha := linha + 1;
    while linha < script.count do
        begin
            lido := trim(script[linha]);
            if lido = '' then
                begin
                    linha := linha + 1;
                    continue;
                end;

            cmd := pegaPalavraMaiusc(lido);
            if cmd = 'FIM' then
                begin
                    cmd := pegaPalavraMaiusc(lido);
                    if cmd = 'SE' then
                        begin
                            buscaFimSeRecursivo := true;
                            exit;
                        end;
                end
            else
            if cmd = 'SE' then
                begin
                    processaTestes (lido, verdadeiro);   // ignora o resultado ou erro

                    if lido = '' then
                        if not buscaFimSeRecursivo (linha) then   // mundos recursivos não são para humanos.
                            exit;
                end;
            linha := linha + 1;
        end;

    sintWriteln (FALTOU_FIMSE);   {'Comando FIM SE faltando'}
end;

{--------------------------------------------------------}
{                  busca senão ou fimSe
{--------------------------------------------------------}

function buscaSenaoOuFimSe: boolean;
var i: integer;
    lido: string;
    verdadeiro: boolean;
    cmd: string;
begin
    buscaSenaoOuFimSe := false;

    i := linhaAtual+1;
    while i < script.count do
        begin
            lido := trim(script[i]);
            if lido = '' then
                begin
                    i := i + 1;
                    continue;
                end;

            cmd := pegaPalavraMaiusc(lido);

            if (cmd = 'SENAO') or (cmd = 'SENÃO') then
                begin
                    if lido <> '' then
                        begin
                            sintWriteln (SENAO_ERRADO);
                            exit;
                        end
                    else
                        begin
                            linhaAtual := i;
                            buscaSenaoOuFimSe := true;
                            exit;
                        end;
                end;

            if cmd = 'FIM' then
                begin
                    cmd := pegaPalavraMaiusc(lido);
                    if cmd = 'SE' then
                        begin
                            linhaatual := i;
                            buscaSenaoOuFimSe := true;
                            exit;
                        end;
                end;

             if cmd = 'SE' then
                begin
                    processaTestes (lido, verdadeiro);   // ignora o resultado ou erro
                    if lido = '' then
                        begin
                            if not buscaFimSeRecursivo (i) then
                                exit;
                        end;
                end;
            i := i + 1;
        end;

    sintWriteln (FALTOU_SENAO_FIMSE);   {'Comando SENÃO ou FIM SE faltando'}
end;

{--------------------------------------------------------}
{                  Comando se
{--------------------------------------------------------}

function processaSe (lido: string): boolean;
var verdadeiro: boolean;

begin
    processaSe := false;
    if not processaTestes (lido, verdadeiro) then exit;

    processaSe := true;

    if verdadeiro and (lido <> '') then
        processaSe := cmdScript (lido)
    else
    if (not verdadeiro) and (lido = '') then
        processaSe := buscaSenaoOuFimSe;
end;

{--------------------------------------------------------}
{                  busca fimSe
{--------------------------------------------------------}

function buscaFimSe: boolean;
var i: integer;
    lido: string;
begin
    buscaFimSe := true;

    for i := linhaAtual+1 to script.count-1 do
        begin
            lido := trim(script[i]);
            if lido = '' then continue;

            cmd := pegaPalavraMaiusc(lido);
            if cmd = 'FIM' then
                begin
                    cmd := pegaPalavraMaiusc(lido);
                    if cmd = 'SE' then
                        begin
                            linhaatual := i;
                            exit;
                        end;
                end;
        end;

    sintWriteln (FALTOU_FIMSE);   {'Comando FIM SE faltando'}
    linhaAtual := script.Count;
    buscaFimSe := false;
end;

{--------------------------------------------------------}
{                  Comando senão
{--------------------------------------------------------}

function processaSenao (lido: string): boolean;
begin
    processaSenao := false;
    if lido <> '' then exit;

    processaSenao := buscaFimSe;
end;

{--------------------------------------------------------}
{        busca um comando fim enquanto ou repete
{--------------------------------------------------------}

procedure buscaFim (deQue: string);
var i: integer;
    lido: string;
    conta: integer;
begin
    conta := 1;
    for i := linhaAtual+1 to script.Count-1 do
        begin
            lido := trim(script[i]);
            if lido = '' then continue;

            cmd := pegaPalavraMaiusc(lido);
            if cmd = deQue then
                conta := conta + 1
            else
                if cmd = 'FIM' then
                     begin
                         if ansiUpperCase(lido) = deQue then
                             begin
                                 conta := conta - 1;
                                 if conta = 0 then
                                     begin
                                         linhaAtual := i;
                                         exit;
                                     end;
                             end;
                     end;
        end;

    sintWriteln (LOOP_ABERTO);   {'Faltou o fim da repetição'}
    linhaAtual := script.Count;
end;

{--------------------------------------------------------}
{                  Comando enquanto
{--------------------------------------------------------}

function processaEnquanto (lido: string): boolean;
var verdadeiro: boolean;

begin
    processaEnquanto := false;
    if not processaTestes (lido, verdadeiro) then exit;

    if verdadeiro then
        pilhaEnquanto.push(linhaAtual)
    else
        buscaFim ('ENQUANTO');

    processaEnquanto := true;
end;

{--------------------------------------------------------}
{                  Comando repete
{--------------------------------------------------------}

function processaRepete (lido: string; continuando: boolean): boolean;
var
    v: char;
    idx: integer;
    natual, nmax: longint;
    valor: string;
    erro: integer;

begin
    processaRepete := false;

    if not extraiVariavel (lido, v, idx) then exit;
    if lido = '' then exit;

    if continuando then
         begin
             val (varScript[v], natual, erro);
             if erro <> 0 then exit;
         end
    else
        natual := 0;

    if not extraiValor (lido, valor) then exit;
    val (valor, nmax, erro);
    if erro <> 0 then exit;

    natual := natual + 1;
    str (natual, varScript[v]);

    if natual <= nmax then
        pilhaRepete.push(linhaAtual)
    else
        buscaFim ('REPETE');

    processaRepete := true;
end;

{--------------------------------------------------------}
{                  Comandos de fim de bloco
{--------------------------------------------------------}

function processaFim (lido: string): boolean;
begin
    processaFim := false;
    if lido = '' then exit;

    lido := maiuscAnsi (lido);
    if lido = 'SE' then
        begin
            processaFim := true;
            exit;
        end;

    if lido = 'ENQUANTO' then
        begin
            if pilhaEnquanto.empty then
                begin
                    sintWriteln (LOOP_INVALIDO);   {'Fim de repetição sem início'}
                    exit;
                end;

            linhaAtual := pilhaEnquanto.pop - 1;
            processaFim := true;
            exit;
        end;

    if lido = 'REPETE' then
        begin
            if pilhaRepete.empty then
                begin
                    sintWriteln (LOOP_INVALIDO);   {'Fim de repetição sem início'}
                    exit;
                end;

            linhaAtual := pilhaRepete.pop;
            lido := trim(script[linhaAtual]);
            while lido[1] <> ' ' do
                delete (lido, 1, 1);
            lido := trim(lido);
            processaFim := processaRepete (lido, true);
            exit;
        end;
end;

{--------------------------------------------------------}
{                  Comando executa
{--------------------------------------------------------}

function processaExecuta (lido: string): boolean;
var comando, param, nomeDir: string;
    espera: boolean;
    i: integer;
begin
    processaExecuta := false;

    espera := true;
    if (lido <> '') and (lido [length(lido)] = '&') then
        begin
            espera := false;
            delete (lido, length (lido), 1);
            lido := trim (lido);
        end;

    if not extraiValor (lido, comando) then exit;
    if lido <> '' then exit;

    if (comando <> '') and (comando[1] = '"') then
        begin
            delete (comando, 1, 1);
            i := pos ('"', comando);
            if i = 0 then
                param := ''
            else
                begin
                    param := copy (comando, i+1, 999);
                    param := trim(param);
                    comando := copy (comando, 1, i-1);
                end;
        end
    else
        begin
            i := pos (' ', comando);
            if i = 0 then
                param := ''
            else
                begin
                    param := copy (comando, i+1, 999);
                    delete (comando, i, 999);
                end;
        end;

    getdir (0, nomeDir);
    while sintFalando do;
    if executaProg (comando, nomeDir, param) >= 32 then
        begin
            if espera then esperaProgVoltar;
        end
    else
        exit;

    processaExecuta := true;
end;

{--------------------------------------------------------}
{                  Comando Termina
{--------------------------------------------------------}

function processaTermina (lido: string): boolean;
begin
    fimScript := true;
    fimScriptMudo := false;
    if maiuscAnsi(lido) = 'MUDO' then
        fimScriptMudo := true;
    processaTermina := true;
end;

{--------------------------------------------------------}
{                  Comando chama
{--------------------------------------------------------}

function processaChama (lido: string): boolean;
var param, s: string;
    v: char;
    idx: integer;
begin
    processaChama := false;
    if fimScript then exit;   { processamento fora de arquivo }
    if lido = '' then exit;

    if maiuscAnsi(copy (lido, 1, 7)) = 'REMOTO ' then
        begin
            delete (lido, 1, 7);
            if not extraiValor (lido, param) then exit;
            v := #0;
            if lido <> '' then
                if not extraiVariavel (lido, v, idx) then exit;
            if lido <> '' then exit;

            if @rotinaExternaPtr <> NIL then
                begin
                    s := rotinaExternaPtr(param);
                    if v <> #0 then
                        if not guardaVar(v, idx, s) then exit;
                    processaChama := true;
                end;
            exit;
        end;

    if lido[1] = '@' then
        begin
            delete (lido, 1, 1);
            s := lido;
            if pos (' ', s) <> 0 then exit;  {rotulo com brancos}
        end
    else
        begin
            if not extraiValor (lido, s) then exit;
            if lido <> '' then exit;
        end;

    if topoRetorno < MAXRETORNO then
        begin
            topoRetorno := topoRetorno + 1;
            pilhaRetorno[topoRetorno] := linhaAtual;
        end
    else
        begin
            sintWriteln (STACK_OVERFLOW);  {'Muitas chamadas sem retorno'}
            exit;
        end;

    processaChama := buscaRotulo (s);
end;

{--------------------------------------------------------}
{                  Comando Busca
{--------------------------------------------------------}

function processaBusca (lido: string): boolean;
var
    v: char;
    idx: integer;
    valor: string;
    emDiretorio: boolean;
    pvalor: array [0..144] of char;
    nomeAchado: string;
begin
    processaBusca := false;
    nomeAchado := '';

    if not extraiVariavel (lido, v, idx) then exit;
    if lido = '' then exit;

    emDiretorio := false;
    if maiuscAnsi (copy (lido, 1, 3)) = 'DIR' then
        begin
            emDiretorio := true;
            delete (lido, 1, 4);
            lido := trim (lido);
        end;

    if (maiuscAnsi (copy (lido, 1, 7)) = 'PRÓXIMO') or
       (maiuscAnsi (copy (lido, 1, 7)) = 'PROXIMO') then
        begin
            delete (lido, 1, 7);
            if lido <> '' then exit;

            repeat
                if FindNext(DirInfo) <> 0 then break;
                if dirInfo.attr and atribBusca <> 0 then
                    begin
                        nomeAchado := DirInfo.FindData.cFileName;
                        break;
                    end;
            until dirInfo.attr and atribBusca <> 0;
        end
    else
    if lido = '' then
        getDir (0, nomeAchado)
    else
        begin
            if not extraiValor (lido, valor) then exit;
            if lido <> '' then exit;

            if emDiretorio then atribBusca := FaDirectory
                           else atribBusca := FaArchive;

            strPCopy (pvalor, valor);
            if FindFirst(pvalor, atribBusca, DirInfo) = 0 then
                nomeAchado := DirInfo.FindData.cFileName;
        end;

    processaBusca := guardaVar(v, idx, trim(nomeAchado));
end;

{--------------------------------------------------------}
{                  Comando Renomeia
{--------------------------------------------------------}

function processaRenomeia (lido: string): boolean;
var nomeArq1, nomeArq2: string;
    ignoraErro: boolean;
begin
    processaRenomeia := false;
    if lido = '' then exit;

    ignoraErro := false;
    if lido[length(lido)] = '&' then
        begin
           ignoraErro := true;
           delete (lido, 1, length (lido));
           lido := trim (lido);
        end;

    if not extraiValor (lido, nomeArq1) then exit;
    if not extraiValor (lido, nomeArq2) then exit;
    if lido <> '' then exit;

    assign (arq, nomeArq1);
    {$I-} rename (arq, nomeArq2);  {$I+}

    processaRenomeia := (ioresult = 0) or ignoraErro;
end;

{--------------------------------------------------------}
{                  Comando Replica
{--------------------------------------------------------}

function processaReplica (lido: string): boolean;
type
    pvet30k = ^vet30k;
    vet30k = array [0..29999] of byte;

var nomeArq1, nomeArq2: string;
    ignoraErro: boolean;
    arq1, arq2: file;
    buf: pvet30k;
    lidos, escritos: integer;
label fim;

begin
    processaReplica := false;
    if lido = '' then exit;

    ignoraErro := false;
    if lido[length(lido)] = '&' then
        begin
           ignoraErro := true;
           delete (lido, 1, length (lido));
        end;

    if not extraiValor (lido, nomeArq1) then exit;
    if not extraiValor (lido, nomeArq2) then exit;
    if lido <> '' then exit;

    new (buf);

    assign (arq1, nomeArq1);
    assign (arq2, nomeArq2);
    {$I-} reset (arq1, 1);  {$I+}
    if (ioresult <> 0) and (not ignoraErro) then goto fim;
    {$I-} rewrite (arq2, 1);  {$I+}
    if (ioresult <> 0) and (not ignoraErro) then goto fim;

    while not eof (arq1) do
        begin
            {$I-} blockRead (arq1, buf^, sizeof(buf^), lidos);  {$I+}
            if (ioresult <> 0) and (not ignoraErro) then
                begin
                    sintWriteln (ERRO_ARQUIVO + ' ' + nomearq1);
                    goto fim;
                end;

            {$I-} blockWrite (arq2, buf^, lidos, escritos);  {$I+}
            if (escritos <> lidos) and (not ignoraErro) then
                begin
                    sintWriteln (ERRO_ESCRITA + ' ' + nomearq2);
                    goto fim;
                end;
        end;

    processaReplica := true;

fim:
    dispose (buf);
    {$I-}  close (arq1);  {$I+}
    if ioresult <> 0 then;
    {$I-}  close (arq2);  {$I+}
    if ioresult <> 0 then;
end;

{--------------------------------------------------------}
{                  Comando Dir
{--------------------------------------------------------}

function processaDir (lido: string): boolean;
var op: char;
    nomeDir: string;
    ignoraErro: boolean;
begin
    processaDir := false;
    ignoraErro := false;

    if (lido <> '') and (lido [length(lido)] = '&') then
        begin
            ignoraErro := true;
            delete (lido, length(lido), 1);
            lido := trim (lido);
        end;

    if maiuscAnsi (copy (lido, 1, 5)) = 'CRIA ' then
         op := 'C'
    else
    if maiuscAnsi (copy (lido, 1, 7)) = 'REMOVE ' then
         op := 'R'
    else
    if maiuscAnsi (copy (lido, 1, 6)) = 'TROCA ' then
         op := 'T'
    else
         exit;

    while (lido <> '') and (lido [1] <> ' ') do
        delete (lido, 1, 1);
    lido := trim (lido);
    if not extraiValor (lido, nomeDir) then exit;
    if lido <> '' then exit;

    {$I-}
    case op of
         'C':  mkdir (nomeDir);
         'R':  rmdir (nomeDir);
         'T':  chdir (nomeDir);
    end;
    {$I+}

    if (ioresult <> 0) and (not ignoraErro) then
        begin
            sintWriteln (ERRO_DIR + nomeDir);
            exit;
        end;

    processaDir := true;
end;

{--------------------------------------------------------}
{                  Comando Retorna
{--------------------------------------------------------}

function processaRetorna (lido: string): boolean;
begin
    processaRetorna := false;
    if lido <> '' then exit;

    if topoRetorno = 0 then
        begin
            sintWriteln (STACK_UNDERFLOW);  {'Retorno sem chamada'}
            exit;
        end;

    linhaAtual := pilhaRetorno[topoRetorno];
    topoRetorno := topoRetorno -1;

    processaRetorna := true;
end;

{--------------------------------------------------------}
{                    Comando IP
{--------------------------------------------------------}

function processaIP (lido: string): boolean;
var
    v: char;
    idx: integer;
    endip: sockaddr_in;
    local: boolean;
    arqSel: char;
    tam: integer;
    valor: string;
begin
    processaIP := false;
    if lido = '' then exit;

    if maiuscAnsi (copy (lido, 1, 6)) = 'LOCAL ' then
        begin
            local := true;
            delete (lido, 1, 6);
        end
    else
    if maiuscAnsi (copy (lido, 1, 7)) = 'REMOTO ' then
        begin
            local := false;
            delete (lido, 1, 7);
        end
    else
        exit;

    lido := trim (lido);

    if not extraiNumArq (lido, arqSel) then exit;
    if not extraiVariavel (lido, v, idx) then exit;

    with arquivo [arqSel] do
        begin
            if soquete < 0 then exit;

            tam := sizeof (sockaddr_in);
            if local then
                getSockName (soquete, endip, tam)
            else
                getpeername(soquete, endip, tam);

            valor := strPas (inet_ntoa (TInAddr(endip.sin_addr.S_addr)))
        end;

    processaIP := guardaVar(v, idx, valor) and (lido = '');
end;

{--------------------------------------------------------}
{                    Comando MSAA
{--------------------------------------------------------}

function processaMSAA (lido: string): boolean;
var x, y, dx, dy, erro: integer;
    valor: string;
    v: char;
    idx: integer;

begin
    processaMSAA := false;
    if (maiuscAnsi (copy (lido, 1, 8))) = 'MONITORA' then
        begin
            delete (lido, 1, 8);
            MSAAMonitora (true);
        end
    else
    if (maiuscAnsi (copy (lido, 1, 3))) = 'FIM' then
        begin
            delete (lido, 1, 3);
            MSAAMonitora (false);
        end
    else
    if (maiuscAnsi (copy (lido, 1, 5))) = 'CHECA' then
        begin
            delete (lido, 1, 5);
            if not extraiVariavel (lido, v, idx) then exit;
            if MSAAPegaEvento then
                valor := '1'
            else
                valor := '0';
            if not guardaVar(v, idx, valor) then exit;
        end
    else
    if (maiuscAnsi (copy (lido, 1, 7))) = 'CAPTURA' then
        begin
            delete (lido, 1, 7);
            if not extraiValor (lido, valor) then exit;
            val (valor, x, erro);
            if erro <> 0 then exit;
            if not extraiValor (lido, valor) then exit;
            val (valor, y, erro);
            if erro <> 0 then exit;
            MSAAPegaPonto (x, y);
        end
    else
    if (maiuscAnsi (copy (lido, 1, 4))) = 'AREA' then
        begin
            delete (lido, 1, 4);
            MSAACoord (x, y, dx, dy);
            if not extraiVariavel (lido, v, idx) then exit;
            if not guardaVar (v, idx, intToStr(x)) then exit;
            if not extraiVariavel (lido, v, idx) then exit;
            str (y, varScript[v]);
            if not extraiVariavel (lido, v, idx) then exit;
            str (dx, varScript[v]);
            if not extraiVariavel (lido, v, idx) then exit;
            str (dy, varScript[v]);
        end
    else
    if (maiuscAnsi (copy (lido, 1, 4))) = 'NOME' then
        begin
            delete (lido, 1, 4);
            if not guardaValor(lido, MSAANome) then exit;
        end
    else
    if ((maiuscAnsi (copy (lido, 1, 6))) = 'CODIGO') or
       ((maiuscAnsi (copy (lido, 1, 6))) = 'CÓDIGO') then
        begin
            delete (lido, 1, 6);
            if not guardaValor(lido, intToStr(MSAACodTipo)) then exit;
        end
    else
    if ((maiuscAnsi (copy (lido, 1, 4))) = 'TIPO') then
        begin
            delete (lido, 1, 4);
            if not guardaValor(lido, MSAATipo) then exit;
        end
    else
    if ((maiuscAnsi (copy (lido, 1, 6))) = 'ESTADO') then
        begin
            delete (lido, 1, 6);
            if not guardaValor(lido, MSAAStatus) then exit;
        end
    else
    if ((maiuscAnsi (copy (lido, 1, 5))) = 'VALOR') then
        begin
            delete (lido, 1, 5);
            if not guardaValor(lido, MSAAValor) then exit;
        end
    else
        exit;

    processaMSAA := true;
end;

{--------------------------------------------------------}
{                    Comando MENU
{--------------------------------------------------------}

function processaMenu (lido: string): boolean;
var xmin, ymin, xmax, ymax, erro: integer;
    valor: string;
    v1, v2, v3: char;
    idx1, idx2, idx3: integer;
    c1, c2: char;
    n: integer;
    selec: boolean;
    salvax, salvay: integer;
begin
    processaMenu := false;
    if (maiuscAnsi (copy (lido, 1, 4))) = 'CRIA' then
        begin
            delete (lido, 1, 4);
            if not extraiValor (lido, valor) then exit;
                    val (valor, xmin, erro);
                    if erro <> 0 then exit;
            if not extraiValor (lido, valor) then exit;
                    val (valor, ymin, erro);
                    if erro <> 0 then exit;
            if not extraiValor (lido, valor) then exit;
                    val (valor, xmax, erro);
                    if erro <> 0 then exit;
            if not extraiValor (lido, valor) then exit;
                    val (valor, ymax, erro);
                    if erro <> 0 then exit;

            if xmin = 0 then
                begin
                    xmin := wherex;
                    xmax := xmax + xmin - 1;
                end;
            if ymin = 0 then
                begin
                    ymin := wherey;
                    ymax := ymax + ymin - 1;
                end;

            folheiaCria (xmin, ymin, xmax, ymax);
            itemInic := 1;
        end
    else
    if (maiuscAnsi (copy (lido, 1, 8))) = 'ADICIONA' then
        begin
            delete (lido, 1, 8);
            if not extraiValor (lido, valor) then exit;
            folheiaAdiciona(valor);
        end
    else
    if (maiuscAnsi (copy (lido, 1, 7))) = 'TERMINA' then
        begin
            delete (lido, 1, 7);
            folheiaLimpa;
            folheiaDestroi;
        end
    else
    if (maiuscAnsi (copy (lido, 1, 7))) = 'EXECUTA' then
        begin
            delete (lido, 1, 7);
            if not extraiVariavel (lido, v1, idx1) then exit;  // número do item
            if not extraiVariavel (lido, v2, idx2) then exit;  // letra acionada
            if not extraiVariavel (lido, v3, idx3) then exit;  // item escolhido
            repeat
                 if not pegaVar(v1, idx1, valor) then exit;
                 val (valor, itemInic, erro);
                 if itemInic <= 0 then
                    itemInic := 1;
                 salvax := wherex;
                 salvay := wherey;
                 folheiaExecuta(itemInic, n, c1, c2, true);
                 gotoxy (salvax, salvay);
            until (c1 <> #0) or (c2 in [F1..F12]);

            if not guardaVar(v1, idx1, intToStr(n)) then exit;
            if c1 >= ' ' then
                begin
                    if not guardaVar (v2, idx2, c1) then exit;
                end
            else
            if (c1 = #0) and (c2 in [F1..F12]) then
                begin
                    if not guardaVar (v2, idx2,
                            '#0#' + intToStr (ord(c2) - ord(F1) + 59)) then exit;
                end
            else
                begin
                    if not guardaVar (v2, idx2, '#' +intToStr(ord(c1))) then exit;
                end;

            folheiaObtemItem(n, valor, selec);
            if not guardaVar (v3, idx3, valor) then exit;
        end
    else
        exit;

    if lido <> '' then exit;
    processaMenu := true;
end;

{--------------------------------------------------------}
{              nomeia um arquivo temporário
{--------------------------------------------------------}

function GetTempFile: String;
var
    tempFileName, tempPath: array[0..255] of Char;

begin
    getTempPath (255, tempPath);
    getTempFileName(tempPath, '$$$', 0, tempFileName);
    result := strPas (tempFileName);
end;

{--------------------------------------------------------}
{                    Comando IMAGEM
{--------------------------------------------------------}

function processaImagem (lido: string): boolean;
var
    nomeArq: string;
    x, y, erro: integer;
    ignoraErro: boolean;
    s: string;
    colando: boolean;
    nomeTemp: string;
begin
    processaImagem := false;
    colando := false;

    if lido = '' then
        begin
    	    closeBMP;
            processaImagem := true;
	    exit;
	end;

    ignoraErro := false;
    if lido[length(lido)] = '&' then
        begin
           ignoraErro := true;
           delete (lido, 1, length (lido));
           lido := trim (lido);
        end;

    if not extraiValor (lido, nomeArq) then exit;
    if lido <> '' then
        begin
            if not extraiValor (lido, s) then exit;
            val (s, x, erro);
            if erro <> 0 then exit;
            if not extraiValor (lido, s) then exit;
            val (s, y, erro);
            if erro <> 0 then exit;

            if (maiuscAnsi (copy (lido, 1, 4))) = 'COLA' then
                begin
                    delete (lido, 1, 4);
                    colando := true;
                end;

            if lido <> '' then exit;
       end
    else
        begin
            x := 0;
            y := 0;
        end;

    if colando then
        freeBmp
    else
        closeBMP;

    if trim (nomeArq) <> '' then
        begin
            if (ansiUpperCase (copy (nomeArq, length (nomeArq)-3, 4)) = '.JPG') or
               (ansiUpperCase (copy (nomeArq, length (nomeArq)-5, 5)) = '.JPEG') then
                   begin
                       if FileExists(nomeArq) then
                           begin
                               nomeTemp := GetTempFile;
                               CopyJpegToBmp (nomeArq, nomeTemp);
                               nomeArq := nomeTemp;
                           end;
                   end;
            if not openBMP (nomeArq) then
                begin
                    if not ignoraErro then exit;
                end
            else
                paintBMP (x, y);
        end;

    processaImagem := true;
    if nomeArq = nomeTemp then
        DeleteFile(nomeTemp);
end;

{--------------------------------------------------------}
{                    Comando SERIAL
{--------------------------------------------------------}

function processaSerial (lido: string): boolean;
var
    arqSel: char;
    porta, veloc, nbits, nstop, parid: integer;
begin
    processaSerial := false;

    if not extraiNumArq (lido, arqSel)      then exit;
    if not extraiValorInteiro (lido, porta) then exit;
    if lido = '' then
        begin
           veloc := 9600;
           nbits := 8;
           nstop := 1;
           parid := 0;
        end
    else
        begin
            if not extraiValorInteiro (lido, veloc) then exit;
            if not extraiValorInteiro (lido, nbits) then exit;
            if not extraiValorInteiro (lido, nstop) then exit;
            if not extraiValorInteiro (lido, parid) then exit;
            if lido <> '' then exit;
        end;

    statusUltIO := ord(inicLink(porta, veloc, nbits, nstop, parid));
    if statusUltIO = 0 then
        with arquivo [arqsel] do
            begin
                aberto := true;
                internet := false;
                serial := true;
                sleep (1500);  // espera conexão se estabilizar
            end;

    processaSerial := true;
end;

{--------------------------------------------------------}
{                    Comando DESTROI
{--------------------------------------------------------}

function processaDestroi (lido: string): boolean;
var v: char;
begin
    processaDestroi := false;
    if not extraiNomeVar (lido, v) then exit;

    if listaScript[v] <> NIL then
        listaScript[v].Free;
    listaScript[v] := NIL;
    processaDestroi := true;
end;

{--------------------------------------------------------}
{                    Comando INSERE
{--------------------------------------------------------}

function processaInsere (lido: string): boolean;
var v: char;
    valor: string;
    indice: integer;
begin
    processaInsere := false;
    if not extraiNomeVar (lido, v) then exit;

    ignoraCarac (lido, '[');
    if not extraiValorInteiro (lido, indice) then exit;
    ignoraCarac (lido, ']');

    if not extraiValor (lido, valor) then exit;

    if (listaScript[v] = NIL) or (indice < 0) or
       (listaScript[v].count <= indice) then exit;

    listaScript[v].Insert(indice, valor);
    processaInsere := true;
end;

{--------------------------------------------------------}
{                    Comando RETIRA
{--------------------------------------------------------}

function processaRetira (lido: string): boolean;
var v: char;
    indice: integer;
begin
    processaRetira := false;
    if not extraiNomeVar (lido, v) then exit;

    ignoraCarac (lido, '[');
    if not extraiValorInteiro (lido, indice) then exit;
    ignoraCarac (lido, ']');

    if (listaScript[v] = NIL) or (indice < 0) or
       (listaScript[v].count <= indice) then exit;

    listaScript[v].Delete(indice);
    processaRetira := true;
end;

{--------------------------------------------------------}
{                    Comando RETIRA
{--------------------------------------------------------}

function processaProcura (lido: string): boolean;
var v, vv: char;
    idx: integer;
    indice: integer;
    buscaMaiusc, buscaParcial: boolean;
    i: integer;
    buscado, s: string;
    p, posicao, tam: integer;
begin
    processaProcura := false;

    if not extraiVariavel (lido, v, idx) then exit;  // recebe a posição final

    if not extraiNomeVar (lido, vv) then exit;       // vetor
    ignoraCarac (lido, '[');
    if not extraiValorInteiro (lido, indice) then exit;  // pos. inicial de busca
    ignoraCarac (lido, ']');

    if not extraiValor (lido, buscado) then exit;  // cadeia a buscar

    lido := AnsiUpperCase(lido);

    buscaParcial := false;
    p := pos ('PARCIAL', lido);
    if p <> 0 then
        begin
            buscaParcial := true;
            delete (lido, p, 7);
        end;

    buscaMaiusc := false;
    p := pos ('MAIUSC', lido);
    if p <> 0 then
        begin
            buscaMaiusc := true;
            delete (lido, p, 7);
        end;

    if trim (lido) <> '' then exit;  // erro: parâmetros demais

    if listaScript[vv] = NIL then
        begin
            sintWriteln (LISTA_INEXISTE);
            exit;
        end;

    if buscaMaiusc then
        buscado := ansiUpperCase (buscado);
    tam := length(buscado);

    posicao := -1;
    for i := indice to listaScript[vv].Count-1 do
        begin
            s := listaScript[vv][i];
            if (not buscaParcial) and (length(s) <> tam) then
                continue;
            if buscaMaiusc then
                s := ansiUpperCase(s);
            if pos(buscado, s) <> 0 then
                begin
                    posicao := i;
                    break;
                end;
        end;

    processaProcura := guardaVar(v, idx, intToStr(posicao));
end;

{--------------------------------------------------------}
{                    Comando ANEXA
{--------------------------------------------------------}

function processaAnexa (lido: string): boolean;
var v, v2: char;
    i: integer;
begin
    processaAnexa := false;

    if not extraiNomeVar (lido, v) then exit;
    if not extraiNomeVar (lido, v2) then exit;
    if (listaScript[v] = NIL) or (listaScript[v2] = NIL) then
        begin
            sintWriteln (LISTA_INEXISTE);
            exit;
        end;

    for i := 0 to listaScript[v2].Count-1 do
        listaScript[v].Add(listaScript[v2][i]);

    processaAnexa := true;
end;

{--------------------------------------------------------}
{                    Comando ORDENA
{--------------------------------------------------------}

function processaOrdena (lido: string): boolean;
var v: char;
    p: integer;
    crescente, maiusc, numerico: boolean;

    function rotCompara2(lista: TStringList; Index1, Index2: Integer): Integer;
    begin
            begin
                if crescente then
                    if maiusc then
                        Result := AnsiCompareText(lista[Index2], lista[Index1])
                    else
                        Result := AnsiCompareStr(lista[Index2], lista[Index1])
                else
                    if maiusc then
                        Result := AnsiCompareText(lista[Index1], lista[Index2])
                    else
                        Result := AnsiCompareStr(lista[Index1], lista[Index2]);
            end;
    end;

    function rotCompara(lista: TStringList; Index1, Index2: Integer): Integer;
    begin
        Result := AnsiCompareText(lista[Index1], lista[Index2])
    end;

    function rotComparaDec(lista: TStringList; Index1, Index2: Integer): Integer;
    begin
        Result := AnsiCompareText(lista[Index2], lista[Index1])
    end;

    function rotComparaNum(lista: TStringList; Index1, Index2: Integer): Integer;
    var n1, n2, erro: integer;
    begin
        val (lista[Index1], n1, erro);
        val (lista[Index2], n2, erro);
        writeln (n1, ' ', n2);
        if crescente then result := n1 - n2
                     else result := n2 - n1;
    end;

    function rotComparaNumDec(lista: TStringList; Index1, Index2: Integer): Integer;
    var n1, n2, erro: integer;
    begin
        val (lista[Index1], n1, erro);
        val (lista[Index2], n2, erro);
        writeln (n1, ' ', n2);
        if crescente then result := n2 - n1
                     else result := n1 - n2;
    end;

begin
    processaOrdena := false;

    if not extraiNomeVar (lido, v) then exit;
    if listaScript[v] = NIL then
        begin
            sintWriteln (LISTA_INEXISTE);
            exit;
        end;

    crescente := true;
    numerico := false;

    lido := ansiUpperCase(lido);

    p := pos ('DECRESCENTE', lido);
    if p <> 0 then
        begin
            crescente := false;
            delete (lido, p, 11);
            lido := trim(lido);
        end;

    p := pos ('NUMÉRICO', lido);
    if p = 0 then
        p := pos ('NUMERICO', lido);
    if p <> 0 then
        begin
            numerico := true;
            delete (lido, p, 8);
            lido := trim(lido);
        end;

    if lido <> '' then exit;

    if numerico then
    else
        if crescente then
            listaScript[v].CustomSort (@rotCompara)
        else
            listaScript[v].CustomSort (@rotComparaDec);

    processaOrdena := true;
end;

{--------------------------------------------------------}
{                    Comando SEPARA
{--------------------------------------------------------}

function processaSepara (lido: string): boolean;
var v: char;
    p: integer;
    valor, separador, extraido: string;
    tiraBrancos: boolean;
begin
    processaSepara := false;
    if lido = '' then exit;

    tiraBrancos := true;
    if lido[length(lido)] = '&' then
        begin
            tiraBrancos := false;
            delete (lido, length(lido), 1);
            lido := trim(lido);
        end;

    if not extraiValor (lido, valor) then exit;     // valor a separar
    if not extraiNomeVar (lido, v) then exit;       // nome da lista
    if listaScript[v] <> NIL then
        listaScript[v].Free;
    listaScript[v] := TStringList.Create;

    if not extraiValor(lido, separador) then        // separador
        begin
            sintWriteln (SEPARA_INVALIDO);
            exit;
        end;

    while valor <> '' do
        begin
            p := pos (separador, valor);
            if p = 0 then p := 9999;
            extraido := copy (valor, 1, p-1);
            if tiraBrancos then
                extraido := trim(extraido);
            delete (valor, 1, p+length(separador)-1);
            listaScript[v].add(extraido);
        end;

    processaSepara := lido = '';
end;

{--------------------------------------------------------}
{                  comando baixa
{--------------------------------------------------------}

function processaBaixa (lido: string): boolean;

const
    CRLF = #$0d + #$0a;


{--------------------------------------------------------}

    function traduzURL (url: string; out protocolo, nomeComput: string;
                                     out porta: integer;
                                     out recurso: string): boolean;
    var
        i: integer;
        erro: integer;
        s: string;
    begin
        traduzURL := false;

        url := trim(url);
        i := pos('://' , url);
        if i = 0 then
            protocolo := 'http'
        else
            begin
                protocolo := copy(url, 1, (i-1));
                url := copy(url, (i+3), 999);
            end;
        protocolo := upperCase(protocolo);

        i := pos('/', url);
        if i = 0 then
            i := pos('?', url);

        if i = 0 then
            begin
                recurso := '';
                nomeComput := url;
            end
        else
            begin
                nomeComput := copy(url, 1, (i-1));
                recurso := copy(url, i, 999);
                if copy(recurso, 1,1) = '?' then
                    recurso := '/' + recurso;
            end;

        i := pos(':', nomeComput);
        if i <> 0 then
            begin
                s := copy(nomeComput, (i+1), 999);
                nomeComput := copy(nomeComput, 1, i-1);
                val (s, porta, erro);
                if erro <> 0 then
                    exit;
            end
        else
            if protocolo = 'HTTPS' then
                porta := 443
            else
                porta := 80;

        if recurso = '' then
            recurso := '/';

        i := pos('?', recurso);
        if i <> 0 then
            recurso := copy(recurso, 1,i) + EncodeURL(copy(recurso, i+1,999));

        traduzURL := true;
    end;

{--------------------------------------------------------}

    function pegaHeader (protocolo, nomeComput: string; porta: integer; recurso: string;
                         out codRetorno: integer;
                         out novaUrl: string;
                         out pbuf: PbufRede;
                         out soquete: integer): boolean;

    var s: string;
        i: integer;
        header: TStringList;
        aEnviar: string;

    begin
        pegaHeader := false;
        codRetorno := 500;
        novaUrl := '';

        if ansiUpperCase(protocolo) = 'HTTPS' then
            soquete := abreConexaoSSL (nomeComput, porta)
        else
            soquete := abreConexao (nomeComput, porta);
        if soquete < 0 then
            begin
                sintWriteln (ERRO_CONEXAO);  {'Erro de conexao' ou seja, soquete menor que 0};
                exit;
            end;

        aEnviar :=
            'GET ' + EncodeURL(recurso) + ' HTTP/1.0' + CRLF +
            'UA-CPU: x86' + CRLF +
            'Connection: Close' + CRLF +
            'Accept-Language: pt-br' + CRLF +
            'User-Agent: Scriptvox ' + VERSAO_DVSCRIPT + CRLF +
            'Host: ' + nomeComput + CRLF +
            CRLF;

        statusUltIO := ord (writeRede(soquete, aEnviar));

        pBuf := inicBufRede (soquete);

        header := TStringList.Create;
        repeat
            statusUltIO := ord (not readlnBufRede (pbuf, s, 30));
            header.add(s);
        until (statusUltIO <> 0) or (s = '');

        if copy(header[0], 1,4) <> 'HTTP' then   // erro no servidor
            begin
                sintWriteln (ERRO_HTTP);
                header.Free;
                fechaConexao(soquete);
                fimBufRede(pbuf);
                pbuf := NIL;
                exit;
            end;

        s := header[0];
        i := pos(' ', s);
        codRetorno := StrToInt(copy(s, i+1, 3));

        if (codRetorno div 100) = 3  then  // relocators
            begin
                // pega o location
                for i := 0 to (header.Count-1) do
                    begin
                        if pos('LOCATION:', upperCase(header[i])) = 1 then
                            novaUrl := trim(copy(header[i], 10 , 999));
                    end;
                fimBufRede (pbuf);
                fechaConexao(soquete);
            end;

        header.Free;
        pegaHeader := true;
    end;

    {--------------------------------------------------------}

    function abreUrl(url: string; out pBuf: pbufrede; out soquete: integer): boolean;
    var
        protocolo, nomeComput, recurso: string;
        porta: integer;
        novaUrl: string;
        codRetorno: integer;

    begin
        abreUrl := false;
        novaUrl := url;

        codRetorno := 300;
        while (codRetorno div 100) = 3  do
            begin
                if not traduzURL (novaUrl, protocolo, nomeComput, porta, recurso) then
                    exit;

                 if not pegaHeader (protocolo, nomeComput, porta, recurso,
                                   codRetorno, novaUrl, pbuf, soquete) then
                    exit;
           end;

        abreUrl := true;
     end;

{--------------------------------------------------------}

function copiaURLparaArquivo (pbuf: PbufRede; soquete: integer;
                              nomeArqBaixar: string): boolean;
    const
        TAMBUF = 8192;
    var
        arq: file;
        lidoOk: boolean;
        buf: packed array [0..TAMBUF-1] of char;
        ncbuf: integer;
        c: char;
        escritos: integer;
    begin
         copiaURLparaArquivo := false;
         statusUltIO := 0;
         ncbuf := 0;

         assign (arq, nomeArqBaixar);
         {$I-}  rewrite (arq, 1);  {$I+}
         if ioresult <> 0 then
             begin
                 statusUltIO := 1;
                 sintWriteln(ERRO_ESCRITA);
                 exit;
             end;

        // versão futura: checar o content-Length previamente recebido
        // se não tiver vindo, considerar tamanho infinito.

        repeat
            lidoOk := leCaracBufRede(pbuf, c);
            if lidoOk then
                begin
                    buf[ncbuf] := c;
                    ncbuf := ncbuf + 1;
                end;

            if ncbuf >= TAMBUF then
                begin
                    escritos := 0;
                    blockWrite (arq, buf, ncbuf, escritos);
                    if escritos <> ncbuf then
                        begin
                            sintWriteln(ERRO_ESCRITA);
                            statusUltIO := 1;
                            lidoOk := false;
                        end;
                    ncbuf := 0;
                end;
        until not lidoOk;

        if ncbuf <> 0 then
            begin
                escritos := 0;
                blockWrite (arq, buf, ncbuf, escritos);
                if escritos <> ncbuf then
                    begin
                        sintWriteln(ERRO_ESCRITA);
                        statusUltIO := 1;
                    end;
                end;

        closeFile (arq);
        copiaURLparaArquivo := true;
    end;

{--------------------------------------------------------}

var
    url: string;
    nomeArqBaixar: string;
    aceitaErro: boolean;
    pbuf: PbufRede;
    soquete: integer;

label erro;
begin
    processaBaixa := false;
    aceitaErro := false;

    if copy (lido, length(lido), 1) = '&' then
        begin
            aceitaErro := true;
            delete (lido, length(lido), 1);
            lido := trim(lido);
        end;

    if not extraiValor (lido, url) then exit;
    if not extraiValor (lido, nomeArqBaixar) then exit;
    if trim(lido) <> '' then exit;

    if abreUrl(url, pbuf, soquete) then
        begin
            if copiaURLparaArquivo (pbuf, soquete, nomeArqBaixar) or aceitaErro then
                processaBaixa := true;
            fimBufRede(pbuf);
            fechaConexao(soquete);
        end;
end;

{--------------------------------------------------------}
{                    Comando converte
{--------------------------------------------------------}

function processaConverte (lido: string): boolean;

type
    TConversoes = (utf, url, mime, qp);

function descobreTipo (lido: string; tipo: string ;
                       out tipoConv: TConversoes): boolean;
    begin
        descobreTipo := false;

        if (tipo = 'UTF8') or
           (tipo = 'UTF') then   tipoConv := utf
        else
        if tipo = 'URL'   then   tipoConv := url
        else
        if tipo = 'MIME'  then   tipoConv := mime
        else
        if tipo = 'QP'    then   tipoConv := qp
        else
            exit;

         descobreTipo := true;
    end;

{--------------------------------------------------------}
var

    c: char;
    s: string;
    tipo: string;
    idx: integer;
    tipoConv: TConversoes;

begin
    processaConverte := false;

    if not extraiVariavel (lido, c, idx) then exit;
    if not pegaVar (c, idx, s) then exit;

    if maiuscAnsi (copy (lido, 1, 3)) = 'DE ' then
        begin
             tipo := trim (maiuscAnsi (copy (lido, 4, length(lido))));
             if tipo = '' then exit;
             if not descobreTipo(lido, tipo, tipoConv) then exit;

             case tipoConv of
                 utf:  s := UTF8Decode(s);
                 url:  s := DecodeURL(s);
                 mime: s := DecodeBase64(s);
                 qp:   s := DecodeQuotedPrintable(s);
            end;
        end
    else
    if maiuscAnsi (copy (lido, 1, 5)) = 'PARA ' then
        begin
            tipo := trim(maiuscAnsi (copy (lido, 6, length(lido))));
            if tipo = '' then exit;
            if not descobreTipo(lido, tipo, tipoConv) then exit;

             case tipoConv of
                 utf:  s := UTF8Encode(s);
                 url:  s := EncodeURL(s);
                 mime: s := EncodeBase64(s);
                 qp:   s := EncodeQuotedPrintable(s);
            end;
        end                  
     else
        exit;

     processaConverte := guardaVar(c, idx, s);
end;

{--------------------------------------------------------}
{                    Comando HELP
{--------------------------------------------------------}

function processaHelp(lido: string): boolean;
var
    comando, param, nomeDir: string;

begin
    processaHelp := false;

    while sintFalando do;

    comando := sintAmbiente ('DOSVOX', 'EDITOR');
    if comando = '' then
        comando := 'c:\winvox\edivox.exe';

    nomeDir := sintAmbiente ('DOSVOX', 'PGMDOSVOX');
    if nomeDir = '' then nomeDir := 'c:\winvox';
    nomeDir := nomeDir + '\manual';

    param := 'scripvox.txt';

    if lido <> '' then
       sintWriteln (MANUAL_PARCIAL);

    if executaProg (comando, nomeDir, param) >= 32 then
        esperaProgVoltar
    else
        exit;

    processaHelp := true;
end;

{--------------------------------------------------------}
{                    Comando SPRITES
{--------------------------------------------------------}

function processaSprites (lido: string): boolean;

var x, y: integer;
    PNG: TPNGObject;
    JPG: TJpegImage;
    BMPLocal: TBitmap;
    nomeArq: string;

begin
    processaSprites := false;
    
    if (maiuscAnsi (copy (lido, 1, 4))) = 'CRIA' then
        begin
            delete (lido, 1, 4);
            if lido <> '' then
                begin
                    if not extraiValor (lido, nomeArq) then exit;
                    if lido <> '' then exit;
                    if not fileExists(nomeArq) then exit;
                end
            else
                nomeArq := '';

    	    if BMPGlobal <> NIL then
                BMPGlobal.Free;
            BMPGlobal := TBitmap.Create;

            if (ansiUpperCase (copy (nomeArq, length (nomeArq)-3, 4)) = '.JPG') or
               (ansiUpperCase (copy (nomeArq, length (nomeArq)-5, 5)) = '.JPEG') then
                begin
                    JPG := TJPEGImage.Create;
                    JPG.LoadFromFile(nomeArq);
                    BMPGlobal.Assign(JPG);
                    JPG.Free;
                end
            else
            if upperCase (copy (nomeArq, length(nomeArq)-3, 4)) = '.PNG' then
                begin
                    PNG := TPNGObject.Create;
                    PNG.LoadFromFile(nomeArq);
                    BMPGlobal.assign(PNG);
                    PNG.free;
                end
            else
            if upperCase (copy (nomeArq, length (nomeArq)-3, 4)) = '.BMP' then
                BMPGlobal.LoadFromFile(nomeArq)
            else
            if nomeArq <> '' then
                exit;
        end
    else

    if (maiuscAnsi (copy (lido, 1, 4))) = 'COLA' then
        begin
            delete (lido, 1, 4);
            if not extraiValor (lido, nomeArq)  then exit;
            if not extraiValorInteiro (lido, x) then exit;
            if not extraiValorInteiro (lido, y) then exit;
            if lido <> '' then exit;

            if BMPGlobal = NIL then exit;
            if not fileExists(nomeArq) then exit;

            if (upperCase (copy (nomeArq, length (nomeArq)-3, 4)) = '.JPG') or
               (upperCase (copy (nomeArq, length (nomeArq)-5, 5)) = '.JPEG') then
                begin
                    JPG := TJPEGImage.Create;
                    JPG.LoadFromFile(nomeArq);
                    BMPGlobal.Canvas.Draw(x, y, JPG);
                    JPG.Free;
                   end
            else
            if upperCase (copy (nomeArq, length(nomeArq)-3, 4)) = '.PNG' then
                begin
                    PNG := TPNGObject.Create;
                    PNG.LoadFromFile(nomeArq);
                    BMPGlobal.Canvas.Draw(x, y, PNG);
                    PNG.free;
                end
            else
            if upperCase (copy (nomeArq, length (nomeArq)-3, 4)) = '.BMP' then
                begin
                    BMPLocal := TBitMap.Create;
                    BMPLocal.LoadFromFile (nomeArq);
                    BMPGlobal.Canvas.Draw(x, y, BMPLocal);
                    BMPLocal.free;
                end
            else
                exit;
        end
    else

    if (maiuscAnsi (copy (lido, 1, 5))) = 'GRAVA' then
        begin
            delete (lido, 1, 5);
            if not extraiValor (lido, nomeArq)  then exit;
            if lido <> '' then exit;

            if (upperCase (copy (nomeArq, length (nomeArq)-3, 4)) = '.JPG') or
               (upperCase (copy (nomeArq, length (nomeArq)-5, 5)) = '.JPEG') then
                begin
                    JPG := TJPEGImage.Create;
                    JPG.Assign(BMPGlobal);
                    JPG.SaveToFile(nomeArq);
                    JPG.Free;
                end
            else
            if upperCase (copy (nomeArq, length(nomeArq)-3, 4)) = '.PNG' then
                begin
                    PNG := TPNGObject.Create;
                    PNG.Assign(BMPGlobal);
                    PNG.SaveToFile(nomeArq);
                    PNG.Free;
                end
            else
            if upperCase (copy (nomeArq, length (nomeArq)-3, 4)) = '.BMP' then
                begin
                    BMPGlobal.SaveToFile(nomeArq);
                end
            else
                exit;
        end
    else

    if (maiuscAnsi (copy (lido, 1, 5))) = 'LIMPA' then
        begin
            delete (lido, 1, 5);
            if BMPGlobal <> NIL then
                BMPGlobal.free;
            BMPGlobal := NIL;
        end
    else
        exit;

    processaSprites := true;
end;

{--------------------------------------------------------}
{             executa um comando do script
{--------------------------------------------------------}

function executaComando (cmd, lido: string): boolean;
begin
    if cmd = '' then
        begin
            executaComando := false;
            exit;
        end;

    lido := trim (lido);
    if debug then
        sintWriteln (cmd + ' ' + lido);

    cmd := maiuscAnsi (cmd);

    if cmd = 'DEBUG'     then executaComando := processaDebug (lido)
    else
    if cmd = 'SEJA'      then executaComando := processaSeja (lido)
    else
    if cmd = 'TELA'      then executaComando := processaTela (lido)
    else
    if cmd = 'COR'       then executaComando := processaCor (lido)
    else
    if cmd = 'FUNDO'     then executaComando := processaFundo (lido)
    else
    if cmd = 'CURSOR'    then executaComando := processaCursor (lido)
    else
    if cmd = 'ABRE'      then executaComando := processaAbre (lido)
    else
    if cmd = 'FECHA'     then executaComando := processaFecha (lido)
    else
    if cmd = 'INTERNET'  then executaComando := processaInternet (lido)
    else
    if cmd = 'CONECTA'   then executaComando := processaConecta (lido)
    else
    if cmd = 'SERVE'     then executaComando := processaServe (lido)
    else
    if cmd = 'ACEITA'    then executaComando := processaAceita (lido)
    else
    if cmd = 'OBSERVA'   then executaComando := processaObserva (lido)
    else
    if cmd = 'ESCREVE'   then executaComando := processaEscreve (lido)
    else
    if cmd = 'BIPA'      then executaComando := processaBipa (lido)
    else
    if cmd = 'SOMA'      then executaComando := processaSoma (lido)
    else
    if cmd = 'SUBTRAI'   then executaComando := processaContas (lido, '-')
    else
    if cmd = 'MULTIPLICA' then executaComando := processaContas (lido, '*')
    else
    if cmd = 'DIVIDE'    then executaComando := processaContas (lido, '/')
    else
    if cmd = 'CONCATENA' then executaComando := processaConcatena (lido)
    else
    if cmd = 'COPIA'     then executaComando := processaCopia (lido)
    else
    if cmd = 'SUBSTITUI' then executaComando := processaSubstitui (lido)
    else
    if cmd = 'TROCA'     then executaComando := processaTroca (lido)
    else
    if cmd = 'TOCA'      then executaComando := processaToca (lido)
    else
    if cmd = 'FALA'      then executaComando := processaFala (lido)
    else
    if cmd = 'MCI'       then executaComando := processaMci (lido)
    else
    if (cmd = 'LÊ') or
       (cmd = 'LE')      then executaComando := processaLe (lido)
    else
    if cmd = 'CHECA'     then executaComando := processaCheca (lido)
    else
    if cmd = 'REMOVE'    then executaComando := processaRemove (lido)
    else
    if cmd = 'RENOMEIA'  then executaComando := processaRenomeia (lido)
    else
    if cmd = 'REPLICA'   then executaComando := processaReplica (lido)
    else
    if cmd = 'CMD'       then executaComando := processaCmd (lido)
    else
    if cmd = 'ESPERA'    then executaComando := processaEspera (lido)
    else
    if cmd = 'DIGITA'    then executaComando := processaDigita (lido)
    else
    if cmd = 'ACIONA'    then executaComando := processaAciona (lido)
    else
    if cmd = 'CLICA'     then executaComando := processaClica (lido)
    else
    if cmd = 'CAPTURA'   then executaComando := processaCaptura (lido)
    else
    if cmd = 'TRANSFERE' then executaComando := processaTransfere (lido)
    else
    if cmd = 'JANELA'    then executaComando := processaJanela (lido)
    else
    if cmd = 'DESVIA'    then executaComando := processaDesvia (lido)
    else
    if cmd = 'SE'        then executaComando := processaSe (lido)
    else
    if (cmd = 'SENAO') or (cmd = 'SENÃO') then
                              executaComando := processaSenao (lido)
    else
    if cmd = 'ENQUANTO'  then executaComando := processaEnquanto (lido)
    else
    if cmd = 'REPETE'    then executaComando := processaRepete (lido, false)
    else
    if cmd = 'FIM'       then executaComando := processaFim (lido)
    else
    if cmd = 'EXECUTA'   then executaComando := processaExecuta (lido)
    else
    if cmd = 'DIR'       then executaComando := processaDir (lido)
    else
    if cmd = 'BUSCA'     then executaComando := processaBusca (lido)
    else
    if cmd = 'TERMINA'   then executaComando := processaTermina (lido)
    else
    if cmd = 'CHAMA'     then executaComando := processaChama (lido)
    else
    if cmd = 'RETORNA'   then executaComando := processaRetorna (lido)
    else
    if cmd = 'RANDOMIZA' then executaComando := processaRandomiza (lido)
    else
    if cmd = 'IP'        then executaComando := processaIp (lido)
    else
    if cmd = 'MSAA'      then executaComando := processaMSAA (lido)
    else
    if cmd = 'MENU'      then executaComando := processaMENU (lido)
    else
    if cmd = 'IMAGEM'    then executaComando := processaImagem (lido)
    else
    if cmd = 'SERIAL'    then executaComando := processaSerial (lido)
    else
    if (cmd = 'RATO') or
       (cmd = 'MOUSE')   then executaComando := processaMouse (lido)
    else
    if cmd = 'DESTROI'   then executaComando := processaDestroi (lido)
    else
    if cmd = 'INSERE'    then executaComando := processaInsere (lido)
    else
    if cmd = 'RETIRA'    then executaComando := processaRetira (lido)
    else
    if cmd = 'PROCURA'   then executaComando := processaProcura (lido)
    else
    if cmd = 'ANEXA'     then executaComando := processaAnexa (lido)
    else
    if cmd = 'ORDENA'    then executaComando := processaOrdena (lido)
    else
    if cmd = 'SEPARA'    then executaComando := processaSepara (lido)
    else
    if cmd = 'BAIXA'     then executaComando := processaBaixa (lido)
    else
    if cmd = 'CONVERTE'  then executaComando := processaConverte (lido)
    else
    if cmd = 'SPRITE'    then executaComando := processaSprites (lido)
    else
    if (cmd = 'AJUDA') or
       (cmd = 'HELP')    then executaComando := processaHelp (lido)

    else
    if pos('=', cmd+lido) > 0 then executaComando := processaSeja (cmd+lido)

    else
        begin
            executaComando := false;
            sintWriteln (COMANDO_INVALIDO + cmd);   {'Comando inválido: '}
        end;
end;

{--------------------------------------------------------}
{                executa uma linha
{--------------------------------------------------------}

function execCmdScript (lido: string; procExterno: boolean): boolean;
begin
    execCmdScript := true;
    lido := trim (lido);
    if (lido = '') or (lido[1] = '*') or (lido[1] = '@') then
        exit;

    cmd := pegaPalavraMaiusc (lido);

    if procExterno and
        ((cmd = 'REPETE') or (cmd = 'ENQUANTO') or
         (cmd = 'SENAO') or (cmd = 'SENÃO') or
         (cmd = 'FIM')) then
            execCmdScript := false    {esses não são válidos como imediatos}
    else
        begin
            erroProc := not executaComando (cmd, lido);
            execCmdScript := not erroProc;
        end;
end;

{--------------------------------------------------------}
{      executa uma linha em processamento externo
{--------------------------------------------------------}

function cmdScript (lido: string): boolean;
begin
    cmdScript := execCmdScript (lido, true);
end;

{--------------------------------------------------------}
{                executa todo script
{--------------------------------------------------------}

function executaComandos (rotulo: string;
        var ultLinhaProc: integer; var linhaProc: string): integer;
var
    lido: string;
begin
    linhaAtual := 0;
    erroProc := false;
    fimScript := false;
    cmd := '';
    topoRetorno := 0;
    statusUltIO := 0;

    pilhaEnquanto.Clear;
    pilhaRepete.Clear;

    if (rotulo <> '') and (not buscaRotulo (rotulo)) then
        result := SCR_ROTULOINVALIDO
    else
        begin
            while (linhaAtual < script.Count) and (not fimScript) and
                  (not erroProc) do
                begin
                    lido := script[linhaAtual];
                    execCmdScript (lido, false);
                    if (not fimScript) and (not erroProc) then
                        linhaAtual := linhaAtual + 1;
                end;

            if erroProc then
                result := SCR_ERROEXEC
            else
                result := SCR_OK;
        end;

    ultLinhaProc := linhaAtual;
    if linhaAtual < script.count then
        linhaProc := script[linhaAtual]
    else
        linhaProc := '';
    liberaScript;
end;

{--------------------------------------------------------}
{                executa script em arquivo
{--------------------------------------------------------}

function executaScript (nomeArq, rotulo: string;
        var ultLinhaProc: integer; var linhaProc: string): integer;
begin
    if not carregaScript (nomeArq) then
        begin
            executaScript := SCR_SEMARQUIVO;
            exit;
        end;

    result := executaComandos (rotulo, ultLinhaProc, linhaProc);
end;

{--------------------------------------------------------}
{                executa script em memória
{--------------------------------------------------------}

function executaScriptList (scriptOriginal: TStringList; rotulo: string;
        var ultLinhaProc: integer; var linhaProc: string): integer;
var
    i: integer;

begin
    script.Assign(scriptOriginal);
    for i := 0 to script.count-1 do
        script[i] := trim(script[i]);

    result := executaComandos (rotulo, ultLinhaProc, linhaProc);
end;

{--------------------------------------------------------}
{                executa todo script
{--------------------------------------------------------}

function executaScriptControlador (nomeArq: string; rotina: RotinaExterna;
        var ultLinhaProc: integer; var linhaProc: string): integer;
begin
    rotinaExternaPtr := rotina;
    executaScriptControlador := executaScript (nomeArq, '', ultLinhaProc, linhaProc);
    rotinaExternaPtr := NIL;
end;

{--------------------------------------------------------}
{              zera as variáveis do script
{      Atenção: carregar e executar script não zeram,
{        isso só ocorre na inicialização do módulo
{--------------------------------------------------------}

procedure zeraVarScript;
var c: char;
    ano0, mes0, dia0: word;
    hora0, minuto0, segundo0, cent0: word;
    {$IFDEF VER150}
    date_and_time: TDateTime;
    {$ENDIF}

begin
    linhaAtual := 0;
    erroProc := false;
    fimScript := false;
    cmd := '';
    topoRetorno := 0;
    statusUltIO := 0;
    rotinaExternaPtr := NIL;

    nomeVarLonga.Clear;

    for c := '0' to '9' do
        arquivo[c].aberto := false;

    for c := 'A' to chr(ord('Z') + 101) do
        begin
            varScript[c] := '';
            listaScript[c] := NIL;
        end;

    fimScript := true;
    delay (1);   { estabilizador de processamento virtual }

    {$IFDEF VER150}
        date_and_time := now;
        decodeDate (date_and_time, ano0, mes0, dia0);
        decodeTime (date_and_time, hora0, minuto0, segundo0, cent0);
        semana0 := dayOfTheWeek (date_and_time);
    {$ELSE}
        getDate(ano0, mes0, dia0, semana0);
        gettime (hora0, minuto0, segundo0, cent0);
    {$ENDIF}
    tempo0 := ((hora0*60+minuto0)*60+segundo0)*100+cent0;

    pilhaEnquanto:= TPilha.Create;
    pilhaRepete := TPilha.Create;
end;

begin
    script := TStringList.Create;
    nomeVarLonga := TStringList.Create;
    zeraVarScript;
    execCmdScript ('seja $VERSAO ' + VERSAO_DVSCRIPT, true);
end.

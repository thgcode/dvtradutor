unit dvdic;

interface
   uses sysUtils, classes;

const
   dicVogal = ['A' , 'E' , 'I' , 'O' , 'U', 'a' , 'e' , 'i' , 'o' , 'u',
               'Á' , 'É' , 'Í' , 'Ó' , 'Ú', 'á' , 'é' , 'í' , 'ó' , 'ú',
               'Â' , 'Ê' , 'Ô' , 'â' , 'ê' , 'ô' ,
               'À' , 'à' ,
               'Ã' , 'Õ' , 'ã' , 'õ', 
               'ü', 'Ü',
	       'è',  'ì', 'ò', 'ù', 'î', 'û',   // para alguns estrangeirismos
	       'È',  'Ì', 'Ò', 'Ù', 'Î', 'Û',
               '-', ''''
	      ];

   dicConsoante = [ 'b'..'d','f'..'h','j'..'n','p'..'t','v'..'z', 'ç', 'ñ',
                  'B'..'D','F'..'H','J'..'N','P'..'T','V'..'Z', 'Ç', 'Ñ' ];

   dicNumeros = ['0', '1', '2', '3', '4', '5', '6', '7' , '8' , '9'];

   dicAlfabeto = dicVogal + dicConsoante;

function carregaDic (nomeArqDic, nomeArqSufixos, nomeArqInexist,
                     nomeArqNomes, nomeArqSugTroca: string): integer;
function procuraDic (palavra: string): boolean;
procedure fechaDic;
procedure geraAlternativasDic (s: string; ind: integer; lista: TStringList);

implementation

type
    TDicio = class
        prefixo, sufixo: string;
        constructor Create (s, s2: string);
    end;

    TDicList = class (Tlist)
        function Find(const S: string; var Index: Integer): Boolean; virtual;
    end;

var
    listaSufixos: TStringList;
    listaDic: TDicList;
    listaInexist: TStringList;
    listaNomes: TStringList;
    palOrig, palTroca: TStringList;

{----------------------------------------------------------------}
{                  rotinas relativas ao dicionário
{----------------------------------------------------------------}

constructor TDicio.Create (s, s2: string);
begin
    prefixo := s;
    sufixo := s2;
end;

{----------------------------------------------------------------}

function TDicList.Find(const S: string; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
  d: TDicio;
begin
  Result := False;
  L := 0;
  H := Count - 1;
  while L <= H do
  begin
    I := (L + H) div 2;
    d := items[i];
    C := AnsiCompareText(d.prefixo, S);
    if C < 0 then
        L := I + 1
    else
        begin
            H := I - 1;
            if C = 0 then
                begin
                  Result := True;
                  L := I;
                end;
        end;
  end;
  Index := L;
end;

{----------------------------------------------------------------}

function CompareNames(Item1, Item2: Pointer): Integer;
var d1, d2: TDicio;
begin
    d1 := item1;
    d2 := item2;
    Result := AnsiCompareText(d1.prefixo, d2.prefixo);
end;

{----------------------------------------------------------------}
{                  carrega a tabela de sufixos
{----------------------------------------------------------------}

function carregaListaSufixos (nomeArqSufixos: string): boolean;
var arqSufixos: text;
    s, chave: string;
    sufixos: TStringList;
begin
    carregaListaSufixos := false;
    listaSufixos := TStringList.Create;

    assign (arqSufixos, nomeArqSufixos);
    {$I-}  reset (arqSufixos);  {$I+}
    if ioresult <> 0 then
        exit;

    chave := '';
    sufixos := NIL;
    while not eof (arqSufixos) do
        begin
            readln (arqSufixos, s);
            s := trim (s);
            if s = '' then continue;
            if s[1] = '*' then continue;

            if s[1] = '[' then
                begin
                    if chave <> '' then
                        begin
                            sufixos.sort;    // ****
                            listaSufixos.addObject (chave, sufixos);
                        end;

                    sufixos := TStringList.Create;
                    chave := copy (s, 2, 999);
                    if chave [length(chave)] = ']' then
                        delete (chave, length(chave), 1);
                    trim (chave);
                end
            else
                sufixos.Add(s);
        end;

    if chave <> '' then
        listaSufixos.addObject (chave, sufixos);

    listaSufixos.sort;    //****

    close (arqSufixos);
    carregaListaSufixos := true;
end;

{----------------------------------------------------------------}
{                 carrega a tabela do dicionário
{----------------------------------------------------------------}

function carregaListaDic (nomeArqDic: string): boolean;
var arqDic: text;
    s, s2: string;
    fimpal: integer;
begin
    carregaListaDic := false;
    listaDic := TDicList.Create;

    assign (arqDic, nomeArqDic);
    {$I-}  reset (arqDic);  {$I+}
    if ioresult <> 0 then
        exit;

    while not eof (arqDic) do
        begin
            readln (arqDic, s);
            s := trim (s);
            if s = '' then continue;
            if s[1] = '*' then continue;

            fimpal := pos (' ', s);
            if fimpal = 0 then
                s2 := '='
            else
                begin
                    s2 := copy (s, fimpal+1, 999);
                    trim (s2);
                    s := copy (s, 1, fimpal-1);
                end;

            listaDic.add (TDicio.Create (s, s2));
        end;

    listaDic.Sort(@compareNames);   //****

    close (arqDic);
    carregaListaDic := true;
end;

{----------------------------------------------------------------}
{     carrega a tabela de palavras inexistentes (excessões)
{----------------------------------------------------------------}

function carregaLista (var novaLista: TStringList; nomeArqInexist: string;
                maiuscDifMinusc: boolean): boolean;
var arqInexist: text;
    s: string;
begin
    carregaLista := false;
    novaLista := TStringList.Create;
    novaLista.CaseSensitive := maiuscDifMinusc;

    assign (arqInexist, nomeArqInexist);
    {$I-}  reset (arqInexist);  {$I+}
    if ioresult <> 0 then
        exit;

    while not eof (arqInexist) do
        begin
            readln (arqInexist, s);
            trim (s);
            if s = '' then continue;
            if s[1] = '*' then continue;
            novaLista.add (s);
        end;

    novaLista.sort;   //****

    close (arqInexist);
    carregaLista := true;
end;

{----------------------------------------------------------------}
{                  carrega sugestões de troca
{----------------------------------------------------------------}

function carregaSugTrocaDic (nomeSug: string): boolean;
var
    arqTrocas: textFile;
    p: integer;
    s: string;
begin
    carregaSugTrocaDic := false;

    palOrig := TStringList.Create;
    palTroca := TStringList.Create;

    assign (arqTrocas, nomeSug);
    {$I-} reset (arqTrocas);  {$I+}
    if ioresult <> 0 then
         exit;

    while not eof (arqTrocas) do
        begin
            readln (arqTrocas, s);
            if s = '' then continue;
            p := pos ('=', s);
            if p < 2 then
                begin
                    Writeln (^g^g, 'Linha errada no arquivo ' + nomeSug + ': ' +  s);
                    exit;
                end;

            palOrig.add  (trim (copy (s, 1, p-1)));
            palTroca.add (trim (copy (s, p+1, 99)));
        end;

    closeFile (arqTrocas);
    carregaSugTrocaDic := true;
end;

{----------------------------------------------------------------}
{                      carrega o dicionário
{----------------------------------------------------------------}

function carregaDic (nomeArqDic, nomeArqSufixos, nomeArqInexist,
                     nomeArqNomes, nomeArqSugTroca: string): integer;
begin
    listaSufixos := NIL;
    listaDic := NIL;
    listaInexist := NIL;

    if not carregaListaSufixos (nomeArqSufixos) then
        carregaDic := 2
    else
    if not carregaListaDic (nomeArqDic) then
        carregaDic := 1
    else
    if not carregaLista (listaInexist, nomeArqInexist, false) then
        carregaDic := 3
    else
    if not carregaLista (listaNomes, nomeArqNomes, true) then
        carregaDic := 4
    else
    if not carregaSugTrocaDic(nomeArqSugTroca) then
        carregaDic := 5
    else
        carregaDic := 0;
end;

{----------------------------------------------------------------}
{                   fecha o dicionário
{----------------------------------------------------------------}

procedure fechaDic;
var i: integer;
    sufixos: TStringList;
    d: TDicio;
begin
    if listaSufixos <> NIL then
         begin
             for i := 0 to listaSufixos.count-1 do
                  begin
                      sufixos := (listaSufixos.objects[i]) as TStringList;
                      sufixos.free;
                  end;
             listaSufixos.free;
         end;

    if listaDic <> NIL then
         begin
             for i := 0 to listaDic.count-1 do
                 begin
                     d := listaDic[i];
                     d.Free;
                 end;
             listaDic.free;
         end;

    if listaInexist  <> NIL then
        listaInexist.free;
end;

{----------------------------------------------------------------}
{                   procura palavra no dicionário
{----------------------------------------------------------------}

function procuraDic (palavra: string): boolean;
var
    i, posPal: integer;
    fimBusca, achouPrefixo: boolean;
    prefixoPalavra: string;
    d: TDicio;
    listaPalavras: TStringList;


    function criaListaPalavras (d: TDicio): TStringList;
    var
        sl, sufixos: TStringList;
        p, posListaSuf, isuf: integer;
        s, suf: string;
    begin
        sl := TStringList.Create;
        s := d.sufixo;
        while s <> '' do
            begin
                p := pos (' ', s);
                if p = 0 then p := length (s) + 1;
                suf := copy (s, 1, p-1);
                if suf = '=' then
                    sl.add (d.prefixo)
                else
                    begin
                        if not listaSufixos.find (suf, posListaSuf) then
                            writeln ('problemas no dicionário: ', suf, ' prefixo: ', d.prefixo)
                        else
                            begin
                                sufixos := (listaSufixos.objects[posListaSuf]) as TStringList;
                                for isuf := 0 to sufixos.count-1 do
                                    sl.add (d.prefixo+sufixos[isuf]);
                            end;
                    end;

                delete (s, 1, p);
                while (s <> '') and (s[1] = ' ') do delete (s, 1, 1);  // por precaução
            end;

        criaListaPalavras := sl;
    end;

begin
   procuraDic := false;
   prefixoPalavra := palavra;

   if listaNomes.find (palavra, i) then
       begin
            procuraDic := true;
            exit;
       end;

   fimBusca := listaInexist.find (palavra, i);
   while not fimBusca do
       begin
           achouPrefixo := listaDic.Find(prefixoPalavra, posPal);
           if achouPrefixo then
                begin
                    d := listaDic[posPal];
                    listaPalavras := criaListaPalavras (d);
                    for i := 0 to listaPalavras.count-1 do
                        begin
                            if AnsiCompareText (listaPalavras[i], palavra) = 0 then
                                begin
                                    fimBusca := true;
                                    procuraDic := true;
                                    break;
                                end;
                        end;

                    listaPalavras.free;
                end;

           if not fimBusca then
               begin
                   delete (prefixoPalavra, length(prefixoPalavra), 1);
                   fimBusca := length (prefixoPalavra) = 0;
               end;
        end;
end;

{----------------------------------------------------------------}
{                  transforma string em maiúsculas
{----------------------------------------------------------------}

function maiuscAnsi (s: string): string;
var x: string;
    i: integer;
begin
    x := s;
    for i:= 1 to length (s) do
        if x[i] in ['a'..'z'] then
            x[i] := upcase (x[i])
        else
            if x[i] in [#$e0..#$ff] then
                x[i] := chr (ord(x[i]) - $20);
    maiuscAnsi := x;
end;

{----------------------------------------------------------------}
{                    gera as alternativas
{----------------------------------------------------------------}

procedure geraAlternativasDic (s: string; ind: integer; lista: TStringList);
var prefixo, pesquisa, chute: string;
    i, t, nc: integer;

begin
    if not procuraDic (s) then
        begin
            chute := maiuscAnsi (s);
            if procuraDic(chute) then
                lista.Add(chute);
        end
    else
        lista.Add(s);

    if s[1] in dicVogal then
        begin
            prefixo := maiuscAnsi (s);
            chute := prefixo[1] + copy (s, 2, 99);
            if procuraDic(chute) then
                lista.Add(chute);

            chute := 'h' + s;
            if procuraDic(chute) then
                lista.Add(chute);
        end;

    for i := ind to length (s) do
        begin
            prefixo := copy (s, 1, i-1);
            pesquisa := copy (s, i, 99);
            for t := 0 to palOrig.count-1 do
                    begin
                        nc := length (palOrig[t]);
                        if copy (pesquisa, 1, nc) = palOrig[t] then
                            begin
                                chute := pesquisa;
                                delete (chute, 1, nc);
                                insert (palTroca[t], chute, 1);
                                insert (prefixo, chute, 1);
                                if procuraDic(chute) then
                                    lista.Add(chute);
                            end;
                end;
        end;
end;

end.


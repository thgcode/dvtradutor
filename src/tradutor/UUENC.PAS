{--------------------------------------------------------}
{
{     Realiza uuencode ou uudecode de um arquivo
{
{     Autor: José Antonio Borges
{
{     Em Abril/95
{
{     Baseado no programa Simtel de Toad Hall
{
{--------------------------------------------------------}

unit uuenc;

interface
Uses dvcrt;

const
    OK = 0;
    NOT_FOUND = 1;
    READ_ERROR = 2;
    WRITE_ERROR = 3;
    INVALID_FORMAT = 4;
    INCOMPL_FILE = 5;

function uuencode (narqin, narqout: string): integer;
function uudecode (nomearq: string): integer;

implementation

{--------------------------------------------------------}
{                   modulo de uuencode
{--------------------------------------------------------}

function uuencode (narqin, narqout: string): integer;

const
    OFFSET = 32;
    CHARSPERLINE = 60;
    BYTESPERHUNK = 3;
    SIXBITMASK = $3F;

    Header = 'begin';
    Trailer = 'end';
    DefaultMode = '644';
    DefaultExtension = '.uue';

var
    Infile: file of byte;
    Outfile: text;
    lineLength, numbytes, bytesInLine: integer;

    Line: ARRAY [0..59] OF char;
    hunk: ARRAY [0..2] OF byte;
    chars: ARRAY [0..3] OF Byte;
    erroUue: integer;

{--------------------------------------------------------}
{                  inicializacao
{--------------------------------------------------------}

procedure inicializa (narqin, narqout: string);
begin
    assign (Infile, narqin);
    {$i-}  reset (inFile);  {$i+}
    if ioresult <> 0 then
         begin
             erroUue := NOT_FOUND;
             exit;
         end;

    assign (Outfile, narqout);
    {$i-}  rewrite (outFile);  {$i+}
    if ioresult <> 0 then
         begin
             erroUue := WRITE_ERROR;
             exit;
         end;

    bytesInLine := 0;
    lineLength := 0;
    numbytes := 0;

    {$i-}  writeln (Outfile, Header, ' ', DefaultMode, ' ', narqin);  {$i+}
    if ioresult <> 0 then
        erroUue := WRITE_ERROR;
end;

{--------------------------------------------------------}
{                   completa uma linha
{--------------------------------------------------------}

procedure FlushLine;

    {--------------------------------------------------------}
        procedure writeOut (c: char);
        begin
            {$i-}
            if c = ' ' then
                write (Outfile, '`')
            else
                write (Outfile, c);
            {$i+}
            if ioresult <> 0 then
                erroUue := WRITE_ERROR;
        end;
    {--------------------------------------------------------}

var i: integer;

begin
    WriteOut (chr (bytesInLine + OFFSET));

    for i := 0 to lineLength-1 DO
        writeOut (line[i]);

    writeOut (#$0d);
    writeOut (#$0a);

    lineLength := 0;
    bytesInLine := 0
end;

{--------------------------------------------------------}
{                completa um "hunk"
{--------------------------------------------------------}

procedure FlushHunk;
var i: integer;
begin
    if lineLength = CHARSPERLINE then
        FlushLine;

    chars[0] := hunk[0] shr 2;
    chars[1] := ((hunk[0] shl 4) and $f0) + (hunk[1] shr 4);     {***}
    chars[2] := ((hunk[1] shl 2) and $fc) + (hunk[2] shr 6);
    chars[3] := hunk[2] and SIXBITMASK;

    for i := 0 TO 3 do
        begin
            Line[lineLength] := chr((chars[i] and SIXBITMASK) + OFFSET);
            Inc(lineLength);
        end;

    Inc (bytesInLine,numbytes);
    numbytes := 0
end;

{--------------------------------------------------------}
{                    termina execucao
{--------------------------------------------------------}

procedure finaliza;
begin
    IF numbytes > 0 then
        FlushHunk;

    IF lineLength > 0 then
        begin
            FlushLine;
            FlushLine;
        end
    else
        FlushLine;

    {$i-} writeln (Outfile, Trailer); {$I+}
    if ioresult <> 0 then erroUue := WRITE_ERROR;
    {$i-} close (Outfile);  {$I+}
    if ioresult <> 0 then erroUue := WRITE_ERROR;
    {$i-} close (Infile); {$I+}
    if ioresult <> 0 then erroUue := READ_ERROR;
end;

{--------------------------------------------------------}
{                   realiza o uuencode
{--------------------------------------------------------}

begin
    erroUue := 0;

    inicializa (narqin, narqout);

    while (erroUue = 0) and (not eof(Infile)) do
        begin
            if numbytes = BYTESPERHUNK then
                FlushHunk;

            {$i-} read (Infile, hunk[numbytes]); {$i+}
            if ioresult <> 0 then erroUue := READ_ERROR;

            Inc (numbytes);
        end;

    if erroUue <> NOT_FOUND then
        finaliza;

    uuencode := erroUue;
end;

{--------------------------------------------------------}
{                  modulo uudecode
{--------------------------------------------------------}

function uudecode (nomearq: string): integer;

const
    DefaultSuffix = '.uue';
    OFFSET = 32;

var
    Infile: text;
    Outfile: file of Byte;
    Line: string;
    errorType: integer;

{--------------------------------------------------------}
{               abre arquivo de entrada
{--------------------------------------------------------}

procedure GetInFile (Infilename: string);
begin
    if pos ('.', Infilename) = 0 then
        Infilename := Infilename + DefaultSuffix;

    assign (Infile, Infilename);
    {$I-} reset (Infile); {$i+}
    if ioResult > 0 then
         errorType := NOT_FOUND;
end;

{--------------------------------------------------------}
{               abre arquivo de saida
{--------------------------------------------------------}

procedure GetOutFile;
var
    Header, Mode, Outfilename: string;
    index: integer;

{--------------------------------------------------------}

    procedure NextWord(var Word: string; var index: integer);
    begin
        Word := '';
        while Header[index] = ' ' do
            begin
                Inc(index);
                if index > length(Header) then 
                    exit;
            end;

        while Header[index] <> ' ' do
            begin
                Word := Word + Header[index];
                Inc(index);
            end;
    end;

{--------------------------------------------------------}

    function ParseHeader: boolean;
    begin
        Header := Header + ' ';
        index := 7;
        NextWord (Mode, index);
        NextWord (Outfilename, index);
        parseHeader := Outfilename <> '';
    end;

{--------------------------------------------------------}

label error;
begin  { GetOutFile }

    {$I-} readln (Infile, Header); {$i+}
    if ioresult <> 0 then goto error;

    while not (copy(Header, 1, 6) = 'begin ') do
        begin
            {$I-} readln (Infile, Header); {$I+}
            if ioresult <> 0 then goto error;
        end;

    if not ParseHeader then goto error;

    assign (Outfile, Outfilename);
    {$I-} rewrite (Outfile); {$I+}
    if ioresult <> 0 then
        begin
            errorType := WRITE_ERROR;
            exit;
        end;

    exit;

error:
    errorType := INVALID_FORMAT;
end;

{--------------------------------------------------------}
{                     decodifica uma linha
{--------------------------------------------------------}

procedure DecodeLine;
var
    lineIndex, byteNum, count, i: integer;
    chars: ARRAY [0..3] of Byte;
    hunk: ARRAY [0..2] of Byte;

{--------------------------------------------------------}

    function Next_Ch: char;
    begin
        Inc(lineIndex);
        if (lineIndex > length(Line)) or
           (not (Line[lineindex] IN [' '..'`'])) then
                begin
                    Next_Ch := ' ';
                    errorType := INVALID_FORMAT;
                    exit;
                end;

        if Line[lineIndex] = '`' then Next_Ch := ' '
                                 else Next_Ch := Line[lineIndex]
    end;

{--------------------------------------------------------}

    procedure GetNextHunk;
    var i: integer;
    begin
        for i := 0 to 3 do
            chars[i] := ord(Next_Ch) - OFFSET;
        hunk[0] := ((chars[0] ShL 2) and $fc) + (chars[1] ShR 4);   {***}
        hunk[1] := ((chars[1] ShL 4) and $f0) + (chars[2] ShR 2);
        hunk[2] := ((chars[2] ShL 6) and $c0) + chars[3];
        byteNum := 0;
    end;

{--------------------------------------------------------}

    procedure DecodeByte;
    begin
        if byteNum = 3 then
             GetNextHunk;
        write (Outfile, hunk[byteNum]);
        Inc (byteNum)
    end;

{--------------------------------------------------------}

begin  { decodeLine }
    lineIndex := 0;
    byteNum := 3;

    if (length(Line) = 0) then
        begin
            errorType := INVALID_FORMAT;
            exit;
        end;

    count := (ord(Next_Ch) - OFFSET);
    for i := 1 to count do
        DecodeByte;
end;

{--------------------------------------------------------}
{                   termina o processamento
{--------------------------------------------------------}

procedure Terminate;
var Trailer: string;
begin
    if eof(Infile) then 
        begin
            errorType := INCOMPL_FILE;
            exit;
        end;

    {$I-} readln (Infile, trailer); {$I+}
    if (ioresult <> 0) or 
       (length (trailer) < 3) or 
       (copy (trailer, 1, 3) <> 'end') then
            begin
                errorType := INCOMPL_FILE;
                exit;
            end;
end;

{--------------------------------------------------------}
{                     decodifica arquivo
{--------------------------------------------------------}

var validLine: boolean;
label fim;

begin
    errorType := OK;
    GetInFile (nomearq);
    if errorType <> 0 then  goto fim;
    GetOutFile;
    if errorType <> 0 then  goto fim;

    repeat
        {$I-} readln (Infile, Line); {$I+}
        if ioresult <> 0 then  goto fim;

        validLine := (line <> '') and (not (Line[1] IN [' ', '`']));
        if validLine and (errorType = 0) then
            DecodeLine;

    until not validLine;

    Terminate;

fim:
    uudecode := errorType;

    {$I-} close (Infile);  {$I+}
    if ioresult <> 0 then;
    {$I-} close (Outfile); {$I+}
    if (ioresult <> 0) and (errorType = 0) then
        errorType := WRITE_ERROR;
end;

end.

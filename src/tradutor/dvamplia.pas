{--------------------------------------------------------}
{
{    Autores:
{
{       José Antônio Borges
{       Júlio Tadeu Carvalho da Silveira
{
{    Em 14/11/2015
{
{--------------------------------------------------------}

unit dvAmplia;

interface

uses
    dvCrt,
    Windows,
    math;

procedure amplInic (ydest, fator: integer);
procedure amplCores (corLetra, corFundo, corLetraCursor: integer);
procedure amplEsconde;
procedure amplFim;

procedure amplCampo (campo: string; colCursor: integer);
function amplFator: integer;
procedure amplPegaConfig (var fator: integer;
                          var corLetra, corFundo, corCursor: integer);

implementation

var
    fontAmpl: HFont = 0;
    fatorAmpl: integer;
    corLetraAmpl, corFundoAmpl, corCursorAmpl: integer;

    yDestAmpl: integer;
    xInicAmpl: integer;
    amplDesloc: integer;

procedure amplInic (ydest, fator: integer);
var
    chset: integer;
begin
    if fator = 0 then
        begin
            fontAmpl := 0;
            exit;
        end;

    yDestAmpl := ydest;
    fatorAmpl := fator;
    xInicAmpl := 0;
    chset := ANSI_CHARSET;
    if selectOEMFont then chset := OEM_CHARSET;

    fontAmpl := CreateFont (dvcrt.fontHeight*fator, dvcrt.fontWidth*fator,
		  0, 0, dvcrt.fontWeight,
          0, 0, 0, chset, 0, 0, 0, DEFAULT_PITCH, pchar(dvcrt.fontName));

    amplCores (corLetraAmpl, corFundoAmpl, corCursorAmpl);
    amplDesloc := 1;
end;

procedure amplEsconde;
var lpRect: TRect;
begin
   GetWindowRect(crtWindow, lpRect);
   invalidateRect (crtWindow, @lpRect, false);
end;

procedure amplFim;
begin
    if fontAmpl <> 0 then
        DeleteObject(fontAmpl);
    amplEsconde;
    fontAmpl := 0;
    fatorAmpl := 0;
end;

procedure amplCores (corLetra, corFundo, corLetraCursor: integer);
begin
    corLetraAmpl := corLetra;
    corFundoAmpl := corFundo;
    corCursorAmpl:= corLetraCursor;
end;

var
    filler: string[80] = '                    ' + '                    ' +
                         '                    ' + '                    ';

procedure amplCampo (campo: string; colCursor: integer);
var dc: HDC;
    oldFont: HFont;
    oldBack, oldColor: TCOLORREF;
    oldAlign: UINT;
    esq, meio, dir: string[80];
    y: integer;
    campoVis: string[80];
begin
    if fontAmpl = 0 then
        exit;

    if colcursor < 1 then colCursor := 1;

    if amplDesloc > colCursor-1 then
        amplDesloc := colCursor-1;
    if amplDesloc < 1 then
        amplDesloc := 1;
    if amplDesloc + (80 div fatorAmpl) < colcursor  then
        amplDesloc := colCursor - (80 div fatorAmpl);

    campoVis := copy (campo, amplDesloc, 80 div fatorAmpl);
    colCursor := colCursor - amplDesloc + 1;

    if colCursor = 0 then
        begin
            esq := '';
            meio := '';
            dir := copy(campoVis+filler, 1, 80 div fatorAmpl);
        end
    else
        begin
            esq := '';
            if colCursor > 2 then
                esq := copy (campoVis, 1, colCursor-2);
            meio := '';
            if colCursor > 1 then
                meio := copy (campoVis, colCursor-1, 1);
            dir := copy (campoVis+filler, colCursor, 80 div fatorAmpl);
        end;

    y := (yDestAmpl-1) * dvcrt.CharSize.y;

    dc := GetDC(crtWindow);
    oldFont := SelectObject (dc, fontAmpl);
    oldBack := setBkColor (dc, colorNumber (corFundoAmpl));
    oldColor := SetTextColor(dc, colorNumber (corLetraAmpl));
    oldAlign := getTextAlign (dc);

    setTextAlign (dc, TA_TOP+TA_LEFT);
    TextOut(dc, 0, y, @esq[1], length(esq));
    SetTextColor(dc, colorNumber (corCursorAmpl));
    TextOut(dc, dvcrt.CharSize.x*length(esq)*fatorAmpl, y, @meio[1], length(meio));
    SetTextColor(dc, colorNumber (corLetraAmpl));
    TextOut(dc, dvcrt.CharSize.x*length(esq+meio)*fatorAmpl, y, @dir[1], length(dir));

    setBkColor (dc, oldBack);
    SetTextColor(dc, oldColor);
    setTextAlign (dc, oldAlign);
    SelectObject (dc, oldFont);
    releaseDC (crtWindow, dc);
end;

procedure amplPegaConfig (var fator: integer;
                          var corLetra, corFundo, corCursor: integer);
begin
    fator := fatorAmpl;
    corLetra:= corLetraAmpl;
    corFundo := corFundoAmpl;
    corCursor := corCursorAmpl;
end;

function amplFator: integer;
begin
    result := fatorAmpl;
end;

end.

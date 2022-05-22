{*******************************************************}
{                                                       }
{       Dosvox CRT emulation procedures                 }
{       By Jose' Antonio Borges                         }
{       January/1998                                    }
{       Copyright (c) 1998 - NCE/UFRJ                   }
{                                                       }
{       Based on the                                    }
{       Turbo Pascal Runtime Library                    }
{       Windows CRT Interface Unit                      }
{       Copyright (c) 1991,92 Borland International     }
{                                                       }
{*******************************************************}

unit DvCrt;

interface

uses Windows, Messages, SysUtils, mmSystem, minireg;

var
  WindowOrg: TPoint =                       { CRT window origin }
    (X: longint(cw_UseDefault);
     Y: longint(cw_UseDefault));
  WindowSize: TPoint =                      { CRT window size }
    (X: 648; Y: 480);
  ScreenSize: TPoint = (X: 80; Y: 25);      { Screen buffer dimensions }
  Cursor: TPoint = (X: 0; Y: 0);            { Cursor location }
  InactiveTitle: PChar = 'Programa terminado';
                                            { Inactive window title }
  CheckEOF: Boolean = False;                { Allow Ctrl-Z for EOF? }
  CheckBreak: Boolean = True;               { Allow Ctrl-C for break? }
  CheckFocus: Boolean = False;                        { Generate keyboard char on focus? }
  SelectOEMFont: Boolean = False;           { Use OEM or System font }
  ForceDefaultFont: Boolean = False;        { Force use of default font }
  invertColorMask: dword;                   { para inversão de cores }

var
{ Interface variables }

  CrtWindow: HWnd;        { CRT window handle }
  LastMode: Word;         { Current text mode }
  TextAttr: Byte;         { Current text attribute }
  WindowDefMode: longint; { Default Window Creation Mode }

var
  WindowTitle: array[0..79] of Char;        { CRT window title }

procedure InitWinCrt;
procedure DoneWinCrt;
procedure AssignCrt(var F: Text);

procedure WriteBuf(Buffer: PChar; Count: Word);
procedure WriteChar(Ch: Char);

procedure processCrtWindowQueue;
procedure processWindowsQueue;
function KeyPressed: Boolean;
function ReadKey: Char;
function ReadBuf(Buffer: PChar; Count: Word): Word;

procedure GotoXY(X, Y: Integer);
function WhereX: Integer;
function WhereY: Integer;
procedure ClrScr;
procedure ClrEol;

procedure InsLine;
procedure DelLine;

procedure TextColor(Color: Byte);
procedure TextBackground(Color: Byte);
procedure LowVideo;
procedure HighVideo;
procedure NormVideo;

procedure Delay(MS: Word);

procedure Sound (Hz: Word);
procedure NoSound;
procedure SpeakerSound (Hz: Word);
procedure SpeakerNoSound;

procedure Window (X1,Y1,X2,Y2: Byte);
procedure TextMode(Mode: Integer);

function  putClipBoard (data: PChar; size : integer) : boolean; overload;
procedure putClipBoard (data: PChar); overload;
procedure getClipBoard (data: PChar; maxSize: integer); overload;
function  getClipBoard (maxSize: integer) : PChar; overload;

procedure ForceCursor;
procedure unForceCursor;

function getScreenChar (x, y: integer): char;
function getScreenAttrib (x, y: integer): byte;
procedure canChangeColors (canChange: boolean);

procedure brailleChangeMode (newMode: integer);
function colorNumber (n: byte): TColorRef;

procedure getDate (var a, m, d, w: word);
procedure getTime (var h, m, s, cent: word);

procedure lookupKeyBuf (var c, c2: char);
procedure insertKeyBuf (Ch: char);

function openBMP (filename: string): Boolean;
procedure paintBMP (x, y: integer);
procedure freeBMP;
procedure closeBMP;

procedure setWindowTitle (title: string);

function dosvoxIniDir: string;

var
  hasAlternateWinProc: boolean;
  alternateWinProc: procedure (Window: HWnd; Message: UINT;
                               WParam: WPARAM; LParam: LPARAM;
                               var resultx: LRESULT);
  hasmmCallback: boolean;
  mmCallback: procedure (Window: HWnd; WParam: WPARAM; LParam: LPARAM);
  hasMCICallback: boolean;
  MCICallback: procedure (Window: HWnd; WParam: WPARAM; LParam: LPARAM);
  hasCopyDataCallback: boolean;
  CopyDataCallback: procedure (Window: HWnd; WParam: WPARAM; LParam: LPARAM);

  brailleKbdMsg: integer;
  hasBrailleKbdCallback: boolean;
  brailleKbdCallback: procedure (Window: HWnd; WParam: WPARAM; LParam: LPARAM;
                                 var key1, key2: char);

  currentWindow: TRect;                 { Active window box }
  maximize: boolean;                    { Window is created in maximize state }
  videoIsSlow: boolean;                 { Scrolling is faster than redrawing }
  textRefreshInhibited: boolean;        { disable paint event text drawing }

  colorArrange: array [0..15] of byte;  { Color mapping }

  BMPHandle: HBitmap;                   { Support for 1 bitmap }
  BMPx, BMPy,                           { Bitmap location }
  BMPwidth, BMPheight: integer;
  BMPScale: real;                       { escala de exibição }

  fontHandle: HFont;                    { font definition }
  fontName: string = '';
  fontHeight: integer = 0;
  fontWidth: integer = 0;
  fontWeight: integer = 0;
  CharAscent: Integer;                  { Character ascent }

  CharSize: TPoint;               { Character cell size (dynamically calculated}
  leftMargin: integer;            { left margin inposed by some fonts }

const

{ CRT modes }

  BW40          = 0;            { 40x25 B/W on Color Adapter }
  CO40          = 1;            { 40x25 Color on Color Adapter }
  BW80          = 2;            { 80x25 B/W on Color Adapter }
  CO80          = 3;            { 80x25 Color on Color Adapter }

{ Foreground and background color constants }

  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

{ Foreground color constants }

  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

  highIntens = 8;
  defaultAttrib = lightGray;

implementation

uses dvMouse;

{ Double word record }

type
  LongRec = record
    Lo, Hi: Integer;
  end;

{ MinMaxInfo array }

type
  PMinMaxInfo = ^TMinMaxInfo;
  TMinMaxInfo = array[0..4] of TPoint;

{ CRT window procedure }

function CrtWinProc(Window: HWnd; Message: UINT;
                    WParam: WPARAM; LParam: LPARAM): LRESULT;
         stdcall; forward;

{ CRT window class }

var
  CrtClass: TWndClass = (
    style: cs_HRedraw + cs_VRedraw;
    lpfnWndProc: @CrtWinProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'DvWinCrt');

var
  KeyCount: Integer = 0;                { Count of keys in KeyBuffer }
  Created: Boolean = False;                   { CRT window created? }
  Focused: Boolean = False;             { CRT window focused? }
  Reading: Boolean = False;             { Reading from CRT window? }
  Painting: Boolean = False;            { Handling wm_Paint? }
  ForcedCur: Boolean = False;           { Force cursor to appear }

var
  SaveExit: Pointer;                    { Saved exit procedure pointer }
  ScreenBuffer: PChar;                  { Screen buffer pointer }
  AttribBuffer: PChar;                  { Screen attributes buffer pointer }
  DC: HDC;                              { Global device context }
  PS: TPaintStruct;                     { Global paint structure }
  SaveFont: HFont;                      { Saved device context font }
  KeyBuffer: array[0..63] of Char;      { Keyboard type-ahead buffer }
  TimerIsSet: boolean;                  { Time was ellapsed }
  varColors: boolean;                   { Can change screen colors }

{ Braille area }
  brailleMode: integer;                 { Braille typing: 0-no 1-uncoded 2-coded }
  brKeysSet, brKeysNowPressed: byte;
  brInUpcase, brCapsLock, brNumeric: boolean;

{ Sound Area }

const
     soundSize = 11025;
var
     wavHdr: array [0..43] of byte = (
        $52, $49, $46, $46, $ff, $ff, $ff, $ff, $57, $41, $56, $45, $66, $6d, $74, $20,
        $10, $00, $00, $00, $01, $00, $01, $00, $11, $2b, $00, $00, $11, $2b, $00, $00,
        $01, $00, $08, $00, $64, $61, $74, $61, $ff, $ff, $ff, $ff);

type
    tSound = array [0.. sizeof (wavHdr) + soundSize-1] of byte;

var
    pSound: ^tSound;

{ Special keys table }

type SpecialKeyAction = record
         Key: word;
         BasicChar, CtlChar: char;
     end;

const
  SpecialKeysCount = 22;
  SpecialKeys: array[1..SpecialKeysCount] of SpecialKeyAction = (
     (Key: VK_F1;  basicChar: #59;  ctlChar: #94),
     (Key: VK_F2;  basicChar: #60;  ctlChar: #95),
     (Key: VK_F3;  basicChar: #61;  ctlChar: #96),
     (Key: VK_F4;  basicChar: #62;  ctlChar: #97),
     (Key: VK_F5;  basicChar: #63;  ctlChar: #98),
     (Key: VK_F6;  basicChar: #64;  ctlChar: #99),
     (Key: VK_F7;  basicChar: #65;  ctlChar: #100),
     (Key: VK_F8;  basicChar: #66;  ctlChar: #101),
     (Key: VK_F9;  basicChar: #67;  ctlChar: #102),
     (Key: VK_F10; basicChar: #68;  ctlChar: #103),
     (Key: VK_F11; basicChar: #69;  ctlChar: #104),
     (Key: VK_F12; basicChar: #70;  ctlChar: #105),

     (Key: VK_INSERT; basicChar: #82;  ctlChar: #255),
     (Key: VK_DELETE; basicChar: #83;  ctlChar: #83),
     (Key: VK_HOME;   basicChar: #71;  ctlChar: #119),
     (Key: VK_END;    basicChar: #79;  ctlChar: #117),

     (Key: VK_PRIOR; basicChar: #73;  ctlChar: #132),
     (Key: VK_NEXT;  basicChar: #81;  ctlChar: #118),
     (Key: VK_UP;    basicChar: #72;  ctlChar: #113),
     (Key: VK_DOWN;  basicChar: #80;  ctlChar: #114),
     (Key: VK_LEFT;  basicChar: #75;  ctlChar: #115),
     (Key: VK_RIGHT; basicChar: #77;  ctlChar: #116)
  );

{ Return the smaller of two integer values }

function Min(X, Y: Integer): Integer;
begin
  if X < Y then Min := X else Min := Y;
end;

{ Return the larger of two integer values }

function Max(X, Y: Integer): Integer;
begin
  if X > Y then Max := X else Max := Y;
end;

{ Allocate device context }

procedure InitDeviceContext;
begin
  if Painting then
    DC := BeginPaint(CrtWindow, PS)
  else
    DC := GetDC(CrtWindow);
  if fontHandle <> 0 then
    SaveFont := SelectObject(DC, fontHandle)
  else
  if selectOemFont then
    SaveFont := SelectObject(DC, GetStockObject(OEM_Fixed_Font))
  else
    SaveFont := SelectObject(DC, GetStockObject(System_Fixed_Font));
end;

{ Release device context }

procedure DoneDeviceContext;
begin
  SelectObject(DC, SaveFont);
  if Painting then
    EndPaint(CrtWindow, PS)
  else
    ReleaseDC(CrtWindow, DC);
end;

{ Show caret }

procedure ShowCursor;
begin
  CreateCaret(CrtWindow, 0, CharSize.X, 2);
  SetCaretPos((currentWindow.left+Cursor.X) * CharSize.X,
    (currentWindow.top+Cursor.Y) * CharSize.Y + CharAscent);
  ShowCaret(CrtWindow);
end;

{ Hide caret }

procedure HideCursor;
begin
  DestroyCaret;
end;

procedure ForceCursor;
begin
   if not forcedCur then showCursor;
   forcedCur := true;
end;

procedure unForceCursor;
begin
    if forcedCur then HideCursor;
    forcedCur := false;
end;

{ Terminate CRT window }

procedure Terminate;
begin
//  if Focused and Reading then HideCursor;
//  Halt(255);
    doneWinCrt;
end;

{ Set cursor position }

procedure CursorTo(X, Y: Integer);
var w, h: integer;
begin
  with currentWindow do
      begin
        w := right-left;
        h := bottom-top;
      end;
  Cursor.X := Max(0, Min(X, w));
  Cursor.Y := Max(0, Min(Y, h));
end;

{ Return pointer to location in screen buffer }

function ScreenPtr(X, Y: Integer): PChar;
begin
  ScreenPtr := @ScreenBuffer[Y * ScreenSize.X + X];
end;

{ Return pointer to location in attribute buffer }

function AttribPtr(X, Y: Integer): PChar;
begin
  AttribPtr := @AttribBuffer[Y * ScreenSize.X + X];
end;

{ read screen memory }

function getScreenChar (x, y: integer): char;
begin
  with currentWindow do
    getScreenChar := ScreenPtr (Left+x-1, Top+y-1)^;
end;

{ read attributes memory }

function getScreenAttrib (x, y: integer): byte;
begin
  with currentWindow do
    getScreenAttrib := ord(attribPtr(Left+x-1,Top+y-1)^);
end;

{ calculates the color number }

function colorNumber (n: byte): TColorRef;
var c: TColorRef;
begin
  c := 0;
  case colorArrange[n] of
       Black:         c := RGB (0, 0, 0);
       Blue:          c := RGB (0, 0, 255);
       Green:         c := RGB (0, 255, 0);
       Cyan:          c := RGB (0, 255, 255);
       Red:           c := RGB (255, 0, 0);
       Magenta:              c := RGB (142, 0, 142);
       Brown:         c := RGB (68, 34, 34);
       LightGray:     c := RGB (192, 192, 192);
       DarkGray:      c := RGB (40, 40, 40);
       LightBlue:     c := RGB (128, 128, 255);
       LightGreen:    c := RGB (128, 255, 128);
       LightCyan:     c := RGB (128, 255, 255);
       LightRed:      c := RGB (255, 128, 128);
       LightMagenta:  c := RGB (255, 128, 255);
       Yellow:        c := RGB (255, 255, 0);
       White:         c := RGB (255, 255, 255);
  end;
  colorNumber := c xor invertColorMask;
end;

{ Update text on cursor line }

procedure ShowText(L, R: Integer; Y: integer);
var p: PChar;
    nc: integer;
    oldAttr: char;
    LL, attr: byte;
begin
  if L < R then
  begin
    if not painting then
        InitDeviceContext;
    with currentWindow do
      begin
         L := L + left;
         R := R + left;
         Y := Y + top;
      end;
    while L < R do
        begin
            p := attribPtr (L, Y);
            attr := ord(p^);
            LL := L;
            repeat
                oldAttr := p^;
                inc (p);
                LL := LL + 1;
            until (LL >= R) or (oldAttr <> p^);
            nc := LL - L;

            setTextColor (DC, colorNumber (attr and $f));
            setBkColor   (DC, colorNumber (attr shr 4));

            TextOut(DC, L * CharSize.X + leftMargin,
                        Y * CharSize.Y, ScreenPtr(L, Y), nc);
            L := L + nc;
        end;
    if not painting then
        DoneDeviceContext;
  end;
end;

{ Write text buffer to CRT window }

procedure WriteBuf(Buffer: PChar; Count: Word);
var
  L, R: Integer;

procedure NewLine;
var
  oldBrush, newBrush: HBrush;
  w, h, y: integer;
  rect: tRect;
begin
  ShowText(L, R, Cursor.Y);
  L := 0;
  R := 0;
  Inc(Cursor.Y);
  if Cursor.Y = currentWindow.bottom-currentWindow.top+1 then
  begin
    if not painting then
        InitDeviceContext;
    Dec(Cursor.Y);
    with currentWindow do
      begin
        w := right-left+1;
        h := bottom-top+1;

        for y := top to bottom-1 do
          begin
            move (ScreenPtr (left, y+1)^, ScreenPtr (left, y)^, w);
            move (AttribPtr (left, y+1)^, AttribPtr (left, y)^, w);
          end;

        FillChar(ScreenPtr(left, bottom)^, w, ' ');
        FillChar(AttribPtr(left, bottom)^, w, textAttr);

        getWindowRect (crtWindow, rect);
        if videoIsSlow and (getActiveWindow = crtWindow) and
           (rect.bottom < getSystemMetrics (SM_CYSCREEN) - 32) then
            begin
                bitBlt (DC, left*CharSize.X, top*CharSize.Y, w*CharSize.X, (h-1)*CharSize.Y,
                        DC, left*CharSize.X, (top+1)*CharSize.Y, SRCCOPY);

                newBrush := createSolidBrush (colorNumber (textAttr shr 4));
                oldBrush := selectObject (DC, newBrush);
                patBlt (DC, left*CharSize.X, bottom*CharSize.Y,
                            w*CharSize.X, CharSize.Y, PATCOPY);
                selectObject (DC, oldBrush);
                deleteObject (newBrush);
            end
        else
            invalidateRect (crtWindow, NIL, false);
      end;
    if not painting then
      DoneDeviceContext;
    UpdateWindow(CrtWindow);
  end;
end;

begin
  InitWinCrt;
  L := Cursor.X;
  R := Cursor.X;
  while Count > 0 do
  begin
    case Buffer^ of
      #32..#255:
        begin
          with currentWindow do
            begin                        {************* verificar ****************}
              if Cursor.X = (right+1) then
                  begin
                      cursor.X := 0;
                      NewLine;
                  end;
                  ScreenPtr(left+Cursor.X, top+Cursor.Y)^ := Buffer^;
                  AttribPtr(left+Cursor.X, top+Cursor.Y)^ := chr(textAttr);
                  Inc(Cursor.X);
              if Cursor.X > R then R := Cursor.X;
            end;
        end;
      #13:
         cursor.X := 0;
      #10:
        begin
               NewLine;
           cursor.X := 0;
        end;
      #8:
        if Cursor.X > 0 then
          with currentWindow do
              begin
              Dec(Cursor.X);
              ScreenPtr(left+Cursor.X, top+Cursor.Y)^ := ' ';
              AttribPtr(left+Cursor.X, top+Cursor.Y)^ := chr(textAttr);
              if Cursor.X < L then L := Cursor.X;
            end;
      #7:
        MessageBeep(0);
    end;
    Inc(Buffer);
    Dec(Count);
  end;
  ShowText(L, R, Cursor.Y);
end;

{ Write character to CRT window }

procedure WriteChar(Ch: Char);
begin
  WriteBuf(@Ch, 1);
end;

{ Return keyboard status }

procedure processCrtWindowQueue;
var
  M: tagMsg;
begin
  while PeekMessage(M, crtWindow, 0, 0, pm_Remove) do
  begin
    if M.Message = wm_Quit then Terminate;
    TranslateMessage(M);
    DispatchMessage(M);
  end;
end;

procedure processWindowsQueue;
var
  M: tagMsg;
begin
  while PeekMessage(M, 0, 0, 0, pm_Remove) do
  begin
    if M.Message = wm_Quit then Terminate;
    TranslateMessage(M);
    DispatchMessage(M);
  end;
end;

function KeyPressed: Boolean;
begin
  InitWinCrt;
  processWindowsQueue;
  KeyPressed := KeyCount > 0;
end;

{ Read key from CRT window }

function ReadKey: Char;
begin
  if forcedCur then
      begin
          forcedCur := false;
          hideCursor;
      end;

  if not KeyPressed then
  begin
    Reading := True;
    if Focused then ShowCursor;
    repeat WaitMessage until KeyPressed;
    if Focused then HideCursor;
    Reading := False;
  end;
  ReadKey := KeyBuffer[0];
  Dec(KeyCount);
  Move(KeyBuffer[1], KeyBuffer[0], KeyCount);
end;

{ Read text buffer from CRT window }

function ReadBuf(Buffer: PChar; Count: Word): Word;
var
  Ch: Char;
  I: Word;
begin
  I := 0;
  repeat
    Ch := ReadKey;
    case Ch of
      #8:
        if I > 0 then
        begin
          Dec(I);
          WriteChar(#8);
        end;
      #32..#255:
        if I < Count - 2 then
        begin
          Buffer[I] := Ch;
          Inc(I);
          WriteChar(Ch);
        end;
    end;
  until (Ch = #13) or (CheckEOF and (Ch = #26));
  Buffer[I] := Ch;
  Inc(I);
  if Ch = #13 then
  begin
    Buffer[I] := #10;
    Inc(I);
    WriteChar(#13);
    WriteChar(#10);
  end;
  ReadBuf := I;
end;

{ Set cursor position }

procedure GotoXY(X, Y: Integer);
begin
  CursorTo(X - 1, Y - 1);
end;

{ Return cursor X position }

function WhereX: Integer;
begin
  WhereX := Cursor.X + 1;
end;

{ Return cursor Y position }

function WhereY: Integer;
begin
  WhereY := Cursor.Y + 1;
end;

{ Clear screen }

procedure ClrScr;
var y: integer;
begin
  InitWinCrt;
  with currentWindow do
    begin
      for y := top to bottom do
        begin
          fillchar (ScreenPtr (left, y)^, right-left+1, ' ');
          fillchar (AttribPtr (left, y)^, right-left+1, textAttr);
        end;
      end;
  Cursor.X := 0;
  Cursor.Y := 0;
  InvalidateRect(CrtWindow, nil, False);
  UpdateWindow (CrtWindow);
end;

{ Clear to end of line }

procedure ClrEol;
var w: integer;
begin
  InitWinCrt;
  with currentWindow do
      begin
          w := right-left+1;
          fillchar (ScreenPtr (left+Cursor.X, top+Cursor.Y)^, w-Cursor.X, ' ');
          fillchar (AttribPtr (left+Cursor.X, top+Cursor.Y)^, w-Cursor.X, textAttr);
      end;
  ShowText(Cursor.X, ScreenSize.X, Cursor.Y);
end;

{ Line insert }

procedure InsLine;
var y, w, h: integer;
begin
   InitWinCrt;
   with currentWindow do
      begin
          w := right-left+1;
          h := bottom-top+1;
          for y := top+h-2 downto top+Cursor.y do
            begin
              move (ScreenPtr(left, y)^,ScreenPtr(left, y+1)^, w);
              move (AttribPtr(left, y)^,AttribPtr(left, y+1)^, w);
            end;
          fillChar (ScreenPtr(left, top+Cursor.y)^, w, ' ');
          fillChar (AttribPtr(left, top+Cursor.y)^, w, textAttr);
      end;
  InvalidateRect(CrtWindow, nil, False);
  UpdateWindow (CrtWindow);
end;

{ Line delete }

procedure DelLine;
var y, w, h: integer;
begin
   InitWinCrt;
   with currentWindow do
      begin
          w := right-left+1;
          h := bottom-top+1;
          for y := top+Cursor.y to top+h-2 do
            begin
              move (ScreenPtr(left, y+1)^,ScreenPtr(left, y)^, w);
              move (AttribPtr(left, y+1)^,AttribPtr(left, y)^, w);
            end;
          fillChar (ScreenPtr(left, top+h-1)^, w, ' ');
          fillChar (AttribPtr(left, top+h-1)^, w, textAttr);
      end;
  InvalidateRect(CrtWindow, nil, False);
  UpdateWindow (CrtWindow);
end;

{ text color select }

procedure TextColor(Color: Byte);
begin
    InitWinCrt;
    if varColors then  textAttr := (textAttr and $f0) or (color and $f);
end;

{ background color select }

procedure TextBackground(Color: Byte);
begin
    InitWinCrt;
    if varColors then  textAttr := (textAttr and $0f) or (color shl 4);
end;

{ auxiliary color setting }

procedure LowVideo;
begin
   InitWinCrt;
   if varColors then  textAttr := textAttr and not HighIntens;
end;

procedure HighVideo;
begin
   InitWinCrt;
   if varColors then  textAttr := textAttr or HighIntens;
end;

procedure NormVideo;
begin
   InitWinCrt;
   if varColors then  textAttr := defaultAttrib;
end;

procedure canChangeColors (canChange: boolean);
begin
   InitWinCrt;
   varColors := canChange;
end;

{ delay }

procedure Delay(MS: Word);
begin
    sleep (ms);
    processWindowsQueue;
    processCrtWindowQueue;
end;

{ select active area }

procedure Window (X1, Y1, X2, Y2: Byte);
begin
  Cursor.X := 0;
  Cursor.Y := 0;
  with currentWindow do
      begin
          left := X1-1;  right  := X2-1;
          top  := Y1-1;  bottom := Y2-1;
      end;
end;

{ text mode - not implemented }

procedure TextMode(Mode: Integer);
begin
   clrscr;
   lastMode := mode;
end;

{ sound }

procedure Sound(Hz: Word);
var l: longint;
    p, period: integer;
begin
    if psound <> NIL then
       noSound;
    getMem (psound, sizeof (psound^)+2);  {1 second}
    period := 11025 div hz;
    p := sizeof (wavHdr);
    l := 0;
    while p <= soundSize-period do
        begin
            fillchar (psound^[p], period div 2 + 1, $60);
            p := p + period div 2;
            fillchar (psound^[p], period-(period div 2)+1, $a0);
            p := sizeof (wavHdr) +
                 integer (longint(11025)* l div longint(hz));
            l := l + 1;
        end;
    psound^[p-1] := $80;
    l := p - sizeof (wavHdr);
    move (l, wavHdr[40], 4);
    l := l + 36;
    move (l, wavHdr[4], 4);
    move (wavHdr, psound^, sizeof (wavHdr));
    sndPlaySound (pchar (psound), snd_async + snd_memory + snd_loop);
end;

{ stop sound }

procedure NoSound;
begin
    if psound <> NIL then
        begin
            sndPlaySound (NIL, SND_ASYNC);
            freeMem (psound, sizeof (psound^)+2);  {1 second}
            psound := NIL;
        end;
end;

{ speaker version of sound }

procedure SpeakerSound (Hz: Word);
{mhz = the frequency of the pc speaker}
var
   count    : word;
begin
    if (GetVersion shr 31) = 0 then exit;    // windows NT não tem bip
    count := 1193280 div hz;
    asm
        mov al,$b6
        out $43,al
        mov ax,count
        out $42,al
        mov al,ah
        out $42,al
        mov al,3
        out $61,al
    end;
end;

{speaker version of nosound }
procedure speakerNosound;
{turn off the pc speaker}
begin
    if (GetVersion shr 31) = 0 then exit;    // windows NT não tem bip
    asm
        mov al,0
        out $61,al
    end;
end;

{ put data on the clipboard (data must be null terminated) }

procedure putClipBoard (data: PChar); overload;
var
  p: pointer;
  hmem: THandle;
  size: cardinal;
begin
  if not openClipboard (crtWindow) then  exit;
  emptyClipboard;
  size := strLen (data) + 1;
  hmem := globalAlloc (GHND, size);
  p := globalLock (hmem);
  move (data^, p^, size);
  setClipboardData (CF_TEXT, hmem);
  globalUnlock (hmem);
  closeClipboard
end;

{ put data on the clipboard; size is given }

function putClipBoard (data: PChar; size : integer) : boolean; overload;
var
  p: PChar;
  hmem: THandle;
begin
  if not openClipboard (crtWindow) then
  begin
     putClipBoard := false;
     exit
  end;
  emptyClipboard;
  hmem := globalAlloc (GHND, size + 1);
  p := globalLock (hmem);
  move (data^, p^, size);
  p[size] := #0;
  setClipboardData (CF_TEXT, hmem);
  globalUnlock (hmem);
  closeClipboard;
  putClipBoard := true
end;

{ get data from the clipboard }

procedure getClipBoard (data: PChar; maxSize: integer); overload;
var
  nread: integer;
  p: PChar;
  hmem: THandle;
begin
  if maxSize = 0 then exit;
  if not openClipboard (crtWindow) then exit;
  hmem := getClipboardData (CF_TEXT);
  if hmem <> 0 then
    begin
      p := globalLock (hmem);
      nread := strlen (p) + 1;
      if nread > maxSize then nread := maxSize;
      move (p^, data^, nread);
      data[nread-1] := #$0;   { forced for overflows... }
      globalUnlock (hmem);
    end
  else
    data[0] := #$0;
  closeClipboard;
end;

function getClipBoard (maxsize : integer) : PChar; overload;
var
    nread   : integer;
    p, q    : PChar;
    hmem    : THandle;
begin
    getClipBoard := NIL;

    if not openClipboard (crtWindow) then exit;

    q    := NIL;
    hmem := getClipboardData (CF_TEXT);

    if hmem <> 0 then
    begin
        p       := globalLock (hmem);
        nread   := strlen (p) + 1;

        if nread > maxSize then nread := maxSize;

        try GetMem (q, nread) except q := NIL end;

        if q <> NIL then
        begin
            Move (p^, q^, nread);
            q[nread-1] := #0
        end;

        globalUnlock (hmem)
    end;

    closeClipboard;

    getClipBoard := q
end;

{ wm_Create message handler }

procedure WindowCreate;
begin
  Created := True;
  GetMem(ScreenBuffer, ScreenSize.X * ScreenSize.Y);
  FillChar(ScreenBuffer^, ScreenSize.X * ScreenSize.Y, ' ');
  GetMem(AttribBuffer, ScreenSize.X * ScreenSize.Y);
  FillChar(AttribBuffer^, ScreenSize.X * ScreenSize.Y, textAttr);
  with currentWindow do
      begin
          left := 0;  right  := ScreenSize.X-1;
          top  := 0;  bottom := ScreenSize.Y-1;
      end;
end;

{ wm_Paint message handler }

procedure WindowPaint;
var
  X1, X2, Y1, Y2: Integer;
begin
  Painting := True;
  InitDeviceContext;

  if not textRefreshInhibited then
    begin
      X1 := Max(0, PS.rcPaint.left div CharSize.X);
      X2 := Min(ScreenSize.X,
        (PS.rcPaint.right + CharSize.X - 1) div CharSize.X);
      Y1 := Max(0, PS.rcPaint.top div CharSize.Y);
      Y2 := Min(ScreenSize.Y,
        (PS.rcPaint.bottom + CharSize.Y - 1) div CharSize.Y);
      while Y1 < Y2 do
        begin
          showText (X1-currentWindow.left, X2-currentWindow.left, Y1-currentWindow.top);
          Inc(Y1);
        end;
    end;

  if BMPHandle <> 0 then
     paintBMP (BMPx, BMPy);

  DoneDeviceContext;
  Painting := False;
end;

{ wm_GetMinMaxInfo message handler }

procedure WindowMinMaxInfo(MinMaxInfo: PMinMaxInfo);
var
  X, Y: Integer;
  Metrics: TTextMetric;
begin
  InitDeviceContext;
  GetTextMetrics(DC, Metrics);
  CharSize.X := Metrics.tmAveCharWidth;
  CharSize.Y := Metrics.tmHeight + Metrics.tmExternalLeading;
  CharAscent := Metrics.tmAscent;
  X := Min(ScreenSize.X * CharSize.X,
       GetSystemMetrics(sm_CXScreen)) + GetSystemMetrics(sm_CXFrame) * 2;
  Y := Min(ScreenSize.Y * CharSize.Y  + GetSystemMetrics(sm_CYCaption),
       GetSystemMetrics(sm_CYScreen)) + GetSystemMetrics(sm_CYFrame) * 2;
  MinMaxInfo^[1].x := X;
  MinMaxInfo^[1].y := Y;
  MinMaxInfo^[3].x := CharSize.X * 16 + GetSystemMetrics(sm_CXFrame) * 2;
  MinMaxInfo^[3].y := CharSize.Y * 4 +  GetSystemMetrics(sm_CYFrame) * 2 +
                                        GetSystemMetrics(sm_CYCaption);
  MinMaxInfo^[4].x := X;
  MinMaxInfo^[4].y := Y;
  DoneDeviceContext;
end;

{ non-message key insert }

procedure lookupKeyBuf (var c, c2: char);
begin
    c  := keyBuffer[0];
    c2 := keyBuffer[1];
    if Keycount = 1 then c2 := #0;
end;

procedure insertKeyBuf (Ch: char);
begin
  if KeyCount < SizeOf(KeyBuffer) then
   begin
        KeyBuffer[KeyCount] := Ch;
        Inc(KeyCount);
   end;
   PostMessage(crtWindow, WM_NOTIFY, 0, 0);
end;

{ wm_Char message handler }

procedure WindowChar(Ch: Char);
begin
  if (brailleMode <> 0) and
     (ch in ['A'..'Z', 'a'..'z', ' ']) then exit;

  if KeyCount < SizeOf(KeyBuffer) then
   begin
    if ord(Ch) = VK_BACK then
        if GetKeyState(vk_Control) < 0 then KeyBuffer[KeyCount] := #127
                                       else KeyBuffer[KeyCount] := #08
    else
    if ord(Ch) = VK_RETURN then
        if GetKeyState(vk_Control) < 0 then KeyBuffer[KeyCount] := #10
                                       else KeyBuffer[KeyCount] := #13
    else
        KeyBuffer[KeyCount] := Ch;
    Inc(KeyCount);
   end;
end;

{ Braille mode change }
procedure brailleChangeMode (newMode: integer);
begin
  if newMode > 2 then newMode := 1;
  case newMode of
    0:   { disable braille typing }
         begin
           brKeysSet := 0;
           brKeysNowPressed := 0;
           brInUpcase := false;
           brCapsLock := false;
           brNumeric := false;
           if brailleMode <> 0 then
               begin
                     sound (100);  delay (200);  nosound;
               end;
         end;

    1, 2:  { braille uncoded/coded }
         begin
             sound (800);  delay (200);  nosound;
             if newMode = 1 then sound (1600) else sound (400);
             delay (200);  nosound;
         end;
  end;
  brailleMode := newMode;
end;

{ Braille typing processing - key down }

function brailleKeyDown(KeyDown: byte): boolean;
var masc: byte;
begin
    masc := 0;
    case keyDown of
         ord('S'):   masc := 4;
         ord('D'):   masc := 2;
         ord('F'):   masc := 1;
         ord('J'):   masc := 8;
         ord('K'):   masc := 16;
         ord('L'):   masc := 32;
         ord(' '):   masc := 64;
     end;
     brKeysSet := brKeysSet or masc;
     brKeysNowPressed := brKeysNowPressed or masc;
     brailleKeyDown := masc <> 0;
end;

{ Braille typing processing - key up }
{
    Non-conventional Braille encoding
        4   circunflex
        45  @ or [
        46  ]
        456 _
        5   ~
        56  \ or $
        6   ` or &
}

function brailleKeyUp(KeyUp: byte): boolean;
const
    tabTec: array [0..63] of char = (

  {0}   ' ',  'a',  ',',  'b', '''',  'k',  ';',  'l',
        '^',  'c',  'i',  'f', 'í',   'm',  's',  'p',

  {1}   '~', 'e', ':', 'h', '*', 'o', '!', 'r',
        '¬', 'd', 'j', 'g', 'ã', 'n', 't', 'q',

  {2}   'ý', 'â', '?', 'ê', '-', 'u', '"', 'v',
        '{', 'î', 'õ', 'à', 'ó', 'x', 'è', 'ç',

  {3}   '$', 'û', 'ÿ', 'ü', '}', 'z', '=', 'á',
        '_', 'ô', 'w', 'ï', '#', 'y', 'ú', 'é' );

  brcodeInUpcase: char = '{';
  brcodeNumberPrefix: char = '#';
  brcodeIgnore: byte = $fe;

var mask: byte;
    code: byte;
    ctrlDown: boolean;

    procedure brailleEncode;
    begin
        if chr(code) = '''' then code := ord('.')
        else
        if chr(code) = 'û'  then code := ord('@');

        if brNumeric then
           case chr(code) of
               'a'..'i':  code := ord ('1') + code-ord('a');
               'j':       code := ord('0');
               '''':      code := ord('.');
               '~':       brNumeric := false;
           end;

//        if (chr (code) = '{') or (chr (code) = '}') then
//             code  := ord('"');

        if brInUpcase or brCapsLock then
            if code in [ord('a')..ord('z')] then
                code := code - $20;

        if chr(code) = brcodeNumberPrefix then
            begin
                brNumeric := true;
                code := brcodeIgnore;
            end
        else
            if chr(code) = brcodeInUpcase then
                begin
                    if brInUpcase then brCapsLock := true;
                    brInUpcase := true;
                    code := brcodeIgnore;
                end
            else
                brInUpcase := false;
    end;

begin
    brailleKeyUp := false;
    CtrlDown := GetKeyState(vk_Control) < 0;
    if ctrlDown or not (chr(keyUp) in [' ', 'A'..'Z']) then
         begin
             brNumeric := false;
             brInUpcase := false;
             brCapsLock := false;
             exit;
         end;

    brailleKeyUp := true;
    mask := 0;
    case keyUp of
         ord('S'):   mask := 4;
         ord('D'):   mask := 2;
         ord('F'):   mask := 1;
         ord('J'):   mask := 8;
         ord('K'):   mask := 16;
         ord('L'):   mask := 32;
         ord(' '):   mask := 64;
     end;

     brKeysNowPressed := brKeysNowPressed and (not mask);
     if brKeysNowPressed <> 0 then exit;

     code := brcodeIgnore;
     if brKeysSet >= 64 then    {control key simulated by space key}
         begin
             brInUpcase := false;
             brCapsLock := false;
             brNumeric := false;
             if brKeysSet = 64 then
                 code := ord (' ')
             else
                 code := ord (tabTec [brKeysSet and $3f]) and $1f;
         end
     else
         begin
             code  := ord (tabTec [brKeysSet]);
             if brailleMode = 2 then brailleEncode;
         end;

    if code <> brcodeIgnore then
      if KeyCount <= SizeOf(KeyBuffer)-1 then
         begin
            KeyBuffer[KeyCount] := chr(code);
            Inc(KeyCount);
         end;

    brKeysSet := 0;
end;

{ wm_KeyDown message handler }

function WindowKeyDown(KeyDown: Byte): boolean;
var
  AltDown, CtrlDown: Boolean;
  I: Integer;

const
    ALTCODES: array [ord('A')..ord('Z')] of byte = (
        $1E, $30, $2E, $20, $12, $21, $22, $23, $17, $24,
        $25, $26, $32, $31, $18, $19, $10, $13, $1F, $14,
        $16, $2F, $11, $2D, $15, $2C
    );
    ALTNUMCODES: array [ord('0')..ord('9')] of byte = (
        $81, $78, $79, $7A, $7B, $7C, $7D, $7E, $7F, $80
    );

begin
  windowKeyDown := true;
  if CheckBreak and (KeyDown = vk_Cancel) then   {control-break}
      Terminate;

  AltDown := getKeyState(vk_Menu) < 0;
  CtrlDown := GetKeyState(vk_Control) < 0;

  if altDown then
    begin
        if CtrlDown and (keydown = VK_F12) then
            begin
               brailleChangeMode (0);
               exit;
            end
        else
        if CtrlDown and (keydown = VK_F11) then
            begin
               brailleChangeMode (brailleMode+1);
               exit;
            end
        else
        if keyDown in [ord('A')..ord('Z'), ord('0')..ord('9')] then
            begin
              KeyBuffer[KeyCount] := #0;
              Inc(KeyCount);
              if keyDown in [ord('A')..ord('Z')] then
                  KeyBuffer[KeyCount] := chr(ALTCODES[keyDown])
              else
                  KeyBuffer[KeyCount] := chr(ALTNUMCODES[keyDown]);
              Inc(KeyCount);
              exit;
            end;
    end;

  if not ctrlDown then
    begin
      if brailleMode <> 0 then
          if brailleKeyDown(KeyDown) then exit;
    end;

  if KeyCount <= SizeOf(KeyBuffer)-2 then
    for I := 1 to SpecialKeysCount do
      with SpecialKeys[I] do
        if (Key = KeyDown) then
          begin
              KeyBuffer[KeyCount] := #0;
              Inc(KeyCount);
              if CtrlDown then
                 KeyBuffer[KeyCount] := ctlChar
              else                                { simulating cut/paste }
                 if (ctlChar = #$ff) and (GetKeyState (vk_Shift) < 0) then
                    KeyBuffer[KeyCount] := #$fe
                 else
                    KeyBuffer[KeyCount] := basicChar;
              Inc(KeyCount);
              exit;
          end;
end;

function WindowKeyUp(KeyUp: Byte): boolean;
begin
  if brailleMode <> 0 then
      windowKeyUp := brailleKeyUp (KeyUp)
  else
      windowKeyUp := false;
end;

{ wm_SetFocus message handler }

procedure WindowSetFocus;
begin
  Focused := True;
  if Reading or ForcedCur then ShowCursor;
  if checkFocus then
      begin
          KeyBuffer[KeyCount] := #$de;
          inc (KeyCount);
      end;
end;

{ wm_KillFocus message handler }

procedure WindowKillFocus;
begin
  if Reading or ForcedCur then HideCursor;
  Focused := False;
  if checkFocus then
      begin
          KeyBuffer[KeyCount] := #$df;
          inc (KeyCount);
      end;
end;

{ wm_Destroy message handler }

procedure WindowDestroy;
begin
  KillTimer (crtWindow, 100);
  FreeMem(ScreenBuffer, ScreenSize.X * ScreenSize.Y);
  FreeMem(AttribBuffer, ScreenSize.X * ScreenSize.Y);
  Cursor.X := 0;
  Cursor.Y := 0;
  PostQuitMessage(0);
  Created := False;
end;

{ wm_timer function }

procedure WindowTimer;
begin
    timerIsSet := true;
end;

{ bitmap handling }

function openBMP (filename: string): Boolean;
var
    TestWin30Bitmap: Longint;

    bitCount: Word;
    size: Word;
    longWidth: Longint;
    colors: Longint;
    dataOffset: Longint;
    DCHandle: HDC;
    BitmapInfo: PBitmapInfo;

    BitsHandle, NewBMPHandle: THandle;
    NewPixelWidth, NewPixelHeight: Word;

    Count: integer;
    ToAddr, Bits: PChar;
    TheFile: File;

begin
    OpenBMP := false;

    Assign(TheFile, filename);
    {$I-} Reset(TheFile, 1); {$I+}
    if ioresult <> 0 then exit;

    Seek(TheFile, 14);
    BlockRead(TheFile, TestWin30Bitmap, SizeOf(TestWin30Bitmap));
    if TestWin30Bitmap <> 40 then
        begin
             close (TheFile);
             exit;
        end;

    OpenBMP := true;;

    seek (TheFile, 10);
    BlockRead(TheFile, dataOffset, SizeOf(dataOffset));
    Seek(TheFile, 28);
    BlockRead(TheFile, bitCount, SizeOf(bitCount));
    Seek(TheFile, 46);
    BlockRead(TheFile, colors, SizeOf(Colors));

    size := SizeOf(TBitmapInfoHeader);
    if bitCount <= 8 then
        size := size + (colors * SizeOf(TRGBQuad));
    getmem (BitmapInfo, size);
    Seek(TheFile, SizeOf(TBitmapFileHeader));
    BlockRead(TheFile, BitmapInfo^, size);

    NewPixelWidth := BitmapInfo^.bmiHeader.biWidth;
    NewPixelHeight := BitmapInfo^.bmiHeader.biHeight;
    longWidth := (((NewPixelWidth * bitCount) + 31) div 32) * 4;
    Count := longWidth * NewPixelHeight;
    BitmapInfo^.bmiHeader.biSizeImage := Count;
    BitsHandle := GlobalAlloc(gmem_Moveable or gmem_Zeroinit, Count);

    Bits := GlobalLock(BitsHandle);
    ToAddr := Bits;

    seek (TheFile, dataOffset);
    while Count > 0 do
        begin
            if Count > $4000 then
                BlockRead(TheFile, ToAddr^, $4000)
            else
                BlockRead(TheFile, ToAddr^, Count);
            inc (ToAddr, $4000);
            dec (Count, $4000);
        end;
    GlobalUnlock(BitsHandle);

    DCHandle := CreateDC ('Display', nil, nil, nil);
    Bits := GlobalLock(BitsHandle);

    NewBMPHandle := CreateDIBitmap(DCHandle,
           BitmapInfo^.bmiHeader, cbm_Init, Bits, BitmapInfo^, 0);

    DeleteDC(DCHandle);
    GlobalUnlock(BitsHandle);
    GlobalFree(BitsHandle);
    if size > 0 then
        FreeMem(BitmapInfo, size);

    if NewBMPHandle <> 0 then
         begin
             if BMPHandle <> 0 then DeleteObject(BMPHandle);

             BMPHandle := NewBMPHandle;
             BMPx := 0; BMPy := 0;
             BMPWidth := NewPixelWidth;
             BMPHeight := NewPixelHeight;
             BMPScale := 1.0;
         end
    else
        OpenBMP := False;

    Close(TheFile);
end;

procedure freeBMP;
begin
    if BMPHandle <> 0 then
        begin
            DeleteObject(BMPHandle);
            BMPHandle := 0;
        end;
end;

procedure closeBMP;
begin
    freeBmp;
    invalidateRect (crtWindow, NIL, false);
    processWindowsQueue;
end;

procedure paintBMP (x, y: integer);
var
    crtDc, MemDc: HDC;
begin
    if bmpHandle = 0 then exit;

    BMPx := x; BMPy := y;

    crtDc := getDc (crtWindow);

    Memdc := CreateCompatibleDC (crtDc);
    SelectObject(MemDC, BMPHandle);
    if BMPScale = 1.0 then
        BitBlt(crtDC, x, y, BMPWidth, BMPHeight, MemDC, 0, 0, SRCCopy)
    else
        StretchBlt (crtDC, x, y, trunc(BMPWidth*BMPScale), trunc(BMPHeight*BMPScale),
                    MemDC, 0, 0, BMPWidth, BMPHeight, SRCCopy);

    DeleteDC(MemDC);

    releaseDc (crtWindow, crtDc);
end;

{ CRT window procedure }

function CrtWinProc(Window: HWnd; Message: UINT;
                    WParam: WPARAM; LParam: LPARAM): LRESULT;
var
    resultx: longint;
    brlKey1, brlKey2: char;
const
    ESQ = 75;
    DIR = 77;
label defproc;
begin
  CrtWinProc := 0;
  CrtWindow := Window;

  if hasAlternateWinProc then
      begin
          alternateWinProc (Window, Message, WParam, LParam, resultx);
          if resultx <> 0 then
              begin
                  CrtWinProc := resultx;
                  exit;
              end;
      end;

  case Message of
    wm_Create: WindowCreate;
    wm_Paint: WindowPaint;
    wm_GetMinMaxInfo: WindowMinMaxInfo(PMinMaxInfo(LParam));
    wm_Char: WindowChar(Char(WParam));
    wm_KeyDown: if not WindowKeyDown(Byte(WParam)) then goto defProc;
    wm_KeyUp:   if not WindowKeyUp(Byte(WParam))   then goto defProc;
    wm_SetFocus:  begin
                      WindowSetFocus;
                      if mouseEnabled then
                          dvMouse.gotFocusByClick :=
                                (GetAsyncKeyState(VK_LBUTTON) < 0) or
                                (GetAsyncKeyState(VK_MBUTTON) < 0) or
                                (GetAsyncKeyState(VK_RBUTTON) < 0);
                  end;
    wm_KillFocus: begin
                    WindowKillFocus;
                    if mouseEnabled then
                        dvMouse.gotFocusByClick := False;
                  end;
    wm_Destroy: WindowDestroy;
    wm_Close: doneWinCrt;
    wm_Timer: WindowTimer;

    wm_CopyData: if hasCopyDataCallBack then
                    copyDataCallback (Window, WParam, Lparam)
                 else goto defProc;
    mm_Wom_Done: if hasmmCallback then
                    mmCallback (Window, WParam, Lparam)
                 else goto defProc;
    mm_MCINotify: if hasMCICallback then
                    MCICallback (Window, WParam, Lparam)
                 else goto defProc;
    wm_SysKeyDown:
        begin
            if checkBreak and
               (Byte(WParam) <> 37) and (Byte(WParam) <> 39) then  //  <- ->
                goto defProc
            else
                if not WindowKeyDown(Byte(WParam)) then goto defProc;
        end;

    wm_LButtonDown,
    wm_RButtonDown,
    wm_MButtonDown,
    wm_MouseWheel:  if not dvMouseProcEvent (Message, WParam, LParam) then goto defProc;

  else
    if hasBrailleKbdCallback and (Message = uint(brailleKbdMsg)) then
      begin
          BrailleKbdCallback (Window, WParam, Lparam, brlKey1, brlKey2);
          if (brlKey1 <> #0) or (brlKey2 <> #0) then
              begin
                  insertKeyBuf(brlKey1);
                  if brlKey1 = #$0 then
                      insertKeyBuf(brlKey2);
                  PostMessage(crtWindow, WM_NOTIFY, 0, 0);
              end;
      end
    else
      begin
defProc:
        CrtWinProc := DefWindowProc(Window, Message, WParam, LParam);
      end;
  end;
end;

{ Text file device driver output function }

function CrtOutput(var F: TTextRec): Integer; far;
begin
  if F.BufPos <> 0 then
  begin
    WriteBuf (PChar(F.BufPtr), F.BufPos);
    F.BufPos := 0;
    KeyPressed;
  end;
  CrtOutput := 0;
end;

{ Text file device driver input function }

function CrtInput(var F: TTextRec): Integer; far;
begin
  F.BufEnd := ReadBuf(PChar(F.BufPtr), F.BufSize);
  F.BufPos := 0;
  CrtInput := 0;
end;

{ Text file device driver close function }

function CrtClose(var F: TTextRec): Integer; far;
begin
  CrtClose := 0;
end;

{ Text file device driver open function }

function CrtOpen(var F: TTextRec): Integer; far;
begin
  if F.Mode = fmInput then
  begin
    F.InOutFunc := @CrtInput;
    F.FlushFunc := nil;
  end else
  begin
    F.Mode := fmOutput;
    F.InOutFunc := @CrtOutput;
    F.FlushFunc := @CrtOutput;
  end;
  F.CloseFunc := @CrtClose;
  CrtOpen := 0;
end;

{ Assign text file to CRT device }

procedure AssignCrt(var F: Text);
begin
  with TTextRec(F) do
  begin
    Handle := $FFFF;
    Mode := fmClosed;
    BufSize := SizeOf(Buffer);
    BufPtr := @Buffer;
    OpenFunc := @CrtOpen;
    Name[0] := #0;
  end;
end;

{ get the date }

procedure getDate (var a, m, d, w: word);
begin
  decodeDate (date, a, m, d);
  w := DayOfWeek (date) - 1;
end;

{ get the time }

procedure getTime (var h, m, s, cent: word);
begin
  decodeTime (time, h, m, s, cent);
  cent := cent div 10;
end;

{ choose Dosvox ini files directory }

function dosvoxIniDir: string;
var dir, windir: string;
    pwindir: array [0..255] of char;

begin
    regGetString (HKEY_CURRENT_USER,
                'Software\Microsoft\Windows\CurrentVersion\Explorer'+
                '\Shell Folders\AppData', Dir);

    dir := Dir + '\Dosvox';   { \users\usuario\appdata\roaming\dosvox }

    if not fileExists(dir+'\Dosvox.ini') then   // Roaming não existe ainda...
        begin
            GetWindowsDirectory(pwindir, 255);
            windir := strPas(pwindir);            // tento na pasta Windows
            if fileExists(windir+'\Dosvox.ini') then
                dir := windir;
        end;

    result := dir;
end;

{ Look for Dosvox default parameters }
{--------------------------------------------------------}

procedure dosvoxSelection;
var i, n, p: integer;
    resp: array [0..80] of char;
    erro: integer;
    cores: string;
    chSet: integer;
    corf, corl: word;
    dxvid, dyvid: integer;
    vidrect: TRect;
    dosvoxIniFileName: string;
const
    largLetra1024 = 13;
    altLetra734 = 28;
begin
    dosvoxIniFilename := dosvoxIniDir + '\Dosvox.ini';

    varColors := true;
    videoIsSlow := false;
    corf := defaultAttrib shr 4;
    corl := defaultAttrib and $f;
    lastMode := CO80;
    maximize := false;

    SystemParametersInfo(SPI_GETWORKAREA, 0, @vidRect, 0);
    dxvid := vidRect.Right - vidRect.Left;
    dyvid := vidRect.Bottom - vidRect.Top;

    n := GetPrivateProfileString('VIDEO', 'TABCORES',
         '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15', resp, 80, pchar(dosvoxIniFileName));
    if (n <> 0) then
        begin
            cores := strPas (resp)+',';
            for i := 0 to 15 do
                begin
                    p := pos (',', cores);
                    if p = 0 then break;
                    val (copy (trim(cores), 1, p-1), colorArrange[i], erro);
                    if erro <> 0 then break;
                    delete (cores, 1, p);
                end;
        end;

    n := GetPrivateProfileString('VIDEO', 'CORESFIXAS', 'N', resp, 80, pchar(dosvoxIniFileName));
    if (n <> 0) and (upcase(resp[0]) = 'S') then varColors := false;
    n := GetPrivateProfileString('VIDEO', 'LENTO', 'N', resp, 80, pchar(dosvoxIniFileName));
    if (n <> 0) and (upcase(resp[0]) = 'S') then videoIsSlow := true;
    n := GetPrivateProfileString('VIDEO', 'CORFUNDO', '0', resp, 80, pchar(dosvoxIniFileName));
    if (n <> 0) then val (strPas (resp), corf, erro);
    n := GetPrivateProfileString('VIDEO', 'CORLETRA', '15', resp, 80, pchar(dosvoxIniFileName));
    if (n <> 0) then val (strPas (resp), corl, erro);

    textAttr := (corf shl 4) or corl;

    brailleMode := 0;
    n := GetPrivateProfileString('BRAILLE', 'MODO', '0', resp, 80, pchar(dosvoxIniFileName));
    if (n <> 0) then brailleMode := ord(resp[0]) and $3;

    if not forceDefaultFont then
        begin
            if fontName = '' then
                begin
                    n := GetPrivateProfileString('VIDEO', 'FONTE', 'Lucida Console',
                                        resp, 80, pchar(dosvoxIniFileName));
                    if (n <> 0) then fontName := resp;
                end;

            if fontWidth = 0 then
                begin
                    n := GetPrivateProfileString('VIDEO', 'LARGURALETRA', '',
                                        resp, 80, pchar(dosvoxIniFileName));
                    if n = 0 then
                        fontWidth := trunc (dxvid / 1024 * largLetra1024)
                    else
                        val (strPas (resp), fontWidth, erro);
                end;

            if fontHeight = 0 then
                begin
                    n := GetPrivateProfileString('VIDEO', 'ALTURALETRA', '',
                                        resp, 80, pchar(dosvoxIniFileName));
                    if n = 0 then
                        fontHeight := trunc (dyvid / 734 * altLetra734)
                    else
                        val (strPas (resp), fontHeight, erro)
                end;

            if fontWeight <> 0 then
                begin
                    n := GetPrivateProfileString('VIDEO', 'PESOLETRA', '700',
                                        resp, 80, pchar(dosvoxIniFileName));
                    if (n <> 0) then val (strPas (resp), fontWeight, erro);
                end;

            if not maximize then
                begin
                    n := GetPrivateProfileString('VIDEO', 'CANTOTELA', 'SIM',
                                        resp, 80, pchar(dosvoxIniFileName));
                    if (n <> 0) then maximize := upcase(resp[1]) <> 'S';
                end;

            chset := ANSI_CHARSET;
            if selectOEMFont then chset := OEM_CHARSET;

            fontHandle := createFont (fontHeight, fontWidth, 0, 0, fontWeight,
                        0, 0, 0, chset, 0, 0, 0, DEFAULT_PITCH, pchar(fontName));
         end;
end;

{ Create CRT window if required }

procedure InitWinCrt;
var
    Metrics: TTextMetric;
begin
  if not Created then
  begin
    dosvoxSelection;

    DC := getDC (0);
    SaveFont := SelectObject(DC, fontHandle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
    releaseDC (0, DC);

    WindowSize.x := Metrics.tmAveCharWidth * ScreenSize.X + GetSystemMetrics(sm_CXFrame) * 2;
    WindowSize.y := (Metrics.tmHeight + Metrics.tmExternalLeading) * ScreenSize.Y +
                    GetSystemMetrics(sm_CYFrame) * 2 + GetSystemMetrics(sm_CYCaption);
    leftMargin := Metrics.tmOverhang;

    CrtWindow := CreateWindow(
        CrtClass.lpszClassName,
        WindowTitle,
        windowDefMode,  {ws_OverlappedWindow}
        WindowOrg.X, WindowOrg.Y,
        WindowSize.X, WindowSize.Y,
        0, 0, 0, nil);

    if maximize then
        ShowWindow(CrtWindow, SW_MAXIMIZE)
    else
        ShowWindow(CrtWindow, SW_SHOW);
    UpdateWindow(CrtWindow);

    brailleChangeMode (brailleMode);
  end;
end;

{ WinCrt unit exit procedure }

procedure ExitWinCrt; far;
begin
  ExitProc := SaveExit;
  if Created and (ErrorAddr = nil) then
  begin
    SetWindowText(CrtWindow, InactiveTitle);
    EnableMenuItem(GetSystemMenu(CrtWindow, False), sc_Close, mf_Enabled);
    CheckBreak := False;
    SetWindowLong(crtWindow, GWL_WNDPROC, Longint(@DefWindowProc));
  end;
end;

{ Destroy CRT window if required }

procedure DoneWinCrt;
begin
  if Created then
     begin
        if Focused and Reading then HideCursor;
        while keypressed do readkey;

        if fontHandle <> 0 then
            begin
                DC := GetDC(CrtWindow);
                SelectObject(DC, GetStockObject(OEM_Fixed_Font));
                deleteObject(fontHandle);
                ReleaseDC(crtWindow, DC);
            end;

        SetWindowLong(crtWindow, GWL_WNDPROC, Longint(@DefWindowProc));
        DestroyWindow(CrtWindow);
        Created := false;
     end;
  halt;
end;

{ Set Window Title }

procedure setWindowTitle (title: string);
var
   sz: array [0..144] of char;
begin
   title := trim (title);
   if length (title) > 140 then
      strPCopy (sz, copy (title, 1, 140) + '...')
   else
      strPCopy (sz, title);
   setWindowText (crtWindow, sz);
end;

var
    i: integer;
begin
  CrtWindow := 0;
  brailleMode := 0;
  hasAlternateWinProc := false;
  hasmmCallback := false;
  hasMCICallback := false;
  hasCopyDataCallback := false;
  textRefreshInhibited := false;

  fileMode := fmOpenRead;
  BMPHandle := 0;
  BMPheight := 0;
  BMPwidth := 0;
  invertColorMask := 0;

  with crtClass do
      begin
         CrtClass.hInstance := 0;
         hIcon := LoadIcon(0, idi_Application);
         hCursor := LoadCursor(0, idc_Arrow);
         hbrBackground := getStockObject (BLACK_BRUSH);
      end;
  RegisterClass(CrtClass);

  brailleKbdMsg := RegisterWindowMessage('dvLinBrl');

  WindowDefMode := ws_OverlappedWindow;
  AssignCrt(Input);
  Reset(Input);
  AssignCrt(Output);
  Rewrite(Output);

  GetModuleFileName(HInstance, WindowTitle, SizeOf(WindowTitle));
  OemToAnsi(WindowTitle, WindowTitle);

  SaveExit := ExitProc;
  ExitProc := @ExitWinCrt;

  pSound := NIL;

  for i := 0 to 15 do
      colorArrange[i] := i;
end.

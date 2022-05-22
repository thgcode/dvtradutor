unit WOW16;
{ Unit which provides an interface to the 16-bit Windows on Win32 (WOW)   }
{ API from a 16-bit application running under Windows NT or Windows 95.   }
{ These functions allow you to call 32-bit DLLs from 16-bit applications. }
{ Copyright (c) 1996 Steve Teixeira }

interface

uses WinTypes;

type
  THandle32 = Longint;
  DWORD = Longint;


{ Win32 module management.}

{ The following routines accept parameters that correspond directly  }
{ to the respective Win32 API function calls that they invoke. Refer }
{ to the Win32 reference documentation for more detail.              }

function LoadLibraryEx32W(LibFileName: PChar; hFile, dwFlags: DWORD): THandle32;
function FreeLibrary32W(LibModule: THandle32): BOOL;
function GetProcAddress32W(Module: THandle32; ProcName: PChar): TFarProc;

{ GetVDMPointer32W converts a 16-bit (16:16) pointer into a       }
{ 32-bit flat (0:32) pointer. The value of FMode should be 1 if   }
{ the 16-bit pointer is a protected mode address (the normal      }
{ situation in Windows 3.x) or 0 if the 16-bit pointer is real    }
{ mode.                                                          }
{ NOTE:  Limit checking is not performed in the retail build      }
{ of Windows NT.  It is performed in the checked (debug) build    }
{ of WOW32.DLL, which will cause 0 to be returned when the        }
{ limit is exceeded by the supplied offset.                       }

function GetVDMPointer32W(Address: Pointer; fProtectedMode: WordBool): DWORD;

{ CallProc32W calls a proc whose address was retrieved by         }
{ GetProcAddress32W. The true definition of this function         }
{ actually allows for multiple DWORD parameters to be passed      }
{ prior to the ProcAddress parameter, and the nParams parameter   }
{ should reveal the number of params passed prior to ProcAddress. }
{ The AddressConvert parameter is a bitmask which indicates which }
{ of the params are 16-bit pointers in need of conversion before  }
{ the 32-bit function is called. Since this function doesn't lend }
{ itself to being defined in Object Pascal, you may want to use  }
{ the simplified Call32BitProc function instead. }

function CallProc32W(Params: DWORD; ProcAddress, AddressConvert,
                     nParams: DWORD): DWORD;

{ Call32BitProc accepts a constant array of Longints as the parameter }
{ list for the function given by ProcAddress. This procedure is       }
{ responsible for packaging the parameters into the correct format    }
{ and calling the CallProc32W WOW function. }

function Call32BitProc(ProcAddress: DWORD; Params: array of Longint;
                       AddressConvert: Longint): DWORD;

{ Converts a 16-bit window handle to 32-bit for use by Windows NT. }

function HWnd16To32(Handle: hWnd): THandle32;

{ Converts a 32-bit window handle to 16-bit. }

function HWnd32To16(Handle: THandle32): hWnd;

implementation

uses WinProcs;

function HWnd16To32(Handle: hWnd): THandle32;
begin
  HWnd16To32 := Handle or $FFFF0000;
end;

function HWnd32To16(Handle: THandle32): hWnd;
begin
  HWnd32To16 := LoWord(Handle);
end;

function BitIsSet(Value: Longint; Bit: Byte): Boolean;
begin
  BitIsSet := Value and (1 shl Bit) <> 0;
end;

procedure FixParams(var Params: array of Longint; AddConv: Longint);
var
  i: integer;
begin
  for i := Low(Params) to High(Params) do
    if BitIsSet(AddConv, i) then
      Params[i] := GetVDMPointer32W(Pointer(Params[i]), True);
end;

function Call32BitProc(ProcAddress: DWORD; Params: array of Longint;
                       AddressConvert: Longint): DWORD;
var
  NumParams: word;
  res: longint;
begin
  FixParams(Params, AddressConvert);
  NumParams := High(Params) + 1;
  asm
    les di, Params              { es:di -> Params }
    mov cx, NumParams           { loop counter = num params }
  @@1:
    push es:word ptr [di + 2]   { push hiword of param x }
    push es:word ptr [di]       { push loword of param x }
    add di, 4                   { skip to next param }
    loop @@1                    { iterate over all params }
    mov cx, ProcAddress.Word[2] { cx = hiword of ProcAddress }
    mov dx, ProcAddress.Word[0] { dx = loword of ProcAddress }
    push cx                     { push hi ProcAddress }
    push dx                     { push lo ProcAddress }
    mov ax, 0
    push ax                     { push dummy hi AddressConvert }
    push ax                     { push dummy lo AddressConvert }
    push ax                     { push hi NumParams }
    mov cx, NumParams
    push cx                     { push lo Number of Params }
    call CallProc32W            { call function }
    mov res.Word[0], ax
    mov res.Word[2], dx      { store return value }
  end;
  Call32BitProc := res;
end;

{ 16-bit WOW functions }
function LoadLibraryEx32W;             external 'KERNEL' index 513;
function FreeLibrary32W;               external 'KERNEL' index 514;
function GetProcAddress32W;            external 'KERNEL' index 515;
function GetVDMPointer32W;             external 'KERNEL' index 516;
function CallProc32W;                  external 'KERNEL' index 517;

end.

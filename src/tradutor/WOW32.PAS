unit WOW32;

interface

uses Windows;

//
// 16:16 -> 0:32 Pointer translation.
//
// WOWGetVDMPointer will convert the passed in 16-bit address
// to the equivalent 32-bit flat pointer.  If fProtectedMode
// is TRUE, the function treats the upper 16 bits as a selector
// in the local descriptor table.  If fProtectedMode is FALSE,
// the upper 16 bits are treated as a real-mode segment value.
// In either case the lower 16 bits are treated as the offset.
//
// The return value is 0 if the selector is invalid.
//
// NOTE:  Limit checking is not performed in the retail build
// of Windows NT.  It is performed in the checked (debug) build
// of WOW32.DLL, which will cause 0 to be returned when the
// limit is exceeded by the supplied offset.
//
function WOWGetVDMPointer(vp, dwBytes: DWORD; fProtectedMode: BOOL): Pointer; stdcall;

//
// The following two functions are here for compatibility with
// Windows 95.  On Win95, the global heap can be rearranged,
// invalidating flat pointers returned by WOWGetVDMPointer, while
// a thunk is executing.  On Windows NT, the 16-bit VDM is completely
// halted while a thunk executes, so the only way the heap will
// be rearranged is if a callback is made to Win16 code.
//
// The Win95 versions of these functions call GlobalFix to
// lock down a segment's flat address, and GlobalUnfix to
// release the segment.
//
// The Windows NT implementations of these functions do *not*
// call GlobalFix/GlobalUnfix on the segment, because there
// will not be any heap motion unless a callback occurs.
// If your thunk does callback to the 16-bit side, be sure
// to discard flat pointers and call WOWGetVDMPointer again
// to be sure the flat address is correct.
//
function WOWGetVDMPointerFix(vp, dwBytes: DWORD; fProtectedMode: BOOL): Pointer; stdcall;
procedure WOWGetVDMPointerUnfix(vp: DWORD); stdcall;

//
// Win16 memory management.
//
// These functions can be used to manage memory in the Win16
// heap.  The following four functions are identical to their
// Win16 counterparts, except that they are called from Win32
// code.
//
function WOWGlobalAlloc16(wFlags: word; cb: DWORD): word; stdcall;
function WOWGlobalFree16(hMem: word): word; stdcall;
function WOWGlobalLock16(hMem: word): DWORD; stdcall;
function WOWGlobalUnlock16(hMem: word): BOOL; stdcall;

//
// The following three functions combine two common operations in
// one switch to 16-bit mode.
//
function WOWGlobalAllocLock16(wFlags: word; cb: DWORD; phMem: PWord): DWORD; stdcall;
function WOWGlobalLockSize16(hMem: word; pcb: PDWORD): DWORD; stdcall;
function WOWGlobalUnlockFree16(vpMem: DWORD): word; stdcall;

//
// Yielding the Win16 nonpreemptive scheduler
//
// The following two functions are provided for Win32 code called
// via Generic Thunks which needs to yield the Win16 scheduler so
// that tasks in that VDM can execute while the thunk waits for
// something to complete.  These two functions are functionally
// identical to calling back to 16-bit code which calls Yield or
// DirectedYield.
//
procedure WOWYield16;
procedure WOWDirectedYield16(htask16: word);

//
// Generic Callbacks.
//
// WOWCallback16 can be used in Win32 code called
// from 16-bit (such as by using Generic Thunks) to call back to
// the 16-bit side.  The function called must be declared similarly
// to the following:
//
// function CallbackRoutine(dwParam: Longint): Longint; export;
//
// If you are passing a pointer, declare the parameter as such:
//
// function CallbackRoutine(vp: Pointer): Longint; export;
//
// NOTE: If you are passing a pointer, you'll need to get the
// pointer using WOWGlobalAlloc16 or WOWGlobalAllocLock16
//
// If the function called returns a word instead of a Longint, the
// upper 16 bits of the return value is undefined.  Similarly, if
// the function called has no return value, the entire return value
// is undefined.
//
// WOWCallback16Ex allows any combination of arguments up to
// WCB16_MAX_CBARGS bytes total to be passed to the 16-bit routine.
// cbArgs is used to properly clean up the 16-bit stack after calling
// the routine.  Regardless of the value of cbArgs, WCB16_MAX_CBARGS
// bytes will always be copied from pArgs to the 16-bit stack.  If
// pArgs is less than WCB16_MAX_CBARGS bytes from the end of a page,
// and the next page is inaccessible, WOWCallback16Ex will incur an
// access violation.
//
// If cbArgs is larger than the WCB16_MAX_ARGS which the running
// system supports, the function returns FALSE and GetLastError
// returns ERROR_INVALID_PARAMETER.  Otherwise the function
// returns TRUE and the DWORD pointed to by pdwRetCode contains
// the return code from the callback routine.  If the callback
// routine returns a WORD, the HIWORD of the return code is
// undefined and should be ignored using LOWORD(dwRetCode).
//
// WOWCallback16Ex can call routines using the PASCAL and CDECL
// calling conventions.  The default is to use the PASCAL
// calling convention.  To use CDECL, pass WCB16_CDECL in the
// dwFlags parameter.
//
// The arguments pointed to by pArgs must be in the correct
// order for the callback routine's calling convention.
// To call the routine SetWindowText,
//
// SetWindowText(Handle: hWnd; lpsz: PChar): Longint;
//
// pArgs would point to an array of words:
//
// SetWindowTextArgs: array[0..2] of word =
//     (LoWord(Longint(lpsz)), HiWord(Longint(lpsz)), Handle);
//
// In other words, the arguments are placed in the array in reverse
// order with the least significant word first for DWORDs and offset
// first for FAR pointers.  Further, the arguments are placed in the array in the order
// listed in the function prototype with the least significant word
// first for DWORDs and offset first for FAR pointers.
//
function WOWCallback16(vpfn16, dwParam: DWORD): DWORD; stdcall;

const
  WCB16_MAX_CBARGS = 16;
  WCB16_PASCAL     = $0;
  WCB16_CDECL      = $1;

function WOWCallback16Ex(vpfn16, dwFlags, cbArgs: DWORD; pArgs: Pointer;
                         pdwRetCode: PDWORD): BOOL; stdcall;

//
// 16 <--> 32 Handle mapping functions.
//
type
  TWOWHandleType = (
    WOW_TYPE_HWND,
    WOW_TYPE_HMENU,
    WOW_TYPE_HDWP,
    WOW_TYPE_HDROP,
    WOW_TYPE_HDC,
    WOW_TYPE_HFONT,
    WOW_TYPE_HMETAFILE,
    WOW_TYPE_HRGN,
    WOW_TYPE_HBITMAP,
    WOW_TYPE_HBRUSH,
    WOW_TYPE_HPALETTE,
    WOW_TYPE_HPEN,
    WOW_TYPE_HACCEL,
    WOW_TYPE_HTASK,
    WOW_TYPE_FULLHWND);

function WOWHandle16(Handle32: THandle; HandType: TWOWHandleType): word; stdcall;
function WOWHandle32(Handle16: word; HandleType: TWOWHandleType): THandle; stdcall;

implementation

const
  WOW32DLL = 'WOW32.DLL';

function WOWCallback16;          external WOW32DLL name 'WOWCallback16';
function WOWCallback16Ex;        external WOW32DLL name 'WOWCallback16Ex';
function WOWGetVDMPointer;       external WOW32DLL name 'WOWGetVDMPointer';
function WOWGetVDMPointerFix;    external WOW32DLL name 'WOWGetVDMPointerFix'
procedure WOWGetVDMPointerUnfix; external WOW32DLL name 'WOWGetVDMPointerUnfix'
function WOWGlobalAlloc16;       external WOW32DLL name 'WOWGlobalAlloc16'
function WOWGlobalAllocLock16;   external WOW32DLL name 'WOWGlobalAllocLock16';
function WOWGlobalFree16;        external WOW32DLL name 'WOWGlobalFree16';
function WOWGlobalLock16;        external WOW32DLL name 'WOWGlobalLock16';
function WOWGlobalLockSize16;    external WOW32DLL name 'WOWGlobalLockSize16';
function WOWGlobalUnlock16;      external WOW32DLL name 'WOWGlobalUnlock16';
function WOWGlobalUnlockFree16;  external WOW32DLL name 'WOWGlobalUnlockFree16';
function WOWHandle16;            external WOW32DLL name 'WOWHandle16';
function WOWHandle32;            external WOW32DLL name 'WOWHandle32';
procedure WOWYield16;            external WOW32DLL name 'WOWYield16';
procedure WOWDirectedYield16;    external WOW32DLL name 'WOWDirectedYield16';

end.

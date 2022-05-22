//+-------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright 1995 - 1996 Microsoft Corporation. All Rights Reserved.
//  File: oleacc.h
//
//  Converted to Delphi 4 by Antonio Borges - The Dosvox Project - 2001
//
//--------------------------------------------------------------------------

unit oleacc;
interface
uses Windows, ActiveX;

type
    HWINEVENTHOOK = DWORD;

const

// PROPERTIES:  Hierarchical
    DISPID_ACC_PARENT                = -5000;
    DISPID_ACC_CHILDCOUNT            = -5001;
    DISPID_ACC_CHILD                 = -5002;

// PROPERTIES:  Descriptional
    DISPID_ACC_NAME                  = -5003;
    DISPID_ACC_VALUE                 = -5004;
    DISPID_ACC_DESCRIPTION           = -5005;
    DISPID_ACC_ROLE                  = -5006;
    DISPID_ACC_STATE                 = -5007;
    DISPID_ACC_HELP                  = -5008;
    DISPID_ACC_HELPTOPIC             = -5009;
    DISPID_ACC_KEYBOARDSHORTCUT      = -5010;
    DISPID_ACC_FOCUS                 = -5011;
    DISPID_ACC_SELECTION             = -5012;
    DISPID_ACC_DEFAULTACTION         = -5013;

// METHODS
    DISPID_ACC_SELECT                = -5014;
    DISPID_ACC_LOCATION              = -5015;
    DISPID_ACC_NAVIGATE              = -5016;
    DISPID_ACC_HITTEST               = -5017;
    DISPID_ACC_DODEFAULTACTION       = -5018;

// Input to DISPID_ACC_NAVIGATE
    NAVDIR_MIN                     = $00000000;
    NAVDIR_UP                      = $00000001;
    NAVDIR_DOWN                    = $00000002;
    NAVDIR_LEFT                    = $00000003;
    NAVDIR_RIGHT                   = $00000004;
    NAVDIR_NEXT                    = $00000005;
    NAVDIR_PREVIOUS                = $00000006;
    NAVDIR_FIRSTCHILD              = $00000007;
    NAVDIR_LASTCHILD               = $00000008;
    NAVDIR_MAX                     = $00000009;

// Input to DISPID_ACC_SELECT
    SELFLAG_NONE                   = $00000000;
    SELFLAG_TAKEFOCUS              = $00000001;
    SELFLAG_TAKESELECTION          = $00000002;
    SELFLAG_EXTENDSELECTION        = $00000004;
    SELFLAG_ADDSELECTION           = $00000008;
    SELFLAG_REMOVESELECTION        = $00000010;
    SELFLAG_VALID                  = $0000001F;

// Output from DISPID_ACC_STATE
    STATE_SYSTEM_UNAVAILABLE       = $00000001;  // Disabled
    STATE_SYSTEM_SELECTED          = $00000002;
    STATE_SYSTEM_FOCUSED           = $00000004;
    STATE_SYSTEM_PRESSED           = $00000008;
    STATE_SYSTEM_CHECKED           = $00000010;
    STATE_SYSTEM_MIXED             = $00000020;  // 3-state checkbox or toolbar button
    STATE_SYSTEM_READONLY          = $00000040;
    STATE_SYSTEM_HOTTRACKED        = $00000080;
    STATE_SYSTEM_DEFAULT           = $00000100;
    STATE_SYSTEM_EXPANDED          = $00000200;
    STATE_SYSTEM_COLLAPSED         = $00000400;
    STATE_SYSTEM_BUSY              = $00000800;
    STATE_SYSTEM_FLOATING          = $00001000;  // Children "owned" not "contained" by parent
    STATE_SYSTEM_MARQUEED          = $00002000;
    STATE_SYSTEM_ANIMATED          = $00004000;
    STATE_SYSTEM_INVISIBLE         = $00008000;
    STATE_SYSTEM_OFFSCREEN         = $00010000;
    STATE_SYSTEM_SIZEABLE          = $00020000;
    STATE_SYSTEM_MOVEABLE          = $00040000;
    STATE_SYSTEM_SELFVOICING       = $00080000;
    STATE_SYSTEM_FOCUSABLE         = $00100000;
    STATE_SYSTEM_SELECTABLE        = $00200000;
    STATE_SYSTEM_LINKED            = $00400000;
    STATE_SYSTEM_TRAVERSED         = $00800000;
    STATE_SYSTEM_MULTISELECTABLE   = $01000000;  // Supports multiple selection
    STATE_SYSTEM_EXTSELECTABLE     = $02000000;  // Supports extended selection
    STATE_SYSTEM_ALERT_LOW         = $04000000;  // This information is of low priority
    STATE_SYSTEM_ALERT_MEDIUM      = $08000000;  // This information is of medium priority
    STATE_SYSTEM_ALERT_HIGH        = $10000000;  // This information is of high priority
    STATE_SYSTEM_VALID             = $1FFFFFFF;

// Output from DISPID_ACC_ROLE
    ROLE_SYSTEM_TITLEBAR           = $00000001;
    ROLE_SYSTEM_MENUBAR            = $00000002;
    ROLE_SYSTEM_SCROLLBAR          = $00000003;
    ROLE_SYSTEM_GRIP               = $00000004;
    ROLE_SYSTEM_SOUND              = $00000005;
    ROLE_SYSTEM_CURSOR             = $00000006;
    ROLE_SYSTEM_CARET              = $00000007;
    ROLE_SYSTEM_ALERT              = $00000008;
    ROLE_SYSTEM_WINDOW             = $00000009;
    ROLE_SYSTEM_CLIENT             = $0000000A;
    ROLE_SYSTEM_MENUPOPUP          = $0000000B;
    ROLE_SYSTEM_MENUITEM           = $0000000C;
    ROLE_SYSTEM_TOOLTIP            = $0000000D;
    ROLE_SYSTEM_APPLICATION        = $0000000E;
    ROLE_SYSTEM_DOCUMENT           = $0000000F;
    ROLE_SYSTEM_PANE               = $00000010;
    ROLE_SYSTEM_CHART              = $00000011;
    ROLE_SYSTEM_DIALOG             = $00000012;
    ROLE_SYSTEM_BORDER             = $00000013;
    ROLE_SYSTEM_GROUPING           = $00000014;
    ROLE_SYSTEM_SEPARATOR          = $00000015;
    ROLE_SYSTEM_TOOLBAR            = $00000016;
    ROLE_SYSTEM_STATUSBAR          = $00000017;
    ROLE_SYSTEM_TABLE              = $00000018;
    ROLE_SYSTEM_COLUMNHEADER       = $00000019;
    ROLE_SYSTEM_ROWHEADER          = $0000001A;
    ROLE_SYSTEM_COLUMN             = $0000001B;
    ROLE_SYSTEM_ROW                = $0000001C;
    ROLE_SYSTEM_CELL               = $0000001D;
    ROLE_SYSTEM_LINK               = $0000001E;
    ROLE_SYSTEM_HELPBALLOON        = $0000001F;
    ROLE_SYSTEM_CHARACTER          = $00000020;
    ROLE_SYSTEM_LIST               = $00000021;
    ROLE_SYSTEM_LISTITEM           = $00000022;
    ROLE_SYSTEM_OUTLINE            = $00000023;
    ROLE_SYSTEM_OUTLINEITEM        = $00000024;
    ROLE_SYSTEM_PAGETAB            = $00000025;
    ROLE_SYSTEM_PROPERTYPAGE       = $00000026;
    ROLE_SYSTEM_INDICATOR          = $00000027;
    ROLE_SYSTEM_GRAPHIC            = $00000028;
    ROLE_SYSTEM_STATICTEXT         = $00000029;
    ROLE_SYSTEM_TEXT               = $0000002A;  // Editable, selectable, etc.
    ROLE_SYSTEM_PUSHBUTTON         = $0000002B;
    ROLE_SYSTEM_CHECKBUTTON        = $0000002C;
    ROLE_SYSTEM_RADIOBUTTON        = $0000002D;
    ROLE_SYSTEM_COMBOBOX           = $0000002E;
    ROLE_SYSTEM_DROPLIST           = $0000002F;
    ROLE_SYSTEM_PROGRESSBAR        = $00000030;
    ROLE_SYSTEM_DIAL               = $00000031;
    ROLE_SYSTEM_HOTKEYFIELD        = $00000032;
    ROLE_SYSTEM_SLIDER             = $00000033;
    ROLE_SYSTEM_SPINBUTTON         = $00000034;
    ROLE_SYSTEM_DIAGRAM            = $00000035;
    ROLE_SYSTEM_ANIMATION          = $00000036;
    ROLE_SYSTEM_EQUATION           = $00000037;
    ROLE_SYSTEM_BUTTONDROPDOWN     = $00000038;
    ROLE_SYSTEM_BUTTONMENU         = $00000039;
    ROLE_SYSTEM_BUTTONDROPDOWNGRID = $0000003A;
    ROLE_SYSTEM_WHITESPACE         = $0000003B;
    ROLE_SYSTEM_PAGETABLIST        = $0000003C;
    ROLE_SYSTEM_CLOCK              = $0000003D;

////////////////////////////////////////////////////////////////////////////
//  GUIDs (these GUIDs can be linked to from OLEACC.LIB)
//EXTERN_C __declspec(dllimport) const GUID     LIBID_Accessibility;
//EXTERN_C __declspec(dllimport) const IID      IID_IAccessible;
////////////////////////////////////////////////////////////////////////////

const
    LIBID_Accessibility:  TGUID = '{1EA4DBF0-3C3B-11CF-810C-00AA00389B71}';
    IID_IAccessible:      TGUID = '{618736E0-3C3D-11CF-810C-00AA00389B71}';

////////////////////////////////////////////////////////////////////////////
//  IAccessible definition
//  #define NO_ACCESSIBLE_INTERFACE if you need to include multiple header
//  files that define the IAccessible interface.
////////////////////////////////////////////////////////////////////////////

type
    Plongint = ^longint;
    BSTR = PWideChar;

    // originalmente a interface era toda em safecall

    IAccessible = interface (IDispatch)
       function get_accParent(out pdispParent: IDispatch): HRESULT; stdcall;
       function get_accChildCount(out countChildren: longint): HRESULT; stdcall;
       function get_accChild(varChildID: Variant; out ppdispChild: IDispatch): HRESULT; stdcall;

       function get_accName(varID: Variant; out pszName: BSTR): HRESULT; stdcall;
       function get_accValue(varID: Variant; out pszValue: BSTR): HRESULT; stdcall;
       function get_accDescription(varID: Variant; out pszDescription: BSTR): HRESULT; stdcall;
       function get_accRole(varID: Variant; out pvarRole: Variant): HRESULT; stdcall;
       function get_accState(varID: Variant; out pvarState: Variant): HRESULT; stdcall;

       function get_accHelp(varID: Variant; out pszHelp: BSTR): HRESULT; stdcall;
       function get_accHelpTopic(var pszHelpFile: BSTR; varChild: Variant; var pidTopic: longint): HRESULT; stdcall;
       function get_accKeyboardShortcut(varID: Variant; out pszKeyboardShortcut: BSTR): HRESULT; stdcall;

       function get_accFocus(out pvarID: Variant): HRESULT; stdcall;
       function get_accSelection(out pvarChildren: Variant): HRESULT; stdcall;

       function get_accDefaultAction(varID: Variant; out pszDefaultAction: BSTR): HRESULT; stdcall;

       function accSelect(flagsSelect: longint; varID: Variant): HRESULT; stdcall;
       function accLocation(out pxLeft, pyTop, pcxWidth, pcyHeight: longint; varID: Variant): HRESULT; stdcall;

       function accNavigate(navDir: longint; varStart: Variant; pvarEndUpAt: PVariant): HRESULT; stdcall;

       function accHitTest(xLeft, yTop: longint; out pvarID: Variant): HRESULT; stdcall;
       function accDoDefaultAction(varID: Variant): HRESULT; stdcall;
       function put_accName(varId: Variant; szName: BSTR): HRESULT; stdcall;
       function put_accValue(varID: Variant; pszValue: BSTR): HRESULT; stdcall;
    end;

////////////////////////////////////////////////////////////////////////////
//  Prototypes
////////////////////////////////////////////////////////////////////////////

function LresultFromObject(const riid: TIID; wParam: WPARAM;
         out pAcc: IUnknown): LRESULT;       stdcall; external 'OLEACC.DLL';
function ObjectFromLresult(lResult: LRESULT; const riid: TIID; wParam: WPARAM;
         out pvObject): LRESULT;   stdcall; external 'OLEACC.DLL';
function WindowFromAccessibleObject(pacc: IAccessible;
         out phwnd: HWND): LRESULT;          stdcall; external 'OLEACC.DLL';
function AccessibleObjectFromWindow(hwnd: HWND; dwId: DWORD; const riid: TIID;
         out ppacc: IAccessible): LRESULT;   stdcall; external 'OLEACC.DLL';
// originalmente         out ppvObject: pointer): LRESULT;   stdcall; external 'OLEACC.DLL';
function AccessibleObjectFromEvent(hwnd: HWND; dwId: DWORD; dwChildId: DWORD;
         out ppacc: IAccessible;
         out pvarChild: Variant): LRESULT;   stdcall; external 'OLEACC.DLL';
function AccessibleObjectFromPoint(ptScreen: TPOINT;
         out ppacc: IAccessible;
         out pvarChild: Variant): LRESULT;   stdcall; external 'OLEACC.DLL';
function CreateStdAccessibleObject(hwnd: HWND; idObject: longint; const riid: TIID;
         out ppvObject: pointer): LRESULT;   stdcall; external 'OLEACC.DLL';
function AccessibleChildren (paccContainer: IAccessible; iChildStart: longint;
	 cChildren: longint;
         out rgvarChildren: Variant;
         out pcObtained: longint): LRESULT;  stdcall; external 'OLEACC.DLL';

function GetRoleTextA(dwRole: DWORD; lpszRole: LPTSTR; cchRoleMax: UINT): UINT; stdcall; external 'OLEACC.DLL';
function GetRoleTextW(dwRole: DWORD; lpszRole: LPWSTR; cchRoleMax: UINT): UINT; stdcall; external 'OLEACC.DLL';
function GetRoleText(dwRole: DWORD; lpszRole: LPWSTR; cchRoleMax: UINT): UINT;
         stdcall; external 'OLEACC.DLL' name 'GetRoleTextW';

function GetStateTextA(lStateBit: DWORD; lpszState: LPSTR;  cchState: UINT): UINT; stdcall; external 'OLEACC.DLL';
function GetStateTextW(lStateBit: DWORD; lpszState: LPWSTR; cchState: UINT): UINT; stdcall; external 'OLEACC.DLL';
function GetStateText(lStateBit: DWORD; lpszState: LPWSTR; cchState: UINT): UINT;
         stdcall; external 'OLEACC.DLL' name 'GetStateTextW';

implementation
end.

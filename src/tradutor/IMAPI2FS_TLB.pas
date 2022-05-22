unit IMAPI2FS_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.130  $
// File generated on 13/12/2010 00:48:32 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\SYSTEM32\imapi2fs.dll (1)
// LIBID: {2C941FD0-975B-59BE-A960-9A2A262853A5}
// LCID: 0
// Helpfile: C:\WINDOWS\SYSTEM32\IMAPIv2.chm
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// Errors:
//   Hint: Parameter 'object' of DFileSystemImageEvents.Update changed to 'object_'
//   Hint: Member 'type' of 'tagSTATSTG' changed to 'type_'
//   Error creating palette bitmap of (TBootOptions) : Server C:\WINDOWS\system32\imapi2fs.dll contains no icons
//   Error creating palette bitmap of (TMsftFileSystemImage) : Server C:\WINDOWS\system32\imapi2fs.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses ActiveX, Classes, Graphics, OleServer, StdVCL, Variants, Windows;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  IMAPI2FSMajorVersion = 1;
  IMAPI2FSMinorVersion = 0;

  LIBID_IMAPI2FS: TGUID = '{2C941FD0-975B-59BE-A960-9A2A262853A5}';

  IID_DFileSystemImageEvents: TGUID = '{2C941FDF-975B-59BE-A960-9A2A262853A5}';
  IID_IBootOptions: TGUID = '{2C941FD4-975B-59BE-A960-9A2A262853A5}';
  CLASS_BootOptions: TGUID = '{2C941FCE-975B-59BE-A960-9A2A262853A5}';
  IID_ISequentialStream: TGUID = '{0C733A30-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IStream: TGUID = '{0000000C-0000-0000-C000-000000000046}';
  CLASS_FsiStream: TGUID = '{2C941FCD-975B-59BE-A960-9A2A262853A5}';
  IID_IFileSystemImageResult: TGUID = '{2C941FD8-975B-59BE-A960-9A2A262853A5}';
  CLASS_FileSystemImageResult: TGUID = '{2C941FCC-975B-59BE-A960-9A2A262853A5}';
  IID_IProgressItems: TGUID = '{2C941FD7-975B-59BE-A960-9A2A262853A5}';
  IID_IProgressItem: TGUID = '{2C941FD5-975B-59BE-A960-9A2A262853A5}';
  IID_IEnumProgressItems: TGUID = '{2C941FD6-975B-59BE-A960-9A2A262853A5}';
  CLASS_ProgressItem: TGUID = '{2C941FCB-975B-59BE-A960-9A2A262853A5}';
  CLASS_EnumProgressItems: TGUID = '{2C941FCA-975B-59BE-A960-9A2A262853A5}';
  CLASS_ProgressItems: TGUID = '{2C941FC9-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiItem: TGUID = '{2C941FD9-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiDirectoryItem: TGUID = '{2C941FDC-975B-59BE-A960-9A2A262853A5}';
  CLASS_FsiDirectoryItem: TGUID = '{2C941FC8-975B-59BE-A960-9A2A262853A5}';
  IID_IEnumFsiItems: TGUID = '{2C941FDA-975B-59BE-A960-9A2A262853A5}';
  IID_IFsiFileItem: TGUID = '{2C941FDB-975B-59BE-A960-9A2A262853A5}';
  CLASS_FsiFileItem: TGUID = '{2C941FC7-975B-59BE-A960-9A2A262853A5}';
  CLASS_EnumFsiItems: TGUID = '{2C941FC6-975B-59BE-A960-9A2A262853A5}';
  IID_IFileSystemImage: TGUID = '{2C941FE1-975B-59BE-A960-9A2A262853A5}';
  IID_IConnectionPointContainer: TGUID = '{B196B284-BAB4-101A-B69C-00AA00341D07}';
  IID_IDiscRecorder2: TGUID = '{27354133-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftFileSystemImage: TGUID = '{2C941FC5-975B-59BE-A960-9A2A262853A5}';
  IID_IEnumConnectionPoints: TGUID = '{B196B285-BAB4-101A-B69C-00AA00341D07}';
  IID_IConnectionPoint: TGUID = '{B196B286-BAB4-101A-B69C-00AA00341D07}';
  IID_IEnumConnections: TGUID = '{B196B287-BAB4-101A-B69C-00AA00341D07}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum PlatformId
type
  PlatformId = TOleEnum;
const
  PlatformX86 = $00000000;
  PlatformPowerPC = $00000001;
  PlatformMac = $00000002;

// Constants for enum EmulationType
type
  EmulationType = TOleEnum;
const
  EmulationNone = $00000000;
  Emulation12MFloppy = $00000001;
  Emulation144MFloppy = $00000002;
  Emulation288MFloppy = $00000003;
  EmulationHardDisk = $00000004;

// Constants for enum FsiFileSystems
type
  FsiFileSystems = TOleEnum;
const
  FsiFileSystemNone = $00000000;
  FsiFileSystemISO9660 = $00000001;
  FsiFileSystemJoliet = $00000002;
  FsiFileSystemUDF = $00000004;
  FsiFileSystemUnknown = $40000000;

// Constants for enum _IMAPI_MEDIA_PHYSICAL_TYPE
type
  _IMAPI_MEDIA_PHYSICAL_TYPE = TOleEnum;
const
  IMAPI_MEDIA_TYPE_UNKNOWN = $00000000;
  IMAPI_MEDIA_TYPE_CDROM = $00000001;
  IMAPI_MEDIA_TYPE_CDR = $00000002;
  IMAPI_MEDIA_TYPE_CDRW = $00000003;
  IMAPI_MEDIA_TYPE_DVDROM = $00000004;
  IMAPI_MEDIA_TYPE_DVDRAM = $00000005;
  IMAPI_MEDIA_TYPE_DVDPLUSR = $00000006;
  IMAPI_MEDIA_TYPE_DVDPLUSRW = $00000007;
  IMAPI_MEDIA_TYPE_DVDPLUSR_DUALLAYER = $00000008;
  IMAPI_MEDIA_TYPE_DVDDASHR = $00000009;
  IMAPI_MEDIA_TYPE_DVDDASHRW = $0000000A;
  IMAPI_MEDIA_TYPE_DVDDASHR_DUALLAYER = $0000000B;
  IMAPI_MEDIA_TYPE_DISK = $0000000C;
  IMAPI_MEDIA_TYPE_DVDPLUSRW_DUALLAYER = $0000000D;
  IMAPI_MEDIA_TYPE_HDDVDROM = $0000000E;
  IMAPI_MEDIA_TYPE_HDDVDR = $0000000F;
  IMAPI_MEDIA_TYPE_HDDVDRAM = $00000010;
  IMAPI_MEDIA_TYPE_BDROM = $00000011;
  IMAPI_MEDIA_TYPE_BDR = $00000012;
  IMAPI_MEDIA_TYPE_BDRE = $00000013;
  IMAPI_MEDIA_TYPE_MAX = $00000013;

// Constants for enum FsiItemType
type
  FsiItemType = TOleEnum;
const
  FsiItemNotFound = $00000000;
  FsiItemDirectory = $00000001;
  FsiItemFile = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  DFileSystemImageEvents = interface;
  IBootOptions = interface;
  IBootOptionsDisp = dispinterface;
  ISequentialStream = interface;
  IStream = interface;
  IFileSystemImageResult = interface;
  IFileSystemImageResultDisp = dispinterface;
  IProgressItems = interface;
  IProgressItemsDisp = dispinterface;
  IProgressItem = interface;
  IProgressItemDisp = dispinterface;
  IEnumProgressItems = interface;
  IFsiItem = interface;
  IFsiItemDisp = dispinterface;
  IFsiDirectoryItem = interface;
  IFsiDirectoryItemDisp = dispinterface;
  IEnumFsiItems = interface;
  IFsiFileItem = interface;
  IFsiFileItemDisp = dispinterface;
  IFileSystemImage = interface;
  IFileSystemImageDisp = dispinterface;
  IConnectionPointContainer = interface;
  IDiscRecorder2 = interface;
  IDiscRecorder2Disp = dispinterface;
  IEnumConnectionPoints = interface;
  IConnectionPoint = interface;
  IEnumConnections = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  BootOptions = IBootOptions;
  FsiStream = ISequentialStream;
  FileSystemImageResult = IFileSystemImageResult;
  ProgressItem = IProgressItem;
  EnumProgressItems = IEnumProgressItems;
  ProgressItems = IProgressItems;
  FsiDirectoryItem = IFsiItem;
  FsiFileItem = IFsiFileItem;
  EnumFsiItems = IEnumFsiItems;
  MsftFileSystemImage = IFileSystemImage;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PByte1 = ^Byte; {*}
  PUserType1 = ^TGUID; {*}

  _LARGE_INTEGER = packed record
    QuadPart: Int64;
  end;

  _ULARGE_INTEGER = packed record
    QuadPart: Largeuint;
  end;

  _FILETIME = packed record
    dwLowDateTime: LongWord;
    dwHighDateTime: LongWord;
  end;

  tagSTATSTG = packed record
    pwcsName: PWideChar;
    type_: LongWord;
    cbSize: _ULARGE_INTEGER;
    mtime: _FILETIME;
    ctime: _FILETIME;
    atime: _FILETIME;
    grfMode: LongWord;
    grfLocksSupported: LongWord;
    clsid: TGUID;
    grfStateBits: LongWord;
    reserved: LongWord;
  end;

  IMAPI_MEDIA_PHYSICAL_TYPE = _IMAPI_MEDIA_PHYSICAL_TYPE; 

  tagCONNECTDATA = packed record
    pUnk: IUnknown;
    dwCookie: LongWord;
  end;


// *********************************************************************//
// Interface: DFileSystemImageEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FDF-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  DFileSystemImageEvents = interface(IDispatch)
    ['{2C941FDF-975B-59BE-A960-9A2A262853A5}']
    function  Update(const object_: IDispatch; const currentFile: WideString; 
                     copiedSectors: Integer; totalSectors: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBootOptions
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD4-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IBootOptions = interface(IDispatch)
    ['{2C941FD4-975B-59BE-A960-9A2A262853A5}']
    function  Get_BootImage: ISequentialStream; safecall;
    function  Get_Manufacturer: WideString; safecall;
    procedure Set_Manufacturer(const pVal: WideString); safecall;
    function  Get_PlatformId: PlatformId; safecall;
    procedure Set_PlatformId(pVal: PlatformId); safecall;
    function  Get_Emulation: EmulationType; safecall;
    procedure Set_Emulation(pVal: EmulationType); safecall;
    function  Get_ImageSize: LongWord; safecall;
    procedure AssignBootImage(const newVal: ISequentialStream); safecall;
    property BootImage: ISequentialStream read Get_BootImage;
    property Manufacturer: WideString read Get_Manufacturer write Set_Manufacturer;
    property PlatformId: PlatformId read Get_PlatformId write Set_PlatformId;
    property Emulation: EmulationType read Get_Emulation write Set_Emulation;
    property ImageSize: LongWord read Get_ImageSize;
  end;

// *********************************************************************//
// DispIntf:  IBootOptionsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD4-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IBootOptionsDisp = dispinterface
    ['{2C941FD4-975B-59BE-A960-9A2A262853A5}']
    property BootImage: ISequentialStream readonly dispid 1;
    property Manufacturer: WideString dispid 2;
    property PlatformId: PlatformId dispid 3;
    property Emulation: EmulationType dispid 4;
    property ImageSize: LongWord readonly dispid 5;
    procedure AssignBootImage(const newVal: ISequentialStream); dispid 20;
  end;

// *********************************************************************//
// Interface: ISequentialStream
// Flags:     (0)
// GUID:      {0C733A30-2A1C-11CE-ADE5-00AA0044773D}
// *********************************************************************//
  ISequentialStream = interface(IUnknown)
    ['{0C733A30-2A1C-11CE-ADE5-00AA0044773D}']
    function  RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult; stdcall;
    function  RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IStream
// Flags:     (0)
// GUID:      {0000000C-0000-0000-C000-000000000046}
// *********************************************************************//
  IStream = interface(ISequentialStream)
    ['{0000000C-0000-0000-C000-000000000046}']
    function  RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                         out plibNewPosition: _ULARGE_INTEGER): HResult; stdcall;
    function  SetSize(libNewSize: _ULARGE_INTEGER): HResult; stdcall;
    function  RemoteCopyTo(const pstm: ISequentialStream; cb: _ULARGE_INTEGER; 
                           out pcbRead: _ULARGE_INTEGER; out pcbWritten: _ULARGE_INTEGER): HResult; stdcall;
    function  Commit(grfCommitFlags: LongWord): HResult; stdcall;
    function  Revert: HResult; stdcall;
    function  LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult; stdcall;
    function  UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult; stdcall;
    function  Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult; stdcall;
    function  Clone(out ppstm: ISequentialStream): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFileSystemImageResult
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD8-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFileSystemImageResult = interface(IDispatch)
    ['{2C941FD8-975B-59BE-A960-9A2A262853A5}']
    function  Get_ImageStream: ISequentialStream; safecall;
    function  Get_ProgressItems: IProgressItems; safecall;
    function  Get_TotalBlocks: Integer; safecall;
    function  Get_BlockSize: Integer; safecall;
    function  Get_DiscId: WideString; safecall;
    property ImageStream: ISequentialStream read Get_ImageStream;
    property ProgressItems: IProgressItems read Get_ProgressItems;
    property TotalBlocks: Integer read Get_TotalBlocks;
    property BlockSize: Integer read Get_BlockSize;
    property DiscId: WideString read Get_DiscId;
  end;

// *********************************************************************//
// DispIntf:  IFileSystemImageResultDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD8-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFileSystemImageResultDisp = dispinterface
    ['{2C941FD8-975B-59BE-A960-9A2A262853A5}']
    property ImageStream: ISequentialStream readonly dispid 1;
    property ProgressItems: IProgressItems readonly dispid 2;
    property TotalBlocks: Integer readonly dispid 3;
    property BlockSize: Integer readonly dispid 4;
    property DiscId: WideString readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IProgressItems
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD7-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IProgressItems = interface(IDispatch)
    ['{2C941FD7-975B-59BE-A960-9A2A262853A5}']
    function  Get__NewEnum: IEnumVARIANT; safecall;
    function  Get_Item(Index: Integer): IProgressItem; safecall;
    function  Get_Count: Integer; safecall;
    function  ProgressItemFromBlock(block: LongWord): IProgressItem; safecall;
    function  ProgressItemFromDescription(const Description: WideString): IProgressItem; safecall;
    function  Get_EnumProgressItems: IEnumProgressItems; safecall;
    property _NewEnum: IEnumVARIANT read Get__NewEnum;
    property Item[Index: Integer]: IProgressItem read Get_Item; default;
    property Count: Integer read Get_Count;
    property EnumProgressItems: IEnumProgressItems read Get_EnumProgressItems;
  end;

// *********************************************************************//
// DispIntf:  IProgressItemsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD7-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IProgressItemsDisp = dispinterface
    ['{2C941FD7-975B-59BE-A960-9A2A262853A5}']
    property _NewEnum: IEnumVARIANT readonly dispid -4;
    property Item[Index: Integer]: IProgressItem readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    function  ProgressItemFromBlock(block: LongWord): IProgressItem; dispid 2;
    function  ProgressItemFromDescription(const Description: WideString): IProgressItem; dispid 3;
    property EnumProgressItems: IEnumProgressItems readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IProgressItem
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD5-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IProgressItem = interface(IDispatch)
    ['{2C941FD5-975B-59BE-A960-9A2A262853A5}']
    function  Get_Description: WideString; safecall;
    function  Get_FirstBlock: LongWord; safecall;
    function  Get_LastBlock: LongWord; safecall;
    function  Get_BlockCount: LongWord; safecall;
    property Description: WideString read Get_Description;
    property FirstBlock: LongWord read Get_FirstBlock;
    property LastBlock: LongWord read Get_LastBlock;
    property BlockCount: LongWord read Get_BlockCount;
  end;

// *********************************************************************//
// DispIntf:  IProgressItemDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD5-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IProgressItemDisp = dispinterface
    ['{2C941FD5-975B-59BE-A960-9A2A262853A5}']
    property Description: WideString readonly dispid 1;
    property FirstBlock: LongWord readonly dispid 2;
    property LastBlock: LongWord readonly dispid 3;
    property BlockCount: LongWord readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IEnumProgressItems
// Flags:     (0)
// GUID:      {2C941FD6-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IEnumProgressItems = interface(IUnknown)
    ['{2C941FD6-975B-59BE-A960-9A2A262853A5}']
    function  RemoteNext(celt: LongWord; out rgelt: IProgressItem; out pceltFetched: LongWord): HResult; stdcall;
    function  Skip(celt: LongWord): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out ppEnum: IEnumProgressItems): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFsiItem
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD9-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiItem = interface(IDispatch)
    ['{2C941FD9-975B-59BE-A960-9A2A262853A5}']
    function  Get_Name: WideString; safecall;
    function  Get_FullPath: WideString; safecall;
    function  Get_CreationTime: TDateTime; safecall;
    procedure Set_CreationTime(pVal: TDateTime); safecall;
    function  Get_LastAccessedTime: TDateTime; safecall;
    procedure Set_LastAccessedTime(pVal: TDateTime); safecall;
    function  Get_LastModifiedTime: TDateTime; safecall;
    procedure Set_LastModifiedTime(pVal: TDateTime); safecall;
    function  Get_IsHidden: WordBool; safecall;
    procedure Set_IsHidden(pVal: WordBool); safecall;
    function  FileSystemName(fileSystem: FsiFileSystems): WideString; safecall;
    function  FileSystemPath(fileSystem: FsiFileSystems): WideString; safecall;
    property Name: WideString read Get_Name;
    property FullPath: WideString read Get_FullPath;
    property CreationTime: TDateTime read Get_CreationTime write Set_CreationTime;
    property LastAccessedTime: TDateTime read Get_LastAccessedTime write Set_LastAccessedTime;
    property LastModifiedTime: TDateTime read Get_LastModifiedTime write Set_LastModifiedTime;
    property IsHidden: WordBool read Get_IsHidden write Set_IsHidden;
  end;

// *********************************************************************//
// DispIntf:  IFsiItemDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FD9-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiItemDisp = dispinterface
    ['{2C941FD9-975B-59BE-A960-9A2A262853A5}']
    property Name: WideString readonly dispid 11;
    property FullPath: WideString readonly dispid 12;
    property CreationTime: TDateTime dispid 13;
    property LastAccessedTime: TDateTime dispid 14;
    property LastModifiedTime: TDateTime dispid 15;
    property IsHidden: WordBool dispid 16;
    function  FileSystemName(fileSystem: FsiFileSystems): WideString; dispid 17;
    function  FileSystemPath(fileSystem: FsiFileSystems): WideString; dispid 18;
  end;

// *********************************************************************//
// Interface: IFsiDirectoryItem
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FDC-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiDirectoryItem = interface(IFsiItem)
    ['{2C941FDC-975B-59BE-A960-9A2A262853A5}']
    function  Get__NewEnum: IEnumVARIANT; safecall;
    function  Get_Item(const path: WideString): IFsiDirectoryItem; safecall;
    function  Get_Count: Integer; safecall;
    function  Get_EnumFsiItems: IEnumFsiItems; safecall;
    procedure AddDirectory(const path: WideString); safecall;
    procedure AddFile(const path: WideString; const fileData: ISequentialStream); safecall;
    procedure AddTree(const sourceDirectory: WideString; includeBaseDirectory: WordBool); safecall;
    procedure Add(const Item: IFsiDirectoryItem); safecall;
    procedure Remove(const path: WideString); safecall;
    procedure RemoveTree(const path: WideString); safecall;
    property _NewEnum: IEnumVARIANT read Get__NewEnum;
    property Item[const path: WideString]: IFsiDirectoryItem read Get_Item; default;
    property Count: Integer read Get_Count;
    property EnumFsiItems: IEnumFsiItems read Get_EnumFsiItems;
  end;

// *********************************************************************//
// DispIntf:  IFsiDirectoryItemDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FDC-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiDirectoryItemDisp = dispinterface
    ['{2C941FDC-975B-59BE-A960-9A2A262853A5}']
    property _NewEnum: IEnumVARIANT readonly dispid -4;
    property Item[const path: WideString]: IFsiDirectoryItem readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property EnumFsiItems: IEnumFsiItems readonly dispid 2;
    procedure AddDirectory(const path: WideString); dispid 30;
    procedure AddFile(const path: WideString; const fileData: ISequentialStream); dispid 31;
    procedure AddTree(const sourceDirectory: WideString; includeBaseDirectory: WordBool); dispid 32;
    procedure Add(const Item: IFsiDirectoryItem); dispid 33;
    procedure Remove(const path: WideString); dispid 34;
    procedure RemoveTree(const path: WideString); dispid 35;
    property Name: WideString readonly dispid 11;
    property FullPath: WideString readonly dispid 12;
    property CreationTime: TDateTime dispid 13;
    property LastAccessedTime: TDateTime dispid 14;
    property LastModifiedTime: TDateTime dispid 15;
    property IsHidden: WordBool dispid 16;
    function  FileSystemName(fileSystem: FsiFileSystems): WideString; dispid 17;
    function  FileSystemPath(fileSystem: FsiFileSystems): WideString; dispid 18;
  end;

// *********************************************************************//
// Interface: IEnumFsiItems
// Flags:     (0)
// GUID:      {2C941FDA-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IEnumFsiItems = interface(IUnknown)
    ['{2C941FDA-975B-59BE-A960-9A2A262853A5}']
    function  RemoteNext(celt: LongWord; out rgelt: IFsiDirectoryItem; out pceltFetched: LongWord): HResult; stdcall;
    function  Skip(celt: LongWord): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out ppEnum: IEnumFsiItems): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFsiFileItem
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FDB-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiFileItem = interface(IFsiItem)
    ['{2C941FDB-975B-59BE-A960-9A2A262853A5}']
    function  Get_DataSize: Int64; safecall;
    function  Get_DataSize32BitLow: Integer; safecall;
    function  Get_DataSize32BitHigh: Integer; safecall;
    function  Get_Data: ISequentialStream; safecall;
    procedure Set_Data(const pVal: ISequentialStream); safecall;
    property DataSize: Int64 read Get_DataSize;
    property DataSize32BitLow: Integer read Get_DataSize32BitLow;
    property DataSize32BitHigh: Integer read Get_DataSize32BitHigh;
    property Data: ISequentialStream read Get_Data write Set_Data;
  end;

// *********************************************************************//
// DispIntf:  IFsiFileItemDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FDB-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFsiFileItemDisp = dispinterface
    ['{2C941FDB-975B-59BE-A960-9A2A262853A5}']
    property DataSize: {??Int64}OleVariant readonly dispid 41;
    property DataSize32BitLow: Integer readonly dispid 42;
    property DataSize32BitHigh: Integer readonly dispid 43;
    property Data: ISequentialStream dispid 44;
    property Name: WideString readonly dispid 11;
    property FullPath: WideString readonly dispid 12;
    property CreationTime: TDateTime dispid 13;
    property LastAccessedTime: TDateTime dispid 14;
    property LastModifiedTime: TDateTime dispid 15;
    property IsHidden: WordBool dispid 16;
    function  FileSystemName(fileSystem: FsiFileSystems): WideString; dispid 17;
    function  FileSystemPath(fileSystem: FsiFileSystems): WideString; dispid 18;
  end;

// *********************************************************************//
// Interface: IFileSystemImage
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FE1-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFileSystemImage = interface(IDispatch)
    ['{2C941FE1-975B-59BE-A960-9A2A262853A5}']
    function  Get_Root: IFsiItem; safecall;
    function  Get_SessionStartBlock: Integer; safecall;
    procedure Set_SessionStartBlock(pVal: Integer); safecall;
    function  Get_FreeMediaBlocks: Integer; safecall;
    procedure Set_FreeMediaBlocks(pVal: Integer); safecall;
    procedure SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2); safecall;
    function  Get_UsedBlocks: Integer; safecall;
    function  Get_VolumeName: WideString; safecall;
    procedure Set_VolumeName(const pVal: WideString); safecall;
    function  Get_ImportedVolumeName: WideString; safecall;
    function  Get_BootImageOptions: IBootOptions; safecall;
    procedure Set_BootImageOptions(const pVal: IBootOptions); safecall;
    function  Get_FileCount: Integer; safecall;
    function  Get_DirectoryCount: Integer; safecall;
    function  Get_WorkingDirectory: WideString; safecall;
    procedure Set_WorkingDirectory(const pVal: WideString); safecall;
    function  Get_ChangePoint: Integer; safecall;
    function  Get_StrictFileSystemCompliance: WordBool; safecall;
    procedure Set_StrictFileSystemCompliance(pVal: WordBool); safecall;
    function  Get_UseRestrictedCharacterSet: WordBool; safecall;
    procedure Set_UseRestrictedCharacterSet(pVal: WordBool); safecall;
    function  Get_FileSystemsToCreate: FsiFileSystems; safecall;
    procedure Set_FileSystemsToCreate(pVal: FsiFileSystems); safecall;
    function  Get_FileSystemsSupported: FsiFileSystems; safecall;
    procedure Set_UDFRevision(pVal: Integer); safecall;
    function  Get_UDFRevision: Integer; safecall;
    function  Get_UDFRevisionsSupported: PSafeArray; safecall;
    procedure ChooseImageDefaults(const discRecorder: IDiscRecorder2); safecall;
    procedure ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE); safecall;
    procedure Set_ISO9660InterchangeLevel(pVal: Integer); safecall;
    function  Get_ISO9660InterchangeLevel: Integer; safecall;
    function  Get_ISO9660InterchangeLevelsSupported: PSafeArray; safecall;
    function  CreateResultImage: IFileSystemImageResult; safecall;
    function  Exists(const FullPath: WideString): FsiItemType; safecall;
    function  CalculateDiscIdentifier: WideString; safecall;
    function  IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems; safecall;
    function  GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems; safecall;
    function  ImportFileSystem: FsiFileSystems; safecall;
    procedure ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems); safecall;
    procedure RollbackToChangePoint(ChangePoint: Integer); safecall;
    procedure LockInChangePoint; safecall;
    function  CreateDirectoryItem(const Name: WideString): IFsiItem; safecall;
    function  CreateFileItem(const Name: WideString): IFsiFileItem; safecall;
    function  Get_VolumeNameUDF: WideString; safecall;
    function  Get_VolumeNameJoliet: WideString; safecall;
    function  Get_VolumeNameISO9660: WideString; safecall;
    function  Get_StageFiles: WordBool; safecall;
    procedure Set_StageFiles(pVal: WordBool); safecall;
    function  Get_MultisessionInterfaces: PSafeArray; safecall;
    procedure Set_MultisessionInterfaces(pVal: PSafeArray); safecall;
    property Root: IFsiItem read Get_Root;
    property SessionStartBlock: Integer read Get_SessionStartBlock write Set_SessionStartBlock;
    property FreeMediaBlocks: Integer read Get_FreeMediaBlocks write Set_FreeMediaBlocks;
    property UsedBlocks: Integer read Get_UsedBlocks;
    property VolumeName: WideString read Get_VolumeName write Set_VolumeName;
    property ImportedVolumeName: WideString read Get_ImportedVolumeName;
    property BootImageOptions: IBootOptions read Get_BootImageOptions write Set_BootImageOptions;
    property FileCount: Integer read Get_FileCount;
    property DirectoryCount: Integer read Get_DirectoryCount;
    property WorkingDirectory: WideString read Get_WorkingDirectory write Set_WorkingDirectory;
    property ChangePoint: Integer read Get_ChangePoint;
    property StrictFileSystemCompliance: WordBool read Get_StrictFileSystemCompliance write Set_StrictFileSystemCompliance;
    property UseRestrictedCharacterSet: WordBool read Get_UseRestrictedCharacterSet write Set_UseRestrictedCharacterSet;
    property FileSystemsToCreate: FsiFileSystems read Get_FileSystemsToCreate write Set_FileSystemsToCreate;
    property FileSystemsSupported: FsiFileSystems read Get_FileSystemsSupported;
    property UDFRevision: Integer read Get_UDFRevision write Set_UDFRevision;
    property UDFRevisionsSupported: PSafeArray read Get_UDFRevisionsSupported;
    property ISO9660InterchangeLevel: Integer read Get_ISO9660InterchangeLevel write Set_ISO9660InterchangeLevel;
    property ISO9660InterchangeLevelsSupported: PSafeArray read Get_ISO9660InterchangeLevelsSupported;
    property VolumeNameUDF: WideString read Get_VolumeNameUDF;
    property VolumeNameJoliet: WideString read Get_VolumeNameJoliet;
    property VolumeNameISO9660: WideString read Get_VolumeNameISO9660;
    property StageFiles: WordBool read Get_StageFiles write Set_StageFiles;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces write Set_MultisessionInterfaces;
  end;

// *********************************************************************//
// DispIntf:  IFileSystemImageDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2C941FE1-975B-59BE-A960-9A2A262853A5}
// *********************************************************************//
  IFileSystemImageDisp = dispinterface
    ['{2C941FE1-975B-59BE-A960-9A2A262853A5}']
    property Root: IFsiItem readonly dispid 0;
    property SessionStartBlock: Integer dispid 1;
    property FreeMediaBlocks: Integer dispid 2;
    procedure SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2); dispid 36;
    property UsedBlocks: Integer readonly dispid 3;
    property VolumeName: WideString dispid 4;
    property ImportedVolumeName: WideString readonly dispid 5;
    property BootImageOptions: IBootOptions dispid 6;
    property FileCount: Integer readonly dispid 7;
    property DirectoryCount: Integer readonly dispid 8;
    property WorkingDirectory: WideString dispid 9;
    property ChangePoint: Integer readonly dispid 10;
    property StrictFileSystemCompliance: WordBool dispid 11;
    property UseRestrictedCharacterSet: WordBool dispid 12;
    property FileSystemsToCreate: FsiFileSystems dispid 13;
    property FileSystemsSupported: FsiFileSystems readonly dispid 14;
    property UDFRevision: Integer dispid 37;
    property UDFRevisionsSupported: {??PSafeArray}OleVariant readonly dispid 31;
    procedure ChooseImageDefaults(const discRecorder: IDiscRecorder2); dispid 32;
    procedure ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE); dispid 33;
    property ISO9660InterchangeLevel: Integer dispid 34;
    property ISO9660InterchangeLevelsSupported: {??PSafeArray}OleVariant readonly dispid 38;
    function  CreateResultImage: IFileSystemImageResult; dispid 15;
    function  Exists(const FullPath: WideString): FsiItemType; dispid 16;
    function  CalculateDiscIdentifier: WideString; dispid 18;
    function  IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems; dispid 19;
    function  GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems; dispid 20;
    function  ImportFileSystem: FsiFileSystems; dispid 21;
    procedure ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems); dispid 22;
    procedure RollbackToChangePoint(ChangePoint: Integer); dispid 23;
    procedure LockInChangePoint; dispid 24;
    function  CreateDirectoryItem(const Name: WideString): IFsiItem; dispid 25;
    function  CreateFileItem(const Name: WideString): IFsiFileItem; dispid 26;
    property VolumeNameUDF: WideString readonly dispid 27;
    property VolumeNameJoliet: WideString readonly dispid 28;
    property VolumeNameISO9660: WideString readonly dispid 29;
    property StageFiles: WordBool dispid 30;
    property MultisessionInterfaces: {??PSafeArray}OleVariant dispid 40;
  end;

// *********************************************************************//
// Interface: IConnectionPointContainer
// Flags:     (0)
// GUID:      {B196B284-BAB4-101A-B69C-00AA00341D07}
// *********************************************************************//
  IConnectionPointContainer = interface(IUnknown)
    ['{B196B284-BAB4-101A-B69C-00AA00341D07}']
    function  EnumConnectionPoints(out ppEnum: IEnumConnectionPoints): HResult; stdcall;
    function  FindConnectionPoint(var riid: TGUID; out ppCP: IConnectionPoint): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDiscRecorder2
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354133-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscRecorder2 = interface(IDispatch)
    ['{27354133-7F64-5B0F-8F00-5D77AFBE261E}']
    procedure EjectMedia; safecall;
    procedure CloseTray; safecall;
    procedure AcquireExclusiveAccess(force: WordBool; const __MIDL_0015: WideString); safecall;
    procedure ReleaseExclusiveAccess; safecall;
    procedure DisableMcn; safecall;
    procedure EnableMcn; safecall;
    procedure InitializeDiscRecorder(const recorderUniqueId: WideString); safecall;
    function  Get_ActiveDiscRecorder: WideString; safecall;
    function  Get_VendorId: WideString; safecall;
    function  Get_ProductId: WideString; safecall;
    function  Get_ProductRevision: WideString; safecall;
    function  Get_VolumeName: WideString; safecall;
    function  Get_VolumePathNames: PSafeArray; safecall;
    function  Get_DeviceCanLoadMedia: WordBool; safecall;
    function  Get_LegacyDeviceNumber: Integer; safecall;
    function  Get_SupportedFeaturePages: PSafeArray; safecall;
    function  Get_CurrentFeaturePages: PSafeArray; safecall;
    function  Get_SupportedProfiles: PSafeArray; safecall;
    function  Get_CurrentProfiles: PSafeArray; safecall;
    function  Get_SupportedModePages: PSafeArray; safecall;
    function  Get_ExclusiveAccessOwner: WideString; safecall;
    property ActiveDiscRecorder: WideString read Get_ActiveDiscRecorder;
    property VendorId: WideString read Get_VendorId;
    property ProductId: WideString read Get_ProductId;
    property ProductRevision: WideString read Get_ProductRevision;
    property VolumeName: WideString read Get_VolumeName;
    property VolumePathNames: PSafeArray read Get_VolumePathNames;
    property DeviceCanLoadMedia: WordBool read Get_DeviceCanLoadMedia;
    property LegacyDeviceNumber: Integer read Get_LegacyDeviceNumber;
    property SupportedFeaturePages: PSafeArray read Get_SupportedFeaturePages;
    property CurrentFeaturePages: PSafeArray read Get_CurrentFeaturePages;
    property SupportedProfiles: PSafeArray read Get_SupportedProfiles;
    property CurrentProfiles: PSafeArray read Get_CurrentProfiles;
    property SupportedModePages: PSafeArray read Get_SupportedModePages;
    property ExclusiveAccessOwner: WideString read Get_ExclusiveAccessOwner;
  end;

// *********************************************************************//
// DispIntf:  IDiscRecorder2Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354133-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscRecorder2Disp = dispinterface
    ['{27354133-7F64-5B0F-8F00-5D77AFBE261E}']
    procedure EjectMedia; dispid 256;
    procedure CloseTray; dispid 257;
    procedure AcquireExclusiveAccess(force: WordBool; const __MIDL_0015: WideString); dispid 258;
    procedure ReleaseExclusiveAccess; dispid 259;
    procedure DisableMcn; dispid 260;
    procedure EnableMcn; dispid 261;
    procedure InitializeDiscRecorder(const recorderUniqueId: WideString); dispid 262;
    property ActiveDiscRecorder: WideString readonly dispid 0;
    property VendorId: WideString readonly dispid 513;
    property ProductId: WideString readonly dispid 514;
    property ProductRevision: WideString readonly dispid 515;
    property VolumeName: WideString readonly dispid 516;
    property VolumePathNames: {??PSafeArray}OleVariant readonly dispid 517;
    property DeviceCanLoadMedia: WordBool readonly dispid 518;
    property LegacyDeviceNumber: Integer readonly dispid 519;
    property SupportedFeaturePages: {??PSafeArray}OleVariant readonly dispid 520;
    property CurrentFeaturePages: {??PSafeArray}OleVariant readonly dispid 521;
    property SupportedProfiles: {??PSafeArray}OleVariant readonly dispid 522;
    property CurrentProfiles: {??PSafeArray}OleVariant readonly dispid 523;
    property SupportedModePages: {??PSafeArray}OleVariant readonly dispid 524;
    property ExclusiveAccessOwner: WideString readonly dispid 525;
  end;

// *********************************************************************//
// Interface: IEnumConnectionPoints
// Flags:     (0)
// GUID:      {B196B285-BAB4-101A-B69C-00AA00341D07}
// *********************************************************************//
  IEnumConnectionPoints = interface(IUnknown)
    ['{B196B285-BAB4-101A-B69C-00AA00341D07}']
    function  RemoteNext(cConnections: LongWord; out ppCP: IConnectionPoint; out pcFetched: LongWord): HResult; stdcall;
    function  Skip(cConnections: LongWord): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out ppEnum: IEnumConnectionPoints): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IConnectionPoint
// Flags:     (0)
// GUID:      {B196B286-BAB4-101A-B69C-00AA00341D07}
// *********************************************************************//
  IConnectionPoint = interface(IUnknown)
    ['{B196B286-BAB4-101A-B69C-00AA00341D07}']
    function  GetConnectionInterface(out pIID: TGUID): HResult; stdcall;
    function  GetConnectionPointContainer(out ppCPC: IConnectionPointContainer): HResult; stdcall;
    function  Advise(const pUnkSink: IUnknown; out pdwCookie: LongWord): HResult; stdcall;
    function  Unadvise(dwCookie: LongWord): HResult; stdcall;
    function  EnumConnections(out ppEnum: IEnumConnections): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumConnections
// Flags:     (0)
// GUID:      {B196B287-BAB4-101A-B69C-00AA00341D07}
// *********************************************************************//
  IEnumConnections = interface(IUnknown)
    ['{B196B287-BAB4-101A-B69C-00AA00341D07}']
    function  RemoteNext(cConnections: LongWord; out rgcd: tagCONNECTDATA; out pcFetched: LongWord): HResult; stdcall;
    function  Skip(cConnections: LongWord): HResult; stdcall;
    function  Reset: HResult; stdcall;
    function  Clone(out ppEnum: IEnumConnections): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoBootOptions provides a Create and CreateRemote method to          
// create instances of the default interface IBootOptions exposed by              
// the CoClass BootOptions. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoBootOptions = class
    class function Create: IBootOptions;
    class function CreateRemote(const MachineName: string): IBootOptions;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TBootOptions
// Help String      : Boot options
// Default Interface: IBootOptions
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TBootOptionsProperties= class;
{$ENDIF}
  TBootOptions = class(TOleServer)
  private
    FIntf:        IBootOptions;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TBootOptionsProperties;
    function      GetServerProperties: TBootOptionsProperties;
{$ENDIF}
    function      GetDefaultInterface: IBootOptions;
  protected
    procedure InitServerData; override;
    function  Get_BootImage: ISequentialStream;
    function  Get_Manufacturer: WideString;
    procedure Set_Manufacturer(const pVal: WideString);
    function  Get_PlatformId: PlatformId;
    procedure Set_PlatformId(pVal: PlatformId);
    function  Get_Emulation: EmulationType;
    procedure Set_Emulation(pVal: EmulationType);
    function  Get_ImageSize: LongWord;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBootOptions);
    procedure Disconnect; override;
    procedure AssignBootImage(const newVal: ISequentialStream);
    property  DefaultInterface: IBootOptions read GetDefaultInterface;
    property BootImage: ISequentialStream read Get_BootImage;
    property ImageSize: LongWord read Get_ImageSize;
    property Manufacturer: WideString read Get_Manufacturer write Set_Manufacturer;
    property PlatformId: PlatformId read Get_PlatformId write Set_PlatformId;
    property Emulation: EmulationType read Get_Emulation write Set_Emulation;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TBootOptionsProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TBootOptions
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TBootOptionsProperties = class(TPersistent)
  private
    FServer:    TBootOptions;
    function    GetDefaultInterface: IBootOptions;
    constructor Create(AServer: TBootOptions);
  protected
    function  Get_BootImage: ISequentialStream;
    function  Get_Manufacturer: WideString;
    procedure Set_Manufacturer(const pVal: WideString);
    function  Get_PlatformId: PlatformId;
    procedure Set_PlatformId(pVal: PlatformId);
    function  Get_Emulation: EmulationType;
    procedure Set_Emulation(pVal: EmulationType);
    function  Get_ImageSize: LongWord;
  public
    property DefaultInterface: IBootOptions read GetDefaultInterface;
  published
    property Manufacturer: WideString read Get_Manufacturer write Set_Manufacturer;
    property PlatformId: PlatformId read Get_PlatformId write Set_PlatformId;
    property Emulation: EmulationType read Get_Emulation write Set_Emulation;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoFsiStream provides a Create and CreateRemote method to          
// create instances of the default interface ISequentialStream exposed by              
// the CoClass FsiStream. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFsiStream = class
    class function Create: ISequentialStream;
    class function CreateRemote(const MachineName: string): ISequentialStream;
  end;

// *********************************************************************//
// The Class CoFileSystemImageResult provides a Create and CreateRemote method to          
// create instances of the default interface IFileSystemImageResult exposed by              
// the CoClass FileSystemImageResult. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFileSystemImageResult = class
    class function Create: IFileSystemImageResult;
    class function CreateRemote(const MachineName: string): IFileSystemImageResult;
  end;

// *********************************************************************//
// The Class CoProgressItem provides a Create and CreateRemote method to          
// create instances of the default interface IProgressItem exposed by              
// the CoClass ProgressItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoProgressItem = class
    class function Create: IProgressItem;
    class function CreateRemote(const MachineName: string): IProgressItem;
  end;

// *********************************************************************//
// The Class CoEnumProgressItems provides a Create and CreateRemote method to          
// create instances of the default interface IEnumProgressItems exposed by              
// the CoClass EnumProgressItems. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoEnumProgressItems = class
    class function Create: IEnumProgressItems;
    class function CreateRemote(const MachineName: string): IEnumProgressItems;
  end;

// *********************************************************************//
// The Class CoProgressItems provides a Create and CreateRemote method to          
// create instances of the default interface IProgressItems exposed by              
// the CoClass ProgressItems. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoProgressItems = class
    class function Create: IProgressItems;
    class function CreateRemote(const MachineName: string): IProgressItems;
  end;

// *********************************************************************//
// The Class CoFsiDirectoryItem provides a Create and CreateRemote method to          
// create instances of the default interface IFsiItem exposed by              
// the CoClass FsiDirectoryItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFsiDirectoryItem = class
    class function Create: IFsiItem;
    class function CreateRemote(const MachineName: string): IFsiItem;
  end;

// *********************************************************************//
// The Class CoFsiFileItem provides a Create and CreateRemote method to          
// create instances of the default interface IFsiFileItem exposed by              
// the CoClass FsiFileItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFsiFileItem = class
    class function Create: IFsiFileItem;
    class function CreateRemote(const MachineName: string): IFsiFileItem;
  end;

// *********************************************************************//
// The Class CoEnumFsiItems provides a Create and CreateRemote method to          
// create instances of the default interface IEnumFsiItems exposed by              
// the CoClass EnumFsiItems. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoEnumFsiItems = class
    class function Create: IEnumFsiItems;
    class function CreateRemote(const MachineName: string): IEnumFsiItems;
  end;

// *********************************************************************//
// The Class CoMsftFileSystemImage provides a Create and CreateRemote method to          
// create instances of the default interface IFileSystemImage exposed by              
// the CoClass MsftFileSystemImage. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftFileSystemImage = class
    class function Create: IFileSystemImage;
    class function CreateRemote(const MachineName: string): IFileSystemImage;
  end;

  TMsftFileSystemImageUpdate = procedure(Sender: TObject; var object_: OleVariant;
                                                          var currentFile: OleVariant;
                                                          copiedSectors: Integer; 
                                                          totalSectors: Integer) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftFileSystemImage
// Help String      : File system image
// Default Interface: IFileSystemImage
// Def. Intf. DISP? : No
// Event   Interface: DFileSystemImageEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftFileSystemImageProperties= class;
{$ENDIF}
  TMsftFileSystemImage = class(TOleServer)
  private
    FOnUpdate: TMsftFileSystemImageUpdate;
    FIntf:        IFileSystemImage;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftFileSystemImageProperties;
    function      GetServerProperties: TMsftFileSystemImageProperties;
{$ENDIF}
    function      GetDefaultInterface: IFileSystemImage;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function  Get_Root: IFsiItem;
    function  Get_SessionStartBlock: Integer;
    procedure Set_SessionStartBlock(pVal: Integer);
    function  Get_FreeMediaBlocks: Integer;
    procedure Set_FreeMediaBlocks(pVal: Integer);
    function  Get_UsedBlocks: Integer;
    function  Get_VolumeName: WideString;
    procedure Set_VolumeName(const pVal: WideString);
    function  Get_ImportedVolumeName: WideString;
    function  Get_BootImageOptions: IBootOptions;
    procedure Set_BootImageOptions(const pVal: IBootOptions);
    function  Get_FileCount: Integer;
    function  Get_DirectoryCount: Integer;
    function  Get_WorkingDirectory: WideString;
    procedure Set_WorkingDirectory(const pVal: WideString);
    function  Get_ChangePoint: Integer;
    function  Get_StrictFileSystemCompliance: WordBool;
    procedure Set_StrictFileSystemCompliance(pVal: WordBool);
    function  Get_UseRestrictedCharacterSet: WordBool;
    procedure Set_UseRestrictedCharacterSet(pVal: WordBool);
    function  Get_FileSystemsToCreate: FsiFileSystems;
    procedure Set_FileSystemsToCreate(pVal: FsiFileSystems);
    function  Get_FileSystemsSupported: FsiFileSystems;
    procedure Set_UDFRevision(pVal: Integer);
    function  Get_UDFRevision: Integer;
    function  Get_UDFRevisionsSupported: PSafeArray;
    procedure Set_ISO9660InterchangeLevel(pVal: Integer);
    function  Get_ISO9660InterchangeLevel: Integer;
    function  Get_ISO9660InterchangeLevelsSupported: PSafeArray;
    function  Get_VolumeNameUDF: WideString;
    function  Get_VolumeNameJoliet: WideString;
    function  Get_VolumeNameISO9660: WideString;
    function  Get_StageFiles: WordBool;
    procedure Set_StageFiles(pVal: WordBool);
    function  Get_MultisessionInterfaces: PSafeArray;
    procedure Set_MultisessionInterfaces(pVal: PSafeArray);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFileSystemImage);
    procedure Disconnect; override;
    procedure SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2);
    procedure ChooseImageDefaults(const discRecorder: IDiscRecorder2);
    procedure ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE);
    function  CreateResultImage: IFileSystemImageResult;
    function  Exists(const FullPath: WideString): FsiItemType;
    function  CalculateDiscIdentifier: WideString;
    function  IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems;
    function  GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems;
    function  ImportFileSystem: FsiFileSystems;
    procedure ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems);
    procedure RollbackToChangePoint(ChangePoint: Integer);
    procedure LockInChangePoint;
    function  CreateDirectoryItem(const Name: WideString): IFsiItem;
    function  CreateFileItem(const Name: WideString): IFsiFileItem;
    property  DefaultInterface: IFileSystemImage read GetDefaultInterface;
    property Root: IFsiItem read Get_Root;
    property UsedBlocks: Integer read Get_UsedBlocks;
    property ImportedVolumeName: WideString read Get_ImportedVolumeName;
    property FileCount: Integer read Get_FileCount;
    property DirectoryCount: Integer read Get_DirectoryCount;
    property ChangePoint: Integer read Get_ChangePoint;
    property FileSystemsSupported: FsiFileSystems read Get_FileSystemsSupported;
    property UDFRevisionsSupported: PSafeArray read Get_UDFRevisionsSupported;
    property ISO9660InterchangeLevelsSupported: PSafeArray read Get_ISO9660InterchangeLevelsSupported;
    property VolumeNameUDF: WideString read Get_VolumeNameUDF;
    property VolumeNameJoliet: WideString read Get_VolumeNameJoliet;
    property VolumeNameISO9660: WideString read Get_VolumeNameISO9660;
    property SessionStartBlock: Integer read Get_SessionStartBlock write Set_SessionStartBlock;
    property FreeMediaBlocks: Integer read Get_FreeMediaBlocks write Set_FreeMediaBlocks;
    property VolumeName: WideString read Get_VolumeName write Set_VolumeName;
    property BootImageOptions: IBootOptions read Get_BootImageOptions write Set_BootImageOptions;
    property WorkingDirectory: WideString read Get_WorkingDirectory write Set_WorkingDirectory;
    property StrictFileSystemCompliance: WordBool read Get_StrictFileSystemCompliance write Set_StrictFileSystemCompliance;
    property UseRestrictedCharacterSet: WordBool read Get_UseRestrictedCharacterSet write Set_UseRestrictedCharacterSet;
    property FileSystemsToCreate: FsiFileSystems read Get_FileSystemsToCreate write Set_FileSystemsToCreate;
    property UDFRevision: Integer read Get_UDFRevision write Set_UDFRevision;
    property ISO9660InterchangeLevel: Integer read Get_ISO9660InterchangeLevel write Set_ISO9660InterchangeLevel;
    property StageFiles: WordBool read Get_StageFiles write Set_StageFiles;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces write Set_MultisessionInterfaces;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftFileSystemImageProperties read GetServerProperties;
{$ENDIF}
    property OnUpdate: TMsftFileSystemImageUpdate read FOnUpdate write FOnUpdate;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftFileSystemImage
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftFileSystemImageProperties = class(TPersistent)
  private
    FServer:    TMsftFileSystemImage;
    function    GetDefaultInterface: IFileSystemImage;
    constructor Create(AServer: TMsftFileSystemImage);
  protected
    function  Get_Root: IFsiItem;
    function  Get_SessionStartBlock: Integer;
    procedure Set_SessionStartBlock(pVal: Integer);
    function  Get_FreeMediaBlocks: Integer;
    procedure Set_FreeMediaBlocks(pVal: Integer);
    function  Get_UsedBlocks: Integer;
    function  Get_VolumeName: WideString;
    procedure Set_VolumeName(const pVal: WideString);
    function  Get_ImportedVolumeName: WideString;
    function  Get_BootImageOptions: IBootOptions;
    procedure Set_BootImageOptions(const pVal: IBootOptions);
    function  Get_FileCount: Integer;
    function  Get_DirectoryCount: Integer;
    function  Get_WorkingDirectory: WideString;
    procedure Set_WorkingDirectory(const pVal: WideString);
    function  Get_ChangePoint: Integer;
    function  Get_StrictFileSystemCompliance: WordBool;
    procedure Set_StrictFileSystemCompliance(pVal: WordBool);
    function  Get_UseRestrictedCharacterSet: WordBool;
    procedure Set_UseRestrictedCharacterSet(pVal: WordBool);
    function  Get_FileSystemsToCreate: FsiFileSystems;
    procedure Set_FileSystemsToCreate(pVal: FsiFileSystems);
    function  Get_FileSystemsSupported: FsiFileSystems;
    procedure Set_UDFRevision(pVal: Integer);
    function  Get_UDFRevision: Integer;
    function  Get_UDFRevisionsSupported: PSafeArray;
    procedure Set_ISO9660InterchangeLevel(pVal: Integer);
    function  Get_ISO9660InterchangeLevel: Integer;
    function  Get_ISO9660InterchangeLevelsSupported: PSafeArray;
    function  Get_VolumeNameUDF: WideString;
    function  Get_VolumeNameJoliet: WideString;
    function  Get_VolumeNameISO9660: WideString;
    function  Get_StageFiles: WordBool;
    procedure Set_StageFiles(pVal: WordBool);
    function  Get_MultisessionInterfaces: PSafeArray;
    procedure Set_MultisessionInterfaces(pVal: PSafeArray);
  public
    property DefaultInterface: IFileSystemImage read GetDefaultInterface;
  published
    property SessionStartBlock: Integer read Get_SessionStartBlock write Set_SessionStartBlock;
    property FreeMediaBlocks: Integer read Get_FreeMediaBlocks write Set_FreeMediaBlocks;
    property VolumeName: WideString read Get_VolumeName write Set_VolumeName;
    property BootImageOptions: IBootOptions read Get_BootImageOptions write Set_BootImageOptions;
    property WorkingDirectory: WideString read Get_WorkingDirectory write Set_WorkingDirectory;
    property StrictFileSystemCompliance: WordBool read Get_StrictFileSystemCompliance write Set_StrictFileSystemCompliance;
    property UseRestrictedCharacterSet: WordBool read Get_UseRestrictedCharacterSet write Set_UseRestrictedCharacterSet;
    property FileSystemsToCreate: FsiFileSystems read Get_FileSystemsToCreate write Set_FileSystemsToCreate;
    property UDFRevision: Integer read Get_UDFRevision write Set_UDFRevision;
    property ISO9660InterchangeLevel: Integer read Get_ISO9660InterchangeLevel write Set_ISO9660InterchangeLevel;
    property StageFiles: WordBool read Get_StageFiles write Set_StageFiles;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces write Set_MultisessionInterfaces;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

class function CoBootOptions.Create: IBootOptions;
begin
  Result := CreateComObject(CLASS_BootOptions) as IBootOptions;
end;

class function CoBootOptions.CreateRemote(const MachineName: string): IBootOptions;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_BootOptions) as IBootOptions;
end;

procedure TBootOptions.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FCE-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{2C941FD4-975B-59BE-A960-9A2A262853A5}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBootOptions.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBootOptions;
  end;
end;

procedure TBootOptions.ConnectTo(svrIntf: IBootOptions);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBootOptions.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBootOptions.GetDefaultInterface: IBootOptions;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TBootOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TBootOptionsProperties.Create(Self);
{$ENDIF}
end;

destructor TBootOptions.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TBootOptions.GetServerProperties: TBootOptionsProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TBootOptions.Get_BootImage: ISequentialStream;
begin
  Result := DefaultInterface.BootImage;
end;

function  TBootOptions.Get_Manufacturer: WideString;
begin
  Result := DefaultInterface.Manufacturer;
end;

procedure TBootOptions.Set_Manufacturer(const pVal: WideString);
  { Warning: The property Manufacturer has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Manufacturer := pVal;
end;

function  TBootOptions.Get_PlatformId: PlatformId;
begin
  Result := DefaultInterface.PlatformId;
end;

procedure TBootOptions.Set_PlatformId(pVal: PlatformId);
begin
  DefaultInterface.PlatformId := pVal;
end;

function  TBootOptions.Get_Emulation: EmulationType;
begin
  Result := DefaultInterface.Emulation;
end;

procedure TBootOptions.Set_Emulation(pVal: EmulationType);
begin
  DefaultInterface.Emulation := pVal;
end;

function  TBootOptions.Get_ImageSize: LongWord;
begin
  Result := DefaultInterface.ImageSize;
end;

procedure TBootOptions.AssignBootImage(const newVal: ISequentialStream);
begin
  DefaultInterface.AssignBootImage(newVal);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TBootOptionsProperties.Create(AServer: TBootOptions);
begin
  inherited Create;
  FServer := AServer;
end;

function TBootOptionsProperties.GetDefaultInterface: IBootOptions;
begin
  Result := FServer.DefaultInterface;
end;

function  TBootOptionsProperties.Get_BootImage: ISequentialStream;
begin
  Result := DefaultInterface.BootImage;
end;

function  TBootOptionsProperties.Get_Manufacturer: WideString;
begin
  Result := DefaultInterface.Manufacturer;
end;

procedure TBootOptionsProperties.Set_Manufacturer(const pVal: WideString);
  { Warning: The property Manufacturer has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Manufacturer := pVal;
end;

function  TBootOptionsProperties.Get_PlatformId: PlatformId;
begin
  Result := DefaultInterface.PlatformId;
end;

procedure TBootOptionsProperties.Set_PlatformId(pVal: PlatformId);
begin
  DefaultInterface.PlatformId := pVal;
end;

function  TBootOptionsProperties.Get_Emulation: EmulationType;
begin
  Result := DefaultInterface.Emulation;
end;

procedure TBootOptionsProperties.Set_Emulation(pVal: EmulationType);
begin
  DefaultInterface.Emulation := pVal;
end;

function  TBootOptionsProperties.Get_ImageSize: LongWord;
begin
  Result := DefaultInterface.ImageSize;
end;

{$ENDIF}

class function CoFsiStream.Create: ISequentialStream;
begin
  Result := CreateComObject(CLASS_FsiStream) as ISequentialStream;
end;

class function CoFsiStream.CreateRemote(const MachineName: string): ISequentialStream;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FsiStream) as ISequentialStream;
end;

class function CoFileSystemImageResult.Create: IFileSystemImageResult;
begin
  Result := CreateComObject(CLASS_FileSystemImageResult) as IFileSystemImageResult;
end;

class function CoFileSystemImageResult.CreateRemote(const MachineName: string): IFileSystemImageResult;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FileSystemImageResult) as IFileSystemImageResult;
end;

class function CoProgressItem.Create: IProgressItem;
begin
  Result := CreateComObject(CLASS_ProgressItem) as IProgressItem;
end;

class function CoProgressItem.CreateRemote(const MachineName: string): IProgressItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ProgressItem) as IProgressItem;
end;

class function CoEnumProgressItems.Create: IEnumProgressItems;
begin
  Result := CreateComObject(CLASS_EnumProgressItems) as IEnumProgressItems;
end;

class function CoEnumProgressItems.CreateRemote(const MachineName: string): IEnumProgressItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_EnumProgressItems) as IEnumProgressItems;
end;

class function CoProgressItems.Create: IProgressItems;
begin
  Result := CreateComObject(CLASS_ProgressItems) as IProgressItems;
end;

class function CoProgressItems.CreateRemote(const MachineName: string): IProgressItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ProgressItems) as IProgressItems;
end;

class function CoFsiDirectoryItem.Create: IFsiItem;
begin
  Result := CreateComObject(CLASS_FsiDirectoryItem) as IFsiItem;
end;

class function CoFsiDirectoryItem.CreateRemote(const MachineName: string): IFsiItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FsiDirectoryItem) as IFsiItem;
end;

class function CoFsiFileItem.Create: IFsiFileItem;
begin
  Result := CreateComObject(CLASS_FsiFileItem) as IFsiFileItem;
end;

class function CoFsiFileItem.CreateRemote(const MachineName: string): IFsiFileItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FsiFileItem) as IFsiFileItem;
end;

class function CoEnumFsiItems.Create: IEnumFsiItems;
begin
  Result := CreateComObject(CLASS_EnumFsiItems) as IEnumFsiItems;
end;

class function CoEnumFsiItems.CreateRemote(const MachineName: string): IEnumFsiItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_EnumFsiItems) as IEnumFsiItems;
end;

class function CoMsftFileSystemImage.Create: IFileSystemImage;
begin
  Result := CreateComObject(CLASS_MsftFileSystemImage) as IFileSystemImage;
end;

class function CoMsftFileSystemImage.CreateRemote(const MachineName: string): IFileSystemImage;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftFileSystemImage) as IFileSystemImage;
end;

procedure TMsftFileSystemImage.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2C941FC5-975B-59BE-A960-9A2A262853A5}';
    IntfIID:   '{2C941FE1-975B-59BE-A960-9A2A262853A5}';
    EventIID:  '{2C941FDF-975B-59BE-A960-9A2A262853A5}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftFileSystemImage.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IFileSystemImage;
  end;
end;

procedure TMsftFileSystemImage.ConnectTo(svrIntf: IFileSystemImage);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftFileSystemImage.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftFileSystemImage.GetDefaultInterface: IFileSystemImage;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftFileSystemImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftFileSystemImageProperties.Create(Self);
{$ENDIF}
end;

destructor TMsftFileSystemImage.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftFileSystemImage.GetServerProperties: TMsftFileSystemImageProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMsftFileSystemImage.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   256: if Assigned(FOnUpdate) then
            FOnUpdate(Self, Params[3] {Integer}, Params[2] {Integer}, Params[1] {const WideString}, Params[0] {const IDispatch});
  end; {case DispID}
end;

function  TMsftFileSystemImage.Get_Root: IFsiItem;
begin
  Result := DefaultInterface.Root;
end;

function  TMsftFileSystemImage.Get_SessionStartBlock: Integer;
begin
  Result := DefaultInterface.SessionStartBlock;
end;

procedure TMsftFileSystemImage.Set_SessionStartBlock(pVal: Integer);
begin
  DefaultInterface.SessionStartBlock := pVal;
end;

function  TMsftFileSystemImage.Get_FreeMediaBlocks: Integer;
begin
  Result := DefaultInterface.FreeMediaBlocks;
end;

procedure TMsftFileSystemImage.Set_FreeMediaBlocks(pVal: Integer);
begin
  DefaultInterface.FreeMediaBlocks := pVal;
end;

function  TMsftFileSystemImage.Get_UsedBlocks: Integer;
begin
  Result := DefaultInterface.UsedBlocks;
end;

function  TMsftFileSystemImage.Get_VolumeName: WideString;
begin
  Result := DefaultInterface.VolumeName;
end;

procedure TMsftFileSystemImage.Set_VolumeName(const pVal: WideString);
  { Warning: The property VolumeName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VolumeName := pVal;
end;

function  TMsftFileSystemImage.Get_ImportedVolumeName: WideString;
begin
  Result := DefaultInterface.ImportedVolumeName;
end;

function  TMsftFileSystemImage.Get_BootImageOptions: IBootOptions;
begin
  Result := DefaultInterface.BootImageOptions;
end;

procedure TMsftFileSystemImage.Set_BootImageOptions(const pVal: IBootOptions);
begin
  DefaultInterface.BootImageOptions := pVal;
end;

function  TMsftFileSystemImage.Get_FileCount: Integer;
begin
  Result := DefaultInterface.FileCount;
end;

function  TMsftFileSystemImage.Get_DirectoryCount: Integer;
begin
  Result := DefaultInterface.DirectoryCount;
end;

function  TMsftFileSystemImage.Get_WorkingDirectory: WideString;
begin
  Result := DefaultInterface.WorkingDirectory;
end;

procedure TMsftFileSystemImage.Set_WorkingDirectory(const pVal: WideString);
  { Warning: The property WorkingDirectory has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.WorkingDirectory := pVal;
end;

function  TMsftFileSystemImage.Get_ChangePoint: Integer;
begin
  Result := DefaultInterface.ChangePoint;
end;

function  TMsftFileSystemImage.Get_StrictFileSystemCompliance: WordBool;
begin
  Result := DefaultInterface.StrictFileSystemCompliance;
end;

procedure TMsftFileSystemImage.Set_StrictFileSystemCompliance(pVal: WordBool);
begin
  DefaultInterface.StrictFileSystemCompliance := pVal;
end;

function  TMsftFileSystemImage.Get_UseRestrictedCharacterSet: WordBool;
begin
  Result := DefaultInterface.UseRestrictedCharacterSet;
end;

procedure TMsftFileSystemImage.Set_UseRestrictedCharacterSet(pVal: WordBool);
begin
  DefaultInterface.UseRestrictedCharacterSet := pVal;
end;

function  TMsftFileSystemImage.Get_FileSystemsToCreate: FsiFileSystems;
begin
  Result := DefaultInterface.FileSystemsToCreate;
end;

procedure TMsftFileSystemImage.Set_FileSystemsToCreate(pVal: FsiFileSystems);
begin
  DefaultInterface.FileSystemsToCreate := pVal;
end;

function  TMsftFileSystemImage.Get_FileSystemsSupported: FsiFileSystems;
begin
  Result := DefaultInterface.FileSystemsSupported;
end;

procedure TMsftFileSystemImage.Set_UDFRevision(pVal: Integer);
begin
  DefaultInterface.UDFRevision := pVal;
end;

function  TMsftFileSystemImage.Get_UDFRevision: Integer;
begin
  Result := DefaultInterface.UDFRevision;
end;

function  TMsftFileSystemImage.Get_UDFRevisionsSupported: PSafeArray;
begin
  Result := DefaultInterface.UDFRevisionsSupported;
end;

procedure TMsftFileSystemImage.Set_ISO9660InterchangeLevel(pVal: Integer);
begin
  DefaultInterface.ISO9660InterchangeLevel := pVal;
end;

function  TMsftFileSystemImage.Get_ISO9660InterchangeLevel: Integer;
begin
  Result := DefaultInterface.ISO9660InterchangeLevel;
end;

function  TMsftFileSystemImage.Get_ISO9660InterchangeLevelsSupported: PSafeArray;
begin
  Result := DefaultInterface.ISO9660InterchangeLevelsSupported;
end;

function  TMsftFileSystemImage.Get_VolumeNameUDF: WideString;
begin
  Result := DefaultInterface.VolumeNameUDF;
end;

function  TMsftFileSystemImage.Get_VolumeNameJoliet: WideString;
begin
  Result := DefaultInterface.VolumeNameJoliet;
end;

function  TMsftFileSystemImage.Get_VolumeNameISO9660: WideString;
begin
  Result := DefaultInterface.VolumeNameISO9660;
end;

function  TMsftFileSystemImage.Get_StageFiles: WordBool;
begin
  Result := DefaultInterface.StageFiles;
end;

procedure TMsftFileSystemImage.Set_StageFiles(pVal: WordBool);
begin
  DefaultInterface.StageFiles := pVal;
end;

function  TMsftFileSystemImage.Get_MultisessionInterfaces: PSafeArray;
begin
  Result := DefaultInterface.MultisessionInterfaces;
end;

procedure TMsftFileSystemImage.Set_MultisessionInterfaces(pVal: PSafeArray);
begin
  DefaultInterface.MultisessionInterfaces := pVal;
end;

procedure TMsftFileSystemImage.SetMaxMediaBlocksFromDevice(const discRecorder: IDiscRecorder2);
begin
  DefaultInterface.SetMaxMediaBlocksFromDevice(discRecorder);
end;

procedure TMsftFileSystemImage.ChooseImageDefaults(const discRecorder: IDiscRecorder2);
begin
  DefaultInterface.ChooseImageDefaults(discRecorder);
end;

procedure TMsftFileSystemImage.ChooseImageDefaultsForMediaType(value: IMAPI_MEDIA_PHYSICAL_TYPE);
begin
  DefaultInterface.ChooseImageDefaultsForMediaType(value);
end;

function  TMsftFileSystemImage.CreateResultImage: IFileSystemImageResult;
begin
  Result := DefaultInterface.CreateResultImage;
end;

function  TMsftFileSystemImage.Exists(const FullPath: WideString): FsiItemType;
begin
  Result := DefaultInterface.Exists(FullPath);
end;

function  TMsftFileSystemImage.CalculateDiscIdentifier: WideString;
begin
  Result := DefaultInterface.CalculateDiscIdentifier;
end;

function  TMsftFileSystemImage.IdentifyFileSystemsOnDisc(const discRecorder: IDiscRecorder2): FsiFileSystems;
begin
  Result := DefaultInterface.IdentifyFileSystemsOnDisc(discRecorder);
end;

function  TMsftFileSystemImage.GetDefaultFileSystemForImport(fileSystems: FsiFileSystems): FsiFileSystems;
begin
  Result := DefaultInterface.GetDefaultFileSystemForImport(fileSystems);
end;

function  TMsftFileSystemImage.ImportFileSystem: FsiFileSystems;
begin
  Result := DefaultInterface.ImportFileSystem;
end;

procedure TMsftFileSystemImage.ImportSpecificFileSystem(fileSystemToUse: FsiFileSystems);
begin
  DefaultInterface.ImportSpecificFileSystem(fileSystemToUse);
end;

procedure TMsftFileSystemImage.RollbackToChangePoint(ChangePoint: Integer);
begin
  DefaultInterface.RollbackToChangePoint(ChangePoint);
end;

procedure TMsftFileSystemImage.LockInChangePoint;
begin
  DefaultInterface.LockInChangePoint;
end;

function  TMsftFileSystemImage.CreateDirectoryItem(const Name: WideString): IFsiItem;
begin
  Result := DefaultInterface.CreateDirectoryItem(Name);
end;

function  TMsftFileSystemImage.CreateFileItem(const Name: WideString): IFsiFileItem;
begin
  Result := DefaultInterface.CreateFileItem(Name);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftFileSystemImageProperties.Create(AServer: TMsftFileSystemImage);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftFileSystemImageProperties.GetDefaultInterface: IFileSystemImage;
begin
  Result := FServer.DefaultInterface;
end;

function  TMsftFileSystemImageProperties.Get_Root: IFsiItem;
begin
  Result := DefaultInterface.Root;
end;

function  TMsftFileSystemImageProperties.Get_SessionStartBlock: Integer;
begin
  Result := DefaultInterface.SessionStartBlock;
end;

procedure TMsftFileSystemImageProperties.Set_SessionStartBlock(pVal: Integer);
begin
  DefaultInterface.SessionStartBlock := pVal;
end;

function  TMsftFileSystemImageProperties.Get_FreeMediaBlocks: Integer;
begin
  Result := DefaultInterface.FreeMediaBlocks;
end;

procedure TMsftFileSystemImageProperties.Set_FreeMediaBlocks(pVal: Integer);
begin
  DefaultInterface.FreeMediaBlocks := pVal;
end;

function  TMsftFileSystemImageProperties.Get_UsedBlocks: Integer;
begin
  Result := DefaultInterface.UsedBlocks;
end;

function  TMsftFileSystemImageProperties.Get_VolumeName: WideString;
begin
  Result := DefaultInterface.VolumeName;
end;

procedure TMsftFileSystemImageProperties.Set_VolumeName(const pVal: WideString);
  { Warning: The property VolumeName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.VolumeName := pVal;
end;

function  TMsftFileSystemImageProperties.Get_ImportedVolumeName: WideString;
begin
  Result := DefaultInterface.ImportedVolumeName;
end;

function  TMsftFileSystemImageProperties.Get_BootImageOptions: IBootOptions;
begin
  Result := DefaultInterface.BootImageOptions;
end;

procedure TMsftFileSystemImageProperties.Set_BootImageOptions(const pVal: IBootOptions);
begin
  DefaultInterface.BootImageOptions := pVal;
end;

function  TMsftFileSystemImageProperties.Get_FileCount: Integer;
begin
  Result := DefaultInterface.FileCount;
end;

function  TMsftFileSystemImageProperties.Get_DirectoryCount: Integer;
begin
  Result := DefaultInterface.DirectoryCount;
end;

function  TMsftFileSystemImageProperties.Get_WorkingDirectory: WideString;
begin
  Result := DefaultInterface.WorkingDirectory;
end;

procedure TMsftFileSystemImageProperties.Set_WorkingDirectory(const pVal: WideString);
  { Warning: The property WorkingDirectory has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.WorkingDirectory := pVal;
end;

function  TMsftFileSystemImageProperties.Get_ChangePoint: Integer;
begin
  Result := DefaultInterface.ChangePoint;
end;

function  TMsftFileSystemImageProperties.Get_StrictFileSystemCompliance: WordBool;
begin
  Result := DefaultInterface.StrictFileSystemCompliance;
end;

procedure TMsftFileSystemImageProperties.Set_StrictFileSystemCompliance(pVal: WordBool);
begin
  DefaultInterface.StrictFileSystemCompliance := pVal;
end;

function  TMsftFileSystemImageProperties.Get_UseRestrictedCharacterSet: WordBool;
begin
  Result := DefaultInterface.UseRestrictedCharacterSet;
end;

procedure TMsftFileSystemImageProperties.Set_UseRestrictedCharacterSet(pVal: WordBool);
begin
  DefaultInterface.UseRestrictedCharacterSet := pVal;
end;

function  TMsftFileSystemImageProperties.Get_FileSystemsToCreate: FsiFileSystems;
begin
  Result := DefaultInterface.FileSystemsToCreate;
end;

procedure TMsftFileSystemImageProperties.Set_FileSystemsToCreate(pVal: FsiFileSystems);
begin
  DefaultInterface.FileSystemsToCreate := pVal;
end;

function  TMsftFileSystemImageProperties.Get_FileSystemsSupported: FsiFileSystems;
begin
  Result := DefaultInterface.FileSystemsSupported;
end;

procedure TMsftFileSystemImageProperties.Set_UDFRevision(pVal: Integer);
begin
  DefaultInterface.UDFRevision := pVal;
end;

function  TMsftFileSystemImageProperties.Get_UDFRevision: Integer;
begin
  Result := DefaultInterface.UDFRevision;
end;

function  TMsftFileSystemImageProperties.Get_UDFRevisionsSupported: PSafeArray;
begin
  Result := DefaultInterface.UDFRevisionsSupported;
end;

procedure TMsftFileSystemImageProperties.Set_ISO9660InterchangeLevel(pVal: Integer);
begin
  DefaultInterface.ISO9660InterchangeLevel := pVal;
end;

function  TMsftFileSystemImageProperties.Get_ISO9660InterchangeLevel: Integer;
begin
  Result := DefaultInterface.ISO9660InterchangeLevel;
end;

function  TMsftFileSystemImageProperties.Get_ISO9660InterchangeLevelsSupported: PSafeArray;
begin
  Result := DefaultInterface.ISO9660InterchangeLevelsSupported;
end;

function  TMsftFileSystemImageProperties.Get_VolumeNameUDF: WideString;
begin
  Result := DefaultInterface.VolumeNameUDF;
end;

function  TMsftFileSystemImageProperties.Get_VolumeNameJoliet: WideString;
begin
  Result := DefaultInterface.VolumeNameJoliet;
end;

function  TMsftFileSystemImageProperties.Get_VolumeNameISO9660: WideString;
begin
  Result := DefaultInterface.VolumeNameISO9660;
end;

function  TMsftFileSystemImageProperties.Get_StageFiles: WordBool;
begin
  Result := DefaultInterface.StageFiles;
end;

procedure TMsftFileSystemImageProperties.Set_StageFiles(pVal: WordBool);
begin
  DefaultInterface.StageFiles := pVal;
end;

function  TMsftFileSystemImageProperties.Get_MultisessionInterfaces: PSafeArray;
begin
  Result := DefaultInterface.MultisessionInterfaces;
end;

procedure TMsftFileSystemImageProperties.Set_MultisessionInterfaces(pVal: PSafeArray);
begin
  DefaultInterface.MultisessionInterfaces := pVal;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TBootOptions, TMsftFileSystemImage]);
end;

end.

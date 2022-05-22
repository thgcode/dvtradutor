{$Warnings off}

unit IMAPI2_TLB;

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
// File generated on 13/12/2010 00:47:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\SYSTEM32\imapi2.dll (1)
// LIBID: {2735412F-7F64-5B0F-8F00-5D77AFBE261E}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// Errors:
//   Hint: Parameter 'object' of DDiscMaster2Events.NotifyDeviceAdded changed to 'object_'
//   Hint: Parameter 'object' of DDiscMaster2Events.NotifyDeviceRemoved changed to 'object_'
//   Hint: Parameter 'object' of DWriteEngine2Events.Update changed to 'object_'
//   Hint: Parameter 'object' of DDiscFormat2EraseEvents.Update changed to 'object_'
//   Hint: Parameter 'object' of DDiscFormat2DataEvents.Update changed to 'object_'
//   Hint: Parameter 'object' of DDiscFormat2TrackAtOnceEvents.Update changed to 'object_'
//   Hint: Parameter 'object' of DDiscFormat2RawCDEvents.Update changed to 'object_'
//   Hint: Member 'type' of 'tagSTATSTG' changed to 'type_'
//   Error creating palette bitmap of (TMsftDiscMaster2) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscRecorder2) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftWriteEngine2) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscFormat2Erase) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscFormat2Data) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscFormat2TrackAtOnce) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftDiscFormat2RawCD) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftStreamZero) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftStreamPrng001) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftStreamConcatenate) : Server C:\windows\system32\imapi2.dll contains no icons
//   Error creating palette bitmap of (TMsftStreamInterleave) : Server C:\windows\system32\imapi2.dll contains no icons
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
  IMAPI2MajorVersion = 1;
  IMAPI2MinorVersion = 0;

  LIBID_IMAPI2: TGUID = '{2735412F-7F64-5B0F-8F00-5D77AFBE261E}';

  IID_IWriteEngine2EventArgs: TGUID = '{27354136-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2DataEventArgs: TGUID = '{2735413D-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2TrackAtOnceEventArgs: TGUID = '{27354140-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2RawCDEventArgs: TGUID = '{27354143-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IWriteSpeedDescriptor: TGUID = '{27354144-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscMaster2Events: TGUID = '{27354131-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DWriteEngine2Events: TGUID = '{27354137-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscFormat2EraseEvents: TGUID = '{2735413A-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscFormat2DataEvents: TGUID = '{2735413C-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscFormat2TrackAtOnceEvents: TGUID = '{2735413F-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_DDiscFormat2RawCDEvents: TGUID = '{27354142-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscMaster2: TGUID = '{27354130-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IConnectionPointContainer: TGUID = '{B196B284-BAB4-101A-B69C-00AA00341D07}';
  CLASS_MsftDiscMaster2: TGUID = '{2735412E-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IEnumConnectionPoints: TGUID = '{B196B285-BAB4-101A-B69C-00AA00341D07}';
  IID_IConnectionPoint: TGUID = '{B196B286-BAB4-101A-B69C-00AA00341D07}';
  IID_IEnumConnections: TGUID = '{B196B287-BAB4-101A-B69C-00AA00341D07}';
  IID_IDiscRecorder2: TGUID = '{27354133-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscRecorder2Ex: TGUID = '{27354132-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscRecorder2: TGUID = '{2735412D-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IWriteEngine2: TGUID = '{27354135-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftWriteEngine2: TGUID = '{2735412C-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_ISequentialStream: TGUID = '{0C733A30-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IStream: TGUID = '{0000000C-0000-0000-C000-000000000046}';
  IID_IDiscFormat2: TGUID = '{27354152-8F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscFormat2Erase: TGUID = '{2735412B-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2Erase: TGUID = '{27354156-8F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2Data: TGUID = '{27354153-9F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscFormat2Data: TGUID = '{2735412A-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2TrackAtOnce: TGUID = '{27354154-8F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscFormat2TrackAtOnce: TGUID = '{27354129-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IDiscFormat2RawCD: TGUID = '{27354155-8F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftDiscFormat2RawCD: TGUID = '{27354128-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftStreamZero: TGUID = '{27354127-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IStreamPseudoRandomBased: TGUID = '{27354145-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftStreamPrng001: TGUID = '{27354126-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IStreamConcatenate: TGUID = '{27354146-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftStreamConcatenate: TGUID = '{27354125-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IStreamInterleave: TGUID = '{27354147-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftStreamInterleave: TGUID = '{27354124-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftWriteSpeedDescriptor: TGUID = '{27354123-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IMultisession: TGUID = '{27354150-7F64-5B0F-8F00-5D77AFBE261E}';
  CLASS_MsftMultisessionSequential: TGUID = '{27354122-7F64-5B0F-8F00-5D77AFBE261E}';
  IID_IMultisessionSequential: TGUID = '{27354151-7F64-5B0F-8F00-5D77AFBE261E}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum _IMAPI_FORMAT2_DATA_WRITE_ACTION
type
  _IMAPI_FORMAT2_DATA_WRITE_ACTION = TOleEnum;
const
  IMAPI_FORMAT2_DATA_WRITE_ACTION_VALIDATING_MEDIA = $00000000;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_FORMATTING_MEDIA = $00000001;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_INITIALIZING_HARDWARE = $00000002;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_CALIBRATING_POWER = $00000003;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_WRITING_DATA = $00000004;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_FINALIZATION = $00000005;
  IMAPI_FORMAT2_DATA_WRITE_ACTION_COMPLETED = $00000006;

// Constants for enum _IMAPI_FORMAT2_TAO_WRITE_ACTION
type
  _IMAPI_FORMAT2_TAO_WRITE_ACTION = TOleEnum;
const
  IMAPI_FORMAT2_TAO_WRITE_ACTION_UNKNOWN = $00000000;
  IMAPI_FORMAT2_TAO_WRITE_ACTION_PREPARING = $00000001;
  IMAPI_FORMAT2_TAO_WRITE_ACTION_WRITING = $00000002;
  IMAPI_FORMAT2_TAO_WRITE_ACTION_FINISHING = $00000003;

// Constants for enum _IMAPI_FORMAT2_RAW_CD_WRITE_ACTION
type
  _IMAPI_FORMAT2_RAW_CD_WRITE_ACTION = TOleEnum;
const
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION_UNKNOWN = $00000000;
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION_PREPARING = $00000001;
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION_WRITING = $00000002;
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION_FINISHING = $00000003;

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

// Constants for enum _IMAPI_READ_TRACK_ADDRESS_TYPE
type
  _IMAPI_READ_TRACK_ADDRESS_TYPE = TOleEnum;
const
  IMAPI_READ_TRACK_ADDRESS_TYPE_LBA = $00000000;
  IMAPI_READ_TRACK_ADDRESS_TYPE_TRACK = $00000001;
  IMAPI_READ_TRACK_ADDRESS_TYPE_SESSION = $00000002;

// Constants for enum _IMAPI_FEATURE_PAGE_TYPE
type
  _IMAPI_FEATURE_PAGE_TYPE = TOleEnum;
const
  IMAPI_FEATURE_PAGE_TYPE_PROFILE_LIST = $00000000;
  IMAPI_FEATURE_PAGE_TYPE_CORE = $00000001;
  IMAPI_FEATURE_PAGE_TYPE_MORPHING = $00000002;
  IMAPI_FEATURE_PAGE_TYPE_REMOVABLE_MEDIUM = $00000003;
  IMAPI_FEATURE_PAGE_TYPE_WRITE_PROTECT = $00000004;
  IMAPI_FEATURE_PAGE_TYPE_RANDOMLY_READABLE = $00000010;
  IMAPI_FEATURE_PAGE_TYPE_CD_MULTIREAD = $0000001D;
  IMAPI_FEATURE_PAGE_TYPE_CD_READ = $0000001E;
  IMAPI_FEATURE_PAGE_TYPE_DVD_READ = $0000001F;
  IMAPI_FEATURE_PAGE_TYPE_RANDOMLY_WRITABLE = $00000020;
  IMAPI_FEATURE_PAGE_TYPE_INCREMENTAL_STREAMING_WRITABLE = $00000021;
  IMAPI_FEATURE_PAGE_TYPE_SECTOR_ERASABLE = $00000022;
  IMAPI_FEATURE_PAGE_TYPE_FORMATTABLE = $00000023;
  IMAPI_FEATURE_PAGE_TYPE_HARDWARE_DEFECT_MANAGEMENT = $00000024;
  IMAPI_FEATURE_PAGE_TYPE_WRITE_ONCE = $00000025;
  IMAPI_FEATURE_PAGE_TYPE_RESTRICTED_OVERWRITE = $00000026;
  IMAPI_FEATURE_PAGE_TYPE_CDRW_CAV_WRITE = $00000027;
  IMAPI_FEATURE_PAGE_TYPE_MRW = $00000028;
  IMAPI_FEATURE_PAGE_TYPE_ENHANCED_DEFECT_REPORTING = $00000029;
  IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_RW = $0000002A;
  IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_R = $0000002B;
  IMAPI_FEATURE_PAGE_TYPE_RIGID_RESTRICTED_OVERWRITE = $0000002C;
  IMAPI_FEATURE_PAGE_TYPE_CD_TRACK_AT_ONCE = $0000002D;
  IMAPI_FEATURE_PAGE_TYPE_CD_MASTERING = $0000002E;
  IMAPI_FEATURE_PAGE_TYPE_DVD_DASH_WRITE = $0000002F;
  IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_READ = $00000030;
  IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_R_WRITE = $00000031;
  IMAPI_FEATURE_PAGE_TYPE_DOUBLE_DENSITY_CD_RW_WRITE = $00000032;
  IMAPI_FEATURE_PAGE_TYPE_LAYER_JUMP_RECORDING = $00000033;
  IMAPI_FEATURE_PAGE_TYPE_CD_RW_MEDIA_WRITE_SUPPORT = $00000037;
  IMAPI_FEATURE_PAGE_TYPE_BD_PSEUDO_OVERWRITE = $00000038;
  IMAPI_FEATURE_PAGE_TYPE_DVD_PLUS_R_DUAL_LAYER = $0000003B;
  IMAPI_FEATURE_PAGE_TYPE_BD_READ = $00000040;
  IMAPI_FEATURE_PAGE_TYPE_BD_WRITE = $00000041;
  IMAPI_FEATURE_PAGE_TYPE_HD_DVD_READ = $00000050;
  IMAPI_FEATURE_PAGE_TYPE_HD_DVD_WRITE = $00000051;
  IMAPI_FEATURE_PAGE_TYPE_POWER_MANAGEMENT = $00000100;
  IMAPI_FEATURE_PAGE_TYPE_SMART = $00000101;
  IMAPI_FEATURE_PAGE_TYPE_EMBEDDED_CHANGER = $00000102;
  IMAPI_FEATURE_PAGE_TYPE_CD_ANALOG_PLAY = $00000103;
  IMAPI_FEATURE_PAGE_TYPE_MICROCODE_UPDATE = $00000104;
  IMAPI_FEATURE_PAGE_TYPE_TIMEOUT = $00000105;
  IMAPI_FEATURE_PAGE_TYPE_DVD_CSS = $00000106;
  IMAPI_FEATURE_PAGE_TYPE_REAL_TIME_STREAMING = $00000107;
  IMAPI_FEATURE_PAGE_TYPE_LOGICAL_UNIT_SERIAL_NUMBER = $00000108;
  IMAPI_FEATURE_PAGE_TYPE_MEDIA_SERIAL_NUMBER = $00000109;
  IMAPI_FEATURE_PAGE_TYPE_DISC_CONTROL_BLOCKS = $0000010A;
  IMAPI_FEATURE_PAGE_TYPE_DVD_CPRM = $0000010B;
  IMAPI_FEATURE_PAGE_TYPE_FIRMWARE_INFORMATION = $0000010C;
  IMAPI_FEATURE_PAGE_TYPE_AACS = $0000010D;
  IMAPI_FEATURE_PAGE_TYPE_VCPS = $00000110;

// Constants for enum _IMAPI_MODE_PAGE_TYPE
type
  _IMAPI_MODE_PAGE_TYPE = TOleEnum;
const
  IMAPI_MODE_PAGE_TYPE_READ_WRITE_ERROR_RECOVERY = $00000001;
  IMAPI_MODE_PAGE_TYPE_MRW = $00000003;
  IMAPI_MODE_PAGE_TYPE_WRITE_PARAMETERS = $00000005;
  IMAPI_MODE_PAGE_TYPE_CACHING = $00000008;
  IMAPI_MODE_PAGE_TYPE_INFORMATIONAL_EXCEPTIONS = $0000001C;
  IMAPI_MODE_PAGE_TYPE_TIMEOUT_AND_PROTECT = $0000001D;
  IMAPI_MODE_PAGE_TYPE_POWER_CONDITION = $0000001A;
  IMAPI_MODE_PAGE_TYPE_LEGACY_CAPABILITIES = $0000002A;

// Constants for enum _IMAPI_MODE_PAGE_REQUEST_TYPE
type
  _IMAPI_MODE_PAGE_REQUEST_TYPE = TOleEnum;
const
  IMAPI_MODE_PAGE_REQUEST_TYPE_CURRENT_VALUES = $00000000;
  IMAPI_MODE_PAGE_REQUEST_TYPE_CHANGEABLE_VALUES = $00000001;
  IMAPI_MODE_PAGE_REQUEST_TYPE_DEFAULT_VALUES = $00000002;
  IMAPI_MODE_PAGE_REQUEST_TYPE_SAVED_VALUES = $00000003;

// Constants for enum _IMAPI_PROFILE_TYPE
type
  _IMAPI_PROFILE_TYPE = TOleEnum;
const
  IMAPI_PROFILE_TYPE_INVALID = $00000000;
  IMAPI_PROFILE_TYPE_NON_REMOVABLE_DISK = $00000001;
  IMAPI_PROFILE_TYPE_REMOVABLE_DISK = $00000002;
  IMAPI_PROFILE_TYPE_MO_ERASABLE = $00000003;
  IMAPI_PROFILE_TYPE_MO_WRITE_ONCE = $00000004;
  IMAPI_PROFILE_TYPE_AS_MO = $00000005;
  IMAPI_PROFILE_TYPE_CDROM = $00000008;
  IMAPI_PROFILE_TYPE_CD_RECORDABLE = $00000009;
  IMAPI_PROFILE_TYPE_CD_REWRITABLE = $0000000A;
  IMAPI_PROFILE_TYPE_DVDROM = $00000010;
  IMAPI_PROFILE_TYPE_DVD_DASH_RECORDABLE = $00000011;
  IMAPI_PROFILE_TYPE_DVD_RAM = $00000012;
  IMAPI_PROFILE_TYPE_DVD_DASH_REWRITABLE = $00000013;
  IMAPI_PROFILE_TYPE_DVD_DASH_RW_SEQUENTIAL = $00000014;
  IMAPI_PROFILE_TYPE_DVD_DASH_R_DUAL_SEQUENTIAL = $00000015;
  IMAPI_PROFILE_TYPE_DVD_DASH_R_DUAL_LAYER_JUMP = $00000016;
  IMAPI_PROFILE_TYPE_DVD_PLUS_RW = $0000001A;
  IMAPI_PROFILE_TYPE_DVD_PLUS_R = $0000001B;
  IMAPI_PROFILE_TYPE_DDCDROM = $00000020;
  IMAPI_PROFILE_TYPE_DDCD_RECORDABLE = $00000021;
  IMAPI_PROFILE_TYPE_DDCD_REWRITABLE = $00000022;
  IMAPI_PROFILE_TYPE_DVD_PLUS_RW_DUAL = $0000002A;
  IMAPI_PROFILE_TYPE_DVD_PLUS_R_DUAL = $0000002B;
  IMAPI_PROFILE_TYPE_BD_ROM = $00000040;
  IMAPI_PROFILE_TYPE_BD_R_SEQUENTIAL = $00000041;
  IMAPI_PROFILE_TYPE_BD_R_RANDOM_RECORDING = $00000042;
  IMAPI_PROFILE_TYPE_BD_REWRITABLE = $00000043;
  IMAPI_PROFILE_TYPE_HD_DVD_ROM = $00000050;
  IMAPI_PROFILE_TYPE_HD_DVD_RECORDABLE = $00000051;
  IMAPI_PROFILE_TYPE_HD_DVD_RAM = $00000052;
  IMAPI_PROFILE_TYPE_NON_STANDARD = $0000FFFF;

// Constants for enum _IMAPI_FORMAT2_DATA_MEDIA_STATE
type
  _IMAPI_FORMAT2_DATA_MEDIA_STATE = TOleEnum;
const
  IMAPI_FORMAT2_DATA_MEDIA_STATE_UNKNOWN = $00000000;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_INFORMATIONAL_MASK = $0000000F;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MASK = $0000FC00;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_OVERWRITE_ONLY = $00000001;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_RANDOMLY_WRITABLE = $00000001;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_BLANK = $00000002;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_APPENDABLE = $00000004;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_FINAL_SESSION = $00000008;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_DAMAGED = $00000400;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_ERASE_REQUIRED = $00000800;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_NON_EMPTY_SESSION = $00001000;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_WRITE_PROTECTED = $00002000;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_FINALIZED = $00004000;
  IMAPI_FORMAT2_DATA_MEDIA_STATE_UNSUPPORTED_MEDIA = $00008000;

// Constants for enum _IMAPI_MEDIA_WRITE_PROTECT_STATE
type
  _IMAPI_MEDIA_WRITE_PROTECT_STATE = TOleEnum;
const
  IMAPI_WRITEPROTECTED_UNTIL_POWERDOWN = $00000001;
  IMAPI_WRITEPROTECTED_BY_CARTRIDGE = $00000002;
  IMAPI_WRITEPROTECTED_BY_MEDIA_SPECIFIC_REASON = $00000004;
  IMAPI_WRITEPROTECTED_BY_SOFTWARE_WRITE_PROTECT = $00000008;
  IMAPI_WRITEPROTECTED_BY_DISC_CONTROL_BLOCK = $00000010;
  IMAPI_WRITEPROTECTED_READ_ONLY_MEDIA = $00004000;

// Constants for enum _IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE
type
  _IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE = TOleEnum;
const
  IMAPI_FORMAT2_RAW_CD_SUBCODE_PQ_ONLY = $00000001;
  IMAPI_FORMAT2_RAW_CD_SUBCODE_IS_COOKED = $00000002;
  IMAPI_FORMAT2_RAW_CD_SUBCODE_IS_RAW = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IWriteEngine2EventArgs = interface;
  IWriteEngine2EventArgsDisp = dispinterface;
  IDiscFormat2DataEventArgs = interface;
  IDiscFormat2DataEventArgsDisp = dispinterface;
  IDiscFormat2TrackAtOnceEventArgs = interface;
  IDiscFormat2TrackAtOnceEventArgsDisp = dispinterface;
  IDiscFormat2RawCDEventArgs = interface;
  IDiscFormat2RawCDEventArgsDisp = dispinterface;
  IWriteSpeedDescriptor = interface;
  IWriteSpeedDescriptorDisp = dispinterface;
  DDiscMaster2Events = interface;
  DWriteEngine2Events = interface;
  DDiscFormat2EraseEvents = interface;
  DDiscFormat2DataEvents = interface;
  DDiscFormat2TrackAtOnceEvents = interface;
  DDiscFormat2RawCDEvents = interface;
  IDiscMaster2 = interface;
  IDiscMaster2Disp = dispinterface;
  IConnectionPointContainer = interface;
  IEnumConnectionPoints = interface;
  IConnectionPoint = interface;
  IEnumConnections = interface;
  IDiscRecorder2 = interface;
  IDiscRecorder2Disp = dispinterface;
  IDiscRecorder2Ex = interface;
  IWriteEngine2 = interface;
  IWriteEngine2Disp = dispinterface;
  ISequentialStream = interface;
  IStream = interface;
  IDiscFormat2 = interface;
  IDiscFormat2Disp = dispinterface;
  IDiscFormat2Erase = interface;
  IDiscFormat2EraseDisp = dispinterface;
  IDiscFormat2Data = interface;
  IDiscFormat2DataDisp = dispinterface;
  IDiscFormat2TrackAtOnce = interface;
  IDiscFormat2TrackAtOnceDisp = dispinterface;
  IDiscFormat2RawCD = interface;
  IDiscFormat2RawCDDisp = dispinterface;
  IStreamPseudoRandomBased = interface;
  IStreamConcatenate = interface;
  IStreamInterleave = interface;
  IMultisession = interface;
  IMultisessionSequential = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MsftDiscMaster2 = IDiscMaster2;
  MsftDiscRecorder2 = IDiscRecorder2;
  MsftWriteEngine2 = IWriteEngine2;
  MsftDiscFormat2Erase = IDiscFormat2;
  MsftDiscFormat2Data = IDiscFormat2Data;
  MsftDiscFormat2TrackAtOnce = IDiscFormat2TrackAtOnce;
  MsftDiscFormat2RawCD = IDiscFormat2RawCD;
  MsftStreamZero = ISequentialStream;
  MsftStreamPrng001 = IStreamPseudoRandomBased;
  MsftStreamConcatenate = IStreamConcatenate;
  MsftStreamInterleave = IStreamInterleave;
  MsftWriteSpeedDescriptor = IWriteSpeedDescriptor;
  MsftMultisessionSequential = IMultisession;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PUserType1 = ^TGUID; {*}
  PByte1 = ^Byte; {*}
  PUserType2 = ^IMAPI_FEATURE_PAGE_TYPE; {*}
  PUserType3 = ^IMAPI_PROFILE_TYPE; {*}
  PUserType4 = ^IMAPI_MODE_PAGE_TYPE; {*}
  PUINT1 = ^LongWord; {*}
  PPUserType1 = ^ISequentialStream; {*}

  IMAPI_FORMAT2_DATA_WRITE_ACTION = _IMAPI_FORMAT2_DATA_WRITE_ACTION; 
  IMAPI_FORMAT2_TAO_WRITE_ACTION = _IMAPI_FORMAT2_TAO_WRITE_ACTION; 
  IMAPI_FORMAT2_RAW_CD_WRITE_ACTION = _IMAPI_FORMAT2_RAW_CD_WRITE_ACTION; 
  IMAPI_MEDIA_PHYSICAL_TYPE = _IMAPI_MEDIA_PHYSICAL_TYPE; 

  tagCONNECTDATA = packed record
    pUnk: IUnknown;
    dwCookie: LongWord;
  end;

  IMAPI_READ_TRACK_ADDRESS_TYPE = _IMAPI_READ_TRACK_ADDRESS_TYPE; 
  IMAPI_FEATURE_PAGE_TYPE = _IMAPI_FEATURE_PAGE_TYPE; 
  IMAPI_MODE_PAGE_TYPE = _IMAPI_MODE_PAGE_TYPE; 
  IMAPI_MODE_PAGE_REQUEST_TYPE = _IMAPI_MODE_PAGE_REQUEST_TYPE; 
  IMAPI_PROFILE_TYPE = _IMAPI_PROFILE_TYPE; 

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

  IMAPI_FORMAT2_DATA_MEDIA_STATE = _IMAPI_FORMAT2_DATA_MEDIA_STATE; 
  IMAPI_MEDIA_WRITE_PROTECT_STATE = _IMAPI_MEDIA_WRITE_PROTECT_STATE; 
  IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE = _IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE; 
  PrivateAlias1 = array[0..17] of Byte; {*}

// *********************************************************************//
// Interface: IWriteEngine2EventArgs
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354136-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteEngine2EventArgs = interface(IDispatch)
    ['{27354136-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Get_StartLba: Integer; safecall;
    function  Get_SectorCount: Integer; safecall;
    function  Get_LastReadLba: Integer; safecall;
    function  Get_LastWrittenLba: Integer; safecall;
    function  Get_TotalSystemBuffer: Integer; safecall;
    function  Get_UsedSystemBuffer: Integer; safecall;
    function  Get_FreeSystemBuffer: Integer; safecall;
    property StartLba: Integer read Get_StartLba;
    property SectorCount: Integer read Get_SectorCount;
    property LastReadLba: Integer read Get_LastReadLba;
    property LastWrittenLba: Integer read Get_LastWrittenLba;
    property TotalSystemBuffer: Integer read Get_TotalSystemBuffer;
    property UsedSystemBuffer: Integer read Get_UsedSystemBuffer;
    property FreeSystemBuffer: Integer read Get_FreeSystemBuffer;
  end;

// *********************************************************************//
// DispIntf:  IWriteEngine2EventArgsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354136-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteEngine2EventArgsDisp = dispinterface
    ['{27354136-7F64-5B0F-8F00-5D77AFBE261E}']
    property StartLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property LastReadLba: Integer readonly dispid 258;
    property LastWrittenLba: Integer readonly dispid 259;
    property TotalSystemBuffer: Integer readonly dispid 262;
    property UsedSystemBuffer: Integer readonly dispid 263;
    property FreeSystemBuffer: Integer readonly dispid 264;
  end;

// *********************************************************************//
// Interface: IDiscFormat2DataEventArgs
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2735413D-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2DataEventArgs = interface(IWriteEngine2EventArgs)
    ['{2735413D-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Get_ElapsedTime: Integer; safecall;
    function  Get_RemainingTime: Integer; safecall;
    function  Get_TotalTime: Integer; safecall;
    function  Get_CurrentAction: IMAPI_FORMAT2_DATA_WRITE_ACTION; safecall;
    property ElapsedTime: Integer read Get_ElapsedTime;
    property RemainingTime: Integer read Get_RemainingTime;
    property TotalTime: Integer read Get_TotalTime;
    property CurrentAction: IMAPI_FORMAT2_DATA_WRITE_ACTION read Get_CurrentAction;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2DataEventArgsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {2735413D-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2DataEventArgsDisp = dispinterface
    ['{2735413D-7F64-5B0F-8F00-5D77AFBE261E}']
    property ElapsedTime: Integer readonly dispid 768;
    property RemainingTime: Integer readonly dispid 769;
    property TotalTime: Integer readonly dispid 770;
    property CurrentAction: IMAPI_FORMAT2_DATA_WRITE_ACTION readonly dispid 771;
    property StartLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property LastReadLba: Integer readonly dispid 258;
    property LastWrittenLba: Integer readonly dispid 259;
    property TotalSystemBuffer: Integer readonly dispid 262;
    property UsedSystemBuffer: Integer readonly dispid 263;
    property FreeSystemBuffer: Integer readonly dispid 264;
  end;

// *********************************************************************//
// Interface: IDiscFormat2TrackAtOnceEventArgs
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354140-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2TrackAtOnceEventArgs = interface(IWriteEngine2EventArgs)
    ['{27354140-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Get_CurrentTrackNumber: Integer; safecall;
    function  Get_CurrentAction: IMAPI_FORMAT2_TAO_WRITE_ACTION; safecall;
    function  Get_ElapsedTime: Integer; safecall;
    function  Get_RemainingTime: Integer; safecall;
    property CurrentTrackNumber: Integer read Get_CurrentTrackNumber;
    property CurrentAction: IMAPI_FORMAT2_TAO_WRITE_ACTION read Get_CurrentAction;
    property ElapsedTime: Integer read Get_ElapsedTime;
    property RemainingTime: Integer read Get_RemainingTime;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2TrackAtOnceEventArgsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354140-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2TrackAtOnceEventArgsDisp = dispinterface
    ['{27354140-7F64-5B0F-8F00-5D77AFBE261E}']
    property CurrentTrackNumber: Integer readonly dispid 768;
    property CurrentAction: IMAPI_FORMAT2_TAO_WRITE_ACTION readonly dispid 769;
    property ElapsedTime: Integer readonly dispid 770;
    property RemainingTime: Integer readonly dispid 771;
    property StartLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property LastReadLba: Integer readonly dispid 258;
    property LastWrittenLba: Integer readonly dispid 259;
    property TotalSystemBuffer: Integer readonly dispid 262;
    property UsedSystemBuffer: Integer readonly dispid 263;
    property FreeSystemBuffer: Integer readonly dispid 264;
  end;

// *********************************************************************//
// Interface: IDiscFormat2RawCDEventArgs
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354143-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2RawCDEventArgs = interface(IWriteEngine2EventArgs)
    ['{27354143-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Get_CurrentAction: IMAPI_FORMAT2_RAW_CD_WRITE_ACTION; safecall;
    function  Get_ElapsedTime: Integer; safecall;
    function  Get_RemainingTime: Integer; safecall;
    property CurrentAction: IMAPI_FORMAT2_RAW_CD_WRITE_ACTION read Get_CurrentAction;
    property ElapsedTime: Integer read Get_ElapsedTime;
    property RemainingTime: Integer read Get_RemainingTime;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2RawCDEventArgsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354143-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2RawCDEventArgsDisp = dispinterface
    ['{27354143-7F64-5B0F-8F00-5D77AFBE261E}']
    property CurrentAction: IMAPI_FORMAT2_RAW_CD_WRITE_ACTION readonly dispid 769;
    property ElapsedTime: Integer readonly dispid 770;
    property RemainingTime: Integer readonly dispid 771;
    property StartLba: Integer readonly dispid 256;
    property SectorCount: Integer readonly dispid 257;
    property LastReadLba: Integer readonly dispid 258;
    property LastWrittenLba: Integer readonly dispid 259;
    property TotalSystemBuffer: Integer readonly dispid 262;
    property UsedSystemBuffer: Integer readonly dispid 263;
    property FreeSystemBuffer: Integer readonly dispid 264;
  end;

// *********************************************************************//
// Interface: IWriteSpeedDescriptor
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27354144-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteSpeedDescriptor = interface(IDispatch)
    ['{27354144-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Get_MediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    function  Get_RotationTypeIsPureCAV: WordBool; safecall;
    function  Get_WriteSpeed: Integer; safecall;
    property MediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_MediaType;
    property RotationTypeIsPureCAV: WordBool read Get_RotationTypeIsPureCAV;
    property WriteSpeed: Integer read Get_WriteSpeed;
  end;

// *********************************************************************//
// DispIntf:  IWriteSpeedDescriptorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {27354144-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteSpeedDescriptorDisp = dispinterface
    ['{27354144-7F64-5B0F-8F00-5D77AFBE261E}']
    property MediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 257;
    property RotationTypeIsPureCAV: WordBool readonly dispid 258;
    property WriteSpeed: Integer readonly dispid 259;
  end;

// *********************************************************************//
// Interface: DDiscMaster2Events
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {27354131-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscMaster2Events = interface(IDispatch)
    ['{27354131-7F64-5B0F-8F00-5D77AFBE261E}']
    function  NotifyDeviceAdded(const object_: IDispatch; const uniqueId: WideString): HResult; stdcall;
    function  NotifyDeviceRemoved(const object_: IDispatch; const uniqueId: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DWriteEngine2Events
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {27354137-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DWriteEngine2Events = interface(IDispatch)
    ['{27354137-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Update(const object_: IDispatch; const progress: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DDiscFormat2EraseEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {2735413A-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscFormat2EraseEvents = interface(IDispatch)
    ['{2735413A-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Update(const object_: IDispatch; elapsedSeconds: Integer; 
                     estimatedTotalSeconds: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DDiscFormat2DataEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {2735413C-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscFormat2DataEvents = interface(IDispatch)
    ['{2735413C-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Update(const object_: IDispatch; const progress: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DDiscFormat2TrackAtOnceEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {2735413F-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscFormat2TrackAtOnceEvents = interface(IDispatch)
    ['{2735413F-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Update(const object_: IDispatch; const progress: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DDiscFormat2RawCDEvents
// Flags:     (4480) NonExtensible OleAutomation Dispatchable
// GUID:      {27354142-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  DDiscFormat2RawCDEvents = interface(IDispatch)
    ['{27354142-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Update(const object_: IDispatch; const progress: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDiscMaster2
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354130-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscMaster2 = interface(IDispatch)
    ['{27354130-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Get__NewEnum: IEnumVARIANT; safecall;
    function  Get_Item(index: Integer): WideString; safecall;
    function  Get_Count: Integer; safecall;
    function  Get_IsSupportedEnvironment: WordBool; safecall;
    property _NewEnum: IEnumVARIANT read Get__NewEnum;
    property Item[index: Integer]: WideString read Get_Item; default;
    property Count: Integer read Get_Count;
    property IsSupportedEnvironment: WordBool read Get_IsSupportedEnvironment;
  end;

// *********************************************************************//
// DispIntf:  IDiscMaster2Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354130-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscMaster2Disp = dispinterface
    ['{27354130-7F64-5B0F-8F00-5D77AFBE261E}']
    property _NewEnum: IEnumVARIANT readonly dispid -4;
    property Item[index: Integer]: WideString readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    property IsSupportedEnvironment: WordBool readonly dispid 2;
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
// Interface: IDiscRecorder2Ex
// Flags:     (0)
// GUID:      {27354132-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscRecorder2Ex = interface(IUnknown)
    ['{27354132-7F64-5B0F-8F00-5D77AFBE261E}']
    function  SendCommandNoData(var Cdb: Byte; CdbSize: LongWord; SenseBuffer: PrivateAlias1; 
                                Timeout: LongWord): HResult; stdcall;
    function  SendCommandSendDataToDevice(var Cdb: Byte; CdbSize: LongWord; 
                                          SenseBuffer: PrivateAlias1; Timeout: LongWord; 
                                          var Buffer: Byte; BufferSize: LongWord): HResult; stdcall;
    function  SendCommandGetDataFromDevice(var Cdb: Byte; CdbSize: LongWord; 
                                           SenseBuffer: PrivateAlias1; Timeout: LongWord; 
                                           out Buffer: Byte; BufferSize: LongWord; 
                                           out BufferFetched: LongWord): HResult; stdcall;
    function  ReadDvdStructure(format: LongWord; address: LongWord; layer: LongWord; 
                               agid: LongWord; out data: PByte1; out Count: LongWord): HResult; stdcall;
    function  SendDvdStructure(format: LongWord; var data: Byte; Count: LongWord): HResult; stdcall;
    function  GetAdapterDescriptor(out data: PByte1; out byteSize: LongWord): HResult; stdcall;
    function  GetDeviceDescriptor(out data: PByte1; out byteSize: LongWord): HResult; stdcall;
    function  GetDiscInformation(out discInformation: PByte1; out byteSize: LongWord): HResult; stdcall;
    function  GetTrackInformation(address: LongWord; addressType: IMAPI_READ_TRACK_ADDRESS_TYPE; 
                                  out trackInformation: PByte1; out byteSize: LongWord): HResult; stdcall;
    function  GetFeaturePage(requestedFeature: IMAPI_FEATURE_PAGE_TYPE; 
                             currentFeatureOnly: Shortint; out featureData: PByte1; 
                             out byteSize: LongWord): HResult; stdcall;
    function  GetModePage(requestedModePage: IMAPI_MODE_PAGE_TYPE; 
                          requestType: IMAPI_MODE_PAGE_REQUEST_TYPE; out modePageData: PByte1; 
                          out byteSize: LongWord): HResult; stdcall;
    function  SetModePage(requestType: IMAPI_MODE_PAGE_REQUEST_TYPE; var data: Byte; 
                          byteSize: LongWord): HResult; stdcall;
    function  GetSupportedFeaturePages(currentFeatureOnly: Shortint; out featureData: PUserType2; 
                                       out byteSize: LongWord): HResult; stdcall;
    function  GetSupportedProfiles(currentOnly: Shortint; out profileTypes: PUserType3; 
                                   out validProfiles: LongWord): HResult; stdcall;
    function  GetSupportedModePages(requestType: IMAPI_MODE_PAGE_REQUEST_TYPE; 
                                    out modePageTypes: PUserType4; out validPages: LongWord): HResult; stdcall;
    function  GetByteAlignmentMask(out value: LongWord): HResult; stdcall;
    function  GetMaximumNonPageAlignedTransferSize(out value: LongWord): HResult; stdcall;
    function  GetMaximumPageAlignedTransferSize(out value: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IWriteEngine2
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354135-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteEngine2 = interface(IDispatch)
    ['{27354135-7F64-5B0F-8F00-5D77AFBE261E}']
    procedure WriteSection(const data: ISequentialStream; startingBlockAddress: Integer; 
                           numberOfBlocks: Integer); safecall;
    procedure CancelWrite; safecall;
    procedure Set_Recorder(const value: IDiscRecorder2Ex); safecall;
    function  Get_Recorder: IDiscRecorder2Ex; safecall;
    procedure Set_UseStreamingWrite12(value: WordBool); safecall;
    function  Get_UseStreamingWrite12: WordBool; safecall;
    procedure Set_StartingSectorsPerSecond(value: Integer); safecall;
    function  Get_StartingSectorsPerSecond: Integer; safecall;
    procedure Set_EndingSectorsPerSecond(value: Integer); safecall;
    function  Get_EndingSectorsPerSecond: Integer; safecall;
    procedure Set_BytesPerSector(value: Integer); safecall;
    function  Get_BytesPerSector: Integer; safecall;
    function  Get_WriteInProgress: WordBool; safecall;
    property Recorder: IDiscRecorder2Ex read Get_Recorder write Set_Recorder;
    property UseStreamingWrite12: WordBool read Get_UseStreamingWrite12 write Set_UseStreamingWrite12;
    property StartingSectorsPerSecond: Integer read Get_StartingSectorsPerSecond write Set_StartingSectorsPerSecond;
    property EndingSectorsPerSecond: Integer read Get_EndingSectorsPerSecond write Set_EndingSectorsPerSecond;
    property BytesPerSector: Integer read Get_BytesPerSector write Set_BytesPerSector;
    property WriteInProgress: WordBool read Get_WriteInProgress;
  end;

// *********************************************************************//
// DispIntf:  IWriteEngine2Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354135-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IWriteEngine2Disp = dispinterface
    ['{27354135-7F64-5B0F-8F00-5D77AFBE261E}']
    procedure WriteSection(const data: ISequentialStream; startingBlockAddress: Integer; 
                           numberOfBlocks: Integer); dispid 512;
    procedure CancelWrite; dispid 513;
    property Recorder: IDiscRecorder2Ex dispid 256;
    property UseStreamingWrite12: WordBool dispid 257;
    property StartingSectorsPerSecond: Integer dispid 258;
    property EndingSectorsPerSecond: Integer dispid 259;
    property BytesPerSector: Integer dispid 260;
    property WriteInProgress: WordBool readonly dispid 261;
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
// Interface: IDiscFormat2
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354152-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2 = interface(IDispatch)
    ['{27354152-8F64-5B0F-8F00-5D77AFBE261E}']
    function  IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; safecall;
    function  IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; safecall;
    function  Get_MediaPhysicallyBlank: WordBool; safecall;
    function  Get_MediaHeuristicallyBlank: WordBool; safecall;
    function  Get_SupportedMediaTypes: PSafeArray; safecall;
    property MediaPhysicallyBlank: WordBool read Get_MediaPhysicallyBlank;
    property MediaHeuristicallyBlank: WordBool read Get_MediaHeuristicallyBlank;
    property SupportedMediaTypes: PSafeArray read Get_SupportedMediaTypes;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2Disp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354152-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2Disp = dispinterface
    ['{27354152-8F64-5B0F-8F00-5D77AFBE261E}']
    function  IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function  IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {??PSafeArray}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IDiscFormat2Erase
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354156-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2Erase = interface(IDiscFormat2)
    ['{27354156-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure Set_Recorder(const value: IDiscRecorder2); safecall;
    function  Get_Recorder: IDiscRecorder2; safecall;
    procedure Set_FullErase(value: WordBool); safecall;
    function  Get_FullErase: WordBool; safecall;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    procedure Set_ClientName(const value: WideString); safecall;
    function  Get_ClientName: WideString; safecall;
    procedure EraseMedia; safecall;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property FullErase: WordBool read Get_FullErase write Set_FullErase;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2EraseDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354156-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2EraseDisp = dispinterface
    ['{27354156-8F64-5B0F-8F00-5D77AFBE261E}']
    property Recorder: IDiscRecorder2 dispid 256;
    property FullErase: WordBool dispid 257;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 258;
    property ClientName: WideString dispid 259;
    procedure EraseMedia; dispid 513;
    function  IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function  IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {??PSafeArray}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IDiscFormat2Data
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354153-9F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2Data = interface(IDiscFormat2)
    ['{27354153-9F64-5B0F-8F00-5D77AFBE261E}']
    procedure Set_Recorder(const value: IDiscRecorder2); safecall;
    function  Get_Recorder: IDiscRecorder2; safecall;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool); safecall;
    function  Get_BufferUnderrunFreeDisabled: WordBool; safecall;
    procedure Set_PostgapAlreadyInImage(value: WordBool); safecall;
    function  Get_PostgapAlreadyInImage: WordBool; safecall;
    function  Get_CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE; safecall;
    function  Get_WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE; safecall;
    function  Get_TotalSectorsOnMedia: Integer; safecall;
    function  Get_FreeSectorsOnMedia: Integer; safecall;
    function  Get_NextWritableAddress: Integer; safecall;
    function  Get_StartAddressOfPreviousSession: Integer; safecall;
    function  Get_LastWrittenAddressOfPreviousSession: Integer; safecall;
    procedure Set_ForceMediaToBeClosed(value: WordBool); safecall;
    function  Get_ForceMediaToBeClosed: WordBool; safecall;
    procedure Set_DisableConsumerDvdCompatibilityMode(value: WordBool); safecall;
    function  Get_DisableConsumerDvdCompatibilityMode: WordBool; safecall;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    procedure Set_ClientName(const value: WideString); safecall;
    function  Get_ClientName: WideString; safecall;
    function  Get_RequestedWriteSpeed: Integer; safecall;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool; safecall;
    function  Get_CurrentWriteSpeed: Integer; safecall;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool; safecall;
    function  Get_SupportedWriteSpeeds: PSafeArray; safecall;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray; safecall;
    procedure Set_ForceOverwrite(value: WordBool); safecall;
    function  Get_ForceOverwrite: WordBool; safecall;
    function  Get_MultisessionInterfaces: PSafeArray; safecall;
    procedure Write(const data: ISequentialStream); safecall;
    procedure CancelWrite; safecall;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); safecall;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property PostgapAlreadyInImage: WordBool read Get_PostgapAlreadyInImage write Set_PostgapAlreadyInImage;
    property CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE read Get_CurrentMediaStatus;
    property WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE read Get_WriteProtectStatus;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property NextWritableAddress: Integer read Get_NextWritableAddress;
    property StartAddressOfPreviousSession: Integer read Get_StartAddressOfPreviousSession;
    property LastWrittenAddressOfPreviousSession: Integer read Get_LastWrittenAddressOfPreviousSession;
    property ForceMediaToBeClosed: WordBool read Get_ForceMediaToBeClosed write Set_ForceMediaToBeClosed;
    property DisableConsumerDvdCompatibilityMode: WordBool read Get_DisableConsumerDvdCompatibilityMode write Set_DisableConsumerDvdCompatibilityMode;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
    property ForceOverwrite: WordBool read Get_ForceOverwrite write Set_ForceOverwrite;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2DataDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354153-9F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2DataDisp = dispinterface
    ['{27354153-9F64-5B0F-8F00-5D77AFBE261E}']
    property Recorder: IDiscRecorder2 dispid 256;
    property BufferUnderrunFreeDisabled: WordBool dispid 257;
    property PostgapAlreadyInImage: WordBool dispid 260;
    property CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE readonly dispid 262;
    property WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE readonly dispid 263;
    property TotalSectorsOnMedia: Integer readonly dispid 264;
    property FreeSectorsOnMedia: Integer readonly dispid 265;
    property NextWritableAddress: Integer readonly dispid 266;
    property StartAddressOfPreviousSession: Integer readonly dispid 267;
    property LastWrittenAddressOfPreviousSession: Integer readonly dispid 268;
    property ForceMediaToBeClosed: WordBool dispid 269;
    property DisableConsumerDvdCompatibilityMode: WordBool dispid 270;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 271;
    property ClientName: WideString dispid 272;
    property RequestedWriteSpeed: Integer readonly dispid 273;
    property RequestedRotationTypeIsPureCAV: WordBool readonly dispid 274;
    property CurrentWriteSpeed: Integer readonly dispid 275;
    property CurrentRotationTypeIsPureCAV: WordBool readonly dispid 276;
    property SupportedWriteSpeeds: {??PSafeArray}OleVariant readonly dispid 277;
    property SupportedWriteSpeedDescriptors: {??PSafeArray}OleVariant readonly dispid 278;
    property ForceOverwrite: WordBool dispid 279;
    property MultisessionInterfaces: {??PSafeArray}OleVariant readonly dispid 280;
    procedure Write(const data: ISequentialStream); dispid 512;
    procedure CancelWrite; dispid 513;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); dispid 514;
    function  IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function  IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {??PSafeArray}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IDiscFormat2TrackAtOnce
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354154-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2TrackAtOnce = interface(IDiscFormat2)
    ['{27354154-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure PrepareMedia; safecall;
    procedure AddAudioTrack(const data: ISequentialStream); safecall;
    procedure CancelAddTrack; safecall;
    procedure ReleaseMedia; safecall;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); safecall;
    procedure Set_Recorder(const value: IDiscRecorder2); safecall;
    function  Get_Recorder: IDiscRecorder2; safecall;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool); safecall;
    function  Get_BufferUnderrunFreeDisabled: WordBool; safecall;
    function  Get_NumberOfExistingTracks: Integer; safecall;
    function  Get_TotalSectorsOnMedia: Integer; safecall;
    function  Get_FreeSectorsOnMedia: Integer; safecall;
    function  Get_UsedSectorsOnMedia: Integer; safecall;
    procedure Set_DoNotFinalizeMedia(value: WordBool); safecall;
    function  Get_DoNotFinalizeMedia: WordBool; safecall;
    function  Get_ExpectedTableOfContents: PSafeArray; safecall;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    procedure Set_ClientName(const value: WideString); safecall;
    function  Get_ClientName: WideString; safecall;
    function  Get_RequestedWriteSpeed: Integer; safecall;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool; safecall;
    function  Get_CurrentWriteSpeed: Integer; safecall;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool; safecall;
    function  Get_SupportedWriteSpeeds: PSafeArray; safecall;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray; safecall;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property NumberOfExistingTracks: Integer read Get_NumberOfExistingTracks;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property UsedSectorsOnMedia: Integer read Get_UsedSectorsOnMedia;
    property DoNotFinalizeMedia: WordBool read Get_DoNotFinalizeMedia write Set_DoNotFinalizeMedia;
    property ExpectedTableOfContents: PSafeArray read Get_ExpectedTableOfContents;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2TrackAtOnceDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354154-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2TrackAtOnceDisp = dispinterface
    ['{27354154-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure PrepareMedia; dispid 512;
    procedure AddAudioTrack(const data: ISequentialStream); dispid 513;
    procedure CancelAddTrack; dispid 514;
    procedure ReleaseMedia; dispid 515;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); dispid 516;
    property Recorder: IDiscRecorder2 dispid 256;
    property BufferUnderrunFreeDisabled: WordBool dispid 258;
    property NumberOfExistingTracks: Integer readonly dispid 259;
    property TotalSectorsOnMedia: Integer readonly dispid 260;
    property FreeSectorsOnMedia: Integer readonly dispid 261;
    property UsedSectorsOnMedia: Integer readonly dispid 262;
    property DoNotFinalizeMedia: WordBool dispid 263;
    property ExpectedTableOfContents: {??PSafeArray}OleVariant readonly dispid 266;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 267;
    property ClientName: WideString dispid 270;
    property RequestedWriteSpeed: Integer readonly dispid 271;
    property RequestedRotationTypeIsPureCAV: WordBool readonly dispid 272;
    property CurrentWriteSpeed: Integer readonly dispid 273;
    property CurrentRotationTypeIsPureCAV: WordBool readonly dispid 274;
    property SupportedWriteSpeeds: {??PSafeArray}OleVariant readonly dispid 275;
    property SupportedWriteSpeedDescriptors: {??PSafeArray}OleVariant readonly dispid 276;
    function  IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function  IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {??PSafeArray}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IDiscFormat2RawCD
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354155-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2RawCD = interface(IDiscFormat2)
    ['{27354155-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure PrepareMedia; safecall;
    procedure WriteMedia(const data: ISequentialStream); safecall;
    procedure WriteMedia2(const data: ISequentialStream; streamLeadInSectors: Integer); safecall;
    procedure CancelWrite; safecall;
    procedure ReleaseMedia; safecall;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); safecall;
    procedure Set_Recorder(const value: IDiscRecorder2); safecall;
    function  Get_Recorder: IDiscRecorder2; safecall;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool); safecall;
    function  Get_BufferUnderrunFreeDisabled: WordBool; safecall;
    function  Get_StartOfNextSession: Integer; safecall;
    function  Get_LastPossibleStartOfLeadout: Integer; safecall;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE; safecall;
    function  Get_SupportedSectorTypes: PSafeArray; safecall;
    procedure Set_RequestedSectorType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE); safecall;
    function  Get_RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE; safecall;
    procedure Set_ClientName(const value: WideString); safecall;
    function  Get_ClientName: WideString; safecall;
    function  Get_RequestedWriteSpeed: Integer; safecall;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool; safecall;
    function  Get_CurrentWriteSpeed: Integer; safecall;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool; safecall;
    function  Get_SupportedWriteSpeeds: PSafeArray; safecall;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray; safecall;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property StartOfNextSession: Integer read Get_StartOfNextSession;
    property LastPossibleStartOfLeadout: Integer read Get_LastPossibleStartOfLeadout;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property SupportedSectorTypes: PSafeArray read Get_SupportedSectorTypes;
    property RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE read Get_RequestedSectorType write Set_RequestedSectorType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
  end;

// *********************************************************************//
// DispIntf:  IDiscFormat2RawCDDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27354155-8F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IDiscFormat2RawCDDisp = dispinterface
    ['{27354155-8F64-5B0F-8F00-5D77AFBE261E}']
    procedure PrepareMedia; dispid 512;
    procedure WriteMedia(const data: ISequentialStream); dispid 513;
    procedure WriteMedia2(const data: ISequentialStream; streamLeadInSectors: Integer); dispid 514;
    procedure CancelWrite; dispid 515;
    procedure ReleaseMedia; dispid 516;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool); dispid 517;
    property Recorder: IDiscRecorder2 dispid 256;
    property BufferUnderrunFreeDisabled: WordBool dispid 258;
    property StartOfNextSession: Integer readonly dispid 259;
    property LastPossibleStartOfLeadout: Integer readonly dispid 260;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE readonly dispid 261;
    property SupportedSectorTypes: {??PSafeArray}OleVariant readonly dispid 264;
    property RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE dispid 265;
    property ClientName: WideString dispid 266;
    property RequestedWriteSpeed: Integer readonly dispid 267;
    property RequestedRotationTypeIsPureCAV: WordBool readonly dispid 268;
    property CurrentWriteSpeed: Integer readonly dispid 269;
    property CurrentRotationTypeIsPureCAV: WordBool readonly dispid 270;
    property SupportedWriteSpeeds: {??PSafeArray}OleVariant readonly dispid 271;
    property SupportedWriteSpeedDescriptors: {??PSafeArray}OleVariant readonly dispid 272;
    function  IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2048;
    function  IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool; dispid 2049;
    property MediaPhysicallyBlank: WordBool readonly dispid 1792;
    property MediaHeuristicallyBlank: WordBool readonly dispid 1793;
    property SupportedMediaTypes: {??PSafeArray}OleVariant readonly dispid 1794;
  end;

// *********************************************************************//
// Interface: IStreamPseudoRandomBased
// Flags:     (0)
// GUID:      {27354145-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IStreamPseudoRandomBased = interface(IStream)
    ['{27354145-7F64-5B0F-8F00-5D77AFBE261E}']
    function  put_Seed(value: LongWord): HResult; stdcall;
    function  get_Seed(out value: LongWord): HResult; stdcall;
    function  put_ExtendedSeed(var values: LongWord; eCount: LongWord): HResult; stdcall;
    function  get_ExtendedSeed(out values: PUINT1; out eCount: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IStreamConcatenate
// Flags:     (0)
// GUID:      {27354146-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IStreamConcatenate = interface(IStream)
    ['{27354146-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Initialize(const stream1: ISequentialStream; const stream2: ISequentialStream): HResult; stdcall;
    function  Initialize2(var streams: ISequentialStream; streamCount: LongWord): HResult; stdcall;
    function  Append(const stream: ISequentialStream): HResult; stdcall;
    function  Append2(var streams: ISequentialStream; streamCount: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IStreamInterleave
// Flags:     (0)
// GUID:      {27354147-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IStreamInterleave = interface(IStream)
    ['{27354147-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Initialize(var streams: ISequentialStream; var interleaveSizes: LongWord; 
                         streamCount: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IMultisession
// Flags:     (4096) Dispatchable
// GUID:      {27354150-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IMultisession = interface(IDispatch)
    ['{27354150-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Get_IsSupportedOnCurrentMediaState(out value: WordBool): HResult; stdcall;
    function  Set_InUse(value: WordBool): HResult; stdcall;
    function  Get_InUse(out value: WordBool): HResult; stdcall;
    function  Get_ImportRecorder(out value: IDiscRecorder2): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IMultisessionSequential
// Flags:     (4096) Dispatchable
// GUID:      {27354151-7F64-5B0F-8F00-5D77AFBE261E}
// *********************************************************************//
  IMultisessionSequential = interface(IMultisession)
    ['{27354151-7F64-5B0F-8F00-5D77AFBE261E}']
    function  Get_IsFirstDataSession(out value: WordBool): HResult; stdcall;
    function  Get_StartAddressOfPreviousSession(out value: Integer): HResult; stdcall;
    function  Get_LastWrittenAddressOfPreviousSession(out value: Integer): HResult; stdcall;
    function  Get_NextWritableAddress(out value: Integer): HResult; stdcall;
    function  Get_FreeSectorsOnMedia(out value: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoMsftDiscMaster2 provides a Create and CreateRemote method to          
// create instances of the default interface IDiscMaster2 exposed by              
// the CoClass MsftDiscMaster2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscMaster2 = class
    class function Create: IDiscMaster2;
    class function CreateRemote(const MachineName: string): IDiscMaster2;
  end;

  TMsftDiscMaster2NotifyDeviceAdded = procedure(Sender: TObject; var object_: OleVariant;
                                                                 var uniqueId: OleVariant) of object;
  TMsftDiscMaster2NotifyDeviceRemoved = procedure(Sender: TObject; var object_: OleVariant;
                                                                   var uniqueId: OleVariant) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscMaster2
// Help String      : Microsoft IMAPIv2 Disc Master
// Default Interface: IDiscMaster2
// Def. Intf. DISP? : No
// Event   Interface: DDiscMaster2Events
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftDiscMaster2Properties= class;
{$ENDIF}
  TMsftDiscMaster2 = class(TOleServer)
  private
    FOnNotifyDeviceAdded: TMsftDiscMaster2NotifyDeviceAdded;
    FOnNotifyDeviceRemoved: TMsftDiscMaster2NotifyDeviceRemoved;
    FIntf:        IDiscMaster2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftDiscMaster2Properties;
    function      GetServerProperties: TMsftDiscMaster2Properties;
{$ENDIF}
    function      GetDefaultInterface: IDiscMaster2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function  Get_Item(index: Integer): WideString;
    function  Get_Count: Integer;
    function  Get_IsSupportedEnvironment: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscMaster2);
    procedure Disconnect; override;
    property  DefaultInterface: IDiscMaster2 read GetDefaultInterface;
    property Item[index: Integer]: WideString read Get_Item; default;
    property Count: Integer read Get_Count;
    property IsSupportedEnvironment: WordBool read Get_IsSupportedEnvironment;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftDiscMaster2Properties read GetServerProperties;
{$ENDIF}
    property OnNotifyDeviceAdded: TMsftDiscMaster2NotifyDeviceAdded read FOnNotifyDeviceAdded write FOnNotifyDeviceAdded;
    property OnNotifyDeviceRemoved: TMsftDiscMaster2NotifyDeviceRemoved read FOnNotifyDeviceRemoved write FOnNotifyDeviceRemoved;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftDiscMaster2
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftDiscMaster2Properties = class(TPersistent)
  private
    FServer:    TMsftDiscMaster2;
    function    GetDefaultInterface: IDiscMaster2;
    constructor Create(AServer: TMsftDiscMaster2);
  protected
    function  Get_Item(index: Integer): WideString;
    function  Get_Count: Integer;
    function  Get_IsSupportedEnvironment: WordBool;
  public
    property DefaultInterface: IDiscMaster2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftDiscRecorder2 provides a Create and CreateRemote method to          
// create instances of the default interface IDiscRecorder2 exposed by              
// the CoClass MsftDiscRecorder2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscRecorder2 = class
    class function Create: IDiscRecorder2;
    class function CreateRemote(const MachineName: string): IDiscRecorder2;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscRecorder2
// Help String      : Microsoft IMAPIv2 Disc Recorder
// Default Interface: IDiscRecorder2
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftDiscRecorder2Properties= class;
{$ENDIF}
  TMsftDiscRecorder2 = class(TOleServer)
  private
    FIntf:        IDiscRecorder2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftDiscRecorder2Properties;
    function      GetServerProperties: TMsftDiscRecorder2Properties;
{$ENDIF}
    function      GetDefaultInterface: IDiscRecorder2;
  protected
    procedure InitServerData; override;
    function  Get_ActiveDiscRecorder: WideString;
    function  Get_VendorId: WideString;
    function  Get_ProductId: WideString;
    function  Get_ProductRevision: WideString;
    function  Get_VolumeName: WideString;
    function  Get_VolumePathNames: PSafeArray;
    function  Get_DeviceCanLoadMedia: WordBool;
    function  Get_LegacyDeviceNumber: Integer;
    function  Get_SupportedFeaturePages: PSafeArray;
    function  Get_CurrentFeaturePages: PSafeArray;
    function  Get_SupportedProfiles: PSafeArray;
    function  Get_CurrentProfiles: PSafeArray;
    function  Get_SupportedModePages: PSafeArray;
    function  Get_ExclusiveAccessOwner: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscRecorder2);
    procedure Disconnect; override;
    procedure EjectMedia;
    procedure CloseTray;
    procedure AcquireExclusiveAccess(force: WordBool; const __MIDL_0015: WideString);
    procedure ReleaseExclusiveAccess;
    procedure DisableMcn;
    procedure EnableMcn;
    procedure InitializeDiscRecorder(const recorderUniqueId: WideString);
    property  DefaultInterface: IDiscRecorder2 read GetDefaultInterface;
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
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftDiscRecorder2Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftDiscRecorder2
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftDiscRecorder2Properties = class(TPersistent)
  private
    FServer:    TMsftDiscRecorder2;
    function    GetDefaultInterface: IDiscRecorder2;
    constructor Create(AServer: TMsftDiscRecorder2);
  protected
    function  Get_ActiveDiscRecorder: WideString;
    function  Get_VendorId: WideString;
    function  Get_ProductId: WideString;
    function  Get_ProductRevision: WideString;
    function  Get_VolumeName: WideString;
    function  Get_VolumePathNames: PSafeArray;
    function  Get_DeviceCanLoadMedia: WordBool;
    function  Get_LegacyDeviceNumber: Integer;
    function  Get_SupportedFeaturePages: PSafeArray;
    function  Get_CurrentFeaturePages: PSafeArray;
    function  Get_SupportedProfiles: PSafeArray;
    function  Get_CurrentProfiles: PSafeArray;
    function  Get_SupportedModePages: PSafeArray;
    function  Get_ExclusiveAccessOwner: WideString;
  public
    property DefaultInterface: IDiscRecorder2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftWriteEngine2 provides a Create and CreateRemote method to          
// create instances of the default interface IWriteEngine2 exposed by              
// the CoClass MsftWriteEngine2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftWriteEngine2 = class
    class function Create: IWriteEngine2;
    class function CreateRemote(const MachineName: string): IWriteEngine2;
  end;

  TMsftWriteEngine2Update = procedure(Sender: TObject; var object_: OleVariant;
                                                       var progress: OleVariant) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftWriteEngine2
// Help String      : Microsoft IMAPIv2 CD Write Engine
// Default Interface: IWriteEngine2
// Def. Intf. DISP? : No
// Event   Interface: DWriteEngine2Events
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftWriteEngine2Properties= class;
{$ENDIF}
  TMsftWriteEngine2 = class(TOleServer)
  private
    FOnUpdate: TMsftWriteEngine2Update;
    FIntf:        IWriteEngine2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftWriteEngine2Properties;
    function      GetServerProperties: TMsftWriteEngine2Properties;
{$ENDIF}
    function      GetDefaultInterface: IWriteEngine2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2Ex);
    function  Get_Recorder: IDiscRecorder2Ex;
    procedure Set_UseStreamingWrite12(value: WordBool);
    function  Get_UseStreamingWrite12: WordBool;
    procedure Set_StartingSectorsPerSecond(value: Integer);
    function  Get_StartingSectorsPerSecond: Integer;
    procedure Set_EndingSectorsPerSecond(value: Integer);
    function  Get_EndingSectorsPerSecond: Integer;
    procedure Set_BytesPerSector(value: Integer);
    function  Get_BytesPerSector: Integer;
    function  Get_WriteInProgress: WordBool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IWriteEngine2);
    procedure Disconnect; override;
    procedure WriteSection(const data: ISequentialStream; startingBlockAddress: Integer; 
                           numberOfBlocks: Integer);
    procedure CancelWrite;
    property  DefaultInterface: IWriteEngine2 read GetDefaultInterface;
    property WriteInProgress: WordBool read Get_WriteInProgress;
    property Recorder: IDiscRecorder2Ex read Get_Recorder write Set_Recorder;
    property UseStreamingWrite12: WordBool read Get_UseStreamingWrite12 write Set_UseStreamingWrite12;
    property StartingSectorsPerSecond: Integer read Get_StartingSectorsPerSecond write Set_StartingSectorsPerSecond;
    property EndingSectorsPerSecond: Integer read Get_EndingSectorsPerSecond write Set_EndingSectorsPerSecond;
    property BytesPerSector: Integer read Get_BytesPerSector write Set_BytesPerSector;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftWriteEngine2Properties read GetServerProperties;
{$ENDIF}
    property OnUpdate: TMsftWriteEngine2Update read FOnUpdate write FOnUpdate;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftWriteEngine2
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftWriteEngine2Properties = class(TPersistent)
  private
    FServer:    TMsftWriteEngine2;
    function    GetDefaultInterface: IWriteEngine2;
    constructor Create(AServer: TMsftWriteEngine2);
  protected
    procedure Set_Recorder(const value: IDiscRecorder2Ex);
    function  Get_Recorder: IDiscRecorder2Ex;
    procedure Set_UseStreamingWrite12(value: WordBool);
    function  Get_UseStreamingWrite12: WordBool;
    procedure Set_StartingSectorsPerSecond(value: Integer);
    function  Get_StartingSectorsPerSecond: Integer;
    procedure Set_EndingSectorsPerSecond(value: Integer);
    function  Get_EndingSectorsPerSecond: Integer;
    procedure Set_BytesPerSector(value: Integer);
    function  Get_BytesPerSector: Integer;
    function  Get_WriteInProgress: WordBool;
  public
    property DefaultInterface: IWriteEngine2 read GetDefaultInterface;
  published
    property Recorder: IDiscRecorder2Ex read Get_Recorder write Set_Recorder;
    property UseStreamingWrite12: WordBool read Get_UseStreamingWrite12 write Set_UseStreamingWrite12;
    property StartingSectorsPerSecond: Integer read Get_StartingSectorsPerSecond write Set_StartingSectorsPerSecond;
    property EndingSectorsPerSecond: Integer read Get_EndingSectorsPerSecond write Set_EndingSectorsPerSecond;
    property BytesPerSector: Integer read Get_BytesPerSector write Set_BytesPerSector;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftDiscFormat2Erase provides a Create and CreateRemote method to          
// create instances of the default interface IDiscFormat2 exposed by              
// the CoClass MsftDiscFormat2Erase. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscFormat2Erase = class
    class function Create: IDiscFormat2;
    class function CreateRemote(const MachineName: string): IDiscFormat2;
  end;

  TMsftDiscFormat2EraseUpdate = procedure(Sender: TObject; var object_: OleVariant;
                                                           elapsedSeconds: Integer; 
                                                           estimatedTotalSeconds: Integer) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscFormat2Erase
// Help String      : Microsoft IMAPIv2 Media Erase/Blank
// Default Interface: IDiscFormat2
// Def. Intf. DISP? : No
// Event   Interface: DDiscFormat2EraseEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftDiscFormat2EraseProperties= class;
{$ENDIF}
  TMsftDiscFormat2Erase = class(TOleServer)
  private
    FOnUpdate: TMsftDiscFormat2EraseUpdate;
    FIntf:        IDiscFormat2;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftDiscFormat2EraseProperties;
    function      GetServerProperties: TMsftDiscFormat2EraseProperties;
{$ENDIF}
    function      GetDefaultInterface: IDiscFormat2;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function  Get_MediaPhysicallyBlank: WordBool;
    function  Get_MediaHeuristicallyBlank: WordBool;
    function  Get_SupportedMediaTypes: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscFormat2);
    procedure Disconnect; override;
    function  IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool;
    function  IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool;
    property  DefaultInterface: IDiscFormat2 read GetDefaultInterface;
    property MediaPhysicallyBlank: WordBool read Get_MediaPhysicallyBlank;
    property MediaHeuristicallyBlank: WordBool read Get_MediaHeuristicallyBlank;
    property SupportedMediaTypes: PSafeArray read Get_SupportedMediaTypes;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftDiscFormat2EraseProperties read GetServerProperties;
{$ENDIF}
    property OnUpdate: TMsftDiscFormat2EraseUpdate read FOnUpdate write FOnUpdate;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftDiscFormat2Erase
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftDiscFormat2EraseProperties = class(TPersistent)
  private
    FServer:    TMsftDiscFormat2Erase;
    function    GetDefaultInterface: IDiscFormat2;
    constructor Create(AServer: TMsftDiscFormat2Erase);
  protected
    function  Get_MediaPhysicallyBlank: WordBool;
    function  Get_MediaHeuristicallyBlank: WordBool;
    function  Get_SupportedMediaTypes: PSafeArray;
  public
    property DefaultInterface: IDiscFormat2 read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftDiscFormat2Data provides a Create and CreateRemote method to          
// create instances of the default interface IDiscFormat2Data exposed by              
// the CoClass MsftDiscFormat2Data. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscFormat2Data = class
    class function Create: IDiscFormat2Data;
    class function CreateRemote(const MachineName: string): IDiscFormat2Data;
  end;

  TMsftDiscFormat2DataUpdate = procedure(Sender: TObject; var object_: OleVariant;
                                                          var progress: OleVariant) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscFormat2Data
// Help String      : Microsoft IMAPIv2 Data Writer
// Default Interface: IDiscFormat2Data
// Def. Intf. DISP? : No
// Event   Interface: DDiscFormat2DataEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftDiscFormat2DataProperties= class;
{$ENDIF}
  TMsftDiscFormat2Data = class(TOleServer)
  private
    FOnUpdate: TMsftDiscFormat2DataUpdate;
    FIntf:        IDiscFormat2Data;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftDiscFormat2DataProperties;
    function      GetServerProperties: TMsftDiscFormat2DataProperties;
{$ENDIF}
    function      GetDefaultInterface: IDiscFormat2Data;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2);
    function  Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function  Get_BufferUnderrunFreeDisabled: WordBool;
    procedure Set_PostgapAlreadyInImage(value: WordBool);
    function  Get_PostgapAlreadyInImage: WordBool;
    function  Get_CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE;
    function  Get_WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE;
    function  Get_TotalSectorsOnMedia: Integer;
    function  Get_FreeSectorsOnMedia: Integer;
    function  Get_NextWritableAddress: Integer;
    function  Get_StartAddressOfPreviousSession: Integer;
    function  Get_LastWrittenAddressOfPreviousSession: Integer;
    procedure Set_ForceMediaToBeClosed(value: WordBool);
    function  Get_ForceMediaToBeClosed: WordBool;
    procedure Set_DisableConsumerDvdCompatibilityMode(value: WordBool);
    function  Get_DisableConsumerDvdCompatibilityMode: WordBool;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    procedure Set_ClientName(const value: WideString);
    function  Get_ClientName: WideString;
    function  Get_RequestedWriteSpeed: Integer;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool;
    function  Get_CurrentWriteSpeed: Integer;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool;
    function  Get_SupportedWriteSpeeds: PSafeArray;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray;
    procedure Set_ForceOverwrite(value: WordBool);
    function  Get_ForceOverwrite: WordBool;
    function  Get_MultisessionInterfaces: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscFormat2Data);
    procedure Disconnect; override;
    procedure Write(const data: ISequentialStream);
    procedure CancelWrite;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool);
    property  DefaultInterface: IDiscFormat2Data read GetDefaultInterface;
    property CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE read Get_CurrentMediaStatus;
    property WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE read Get_WriteProtectStatus;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property NextWritableAddress: Integer read Get_NextWritableAddress;
    property StartAddressOfPreviousSession: Integer read Get_StartAddressOfPreviousSession;
    property LastWrittenAddressOfPreviousSession: Integer read Get_LastWrittenAddressOfPreviousSession;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
    property MultisessionInterfaces: PSafeArray read Get_MultisessionInterfaces;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property PostgapAlreadyInImage: WordBool read Get_PostgapAlreadyInImage write Set_PostgapAlreadyInImage;
    property ForceMediaToBeClosed: WordBool read Get_ForceMediaToBeClosed write Set_ForceMediaToBeClosed;
    property DisableConsumerDvdCompatibilityMode: WordBool read Get_DisableConsumerDvdCompatibilityMode write Set_DisableConsumerDvdCompatibilityMode;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property ForceOverwrite: WordBool read Get_ForceOverwrite write Set_ForceOverwrite;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftDiscFormat2DataProperties read GetServerProperties;
{$ENDIF}
    property OnUpdate: TMsftDiscFormat2DataUpdate read FOnUpdate write FOnUpdate;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftDiscFormat2Data
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftDiscFormat2DataProperties = class(TPersistent)
  private
    FServer:    TMsftDiscFormat2Data;
    function    GetDefaultInterface: IDiscFormat2Data;
    constructor Create(AServer: TMsftDiscFormat2Data);
  protected
    procedure Set_Recorder(const value: IDiscRecorder2);
    function  Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function  Get_BufferUnderrunFreeDisabled: WordBool;
    procedure Set_PostgapAlreadyInImage(value: WordBool);
    function  Get_PostgapAlreadyInImage: WordBool;
    function  Get_CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE;
    function  Get_WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE;
    function  Get_TotalSectorsOnMedia: Integer;
    function  Get_FreeSectorsOnMedia: Integer;
    function  Get_NextWritableAddress: Integer;
    function  Get_StartAddressOfPreviousSession: Integer;
    function  Get_LastWrittenAddressOfPreviousSession: Integer;
    procedure Set_ForceMediaToBeClosed(value: WordBool);
    function  Get_ForceMediaToBeClosed: WordBool;
    procedure Set_DisableConsumerDvdCompatibilityMode(value: WordBool);
    function  Get_DisableConsumerDvdCompatibilityMode: WordBool;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    procedure Set_ClientName(const value: WideString);
    function  Get_ClientName: WideString;
    function  Get_RequestedWriteSpeed: Integer;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool;
    function  Get_CurrentWriteSpeed: Integer;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool;
    function  Get_SupportedWriteSpeeds: PSafeArray;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray;
    procedure Set_ForceOverwrite(value: WordBool);
    function  Get_ForceOverwrite: WordBool;
    function  Get_MultisessionInterfaces: PSafeArray;
  public
    property DefaultInterface: IDiscFormat2Data read GetDefaultInterface;
  published
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property PostgapAlreadyInImage: WordBool read Get_PostgapAlreadyInImage write Set_PostgapAlreadyInImage;
    property ForceMediaToBeClosed: WordBool read Get_ForceMediaToBeClosed write Set_ForceMediaToBeClosed;
    property DisableConsumerDvdCompatibilityMode: WordBool read Get_DisableConsumerDvdCompatibilityMode write Set_DisableConsumerDvdCompatibilityMode;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
    property ForceOverwrite: WordBool read Get_ForceOverwrite write Set_ForceOverwrite;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftDiscFormat2TrackAtOnce provides a Create and CreateRemote method to          
// create instances of the default interface IDiscFormat2TrackAtOnce exposed by              
// the CoClass MsftDiscFormat2TrackAtOnce. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscFormat2TrackAtOnce = class
    class function Create: IDiscFormat2TrackAtOnce;
    class function CreateRemote(const MachineName: string): IDiscFormat2TrackAtOnce;
  end;

  TMsftDiscFormat2TrackAtOnceUpdate = procedure(Sender: TObject; var object_: OleVariant;
                                                                 var progress: OleVariant) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscFormat2TrackAtOnce
// Help String      : Microsoft IMAPIv2 Track-at-Once Audio CD Writer
// Default Interface: IDiscFormat2TrackAtOnce
// Def. Intf. DISP? : No
// Event   Interface: DDiscFormat2TrackAtOnceEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftDiscFormat2TrackAtOnceProperties= class;
{$ENDIF}
  TMsftDiscFormat2TrackAtOnce = class(TOleServer)
  private
    FOnUpdate: TMsftDiscFormat2TrackAtOnceUpdate;
    FIntf:        IDiscFormat2TrackAtOnce;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftDiscFormat2TrackAtOnceProperties;
    function      GetServerProperties: TMsftDiscFormat2TrackAtOnceProperties;
{$ENDIF}
    function      GetDefaultInterface: IDiscFormat2TrackAtOnce;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2);
    function  Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function  Get_BufferUnderrunFreeDisabled: WordBool;
    function  Get_NumberOfExistingTracks: Integer;
    function  Get_TotalSectorsOnMedia: Integer;
    function  Get_FreeSectorsOnMedia: Integer;
    function  Get_UsedSectorsOnMedia: Integer;
    procedure Set_DoNotFinalizeMedia(value: WordBool);
    function  Get_DoNotFinalizeMedia: WordBool;
    function  Get_ExpectedTableOfContents: PSafeArray;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    procedure Set_ClientName(const value: WideString);
    function  Get_ClientName: WideString;
    function  Get_RequestedWriteSpeed: Integer;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool;
    function  Get_CurrentWriteSpeed: Integer;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool;
    function  Get_SupportedWriteSpeeds: PSafeArray;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscFormat2TrackAtOnce);
    procedure Disconnect; override;
    procedure PrepareMedia;
    procedure AddAudioTrack(const data: ISequentialStream);
    procedure CancelAddTrack;
    procedure ReleaseMedia;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool);
    property  DefaultInterface: IDiscFormat2TrackAtOnce read GetDefaultInterface;
    property NumberOfExistingTracks: Integer read Get_NumberOfExistingTracks;
    property TotalSectorsOnMedia: Integer read Get_TotalSectorsOnMedia;
    property FreeSectorsOnMedia: Integer read Get_FreeSectorsOnMedia;
    property UsedSectorsOnMedia: Integer read Get_UsedSectorsOnMedia;
    property ExpectedTableOfContents: PSafeArray read Get_ExpectedTableOfContents;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property DoNotFinalizeMedia: WordBool read Get_DoNotFinalizeMedia write Set_DoNotFinalizeMedia;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftDiscFormat2TrackAtOnceProperties read GetServerProperties;
{$ENDIF}
    property OnUpdate: TMsftDiscFormat2TrackAtOnceUpdate read FOnUpdate write FOnUpdate;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftDiscFormat2TrackAtOnce
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftDiscFormat2TrackAtOnceProperties = class(TPersistent)
  private
    FServer:    TMsftDiscFormat2TrackAtOnce;
    function    GetDefaultInterface: IDiscFormat2TrackAtOnce;
    constructor Create(AServer: TMsftDiscFormat2TrackAtOnce);
  protected
    procedure Set_Recorder(const value: IDiscRecorder2);
    function  Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function  Get_BufferUnderrunFreeDisabled: WordBool;
    function  Get_NumberOfExistingTracks: Integer;
    function  Get_TotalSectorsOnMedia: Integer;
    function  Get_FreeSectorsOnMedia: Integer;
    function  Get_UsedSectorsOnMedia: Integer;
    procedure Set_DoNotFinalizeMedia(value: WordBool);
    function  Get_DoNotFinalizeMedia: WordBool;
    function  Get_ExpectedTableOfContents: PSafeArray;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    procedure Set_ClientName(const value: WideString);
    function  Get_ClientName: WideString;
    function  Get_RequestedWriteSpeed: Integer;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool;
    function  Get_CurrentWriteSpeed: Integer;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool;
    function  Get_SupportedWriteSpeeds: PSafeArray;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray;
  public
    property DefaultInterface: IDiscFormat2TrackAtOnce read GetDefaultInterface;
  published
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property DoNotFinalizeMedia: WordBool read Get_DoNotFinalizeMedia write Set_DoNotFinalizeMedia;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftDiscFormat2RawCD provides a Create and CreateRemote method to          
// create instances of the default interface IDiscFormat2RawCD exposed by              
// the CoClass MsftDiscFormat2RawCD. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftDiscFormat2RawCD = class
    class function Create: IDiscFormat2RawCD;
    class function CreateRemote(const MachineName: string): IDiscFormat2RawCD;
  end;

  TMsftDiscFormat2RawCDUpdate = procedure(Sender: TObject; var object_: OleVariant;
                                                           var progress: OleVariant) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftDiscFormat2RawCD
// Help String      : Microsoft IMAPIv2 Disc-at-Once RAW CD Image Writer
// Default Interface: IDiscFormat2RawCD
// Def. Intf. DISP? : No
// Event   Interface: DDiscFormat2RawCDEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftDiscFormat2RawCDProperties= class;
{$ENDIF}
  TMsftDiscFormat2RawCD = class(TOleServer)
  private
    FOnUpdate: TMsftDiscFormat2RawCDUpdate;
    FIntf:        IDiscFormat2RawCD;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftDiscFormat2RawCDProperties;
    function      GetServerProperties: TMsftDiscFormat2RawCDProperties;
{$ENDIF}
    function      GetDefaultInterface: IDiscFormat2RawCD;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    procedure Set_Recorder(const value: IDiscRecorder2);
    function  Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function  Get_BufferUnderrunFreeDisabled: WordBool;
    function  Get_StartOfNextSession: Integer;
    function  Get_LastPossibleStartOfLeadout: Integer;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    function  Get_SupportedSectorTypes: PSafeArray;
    procedure Set_RequestedSectorType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE);
    function  Get_RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE;
    procedure Set_ClientName(const value: WideString);
    function  Get_ClientName: WideString;
    function  Get_RequestedWriteSpeed: Integer;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool;
    function  Get_CurrentWriteSpeed: Integer;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool;
    function  Get_SupportedWriteSpeeds: PSafeArray;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDiscFormat2RawCD);
    procedure Disconnect; override;
    procedure PrepareMedia;
    procedure WriteMedia(const data: ISequentialStream);
    procedure WriteMedia2(const data: ISequentialStream; streamLeadInSectors: Integer);
    procedure CancelWrite;
    procedure ReleaseMedia;
    procedure SetWriteSpeed(RequestedSectorsPerSecond: Integer; RotationTypeIsPureCAV: WordBool);
    property  DefaultInterface: IDiscFormat2RawCD read GetDefaultInterface;
    property StartOfNextSession: Integer read Get_StartOfNextSession;
    property LastPossibleStartOfLeadout: Integer read Get_LastPossibleStartOfLeadout;
    property CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE read Get_CurrentPhysicalMediaType;
    property SupportedSectorTypes: PSafeArray read Get_SupportedSectorTypes;
    property RequestedWriteSpeed: Integer read Get_RequestedWriteSpeed;
    property RequestedRotationTypeIsPureCAV: WordBool read Get_RequestedRotationTypeIsPureCAV;
    property CurrentWriteSpeed: Integer read Get_CurrentWriteSpeed;
    property CurrentRotationTypeIsPureCAV: WordBool read Get_CurrentRotationTypeIsPureCAV;
    property SupportedWriteSpeeds: PSafeArray read Get_SupportedWriteSpeeds;
    property SupportedWriteSpeedDescriptors: PSafeArray read Get_SupportedWriteSpeedDescriptors;
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE read Get_RequestedSectorType write Set_RequestedSectorType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftDiscFormat2RawCDProperties read GetServerProperties;
{$ENDIF}
    property OnUpdate: TMsftDiscFormat2RawCDUpdate read FOnUpdate write FOnUpdate;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftDiscFormat2RawCD
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftDiscFormat2RawCDProperties = class(TPersistent)
  private
    FServer:    TMsftDiscFormat2RawCD;
    function    GetDefaultInterface: IDiscFormat2RawCD;
    constructor Create(AServer: TMsftDiscFormat2RawCD);
  protected
    procedure Set_Recorder(const value: IDiscRecorder2);
    function  Get_Recorder: IDiscRecorder2;
    procedure Set_BufferUnderrunFreeDisabled(value: WordBool);
    function  Get_BufferUnderrunFreeDisabled: WordBool;
    function  Get_StartOfNextSession: Integer;
    function  Get_LastPossibleStartOfLeadout: Integer;
    function  Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
    function  Get_SupportedSectorTypes: PSafeArray;
    procedure Set_RequestedSectorType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE);
    function  Get_RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE;
    procedure Set_ClientName(const value: WideString);
    function  Get_ClientName: WideString;
    function  Get_RequestedWriteSpeed: Integer;
    function  Get_RequestedRotationTypeIsPureCAV: WordBool;
    function  Get_CurrentWriteSpeed: Integer;
    function  Get_CurrentRotationTypeIsPureCAV: WordBool;
    function  Get_SupportedWriteSpeeds: PSafeArray;
    function  Get_SupportedWriteSpeedDescriptors: PSafeArray;
  public
    property DefaultInterface: IDiscFormat2RawCD read GetDefaultInterface;
  published
    property Recorder: IDiscRecorder2 read Get_Recorder write Set_Recorder;
    property BufferUnderrunFreeDisabled: WordBool read Get_BufferUnderrunFreeDisabled write Set_BufferUnderrunFreeDisabled;
    property RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE read Get_RequestedSectorType write Set_RequestedSectorType;
    property ClientName: WideString read Get_ClientName write Set_ClientName;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftStreamZero provides a Create and CreateRemote method to          
// create instances of the default interface ISequentialStream exposed by              
// the CoClass MsftStreamZero. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftStreamZero = class
    class function Create: ISequentialStream;
    class function CreateRemote(const MachineName: string): ISequentialStream;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftStreamZero
// Help String      : Microsoft IMAPIv2 /dev/zero Stream 
// Default Interface: ISequentialStream
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftStreamZeroProperties= class;
{$ENDIF}
  TMsftStreamZero = class(TOleServer)
  private
    FIntf:        ISequentialStream;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftStreamZeroProperties;
    function      GetServerProperties: TMsftStreamZeroProperties;
{$ENDIF}
    function      GetDefaultInterface: ISequentialStream;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISequentialStream);
    procedure Disconnect; override;
    function  RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
    function  RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
    property  DefaultInterface: ISequentialStream read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftStreamZeroProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftStreamZero
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftStreamZeroProperties = class(TPersistent)
  private
    FServer:    TMsftStreamZero;
    function    GetDefaultInterface: ISequentialStream;
    constructor Create(AServer: TMsftStreamZero);
  protected
  public
    property DefaultInterface: ISequentialStream read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftStreamPrng001 provides a Create and CreateRemote method to          
// create instances of the default interface IStreamPseudoRandomBased exposed by              
// the CoClass MsftStreamPrng001. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftStreamPrng001 = class
    class function Create: IStreamPseudoRandomBased;
    class function CreateRemote(const MachineName: string): IStreamPseudoRandomBased;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftStreamPrng001
// Help String      : Microsoft IMAPIv2 PRNG based Stream (LCG: 0x19660D, 0x3C6EF35F)
// Default Interface: IStreamPseudoRandomBased
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftStreamPrng001Properties= class;
{$ENDIF}
  TMsftStreamPrng001 = class(TOleServer)
  private
    FIntf:        IStreamPseudoRandomBased;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftStreamPrng001Properties;
    function      GetServerProperties: TMsftStreamPrng001Properties;
{$ENDIF}
    function      GetDefaultInterface: IStreamPseudoRandomBased;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStreamPseudoRandomBased);
    procedure Disconnect; override;
    function  RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
    function  RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
    function  RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                         out plibNewPosition: _ULARGE_INTEGER): HResult;
    function  SetSize(libNewSize: _ULARGE_INTEGER): HResult;
    function  RemoteCopyTo(const pstm: ISequentialStream; cb: _ULARGE_INTEGER; 
                           out pcbRead: _ULARGE_INTEGER; out pcbWritten: _ULARGE_INTEGER): HResult;
    function  Commit(grfCommitFlags: LongWord): HResult;
    function  Revert: HResult;
    function  LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function  UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function  Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
    function  Clone(out ppstm: ISequentialStream): HResult;
    function  put_Seed(value: LongWord): HResult;
    function  get_Seed(out value: LongWord): HResult;
    function  put_ExtendedSeed(var values: LongWord; eCount: LongWord): HResult;
    function  get_ExtendedSeed(out values: PUINT1; out eCount: LongWord): HResult;
    property  DefaultInterface: IStreamPseudoRandomBased read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftStreamPrng001Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftStreamPrng001
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftStreamPrng001Properties = class(TPersistent)
  private
    FServer:    TMsftStreamPrng001;
    function    GetDefaultInterface: IStreamPseudoRandomBased;
    constructor Create(AServer: TMsftStreamPrng001);
  protected
  public
    property DefaultInterface: IStreamPseudoRandomBased read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftStreamConcatenate provides a Create and CreateRemote method to          
// create instances of the default interface IStreamConcatenate exposed by              
// the CoClass MsftStreamConcatenate. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftStreamConcatenate = class
    class function Create: IStreamConcatenate;
    class function CreateRemote(const MachineName: string): IStreamConcatenate;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftStreamConcatenate
// Help String      : Microsoft IMAPIv2 concatenation stream
// Default Interface: IStreamConcatenate
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftStreamConcatenateProperties= class;
{$ENDIF}
  TMsftStreamConcatenate = class(TOleServer)
  private
    FIntf:        IStreamConcatenate;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftStreamConcatenateProperties;
    function      GetServerProperties: TMsftStreamConcatenateProperties;
{$ENDIF}
    function      GetDefaultInterface: IStreamConcatenate;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStreamConcatenate);
    procedure Disconnect; override;
    function  RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
    function  RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
    function  RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                         out plibNewPosition: _ULARGE_INTEGER): HResult;
    function  SetSize(libNewSize: _ULARGE_INTEGER): HResult;
    function  RemoteCopyTo(const pstm: ISequentialStream; cb: _ULARGE_INTEGER; 
                           out pcbRead: _ULARGE_INTEGER; out pcbWritten: _ULARGE_INTEGER): HResult;
    function  Commit(grfCommitFlags: LongWord): HResult;
    function  Revert: HResult;
    function  LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function  UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function  Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
    function  Clone(out ppstm: ISequentialStream): HResult;
    function  Initialize(const stream1: ISequentialStream; const stream2: ISequentialStream): HResult;
    function  Initialize2(var streams: ISequentialStream; streamCount: LongWord): HResult;
    function  Append(const stream: ISequentialStream): HResult;
    function  Append2(var streams: ISequentialStream; streamCount: LongWord): HResult;
    property  DefaultInterface: IStreamConcatenate read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftStreamConcatenateProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftStreamConcatenate
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftStreamConcatenateProperties = class(TPersistent)
  private
    FServer:    TMsftStreamConcatenate;
    function    GetDefaultInterface: IStreamConcatenate;
    constructor Create(AServer: TMsftStreamConcatenate);
  protected
  public
    property DefaultInterface: IStreamConcatenate read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftStreamInterleave provides a Create and CreateRemote method to          
// create instances of the default interface IStreamInterleave exposed by              
// the CoClass MsftStreamInterleave. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftStreamInterleave = class
    class function Create: IStreamInterleave;
    class function CreateRemote(const MachineName: string): IStreamInterleave;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMsftStreamInterleave
// Help String      : Microsoft IMAPIv2 interleave stream
// Default Interface: IStreamInterleave
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMsftStreamInterleaveProperties= class;
{$ENDIF}
  TMsftStreamInterleave = class(TOleServer)
  private
    FIntf:        IStreamInterleave;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMsftStreamInterleaveProperties;
    function      GetServerProperties: TMsftStreamInterleaveProperties;
{$ENDIF}
    function      GetDefaultInterface: IStreamInterleave;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IStreamInterleave);
    procedure Disconnect; override;
    function  RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
    function  RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
    function  RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                         out plibNewPosition: _ULARGE_INTEGER): HResult;
    function  SetSize(libNewSize: _ULARGE_INTEGER): HResult;
    function  RemoteCopyTo(const pstm: ISequentialStream; cb: _ULARGE_INTEGER; 
                           out pcbRead: _ULARGE_INTEGER; out pcbWritten: _ULARGE_INTEGER): HResult;
    function  Commit(grfCommitFlags: LongWord): HResult;
    function  Revert: HResult;
    function  LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function  UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; dwLockType: LongWord): HResult;
    function  Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
    function  Clone(out ppstm: ISequentialStream): HResult;
    function  Initialize(var streams: ISequentialStream; var interleaveSizes: LongWord; 
                         streamCount: LongWord): HResult;
    property  DefaultInterface: IStreamInterleave read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMsftStreamInterleaveProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMsftStreamInterleave
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMsftStreamInterleaveProperties = class(TPersistent)
  private
    FServer:    TMsftStreamInterleave;
    function    GetDefaultInterface: IStreamInterleave;
    constructor Create(AServer: TMsftStreamInterleave);
  protected
  public
    property DefaultInterface: IStreamInterleave read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoMsftWriteSpeedDescriptor provides a Create and CreateRemote method to          
// create instances of the default interface IWriteSpeedDescriptor exposed by              
// the CoClass MsftWriteSpeedDescriptor. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftWriteSpeedDescriptor = class
    class function Create: IWriteSpeedDescriptor;
    class function CreateRemote(const MachineName: string): IWriteSpeedDescriptor;
  end;

// *********************************************************************//
// The Class CoMsftMultisessionSequential provides a Create and CreateRemote method to          
// create instances of the default interface IMultisession exposed by              
// the CoClass MsftMultisessionSequential. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMsftMultisessionSequential = class
    class function Create: IMultisession;
    class function CreateRemote(const MachineName: string): IMultisession;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

implementation

uses ComObj;

class function CoMsftDiscMaster2.Create: IDiscMaster2;
begin
  Result := CreateComObject(CLASS_MsftDiscMaster2) as IDiscMaster2;
end;

class function CoMsftDiscMaster2.CreateRemote(const MachineName: string): IDiscMaster2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscMaster2) as IDiscMaster2;
end;

procedure TMsftDiscMaster2.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412E-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354130-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{27354131-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscMaster2.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscMaster2;
  end;
end;

procedure TMsftDiscMaster2.ConnectTo(svrIntf: IDiscMaster2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscMaster2.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscMaster2.GetDefaultInterface: IDiscMaster2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftDiscMaster2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftDiscMaster2Properties.Create(Self);
{$ENDIF}
end;

destructor TMsftDiscMaster2.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftDiscMaster2.GetServerProperties: TMsftDiscMaster2Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMsftDiscMaster2.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   256: if Assigned(FOnNotifyDeviceAdded) then
            FOnNotifyDeviceAdded(Self, Params[1] {const WideString}, Params[0] {const IDispatch});
   257: if Assigned(FOnNotifyDeviceRemoved) then
            FOnNotifyDeviceRemoved(Self, Params[1] {const WideString}, Params[0] {const IDispatch});
  end; {case DispID}
end;

function  TMsftDiscMaster2.Get_Item(index: Integer): WideString;
begin
  Result := DefaultInterface.Item[index];
end;

function  TMsftDiscMaster2.Get_Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

function  TMsftDiscMaster2.Get_IsSupportedEnvironment: WordBool;
begin
  Result := DefaultInterface.IsSupportedEnvironment;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftDiscMaster2Properties.Create(AServer: TMsftDiscMaster2);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftDiscMaster2Properties.GetDefaultInterface: IDiscMaster2;
begin
  Result := FServer.DefaultInterface;
end;

function  TMsftDiscMaster2Properties.Get_Item(index: Integer): WideString;
begin
  Result := DefaultInterface.Item[index];
end;

function  TMsftDiscMaster2Properties.Get_Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

function  TMsftDiscMaster2Properties.Get_IsSupportedEnvironment: WordBool;
begin
  Result := DefaultInterface.IsSupportedEnvironment;
end;

{$ENDIF}

class function CoMsftDiscRecorder2.Create: IDiscRecorder2;
begin
  Result := CreateComObject(CLASS_MsftDiscRecorder2) as IDiscRecorder2;
end;

class function CoMsftDiscRecorder2.CreateRemote(const MachineName: string): IDiscRecorder2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscRecorder2) as IDiscRecorder2;
end;

procedure TMsftDiscRecorder2.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412D-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354133-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscRecorder2.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDiscRecorder2;
  end;
end;

procedure TMsftDiscRecorder2.ConnectTo(svrIntf: IDiscRecorder2);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftDiscRecorder2.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftDiscRecorder2.GetDefaultInterface: IDiscRecorder2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftDiscRecorder2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftDiscRecorder2Properties.Create(Self);
{$ENDIF}
end;

destructor TMsftDiscRecorder2.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftDiscRecorder2.GetServerProperties: TMsftDiscRecorder2Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TMsftDiscRecorder2.Get_ActiveDiscRecorder: WideString;
begin
  Result := DefaultInterface.ActiveDiscRecorder;
end;

function  TMsftDiscRecorder2.Get_VendorId: WideString;
begin
  Result := DefaultInterface.VendorId;
end;

function  TMsftDiscRecorder2.Get_ProductId: WideString;
begin
  Result := DefaultInterface.ProductId;
end;

function  TMsftDiscRecorder2.Get_ProductRevision: WideString;
begin
  Result := DefaultInterface.ProductRevision;
end;

function  TMsftDiscRecorder2.Get_VolumeName: WideString;
begin
  Result := DefaultInterface.VolumeName;
end;

function  TMsftDiscRecorder2.Get_VolumePathNames: PSafeArray;
begin
  Result := DefaultInterface.VolumePathNames;
end;

function  TMsftDiscRecorder2.Get_DeviceCanLoadMedia: WordBool;
begin
  Result := DefaultInterface.DeviceCanLoadMedia;
end;

function  TMsftDiscRecorder2.Get_LegacyDeviceNumber: Integer;
begin
  Result := DefaultInterface.LegacyDeviceNumber;
end;

function  TMsftDiscRecorder2.Get_SupportedFeaturePages: PSafeArray;
begin
  Result := DefaultInterface.SupportedFeaturePages;
end;

function  TMsftDiscRecorder2.Get_CurrentFeaturePages: PSafeArray;
begin
  Result := DefaultInterface.CurrentFeaturePages;
end;

function  TMsftDiscRecorder2.Get_SupportedProfiles: PSafeArray;
begin
  Result := DefaultInterface.SupportedProfiles;
end;

function  TMsftDiscRecorder2.Get_CurrentProfiles: PSafeArray;
begin
  Result := DefaultInterface.CurrentProfiles;
end;

function  TMsftDiscRecorder2.Get_SupportedModePages: PSafeArray;
begin
  Result := DefaultInterface.SupportedModePages;
end;

function  TMsftDiscRecorder2.Get_ExclusiveAccessOwner: WideString;
begin
  Result := DefaultInterface.ExclusiveAccessOwner;
end;

procedure TMsftDiscRecorder2.EjectMedia;
begin
  DefaultInterface.EjectMedia;
end;

procedure TMsftDiscRecorder2.CloseTray;
begin
  DefaultInterface.CloseTray;
end;

procedure TMsftDiscRecorder2.AcquireExclusiveAccess(force: WordBool; const __MIDL_0015: WideString);
begin
  DefaultInterface.AcquireExclusiveAccess(force, __MIDL_0015);
end;

procedure TMsftDiscRecorder2.ReleaseExclusiveAccess;
begin
  DefaultInterface.ReleaseExclusiveAccess;
end;

procedure TMsftDiscRecorder2.DisableMcn;
begin
  DefaultInterface.DisableMcn;
end;

procedure TMsftDiscRecorder2.EnableMcn;
begin
  DefaultInterface.EnableMcn;
end;

procedure TMsftDiscRecorder2.InitializeDiscRecorder(const recorderUniqueId: WideString);
begin
  DefaultInterface.InitializeDiscRecorder(recorderUniqueId);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftDiscRecorder2Properties.Create(AServer: TMsftDiscRecorder2);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftDiscRecorder2Properties.GetDefaultInterface: IDiscRecorder2;
begin
  Result := FServer.DefaultInterface;
end;

function  TMsftDiscRecorder2Properties.Get_ActiveDiscRecorder: WideString;
begin
  Result := DefaultInterface.ActiveDiscRecorder;
end;

function  TMsftDiscRecorder2Properties.Get_VendorId: WideString;
begin
  Result := DefaultInterface.VendorId;
end;

function  TMsftDiscRecorder2Properties.Get_ProductId: WideString;
begin
  Result := DefaultInterface.ProductId;
end;

function  TMsftDiscRecorder2Properties.Get_ProductRevision: WideString;
begin
  Result := DefaultInterface.ProductRevision;
end;

function  TMsftDiscRecorder2Properties.Get_VolumeName: WideString;
begin
  Result := DefaultInterface.VolumeName;
end;

function  TMsftDiscRecorder2Properties.Get_VolumePathNames: PSafeArray;
begin
  Result := DefaultInterface.VolumePathNames;
end;

function  TMsftDiscRecorder2Properties.Get_DeviceCanLoadMedia: WordBool;
begin
  Result := DefaultInterface.DeviceCanLoadMedia;
end;

function  TMsftDiscRecorder2Properties.Get_LegacyDeviceNumber: Integer;
begin
  Result := DefaultInterface.LegacyDeviceNumber;
end;

function  TMsftDiscRecorder2Properties.Get_SupportedFeaturePages: PSafeArray;
begin
  Result := DefaultInterface.SupportedFeaturePages;
end;

function  TMsftDiscRecorder2Properties.Get_CurrentFeaturePages: PSafeArray;
begin
  Result := DefaultInterface.CurrentFeaturePages;
end;

function  TMsftDiscRecorder2Properties.Get_SupportedProfiles: PSafeArray;
begin
  Result := DefaultInterface.SupportedProfiles;
end;

function  TMsftDiscRecorder2Properties.Get_CurrentProfiles: PSafeArray;
begin
  Result := DefaultInterface.CurrentProfiles;
end;

function  TMsftDiscRecorder2Properties.Get_SupportedModePages: PSafeArray;
begin
  Result := DefaultInterface.SupportedModePages;
end;

function  TMsftDiscRecorder2Properties.Get_ExclusiveAccessOwner: WideString;
begin
  Result := DefaultInterface.ExclusiveAccessOwner;
end;

{$ENDIF}

class function CoMsftWriteEngine2.Create: IWriteEngine2;
begin
  Result := CreateComObject(CLASS_MsftWriteEngine2) as IWriteEngine2;
end;

class function CoMsftWriteEngine2.CreateRemote(const MachineName: string): IWriteEngine2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftWriteEngine2) as IWriteEngine2;
end;

procedure TMsftWriteEngine2.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412C-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354135-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{27354137-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftWriteEngine2.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IWriteEngine2;
  end;
end;

procedure TMsftWriteEngine2.ConnectTo(svrIntf: IWriteEngine2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftWriteEngine2.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftWriteEngine2.GetDefaultInterface: IWriteEngine2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftWriteEngine2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftWriteEngine2Properties.Create(Self);
{$ENDIF}
end;

destructor TMsftWriteEngine2.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftWriteEngine2.GetServerProperties: TMsftWriteEngine2Properties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMsftWriteEngine2.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   256: if Assigned(FOnUpdate) then
            FOnUpdate(Self, Params[1] {const IDispatch}, Params[0] {const IDispatch});
  end; {case DispID}
end;

procedure TMsftWriteEngine2.Set_Recorder(const value: IDiscRecorder2Ex);
begin
  DefaultInterface.Recorder := value;
end;

function  TMsftWriteEngine2.Get_Recorder: IDiscRecorder2Ex;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftWriteEngine2.Set_UseStreamingWrite12(value: WordBool);
begin
  DefaultInterface.UseStreamingWrite12 := value;
end;

function  TMsftWriteEngine2.Get_UseStreamingWrite12: WordBool;
begin
  Result := DefaultInterface.UseStreamingWrite12;
end;

procedure TMsftWriteEngine2.Set_StartingSectorsPerSecond(value: Integer);
begin
  DefaultInterface.StartingSectorsPerSecond := value;
end;

function  TMsftWriteEngine2.Get_StartingSectorsPerSecond: Integer;
begin
  Result := DefaultInterface.StartingSectorsPerSecond;
end;

procedure TMsftWriteEngine2.Set_EndingSectorsPerSecond(value: Integer);
begin
  DefaultInterface.EndingSectorsPerSecond := value;
end;

function  TMsftWriteEngine2.Get_EndingSectorsPerSecond: Integer;
begin
  Result := DefaultInterface.EndingSectorsPerSecond;
end;

procedure TMsftWriteEngine2.Set_BytesPerSector(value: Integer);
begin
  DefaultInterface.BytesPerSector := value;
end;

function  TMsftWriteEngine2.Get_BytesPerSector: Integer;
begin
  Result := DefaultInterface.BytesPerSector;
end;

function  TMsftWriteEngine2.Get_WriteInProgress: WordBool;
begin
  Result := DefaultInterface.WriteInProgress;
end;

procedure TMsftWriteEngine2.WriteSection(const data: ISequentialStream; 
                                         startingBlockAddress: Integer; numberOfBlocks: Integer);
begin
  DefaultInterface.WriteSection(data, startingBlockAddress, numberOfBlocks);
end;

procedure TMsftWriteEngine2.CancelWrite;
begin
  DefaultInterface.CancelWrite;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftWriteEngine2Properties.Create(AServer: TMsftWriteEngine2);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftWriteEngine2Properties.GetDefaultInterface: IWriteEngine2;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMsftWriteEngine2Properties.Set_Recorder(const value: IDiscRecorder2Ex);
begin
  DefaultInterface.Recorder := value;
end;

function  TMsftWriteEngine2Properties.Get_Recorder: IDiscRecorder2Ex;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftWriteEngine2Properties.Set_UseStreamingWrite12(value: WordBool);
begin
  DefaultInterface.UseStreamingWrite12 := value;
end;

function  TMsftWriteEngine2Properties.Get_UseStreamingWrite12: WordBool;
begin
  Result := DefaultInterface.UseStreamingWrite12;
end;

procedure TMsftWriteEngine2Properties.Set_StartingSectorsPerSecond(value: Integer);
begin
  DefaultInterface.StartingSectorsPerSecond := value;
end;

function  TMsftWriteEngine2Properties.Get_StartingSectorsPerSecond: Integer;
begin
  Result := DefaultInterface.StartingSectorsPerSecond;
end;

procedure TMsftWriteEngine2Properties.Set_EndingSectorsPerSecond(value: Integer);
begin
  DefaultInterface.EndingSectorsPerSecond := value;
end;

function  TMsftWriteEngine2Properties.Get_EndingSectorsPerSecond: Integer;
begin
  Result := DefaultInterface.EndingSectorsPerSecond;
end;

procedure TMsftWriteEngine2Properties.Set_BytesPerSector(value: Integer);
begin
  DefaultInterface.BytesPerSector := value;
end;

function  TMsftWriteEngine2Properties.Get_BytesPerSector: Integer;
begin
  Result := DefaultInterface.BytesPerSector;
end;

function  TMsftWriteEngine2Properties.Get_WriteInProgress: WordBool;
begin
  Result := DefaultInterface.WriteInProgress;
end;

{$ENDIF}

class function CoMsftDiscFormat2Erase.Create: IDiscFormat2;
begin
  Result := CreateComObject(CLASS_MsftDiscFormat2Erase) as IDiscFormat2;
end;

class function CoMsftDiscFormat2Erase.CreateRemote(const MachineName: string): IDiscFormat2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscFormat2Erase) as IDiscFormat2;
end;

procedure TMsftDiscFormat2Erase.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412B-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354152-8F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{2735413A-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscFormat2Erase.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscFormat2;
  end;
end;

procedure TMsftDiscFormat2Erase.ConnectTo(svrIntf: IDiscFormat2);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscFormat2Erase.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscFormat2Erase.GetDefaultInterface: IDiscFormat2;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftDiscFormat2Erase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftDiscFormat2EraseProperties.Create(Self);
{$ENDIF}
end;

destructor TMsftDiscFormat2Erase.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftDiscFormat2Erase.GetServerProperties: TMsftDiscFormat2EraseProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMsftDiscFormat2Erase.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   512: if Assigned(FOnUpdate) then
            FOnUpdate(Self, Params[2] {Integer}, Params[1] {Integer}, Params[0] {const IDispatch});
  end; {case DispID}
end;

function  TMsftDiscFormat2Erase.Get_MediaPhysicallyBlank: WordBool;
begin
  Result := DefaultInterface.MediaPhysicallyBlank;
end;

function  TMsftDiscFormat2Erase.Get_MediaHeuristicallyBlank: WordBool;
begin
  Result := DefaultInterface.MediaHeuristicallyBlank;
end;

function  TMsftDiscFormat2Erase.Get_SupportedMediaTypes: PSafeArray;
begin
  Result := DefaultInterface.SupportedMediaTypes;
end;

function  TMsftDiscFormat2Erase.IsRecorderSupported(const Recorder: IDiscRecorder2): WordBool;
begin
  Result := DefaultInterface.IsRecorderSupported(Recorder);
end;

function  TMsftDiscFormat2Erase.IsCurrentMediaSupported(const Recorder: IDiscRecorder2): WordBool;
begin
  Result := DefaultInterface.IsCurrentMediaSupported(Recorder);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftDiscFormat2EraseProperties.Create(AServer: TMsftDiscFormat2Erase);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftDiscFormat2EraseProperties.GetDefaultInterface: IDiscFormat2;
begin
  Result := FServer.DefaultInterface;
end;

function  TMsftDiscFormat2EraseProperties.Get_MediaPhysicallyBlank: WordBool;
begin
  Result := DefaultInterface.MediaPhysicallyBlank;
end;

function  TMsftDiscFormat2EraseProperties.Get_MediaHeuristicallyBlank: WordBool;
begin
  Result := DefaultInterface.MediaHeuristicallyBlank;
end;

function  TMsftDiscFormat2EraseProperties.Get_SupportedMediaTypes: PSafeArray;
begin
  Result := DefaultInterface.SupportedMediaTypes;
end;

{$ENDIF}

class function CoMsftDiscFormat2Data.Create: IDiscFormat2Data;
begin
  Result := CreateComObject(CLASS_MsftDiscFormat2Data) as IDiscFormat2Data;
end;

class function CoMsftDiscFormat2Data.CreateRemote(const MachineName: string): IDiscFormat2Data;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscFormat2Data) as IDiscFormat2Data;
end;

procedure TMsftDiscFormat2Data.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{2735412A-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354153-9F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{2735413C-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscFormat2Data.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscFormat2Data;
  end;
end;

procedure TMsftDiscFormat2Data.ConnectTo(svrIntf: IDiscFormat2Data);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscFormat2Data.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscFormat2Data.GetDefaultInterface: IDiscFormat2Data;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftDiscFormat2Data.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftDiscFormat2DataProperties.Create(Self);
{$ENDIF}
end;

destructor TMsftDiscFormat2Data.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftDiscFormat2Data.GetServerProperties: TMsftDiscFormat2DataProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMsftDiscFormat2Data.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   512: if Assigned(FOnUpdate) then
            FOnUpdate(Self, Params[1] {const IDispatch}, Params[0] {const IDispatch});
  end; {case DispID}
end;

procedure TMsftDiscFormat2Data.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function  TMsftDiscFormat2Data.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2Data.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function  TMsftDiscFormat2Data.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

procedure TMsftDiscFormat2Data.Set_PostgapAlreadyInImage(value: WordBool);
begin
  DefaultInterface.PostgapAlreadyInImage := value;
end;

function  TMsftDiscFormat2Data.Get_PostgapAlreadyInImage: WordBool;
begin
  Result := DefaultInterface.PostgapAlreadyInImage;
end;

function  TMsftDiscFormat2Data.Get_CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE;
begin
  Result := DefaultInterface.CurrentMediaStatus;
end;

function  TMsftDiscFormat2Data.Get_WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE;
begin
  Result := DefaultInterface.WriteProtectStatus;
end;

function  TMsftDiscFormat2Data.Get_TotalSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.TotalSectorsOnMedia;
end;

function  TMsftDiscFormat2Data.Get_FreeSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.FreeSectorsOnMedia;
end;

function  TMsftDiscFormat2Data.Get_NextWritableAddress: Integer;
begin
  Result := DefaultInterface.NextWritableAddress;
end;

function  TMsftDiscFormat2Data.Get_StartAddressOfPreviousSession: Integer;
begin
  Result := DefaultInterface.StartAddressOfPreviousSession;
end;

function  TMsftDiscFormat2Data.Get_LastWrittenAddressOfPreviousSession: Integer;
begin
  Result := DefaultInterface.LastWrittenAddressOfPreviousSession;
end;

procedure TMsftDiscFormat2Data.Set_ForceMediaToBeClosed(value: WordBool);
begin
  DefaultInterface.ForceMediaToBeClosed := value;
end;

function  TMsftDiscFormat2Data.Get_ForceMediaToBeClosed: WordBool;
begin
  Result := DefaultInterface.ForceMediaToBeClosed;
end;

procedure TMsftDiscFormat2Data.Set_DisableConsumerDvdCompatibilityMode(value: WordBool);
begin
  DefaultInterface.DisableConsumerDvdCompatibilityMode := value;
end;

function  TMsftDiscFormat2Data.Get_DisableConsumerDvdCompatibilityMode: WordBool;
begin
  Result := DefaultInterface.DisableConsumerDvdCompatibilityMode;
end;

function  TMsftDiscFormat2Data.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

procedure TMsftDiscFormat2Data.Set_ClientName(const value: WideString);
  { Warning: The property ClientName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ClientName := value;
end;

function  TMsftDiscFormat2Data.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function  TMsftDiscFormat2Data.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function  TMsftDiscFormat2Data.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2Data.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function  TMsftDiscFormat2Data.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2Data.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function  TMsftDiscFormat2Data.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

procedure TMsftDiscFormat2Data.Set_ForceOverwrite(value: WordBool);
begin
  DefaultInterface.ForceOverwrite := value;
end;

function  TMsftDiscFormat2Data.Get_ForceOverwrite: WordBool;
begin
  Result := DefaultInterface.ForceOverwrite;
end;

function  TMsftDiscFormat2Data.Get_MultisessionInterfaces: PSafeArray;
begin
  Result := DefaultInterface.MultisessionInterfaces;
end;

procedure TMsftDiscFormat2Data.Write(const data: ISequentialStream);
begin
  DefaultInterface.Write(data);
end;

procedure TMsftDiscFormat2Data.CancelWrite;
begin
  DefaultInterface.CancelWrite;
end;

procedure TMsftDiscFormat2Data.SetWriteSpeed(RequestedSectorsPerSecond: Integer; 
                                             RotationTypeIsPureCAV: WordBool);
begin
  DefaultInterface.SetWriteSpeed(RequestedSectorsPerSecond, RotationTypeIsPureCAV);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftDiscFormat2DataProperties.Create(AServer: TMsftDiscFormat2Data);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftDiscFormat2DataProperties.GetDefaultInterface: IDiscFormat2Data;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMsftDiscFormat2DataProperties.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function  TMsftDiscFormat2DataProperties.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2DataProperties.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function  TMsftDiscFormat2DataProperties.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

procedure TMsftDiscFormat2DataProperties.Set_PostgapAlreadyInImage(value: WordBool);
begin
  DefaultInterface.PostgapAlreadyInImage := value;
end;

function  TMsftDiscFormat2DataProperties.Get_PostgapAlreadyInImage: WordBool;
begin
  Result := DefaultInterface.PostgapAlreadyInImage;
end;

function  TMsftDiscFormat2DataProperties.Get_CurrentMediaStatus: IMAPI_FORMAT2_DATA_MEDIA_STATE;
begin
  Result := DefaultInterface.CurrentMediaStatus;
end;

function  TMsftDiscFormat2DataProperties.Get_WriteProtectStatus: IMAPI_MEDIA_WRITE_PROTECT_STATE;
begin
  Result := DefaultInterface.WriteProtectStatus;
end;

function  TMsftDiscFormat2DataProperties.Get_TotalSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.TotalSectorsOnMedia;
end;

function  TMsftDiscFormat2DataProperties.Get_FreeSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.FreeSectorsOnMedia;
end;

function  TMsftDiscFormat2DataProperties.Get_NextWritableAddress: Integer;
begin
  Result := DefaultInterface.NextWritableAddress;
end;

function  TMsftDiscFormat2DataProperties.Get_StartAddressOfPreviousSession: Integer;
begin
  Result := DefaultInterface.StartAddressOfPreviousSession;
end;

function  TMsftDiscFormat2DataProperties.Get_LastWrittenAddressOfPreviousSession: Integer;
begin
  Result := DefaultInterface.LastWrittenAddressOfPreviousSession;
end;

procedure TMsftDiscFormat2DataProperties.Set_ForceMediaToBeClosed(value: WordBool);
begin
  DefaultInterface.ForceMediaToBeClosed := value;
end;

function  TMsftDiscFormat2DataProperties.Get_ForceMediaToBeClosed: WordBool;
begin
  Result := DefaultInterface.ForceMediaToBeClosed;
end;

procedure TMsftDiscFormat2DataProperties.Set_DisableConsumerDvdCompatibilityMode(value: WordBool);
begin
  DefaultInterface.DisableConsumerDvdCompatibilityMode := value;
end;

function  TMsftDiscFormat2DataProperties.Get_DisableConsumerDvdCompatibilityMode: WordBool;
begin
  Result := DefaultInterface.DisableConsumerDvdCompatibilityMode;
end;

function  TMsftDiscFormat2DataProperties.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

procedure TMsftDiscFormat2DataProperties.Set_ClientName(const value: WideString);
  { Warning: The property ClientName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ClientName := value;
end;

function  TMsftDiscFormat2DataProperties.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function  TMsftDiscFormat2DataProperties.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function  TMsftDiscFormat2DataProperties.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2DataProperties.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function  TMsftDiscFormat2DataProperties.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2DataProperties.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function  TMsftDiscFormat2DataProperties.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

procedure TMsftDiscFormat2DataProperties.Set_ForceOverwrite(value: WordBool);
begin
  DefaultInterface.ForceOverwrite := value;
end;

function  TMsftDiscFormat2DataProperties.Get_ForceOverwrite: WordBool;
begin
  Result := DefaultInterface.ForceOverwrite;
end;

function  TMsftDiscFormat2DataProperties.Get_MultisessionInterfaces: PSafeArray;
begin
  Result := DefaultInterface.MultisessionInterfaces;
end;

{$ENDIF}

class function CoMsftDiscFormat2TrackAtOnce.Create: IDiscFormat2TrackAtOnce;
begin
  Result := CreateComObject(CLASS_MsftDiscFormat2TrackAtOnce) as IDiscFormat2TrackAtOnce;
end;

class function CoMsftDiscFormat2TrackAtOnce.CreateRemote(const MachineName: string): IDiscFormat2TrackAtOnce;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscFormat2TrackAtOnce) as IDiscFormat2TrackAtOnce;
end;

procedure TMsftDiscFormat2TrackAtOnce.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354129-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354154-8F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{2735413F-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscFormat2TrackAtOnce.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscFormat2TrackAtOnce;
  end;
end;

procedure TMsftDiscFormat2TrackAtOnce.ConnectTo(svrIntf: IDiscFormat2TrackAtOnce);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscFormat2TrackAtOnce.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscFormat2TrackAtOnce.GetDefaultInterface: IDiscFormat2TrackAtOnce;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftDiscFormat2TrackAtOnce.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftDiscFormat2TrackAtOnceProperties.Create(Self);
{$ENDIF}
end;

destructor TMsftDiscFormat2TrackAtOnce.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftDiscFormat2TrackAtOnce.GetServerProperties: TMsftDiscFormat2TrackAtOnceProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMsftDiscFormat2TrackAtOnce.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   512: if Assigned(FOnUpdate) then
            FOnUpdate(Self, Params[1] {const IDispatch}, Params[0] {const IDispatch});
  end; {case DispID}
end;

procedure TMsftDiscFormat2TrackAtOnce.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2TrackAtOnce.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_NumberOfExistingTracks: Integer;
begin
  Result := DefaultInterface.NumberOfExistingTracks;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_TotalSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.TotalSectorsOnMedia;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_FreeSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.FreeSectorsOnMedia;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_UsedSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.UsedSectorsOnMedia;
end;

procedure TMsftDiscFormat2TrackAtOnce.Set_DoNotFinalizeMedia(value: WordBool);
begin
  DefaultInterface.DoNotFinalizeMedia := value;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_DoNotFinalizeMedia: WordBool;
begin
  Result := DefaultInterface.DoNotFinalizeMedia;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_ExpectedTableOfContents: PSafeArray;
begin
  Result := DefaultInterface.ExpectedTableOfContents;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

procedure TMsftDiscFormat2TrackAtOnce.Set_ClientName(const value: WideString);
  { Warning: The property ClientName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ClientName := value;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function  TMsftDiscFormat2TrackAtOnce.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

procedure TMsftDiscFormat2TrackAtOnce.PrepareMedia;
begin
  DefaultInterface.PrepareMedia;
end;

procedure TMsftDiscFormat2TrackAtOnce.AddAudioTrack(const data: ISequentialStream);
begin
  DefaultInterface.AddAudioTrack(data);
end;

procedure TMsftDiscFormat2TrackAtOnce.CancelAddTrack;
begin
  DefaultInterface.CancelAddTrack;
end;

procedure TMsftDiscFormat2TrackAtOnce.ReleaseMedia;
begin
  DefaultInterface.ReleaseMedia;
end;

procedure TMsftDiscFormat2TrackAtOnce.SetWriteSpeed(RequestedSectorsPerSecond: Integer; 
                                                    RotationTypeIsPureCAV: WordBool);
begin
  DefaultInterface.SetWriteSpeed(RequestedSectorsPerSecond, RotationTypeIsPureCAV);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftDiscFormat2TrackAtOnceProperties.Create(AServer: TMsftDiscFormat2TrackAtOnce);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftDiscFormat2TrackAtOnceProperties.GetDefaultInterface: IDiscFormat2TrackAtOnce;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMsftDiscFormat2TrackAtOnceProperties.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2TrackAtOnceProperties.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_NumberOfExistingTracks: Integer;
begin
  Result := DefaultInterface.NumberOfExistingTracks;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_TotalSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.TotalSectorsOnMedia;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_FreeSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.FreeSectorsOnMedia;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_UsedSectorsOnMedia: Integer;
begin
  Result := DefaultInterface.UsedSectorsOnMedia;
end;

procedure TMsftDiscFormat2TrackAtOnceProperties.Set_DoNotFinalizeMedia(value: WordBool);
begin
  DefaultInterface.DoNotFinalizeMedia := value;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_DoNotFinalizeMedia: WordBool;
begin
  Result := DefaultInterface.DoNotFinalizeMedia;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_ExpectedTableOfContents: PSafeArray;
begin
  Result := DefaultInterface.ExpectedTableOfContents;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

procedure TMsftDiscFormat2TrackAtOnceProperties.Set_ClientName(const value: WideString);
  { Warning: The property ClientName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ClientName := value;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function  TMsftDiscFormat2TrackAtOnceProperties.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

{$ENDIF}

class function CoMsftDiscFormat2RawCD.Create: IDiscFormat2RawCD;
begin
  Result := CreateComObject(CLASS_MsftDiscFormat2RawCD) as IDiscFormat2RawCD;
end;

class function CoMsftDiscFormat2RawCD.CreateRemote(const MachineName: string): IDiscFormat2RawCD;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftDiscFormat2RawCD) as IDiscFormat2RawCD;
end;

procedure TMsftDiscFormat2RawCD.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354128-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354155-8F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '{27354142-7F64-5B0F-8F00-5D77AFBE261E}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftDiscFormat2RawCD.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IDiscFormat2RawCD;
  end;
end;

procedure TMsftDiscFormat2RawCD.ConnectTo(svrIntf: IDiscFormat2RawCD);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TMsftDiscFormat2RawCD.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TMsftDiscFormat2RawCD.GetDefaultInterface: IDiscFormat2RawCD;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftDiscFormat2RawCD.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftDiscFormat2RawCDProperties.Create(Self);
{$ENDIF}
end;

destructor TMsftDiscFormat2RawCD.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftDiscFormat2RawCD.GetServerProperties: TMsftDiscFormat2RawCDProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TMsftDiscFormat2RawCD.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   512: if Assigned(FOnUpdate) then
            FOnUpdate(Self, Params[1] {const IDispatch}, Params[0] {const IDispatch});
  end; {case DispID}
end;

procedure TMsftDiscFormat2RawCD.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function  TMsftDiscFormat2RawCD.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2RawCD.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function  TMsftDiscFormat2RawCD.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

function  TMsftDiscFormat2RawCD.Get_StartOfNextSession: Integer;
begin
  Result := DefaultInterface.StartOfNextSession;
end;

function  TMsftDiscFormat2RawCD.Get_LastPossibleStartOfLeadout: Integer;
begin
  Result := DefaultInterface.LastPossibleStartOfLeadout;
end;

function  TMsftDiscFormat2RawCD.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

function  TMsftDiscFormat2RawCD.Get_SupportedSectorTypes: PSafeArray;
begin
  Result := DefaultInterface.SupportedSectorTypes;
end;

procedure TMsftDiscFormat2RawCD.Set_RequestedSectorType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE);
begin
  DefaultInterface.RequestedSectorType := value;
end;

function  TMsftDiscFormat2RawCD.Get_RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE;
begin
  Result := DefaultInterface.RequestedSectorType;
end;

procedure TMsftDiscFormat2RawCD.Set_ClientName(const value: WideString);
  { Warning: The property ClientName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ClientName := value;
end;

function  TMsftDiscFormat2RawCD.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function  TMsftDiscFormat2RawCD.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function  TMsftDiscFormat2RawCD.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2RawCD.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function  TMsftDiscFormat2RawCD.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2RawCD.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function  TMsftDiscFormat2RawCD.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

procedure TMsftDiscFormat2RawCD.PrepareMedia;
begin
  DefaultInterface.PrepareMedia;
end;

procedure TMsftDiscFormat2RawCD.WriteMedia(const data: ISequentialStream);
begin
  DefaultInterface.WriteMedia(data);
end;

procedure TMsftDiscFormat2RawCD.WriteMedia2(const data: ISequentialStream; 
                                            streamLeadInSectors: Integer);
begin
  DefaultInterface.WriteMedia2(data, streamLeadInSectors);
end;

procedure TMsftDiscFormat2RawCD.CancelWrite;
begin
  DefaultInterface.CancelWrite;
end;

procedure TMsftDiscFormat2RawCD.ReleaseMedia;
begin
  DefaultInterface.ReleaseMedia;
end;

procedure TMsftDiscFormat2RawCD.SetWriteSpeed(RequestedSectorsPerSecond: Integer; 
                                              RotationTypeIsPureCAV: WordBool);
begin
  DefaultInterface.SetWriteSpeed(RequestedSectorsPerSecond, RotationTypeIsPureCAV);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftDiscFormat2RawCDProperties.Create(AServer: TMsftDiscFormat2RawCD);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftDiscFormat2RawCDProperties.GetDefaultInterface: IDiscFormat2RawCD;
begin
  Result := FServer.DefaultInterface;
end;

procedure TMsftDiscFormat2RawCDProperties.Set_Recorder(const value: IDiscRecorder2);
begin
  DefaultInterface.Recorder := value;
end;

function  TMsftDiscFormat2RawCDProperties.Get_Recorder: IDiscRecorder2;
begin
  Result := DefaultInterface.Recorder;
end;

procedure TMsftDiscFormat2RawCDProperties.Set_BufferUnderrunFreeDisabled(value: WordBool);
begin
  DefaultInterface.BufferUnderrunFreeDisabled := value;
end;

function  TMsftDiscFormat2RawCDProperties.Get_BufferUnderrunFreeDisabled: WordBool;
begin
  Result := DefaultInterface.BufferUnderrunFreeDisabled;
end;

function  TMsftDiscFormat2RawCDProperties.Get_StartOfNextSession: Integer;
begin
  Result := DefaultInterface.StartOfNextSession;
end;

function  TMsftDiscFormat2RawCDProperties.Get_LastPossibleStartOfLeadout: Integer;
begin
  Result := DefaultInterface.LastPossibleStartOfLeadout;
end;

function  TMsftDiscFormat2RawCDProperties.Get_CurrentPhysicalMediaType: IMAPI_MEDIA_PHYSICAL_TYPE;
begin
  Result := DefaultInterface.CurrentPhysicalMediaType;
end;

function  TMsftDiscFormat2RawCDProperties.Get_SupportedSectorTypes: PSafeArray;
begin
  Result := DefaultInterface.SupportedSectorTypes;
end;

procedure TMsftDiscFormat2RawCDProperties.Set_RequestedSectorType(value: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE);
begin
  DefaultInterface.RequestedSectorType := value;
end;

function  TMsftDiscFormat2RawCDProperties.Get_RequestedSectorType: IMAPI_FORMAT2_RAW_CD_DATA_SECTOR_TYPE;
begin
  Result := DefaultInterface.RequestedSectorType;
end;

procedure TMsftDiscFormat2RawCDProperties.Set_ClientName(const value: WideString);
  { Warning: The property ClientName has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ClientName := value;
end;

function  TMsftDiscFormat2RawCDProperties.Get_ClientName: WideString;
begin
  Result := DefaultInterface.ClientName;
end;

function  TMsftDiscFormat2RawCDProperties.Get_RequestedWriteSpeed: Integer;
begin
  Result := DefaultInterface.RequestedWriteSpeed;
end;

function  TMsftDiscFormat2RawCDProperties.Get_RequestedRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.RequestedRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2RawCDProperties.Get_CurrentWriteSpeed: Integer;
begin
  Result := DefaultInterface.CurrentWriteSpeed;
end;

function  TMsftDiscFormat2RawCDProperties.Get_CurrentRotationTypeIsPureCAV: WordBool;
begin
  Result := DefaultInterface.CurrentRotationTypeIsPureCAV;
end;

function  TMsftDiscFormat2RawCDProperties.Get_SupportedWriteSpeeds: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeeds;
end;

function  TMsftDiscFormat2RawCDProperties.Get_SupportedWriteSpeedDescriptors: PSafeArray;
begin
  Result := DefaultInterface.SupportedWriteSpeedDescriptors;
end;

{$ENDIF}

class function CoMsftStreamZero.Create: ISequentialStream;
begin
  Result := CreateComObject(CLASS_MsftStreamZero) as ISequentialStream;
end;

class function CoMsftStreamZero.CreateRemote(const MachineName: string): ISequentialStream;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftStreamZero) as ISequentialStream;
end;

procedure TMsftStreamZero.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354127-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{0C733A30-2A1C-11CE-ADE5-00AA0044773D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftStreamZero.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISequentialStream;
  end;
end;

procedure TMsftStreamZero.ConnectTo(svrIntf: ISequentialStream);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftStreamZero.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftStreamZero.GetDefaultInterface: ISequentialStream;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftStreamZero.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftStreamZeroProperties.Create(Self);
{$ENDIF}
end;

destructor TMsftStreamZero.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftStreamZero.GetServerProperties: TMsftStreamZeroProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TMsftStreamZero.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function  TMsftStreamZero.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftStreamZeroProperties.Create(AServer: TMsftStreamZero);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftStreamZeroProperties.GetDefaultInterface: ISequentialStream;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoMsftStreamPrng001.Create: IStreamPseudoRandomBased;
begin
  Result := CreateComObject(CLASS_MsftStreamPrng001) as IStreamPseudoRandomBased;
end;

class function CoMsftStreamPrng001.CreateRemote(const MachineName: string): IStreamPseudoRandomBased;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftStreamPrng001) as IStreamPseudoRandomBased;
end;

procedure TMsftStreamPrng001.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354126-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354145-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftStreamPrng001.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStreamPseudoRandomBased;
  end;
end;

procedure TMsftStreamPrng001.ConnectTo(svrIntf: IStreamPseudoRandomBased);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftStreamPrng001.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftStreamPrng001.GetDefaultInterface: IStreamPseudoRandomBased;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftStreamPrng001.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftStreamPrng001Properties.Create(Self);
{$ENDIF}
end;

destructor TMsftStreamPrng001.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftStreamPrng001.GetServerProperties: TMsftStreamPrng001Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TMsftStreamPrng001.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function  TMsftStreamPrng001.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

function  TMsftStreamPrng001.RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                                        out plibNewPosition: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.RemoteSeek(dlibMove, dwOrigin, plibNewPosition);
end;

function  TMsftStreamPrng001.SetSize(libNewSize: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.SetSize(libNewSize);
end;

function  TMsftStreamPrng001.RemoteCopyTo(const pstm: ISequentialStream; cb: _ULARGE_INTEGER; 
                                          out pcbRead: _ULARGE_INTEGER; 
                                          out pcbWritten: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.RemoteCopyTo(pstm, cb, pcbRead, pcbWritten);
end;

function  TMsftStreamPrng001.Commit(grfCommitFlags: LongWord): HResult;
begin
  DefaultInterface.Commit(grfCommitFlags);
end;

function  TMsftStreamPrng001.Revert: HResult;
begin
  DefaultInterface.Revert;
end;

function  TMsftStreamPrng001.LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                        dwLockType: LongWord): HResult;
begin
  DefaultInterface.LockRegion(libOffset, cb, dwLockType);
end;

function  TMsftStreamPrng001.UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                          dwLockType: LongWord): HResult;
begin
  DefaultInterface.UnlockRegion(libOffset, cb, dwLockType);
end;

function  TMsftStreamPrng001.Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
begin
  DefaultInterface.Stat(pstatstg, grfStatFlag);
end;

function  TMsftStreamPrng001.Clone(out ppstm: ISequentialStream): HResult;
begin
  DefaultInterface.Clone(ppstm);
end;

function  TMsftStreamPrng001.put_Seed(value: LongWord): HResult;
begin
  DefaultInterface.put_Seed(value);
end;

function  TMsftStreamPrng001.get_Seed(out value: LongWord): HResult;
begin
  DefaultInterface.get_Seed(value);
end;

function  TMsftStreamPrng001.put_ExtendedSeed(var values: LongWord; eCount: LongWord): HResult;
begin
  DefaultInterface.put_ExtendedSeed(values, eCount);
end;

function  TMsftStreamPrng001.get_ExtendedSeed(out values: PUINT1; out eCount: LongWord): HResult;
begin
  DefaultInterface.get_ExtendedSeed(values, eCount);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftStreamPrng001Properties.Create(AServer: TMsftStreamPrng001);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftStreamPrng001Properties.GetDefaultInterface: IStreamPseudoRandomBased;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoMsftStreamConcatenate.Create: IStreamConcatenate;
begin
  Result := CreateComObject(CLASS_MsftStreamConcatenate) as IStreamConcatenate;
end;

class function CoMsftStreamConcatenate.CreateRemote(const MachineName: string): IStreamConcatenate;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftStreamConcatenate) as IStreamConcatenate;
end;

procedure TMsftStreamConcatenate.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354125-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354146-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftStreamConcatenate.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStreamConcatenate;
  end;
end;

procedure TMsftStreamConcatenate.ConnectTo(svrIntf: IStreamConcatenate);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftStreamConcatenate.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftStreamConcatenate.GetDefaultInterface: IStreamConcatenate;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftStreamConcatenate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftStreamConcatenateProperties.Create(Self);
{$ENDIF}
end;

destructor TMsftStreamConcatenate.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftStreamConcatenate.GetServerProperties: TMsftStreamConcatenateProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TMsftStreamConcatenate.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function  TMsftStreamConcatenate.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

function  TMsftStreamConcatenate.RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                                            out plibNewPosition: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.RemoteSeek(dlibMove, dwOrigin, plibNewPosition);
end;

function  TMsftStreamConcatenate.SetSize(libNewSize: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.SetSize(libNewSize);
end;

function  TMsftStreamConcatenate.RemoteCopyTo(const pstm: ISequentialStream; cb: _ULARGE_INTEGER; 
                                              out pcbRead: _ULARGE_INTEGER; 
                                              out pcbWritten: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.RemoteCopyTo(pstm, cb, pcbRead, pcbWritten);
end;

function  TMsftStreamConcatenate.Commit(grfCommitFlags: LongWord): HResult;
begin
  DefaultInterface.Commit(grfCommitFlags);
end;

function  TMsftStreamConcatenate.Revert: HResult;
begin
  DefaultInterface.Revert;
end;

function  TMsftStreamConcatenate.LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                            dwLockType: LongWord): HResult;
begin
  DefaultInterface.LockRegion(libOffset, cb, dwLockType);
end;

function  TMsftStreamConcatenate.UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                              dwLockType: LongWord): HResult;
begin
  DefaultInterface.UnlockRegion(libOffset, cb, dwLockType);
end;

function  TMsftStreamConcatenate.Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
begin
  DefaultInterface.Stat(pstatstg, grfStatFlag);
end;

function  TMsftStreamConcatenate.Clone(out ppstm: ISequentialStream): HResult;
begin
  DefaultInterface.Clone(ppstm);
end;

function  TMsftStreamConcatenate.Initialize(const stream1: ISequentialStream; 
                                            const stream2: ISequentialStream): HResult;
begin
  DefaultInterface.Initialize(stream1, stream2);
end;

function  TMsftStreamConcatenate.Initialize2(var streams: ISequentialStream; streamCount: LongWord): HResult;
begin
  DefaultInterface.Initialize2(streams, streamCount);
end;

function  TMsftStreamConcatenate.Append(const stream: ISequentialStream): HResult;
begin
  DefaultInterface.Append(stream);
end;

function  TMsftStreamConcatenate.Append2(var streams: ISequentialStream; streamCount: LongWord): HResult;
begin
  DefaultInterface.Append2(streams, streamCount);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftStreamConcatenateProperties.Create(AServer: TMsftStreamConcatenate);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftStreamConcatenateProperties.GetDefaultInterface: IStreamConcatenate;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoMsftStreamInterleave.Create: IStreamInterleave;
begin
  Result := CreateComObject(CLASS_MsftStreamInterleave) as IStreamInterleave;
end;

class function CoMsftStreamInterleave.CreateRemote(const MachineName: string): IStreamInterleave;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftStreamInterleave) as IStreamInterleave;
end;

procedure TMsftStreamInterleave.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{27354124-7F64-5B0F-8F00-5D77AFBE261E}';
    IntfIID:   '{27354147-7F64-5B0F-8F00-5D77AFBE261E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMsftStreamInterleave.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IStreamInterleave;
  end;
end;

procedure TMsftStreamInterleave.ConnectTo(svrIntf: IStreamInterleave);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMsftStreamInterleave.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMsftStreamInterleave.GetDefaultInterface: IStreamInterleave;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMsftStreamInterleave.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMsftStreamInterleaveProperties.Create(Self);
{$ENDIF}
end;

destructor TMsftStreamInterleave.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMsftStreamInterleave.GetServerProperties: TMsftStreamInterleaveProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TMsftStreamInterleave.RemoteRead(out pv: Byte; cb: LongWord; out pcbRead: LongWord): HResult;
begin
  DefaultInterface.RemoteRead(pv, cb, pcbRead);
end;

function  TMsftStreamInterleave.RemoteWrite(var pv: Byte; cb: LongWord; out pcbWritten: LongWord): HResult;
begin
  DefaultInterface.RemoteWrite(pv, cb, pcbWritten);
end;

function  TMsftStreamInterleave.RemoteSeek(dlibMove: _LARGE_INTEGER; dwOrigin: LongWord; 
                                           out plibNewPosition: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.RemoteSeek(dlibMove, dwOrigin, plibNewPosition);
end;

function  TMsftStreamInterleave.SetSize(libNewSize: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.SetSize(libNewSize);
end;

function  TMsftStreamInterleave.RemoteCopyTo(const pstm: ISequentialStream; cb: _ULARGE_INTEGER; 
                                             out pcbRead: _ULARGE_INTEGER; 
                                             out pcbWritten: _ULARGE_INTEGER): HResult;
begin
  DefaultInterface.RemoteCopyTo(pstm, cb, pcbRead, pcbWritten);
end;

function  TMsftStreamInterleave.Commit(grfCommitFlags: LongWord): HResult;
begin
  DefaultInterface.Commit(grfCommitFlags);
end;

function  TMsftStreamInterleave.Revert: HResult;
begin
  DefaultInterface.Revert;
end;

function  TMsftStreamInterleave.LockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                           dwLockType: LongWord): HResult;
begin
  DefaultInterface.LockRegion(libOffset, cb, dwLockType);
end;

function  TMsftStreamInterleave.UnlockRegion(libOffset: _ULARGE_INTEGER; cb: _ULARGE_INTEGER; 
                                             dwLockType: LongWord): HResult;
begin
  DefaultInterface.UnlockRegion(libOffset, cb, dwLockType);
end;

function  TMsftStreamInterleave.Stat(out pstatstg: tagSTATSTG; grfStatFlag: LongWord): HResult;
begin
  DefaultInterface.Stat(pstatstg, grfStatFlag);
end;

function  TMsftStreamInterleave.Clone(out ppstm: ISequentialStream): HResult;
begin
  DefaultInterface.Clone(ppstm);
end;

function  TMsftStreamInterleave.Initialize(var streams: ISequentialStream; 
                                           var interleaveSizes: LongWord; streamCount: LongWord): HResult;
begin
  DefaultInterface.Initialize(streams, interleaveSizes, streamCount);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMsftStreamInterleaveProperties.Create(AServer: TMsftStreamInterleave);
begin
  inherited Create;
  FServer := AServer;
end;

function TMsftStreamInterleaveProperties.GetDefaultInterface: IStreamInterleave;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoMsftWriteSpeedDescriptor.Create: IWriteSpeedDescriptor;
begin
  Result := CreateComObject(CLASS_MsftWriteSpeedDescriptor) as IWriteSpeedDescriptor;
end;

class function CoMsftWriteSpeedDescriptor.CreateRemote(const MachineName: string): IWriteSpeedDescriptor;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftWriteSpeedDescriptor) as IWriteSpeedDescriptor;
end;

class function CoMsftMultisessionSequential.Create: IMultisession;
begin
  Result := CreateComObject(CLASS_MsftMultisessionSequential) as IMultisession;
end;

class function CoMsftMultisessionSequential.CreateRemote(const MachineName: string): IMultisession;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_MsftMultisessionSequential) as IMultisession;
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TMsftDiscMaster2, TMsftDiscRecorder2, TMsftWriteEngine2, TMsftDiscFormat2Erase, 
    TMsftDiscFormat2Data, TMsftDiscFormat2TrackAtOnce, TMsftDiscFormat2RawCD, TMsftStreamZero, TMsftStreamPrng001, 
    TMsftStreamConcatenate, TMsftStreamInterleave]);
end;

end.

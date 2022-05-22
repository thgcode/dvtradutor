unit MBRPLAY;

{ FPMs-TCTS SOFTWARE LIBRARY                                                }
{ File : mbrplay.pas                                                        }
{ Purpose : MbrPlay main include                                            }
{ Author : Alain Ruelle                                                     }
{ Email : ruelle@tcts.fpms.ac.be                                            }
{                                                                           }
{ Copyright (c) 2000 Faculte Polytechnique de Mons (TCTS lab)               }
{ All rights reserved.                                                      }
{ PERMISSION IS HEREBY DENIED TO USE, COPY, MODIFY, OR DISTRIBUTE THIS      }
{ SOFTWARE OR ITS DOCUMENTATION FOR ANY PURPOSE WITHOUT WRITTEN             }
{ AGREEMENT OR ROYALTY FEES.                                                }

interface
uses
  Windows;

const  MBR_MSGINIT = 1;
const  MBR_MSGREAD = 2;
const  MBR_MSGWAIT = 4;
const  MBR_MSGWRITE = 8;
const  MBR_MSGEND = 16;
const  MBR_MSGALL = 31;
const  MBR_BYFILE = 32;
const  MBR_WAIT = 64;
const  MBR_CALLBACK = 128;
const  MBR_QUEUED = 256;
const  MBR_ASPHS = 512;

const  MBROUT_SOUNDBOARD = 0;
const  MBROUT_RAW = 1024;
const  MBROUT_WAVE = 2048;
const  MBROUT_AU = 4096;
const  MBROUT_AIFF = 8192;

const  MBROUT_ALAW = 16384;
const  MBROUT_MULAW = 32768;
const  MBROUT_DISABLED = 65536;

const  MBRERR_NOMBROLADLL = -11;
const  MBRERR_NOREGISTRY = -10;
const  MBRERR_NORESOURCE = -9;
const  MBRERR_NOTHREAD = -8;
const  MBRERR_DATABASENOTVALID = -7;
const  MBRERR_CANTOPENDEVICEOUT = -6;
const  MBRERR_BADCOMMAND = -5;
const  MBRERR_CANTOPENFILE = -4;
const  MBRERR_WRITEERROR = -3;
const  MBRERR_MBROLAERROR = -2;
const  MBRERR_CANCELLEDBYUSER = -1;
const  MBRERR_NOERROR = 0;

{ Custom Windows Messages }
const  WM_MBR_INIT = ($0400+$1BF);
const  WM_MBR_READ = ($0400+$1C00);
const  WM_MBR_WAIT = ($0400+$1C01);
const  WM_MBR_WRITE = ($0400+$1C02);
const  WM_MBR_END = ($0400+$1C03);

{ Callback Procedures }
type LPPLAYCALLBACKPROC = function(msg: LongInt;
                                   wParam: LongInt;
                                   lParam: LongInt): LongInt stdcall {cdecl};
type LPENUMDATABASECALLBACK = function(lpszID: PChar;
                                       dwUserData: LongInt): Bool stdcall {cdecl};

{ Synthesizer Input/Output Related Functions }
procedure MBR_MBRUnload;
function  MBR_Play(lpszText: PChar;
                   dwFlags: LongInt;
                   lpszOutFile: PChar;
                   dwCallback: pointer): LongInt stdcall;
function  MBR_Stop: LongInt stdcall;
function  MBR_WaitForEnd: LongInt stdcall;
function  MBR_SetPitchRatio(fPitch: Single): LongInt stdcall;
function  MBR_SetDurationRatio(fDuration: Single): LongInt stdcall;
function  MBR_SetVoiceFreq(lFreq: LongInt): LongInt stdcall;
function  MBR_SetVolumeRatio(fVol: Single): LongInt stdcall;
function  MBR_GetPitchRatio: Single stdcall;
function  MBR_GetDurationRatio: Single stdcall;
function  MBR_GetVoiceFreq: LongInt stdcall;
function  MBR_GetVolumeRatio: Single stdcall;
function  MBR_SetNoError(bNoError: Bool): LongInt stdcall;
function  MBR_GetNoError: Bool stdcall;
function  MBR_SetDatabase(lpszID: PChar): LongInt stdcall;
function  MBR_SetDatabaseEx(lpszID: PChar;
                            lpszRename: PChar;
                            lpszCopy: PChar): LongInt stdcall;
function  MBR_GetDatabase(lpID: PChar;
                          dwSize: LongInt): LongInt stdcall;
function  MBR_IsPlaying: Bool stdcall;
function  MBR_LastError(lpszError: PChar;
                        dwSize: LongInt): LongInt stdcall;

{ Syntheszier General informations }
procedure MBR_GetVersion(lpVersion: PChar;
                         dwSize: LongInt) stdcall;

{ Current Database Info }
function  MBR_GetDefaultFreq: LongInt stdcall;
function  MBR_GetDatabaseInfo(idx: LongInt;
                              lpMsg: PChar;
                              dwSize: LongInt): LongInt stdcall;
function  MBR_GetDatabaseAllInfo(lpMsg: PChar;
                                 dwSize: LongInt): LongInt stdcall;

{ Registry Related Functions }
function  MBR_RegEnumDatabase(lpszData: PChar;
                              dwSize: LongInt): LongInt stdcall;
function  MBR_RegEnumDatabaseCallback(lpedCallback: LPENUMDATABASECALLBACK;
                                      dwUserData: LongInt): LongInt stdcall;
function  MBR_RegGetDatabaseLabel(lpszID: PChar;
                                  lpLabel: PChar;
                                  dwSize: LongInt): LongInt stdcall;
function  MBR_RegGetDatabasePath(lpszID: PChar;
                                 lpPath: PChar;
                                 dwSize: LongInt): LongInt stdcall;
function  MBR_RegGetDatabaseCount: LongInt stdcall;
function  MBR_RegGetDefaultDatabase(lpID: PChar;
                                    dwSize: LongInt): LongInt stdcall;
function  MBR_RegSetDefaultDatabase(lpszID: PChar): LongInt stdcall;
function  MBR_RegisterDatabase(dbId: PChar;
                               dbPath: PChar;
                               dbLabel: PChar;
                               isDef: Bool;
                               lpBuffer: PChar;
                               dwSize: LongInt): Bool stdcall;
function  MBR_UnregisterDatabase(dbId: PChar): Bool stdcall;
function  MBR_UnregisterAll: Bool stdcall;
function  MBR_DatabaseExist(lpszID: PChar): Bool stdcall;

{ Registry Releated Functions, accessed by index }
function  MBR_RegIdxGetDatabaseId(nIdx: LongInt;
                                  lpszId: PChar;
                                  dwSize: LongInt): Bool stdcall;
function  MBR_RegIdxGetDatabasePath(nIdx: LongInt;
                                    lpszPath: PChar;
                                    dwSize: LongInt): Bool stdcall;
function  MBR_RegIdxGetDatabaseLabel(nIdx: LongInt;
                                     lpszLabel: PChar;
                                     dwSize: LongInt): Bool stdcall;
function  MBR_RegIdxGetDatabaseIndex(lpszID: PChar): LongInt stdcall;
function  MBR_RegIdxGetDefaultDatabase: LongInt stdcall;

{ Control Panel Access }
function  MBR_StartControlPanel(hParent: HWND): LongInt stdcall;

{ Callback Message Base }
function  MBR_SetCallbackMsgBase(dwBase: LongInt): LongInt stdcall;


implementation

procedure MBR_MBRUnload; external 'MBRPLAY.DLL' name '_MBR_MBRUnload@0';
function  MBR_Play; external 'MBRPLAY.DLL' name '_MBR_Play@16';
function  MBR_Stop; external 'MBRPLAY.DLL' name '_MBR_Stop@0';
function  MBR_WaitForEnd; external 'MBRPLAY.DLL' name '_MBR_WaitForEnd@0';
function  MBR_SetPitchRatio; external 'MBRPLAY.DLL' name '_MBR_SetPitchRatio@4';
function  MBR_SetDurationRatio; external 'MBRPLAY.DLL' name '_MBR_SetDurationRatio@4';
function  MBR_SetVoiceFreq; external 'MBRPLAY.DLL' name '_MBR_SetVoiceFreq@4';
function  MBR_SetVolumeRatio; external 'MBRPLAY.DLL' name '_MBR_SetVolumeRatio@4';
function  MBR_GetPitchRatio; external 'MBRPLAY.DLL' name '_MBR_GetPitchRatio@0';
function  MBR_GetDurationRatio; external 'MBRPLAY.DLL' name '_MBR_GetDurationRatio@0';
function  MBR_GetVoiceFreq; external 'MBRPLAY.DLL' name '_MBR_GetVoiceFreq@0';
function  MBR_GetVolumeRatio; external 'MBRPLAY.DLL' name '_MBR_GetVolumeRatio@0';
function  MBR_SetNoError; external 'MBRPLAY.DLL' name '_MBR_SetNoError@4';
function  MBR_GetNoError; external 'MBRPLAY.DLL' name '_MBR_GetNoError@0';
function  MBR_SetDatabase; external 'MBRPLAY.DLL' name '_MBR_SetDatabase@4';
function  MBR_SetDatabaseEx; external 'MBRPLAY.DLL' name '_MBR_SetDatabaseEx@12';
function  MBR_GetDatabase; external 'MBRPLAY.DLL' name '_MBR_GetDatabase@8';
function  MBR_IsPlaying; external 'MBRPLAY.DLL' name '_MBR_IsPlaying@0';
function  MBR_LastError; external 'MBRPLAY.DLL' name '_MBR_LastError@8';
procedure MBR_GetVersion; external 'MBRPLAY.DLL' name '_MBR_GetVersion@8';
function  MBR_GetDefaultFreq; external 'MBRPLAY.DLL' name '_MBR_GetDefaultFreq@0';
function  MBR_GetDatabaseInfo; external 'MBRPLAY.DLL' name '_MBR_GetDatabaseInfo@12';
function  MBR_GetDatabaseAllInfo; external 'MBRPLAY.DLL' name '_MBR_GetDatabaseAllInfo@8';
function  MBR_RegEnumDatabase; external 'MBRPLAY.DLL' name '_MBR_RegEnumDatabase@8';
function  MBR_RegEnumDatabaseCallback; external 'MBRPLAY.DLL' name '_MBR_RegEnumDatabaseCallback@8';
function  MBR_RegGetDatabaseLabel; external 'MBRPLAY.DLL' name '_MBR_RegGetDatabaseLabel@12';
function  MBR_RegGetDatabasePath; external 'MBRPLAY.DLL' name '_MBR_RegGetDatabasePath@12';
function  MBR_RegGetDatabaseCount; external 'MBRPLAY.DLL' name '_MBR_RegGetDatabaseCount@0';
function  MBR_RegGetDefaultDatabase; external 'MBRPLAY.DLL' name '_MBR_RegGetDefaultDatabase@8';
function  MBR_RegSetDefaultDatabase; external 'MBRPLAY.DLL' name '_MBR_RegSetDefaultDatabase@4';
function  MBR_RegisterDatabase; external 'MBRPLAY.DLL' name '_MBR_RegisterDatabase@24';
function  MBR_UnregisterDatabase; external 'MBRPLAY.DLL' name '_MBR_UnregisterDatabase@4';
function  MBR_UnregisterAll; external 'MBRPLAY.DLL' name '_MBR_UnregisterAll@0';
function  MBR_DatabaseExist; external 'MBRPLAY.DLL' name '_MBR_DatabaseExist@4';
function  MBR_RegIdxGetDatabaseId; external 'MBRPLAY.DLL' name '_MBR_RegIdxGetDatabaseId@12';
function  MBR_RegIdxGetDatabasePath; external 'MBRPLAY.DLL' name '_MBR_RegIdxGetDatabasePath@12';
function  MBR_RegIdxGetDatabaseLabel; external 'MBRPLAY.DLL' name '_MBR_RegIdxGetDatabaseLabel@12';
function  MBR_RegIdxGetDatabaseIndex; external 'MBRPLAY.DLL' name '_MBR_RegIdxGetDatabaseIndex@4';
function  MBR_RegIdxGetDefaultDatabase; external 'MBRPLAY.DLL' name '_MBR_RegIdxGetDefaultDatabase@0';
function  MBR_StartControlPanel; external 'MBRPLAY.DLL' name '_MBR_StartControlPanel@4';
function  MBR_SetCallbackMsgBase; external 'MBRPLAY.DLL' name '_MBR_SetCallbackMsgBase@4';

end.

(*
 * FPMs-TCTS SOFTWARE LIBRARY
 *
 * File    : mbrola.pas
 * Purpose : Mbrola interface with the MBROLA synthesizer DLL
 * Author  : Alain Ruelle
 * Email   : ruelle@multitel.be
 *
 * Copyright (c) 1997 Faculte Polytechnique de Mons (TCTS lab)
 * All rights reserved.
 *
 * translated to Delphi by Antonio Borges
 *               NCE/UFRJ - The Dosvox Project - 2007
 *)

unit mbrola;

interface
uses Windows, messages;


function load_MBR: boolean;
procedure unload_MBR;
function loaded_MBR: boolean;

(*---------------------------------------------------------*)

const
    PITCH_SWITCH = ';; F = ';
    TIME_SWITCH  = ';; T = ';

type
    AudioType = (
          LIN16=0,     // same as intern computation format: 16 bits linear
          LIN8,        // unsigned linear 8 bits, worse than telephone
          ULAW,        // MU law -> 8bits, telephone. Roughly equ. to 12bits
          ALAW         // A law  -> 8bits, equivallent to mulaw
    );


type
    PParser = pointer;
    LPPHONE = pointer;

var
    hinstDllMBR: THandle;

    init_MBR:            function (dbaname: pchar): integer stdcall;
    init_rename_MBR:     function (dbaname, replacing, cloning: pchar): integer stdcall;
    write_MBR:           function (buffer_in: pchar): integer stdcall;
    flush_MBR:           function: integer stdcall;
    read_MBR:            function (buffer_out: pshortInt; nb_wanted: integer): integer stdcall;
    readType_MBR:        function (buffer_out: pshortInt; nb_wanted: integer; filter: AudioType): integer stdcall;
    close_MBR:           procedure stdcall;
    reset_MBR:           procedure stdcall;

    lastError_MBR:       function: integer stdcall;
    lastErrorStr_MBR:    function (buffer_err: pchar; nb_wanted:integer): pchar stdcall;
    setNoError_MBR:      procedure (ignoreErrors: integer) stdcall;
    getNoError_MBR:      function: integer stdcall;

    setFreq_MBR:         procedure (nFreq: integer) stdcall;
    getFreq_MBR:         function: integer stdcall;
    setVolumeRatio_MBR:  procedure (fVol: real) stdcall;
    getVolumeRatio_MBR:  function: real stdcall;

    getVersion_MBR:      function (buffer: pchar; nb_wanted:integer): integer stdcall;
    getDatabaseInfo_MBR: function (buffer: pchar; nb_wanted, idx: integer): integer stdcall;

    setParser_MBR:       procedure (parser: PParser) stdcall;
    init_Phone:          function  (phone: pchar; fDur: real): LPPHONE stdcall;
    reset_Phone:         procedure (hPhoneme: LPPHONE) stdcall;
    close_Phone:         procedure (hPhoneme: LPPHONE) stdcall;
    appendf0_Phone:      procedure (hPhoneme: LPPHONE; percent, pitch: real) stdcall;

(*---------------------------------------------------------*)

implementation

function load_MBR: boolean;
begin
    hinstDllMBR := LoadLibrary('mbrola.dll');
    if hinstDllMBR = 0 then
        begin
            load_MBR := FALSE;
            exit;
        end;

    @init_MBR		 := GetProcAddress (hinstDllMBR,'init_MBR');
    @init_rename_MBR	 := GetProcAddress (hinstDllMBR,'init_rename_MBR');
    @write_MBR		 := GetProcAddress (hinstDllMBR,'write_MBR');
    @flush_MBR		 := GetProcAddress (hinstDllMBR,'flush_MBR');
    @read_MBR		 := GetProcAddress (hinstDllMBR,'read_MBR');
    @readType_MBR	 := GetProcAddress (hinstDllMBR,'readtype_MBR');
    @close_MBR		 := GetProcAddress (hinstDllMBR,'close_MBR');
    @reset_MBR		 := GetProcAddress (hinstDllMBR,'reset_MBR');
    @lastError_MBR	 := GetProcAddress (hinstDllMBR,'lastError_MBR');
    @lastErrorStr_MBR	 := GetProcAddress (hinstDllMBR,'lastErrorStr_MBR');
    @setNoError_MBR	 := GetProcAddress (hinstDllMBR,'setNoError_MBR');
    @getNoError_MBR	 := GetProcAddress (hinstDllMBR,'getNoError_MBR');
    @setFreq_MBR	 := GetProcAddress (hinstDllMBR,'setFreq_MBR');
    @getFreq_MBR	 := GetProcAddress (hinstDllMBR,'getFreq_MBR');
    @setVolumeRatio_MBR	 := GetProcAddress (hinstDllMBR,'setVolumeRatio_MBR');
    @getVolumeRatio_MBR	 := GetProcAddress (hinstDllMBR,'getVolumeRatio_MBR');
    @getVersion_MBR	 := GetProcAddress (hinstDllMBR,'getVersion_MBR');
    @getDatabaseInfo_MBR := GetProcAddress (hinstDllMBR,'getDatabaseInfo_MBR');
    @setParser_MBR	 := GetProcAddress (hinstDllMBR,'setParser_MBR');
    @init_Phone		 := GetProcAddress (hinstDllMBR,'init_Phone');
    @reset_Phone	 := GetProcAddress (hinstDllMBR,'reset_Phone');
    @close_Phone	 := GetProcAddress (hinstDllMBR,'close_Phone');
    @appendf0_Phone	 := GetProcAddress (hinstDllMBR,'appendf0_Phone');

    if (@init_MBR            = NIL) or   (@init_rename_MBR     = NIL) or
       (@write_MBR           = NIL) or   (@flush_MBR           = NIL) or
       (@read_MBR            = NIL) or   (@readType_MBR        = NIL) or
       (@close_MBR           = NIL) or   (@reset_MBR           = NIL) or
       (@lastError_MBR       = NIL) or   (@lastErrorStr_MBR    = NIL) or
       (@setNoError_MBR      = NIL) or   (@getNoError_MBR      = NIL) or
       (@setFreq_MBR         = NIL) or   (@getFreq_MBR         = NIL) or
       (@setVolumeRatio_MBR  = NIL) or   (@getVolumeRatio_MBR  = NIL) or
       (@getVersion_MBR      = NIL) or   (@getDatabaseInfo_MBR = NIL) or
       (@setParser_MBR       = NIL) or   (@init_Phone          = NIL) or
       (@reset_Phone         = NIL) or   (@close_Phone         = NIL) or
       (@appendf0_Phone      = NIL) then
            begin
                FreeLibrary (hinstDllMBR);
                hinstDllMBR := 0;
                load_MBR := false;
                exit;
            end;

    load_MBR := true;
end;

(*---------------------------------------------------------*)

procedure unload_MBR;
begin
    if hinstDllMBR <> 0 then
        begin
            FreeLibrary (hinstDllMBR);
            hinstDllMBR := 0;
    end;
end;

function loaded_MBR: boolean;
begin
    loaded_MBR := hinstDllMBR <> 0;
end;

end.


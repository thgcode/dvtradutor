//------------------------------------------------------
// Driver para lame_enc.dll
// Desenvolvimento original de lame.sourceforge.net
// Ajustes para uso no Dosvox por Antonio Borges
// em 12/11/2014
//------------------------------------------------------

unit lame_export;

interface

uses SysUtils, Windows, MMsystem;

function EncodeWavToMP3(inputFilename, outputFilename: string;
                        outputBitRate: integer): integer;

implementation

type
    THBE_STREAM = LongWord;
    PHBE_STREAM = ^PHBE_STREAM;
    BE_ERR = LongWord;

const
    // encoding formats
    BE_CONFIG_MP3 = 0;
    BE_CONFIG_LAME = 256;

  // error codes
    BE_ERR_SUCCESSFUL: LongWord = 0;
    BE_ERR_INVALID_FORMAT: LongWord = 1;
    BE_ERR_INVALID_FORMAT_PARAMETERS: LongWord = 2;
    BE_ERR_NO_MORE_HANDLES: LongWord = 3;
    BE_ERR_INVALID_HANDLE: LongWord = 4;
    BE_ERR_LIBRARY_NOT_LOADED: LongWord = 5;

    BE_INPUT_ERROR: LongWord = 10;
    BE_OUTPUT_ERROR: LongWord = 11;

    // other constants
    BE_MAX_HOMEPAGE = 256;

    // format specific variables
    BE_MP3_MODE_STEREO = 0;
    BE_MP3_MODE_DUALCHANNEL = 2;
    BE_MP3_MODE_MONO = 3;

type
    TMP3 = packed record
        dwSampleRate: LongWord;
        byMode: Byte;
        wBitRate: Word;
        bPrivate: LongWord;
        bCRC: LongWord;
        bCopyright: LongWord;
        bOriginal: LongWord;
    end;

    TLHV1 = packed record
        // structure information
        dwStructVersion: DWORD;
        dwStructSize: DWORD;

        // Basic encoder settings
        dwSampleRate: DWORD;      // 48000, 44100 and 32000 allowed
        dwReSampleRate: DWORD;    // Downsamplerate, 0=encoder decides
        nMode: Integer;           // BE_MP3_MODE_STEREO, BE_MP3_MODE_DUALCHANNEL, BE_MP3_MODE_MONO
        dwBitrate: DWORD;         // CBR bitrate (32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192,
                                  //    224, 256 and 320 allowed); VBR min bitrate
        dwMaxBitrate: DWORD;      // CBR ignored, VBR max bitrate
        nQuality: Integer;        // Quality setting (NORMAL, HIGH, LOW, VOICE)
        dwMpegVersion: DWORD;     // MPEG-1 OR MPEG-2
        dwPsyModel: DWORD;        // future use, set to 0
        dwEmphasis: DWORD;        // future use, set to 0

        // Bit stream settings
        bPrivate: LONGBOOL;       // Set Private Bit (TRUE/FALSE)
        bCRC: LONGBOOL;           // Insert CRC (TRUE/FALSE)
        bCopyright: LONGBOOL;     // Set Copyright Bit (TRUE/FALSE)
        bOriginal: LONGBOOL;      // Set Original Bit (TRUE/FALSE_

        // VBR stuff
        bWriteVBRHeader: LONGBOOL; // write XING VBR reader?
        bEnableVBR: LONGBOOL;      // use VBR encoding?
        nVBRQuality: Integer;      // VBR quality 0..9

        btReserved: array[ 0..255 ] of Byte; // FUTURE USE, SET TO 0
    end;

    TAAC = packed record
        dwSampleRate: LongWord;
        byMode: Byte;
        wBitRate: Word;
        byEncodingMethod: Byte;
    end;

    TFormat = packed record
        case byte of
            1: (mp3: TMP3);
            2: (lhv1: TLHV1);
            3: (aac: TAAC);
        end;

    TBE_Config = packed record
        dwConfig: LongWord;
        format: TFormat;
    end;

    PBE_Config = ^TBE_Config;

    TBE_Version = record
        byDLLMajorVersion: Byte;
        byDLLMinorVersion: Byte;

        byMajorVersion: Byte;
        byMinorVersion: Byte;

        byDay: Byte;
        byMonth: Byte;
        wYear: Word;

        zHomePage: array[ 0..BE_MAX_HOMEPAGE + 1 ] of Char;
    end;

    PBE_Version = ^TBE_Version;

var
    beConfig: TBE_Config;

{---------------------------------------------------------}
{               lame_enc.dll entry points
{---------------------------------------------------------}

var
    beInitStream: function (var pbeConfig: TBE_CONFIG; var dwSample: LongWord;
         var dwBufferSize: LongWord; var phbeStream: THBE_STREAM): BE_Err;
         cdecl;
    beEncodeChunk: function (hbeStream: THBE_STREAM; nSamples: LongWord;
         var pSample; var pOutput; var pdwOutput: LongWord): BE_Err;
         cdecl;
    beDeinitStream: function (hbeStream: THBE_STREAM; var pOutput;
         var pdwOutput: LongWord): BE_Err;
         cdecl;
    beCloseStream: function (hbeStream: THBE_STREAM): BE_Err;
         cdecl;
    beVersion: procedure (var pbeVersion: TBE_VERSION);
         cdecl;

var
    lame_dll_inst: THandle;

{---------------------------------------------------------}

function load_lame_dll: boolean;
begin
    lame_dll_inst := LoadLibrary('lame_enc.dll');
    if lame_dll_inst = 0 then
        begin
            result := FALSE;
            exit;
        end;

    @beInitStream   := GetProcAddress (lame_dll_inst, 'beInitStream');
    @beEncodeChunk  := GetProcAddress (lame_dll_inst, 'beEncodeChunk');
    @beDeinitStream := GetProcAddress (lame_dll_inst, 'beDeinitStream');
    @beCloseStream  := GetProcAddress (lame_dll_inst, 'beCloseStream');
    @beVersion      := GetProcAddress (lame_dll_inst, 'beVersion');

    if (@beInitStream   = NIL) or
       (@beEncodeChunk  = NIL) or
       (@beDeinitStream = NIL) or
       (@beCloseStream  = NIL) or
       (@beVersion      = NIL) then
             begin
                FreeLibrary (lame_dll_inst);
                lame_dll_inst := 0;
                result := false;
                exit;
            end;

    result := true;
end;

{---------------------------------------------------------}

procedure unload_lame_dll;
begin
    if lame_dll_inst <> 0 then
        begin
            FreeLibrary (lame_dll_inst);
            lame_dll_inst := 0;
    end;
end;

{---------------------------------------------------------}

function loaded_lame_dll: boolean;
begin
    result := lame_dll_inst <> 0;
end;

{---------------------------------------------------------}
{                      Configuration
{---------------------------------------------------------}

procedure beConfigure (inputSampleRate, outputBitRate: integer; mono: boolean);
begin
    beConfig.dwConfig := BE_CONFIG_LAME;

    //Structure information
    beConfig.Format.lhv1.dwStructVersion := 1;
    beConfig.Format.lhv1.dwStructSize := SizeOf(beConfig);
    //Basic encoder setting
    beConfig.Format.lhv1.dwSampleRate := inputSampleRate;
    beConfig.Format.lhv1.dwReSampleRate := inputSampleRate;
    if mono then
        beConfig.Format.lhv1.nMode := BE_MP3_MODE_MONO
    else
        beConfig.Format.lhv1.nMode := BE_MP3_MODE_STEREO;
    beConfig.Format.lhv1.dwBitrate := outputBitRate;
    beConfig.Format.lhv1.dwMaxBitrate := outputBitRate;
    beConfig.Format.lhv1.nQuality := 2;
    beConfig.Format.lhv1.dwMPegVersion := 1; //MPEG1
    beConfig.Format.lhv1.dwPsyModel := 0;
    beConfig.Format.lhv1.dwEmphasis := 0;
    //Bit Stream Settings
    beConfig.Format.lhv1.bPrivate := False;
    beConfig.Format.lhv1.bCRC := False;
    beConfig.Format.lhv1.bCopyright := True;
    beConfig.Format.lhv1.bOriginal := True;
    //VBR Stuff
    beConfig.Format.lhv1.bWriteVBRHeader := false;
    beConfig.Format.lhv1.bEnableVBR := false;
    beConfig.Format.lhv1.nVBRQuality := 0;
end;

{---------------------------------------------------------}
{                   Get WAV parameters
{---------------------------------------------------------}

function getWavParameters (fd: integer; var totalSize: LongWord;
                                        var wavfmt: PCMWAVEFORMAT): boolean;
var
    buf: array [0..255] of char;
    size: LongWord;
    transf: LongWord;
    lpFormat: PPCMWAVEFORMAT;
    achou: boolean;

begin
    result := false;

    transf := fileRead (fd, buf, 12);     { checa cabeçalho RIFF }
    if transf < 12 then exit;
    if strlicomp (buf, 'RIFF', 4) <> 0 then exit;

    transf := fileRead (fd, buf, 8);      { checa fmt }
    if transf < 8 then exit;
    if strlicomp (buf, 'fmt ', 4) <> 0 then exit;

    move (buf[4], size, 4);
    transf := fileRead (fd, buf, size);   { checa fmt }
    if size <> transf then exit;

    lpFormat := @buf[0];

    if lpFormat^.wf.wFormatTag <> WAVE_FORMAT_PCM then
        exit;    // só processo PCM
    move (buf, wavFmt, sizeof(PCMWAVEFORMAT));

    repeat
        transf := fileRead (fd, buf, 8);     { ignora chunks até data }
        if transf < 8 then exit;
        achou := strlicomp (buf, 'data', 4) = 0;
        move (buf[4], size, 4);
        if not achou then
            begin
               transf := fileRead (fd, buf, size);     { checa fmt }
               if size <> transf then exit;
            end;
    until achou;

    totalSize := size;
    result := true;
end;

{---------------------------------------------------------}
{                 Main encoding procedure
{---------------------------------------------------------}

function EncodeWavToMP3(inputFilename, outputFilename: string;
                        outputBitRate: integer): integer;
var
    dwSamples, dwSamplesMP3: LongWord;
    hbeStream: THBE_STREAM;
    error: BE_ERR;
    pBuffer: PSmallInt;
    pMP3Buffer: PByte;

    done: LongWord;
    dwWrite: LongWord;
    ToRead: LongWord;
    ToWrite: LongWord;

    wavfmt: PCMWAVEFORMAT;
    totalSize: LongWord;
    infile, outfile: integer;

begin
    if not loaded_lame_dll then
         begin
             result := BE_ERR_LIBRARY_NOT_LOADED;
             exit;
         end;

    result := BE_ERR_SUCCESSFUL;

    infile := fileOpen (inputFileName, fmOpenRead or fmShareDenyNone);
    if infile < 0 then
        begin
            result := BE_INPUT_ERROR;
            exit;
        end;

    if not getWavParameters (infile, totalSize, wavFmt) then
        begin
            result := BE_INPUT_ERROR;
            fileClose (infile);
            exit;
        end;

    outfile := fileCreate (outputFileName);
    if outfile < 0 then
        begin
            result := BE_OUTPUT_ERROR;
            fileClose (outfile);
            exit;
        end;

    beConfigure (wavFmt.wf.nSamplesPerSec, outputBitRate, wavfmt.wf.nChannels=1);

    error := beInitStream(beConfig, dwSamples, dwSamplesMP3, hbeStream);
    if error <> BE_ERR_SUCCESSFUL then
        begin
            fileClose(infile);
            fileClose(outfile);
            result := error;
            exit;
        end;

    pBuffer := AllocMem(dwSamples * 2);
    pMP3Buffer := AllocMem(dwSamplesMP3);

    done := 0;

    while (done < TotalSize) do
        begin
            if (done + dwSamples * 2 < TotalSize) then
              ToRead := dwSamples * 2
            else
                begin
                    ToRead := TotalSize - done;
                    FillChar(pbuffer^, dwSamples, 0);
                end;

            if FileRead(infile, pbuffer^, toread) = -1 then
                begin
                    result := BE_INPUT_ERROR;
                    break;
                end;

            error := beEncodeChunk(hbeStream, toRead div 2, pBuffer^,
                                   pMP3Buffer^, toWrite);
            if error <> BE_ERR_SUCCESSFUL then
                begin
                    result := error;
                    break;
                end;

            if FileWrite(outfile, pMP3Buffer^, toWrite) = -1 then
                begin
                    result := BE_OUTPUT_ERROR;
                    break;
                end;

            done := done + toread;
        end;

    if error = 0 then
        begin
            error := beDeInitStream(hbeStream, pMP3Buffer^, dwWrite);
            if error <> BE_ERR_SUCCESSFUL then
                result := error
            else
                if dwWrite <> 0 then
                    if FileWrite(outfile, pMP3Buffer^, dwWrite) = -1 then
                        result := BE_OUTPUT_ERROR;
        end;

    fileClose(infile);
    fileClose(outfile);
    beCloseStream(hbeStream);
    FreeMem(pBuffer);
    FreeMem(pMP3Buffer);
end;

begin
    if not load_lame_dll then
       beep(500, 1000);
end.

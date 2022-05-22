{------------------------------------------------------------}
{    Rotinas de tratamento de fala SAPI
{    Autor: José Antonio Borges
{    Em 9/10/2000
{------------------------------------------------------------}

unit dvsapi4;

interface

uses windows, messages, dvcrt, dvwav, dvsapglb,
     dialogs, comObj, sysUtils, activex, speech;

function sapiInic (voz, veloc, tom: integer; nomeArq: string): boolean;
procedure sapiFim;

procedure sapiFala (s: string);
procedure sapiFalaPchar (p: pchar);

function sapiAtivo (masc: byte): boolean;
{  masc = 1  - se acabou de processar buffers internos, talvez ainda falando }
{  masc <> 1 - se audio ou gravação ativa  }

procedure sapiReset;
procedure sapiPegaParam (var param: TParamVoz);
procedure sapiMudaParam (param: TParamVoz);
procedure sapiInfo (nvoz: integer; var paramSapi: TInfoSAPI);
function sapiNumVozes: integer;

implementation

uses mmsystem;

var
    fIAMM : IAudioMultimediaDevice;
    aTTSEnum : ITTSEnum;
    fITTSCentral : ITTSCentral;
    fpModeInfo : PTTSModeInfo;
    fTTSNotifySink : ITTSNotifySink;
    fTTSBufNotifySink : ITTSBufNotifySink;
    fdwKey: DWord;
    gpIAF: IAUDIOFILE;

    falasAtivas: integer;
    audioAtivo: boolean;
    vozAtual: integer;
    sapiEmArquivo: boolean;
    sapiNomeArq: string;

    sapiPosFalada: DWORD;

{----------------------------------------------------------}

type
    TTSBufNotifySink = class(TInterfacedObject, ITTSBufNotifySink)
       function TextDataDone(qTimeStamp: QWORD; dwFlags: DWORD): HResult; stdcall;
       function TextDataStarted(qTimeStamp: QWORD) : HResult; stdcall;
       function BookMark(qTimeStamp: QWORD; dwMarkNum: DWORD) : HResult; stdcall;
       function WordPosition(qTimeStamp: QWORD; dwByteOffset: DWORD) : HResult; stdcall;
      end;

    TTSNotifySink = class(TInterfacedObject, ITTSNotifySink)
       function AttribChanged(dwAttribute: DWORD) : HResult; stdcall;
       function AudioStart(qTimeStamp: QWORD) : HResult; stdcall;
       function AudioStop(qTimeStamp: QWORD) : HResult; stdcall;
       function Visual(qTimeStamp: QWORD;
                       cIPAPhoneme: Char;
                       cEnginePhoneme: Char;
                       dwHints: DWORD;
                       apTTSMouth: PTTSMouth) : HResult; stdcall;
      end;

{----------------------------------------------------------}

function TTSBufNotifySink.TextDataDone(qTimeStamp: QWORD; dwFlags: DWORD): HResult;
begin
  falasAtivas := falasAtivas - 1;
  if falasAtivas < 0 then falasAtivas := 0;
  result := 0;
end;

function TTSBufNotifySink.TextDataStarted(qTimeStamp: QWORD) : HResult;
begin
  falasAtivas := falasAtivas + 1;
  result := 0;
end;

function TTSBufNotifySink.BookMark(qTimeStamp: QWORD; dwMarkNum: DWORD) : HResult;
begin
  result := 0;
end;

function TTSBufNotifySink.WordPosition(qTimeStamp: QWORD; dwByteOffset: DWORD) : HResult;
begin
  result := 0;
  sapiPosFalada := dwByteOffset;
end;

{----------------------------------------------------------}

function TTSNotifySink.AttribChanged(dwAttribute: DWORD) : HResult;
begin
  result := 0;
end;

function TTSNotifySink.AudioStart(qTimeStamp: QWORD) : HResult;
begin
  audioAtivo := true;
  result := 0;
end;

function TTSNotifySink.AudioStop(qTimeStamp: QWORD) : HResult;
begin
  audioAtivo := false;
  result := 0;
end;

function TTSNotifySink.Visual(qTimeStamp: QWORD;
               cIPAPhoneme: Char;
               cEnginePhoneme: Char;
               dwHints: DWORD;
               apTTSMouth: PTTSMouth) : HResult;
begin
  result := 0;
end;

{----------------------------------------------------------}

function sapiInic (voz, veloc, tom: integer; nomeArq: string): boolean;
var i: integer;
    ModeInfo : TTSModeInfo;
    fITTSAttributes : ITTSAttributes;
    dir: string;
    wstr: WideString;
    devId: Cardinal;
    
begin
    sapiNomeArq := nomeArq;
    sapiEmArquivo := nomeArq <> '';
    if voz = 0 then voz := 1;   // evita acessos errados

    getDir (0, dir);
    sapiInic := false;

    try
    if sapiEmArquivo then
        begin
            OleCheck(CoCreateInstance(CLSID_AudioDestFile, NIL, CLSCTX_ALL,
                    IID_IAudioFile, gpIAF));

            wstr := sapiNomeArq;
            if gpIAF.DoSet(@wstr[1], 1) <> 0 then
                begin
                    chDir (dir);
                    exit;
                end;
        end
    else
        OleCheck(CoCreateInstance(CLSID_MMAudioDest, Nil, CLSCTX_ALL,
           IID_IAudioMultiMediaDevice, fIAMM));
        devId := waveGetCurrentDeviceId;
        if devId <> WAVE_MAPPER then
            fIAMM.DeviceNumSet(devId);

    except
       chDir (dir);
       exit;
    end;

    CoCreateInstance(CLSID_TTSEnumerator, Nil, CLSCTX_ALL, IID_ITTSEnum, aTTSEnum);
    aTTSEnum._AddRef;
    aTTSEnum.Reset;
    try
        new(fpModeInfo);
        for i := 1 to voz do
            OleCheck(aTTSEnum.Next(1, ModeInfo, NIL));
        fpModeInfo^ := ModeInfo;
        if sapiEmArquivo then
             OleCheck(aTTSEnum.Select(fpModeInfo^.gModeID, fITTSCentral, IUnknown(gpIAF)))
        else
             OleCheck(aTTSEnum.Select(fpModeInfo^.gModeID, fITTSCentral, IUnknown(fIAMM)));
    except
         fiAMM := NIL;
         aTTSEnum := NIL;
         dispose (fpModeInfo);
         fpModeInfo := NIL;
         if assigned (fiTTSCentral) then fiTTSCentral := NIL;
         chDir (dir);
         exit;
    end;

    fTTSBufNotifySink := TTSBufNotifySink.Create;
    fTTSNotifySink := TTSNotifySink.Create;
    OleCheck(fITTSCentral.Register( pointer(fTTSNotifySink), IID_ITTSNotifySink, fdwKey));

    vozAtual := voz;
    sapiInic := true;

    if assigned (fITTSCentral) then
      begin
          OleCheck(fITTSCentral.QueryInterface(IID_ITTSAttributes, fITTSAttributes));
          with fITTSAttributes do
              begin
                  if veloc <> 0 then SpeedSet(veloc);
                  if tom <> 0 then PitchSet(tom);
              end;
          if assigned(fITTSAttributes) then fITTSAttributes := Nil;
      end;
    chDir (dir);
end;

{----------------------------------------------------------}

procedure sapiFim;
begin
    if assigned(gpIAF) then
        begin
            gpIAF.Flush;
            gpIAF := Nil;
        end;
    if assigned(fIAMM) then fIAMM := Nil;
    if assigned(aTTSEnum) then
        begin
            aTTSEnum._Release;
            aTTSEnum := nil;
        end;

    if assigned(fTTSBufNotifySink) then fTTSBufNotifySink := Nil;
    if assigned(fTTSNotifySink) then
    begin
        fITTSCentral.unregister(fdwKey);
        fTTSNotifySink := Nil;
    end;
    fITTSCentral := NIL;
end;

{----------------------------------------------------------}

procedure sapiFalaPchar (p: pchar);
var SData : TSData;
begin
  while (strLen(p) <> 0) and (p[0] = ' ') do p := p + 1;
  if strLen(p) = 0 then exit;

  if not assigned (fITTSCentral) or (keyStopsWave and keypressed) then exit;

  SData.dwSize := strLen(p) + 1;
  SData.pData := p;
  try
      OleCheck(fITTSCentral.TextData (CHARSET_TEXT, 0,
           SData, pointer(fTTSBufNotifySink), IID_ITTSBufNotifySink));
  except
      sapiReset;
  end;
end;

{----------------------------------------------------------}

procedure sapiFala (s: string);
var
    SData : TSData;
    pch: array [0..64000] of char;
begin
    s := trim (s);
    if s = '' then exit;
    if (length (s) = 1) and (s[1] in ['0'..'9']) then s := s + '.';

    if not assigned (fITTSCentral) or (keyStopsWave and keypressed) then exit;

    SData.dwSize := length(s) + 1;
    strPCopy (pch, s);
    SData.pData := @pch;
    try
        if falasAtivas > 0 then delay (20);
        OleCheck(fITTSCentral.TextData (CHARSET_TEXT, 0,
                 SData, pointer(fTTSBufNotifySink), IID_ITTSBufNotifySink));
    except
        sapiReset;
    end;
end;

{----------------------------------------------------------}

function sapiAtivo (masc: byte): boolean;
{
   masc = 1  - se acabou de processar buffers internos, talvez ainda falando
   masc <> 1 - se audio ou gravação ativa
}
begin
   if masc = 1 then
       result := falasAtivas > 0
   else
       result := (falasAtivas > 0) or audioAtivo;
end;

{----------------------------------------------------------}

procedure sapiReset;
begin
    if audioAtivo then
        if assigned (fITTSCentral) then
           begin
               try
                   delay (50);
                   OleCheck(fITTSCentral.AudioReset);
                   delay (150);
               except
               end;
           end;
    audioAtivo := false;
    falasAtivas := 0;
end;

{----------------------------------------------------------}

procedure sapiPegaParam (var param: TParamVoz);
var
    dw: DWord;
    w: word;
    fITTSAttributes : ITTSAttributes;
begin
  if assigned (fITTSCentral) then
      begin
          OleCheck(fITTSCentral.QueryInterface(IID_ITTSAttributes, fITTSAttributes));
          with param, fITTSAttributes do
              begin
                  tipoSapi := 4;
                  voz := vozAtual;
                  SpeedGet(dw);  velocidade := dw;
                  PitchGet(w);  tom := w;

                  SpeedSet(TTSATTR_MINSpeed);
                  SpeedGet(dw);  minVeloc := dw;
                  SpeedSet(TTSATTR_MAXSpeed);
                  SpeedGet(dw);  maxVeloc := dw;
                  SpeedSet(velocidade);

                  PitchSet(TTSATTR_MINPitch);
                  PitchGet(w);  minTom := w;
                  PitchSet(TTSATTR_MAXPitch);
                  PitchGet(w);  maxTom := w;
                  PitchSet(tom);
              end;
      end;
    if assigned(fITTSAttributes) then fITTSAttributes := Nil;
end;

{----------------------------------------------------------}

function sapiNumVozes: integer;
var i: integer;
    ModeInfo : TTSModeInfo;
    fITTSAttributes : ITTSAttributes;
    numFound: longint;
begin
    result := 0;
    if not assigned (fITTSCentral) then exit;

    OleCheck(fITTSCentral.QueryInterface(IID_ITTSAttributes, fITTSAttributes));
    with fITTSAttributes do
        begin
            aTTSEnum.Reset;
            i := 0;
            repeat
                aTTSEnum.Next(1, ModeInfo, @numFound);
                i := i + 1;
            until numFound = 0;
            result := i-1;
        end;
end;

{----------------------------------------------------------}

procedure sapiMudaParam (param: TParamVoz);
var i: integer;
    modeInfo: TTSModeInfo;
    fITTSAttributes : ITTSAttributes;
begin
    sapiReset;
    aTTSEnum.Reset;
    try
        for i := 1 to param.voz do
            OleCheck(aTTSEnum.Next(1, ModeInfo, NIL));
        fpModeInfo^ := ModeInfo;
        OleCheck(aTTSEnum.Select(fpModeInfo^.gModeID, fITTSCentral, IUnknown(fIAMM)));

        OleCheck(fITTSCentral.QueryInterface(IID_ITTSAttributes, fITTSAttributes));
        if assigned (fITTSAttributes) then
            begin
                with param, fITTSAttributes do
                      begin
                          if param.velocidade <> 0 then
                              SpeedSet(param.velocidade);
                          if param.tom <> 0 then
                              PitchSet(param.tom);
                      end;
                fITTSAttributes := Nil;
            end;

    except
        aTTSEnum.Reset;
        OleCheck(aTTSEnum.Next(1, ModeInfo, NIL));
        fpModeInfo^ := ModeInfo;
        OleCheck(aTTSEnum.Select(fpModeInfo^.gModeID, fITTSCentral, IUnknown(fIAMM)));
    end;
end;

{----------------------------------------------------------}

procedure sapiInfo (nvoz: integer; var paramSapi: TInfoSAPI);
var i: integer;
    modeInfo: TTSModeInfo;
begin
    sapiReset;
    aTTSEnum.Reset;
    try
        for i := 1 to nvoz do
            OleCheck(aTTSEnum.Next(1, ModeInfo, NIL));
        fpModeInfo^ := ModeInfo;
        with paramSapi do
            begin
                voz := nvoz;
                nomeVoz   := fpModeInfo^.szSpeaker;
                sexo      := fpModeInfo^.wGender;
                idade     := fpModeInfo^.wAge;
                estilo    := fpModeInfo^.szStyle;
                modo      := fpModeInfo^.szModeName;
                lingua    := fpModeInfo^.Language.LanguageID;
                dialeto   := fpModeInfo^.Language.szDialect;
                produtor  := fpModeInfo^.szMfgName;
                produto   := fpModeInfo^.szProductName;
            end;
    except
        aTTSEnum.Reset;
        OleCheck(aTTSEnum.Next(1, ModeInfo, NIL));
        fpModeInfo^ := ModeInfo;
        OleCheck(aTTSEnum.Select(fpModeInfo^.gModeID, fITTSCentral, IUnknown(fIAMM)));
    end;
end;

end.


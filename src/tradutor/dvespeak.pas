{------------------------------------------------------------}
{    Rotinas de tratamento do eSpeak
{------------------------------------------------------------}

unit dvEspeak;

interface

uses dvCrt, dvWav, dvSapGlb, speak_lib, sysutils;

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
var sampleRate: integer;

function espeakCallback(wav: pByte; numsamples: integer; events: pespeak_EVENT):
integer; cdecl;
    begin
    espeakCallback := 0; // Continua sinteze

    if wav = nil then exit;

    if numSamples = 0 then exit;

    wavePlay(pChar(wav), numSamples * 2, sampleRate, 16, 1);
end;

function sapiInic (voz, veloc, tom: integer; nomeArq: string): boolean;
begin
    sampleRate := espeak_Initialize(AUDIO_OUTPUT_SYNCHRONOUS, 0, 'C:\Program files (x86)\NVDA\synthDrivers', 0);

    if sampleRate = -1 then
        begin
        sapiInic := false;
        exit;
    end;

    espeak_setSynthCallback(@espeakCallback);
    espeak_setVoiceByName('pt-BR+thiago');
    espeak_setParameter(espeakRate, 449, 0);
    sapiInic := true;
end;

procedure sapiFim;
begin
    espeak_Terminate;
end;

procedure sapiFala (s: string);
begin
    if (length(s) = 1) and not (s[1] in ['a'..'z'] + ['A'..'Z']) then
        begin
        espeak_Key(@s[1]);
        exit;
    end;

    s := trim(s);

    if s ='' then exit;

    espeak_Synth(@s[1], length(s), 0, POS_CHARACTER, 0, 0, nil, nil);
end;

procedure sapiFalaPchar (p: pchar);
begin
sapiFala(strPas(p));
end;

function sapiAtivo (masc: byte): boolean;
{  masc = 1  - se acabou de processar buffers internos, talvez ainda falando }
{  masc <> 1 - se audio ou gravação ativa  }
begin
    sapiAtivo := waveIsPlaying;
end;

procedure sapiReset;
begin
    espeak_Cancel;
end;

procedure sapiPegaParam (var param: TParamVoz);
begin
end;

procedure sapiMudaParam (param: TParamVoz);
begin
end;

procedure sapiInfo (nvoz: integer; var paramSapi: TInfoSAPI);
begin
end;

function sapiNumVozes: integer;
begin
    sapiNumVozes := 1;
end;

end.

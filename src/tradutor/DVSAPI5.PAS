unit dvSapi5;
interface
uses dvsapGlb;
function sapiInic (voz_, veloc, tom: integer; nomeArq: string): boolean;
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
uses sysutils, dvCrt, windows, variants, comobj;
var voz: variant;
    vozAtual: integer;
    numVozes: integer;
ev: tHandle;

const
  SVSFDefault = $00000000;
  SVSFlagsAsync = $00000001;
  SVSFPurgeBeforeSpeak = $00000002;
  SVSFIsFilename = $00000004;
  SVSFIsXML = $00000008;
  SVSFIsNotXML = $00000010;
  SVSFPersistXML = $00000020;
  SVSFNLPSpeakPunc = $00000040;
  SVSFNLPMask = $00000040;
  SVSFVoiceMask = $0000007F;
  SVSFUnusedFlags = $FFFFFF80;
  SVEStartInputStream = $00000002;
  SVEEndInputStream = $00000004;
  SVEVoiceChange = $00000008;
  SVEBookmark = $00000010;
  SVEWordBoundary = $00000020;
  SVEPhoneme = $00000040;
  SVESentenceBoundary = $00000080;
  SVEViseme = $00000100;
  SVEAudioLevel = $00000200;
  SVEPrivate = $00008000;
  SVEAllEvents = $000083FE;

function sapiInic (voz_, veloc, tom: integer; nomeArq: string): boolean;
var tokens: variant;
begin
voz := createOleObject('SAPI.SpVoice');
tokens := voz.GetVoices('', '');
voz.Voice := tokens.Item(voz_ - 1);
voz.Rate := veloc;
    ev := voz.SpeakCompleteEvent;
	vozAtual := voz_;
	numVozes := tokens.Count;
result := true;
end;

procedure sapiFim;
begin
    voz := nil;
end;

procedure sapiFala (s: string);
begin
    if s = '' then s := ' ';   // tem que tentar falar algo para poder causar evento
    voz.Speak(s, SVSFlagsAsync+SVSFIsNotXML);
end;

procedure sapiFalaPchar (p: pchar);
begin
sapiFala(strPas(p));
end;

function sapiAtivo (masc: byte): boolean;
{  masc = 1  - se acabou de processar buffers internos, talvez ainda falando }
{  masc <> 1 - se audio ou gravação ativa  }
var ativo: boolean;
begin
    ativo := waitForSingleObject (ev, 20) = WAIT_TIMEOUT;
    sapiAtivo := ativo;
    if ativo then   // estrutura do dosvox exige evento para ficar acordada
        postMessage (crtWindow, WM_USER+1956, 0, 0);
end;

procedure sapiReset;
begin
    voz.Speak(string(' '), SVSFPurgeBeforeSpeak+SVSFDefault);
end;

procedure sapiPegaParam (var param: TParamVoz);
begin
    sapiReset;
              param.tipoSapi := 5;
              param.voz := vozAtual;
              param.velocidade := voz.Rate;
              param.tom := 0;

              param.minVeloc := -10;
              param.maxVeloc := 10;
              param.minTom := 0;
              param.maxTom := 0;
          end;

procedure sapiMudaParam (param: TParamVoz);
var
    SOTokens: variant;
begin
    sapiReset;
              param.voz := vozAtual;
              SOTokens := voz.GetVoices('','');
              voz.Voice := SoTokens.Item(param.voz-1);
              voz.rate := param.velocidade;
              SOTokens := NIL;
          end;

procedure sapiInfo (nvoz: integer; var paramSapi: TInfoSAPI);
var
    SOTokens: Variant;
    SOToken: Variant;
    s: string;
    p: integer;
const
    naoDisponivel: string = 'Não disponível';
begin
    sapiReset;
    SOTokens := voz.GetVoices('', '');
    SOToken := SOTokens.Item(nvoz-1);
    with paramSapi do
        begin
            voz := nvoz;
            nomeVoz   := SOToken.GetAttribute ('Name');

            lingua    := 409;
            dialeto   := naoDisponivel;
            try
                s := SOToken.GetAttribute ('Language');
                if s <> '' then
                    begin
                         p := pos (';', s);
                         if p = 0 then
                             lingua := strToInt (trim(s))
                         else
                             begin
                                 lingua := strToInt (trim(copy(s, 1, p-1)));
                                 dialeto := trim(copy(s, p+1, 999));
                             end;
                    end;
            except
            end;

            produtor  := naoDisponivel;
            try
                produtor  := SOToken.GetAttribute ('Vendor');
            except end;
            sexo := 0;
            try
                s := SOToken.GetAttribute ('Gender');
                if copy (s, 1, 1) = 'M' then sexo := 0 else sexo := 1;
            except end;

            idade     := 21;
            estilo    := naoDisponivel;
            modo      := naoDisponivel;
            produto   := naoDisponivel;
        end;

    SOTokens := Unassigned;
    SOToken := unassigned;
end;

function sapiNumVozes: integer;
begin
result := voz.GetVoices('', '').Count;
end;
end.

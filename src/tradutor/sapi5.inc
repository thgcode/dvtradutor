function sapiInic (voz, veloc, tom: integer; nomeArq: string): boolean;
procedure sapiFim;

procedure sapiFala (s: string);
procedure sapiFalaPchar (p: pchar);
function sapiAtivo (masc: byte): boolean;
    {  masc = 1 - se acabou de falar   }
    {  masc = 2 - se acabou de processar buffers internos, talvez ainda falando }
function sapiReset: boolean;
procedure sapiPegaParam (var param: TParamVoz);
procedure sapiMudaParam (param: TParamVoz);
procedure sapiInfo (nvoz: integer; var paramSapi: TInfoSAPI);
function sapiNumVozes: integer;

var
    sapiPosFalada: DWORD;

implementation

var sintet: TSpVoice;
    SoundFileStream: TSpFileStream;
    ev: THandle;

    vozAtual: integer;
    numVozes: integer;

{----------------------------------------------------------}

function sapiInic (voz, veloc, tom: integer; nomeArq: string): boolean;
var
    SOTokens: ISpeechObjectTokens;
    SOToken: ISpeechObjectToken;
    v: integer;
    wNomeArq: WideString;

begin
    result := false;
    try
        sintet := TSpVoice.Create(NIL);
    except exit; end;

    try
        sintet.EventInterests := SVEAllEvents;    // SVEEndInputStream
    except exit; end;

    SOTokens := sintet.GetVoices('','');
    numVozes := SoTokens.count;
    if numVozes = 0 then exit;

    if (voz <= 0) or (voz > numVozes) then
        begin
            voz := 1;   // evita acessos errados
            veloc := 0;
            // tom := 0;
        end;

    v := voz - 1;   // Sapi 5 indexa a partir de 0
    sintet.Voice := SoTokens.Item(v);
    try
        sintet.Rate := veloc;
    except end;
    ev := sintet.SpeakCompleteEvent;

    if nomeArq <> '' then
        begin
            SoundFileStream := TSpFileStream.Create(NIL);
            wNomeArq := nomeArq;
            SoundFileStream.Open (wNomeArq, SSFMCreateForWrite, True);
            sintet.AudioOutputStream := SoundFileStream.DefaultInterface;
        end;

    SOTokens := NIL;
    SOToken := NIL;
    vozAtual := v+1;
    sapi5AceitaXML := false;
    result := true;
end;

{----------------------------------------------------------}

procedure sapiFim;
begin
    while sapiAtivo (1) do delay (300);

    if SoundFileStream <> NIL then
        begin
            SoundFileStream.close;
            SoundFileStream.free;
            SoundFileStream := NIL;
        end;

    sintet.free;
    sintet := NIL;
end;

{----------------------------------------------------------}

procedure sapiFalaPchar (p: pchar);
begin
    sapiFala (strPas(p));
end;

{----------------------------------------------------------}

procedure sapiFala (s: string);
begin
    if s = '' then s := ' ';   // tem que tentar falar algo para poder causar evento
    try
        if sapi5AceitaXML then
            sintet.Speak(s, SVSFlagsAsync+SVSFIsXML)
        else
            sintet.Speak(s, SVSFlagsAsync+SVSFIsNotXML);
    except
        sysUtils.beep;
    end;
end;

{----------------------------------------------------------}

function sapiAtivo (masc: byte): boolean;
var ativo: boolean;
begin
    ativo := waitForSingleObject (ev, 20) = WAIT_TIMEOUT;
    sapiAtivo := ativo;
    if ativo then   // estrutura do dosvox exige evento para ficar acordada
        postMessage (crtWindow, WM_USER+1956, 0, 0);
end;

{----------------------------------------------------------}

function sapiReset: boolean;
var erro: boolean;
begin
    erro := false;
    try
        sintet.Speak(' ', SVSFPurgeBeforeSpeak+SVSFDefault);
        delay (50);
    except
        erro := true;
    end;
    result := erro;
end;

{----------------------------------------------------------}

procedure sapiPegaParam (var param: TParamVoz);
begin
    sapiReset;
    with param do
          begin
              tipoSapi := 5;
              voz := vozAtual;
              velocidade := sintet.Rate;
              tom := 0;

              minVeloc := -10;
              maxVeloc := 10;
              minTom := 0;
              maxTom := 0;
          end;
end;

{----------------------------------------------------------}

function sapiNumVozes: integer;
begin
    result := numVozes;
end;

{----------------------------------------------------------}

procedure sapiMudaParam (param: TParamVoz);
var
    SOTokens: ISpeechObjectTokens;
begin
    sapiReset;
    with param do
          begin
              voz := vozAtual;
              SOTokens := sintet.GetVoices('','');
              sintet.Voice := SoTokens.Item(voz-1);
              sintet.rate := velocidade;
              SOTokens := NIL;
          end;
end;

{----------------------------------------------------------}

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
    SOTokens := sintet.GetVoices('','');
    SOToken := SOTokens.Item(nvoz-1);
    with paramSapi do
        begin
            nomeVoz := '-- sintetizador inválido --';
            lingua    := 1046;
            dialeto   := naoDisponivel;
            produtor  := naoDisponivel;
            sexo := 0;  // neutro
            idade     := 21;
            estilo    := naoDisponivel;
            modo      := naoDisponivel;
            produto   := naoDisponivel;

            voz := nvoz;
            try
                nomeVoz   := SOToken.GetAttribute ('Name');

                try
                    s := SOToken.GetAttribute ('Language');
                    if s <> '' then
                        begin
                             p := pos (';', s);
                             lingua := 0;
                             if p = 0 then
                                 lingua := strToInt ('$'+s)
                             else
                                 begin
                                     lingua := strToInt ('$'+trim(copy(s, 1, p-1)));
                                     dialeto := trim(copy(s, p+1, 999));
                                 end;
                        end;
                except end;

                try
                    produtor  := SOToken.GetAttribute ('Vendor');
                except end;

                try
                    s := SOToken.GetAttribute ('Gender');
                    if copy (s, 1, 1) = 'M' then sexo := 2 else sexo := 1;
                except end;

            except end;
        end;

    SOTokens := Unassigned;
    SOToken := unassigned;
end;


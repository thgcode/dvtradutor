{--------------------------------------------------------}
{
{     Rotinas de aquisição em baixo nível
{
{     Autor: José Antonio Borges
{
{     Em 13/6/99
{
{--------------------------------------------------------}

unit dvgrav;
interface
uses windows, sysutils, mmsystem;

function preparaGravacao (nomeArq: string;
                          veloc: longint; bits, canais: word;
                          numBuffers, tamBuffer: word): integer;
{ retornos:  0: ok;  >0: não inicializou som;   -1: erro de escrita }

procedure iniciaGravacao;
function monitoraGravacao: boolean;   { obrigatório chamar esta rotina frequentemente }
function terminaGravacao: boolean;
procedure genWavHdr (pvet: pchar; veloc: longint; bits, channels: word; size: longint);

var
    arqGravador: file;
    tamGravado: longint;

implementation

const maxBuf = 16;

var
    hWavIn: HWaveIn;
    nBuf, tamBuf: word;

    hbuf: array [0..maxBuf-1] of THandle;
    pBuf: array [0..maxBuf-1] of pChar;
    hhdr: array [0..maxBuf-1] of THandle;
    lpWaveInHdr: array [0..maxBuf-1] of PWaveHdr;
    pin: integer;

    hdr: array [0..43] of char;

    listening: boolean;
    velocGrav, bitsGrav, canaisGrav: word;

{-------------------------------------------------------------}
{                    abre o dispositivo de áudio
{-------------------------------------------------------------}

function openWaveDevice (uDeviceId: UINT; veloc: longint; bits, channels: integer): word;
var
    lpFormat: PPcmWaveFormat;
    dwCallback, dwInstance, dwFlags: longint;
    status: word;
begin
    new (lpFormat);
    with lpFormat^, lpFormat^.wf do
        begin
            wFormatTag := WAVE_FORMAT_PCM;
            nSamplesPerSec := veloc;
            wBitsPerSample := bits;
            nChannels := channels;
            nBlockAlign := (wBitsPerSample div 8) * nChannels;
            nAvgBytesPerSec := nBlockAlign * nSamplesPerSec;
        end;

    dwCallBack := 0;
    dwInstance := 0;
    dwFlags := 0 { CALLBACK_WINDOW };

    status := waveInOpen(@hWavIn, uDeviceID, @lpFormat^,
                          dwCallback, dwInstance, dwFlags);

    openWaveDevice := status;    {zero significa ok}

    velocGrav := veloc;
    bitsGrav := bits;
    canaisGrav := channels;

    dispose (lpformat);
end;

{-------------------------------------------------------------}
{            envia um buffer ao sistema multimídia
{-------------------------------------------------------------}

procedure PrepareBuffer (i: integer);
begin
    fillChar (lpWaveInHdr [i]^, sizeof (TWaveHdr), 0);
    with lpWaveInHdr [i]^ do
        begin
            lpData := pBuf[i];       { pointer to locked data buffer }
            dwBufferLength := tamBuf;
        end;

    if waveInPrepareHeader(hWavIn, lpWaveInHdr [i], sizeof (TWaveHdr)) <> 0 then
        begin
            writeln (#$07, #$07, #$07, 'Falha na preparação do buffer de gravação #', i);
            exit;
        end;

    waveInAddBuffer (hWavIn, lpWaveInHdr [i], sizeof (TWaveHdr));
end;

{-------------------------------------------------------------}
{       inicializa sistema de gravação e abre arquivo
{-------------------------------------------------------------}

function preparaGravacao (nomeArq: string;
                          veloc: longint; bits, canais: word;
                          numBuffers, tamBuffer: word): integer;
var
    i, status: integer;
label erroDisco;

begin
    sndPlaySound (NIL, snd_sync);

    preparaGravacao := 0;
    status := openWaveDevice (WAVE_MAPPER, veloc, bits, canais);   { $FFFF = Wave Mapper }
    if status <> 0 then
        begin
            preparaGravacao := status;  {não conseguiu abrir canal}
            exit;
        end;

    assign (arqGravador, nomeArq);
    {$I-} rewrite (arqGravador, 1);  {$I+}
    if ioresult <> 0 then goto erroDisco;

    {$I-}   blockWrite (arqGravador, hdr, 44);  {$I+}   { espaço para o cabecalho }
    if ioresult <> 0 then goto erroDisco;

    tamGravado := 0;
    nBuf := numBuffers;
    tamBuf := tamBuffer;

    for i := 0 to nBuf-1 do
        begin
            hbuf[i] := globalAlloc (GMEM_MOVEABLE or GMEM_SHARE, tamBuf);
            pBuf[i] := globalLock (hbuf[i]);
            hhdr[i] := globalAlloc (GMEM_MOVEABLE or GMEM_SHARE, sizeof (TWaveHdr));
            lpWaveInHdr [i] := globalLock (hhdr[i]);
            prepareBuffer (i);
        end;
    exit;

erroDisco:
    waveInClose (hWavIn);
    {$I-} close (arqGravador);  {$I+}
    if ioresult <> 0 then;
    preparaGravacao := -1;
end;

{-------------------------------------------------------------}
{          monitora e alimenta o sistema de gravacao
{-------------------------------------------------------------}

function monitoraGravacao: boolean;
begin
    monitoraGravacao := true;

    while (lpWaveInHdr [pin] <> NIL) and
          ((lpWaveInHdr [pin]^.dwFlags and WHDR_DONE) <> 0) do
        begin
            with lpWaveInHdr [pin]^ do
                begin
                    {$I-}  blockWrite (arqGravador, lpdata^, dwBytesRecorded);  {$I+}
                    if ioresult <> 0 then
                       begin
                           waveInStop (hWavIn);
                           waveInReset (hWavIn);
                           listening := false;
                           monitoraGravacao := false;
                       end
                    else
                        tamGravado := tamGravado + integer(dwBytesRecorded);

                    waveInUnPrepareHeader(hWavIn, lpWaveInHdr [pin], sizeof (TWaveHdr));

                    if listening then
                        prepareBuffer (pin)
                    else
                        begin
                            globalUnlock (hbuf[pin]);  globalFree (hbuf[pin]);
                            globalUnlock (hhdr[pin]);  globalFree (hhdr[pin]);
                            lpWaveInHdr [pin] := NIL;
                        end;

                end;

            pin := (pin + 1) mod nbuf;
        end;
end;

{-------------------------------------------------------------}
{                     inicia a gravacao
{-------------------------------------------------------------}

procedure iniciaGravacao;
begin
    pin := 0;
    listening := true;
    waveInStart (hWavIn);
end;

{-------------------------------------------------------------}
{             gera um cabecalho de arquivo .WAV
{-------------------------------------------------------------}

procedure genWavHdr (pvet: pchar; veloc: longint; bits, channels: word; size: longint);
const
    wavHdr: array [0..43] of byte = (
        $52, $49, $46, $46,    {'RIFF'}
        $ff, $ff, $ff, $ff,    {riff size}
        $57, $41, $56, $45, $66, $6d, $74, $20,    {'WAVEFMT '}
        $10, $00, $00, $00,    {hdr size}
        $01, $00, $01, $00, $11, $2b, $00, $00, $11, $2b, $00, $00, $01, $00, $08, $00,  {reg}
        $64, $61, $74, $61,    {'data'}
        $ff, $ff, $ff, $ff);   {data size}

var l: longint;
    p: pointer;
    lpFormat: PPCMWAVEFORMAT;

begin
    new (lpFormat);
    with lpFormat^, lpFormat^.wf do
        begin
            wFormatTag := WAVE_FORMAT_PCM;
            nSamplesPerSec := veloc;
            wBitsPerSample := bits;
            nChannels := channels;
            nBlockAlign := (wBitsPerSample div 8) * nChannels;
            nAvgBytesPerSec := nBlockAlign * nSamplesPerSec;
        end;

    p := @wavHdr[20];
    move (lpFormat^, p^, sizeof (lpFormat^));
    l := size + 36;
    p := @wavHdr[4];
    move (l, p^, sizeof (l));
    p := @wavHdr[40];
    move (size, p^, sizeof (size));

    move (wavHdr, pvet^, sizeof (wavHdr));
    dispose (lpFormat);
end;

{-------------------------------------------------------------}
{                     termina a gravacao
{-------------------------------------------------------------}

function terminaGravacao: boolean;
var
    i: integer;
    erroGrav: boolean;
    salva: integer;
label erro;
begin
    erroGrav := false;
    terminaGravacao := true;

    for i := 1 to nBuf do
        if not monitoraGravacao then
            erroGrav := true;

    waveInStop (hWavIn);
    waveInReset (hWavIn);
    listening := false;

    while lpWaveInHdr [pin] <> NIL do
        if not monitoraGravacao then
                erroGrav := true;

    waveInClose (hWavIn);
    sndPlaySound (NIL, snd_sync);

    close (arqGravador);

    salva := FileMode;
    FileMode := fmOpenReadWrite;          { abre para reescrita }
    {$I-} reset (arqGravador, 1);  {$I+}
    FileMode := salva;

    if ioresult <> 0 then goto erro;

    genWavHdr (@Hdr, velocGrav, bitsGrav, canaisGrav, tamGravado);
    {$I-} blockWrite (arqGravador, Hdr, 44);  {$I+}
    if ioresult <> 0 then goto erro;

    {$I-} close (arqGravador);  {$I+}
    if ioresult <> 0 then goto erro;

    if erroGrav then goto erro;
    exit;

erro:
    {$I-} close (arqGravador);  {$I+}
    if ioresult <> 0 then;
    terminaGravacao := false;
end;

end.

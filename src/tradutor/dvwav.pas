{--------------------------------------------------------}
{
{     Rotinas de fala em baixo nível
{
{     Autor: José Antonio Borges
{
{     Em 20/7/2000
{
{--------------------------------------------------------}

unit dvwav;
interface
uses
    Classes, Windows, SysUtils, dvcrt, mmsystem, dialogs;

function  waveGetDeviceName  (devId: Cardinal): string;
procedure waveGetDeviceNames (var names: TStringList);
function  waveGetCurrentDeviceId: longword;
function  waveGetDeviceId (devName: string; out devId: Cardinal): boolean;
function  waveSetDevice (devId: Cardinal): boolean;

function waveIsPlaying: boolean;
function wavePlay (pSound: pchar; soundSize: longint;
                      veloc: longint; bits, channels: word): integer;
function wavePlayMem (pSound: pchar): integer;
function wavePlayFile (filename: string): integer;
procedure waveStop;
function wavefileParse (filename: string; PPcmFormat: PPCMWAVEFORMAT;
                        var soundSize, hdrsize: integer): boolean;

var
    keyStopsWave: boolean;
    queueingWaves: boolean;
    speedupWaves: boolean;
    compactWaves: boolean;
    maxBufWaves: integer;

implementation

type
    VETBYTE = packed array [0..65535] of byte;
    PVETBYTE = ^VETBYTE;

const
    SOUND_OK = 0;

    MAXBUFFERS = 16;
    MAXBUFSIZE = 8192;

var
    hWavOut: HWaveOut;

    uWaveOutDeviceId: word;
    lWaveOutveloc: longint;
    nWaveOutBits, nWaveOutChannels: integer;

    hbuf: array [1..MAXBUFFERS] of THandle;
    hhdr: array [1..MAXBUFFERS] of THandle;
    nextWavBuf: integer;

    nbufWaiting: integer;
    soundBuffer: pchar;

    waveCurrentDeviceId: Cardinal;
    dosvoxIniFileName: string;

{--------------------------------------------------------}

function waveGetDeviceName (devId: Cardinal): string;
var
    waveOutDevCaps: WAVEOUTCAPS;
begin
    result := '';
    if (devId = WAVE_MAPPER) or (devId < waveOutGetNumDevs) then
    begin
        waveOutGetDevCaps(devId, @waveOutDevCaps, SizeOf (waveOutDevCaps));
        result := strPas (waveOutDevCaps.szPname);
    end;
end;

{--------------------------------------------------------}

procedure waveGetDeviceNames (var names: TStringList);
var
    waveOutDevCaps: WAVEOUTCAPS;
    n: integer;
begin
    names.Clear();
    for n := 0 to waveOutGetNumDevs-1 do
    begin
        waveOutGetDevCaps(n, @waveOutDevCaps, SizeOf (waveOutDevCaps));
        names.Add (trim (strPas (waveOutDevCaps.szPname)));
    end;
end;

{--------------------------------------------------------}

function  waveGetCurrentDeviceId: longword;
begin
    result := waveCurrentDeviceId;
end;

{--------------------------------------------------------}

function waveGetDeviceId (devName: string; out devId: Cardinal): boolean;
var
    n: integer;
    devNames: TStringList;
begin
    result := False;

    devNames := TStringList.Create;
    waveGetDeviceNames(devNames);

    for n := 0 to devNames.Count-1 do
    begin
        if UpperCase (devNames[n]) = Uppercase(devName) then
        begin
            devId  := n;
            result := True;
            exit;
        end;
    end;
    devNames.Destroy;
end;

{--------------------------------------------------------}

function waveSetDevice (devId: Cardinal): boolean;
var
    deviceName: string;
begin
    result := true;
    if (devId = WAVE_MAPPER) or (devId < waveOutGetNumDevs) then
    begin
        waveCurrentDeviceId := devId;
        deviceName := waveGetDeviceName (devId);
        writePrivateProfileString ('TRADUTOR', 'SAIDADEAUDIO', pchar(deviceName),
                                    pchar(dosvoxInifilename));
    end
    else
        result := false;
end;

{--------------------------------------------------------}

function waveCompact (pmem: PVETBYTE; size, bits, veloc: word): integer;
var
    i: integer;
    origem, destino, posmax, tam: integer;
    maximo: byte;
    d1, d2, d3: integer;

begin
    if bits = 16 then    // passa para 8
        begin
            size := size div 2;
            for i := 0 to size-1 do
                pmem^[i] := pmem^[i shl 1 + 1] xor $80;
    end;

    waveCompact := size;
    if size < 1000 then exit;

    maximo := 0;                          { acha primeiro ponto de maximo }
    posmax := 0;

    d1 := 200;
    d2 := 80;
    d3 := 50;
    if veloc <> 11025 then
        begin
            d1 := d1 * 4;
            d2 := d2 * 4;
            d3 := d3 * 4;
        end;

    for i := d1 to d1+d2+d3 do
        if pmem^[i] > maximo then
            begin
                maximo := pmem^[i];
                posmax := i;
            end;

    origem := posmax;                     { ali comecara a compactacao }
    destino := origem;
    while origem < size - 2*(d2+d3) do
        begin
             maximo := 0;              { acha proximo ponto de maximo }
             origem := origem + d2;
             for i := origem to origem + d3 do
                if pmem^[i] > maximo then
                    begin
                        maximo := pmem^[i];
                        posmax := i;
                    end;

             origem := posmax;             { ali comecara a compactacao }
             maximo := 0;
             for i := origem+d2 to origem+d2+d3 do
                if pmem^[i] > maximo then
                    begin
                        maximo := pmem^[i];
                        posmax := i;
                    end;

             tam := posmax-origem+1;
             move (pmem^[origem], pmem^[destino], tam);
             origem := posmax;
             destino := destino + tam;
        end;

    while (abs (pmem^[destino] - 128) > 20) and (origem < size) do
        begin
            pmem^[destino] := pmem^[origem];
            destino := destino + 1;
            origem := origem + 1;
        end;

    waveCompact := destino;
end;

{-------------------------------------------------------------}

procedure handleWaveOutMsg (Window: HWnd; WParam: WPARAM; LParam: LPARAM);  far;
var
    lpWaveOutHdr: PWaveHdr;
    b: dword;
    status: dword;
begin
    lpWaveOutHdr := PWaveHdr (LParam);

    if lpWaveOutHdr <> NIL then
        with lpWaveOutHdr^ do
            begin
                b := dwUser;
                status := waveOutUnPrepareHeader(hWavOut, lpWaveOutHdr, sizeof (TWaveHdr));
                if status <> MMSYSERR_NOERROR then
                    begin
                        case status of
                            MMSYSERR_INVALHANDLE:  write ('Specified device handle is invalid.');
                            MMSYSERR_NODRIVER:     write ('No device driver is present.');
                            MMSYSERR_NOMEM:        write ('Unable to allocate or lock memory.');
                            WAVERR_STILLPLAYING:   write ('The data block pointed to by the pwh parameter is still in queue');
                        end;
                        readln;
                    end;
                globalUnlock (hhdr[b]);
                globalUnlock (hbuf[b]);
                if nbufWaiting > 0 then
                    nbufWaiting := nbufWaiting - 1;
           end;
end;

{-------------------------------------------------------------}

function openWaveOutDevice : word;
var
    lpFormat: PPcmWaveFormat;
    dwCallback, dwInstance, dwFlags: longint;
    status: word;
begin
    if hWavOut <> 0 then    { continuação da operação anterior }
        begin
            openWaveOutDevice := 0;
            exit;
        end;

    new (lpFormat);
    with lpFormat^, lpFormat^.wf do
        begin
            wFormatTag := WAVE_FORMAT_PCM;
            nSamplesPerSec := lWaveOutVeloc;
            wBitsPerSample := nWaveOutBits;
            nChannels := nWaveOutChannels;
            nBlockAlign := (wBitsPerSample div 8) * nChannels;
            nAvgBytesPerSec := nBlockAlign * nSamplesPerSec;
        end;

    dwCallBack := crtWindow;
    dwInstance := 0;
    dwFlags := CALLBACK_WINDOW or WAVE_ALLOWSYNC;

    mmCallback := handleWaveOutMsg;
    hasmmCallback := true;

    status := waveOutOpen(@hWavOut, waveCurrentDeviceId, @lpFormat^,
                          dwCallback, dwInstance, dwFlags);

    openWaveOutDevice := status;    {zero significa ok}

    dispose (lpformat);
end;

{-------------------------------------------------------------}

function queueWaveOutBuffer (p: pchar; size: integer): boolean;
var b, i: integer;
    lpWaveOutHdr: PWaveHdr;
    pBuf: pChar;
    newSize: longint;

begin
    queueWaveOutBuffer := false;

    i := 0;
    while (nbufWaiting >= maxBufWaves) and (i < 40) do    {evita um bloqueio perpétuo}
        begin
           processWindowsQueue;
           i := i + 1;  delay (50);
        end;
    if nbufWaiting >= maxBufWaves then exit;

    nbufWaiting := nbufWaiting + 1;

    nextWavBuf := nextWavBuf + 1;
    if nextWavBuf > maxBufWaves then nextWavBuf := 1;
    b := nextWavBuf;

    if size < 256 then
        newsize := 256
    else
        newsize := size;
    pBuf := globalLock (hbuf[b]);

    if (nWaveOutChannels = 1) and (nWaveOutBits = 8) and (size < 256) then
        fillchar (pBuf[size], 256-size, $80);
    move (p^, pBuf^, size);
    if (nWaveOutChannels = 1) and (nWaveOutBits = 8) and (size <> MAXBUFSIZE) then
        pbuf[size-1] := #$80;

    lpWaveOutHdr := globalLock (hhdr[b]);

    fillChar (lpWaveOutHdr^, sizeof (TWaveHdr), 0);
    with lpWaveOutHdr^ do
        begin
            lpData := pBuf;
            dwBufferLength := newSize;
            dwUser := b;             { used to unlock the data }
        end;

    if waveOutPrepareHeader(hWavOut, lpWaveOutHdr, sizeof (TWaveHdr)) <> 0 then
        exit;

    waveOutWrite (hWavOut, lpWaveOutHdr, sizeof (TWaveHdr));
    queueWaveOutBuffer := true;
end;

{-------------------------------------------------------------}

function waveIsPlaying: boolean;
begin
    processWindowsQueue;
    if (keyStopsWave and keypressed) or (nbufWaiting = 0) then
        waveStop;

    waveIsPlaying := nbufWaiting <> 0;
end;

{-------------------------------------------------------------}

procedure waveStop;
begin
    if hWavOut <> 0 then
        begin
            if nbufWaiting <> 0 then
                waveOutReset (hWavOut);

            processWindowsQueue;   { ativa loop da dvcrt }
        end;
end;

{-------------------------------------------------------------}

function setWaveOutParams (veloc: longint; bits, channels: integer): word;
begin
    if (lWaveOutVeloc <> veloc) or
       (nWaveOutBits <> bits) or
       (nWaveOutChannels <> channels) then
        begin
            repeat until not waveIsPlaying;
            if hWavOut <> 0 then
                begin
                    waveOutClose(hWavOut);
                    hWavOut := 0;
                end;
        end;

    uWaveOutDeviceId := 0;
    lWaveOutVeloc := veloc;
    nWaveOutBits := bits;
    nWaveOutChannels := channels;

    setWaveOutParams := openWaveOutDevice;
end;

{-------------------------------------------------------------}

function wavePlay (pSound: pchar; soundSize: longint;
                      veloc: longint; bits, channels: word): integer;
var

    status: integer;
    size, newSize: integer;

label interrompeu;
begin
    wavePlay := 0;

    if speedupWaves then
        veloc := trunc(veloc * 1.5);

    if compactWaves and (channels = 1) and (bits = 16)then
        status := setWaveOutParams (veloc, 8, channels)
    else
        status := setWaveOutParams (veloc, bits, channels);

    if status <> 0 then
        begin
            wavePlay := status;  {não conseguiu abrir canal}
            exit;
        end;

    while soundSize > 0 do
        begin
            while nbufWaiting >= maxBufWaves do
                begin
                    if keypressed and keyStopsWave then
                        goto interrompeu;
                    delay (10);
                end;

            if keyStopsWave and keypressed then
                goto interrompeu;

            if soundSize < MAXBUFSIZE then
                size := soundSize
            else
                size := MAXBUFSIZE;

            if compactWaves and (channels = 1) then
                newsize := waveCompact (addr (pSound^), size, bits, veloc)
            else
                newsize := size;

            queueWaveOutBuffer (pSound, newsize);

            pSound := pSound + size;
            soundSize := soundSize - size;
        end;
    exit;

interrompeu:
    waveStop;
end;

{-------------------------------------------------------------}

function waveGetFormat (psound: pchar;
          var soundSize: longint;
          var lpFormat: PPCMWAVEFORMAT;
          var pdata: pchar;
          var dataSize: integer): boolean;
var
    savep: pchar;
    size: longint;
    dataFound: boolean;

begin
    waveGetFormat := false;

    savep := psound;
    if strlicomp (psound, pchar('RIFF'), 4) <> 0 then exit;
    psound := psound + 12;
    if strlicomp (psound, 'fmt ', 4) <> 0 then exit;
    move (psound[4], size, 4);
    psound := psound + 8;

    lpFormat := @psound[0];
    psound := psound + size;

    repeat
        dataFound := strlicomp (psound, 'data', 4) = 0;
        move (psound[4], size, 4);
        psound := psound + 8;
        if not dataFound then
            psound := psound + size;
    until dataFound;

    pdata := psound;
    dataSize := size;
    soundSize := integer (pdata - savep) + dataSize;

    waveGetFormat := true;
end;

{-------------------------------------------------------------}

function wavePlayMem (pSound: pchar): integer;
var
    soundSize: longint;
    lpFormat: PPCMWAVEFORMAT;
    pdata: pchar;
    dataSize: integer;

begin
    waveGetFormat (pSound, soundSize, lpFormat, pdata, dataSize);

    wavePlayMem := wavePlay (pdata, dataSize,
                      lpFormat^.wf.nSamplesPerSec, lpFormat^.wBitsPerSample,
                      lpFormat^.wf.nChannels);
end;

{-------------------------------------------------------------}

function wavePlayFile (filename: string): integer;
var
    veloc: longint;
    bits, channels: word;
    status: integer;
    soundSize: longint;
    size: longint;
    transf: integer;
    lpFormat: PPCMWAVEFORMAT;
    f: integer;
    achou: boolean;
    dirRapido, arqRapido: string;
label fim;
begin
    status := -1;
    if keyStopsWave and keypressed then
        begin
            waveStop;
            wavePlayFile := 0;
            exit;
        end;

    wavePlayFile := -1;

    if compactWaves then
         begin
             dirRapido := ExtractFilePath(filename) + 'rapido\';
             arqRapido := ExtractFileName(filename);
             if FileExists(dirRapido + arqRapido) then
                 begin
                     compactWaves := false;
                     result := wavePlayFile (dirRapido + arqRapido);
                     compactWaves := true;
                     exit;
                 end;
         end;

    f := FileOpen(fileName, fmOpenRead or fmShareDenyNone);
    if f < 0 then exit;

    transf := fileRead (f, soundBuffer^, 12);     { checa cabeçalho RIFF }
    if transf < 12 then goto fim;
    if strlicomp (soundBuffer, pchar('RIFF'), 4) <> 0 then goto fim;

    transf := fileRead (f, soundBuffer^, 8);      { checa fmt }
    if transf < 8 then goto fim;
    if strlicomp (soundBuffer, 'fmt ', 4) <> 0 then goto fim;

    move (soundBuffer[4], size, 4);
    transf := fileRead (f, soundBuffer^, size);   { checa fmt }
    if size <> transf then goto fim;

    lpFormat := @soundBuffer[0];
    with lpFormat^, lpFormat^.wf do
        begin
            veloc := nSamplesPerSec;
            bits := wBitsPerSample;
            channels := nChannels;
        end;

    repeat
        transf := fileRead (f, soundBuffer^, 8);     { ignora chunks até data }
        if transf < 8 then goto fim;
        achou := strlicomp (soundBuffer, 'data', 4) = 0;
        move (soundBuffer[4], size, 4);
        if not achou then
            begin
               transf := fileRead (f, soundBuffer^, size);     { checa fmt }
               if size <> transf then goto fim;
            end;
    until achou;

    soundSize := size;

    status := 0;
    while soundSize > 0 do
        begin
            status := -1;

            if (soundSize > MAXBUFSIZE) and (soundSize < (MAXBUFSIZE+256)) then
                size := MAXBUFSIZE - 256   {garante pelo menos 256 bytes}
            else
            if (size >= soundSize) and (size <= MAXBUFSIZE) then
                size := soundSize
            else
                size := MAXBUFSIZE;
            soundSize := soundSize - size;

            transf := fileRead (f, soundBuffer^, size);
            if transf = 0 then break;
            status := wavePlay (soundBuffer, transf, veloc, bits, channels);
            if status <> 0 then break;

            if keyStopsWave and keypressed then break;
        end;

fim:
    fileClose (f);
    wavePlayFile := status;

    if not queueingWaves then        { para melhorar performance pode-se não esperar }
        while waveIsPlaying do       { essa rotina faz o stop }
            waitMessage;             { nada faz, só espera uma mensagem }
end;

{--------------------------------------------------------}

function wavefileParse (filename: string; PPcmFormat: PPCMWAVEFORMAT;
                        var soundSize, hdrsize: integer): boolean;
var
    f: integer;
    ioOk: boolean;
    size, transf: integer;
    achou: boolean;
    soundBuffer: pchar;

label fim;
begin
    result := false;
    soundSize := 0;
    hdrSize := 0;

    f := FileOpen(fileName, fmOpenRead or fmShareDenyNone);
    if f < 0 then exit;

    ioOk := false;

    getMem (soundBuffer, MAXBUFSIZE);

    transf := fileRead (f, soundBuffer^, 12);     { checa cabeçalho RIFF }
    if transf < 12 then goto fim;
    if strlicomp (soundBuffer, pchar('RIFF'), 4) <> 0 then goto fim;

    transf := fileRead (f, soundBuffer^, 8);      { checa fmt }
    if transf < 8 then goto fim;
    if strlicomp (soundBuffer, 'fmt ', 4) <> 0 then goto fim;

    move (soundBuffer[4], size, 4);
    transf := fileRead (f, soundBuffer^, size);   { checa fmt }
    if size <> transf then goto fim;

    move (soundBuffer[0], PPcmFormat^, sizeof (TPCMWAVEFORMAT));

    if PPcmFormat^.wf.wFormatTag <> WAVE_FORMAT_PCM then
        goto fim;    // só processo PCM

    repeat
        transf := fileRead (f, soundBuffer^, 8);     { ignora chunks até data }
        if transf < 8 then goto fim;
        achou := strlicomp (soundBuffer, 'data', 4) = 0;
        move (soundBuffer[4], size, 4);
        if not achou then
            begin
               transf := fileRead (f, soundBuffer^, size);     { checa fmt }
               if size <> transf then goto fim;
            end;
    until achou;

    soundSize := size;
    hdrSize := fileSeek (f, 0, 1);
    ioOk := true;

fim:
    freeMem (soundBuffer, MAXBUFSIZE);
    fileClose (f);
    result := ioOk;
end;

{--------------------------------------------------------}

{$WARNINGS OFF}
var
    b: integer;
    resp: array [0..80] of char;

initialization

begin
    keyStopsWave := true;
    queueingWaves := false;
    speedupWaves := false;
    compactWaves := false;
    maxBufWaves := MAXBUFFERS;

    nextWavBuf := 0;
    hWavOut := 0;
    nbufWaiting := 0;

    getmem (soundBuffer, MAXBUFSIZE);
    for b := 1 to MAXBUFFERS do
        begin
            hbuf[b] := globalAlloc (GMEM_MOVEABLE or GMEM_SHARE, MAXBUFSIZE);
            hhdr[b] := globalAlloc (GMEM_MOVEABLE or GMEM_SHARE, sizeof (TWaveHdr));
        end;

    waveCurrentDeviceId := WAVE_MAPPER;

    b := GetPrivateProfileString('TRADUTOR', 'SAIDADEAUDIO', '', resp, 80,
                                    pchar(dosvoxIniFileName));
    if (b <> 0) and (resp <> '') then
        waveGetDeviceId (resp, waveCurrentDeviceId);
end;

finalization
    if hWavOut <> 0 then
         waveOutClose (hWavOut);
(*
    for b := 1 to MAXBUFFERS do
        begin
            globalFree (hbuf[b]);
            globalFree (hhdr[b]);
        end;
*)
end.


unit uttsLiane;

interface
uses

    uttsPortug, uttsPreproc, uttsProsodia, mbrola, minireg, dvwav,
    windows, classes, sysutils, mmsystem;

function liane_open (mbrola_db,
    arq_regras, arq_excessoes, arq_abrev, arq_prosodia, arq_listadif: string): boolean;
procedure liane_setOutputFile (filename: string);
procedure liane_config (duration, pitch: real);
procedure liane_close;

function liane_speak (s: string): boolean;
procedure liane_stop;
function liane_isSpeaking: boolean;
procedure liane_wait;

var
    liane_pitchRate: real;
    liane_durationRate: real;

implementation

const
    BSIZE = 16000;

var output_filename: string;
    lastError: array [0..255] of char;
    liane_file: file;
    writingToFile: boolean;
    inBuffer: array [0..BSIZE*2-1] of byte;
    outBuffer: array [-44..BSIZE*2-1] of byte;

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

{--------------------------------------------------------}
{                abre os bancos de dados                 }
{--------------------------------------------------------}

function liane_open (mbrola_db,
    arq_regras, arq_excessoes, arq_abrev, arq_prosodia, arq_listadif: string): boolean;
var
    p: pointer;

begin
    liane_open := false;
    if not load_MBR then exit;

    if mbrola_db = '' then mbrola_db := 'br4';

    if arq_regras    = '' then arq_regras    := 'portug.nrl';
    if arq_excessoes = '' then arq_excessoes := 'portug.exc';
    if arq_abrev     = '' then arq_abrev     := 'portug.abr';
    if arq_prosodia  = '' then arq_prosodia  := 'portug.pro';
    if arq_listadif  = '' then arq_listadif  := 'portug.dfn';

    RegGetString(HKEY_LOCAL_MACHINE, 'SOFTWARE\TCTS\Mbrola\databases\'+ mbrola_db+'\', mbrola_db);
    if mbrola_db = '' then mbrola_db := 'c:\winvox\lianetts\br4';

    if init_MBR (@mbrola_db[1]) < 0 then
	begin
            unload_MBR;
            exit;
	end;

    setNoError_MBR (1);

    fimTradutor;
    fimProsodia;
    if not inicTradutor (arq_regras, arq_excessoes) then
        lastError := 'Erro na base de dados de português'
    else
    if not inicAbrev(arq_abrev) then
        lastError := 'Erro no arquivo de abreviaturas'
    else
    if not inicProsodia(arq_prosodia) then
        lastError := 'Erro no arquivo de prosódia'
    else
    if not inicListaDifones (arq_listadif) then
        lastError := 'Erro no arquivo de prosódia'
    else
        begin
            if output_filename <> '' then
                begin
                    assignFile (liane_file, output_filename);
                    {$I-} rewrite (liane_file, 1);  {$I-}
                    if ioresult = 0 then
                        begin
                            genWavHdr (@outBuffer, 16000, 16, 1, 0);
                            p := @outBuffer;
                            {$I-} blockwrite (liane_file, p^, 44); {$I+}
                            if ioresult <> 0 then
                                begin
                                    lastError := 'Arquivo de saída não pode ser criado';
                                    closeFile (liane_file);
                                    exit;
                                end;

                            liane_open := true;
                            writingToFile := true;
                        end;
                end
            else
                begin
                    writingToFile := false;
                    liane_open := true;
                end;
        end;
end;

{--------------------------------------------------------}
{                    configura saida                     }
{--------------------------------------------------------}

procedure liane_setOutputFile (filename: string);
begin
    output_filename := filename;
end;

{--------------------------------------------------------}
{                    configura a fala                    }
{--------------------------------------------------------}

procedure liane_config (duration, pitch: real);
begin
   liane_pitchRate := pitch;
   liane_durationRate := duration;
end;

{--------------------------------------------------------}
{                fecha os bancos de dados                }
{--------------------------------------------------------}

procedure liane_close;
var
    salvaFileMode: byte;
    tam: integer;
    
begin
    if writingToFile then
        begin
            CloseFile (liane_file);
            salvaFilemode := filemode;

            FileMode := 2;
            reset (liane_file, 1);
            tam := filesize (liane_file) - 44;
            genWavHdr (@outBuffer, 16000, 16, 1, tam);
            blockWrite (liane_file, outBuffer, 44);
            closeFile (liane_file);

            FileMode := salvaFileMode;
        end;

    fimTradutor;
    fimProsodia;

    close_MBR;
    unload_MBR;
end;

{--------------------------------------------------------}
{               debug dos comandos gerados               }
{--------------------------------------------------------}

procedure debug_mbrola (mbrola_cmd: TStringList);
var debug: textFile;
    i: integer;
begin
    assignFile (debug, '\mb_debug.txt');
    if FileExists('\mb_debug.txt') then
        append (debug)
    else
        rewrite (debug);
    for i := 0 to mbrola_cmd.count-1 do
        writeln (debug, mbrola_cmd[i]);
    writeln (debug, ';---------------------------------------');
    closeFile (debug);
end;

{--------------------------------------------------------}
{                      sintetiza fala                    }
{--------------------------------------------------------}

function liane_speak (s: string): boolean;
var
    i, n: integer;
    fonemas, palavrasComCodigos, palavrasComProsodia, mbrolaCmd: TStringList;
    p: pointer;
    isai: integer;
    dif: string;
    svspeedupWaves, svcompactWaves: boolean;

begin
    liane_speak := true;
    if trim (s) = '' then exit;

    s := preProcessa(s);
    palavrasComCodigos := preProsodia(s);

    palavrasComProsodia := calculaCurvaProsodia (palavrasComCodigos, true);
    palavrasComCodigos.free;

    compilaFonemas (palavrasComProsodia, fonemas);
    palavrasComProsodia.free;

    aplicaProsodia (fonemas, mbrolaCmd, liane_durationRate, liane_pitchRate);
    fonemas.free;

    svspeedupWaves := speedupWaves;
    svcompactWaves := compactWaves;
    speedupWaves := false;
    compactWaves := false;

//    debug_mbrola (mbrolaCmd);

    reset_MBR;
    isai := 0;
    for i := 0 to mbrolaCmd.count-1 do
        begin
            dif := mbrolaCmd[i];
            if (dif = '') and (i <> mbrolaCmd.count-1) then
                continue;

            dif := dif + #$0d#$0a;
            write_MBR (@dif[1]);
            if lastError_MBR <> 0 then
                begin
                    reset_MBR;
                    liane_speak := false;
                end;

            if i = mbrolaCmd.count-1 then
                flush_MBR;

            n := 0;
            try
                n := read_MBR (@inBuffer[0], BSIZE) * 2;
            except
                if lastError_MBR <> 0 then
                    begin
                        reset_MBR;
                        liane_speak := false;
                    end;
            end;
            while n > 0 do
                begin
                    if writingToFile then
                        begin
                            p := @inBuffer[0];
                            {$I-} blockwrite (liane_file, p^, n); {$I+}
                            if ioresult <> 0 then
                                liane_speak := false;
                        end
                    else
                        begin
                            if isai+n >= BSIZE then
                                begin
                                    genWavHdr (@outBuffer[-44], 16000, 16, 1, isai);
                                    wavePlayMem(@outBuffer[-44]);
                                    isai := 0;
                                end;
                            move (inBuffer, outBuffer[isai], n);
                            isai := isai + n;
                        end;

                    n := read_MBR (@outBuffer[0], BSIZE) * 2;
                end;
        end;

    if not writingToFile then
        begin
            if isai > 0 then
                begin
                    if isai < 256 then
                        begin
                            fillchar (outBuffer[isai], 0, 256-isai);
                            isai := 256;   // evita clicks em algumas placas de som
                        end;
                    genWavHdr (@outBuffer[-44], 16000, 16, 1, isai);
                    wavePlayMem(@outBuffer[-44]);
                end;
        end;

    mbrolaCmd.free;

    speedupWaves := svspeedupWaves;
    compactWaves := svcompactWaves;
end;

{--------------------------------------------------------}
{                      para de falar                     }
{--------------------------------------------------------}

procedure liane_stop;
begin
    if not writingToFile then
        waveStop;
end;

{--------------------------------------------------------}
{                vê se ainda está falando                }
{--------------------------------------------------------}

function liane_isSpeaking: boolean;
begin
    if writingToFile then
        liane_isSpeaking := false
    else
        liane_isSpeaking := waveIsPlaying;
end;

{--------------------------------------------------------}
{                espera terminar de falar                }
{--------------------------------------------------------}

procedure liane_wait;
begin
    if not writingToFile then
       while liane_isSpeaking do waitMessage;
end;

begin
    output_filename := '';
    writingToFile := false;
    liane_pitchRate := 1.0;
    liane_durationRate := 1.0;
end.

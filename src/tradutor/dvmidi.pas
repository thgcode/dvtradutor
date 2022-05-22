{--------------------------------------------------------}
{
{      Interface simplificada para a execução midi
{
{      Autor: José Antonio Borges
{
{      Em agosto/2010
{
{--------------------------------------------------------}

unit dvmidi;

interface
uses windows, sysutils, classes, mmsystem;

function quantasInterfacesMidi: integer;
function pegaNomeMidi (numDispositivo: integer): string;
procedure abreMidi (numDispositivo: integer);
procedure fechaMidi;

procedure selCanal (n: integer);  // entre 1 e 16
procedure selInstrumento (n: integer);  // GM

procedure tocaNota (escala, n, dur: integer);
procedure iniciaNota (escala, n: integer);
procedure paraNota (escala, n: integer);
procedure volumeNota (n: integer);  // entre 0 e 127

implementation

var
    midiOut: HMidiOut;
    volNota: integer;  // de 0 a 255
    canal: integer;   // de 1 a 16

function quantasInterfacesMidi: integer;
begin
    result := midiOutGetNumDevs;
end;

function pegaNomeMidi (numDispositivo: integer): string;
var
    midiOutCapabilities: MIDIOUTCAPS;
begin
    midiOutGetDevCaps(numDispositivo, @midiOutCapabilities, sizeof(midiOutCapabilities));
    result := strPas(midiOutCapabilities.szPname);
end;

procedure abreMidi (numDispositivo: integer);
begin
    midiOutOpen(@MidiOut, numDispositivo, 0, 0, 0);
    volNota := 100;
    selInstrumento (0);
    canal := 1;
end;

procedure fechaMidi;
begin
    midiOutClose (midiOut);
end;

procedure selCanal (n: integer);  // de 1 a 16
begin
     canal := n;
end;

procedure selInstrumento (n: integer);  // GM
var
    midiMsg: longint;
begin
    midiMsg := $C0 + (canal-1) + (n shl 8);
    midiOutShortMsg (MidiOut, midiMsg);
end;

procedure iniciaNota (escala, n: integer);
var
    midiMsg: longint;
begin
    if (escala <= -1) or (escala >= 7) then n := -1;
    n := n + (1+escala)*12;
    midiMsg := $90 + (canal-1) + (n shl 8) + (volNota shl 16);
    midiOutShortMsg (MidiOut, midiMsg);
end;

procedure paraNota (escala, n: integer);
var
    midiMsg: longint;
begin
    if (escala <= -1) or (escala >= 7) then n := -1;
    n := n + (1+escala)*12;
    midiMsg := $80 + (canal-1) + (n shl 8) + (volNota shl 16);
    midiOutShortMsg (MidiOut, midiMsg);
end;

procedure tocaNota (escala, n, dur: integer);
begin
    iniciaNota (escala, n);
    sleep (dur);
    paraNota (escala, n);
end;

procedure volumeNota (n: integer);
begin
    volNota := n;
end;

end.

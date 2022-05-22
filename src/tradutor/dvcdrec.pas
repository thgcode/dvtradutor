{--------------------------------------------------------}
{
{     Rotinas de Gravação de CD usando IMAP2
{
{     Autor:  José Antonio Borges
{
{     Em 11/06/2011
{
{--------------------------------------------------------}

Unit dvCdRec;
interface
uses
    Windows, Messages, SysUtils, OleServer, IMAPI2_TLB, IMAPI2FS_TLB, ComCtrls,
    ShellApi, Classes,
    dvcrt, dvwin;

function pegaUnidsCD: string;
function inicializaCD: boolean;
function listaDrivesCD: TStringList;
function geraDirCD (nomeDir: string): boolean;
function geraArqCD (nomeArq: string): boolean;
function criaImagemCD (nomeVolume: string; indGrav: integer): boolean;
function gravaCD: boolean;
procedure finalizaCD;


{ retornos
{  0 - ok
{  1 - não há gravadores instalados
{  2 - esta unidade não pode ser usada para gravação
{  3 - não há arquivos para gravar
{  4 - erro de gravação
}

implementation
var
    MsftDiscMaster: TMsftDiscMaster2;
    MsftDiscRecorder: TMsftDiscRecorder2;
    MsftFileSystemImage: TMsftFileSystemImage;
    MsftDiscFormat2Data: TMsftDiscFormat2Data;

var
    wstr:WideString;
    DiscRoot:IFsiDirectoryItem;
    resimage:IFileSystemImageResult;
    DiscStream,fstream:IMAPI2_TLB.IStream;
    DR:IDiscRecorder2;

Function SHCreateStreamOnFileEx(
    pszFile: PWChar;
    grfMode:DWORD;
    dwAttributes:DWORD;
    fCreate:BOOL;
    pstmTemplate:IStream;
    var ppstm:IStream): DWORD;stdcall;
          external 'shlwapi.dll' name 'SHCreateStreamOnFileEx';


function pegaUnidsCD: string;
var letras: array [0..255] of char;
    p: pchar;
    drives: string;
begin
    GetLogicalDriveStrings(255, letras);
    drives := '';
    p := letras;
    while (p^ <> #0) do
        begin
             if GetDriveType(p) = DRIVE_CDROM then
                 drives := drives + p^;
             while (p^ <> #0) do p := p + 1;
             p := p + 1;
        end;

    result := drives;
end;

function inicializaCD: boolean;
begin
    MsftDiscMaster := TMsftDiscMaster2.Create(NIL);
    if not MsftDiscMaster.IsSupportedEnvironment then
        begin
            result := false;
            exit;
        end;

    MsftDiscRecorder := TMsftDiscRecorder2.Create(NIL);
    MsftFileSystemImage := TMsftFileSystemImage.Create(NIL);
    DiscRoot:=(MsftFileSystemImage.Root) as IFsiDirectoryItem;
    result := true;
end;

function listaDrivesCD: TStringList;
var
    cdList: TStringList;
    unitName: string;
    i: integer;
begin
    cdList := TStringList.Create;
    result := cdList;

    for i := 0 to MsftDiscMaster.Count-1 do
        begin
            try
                MsftDiscRecorder.InitializeDiscRecorder(MsftDiscMaster.Item[0]);
                unitName := MsftDiscRecorder.VendorId+': '+MsftDiscRecorder.ProductId;
                cdList.add (intToStr(i) + ' - ' + unitName);
                MsftDiscRecorder.Disconnect;
            except
                unitName := '(read only) ' + unitName;
            end;
        end;
end;

function geraDirCD (nomeDir: string): boolean;
var
    sr: TSearchRec;
    dir: string;
begin
    getdir (0, dir);
    {$I-} chdir (nomeDir); {$I+}
    if ioresult <> 0 then
        begin
            result := false;
            exit;
        end;

    if findFirst ('*.*', faDirectory + faArchive, sr) = 0 then
        repeat
             if (sr.Name = '.') or (sr.Name = '..') then
                 continue;

            if (sr.Attr and faDirectory) <> 0 then
                 DiscRoot.AddTree(sr.Name, true)
            else
                if FileExists(sr.Name) then
                     begin
                         wstr := sr.Name;
                         SHCreateStreamOnFileEx(PWideChar(wstr),0,0,False,nil,IStream(fstream));
                         DiscRoot.AddFile(sr.Name, IMAPI2FS_TLB.IStream(fstream));
                     end;
        until findNext (sr) <> 0;

    chdir (dir);
    result := true;
end;

function geraArqCD (nomeArq: string): boolean;
// os arquivos devem ter nomes diferentes, e serão gravados na raiz
begin
    if FileExists(nomeArq) then
        begin
            wstr := nomeArq;
            SHCreateStreamOnFileEx(PWideChar(wstr),0,0,False,nil,IStream(fstream));
            DiscRoot.AddFile(extractFileName (nomeArq), IMAPI2FS_TLB.IStream(fstream));
        end;

    result := true;
end;

function criaImagemCD (nomeVolume: string; indGrav: integer): boolean;
begin
    result := true;
    try
        MsftDiscRecorder.InitializeDiscRecorder(MsftDiscMaster.Item[indGrav]);
    except
        result := false;   // esta unidade não pode ser usada para gravação
    end;

    MsftDiscFormat2Data := TMsftDiscFormat2Data.Create(NIL);
    MsftDiscFormat2Data.Recorder:=MsftDiscRecorder.DefaultInterface;
    MsftDiscFormat2Data.ClientName:='IMAPI';

    DR:=IDiscRecorder2(MsftDiscRecorder.DefaultInterface);
    MsftFileSystemImage.ChooseImageDefaults(DR);
    MsftFileSystemImage.VolumeName:= nomeVolume;

    resimage:=MsftFileSystemImage.CreateResultImage;
    DiscStream:=IMAPI2_TLB.IStream(resimage.ImageStream);
end;

function gravaCD: boolean;
begin
    result := true;
    try
        MsftDiscFormat2Data.Write(DiscStream);
        MsftDiscRecorder.EjectMedia;
    except
        result := false;   // 5 - erro de gravação
    end;

    MsftDiscRecorder.Disconnect;
end;

procedure finalizaCD;
begin
    if assigned (DiscRoot) then DiscRoot := NIL;
    if assigned (MsftFileSystemImage) then MsftFileSystemImage := NIL;
    if assigned (MsftDiscRecorder) then MsftDiscRecorder := NIL;
    if assigned (MsftDiscMaster) then MsftDiscMaster := NIL;
end;

end.


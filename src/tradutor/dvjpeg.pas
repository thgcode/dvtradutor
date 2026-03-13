{ Reescrita da unit dvjpeg para funcionar com Free Pascal }
{ Autor: Thiago Seus
{ Em 13/03/2026 }

unit dvjpeg;

interface
uses
  Classes, SysUtils, FPImage, FPReadJPEG, FPWriteBMP;

procedure CopyJpegToBmp(const FJpegFile, FBmpFile: string);

implementation

procedure CopyJpegToBmp(const FJpegFile, FBmpFile: string);
var
  Reader: TFPReaderJPEG;
  Writer: TFPWriterBMP;
  Img: TFPMemoryImage;
  FSIn, FSOut: TFileStream;
begin
  // Ensure output file does not exist
  if FileExists(FBmpFile) then
    DeleteFile(FBmpFile);

  FSIn := TFileStream.Create(FJpegFile, fmOpenRead or fmShareDenyWrite);
  FSOut := TFileStream.Create(FBmpFile, fmCreate);
  Reader := TFPReaderJPEG.Create;
  Writer := TFPWriterBMP.Create;
  Img := TFPMemoryImage.Create(0, 0);

  try
    // Load JPEG into memory image
    Img.LoadFromStream(FSIn, Reader);

    // Save as BMP
    Img.SaveToStream(FSOut, Writer);
  finally
    Img.Free;
    Reader.Free;
    Writer.Free;
    FSIn.Free;
    FSOut.Free;
  end;
end;

end.

unit dvjpeg;

interface
uses
  dvcrt,
  classes,
//  jpeg,
//  graphics,
  sysUtils;

procedure CopyJpegToBmp (FJpegFile, FBmpFile: string);

implementation

procedure CopyJpegToBmp (FJpegFile, FBmpFile: string);
{
var
    FStreamBmp, FStreamJpg  : TStream;
    FJpeg    : TJpegImage;
    FBmp     : TBitmap;
}
begin
{
  if FileExists(FBmpFile) then DeleteFile(FBmpFile);
  FStreamBmp := TFileStream.Create(FBmpFile,fmCreate);
  FStreamJpg := TFileStream.Create(FJpegFile, fmOpenRead);
  FJpeg := TJPEGImage.Create;
  FBmp := TBitmap.Create;

  try
    FJpeg.LoadFromStream(FStreamJpg);

    if FJpeg.PixelFormat = jf24bit then
      FBmp.PixelFormat := pf24bit
    else
      FBmp.PixelFormat := pf8bit;

    FBmp.Width := FJpeg.Width;
    FBmp.Height := FJpeg.Height;
    FBmp.Canvas.Draw(0,0,FJpeg);
    FBmp.SaveToStream(FStreamBmp);
  finally
    FStreamJpg.Free;
    FStreamBmp.Free;
    FJpeg.Free;
    FBmp.Free;
  end;
}
end;

end.

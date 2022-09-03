program webserver;

uses
  fphttpapp, httpdefs, httproute, wrapDvwin, dvWin;

begin
    sintInic(0, '');
  Application.Port := 8080;
    wrapDvwin.registra;
  Application.Initialize;
  Application.Run;
    sintFim;
end.

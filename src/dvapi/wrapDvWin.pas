unit wrapDvWin;
interface
procedure registra;
implementation
uses httpDefs, httpRoute, fpJson, jsonParser, dvWin;

procedure sintetizaEndpoint(req: TRequest; resp: TResponse);
    var o: tJsonObject;
    begin
    try
        o := getJson(req.content) as tJsonObject;
        sintetiza(o.strings['mensagem']);
    finally
        o.Free;
    end;
end;

procedure registra;
    begin
    HTTPRouter.RegisterRoute('/fala', rmPost, @sintetizaEndpoint);
end;
end.

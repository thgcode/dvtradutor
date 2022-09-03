unit wrapDvWin;
interface
procedure registra;
implementation
uses httpDefs, httpRoute, fpJson, jsonParser, dvWin;

procedure bipaEndpoint(req: TRequest; resp: TResponse);
    begin
        sintBip;
end;

procedure clekaEndpoint(req: TRequest; resp: TResponse);
    begin
        sintClek;
end;

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

procedure leLinhaEndpoint(req: TRequest; resp: TResponse);
    var o: tJsonObject;
    var respObj: tJsonObject;
    s: string;
    begin
    try
        o := getJson(req.content) as tJsonObject;

        if o.get('falando', false) then
            sintReadln(s)
        else
            readln(s);

        try
            respObj := tJsonObject.create;
            respObj.strings['resultado'] := s;
            resp.content := respObj.asJson;
        finally
            respObj.free;
        end;

    finally
        o.Free;
    end;
end;

procedure registra;
    begin
    HTTPRouter.RegisterRoute('/bip', rmPost, @bipaEndpoint);
    HTTPRouter.RegisterRoute('/clek', rmPost, @clekaEndpoint);
    HTTPRouter.RegisterRoute('/fala', rmPost, @sintetizaEndpoint);
    HTTPRouter.RegisterRoute('/linha', rmGet, @leLinhaEndpoint);
end;
end.

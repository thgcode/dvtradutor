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

procedure falandoEndpoint(req: TRequest; resp: TResponse);
    var respObj: tJsonObject;
    begin
        try
            respObj := tJsonObject.create;
            respObj.booleans['resultado'] := sintFalando;
            resp.content := respObj.asJson;
        finally
            respObj.free;
        end;
end;

procedure escreveEndpoint(req: TRequest; resp: TResponse);
    var o: tJsonObject;
     s: string;
    novaLinha: boolean;
    falando: boolean;
    begin
    try
        o := getJson(req.content) as tJsonObject;
        s := o.strings['mensagem'];

        novaLinha := o.get('nova_linha', true);
        falando := o.get('falando', true);

        if novaLinha then
            begin
            if falando then
                sintWriteln(s)
            else
                writeln(s)
        end
        else
            begin
            if falando then
                sintWrite(s)
            else
                write(s);
        end;
    finally
        o.free;
    end;
end;

procedure registra;
    begin
    HTTPRouter.RegisterRoute('/bip', rmPost, @bipaEndpoint);
    HTTPRouter.RegisterRoute('/clek', rmPost, @clekaEndpoint);
    HTTPRouter.RegisterRoute('/falando', rmGet, @falandoEndpoint);
    HTTPRouter.RegisterRoute('/fala', rmPost, @sintetizaEndpoint);
    HTTPRouter.RegisterRoute('/linha', rmGet, @leLinhaEndpoint);
    HTTPRouter.RegisterRoute('/tela', rmPost, @escreveEndpoint);
end;
end.

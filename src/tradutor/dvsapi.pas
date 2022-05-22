{------------------------------------------------------------}
{    Rotinas de tratamento de fala SAPI
{    Autor: José Antonio Borges
{    Em 9/10/2000
{------------------------------------------------------------}

unit dvsapi;

interface

uses windows, messages, dvcrt, dvwav, dvsapglb,
     dvserpro, dvsapi4, dvsapi5, dvsapi54,
     dialogs, comObj, sysUtils, activex;

function sapiInic (voz, veloc, tom: integer;
                   tipoSapi: integer; nomeArq: string): boolean;
procedure sapiFim;
procedure sapiFala (s: string);
procedure sapiFalaPchar (p: pchar);
function sapiAtivo (masc: byte): boolean;
    {  masc = 1  - se acabou de processar buffers internos, talvez ainda falando }
    {  masc <> 1 - se audio ou gravação ativa  }
procedure sapiReset;
procedure sapiPegaParam (var param: TParamVoz);
procedure sapiMudaParam (param: TParamVoz);
procedure sapiInfo (nvoz: integer; var paramSapi: TInfoSAPI);
function sapiNumVozes: integer;

function sapiTipo: integer;

implementation

var modeloSapi: integer;

function sapiTipo: integer;
begin
    result := modeloSapi;
end;

function sapiInic (voz, veloc, tom: integer;
                   tipoSapi: integer; nomeArq: string): boolean;
begin
    modeloSapi := tipoSapi;
    case modeloSapi of
        3:  result := dvserpro.sapiInic (voz, veloc, tom, nomeArq);
        4:  result := dvsapi4.sapiInic (voz, veloc, tom, nomeArq);
        54: result := dvsapi54.sapiInic (voz, veloc, tom, nomeArq);
    else
            result := dvsapi5.sapiInic (voz, veloc, tom, nomeArq);
    end;
    if result then
        while sapiAtivo(1) do delay (50);
end;

procedure sapiFim;
begin
    case modeloSapi of
        3: dvserpro.sapiFim;
        4: dvsapi4.sapiFim;
       54: dvsapi54.sapiFim;
    else
           dvsapi5.sapiFim;
    end;
end;

procedure sapiFala (s: string);
begin
    case modeloSapi of
        3: dvserpro.sapiFala (s);
        4: dvsapi4.sapiFala (s);
       54: dvsapi54.sapiFala (s);
    else
           dvsapi5.sapiFala (s);
    end;
end;

procedure sapiFalaPchar (p: pchar);
begin
    case modeloSapi of
        3: dvserpro.sapiFalaPchar (p);
        4: dvsapi4.sapiFalaPchar (p);
       54: dvsapi54.sapiFalaPchar (p);
    else
           dvsapi5.sapiFalaPchar (p);
    end;
end;

function sapiAtivo (masc: byte): boolean;
{  masc = 1  - se acabou de processar buffers internos, talvez ainda falando }
{  masc <> 1 - se audio ou gravação ativa  }
begin
    processWindowsQueue;
    case modeloSapi of
        3: result := dvserpro.sapiAtivo (masc);
        4: result := dvsapi4.sapiAtivo (masc);
       54: result := dvsapi54.sapiAtivo (masc);
    else
           result := dvsapi5.sapiAtivo (masc);
    end;
end;

procedure sapiReset;
begin
    case modeloSapi of
        3: dvserpro.sapiReset;
        4: dvsapi4.sapiReset;
       54: dvsapi54.sapiReset;
    else
           dvsapi5.sapiReset;
    end;
end;

procedure sapiPegaParam (var param: TParamVoz);
begin
    case modeloSapi of
        3: dvserpro.sapiPegaParam (param);
        4: dvsapi4.sapiPegaParam (param);
       54: dvsapi54.sapiPegaParam (param);
    else
           dvsapi5.sapiPegaParam (param);
    end;
    param.tipoSapi := modeloSapi;
end;

procedure sapiMudaParam (param: TParamVoz);
begin
    case modeloSapi of
        3: dvserpro.sapiMudaParam (param);
        4: dvsapi4.sapiMudaParam (param);
       54: dvsapi54.sapiMudaParam (param);
    else
           dvsapi5.sapiMudaParam (param);
    end;
end;

procedure sapiInfo (nvoz: integer; var paramSapi: TInfoSAPI);
begin
    case modeloSapi of
        3: dvserpro.sapiInfo (nvoz, paramSapi);
        4: dvsapi4.sapiInfo (nvoz, paramSapi);
       54: dvsapi54.sapiInfo (nvoz, paramSapi);
    else
           dvsapi5.sapiInfo (nvoz, paramSapi);
    end;
    paramsapi.tipoSapi := modeloSapi;
end;

function sapiNumVozes: integer;
begin
    case modeloSapi of
        3: result := dvserpro.sapiNumVozes;
        4: result := dvsapi4.sapiNumVozes;
       54: result := dvsapi54.sapiNumVozes;
    else
           result := dvsapi5.sapiNumVozes;
    end;
end;

begin
    modeloSapi := 5;
end.

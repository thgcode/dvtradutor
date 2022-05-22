{------------------------------------------------------------}
{    Globais das rotinas de tratamento de SAPI
{------------------------------------------------------------}

unit dvsapglb;

interface

uses speech;

type
  PParamVoz = ^TParamVoz;
  TParamVoz = record
      tipoSapi: integer;
      voz: longint;
      velocidade: longint;
      tom: longint;
      minVeloc, maxVeloc: longint;
      minTom, maxTom: longint;
  end;

  PInfoSAPI = ^TInfoSAPI;
  TInfoSAPI = record
      tipoSapi: integer;
      voz: longint;
      nomeVoz: string;
      sexo, idade: integer;
      modo, produtor, produto,
      estilo, dialeto: string;
      lingua: integer;
  end;

var
    sapi5AceitaXML: boolean;

implementation
end.
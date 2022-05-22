unit uttsTonica;

interface
uses sysUtils;

function descobreTonica (palavra: string): integer;

implementation

{--------------------------------------------------------}

function descobreTonica (palavra: string): integer;
var
    p: integer;
    c: char;
    posAcento: integer;
    estado : integer;                   { Indica estado corrente do diagrama }

const
    vogais: set of char =
        ['a','e','i','o','u','y','w','ü'];
    acentos: set of char =
        ['á','â','ã','à','é','ê','í','ó','ô','õ','ú'];
begin
    descobreTonica := 0;
    palavra := ansiLowerCase (palavra);
    posAcento := 0;
    for p := length (palavra) downto 1 do
        begin
            c := palavra[p];
            if c in acentos then
                 begin
                     descobreTonica := p;
                     exit;
                 end;
            if (posAcento = 0) and (c in vogais) then
                posAcento := p;
        end;

    if posAcento = 0 then exit;   // palavra não tem vogais

    estado := 0;
    p := length (palavra);

    while p > 0 do
        begin
            c := palavra[p];

            case estado of
                0: case c of
                       'a', 'e', 'o':
                            begin
                                descobreTonica := p;
                                estado := 1;
                            end;
                       'u':
                            begin
                                descobreTonica := p;
                                estado := 10;
                            end;
                       'i':
                            begin
                                descobreTonica := p;
                                estado := 20;
                            end;
                       's': estado := 0;
                       'm': estado := 40;
                   else
                       estado := 30;
                   end;

            {--- palavras com última vogal 'a', 'e', 'o' ---}

                1: if c = 'u' then
                       estado := 4
                   else
                   if c in vogais then
                       begin
                           descobreTonica := p;
                           p := 0;
                       end
                   else
                       estado := 2;

                2: case c of
                       'i', 'u':
                           begin
                               descobreTonica := p;
                               estado := 3;
                           end;
                       'a', 'e', 'o':
                           begin
                               descobreTonica := p;
                               p := 0;
                           end;
                    end;

                3: begin
                        if c in ['a', 'e', 'o'] then
                            begin
                                descobreTonica := p;
                                p := 0;
                            end
                        else
                            if c = 'u' then
                                estado := 5
                        else
                             p := 0;
                    end;

                4: begin
                       if c in ['g', 'q'] then
                           begin
                               descobreTonica := p + 2;
                               estado := 2;
                           end
                       else
                           begin
                               descobreTonica := p + 1;
                               p := 0;
                           end;
                   end;

                5: begin
                       if c in ['g', 'q'] then
                           descobreTonica := p + 2
                       else
                           descobreTonica := p + 1;
                       p := 0;
                   end;

            {--- palavras com última vogal 'u' ---}

                10: begin
                        if c in ['a','e','i','o'] then
                            descobreTonica := p;
                        p := 0;
                    end;

            {--- palavras com última vogal 'i' ---}

                20: begin
                        if c in ['a','e','o'] then
                            descobreTonica := p
                        else
                            if c = 'u' then
                                estado := 21
                            else
                                p := 0;
                    end;

                21: begin
                        if c in ['g','q'] then
                            descobreTonica := p + 2
                        else
                            descobreTonica := p + 1;
                        p := 0;
                    end;

            {--- palavras terminadas por consoante, exceto 's', 'm' ---}

                30: if c in vogais then
                       begin
                           descobreTonica := p;
                           p := 0;
                      end;

            {--- palavras terminadas por 'm' ---}

                40: if c in ['i', 'o', 'u'] then
                        begin
                           descobreTonica := p;
                           p := 0;
                        end
                    else
                        if c in ['a', 'e'] then
                            begin
                                descobreTonica := p;
                                estado := 1;
                            end
                        else
                            estado := 0;
            end;

            p := p - 1;
        end;
end;

end.
 
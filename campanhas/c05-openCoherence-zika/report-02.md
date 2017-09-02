# Relatório 02 da Campanha C05

*Obtenção das licenças dos artigos e cálculo da OpenCoherence do conjunto*

A partir da revisão metodológica foram definidos índices e algorítimos. Os resultados obtidos são apresentados.

* Curador responsável: Ricardo.
* Expert responsável: Peter.

## Levantamentos preliminares

Conforme a metodologia descrita por Krauss (2015) as licensas dos artigos JATS em geral podem ser deduzidas diretamente da URL apresentada na tag license. Na contagem sobre o universo total, usando `n_hasLicUrl` conforme abaixo ... e a [tabela de metadados do *report-01*](report-01.md#tabela-de-metadados).

* `n_arts=1444` número de artigos no universo filtrado.
* `n_hasLicUrl=937` (65% de n_arts)

Como o número restante, ~500 (35%), ainda é elevado e a obtenção direta de URL pode levar a erros de  interpretação em textos de licença, optou-se por revisar de forma sistemática todos os textos.

```sql
SELECT count(*) as n_arts      FROM kx.c05_article; --  1444
SELECT count(*) as n_hasLicUrl FROM kx.c05_article WHERE license_url is not null; --  937

-- comparando com o universo
SELECT count(*) as n_hasLicUrl FROM kx.vw_article_metas1_sql WHERE license_url is not null; --  1166
```

## Revisão metodológica e algoritmos ##
...
### Reconhecimento da licença e sua família

1. Confere se a URL fornecida pode ser resolvida pelos _datasets_ disponíveis (`tmpcsv_license_urls`).

2. Confere se o texto de licensa fornecido pode ser resolvida pela avaliação humana realizada (_dataset_ `data/liecenses_used.csv` do c05).

3. Complementa-se os _datasets_ dos itens 1 ou 2 no sentido de garantir o máximo ou a totalidade das resoluções de licensas.

Uma vez concluído o reconhecimento das licensas, um relatório de frequência e confiabilidade das resoluções é emitido.

```sql
-- resolução da licensa fornecida diretamente pela sua URL
SELECT count(*) as n
FROM kx.c05_article
WHERE license_url IS NOT NULL AND lib.url_tocmp(license_url) IN (
    SELECT lower(url) FROM tmpcsv_license_urls
); -- 932 de 1444


-- -- -- -- -- -- -- -- --
-- -- -- PART1, insert only URLs

-- drop TABLE kx.article_license ;
CREATE TABLE kx.article_license AS
  SELECT a.id, a.license_text,
         'url'::text as match_mode, ''::text as name, ''::text as family,
         array_agg(DISTINCT lu.name) as names
  FROM kx.c05_article a INNER JOIN
       tmpcsv_license_urls lu ON lower(lu.url)=lib.url_tocmp(a.license_url)
  WHERE license_url IS NOT NULL
  GROUP BY 1,2
  ORDER BY 1
; -- 932

-- check no error by select * from kx.article_license where array_length(name,1)>1;
UPDATE kx.article_license
SET  name=names[1]
WHERE array_length(names,1)=1
; -- 932  (same number is good)

UPDATE kx.article_license
SET  family=l.family
FROM tmpcsv_licenses l
WHERE article_license.name=l.name
; -- 932.. check errors on diff number  SELECT * from kx.article_license where family='';

-- -- -- -- -- --
-- PART2: insert as text-equivalence

INSERT INTO kx.article_license (id,license_text,url,family,names)
  SELECT a.id,
        lib.trim2( xpath('//article/front//license//text()', content) ) as license_text,
         'url'::text as match_mode, ''::text as name, ''::text as family,
         array_agg(DISTINCT lu.name) as names
  FROM kx.c05_article a INNER JOIN
       kx.c05_licenses_used lu ON lower(lu."License")=lower()
  WHERE a.license_url IS NULL OR a.id IN (SELECT id WHERE kx.article_license family='')
  GROUP BY 1,2
  ORDER BY 1
; -- 932


  n_reuse,famyly,family_or_license,embargo_months,contradiction,dependences,License,notes
  FROM kx.c05_licenses_used inner JOIN tmpcsv_licenseText_used




---- --- REPORTS

SELECT *, round(100*n/932.0) as perc FROM (
    SELECT name, count(*) as n
    FROM kx.article_license group by 1 order by 2 desc, 1
) t; --report 1

SELECT *, round(100*n/932.0) as perc FROM (
    SELECT family, count(*) as n
    FROM kx.article_license group by 1 order by 2 desc, 1
) t; --report 2
```

family          |  n  | perc
----------------|-----|------
by       | 766 |   82
by-nc-nd |  65 |    7
cc0      |  47 |    5
by-nc    |  40 |    4
by-nc-sa |  13 |    1
cc0-x    |   1 |    0


name            |  n  | perc
----------------|-----|------
CC-BY-4.0       | 713 |   77
CC-BY-NC-ND-4.0 |  61 |    7
CC0-1.0         |  44 |    5
CC-BY-NC-4.0    |  34 |    4
CC-BY-2.0       |  26 |    3
CC-BY-3.0       |  23 |    2
CC-BY-NC-SA-3.0 |  11 |    1
CC-BY-NC-3.0    |   6 |    1
CC-BY-NC-ND-3.0 |   4 |    0
CC-BY-2.5       |   4 |    0
CC-PDM-1.0      |   3 |    0
CC-BY-NC-SA-4.0 |   2 |    0
CC0-GOV-US      |   1 |    0

### Reconhecimento da família e cálculos de score
A resolução de família é dada pelo _dataset_ [ppKrauss/licenses/data/licenses.csv](https://github.com/ppKrauss/licenses/blob/master/data/licenses.csv), e os scores de família por uma tabela similar a [ppKrauss/licenses/data/families.csv](https://github.com/ppKrauss/licenses/blob/master/data/families.csv).  A eleição de scores foi revista em função da ordenação mais praticada atualmente, expressa pelo *"Creative Commons license spectrum"*:

![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Creative_commons_license_spectrum.svg/148px-Creative_commons_license_spectrum.svg.png)

## Resultados
...

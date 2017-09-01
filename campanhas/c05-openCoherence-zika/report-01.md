# Relatório 01 da Campanha C05

Relatorório de "...". Resultados obtidos.

## Sumário das contagens ##

Na base de dados foram conseguidos por download (via API do PMC) 2405 artigos em JATS. Alguns full-text outros apenas front-back.

* `n_arts=2405` (96% do universo inicial pesquisado)
* `n_has_body=2032` e `n_has_permiss=2032` (84,5% de n_arts)
* `n_useful1=2032` (84,5% de n_arts), contagem de  *`has_body` and `has_permiss`*
* `n_hasRefs=1778` (73,9% de n_arts)
* `n_useful2=1667` (69,3% de n_arts), contagem de  *`hasRefs` and `useful1`*
* `n_isValid=1940` (80,7% de n_arts)
* `n_useful3=1444` (60,0% de n_arts), contagem de  *`isValid` and `useful2`*

```
SELECT count(*) as n_jous from core.journal_repository; -- 14107 universo de issn's catalogado

SELECT count(*) as n_arts     FROM core.article;--  2405
SELECT count(*) as n_has_body FROM kx.vw_article_metas1_sql WHERE has_body; -- 2032
SELECT count(*) as n_has_permiss FROM kx.vw_article_metas1_sql WHERE has_permiss; -- 2032
SELECT count(*) as n_useful1    FROM kx.vw_article_metas1_sql WHERE has_body and has_permiss; -- 2032
SELECT count(*) as "n_hasRefs"   FROM kx.vw_article_metas1_sql WHERE n_refs>1; -- 1778

SELECT count(*) as n_useful2 FROM kx.vw_article_metas1_sql
WHERE has_body and has_permiss and n_refs>1;--   1667

SELECT count(*) as n_isValid FROM kx.vw_article_metas1_sql
WHERE article_type IN ('research-article', 'review-article', 'brief-report','case-report');--   1940

SELECT count(*) as n_useful3 FROM kx.vw_article_metas1_sql
WHERE has_body and has_permiss and n_refs>1 and
      article_type IN ('research-article', 'review-article', 'brief-report','case-report');--   1444

-- -- -- --
SELECT count(*) "n_hasLicense"
FROM core.article
WHERE xmlexists('//article/front//license' PASSING BY REF content); -- 1811

SELECT count(*) "n_hasCopyright"
FROM core.article
WHERE xmlexists('//article/front//copyright-statement' PASSING BY REF content); -- 1856

CREATE VIEW kx.c05_licenses_used AS
 SELECT count(*) as n_reuse,
       lib.trim2( xpath('//article/front//license//text()', content) ) as license
 FROM core.article
 WHERE xmlexists('//article/front//license' PASSING BY REF content)
 GROUP BY 2
 ORDER BY 1 desc, 2
; -- 191 tipos de licença a serem analisados
COPY (SELECT * FROM kx.c05_licenses_used) TO '/tmp/c05_licenses_used.csv' DELIMITER ',' CSV HEADER;

create view kx.vw_c05_licenseExpand AS
 SELECT id,xpath('//article/front//license', content) as xml_license
 FROM core.article
 WHERE lib.trim2( xpath('//article/front//license//text()', content) )
       IN ('All Rights Reserved.', 'Freely available online through the PNAS open access option.', 'Published by the Royal Society. All rights reserved.', 'This is an open access article published under an ACS AuthorChoice License, which permits copying and redistribution of the article or any adaptations for non-commercial purposes.')
;
COPY COPY (SELECT count(*) as n, array_agg(id) ids, xml_license[1]::text FROM kx.vw_c05_licenseExpand group by (xml_license[1])::text ) TO '/tmp/c05_licenses_expanded.csv' DELIMITER ',' CSV HEADER;
```
## Refs apoio

* https://jats.nlm.nih.gov/publishing/tag-library/1.1/element/license.html
* ...

## Resultados parciais
Dump dos _datasets_ em [c05-openCoherence-zika/data](https://github.com/UnB-CIDACS/observatorio-jats/tree/master/campanhas/c05-openCoherence-zika/data): `issn_count1.csv`, `licenses_used.csv`, `pmc_result-zikaFull-2017-08.csv`. Disponíveis também [planilha ](https://docs.google.com/spreadsheets/d/1UWjhYxrD5D2SBFFhtiT2QhiI3vG6Y2QTZ7YF7wULO0Y/).

Revistas com mais de 20 artigos, totalizando mais de 80% do universo de artigos no PMC.

  ISSN-L   |  n  
-----------|-----
 1935-2727 | 209
 2045-2322 | 127
 1080-6040 | 115
 1932-6203 | 106
 0042-9686 |  91
 1756-3305 |  70
 0027-8424 |  47
 0022-538X |  46
 1553-7366 |  41
 1664-302X |  41
 0002-9637 |  36
 1471-2334 |  34
 1999-4915 |  31
 1743-422X |  28
 1025-496X |  27
 2157-3999 |  26
 2352-3964 |  26
 0074-0276 |  25
 2150-7511 |  25
 2041-1723 |  24
 2046-1402 |  24
 2169-8287 |  20


--- kx LIBRARY
CREATE or replace FUNCTION kx.license_url2name(
  url text,
  retfamily boolean default false
) RETURNS text AS $f$
	SELECT CASE WHEN $2 THEN family ELSE name END
       FROM kx.vw_license_url
       WHERE lib.url_tocmp($1)= url;
$f$ LANGUAGE sql IMMUTABLE;


-------------

CREATE VIEW kx.vw_c05_article AS
  SELECT *,  lib.trim2( xpath('//article/front//license//text()', content) ) as license_text
  FROM kx.vw_article_metas1_sql
  WHERE has_body and has_permiss and n_refs>1
      and article_type IN ('research-article', 'review-article', 'brief-report','case-report')
; -- 1444 com has_permiss, 1510 sem.


-- DROP VIEW kx.c05_issn_count1;
CREATE VIEW kx.c05_issn_count1 AS
 SELECT issn.cast(k.issnl) as issnl,   -- 1
        COUNT(*) as n_arts,            -- 2
        SUM((
          k.has_body and k.has_permiss and k.n_refs>1
          and article_type IN ('research-article', 'review-article', 'brief-report','case-report')
          )::int) n_usefull2,  -- 4
        trim(substr(j.publisher, 1, position(':' in j.publisher)),' :') as publisher_loc,
        j.title   -- 5
 FROM  kx.vw_article_metas1_sql k
       LEFT JOIN tmpcsv_journalmeta j ON j.issnl=issn.cast(k.issnl)
 GROUP BY 1, 4, 5
 ORDER BY 3 desc, 1
;
-- for first COPY (SELECT * FROM kx.c05_issn_count1) TO '/tmp/c05_issn_count1.csv' DELIMITER ',' CSV HEADER;

-- -- --
CREATE VIEW kx.c05_licenses_used AS
 SELECT count(*) as n_reuse,
       lib.trim2( xpath('//article/front//license//text()', content) ) as license
 FROM core.article
 WHERE xmlexists('//article/front//license' PASSING BY REF content)
 GROUP BY 2
 ORDER BY 1 desc, 2
; -- 191 tipos de licença a serem analisados
COPY (SELECT * FROM kx.c05_licenses_used) TO '/tmp/c05_licenses_used.csv' DELIMITER ',' CSV HEADER;

CREATE VIEW kx.vw_c05_licenseExpand AS
 SELECT id,xpath('//article/front//license', content) as xml_license
 FROM core.article
 WHERE lib.trim2( xpath('//article/front//license//text()', content) )
       IN ('All Rights Reserved.', 'Freely available online through the PNAS open access option.', 'Published by the Royal Society. All rights reserved.', 'This is an open access article published under an ACS AuthorChoice License, which permits copying and redistribution of the article or any adaptations for non-commercial purposes.')
;
COPY  (SELECT count(*) as n, array_agg(id) ids, xml_license[1]::text FROM kx.vw_c05_licenseExpand group by (xml_license[1])::text ) 
TO '/tmp/c05_licenses_expanded.csv' DELIMITER ',' CSV HEADER;


---------------
-------
-- DROP table kx.c05_licenseText_used;
CREATE TABLE kx.c05_licenseText_used AS -- falta confiança 
  SELECT  lower("License") as license_text,  count(*) as n_arts,
                   array_agg(DISTINCT  famyly) as human_families,
                   array_agg_notnull(DISTINCT family_or_license) as human_interpretations,
		  '{}'::text[] as license_text_urls,
		  '{}'::text[] as url_names,
		  '{}'::text[] as url_families,
		   NULL::boolean as is_trusted
 FROM tmpcsv_licenseText_used
 group by 1
; -- 187 (reduced from 191 non lower)
 
-- check:
--     SELECT count(*) FROM kx.vw_c05_article ;
--     SELECT  count(*), count(DISTINCT a.id) 
--     FROM kx.vw_c05_article a INNER JOIN  kx.c05_licenseText_used u ON lower(a.license_text)=u.license_text;

UPDATE kx.c05_licenseText_used
SET license_text_urls=t.urls,   url_names=t.names,  url_families=t.families
FROM (
   SELECT u.license_text, 
                    array_agg_notnull(DISTINCT a.url_clean) as urls,
                    array_agg_notnull(DISTINCT kx.license_url2name(a.url_clean)) as names,
                    array_agg_notnull(DISTINCT kx.license_url2name(a.url_clean,true)) as families
   FROM (SELECT *, lib.url_tocmp(license_url) as url_clean FROM kx.vw_c05_article) a 
                  INNER JOIN  kx.c05_licenseText_used u ON lower(a.license_text)=u.license_text
   GROUP BY 1
) t WHERE t.license_text = c05_licenseText_used.license_text
; -- 151 of 187

--- List the invalid or conflict ones
--     SELECT n_arts,  human_families as hfams, human_interpretations as hinterpretations, url_families, url_names, license_text_urls, license_text
--     FROM  kx.c05_licenseText_used 
--     WHERE array_length(url_families,1)>1 OR array_length(url_names,1)>1  OR  url_families[1]!=human_families[1];

-- DROP VIEW  kx.vw_c05_licenseText_used;
CREATE VIEW  kx.vw_c05_licenseText_used AS 
   SELECT *,  
           CASE WHEN url_families[1] is null THEN human_families[1] ELSE url_families[1] END as family , 
           CASE WHEN url_families[1] is null THEN true ELSE false END as inferby_human
   FROM  kx.c05_licenseText_used 
   WHERE (array_length(url_families,1)=1 AND  url_families[1]=human_families[1]) OR (url_families[1] is null AND array_length(human_families,1)=1 AND human_families[1]>'')
;
-- select count(*) from kx.vw_c05_licenseText_used; --    156

-- FALTA kx.vw_c05_article   com respectivas definindo famílias, priorizando as interpretacao de texto  
select family, license_text FROM kx.vw_c05_licenseText_used 


----- teste e relatorio.. . falta resgatar info da inferencia... e incluir dados no c05_article

CREATE table tmp_res as SELECT a.id, u.family. u.inferby_human
FROM kx.c05_article a INNER JOIN kx.vw_c05_licenseText_used u ON lower(a.license_text)=u.license_text
; -- demorada pois nao esta usando cache.

select count(*) from tmp_res; -- 1342 de 1444

SELECT *, round(100*n/1342.0) as perc FROM (
    SELECT family, count(*) as n
    FROM tmp_res  group by 1 order by 2 desc, 1
) t; --report 2

-- Falta 1. usar cache desde o inicio; 2. comparar os modos de inferencia e os artigos sem relacionamento.

-- relatorio dos descartados, por ISSN
select issn.cast(issnl) as "ISSN-L",count(*) as n_arts from kx.c05_article where id NOT IN (select id from tmp_res) group by 1 order by 2 desc, 1;

-- relatorio dos descartados por doi
select id, doi, license_url from kx.c05_article where id NOT IN (select id from tmp_res);

---
select count(*) from kx.c05_article a; --  1444
select count(*) from kx.c05_article a inner join tmp_res t ON t.id=a.id ; -- 1342
select count(*) from kx.c05_article a inner join tmp_res t ON t.id=a.id where a.license_url is null; --     477
select count(*) from kx.c05_article a inner join tmp_res t ON t.id=a.id where a.license_url is not null; --  865



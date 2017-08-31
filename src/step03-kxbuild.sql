--
-- Observatorio-JATS, cache (kx) views and other structures.
--

DROP SCHEMA IF EXISTS kx CASCADE;
CREATE SCHEMA kx;

-- Cache para calibração e comparação com dados SciELO.

CREATE VIEW kx.vw_article_metas1 AS
  SELECT id,
  -- FALTA lang do artigo e sua DTD, além de relacionar com repositório-origem (autoridade do dump obtido)
   -- substituir por função que captura direto todos os Xpaths pro JSON. Vantagem aqui pode ser otimização
   -- interna do PostgreSQL que criaria o DOM uma vez só para todos... Por ser cache não apita muito.
   (xpath('count(//article)', content))[1]::text::integer 		as n_articles,
   (xpath('//article/front//pub-date/year/text()', content))[1]::text::integer as year,
   trim((xpath('//article/front//volume/text()', content))[1]::text) 	as volume,
   trim((xpath('//article/front//issue/text()', content))[1]::text) 	as issue,
   lib.trim2( xpath('//article/front//article-title//text()',content) ) as title,
   lib.trim2( xpath('//article/front//abstract//text()', content) ) 	as abstract,
   trim((xpath('//article/front//pub-date[@pub-type="epub"]/text()', content))[1]::text) as epub_date,
   xmlexists('//article/body' PASSING BY REF content)            	as has_body,
   xmlexists('//article/front//permissions' PASSING BY REF content) 	as has_permiss,
   (xpath('count(//article/body//table)', content))[1]::text::integer 	as n_btables,
   (xpath('count(//article/body//fig)', content))[1]::text::integer 	as n_bfigs,
   (xpath('count(//article/back/ref-list/ref)', content))[1]::text::integer as n_refs,
   char_length(content::text)                                 		as nchars_xml,
   char_length(  array_to_string( (xpath('//article//text()', content))::text[] ,'')  )  as nchars_txt
  FROM core.article
;


CREATE VIEW kx.vw_article_metas1_sql AS
   SELECT *,
    (kx->>'n_articles')::int as n_articles,
    (kx->>'year')::int as year,
    (kx->>'volume')::text as volume,
    lib.lpad0((kx->>'issue')::text) as issue,
    (kx->>'title')::text as title,
    (kx->>'abstract')::text as abstract,
    (kx->>'title')::text as epub_date,
    (kx->>'has_body')::boolean as has_body,
    (kx->>'has_permiss')::boolean as has_permiss,
    (kx->>'n_btables')::int as n_btables,
    (kx->>'n_refs')::int as n_refs,
    (kx->>'n_bfigs')::int as n_bfigs,
    (kx->>'nchars_txt')::int as nchars_txt,
    (kx->>'nchars_xml')::int as nchars_xml
   FROM core.vw_article_journal_repo --core.article
;

-- revisar
CREATE VIEW kx.vw_article_issue AS
  SELECT a.*, m.issnl, m.year, m.volume, m.issue, m.title,
         m.n_refs, m.has_body, m.has_permiss, m.n_bfigs, m.n_btables, m.nchars_txt, m.nchars_xml
  FROM core.article a INNER JOIN kx.vw_article_metas1_sql m ON m.id=a.id
;
-----

CREATE VIEW kx.vw_article_issue_count AS
   SELECT  issnl, year, volume, issue , count(*) as n
   FROM kx.vw_article_issue
   GROUP BY issnl, year, volume, issue
   ORDER BY 1, 2 DESC, 3 DESC, lib.lpad0(issue)
;

-----

 CREATE VIEW kx.vw_std_issue_profile AS
    SELECT issnl, year, volume, issue,
           count(*) as n_arts,
           sum((n_refs>0)::int*1) as has_refs,
           avg(nchars_txt)::int as  avg_nchars_txt,
           avg(nchars_xml)::int as  avg_nchars_xml
    FROM kx.vw_article_metas1_sql
    GROUP BY 1,2,3,4
    ORDER BY 1, 2 desc, 3 desc, lib.lpad0(issue)
 ;

 CREATE VIEW kx.vw_std_volume_profile AS
    SELECT issnl, year, volume,
           count(*) as n_arts,
           sum((n_refs>0)::int*1) as has_refs,
           avg(nchars_txt)::int as  avg_nchars_txt,
           avg(nchars_xml)::int as  avg_nchars_xml
    FROM kx.vw_article_metas1_sql
    GROUP BY 1,2,3
    ORDER BY 1, 2 desc, 3 desc
 ;


-- depois da carga use COPY article_issue_count TO '/tmp/article_issue_count.csv' CSV HEADER;
-- montar planilha template scielo com awk, php ou perl


-- -- -- -- --
-- -- -- -- --
-- Datasets (from OpenCoherence model)

CREATE TABLE kx.families (
  family text NOT NULL PRIMARY KEY,
  scope text NOT NULL,
  sort int
);

CREATE TABLE kx.licenses (
  id_label   text NOT NULL CHECK(lower(id_label)=id_label),
  id_version text DEFAULT '',
  name   text NOT NULL CHECK(lower(replace(name,' ','-'))=(id_label||CASE WHEN id_version>'' THEN '-'||id_version ELSE '' END)),
  family text NOT NULL REFERENCES kx.families(family),
  title  text NOT NULL CHECK(trim(title)>''),
  info JSONb,
  UNIQUE(id_label,id_version),
  UNIQUE(title)
);

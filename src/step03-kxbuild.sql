
-- Cache para calibração e comparação com dados SciELO.

CREATE VIEW article_metas1 AS
  SELECT id,
   (xpath('count(/articles/article)', content))[1]::text::integer as n_articles,
   (xpath('/articles/article[1]/front//pub-date/year/text()', content))[1]::text::integer as year,
   (xpath('/articles/article[1]/front//volume/text()', content))[1]::text as volume,
   (xpath('/articles/article[1]/front//issue/text()', content))[1]::text as issue,
   (xpath('/articles/article[1]/front//article-title/text()', content))[1]::text as title,
   (xpath('count(/articles/article[1]//body)', content))[1]::text::integer as n_body,
   (xpath('count(/articles/article[1]/body//table)', content))[1]::text::integer as n_btables,
   (xpath('count(/articles/article[1]/body//fig)', content))[1]::text::integer as n_bfigs,
   (xpath('count(/articles/article[1]/back/ref-list/ref)', content))[1]::text::integer as n_refs,
   char_length(content::text) as nchars_xml,
   char_length(  array_to_string( (xpath('/articles//text()', content))::text[] ,'')  )  as nchars_txt
  FROM article
;

--DROP VIEW article_metas1_sql ;
CREATE VIEW article_metas1_sql AS
   SELECT id, issn,
    (kx->>'year')::int as year,
    (kx->>'volume')::text as volume,
    lpad0((kx->>'issue')::text) as issue,
    (kx->>'title')::text as title,
    (kx->>'n_refs')::int as n_refs,
    (kx->>'n_body')::int as n_body,
    (kx->>'n_bfigs')::int as n_bfigs,
    (kx->>'n_btables')::int as n_btables,
    (kx->>'n_articles')::int as n_articles,
    (kx->>'nchars_txt')::int as nchars_txt,
    (kx->>'nchars_xml')::int as nchars_xml
   FROM article;


   --DROP VIEW article_issue
   CREATE VIEW article_issue AS
      SELECT a.*, m.year, m.volume, m.issue, m.title,
             m.n_refs, m.n_body, m.n_bfigs, m.n_btables, m.nchars_txt, m.nchars_xml
      FROM article a INNER JOIN article_metas1_sql m ON m.id=a.id
   ;
-----

CREATE or replace FUNCTION lpad0(text) RETURNS  text AS $func$
  -- secure lpad for non-only-digits strings.
  SELECT  regexp_replace($1,'^([1-9])$','0\1'); -- or LPAD($1, 3, '0');
$func$ LANGUAGE SQL IMMUTABLE;
CREATE or replace FUNCTION lpad0(int) RETURNS text AS $wrap$
  SELECT lpad0($1::text);
$wrap$ LANGUAGE SQL IMMUTABLE;

CREATE VIEW article_issue_count AS
   SELECT  issn, year, volume, issue , count(*) as n
   FROM article_issue
   GROUP BY issn, year, volume, issue
   ORDER BY 1, 2 DESC, 3 DESC, lpad0(issue)
;


-----

   CREATE VIEW std_issue_profile AS
      SELECT issn, year, volume, issue,
             count(*) as n_arts,
             sum((n_refs>0)::int*1) as has_refs,
             avg(nchars_txt)::int as  avg_nchars_txt,
             avg(nchars_xml)::int as  avg_nchars_xml
      FROM article_metas1_sql
      GROUP BY 1,2,3,4
      ORDER BY 1, 2 desc, 3 desc, lpad0(issue)
   ;

   CREATE VIEW std_volume_profile AS
      SELECT issn, year, volume,
             count(*) as n_arts,
             sum((n_refs>0)::int*1) as has_refs,
             avg(nchars_txt)::int as  avg_nchars_txt,
             avg(nchars_xml)::int as  avg_nchars_xml
      FROM article_metas1_sql
      GROUP BY 1,2,3
      ORDER BY 1, 2 desc, 3 desc
   ;


-- depois da carga use COPY article_issue_count TO '/tmp/article_issue_count.csv' CSV HEADER;
-- montar planilha template scielo com awk, php ou perl

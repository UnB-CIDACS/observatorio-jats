
-- Cache para calibração e comparação com dados SciELO.

CREATE VIEW article_metas1 AS 
  SELECT *, 
   (xpath('/articles/article[1]/front//pub-date/year/text()', content))[1]::text::integer as year,
   (xpath('/articles/article[1]/front//volume/text()', content))[1]::text as volume,
   (xpath('/articles/article[1]/front//issue/text()', content))[1]::text as issue,
   (xpath('/articles/article[1]/front//article-title/text()', content))[1]::text as title,
   (xpath('count(/articles/article[1]/back/ref-list/ref)', content))[1]::text::integer as n_refs,
   char_length(content::text) as nchars_xml
   char_length(  array_to_string( (xpath('/articles//text()', content))::text[] ,'')  )  as nchars_txt
  FROM article
;

CREATE VIEW article_issue AS 
   SELECT id, issn, (kx->>'year')::int as year, (kx->>'volume')::text as volume, (kx->>'issue')::text as issue
   FROM article
;
   
CREATE VIEW article_issue_count AS 
   SELECT  issn, year, volume, issue , count(*) as n 
   FROM article_issue 
   group by 1,2,3,4
   order by 1,2,3,4
;

-- depois da carga use COPY article_issue_count TO '/tmp/article_issue_count.csv' CSV HEADER;
-- montar planilha template scielo com awk, php ou perl

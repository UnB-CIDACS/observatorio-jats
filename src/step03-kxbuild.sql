
-- Cache para calibração e comparação com dados SciELO.

CREATE VIEW article_metas1 AS 
  SELECT id, 
   (xpath('/articles/article[1]/front//pub-date/year/text()', content))[1]::text::integer as year,
   (xpath('/articles/article[1]/front//volume/text()', content))[1]::text as volume,
   (xpath('/articles/article[1]/front//issue/text()', content))[1]::text as issue,
   (xpath('/articles/article[1]/front//article-title/text()', content))[1]::text as title,
   (xpath('count(/articles/article[1]/back/ref-list/ref)', content))[1]::text::integer as n_refs,
   char_length(content::text) as nchars_xml
   -- char_length(  array_to_string( (xpath('/articles//text()', content))::text[] ,'')  )  as nchars_txt
  FROM article
;


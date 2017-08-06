

INSERT INTO repository(id,name,label,url,dtds) VALUES
 (1,'PubMed Central', 'pmc', 'http://www.ncbi.nlm.nih.gov/pmc/', 
   array['nlm-jats-2','nlm-jats-3','jats-1.0','jats-1.1']::text[]
 )
 ,(2,'SciELO', 'scielo', 'http://www.scielo.org', 
  array['thomson-jats-1','nlm-jats-3','sps-jats-1']::text[]
 )
;

-- see kx_csv2foreign_tables.sql
INSERT INTO journal_repository (issnl,repository_id) 
 SELECT  issnl, 1::int repo_id
 FROM (
   SELECT DISTINCT issn.n2c( unnest(array[issn,eissn]) ) as issnl
   FROM tmpcsv_pmc_ids
 ) t
 ORDER BY 1
;

----

-- ... after all imports


UPDATE article
  SET kx = kx_info
  FROM (
   SELECT id, to_json(article_metas1) as kx_info FROM article_metas1
  ) t
  WHERE t.id=article.id
;

--
-- Inserts. See also kx_csv2foreign_tables.sql
--

--
-- ATENCAO SUBSTITUIR POR CARGA CSV https://github.com/ppKrauss/openCoherence/blob/master/data/sciRepos.csv
INSERT INTO core.repository(id,name,label,url,dtds) VALUES
 -- add others as the example
 (1,'PubMed Central', 'pmc', 'http://www.ncbi.nlm.nih.gov/pmc/',
   array['nlm-jats-2','nlm-jats-3','jats-1.0','jats-1.1']::text[]
 )
 ,(2,'SciELO Brasil', 'scielo-br', 'http://www.scielo.br',
   array['thomson-jats-1','nlm-jats-3','sps-jats-1']::text[]
 )
 ,(3,'SciELO Argentina', 'scielo-ar', 'http://www.scielo.ar',
   array['thomson-jats-1','nlm-jats-3','sps-jats-1']::text[]
 )
 ,(4,'Europe PubMed Central ', 'europepmc', 'http://www.europepmc.org',
   array['nlm-jats-3','jats-1.0','jats-1.1']::text[]
 )
ON CONFLICT DO NOTHING -- can repeat insert with no bug message
;

-- ATENCAO substituir ls externo em pipe função de core.campaign_insertByFilename().
INSERT INTO core.campaign(id,label) VALUES
 -- add others as the example
 (1,'consistencia'),          (2,'corpusFioCruz'),
 (3,'openCoherence-doajCia'), (4,'openCoherence-teseZika'),
 (5,'openCoherence-zika')
ON CONFLICT DO NOTHING -- can repeat insert with no bug message
;

-- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- --
-- FROM CSV-files TO core

INSERT INTO core.journal_repository (issnl,repository_id)
 SELECT  issnl, 1::int repo_id
 FROM (
   SELECT DISTINCT issn.n2c( unnest(array[issn,eissn]) ) as issnl
   FROM tmpcsv_pmc_ids
 ) t
 WHERE issnl is not  null
 ORDER BY 1
ON CONFLICT DO NOTHING  -- danger, CPU consuming only for no bug message
;

-- DROP FOREIGN TABLE tmpcsv_pmc_ids;

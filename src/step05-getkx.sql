--
-- Inserts. See also kx_csv2foreign_tables.sql
--

INSERT INTO core.repository(id,name,label,url,dtds) VALUES
 -- add others as the example
 (1,'PubMed Central', 'pmc', 'http://www.ncbi.nlm.nih.gov/pmc/',
   array['nlm-jats-2','nlm-jats-3','jats-1.0','jats-1.1']::text[]
 )
 ,(2,'SciELO', 'scielo', 'http://www.scielo.org',
  array['thomson-jats-1','nlm-jats-3','sps-jats-1']::text[]
 )
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
;
-- DROP FOREIGN TABLE tmpcsv_pmc_ids;

-- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- --
-- FROM CSV-files TO kx


INSERT INTO kx.families(family,scope,sort) SELECT * FROM tmpcsv_families;

INSERT INTO kx.licenses (id_label, id_version, name, family, title, info)
  SELECT id_label, id_version, name, family, title, jsonb_build_object(
        'year',year, 'url',url,
        'domain_content', domain_content::boolean,
        'domain_data', domain_data::boolean,
        'domain_software', domain_software::boolean,
        'is_by', is_by::boolean,
        'is_sa', is_sa::boolean,
        'is_nd', is_nd::boolean
        )
  FROM tmpcsv_licenses
  WHERE family is not null
  UNION
  (
    SELECT id_label, id_version, name, family, title, jsonb_build_object(
    'year',year, 'url',url_ref,
    'domain_content', domain_content::boolean,
    'domain_data', domain_data::boolean,
    'domain_software', domain_software::boolean,
    'is_by', is_by::boolean,
    'is_sa', is_sa::boolean
    )
    FROM tmpcsv_implieds

  )
;

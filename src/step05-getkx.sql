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
  FROM tmpcsv_licenses -- -- 125 of 126 
  WHERE family is not null  --  only 37!
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

INSERT INTO kx.license_url (url, name, lang,  url_type, interpretation, info) 
   SELECT DISTINCT lib.url_tocmp(url), name, lang, url_type, interpretation, jsonb_build_object(
        'is_trans',CASE WHEN is_trans IS NULL OR is_trans='' OR is_trans='no' THEN false ELSE true END, 
        'is_cool',CASE WHEN is_cool IS NULL OR is_cool='' OR is_cool='no' THEN false ELSE true END, 
        'prefixes',prefixes,
        'url_sample', url
   )
  FROM  tmpcsv_license_urls
; -- 280



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

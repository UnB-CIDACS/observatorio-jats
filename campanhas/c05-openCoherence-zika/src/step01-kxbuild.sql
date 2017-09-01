
-- DROP VIEW kx.c05_issn_count1;
CREATE VIEW kx.c05_issn_count1 AS
 SELECT issn.cast(k.issnl) as issnl,   -- 1
        COUNT(*) as n_arts,            -- 2
        SUM((k.has_body and k.has_permiss and k.n_refs>1)::int) n_usefull2,  -- 4
        trim(substr(j.publisher, 1, position(':' in j.publisher)),' :') as publisher_loc,
        j.title   -- 5
 FROM  kx.vw_article_metas1_sql k
       LEFT JOIN tmpcsv_journalmeta j ON j.issnl=issn.cast(k.issnl)
 GROUP BY 1, 4, 5
 ORDER BY 3 desc, 1
;
COPY (SELECT * FROM kx.c05_issn_count1) TO '/tmp/c05_issn_count1.csv' DELIMITER ',' CSV HEADER;

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
COPY COPY (SELECT count(*) as n, array_agg(id) ids, xml_license[1]::text FROM kx.vw_c05_licenseExpand group by (xml_license[1])::text ) TO '/tmp/c05_licenses_expanded.csv' DELIMITER ',' CSV HEADER;

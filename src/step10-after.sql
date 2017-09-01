--
-- Cache REFRESH. Do it after all exports.
--

UPDATE core.article
  SET kx = kx_info
  FROM (
   SELECT id, to_json(vw_article_metas1) as kx_info
   FROM kx.vw_article_metas1
  ) t
  WHERE t.id=article.id
;


/*
ver campanha c05, já deve ter atualizado ...
create view kx.journal_current_issn as
  select distinct issn.cast(issnl) as issn
  from core.vw_article_journal
;
COPY (SELECT * from kx.journal_current_issn) TO '/tmp/issn_using.csv' DELIMITER ',' CSV HEADER;

*/

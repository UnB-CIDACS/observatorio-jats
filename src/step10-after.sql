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

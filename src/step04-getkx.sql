
UPDATE article 
SET kx = kx_info
FROM (
 SELECT id, to_json(article_metas1) as kx_info FROM article_metas1
) t 
WHERE t.id=article.id
;

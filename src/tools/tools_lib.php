<?php

/**
 * Biblioteca das funções definidas no tools.yuml.
 */


// Gestão dos arquivos XML
function gestao_xml($params) {
	print "\n RODOU gest xml";
}

// Gestão dos arquivos CSV
function gestao_csv($params) {
	print "\n RODOU gest csv";
}

===


CREATE or replace FUNCTION core.insert_article_byjou(
 p_jrepo_id int,
 p_uri text,
 p_content XML
) RETURNS int AS $f$
  INSERT INTO core.article (jrepo_id,uri,content) 
  VALUES($1, $2,  $3 ) RETURNING id
  ;
$f$ LANGUAGE SQL;


CREATE or replace FUNCTION core.get_issn(xml) RETURNS int AS $f$
  SELECT issn.cast( trim((xpath(
	'//article/front/journal-meta/issn/text() | //article/front/journal-meta/issn-l/text()', 
	$1
	))[1]::text) );
$f$ LANGUAGE SQL;



CREATE or replace FUNCTION core.insert_article(
 p_repo_id int,
 p_uri text,
 p_content XML
) RETURNS int AS $f$
  SELECT core.insert_article_byjou(
     (SELECT id FROM core.journal_repository WHERE  repository_id=$1 AND issnl=core.get_issn($3) )
     ,$2
     ,$3
  );
$f$ LANGUAGE SQL;




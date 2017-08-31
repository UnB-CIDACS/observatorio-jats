<?php
/**
 * Testando, pega metadados JSON do Worldcat.
 * Usar: cat ../../data/caches/issn_using.csv | php carga_worldcat.php > ../../data/caches/issn_using_meta.csv
 */

include('conf.php');

$url_base = 'http://xissn.worldcat.org/webservices/xid/issn/_ISSN_?format=json';

$pdo = new PDO(PG_CONSTR_OBSJATS, PG_DFT_USER, PG_DFT_PW);

$meta = ['issnl', 'issn_ref', 'publisher', 'form','title', 'rssurl', 'peerreview'];
fputcsv(STDOUT, $meta);

for ($i=0; $pmid = fgets(STDIN); $i=1)  if ($i) {
        $issn = trim($pmid);
        $url  = str_replace('_ISSN_',$issn,$url_base);
	//print "\n DEBUG $url";
	$meta  = json_decode( file_get_contents($url), TRUE );
	$d = $meta['group'][0]['list'][0];
	$meta = [ $issn, $d['issn'], $d['publisher'], $d['form'], $d['title'], $d['rssurl'], $d['peerreview'] ];
	fputcsv(STDOUT, $meta);
}

/*
	CREATE TABLE core.journal (
	  -- "In use" journal, to relate its articles. Need 1 or more articles in the database. Delete if no one.
	  issn integer NOT NULL PRIMARY KEY,
	  country text NOT NULL, -- 2-letter country code
	  name text,   -- full name
	  abbrev text, -- like label, but an "official abbreviation"
	  info JSONb,  -- all other information, like other issns, publisher, country of the publisher, languages.
	  kx   JSONb,  -- cache
	  UNIQUE(country,abbrev)
	);


	create view kx.journal_current_issn as 
	  select distinct issn.cast(issnl) as "ISSN-L" 
	  from core.vw_article_journal
	;

	COPY (SELECT * from kx.journal_current_issn) TO '/tmp/issn_using.csv' DELIMITER ',' CSV HEADER;



*/




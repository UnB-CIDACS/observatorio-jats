<?php
/**
 * Testando, pega metadados JSON do Worldcat.
 * Usar: cat ../../data/caches/issn_using.csv | php carga_worldcat.php > ../../data/caches/issn_using_meta.csv
 */

include('conf.php');

$url_base = 'http://xissn.worldcat.org/webservices/xid/issn/_ISSN_?format=json';
// worldcat não é completo mas é o que temos, resto obter dos artigos.
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

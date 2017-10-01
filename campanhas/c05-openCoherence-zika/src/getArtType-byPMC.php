<?php
/**
 * Transforms a PMCID list into CSV table of basic metadata.
 * EXAMPLE:
 *   php getArtType-byPMC.php < ../data/c05_articles_pmid-ids.csv |more
 */
print "pmcid,issn,pubtype,pubdate";
$urlGetSumm = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&retmode=json&id=';
foreach( file_csv("php://stdin")  as $row) {
   $pmcid = preg_replace('/^pmc/i','',$row[0]);
   $j= file_get_contents($urlGetSumm.$pmcid);
   $a = json_decode($j,true);
   $u = $a['result'][$pmcid];
   if (!$u['issn']) $u['issn'] = getISSN($pmcid);
   print "\n$pmcid,$u[issn],{$u['pubtype'][0]},".substr($u['sortpubdate'],0,10);
}


/// LIB from ppKrauss/php-little-utils

function getISSN($pmcid) {
  $txt = file_get_contents( "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=$pmcid" );
  $issn='';
  if ( preg_match('/issn[\s"]+([\dX\-]+)/i',$txt,$m) ) $issn=$m[1];
  return $issn;
}

/**
 * Reads entire CSV file into an array (or associative array or pair of header-content arrays).
 * Like build-in file() function, but to CSV handling.
 * @param $file string filename.
 * @param $opt not-null (can be empty) associative array of options (sep,enclosure,escape,head,assoc,limit)
 * @param $length integer same as in fgetcsv().
 * @param $context resource same as in fopen().
 * @return array (as head and assoc options).
 */
function file_csv($file, $opt=[], $length=0, resource $context=NULL) {
	$opt = array_merge(['sep'=>',', 'enclosure'=>'"', 'escape'=>"\\", 'head'=>false, 'assoc'=>false, 'limit'=>0], $opt);
	$header = NULL;
	$n=0; $nmax=(int)$opt['limit'];
	$lines = [];
	$h = $context? fopen($file,'r',false,$context):  fopen($file,'r');
	while( $h && !feof($h) && (!$nmax || $n<$nmax) )
		if ( ($r=fgetcsv($h,$length,$opt['sep'],$opt['enclosure'],$opt['escape'])) && $n++>0 )
			$lines[] = $opt['assoc']? array_combine($header,$r): $r;
		elseif ($n==1)
			$header = $r;
	return $opt['head']? array($header,$lines): $lines;
}


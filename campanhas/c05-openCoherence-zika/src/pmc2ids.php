<?php
/**
 * v2
 * Transforms a PMCID list into CSV table of basic metadata.
 * EXAMPLE:
 *   php pmcs2ids.php < ../data/c05_articles_pmid.csv |more
 */


$url = 'https://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0/?format=csv&ids=';
$MAX=150;
$n=0;
$pmcids = [];
$NOTFIRST=false;
foreach( file_csv("php://stdin")  as $row) {
   if ($n>=$MAX) {
     showCSV($url,$pmcids);
     $n=0; $pmcids=[];
   }
   $pmcids[] = $row[0];
   $n++;
}
if ($n) showCSV($url,$pmcids);



////LIB /////////

function showCSV($url,$a) {
     global $NOTFIRST;
     $csv= file_get_contents($url.join(',',$a));
     if ($NOTFIRST)  $csv = preg_replace('/^.+\n/', '', $csv); // rm header
     print $csv;
     $NOTFIRST = true;
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







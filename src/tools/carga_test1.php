<?php
/**
 * Testando. Realiza inserts via PDO.
 * Usar: cat PMIDs.txt | php insert03_direct.php 1234
 */

include('conf.php');
$pdo = new PDO(PG_CONSTR_OBSJATS, PG_DFT_USER, PG_DFT_PW);

// conforme indicações de https://www.ncbi.nlm.nih.gov/pmc/tools/get-full-text/
//$url_base = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id=';
$url_base = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id=';

if ($argc<2) die("\nERRO: falta argumento com ID do repositório\n");
$repoID = $argv[1];

$st = $pdo->prepare("
  SELECT core.insert_article( $repoID, :uri,  XMLPARSE (DOCUMENT :content) )
");

while ($pmid = fgets(STDIN)) {
        $pmid = trim($pmid);
        $url  = "$url_base$pmid";
print "\n $url";

        $xml  = file_get_contents($url);
print "\n\t ".substr($xml,0,60);

$ret =         $st->execute(array(
            "uri" => $url,
            "content" => $xml
        ));
print "\n\t$ret";

}





<?php
/**
 * Testando. Realiza inserts via PDO.
 * Usar: cat PMIDs.txt | php insert03_direct.php 1234
 */

include('conf.php');
$pdo = new PDO(PG_CONSTR_OBSJATS, PG_DFT_USER, PG_DFT_PW);
$url_base = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id=';

if ($argc<2) die("\nERRO: falta argumento com ID do repositório\n");
$repoID = $argv[1];

$statement = $link->prepare("
  INSERT INTO core.article (jrepo_id,uri,content) VALUES
  VALUES($repoID, :uri,  XMLPARSE (DOCUMENT :content) )
");

while ($pmid = fgets(STDIN)) {
	$pmid = trim($pmid);
	$url  = "$url_base$pmid";
	$xml  = file_get_contents($url);
	$statement->execute(array(
	    "uri" => $url,
	    "content" => $xml
	));
}




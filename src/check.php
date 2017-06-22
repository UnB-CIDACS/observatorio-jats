<?php
/**
 *  Faz busca por artigos em listas de referências de fonte HTML dada por DOI ou save-as HTML do artigo. 
 *  Entrar com uma sequencia de DOIs. Saida = planilha de <doiCitador,tipoCitado,IDcitado>
 *   depois PostgreSQL https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id=3888466
 */

// CONFIGS:
$DOIs = ['10.1016/S1473-3099(16)30318-8', '10.1038/nature22401', '10.1016/S0140-6736(17)31368-5'];
$debug = 0;

$RESULT = []; // "doiCitador,tipoCitado,IDcitado";
$R = [];

foreach ($DOIs as $doi) {
	$url_doi = "http://doi.org/$doi";
	$url = url2redirected($url_doi);
	if ($debug) echo "\n---- $url_doi -------\n to $url";

	$pmc = [];
	if ( preg_match('#^https?://(?:www\.)?([^/]+)/([^/]+)#i',$url,$m) )  {
		switch ("$m[1]/$m[2]") {
		case 'nature.com/nature':
			$pmc = method1($url,$doi);
			break;
		case 'sciencedirect.com/science':
			$pmc = method1($url,$doi);
			break;
		default: if ($debug) echo "\n DESCONHECIDO ($m[1])";	
		} // switch
		$RESULT[] = ['doi'=>$doi, 'n_pmcIds'=>count($pmc), 'pmcIds'=>$pmc];
	} elseif ($debug)
		echo "\n INVALID URL";
}
echo json_encode($RESULT);

//////////

function method1($url,$doi) {
	$hrefs = onlyAnchors($url);
	$pmc1 = IDs2PMC(  getIds($hrefs,'doi',$doi)  );
	$pmc2 = IDs2PMC(  getIds($hrefs,'pmc')       );
	return array_unique( array_merge($pmc1,$pmc2) );
}

function x2dom($xml) {
	$dom = new DOMDocument('1.0', 'UTF-8');
	$dom->formatOutput = true;
	$dom->preserveWhiteSpace = false;
	$dom->resolveExternals = false; // external entities from a (HTML) doctype declaration
	$dom->recover = true; // Libxml2 proprietary behaviour. Enables recovery mode, i.e. trying to parse non-well formed documents
	$ok = @$dom->loadHTML($xml, LIBXML_NOENT | LIBXML_NOCDATA);
	if ($ok) return $dom; else return NULL;
}

function onlyAnchors($file) {
	$all = [];
	$METAchar = '<meta charset="UTF-8"/>';
	$clean = file_get_contents($file);
	$clean = preg_replace('#<script [^>]+>.+?</script>#', '', $clean);
	$clean = strip_tags($clean, '<a>');
	$dom = x2dom("<html><head>$METAchar</head><body>$clean</body></html>");
	$anchors = $dom->getElementsByTagName('a');
	foreach ($anchors as $a) {
		$href = $a->getAttribute('href');
		$all[]= $href;
	}
	return $all;
}


function getIds($all,$idType='doi',$self='',$csv=0,$debug=0) {
	global $doi;
	$IDs = [];
	$regex = [
		'doi'=>'#^https?://((?:dx.)?doi.org|(?:www.)?nature.com/doifinder)/(.+)$#i',
		'pmc'=>'#^https?://((?:www.)?ncbi.nlm.nih.gov)/entrez/query.+?db=PubMed.+?list_uids=(\d+)#i'
	];
	if (isset($regex[$idType]))
		$rgx = $regex[$idType];
	else die("\n ERRO NO idType\n");

	foreach($all as $url) if (preg_match($rgx,$url,$m)) 
		if (!$self || $self!=$m[2]) {
			if ($csv) echo "\n$doi,$idType,$m[2]";
			$IDs[]=$m[2];
		} elseif ($debug) echo "\n -- invalid $url";
	return $IDs;
}


/**
 * Get redirected URL in the case of redirection.
 */
function url2redirected($url) {
	// funcionou
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_HEADER, true);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true); // Must be set to true so that PHP follows any "Location:" header
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

	$a = curl_exec($ch); // $a will contain all headers

	$url = curl_getinfo($ch, CURLINFO_EFFECTIVE_URL); // This is what you need, it will return you the last effective URL
	return $url;
}


/**
 * Converts list of PubMed-ID or DOI into PMC-ID.
 * This service allows for conversion of up to 200 IDs in a single request.
 */
function IDs2PMC($list) {
	if (!count($list)) die("\nERRO IDs2PMC, param vazio\n");
	$pmc=[];
	$URL = 'https://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0/?format=json&tool=my&email=my@my.org';
	$l = join(',',$list);
	// var_dump($list);
	$url  = "$URL&ids=$l";
	$json = file_get_contents($url);
	$obj  = json_decode( $json );
	foreach ($obj->{'records'} as $r)  if (isset($r->pmcid)) 
		$pmc[] = $r->pmcid; //.','.(isset($r->doi)? $r->doi: '');
	return $pmc;
}




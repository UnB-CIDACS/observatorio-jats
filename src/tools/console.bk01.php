<?php
/**
 * CLI interface (console) for some operations of the JATS Observatory.
 */

foreach (glob(__DIR__ . '/../../campanhas/c*/src/console.inc') as $inc)
	require_once($inc);


$HELP = <<<EOHELP
Command-line Interface (CLI) do Observatório JATS
-------------------------------------------------

Comandos:

* quit
* add jou
* serv issn
* list jou
* help
* help add
* help serv
* help ...
EOHELP;
$context='';

$isCli = (php_sapi_name() === 'cli');
print "$HELP\n";

do {
	$cmd = readline("\n#cmd? ");
	list($cmd,$context) = cmd_parse($cmd,$context);
} while($cmd != 'quit');


// // // // // //

function cmd_parse($cmd,$context) {
	$context = trim($context);
	$contextNew = false;
	$delContext = true;
	$params = '';
	// if (preg_match('#^([^\s/]+)\s+(?:(.+)|(/)(.*))$#is',$cmd,$m)) { // ignora context
	if (preg_match('#^(?:(serv)\s+([^\s/]+)(?:[/\s]?(.+))?)|(?:([^\s/]+)\s+(.+))$#is',$cmd,$m)) { // ignora context
		// var_dump($m);
		if ($m[1]=='serv') {
			$context = 'serv';
			$cmd     = $m[2];
			$params  = $m[3];
		} else {
			$context = $m[4];
			$cmd = $m[5];
		}
		$contextNew = true;
	}
	$cmd = trim(strtolower($cmd));
	$msg = "... certo, usando '$cmd'...";
	if (!$context) switch ($cmd) {
	case 'help':
		global $HELP;
		$msg = $HELP;
		break;
	case 'add':
		$msg = "Adicionando algo: jou=revista, art=article, etc.\nuse add X";
		break;
	case 'list':
		$msg = "Listando algo: jou=revistas, a=articles, etc.\nuse list X";
		break;
	case 'serv':
		$msg = "Sevices disponiveis: issn=revista, ...\nuse serv X";
		break;
	case 'q':
	case 'quit':
	  $cmd = 'quit';
		$msg = '... Bye!';
		break;
	default:
		$msg = "comando '$cmd' desconhecido, use help ou quit";
		$cmd='';

	} else {
	if (!$contextNew) print "\n (... ainda no contexto $context ...)";
	//if ($cmd!='help' && $context=='help') $delContext=false;
	$isCli = (php_sapi_name() === 'cli');
	switch ("$context $cmd") {
		case 'serv issn':
			$msg = "Service ISSN-resolver, executando issn/$params:\n";
			$res = new app("issn/$params");
			$msg.="=$res\n!";
			break;
		case 'serv etc':
			$msg = "Service ETC, executando $cmd/$params:\n";
			break;
		case 'help add':
			$msg = "Help do comando '$cmd':\n jou, art, etc.";
			break;
		case 'help issn':
			$msg = "Help do ISSN-resolver ....";
			break;
		case 'help ins':
			$msg = "Help do comando '$cmd':\n jou, jous, articles";
      break;
		default:
			$msg = "context '$context', comando '$cmd' desconhecido";
	}
	}

	readline_add_history($cmd);
	print "\n$msg\n";
	if ($delContext) $context='';
	return [$cmd,$context];
}


/////////////// LIB


class app {
  // CONFIGS:
  var $PG_CONSTR = 'pgsql:host=localhost;port=5432;dbname=obs2';
  var $PG_USER = 'postgres';
  var $PG_PW   = 'postgres';
  // INITS:
  var $status = 200;  // 404 - has not found the input issn.  416 - issn format is invalid.
                      // but 404 is also service-not-found.
  var $isCli;         // set with true when is client (terminal), else false.
  var $outFormat_dft='j';
  var $outFormat;     // j=json|x=xml|t=txt
  var $dbh; // database PDF connection.
  function __construct($uri=NULL) {
    global $isCli;
    $this->isCli = isset($isCli)? $isCli: (php_sapi_name() === 'cli');
    $this->outFormat = $this->isCli? 't': $this->outFormat_dft;
    $this->dbh = new PDO($this->PG_CONSTR, $this->PG_USER, $this->PG_PW);
    if ($uri) $this->runByUri($uri); // dies returing output
  }
  function runByUri($uri) {
    //if ($this->isCli) $uri =rmExtension($uri).".negotiatedExtension; //... future content negotiation.
    $sth = $this->dbh->prepare('SELECT api.run_byuri(?)');
    $sth->bindParam(1, $uri, PDO::PARAM_STR);
    $sth->execute();
    $a = json_decode( $sth->fetchColumn(), true); // even XML is into a JSON package.
    if (isset($a['status']) && $a['status']>0)
      $this->status    = $a['status'];
    if (isset($a['outFormat']))
      $this->outFormat = substr($a['outFormat'],0,1);
    $this->die($a['result']); // send string or array
  }
  /**
   * Ending REST API by die() with a message and coorect HTTP status.
   * @param $msg string or array with returning data from API (or standard error package).
   * @param $newStatus integer optional, (will use?) to change of HTTP-status.
   * @param $errCode integer, NOT IN USE... ERRROR when $this->status!=200 or as WARNING when $errCode!=0.
   */
  function die($msg,$newStatus=0,$errCode=0) {
    $outFormatMime = ['j'=>'application/json', 'x'=>'application/xml', 't'=>'text/plain'];  // MIME
    if ($newStatus)
      $this->status = $newStatus;
    if ($this->status==200 || !$this->status) {
      if ($this->outFormat=='x' || $this->outFormat=='t') {
        if (is_array($msg)) $msg = join($msg,','); // supposing only txt case and 1 level of array.
        $OUT = ($this->outFormat=='x')? $msg: "\n$msg\n";
      } else
        $OUT = json_encode($msg);
    } elseif ($this->isCli) // display error at terminal:
        die("\nERROR (status {$this->status}) $errCode: $msg\n");
    else {                  // display error at Web:
      http_response_code($this->status);
      if ($errCode) // not in use
        $OUT = ($this->outFormat=='j')?
          "{'errCode':$errCode,'errMsg':'$msg'}":
          "<api errCode='$errCode'><errMsg>$msg</errMsg></api>";
    }
    if (!$this->isCli) header("Content-Type: {$outFormatMime[$this->outFormat]}");
    die($OUT);
  } // func
} // class
?>

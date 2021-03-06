<?php
/*

===
- (resgatar ) E-mail para os candidatos a associados efetivos.

Sobre as balas perdidas no Rio de Janeiro, já se demonstrou que as balas perdias não são tão perdidas assim,
" O Brasil é um país em que os corruptos seriais assumiram o comando.
  A podridão moral deles é o fio invisível que dirige a bala	(...)
", R.P.Toledo
===

*/


/**
 * CLI interface (console) for some operations of the JATS Observatory.
 */

//require_once('console_CmdClass.inc');

// command-name = array['param1','param2',..., msg]
$COMMANDS = [
		'quit' =>['... Bye!'],
		'help' =>['_context_','msg help'],
		'list' =>["Listando algo: jou=revistas, a=articles, etc.\nuse list X"],
		'add'  =>['_context_', "Adicionando algo: jou=revista, art=article, etc.\nuse add X"],
		'list' =>['_context_',''],
		'serv' =>['_context_',''],
		'serv' =>['_context_',''],
];

foreach (glob(__DIR__ . '/../../campanhas/c*/src/console.inc') as $inc)
	require_once($inc);

$context='';
$HELP = "Command-line Interface (CLI) do Observatório JATS
-------------------------------------------------\n
Comandos:";
foreach ($COMMANDS as $i=>$a) {
	array_pop($a);
	$HELP .= "\n * $i ".join(' ',$a);
}

$isCli = (php_sapi_name() === 'cli');
print "$HELP\n";

do {
	$line = readline("\n#cmd? ");
	list($cmd,$params) = cmd_parse($line);
	//print "\n\t\tcmd='$cmd'\n";
} while($cmd != 'quit');


// // // // // //

function cmd_parse($line) {
	global $isCli;
	global $COMMANDS;
	$contextNew = false;
	$delContext = true;
	$params = '';
	$cmd_std = strtolower(trim($line));
	if (preg_match('/^\s*(\w+)(?:\s+(.+))?$/s',$cmd_std,$m)) {
		return isset($m[2])? [$m[1],$m[2]]: [$m[1],''];
	} else return ['',''];
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

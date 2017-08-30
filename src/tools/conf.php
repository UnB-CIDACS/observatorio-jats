<?php
/**
 * Basic and default configurations.
 */


// global settings:
//setlocale(LC_ALL, 'pt_BR');
mb_internal_encoding('UTF-8');

//define('PG_CONSTR_ISSN',     'pgsql:host=localhost;port=5432;dbname=issnl');
define('PG_CONSTR_OBSJATS',  'pgsql:host=localhost;port=5432;dbname=obsjats');
define('PG_DFT_USER','postgres');
define('PG_DFT_PW',  'postgres');

$is_cli = (php_sapi_name() === 'cli');  // true when is client (terminal).

$outFormatMime = ['j'=>'application/json', 'x'=>'application/xml', 't'=>'text/plain'];
$status = 200;
?>

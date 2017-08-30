<?php
/**
 * CLI de menu de comandos para as tools. Ver tools.yaml.
 */

include 'tools_lib.php';

$CMD_MENU = yaml_parse_file('tools.yaml');
$isCli = (php_sapi_name() === 'cli');
$notini = 0;
$cmd_path = [];
$cmd='';
do {
	if ($notini) {
    print "\nOpção? # ";
    $opt = readline();
  } else $opt='';
  $cmd_path = parse_cmd($opt,$cmd_path); // aqui diz se era menu
  $lst = cmd_menu_parseItem($cmd_path);  // pega context global
  $cmd = end($cmd_path); // null se nada
  //if ($cmd) { print "\n? rodei '$cmd'?"; }
  $notini =1;
} while($cmd != 's'); // s de "sair"

print "\n";

//////

/**
 * Converte opção em label.
 */
function parse_cmd($cmd, $ctx) {
    global $CMD_MENU;
    $cmd= trim(strtolower($cmd));
    $n = count($ctx);
    if (ctype_digit($cmd)) {
      if ( $n==1 && isset($CMD_MENU[$ctx[0]]) )
        $LST = $CMD_MENU[$ctx[0]];
      elseif ( $n==2 && isset($CMD_MENU[$ctx[0]][$ctx[1]]) )
        $LST = $CMD_MENU[$ctx[0]][$ctx[1]];
      $k = array_keys($n? $LST['_params']: $CMD_MENU);
      $cmd = $k[$cmd-1];
    }
    return $cmd? array_merge($ctx, [$cmd]): $ctx;
}

/**
 * Afeta $context.
 * Mostra as opções ou roda o comando.
 */
function cmd_menu_parseItem($cmd_path,$dftmsg='Menu principal') {
    global $CMD_MENU;
    $error = 0;
    $LST=NULL;
    $cmd_path_n = count($cmd_path);
    if (!$cmd_path_n) {
      $LST = $CMD_MENU;
      $title = $dftmsg;
      $isMenu = true;
    } else {
      print "\n\n ------ debg n=$cmd_path_n=".join("/",$cmd_path);
      if ( $cmd_path_n==1 && isset($CMD_MENU[$cmd_path[0]]) )
        $LST = $CMD_MENU[$cmd_path[0]];
      elseif ( $cmd_path_n==2 && isset($CMD_MENU[$cmd_path[0]]['_params'][$cmd_path[1]]) )
        $LST = $CMD_MENU[$cmd_path[0]]['_params'][$cmd_path[1]];
      elseif ( $cmd_path_n==3 && isset($CMD_MENU[$cmd_path[0]]['_params'][$cmd_path[1]]['_params'][$cmd_path[2]]) )
        $LST = $CMD_MENU[$cmd_path[0]]['_params'][$cmd_path[1]]['_params'][$cmd_path[2]];
      if ($LST===NULL) $error=5;
      $title = $LST['_title'];
      $isMenu = ($LST['_func']=='_menu');
	if ($isMenu) $LST = $LST['_params'];
    }
    if ($error) { die("\nERRO $error\n"); }
    if ($isMenu) {
      print "\nEscolha uma das seguintes opções de $title:";
      $i = 0;
      $ret = [];
      foreach ($LST as $item=>$r) {
          $i++;
          print "\n $i. $item - {$r['_title']}";
          $ret[]=$i;
      }
      print "\n Digite o número da opção, 'v' para voltar ou 's' para sair.";
      $ret[]='v';
      $ret[]='S';
      return $ret;
    } else {
      print "\nEXECUTANDO FUNCAO '$LST[_func]': ";
$params = $LST['_params'];
      if (isset($LST['_params_flags']) && $LST['_params_flags']=='input') 
	$params[] = readline('mais esse parametro# ');
      
	call_user_func($LST['_func'],$params);
      
    }
}




/*
.. agora que decidiu o que quer e rodou... Simplificar algoritmo! Carregar o fragmento de array ... e usar recorrencia
''  = menu
'tmp' = menu[tmp]
'tmp/xml' = menu[tmp][xml]

*/

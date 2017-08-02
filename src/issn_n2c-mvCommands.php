# Script shell com comandos para renomear ISSNs erraoddos. 
# Gerado por:   ls | php conv.php > convPerigo.sh
#
<?php
fwrite(STDERR, "\n... Aguarde, conferindo cada um dos itens... \n\t(resultados shell no STDOUT)\n" );
$n=$ndiff=0;
foreach (file('php://stdin') as $line) if (preg_match('/([0-9][0-9\-Xx]*)/s',$line,$m)) {
	$n++;
	$issn  = $m[1];
	$issnL = trim( file_get_contents("http://api.ok.org.br/issn/$issn/n2c.txt") );
	if ($issnL && $issn!=$issnL) {$ndiff++; echo "\nmv $issn $issnL"; }
	//else echo "\n# pasta $issn fica como esta";
}
echo "\n#  final, $ndiff (de $n) dos códigos ISSN não eram canônicos, devem ser convertidos para ISSN-L\n";


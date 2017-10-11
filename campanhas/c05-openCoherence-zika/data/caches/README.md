
## Preparo

### pmc_result-zikaFull-2017-08-trans.csv

Processamento da pasta local da campanha  `src/getArtType-byPMC.php`. 

Alguns itens não são convertidos por não corresponderem a artigos de fato. A sua linha fica com "0" e fazio, exceto pelo DOI. Exemplos: 
* O DOI não existe, http://doi.org/10.1038/srep43527  
* Formato *folder* de uma folha, http://doi.org/10.2471/BLT.16.001116
* Multi-article (extractos) http://doi.org/10.1073/pnas.ss1143

São mantidos no arquivo CSV apenas para rastreabilidade, podendo ser omitidos no uso final.



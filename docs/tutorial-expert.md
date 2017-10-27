# Tutorial para o técnico expert

&nbsp; ![](assets/experts.png)

Na equipe das campanhas são necessários dois atores, o curador e o expert. Este tutorial tem como público-alvo os experts: requer conhecimentos mínimos no uso do terminal Linux e da linguagem SQL. É um complemento do [tutorial do curador](tutorial-curador.md) pois estaremos abordando os mesmos exemplos.

Os experts podem ainda se limitar à análise final dos dados (ex. estatísticos), ou apenas dar suporte para a instalação. As partes deste tutorial que não couberem a sua expertise podem ser saltadas.

## Instalação geral e dos dasets externos

A instalação local pode ser interessante para gerar e conferir dados que serão depois publicados no *git*, na pasta da respectiva campanha.

O primeiro passo para instalar (local ou remotamente) é seguir a [instalação básica com configuração](https://github.com/datasets-br/sql-unifier#configurating), com o  **[`conf.json` do tutorial](../data/tutorial/conf.json)**.

## Instalação dos datasets da campanha

Os datasets de uso geral ficam no SQL SCHEMA `dataset`, e os datasets específicos (sem reuso) de cada campanha, ficam no respectivo dataset. No exemplo do tutorial o código da campanha é `c05`, de modo que esse fica sendo também o SCHEMA. Deve-se proceder manualmente a inicialização `CREATE SCHEMA c05` com o `psql`.

Quando os _datasets_ se encontram devidamente descritos num `databackage.json` online, basta inclui-los na configuração já descrita acima. Para o caso de pastas locais, acrescentar em `"local"` ao invés de `"github.com"`.

Quando existe apenas o `minhaTabela.csv`, sem uma descrição formal, pode-se acrescentar automaticamente como tabela SQL `dataset.minhaTabela` no banco de dados via `"local-csv"`. Exemplificando:

```json
"github.com":{ "...":"..." },
"local":{"/home/user/sandbox/cbh-codes":null},
"local-csv":["../minhaTabela.csv"],
```

O *local-csv* é realizado via *csvkit*. Por exemplo a inclusão do *minhaTabela* equivale a realizar

```sh
csvsql --db "postgresql://postgres:postgres@localhost:5432/obsjats" --insert --db-schema c05 minhatabela.csv
```
A vantagem aqui é que podemos indicar o schema correto, que no caso foi o `c05`.

## Instalação da lista bibliográfica do PubMed

Outras opções de pesquisa e inclusão de JATS são válidas. Como, todavia, o PubMed é o repositório maior e com oferta de ferramenats mais completas, é interessante começar pelo seu uso.

No [tutorial do curador](tutorial-curador.md) é melhor indicado o processo de busca, aqui podemos suporte que a lista dos artigos já foi obtida.

### Arquivo Flink
O exemplo to tutorial do curador é o arquivo [pubMed_resultMax-Zika-2017-10.csv](../data/tutorial/original/pubMed_resultMax-Zika-2017-10.csv).  Pode-se utilizar a ferramenta `csvcut` do *CSVkit* para analisar e cortar, gereando uma versão bem mais reduzida (de ~1M para ~ 50K) do arquivo.

```
wc -l pubMed_resultMax-Zika-2017-10.csv
3413 pubMed_resultMax-Zika-2017-10.csv

csvcut -n pubMed_resultMax-Zika-2017-10.csv
  1: UID
  2: Authors
  3: PubDate(Year)
  4: PubDate(Month)
  5: Title
  6: Summary

# realizando o corte para a coluna UID (que é sinônimo de PMID) e o ano:
csvcut -c 1,3 pubMed_resultMax-Zika-2017-10.csv  > pubMed_resultMax-Zika-2017-10-cut.csv

ls -lh pubMed_resultMax-Zika-2017-10*
... 1,3M Out 27 03:36 pubMed_resultMax-Zika-2017-10.csv
...  47K Out 27 03:39 pubMed_resultMax-Zika-2017-10-cut.csv
```

Conforme o tipo de análise, de qualquer forma, a tabela inicial pode ser interessante para listar perfil dos artigos (ex. PubDate Year), o que precisa ser conferido com a curadoria. Para a base de dados convém renomear o *header* (ex. via `nano`)  para rótulos mais simples, por exemplo `uid,year`, o que permite enfim incluir como tabela do esquema `c05` e obter um primeiro resultado:

```sh
psql "postgresql://postgres:postgres@localhost:5432/obsjats"
CREATE SCHEMA c05;
\q

csvsql --db "postgresql://postgres:postgres@localhost:5432/obsjats" \
   --insert --db-schema c05 data/tutorial/original/pubMed_resultMax-Zika-2017-10.csv
```

```sql
SELECT year, count(*) as n
FROM c05."pubMed_resultMax-Zika-2017-10-cut" -- where year>=2000
group by 1 order by 1;
```

year |  n   
-----|------
2001 |    2
...  |  ...
2013 |    3
2014 |   27
2015 |   37
2016 | 1641
2017 | 1626

Ver tabela completa em [c05_res01_1-BySql.csv](../data/tutorial/c05_res01_1-BySql.csv).

Outra análise solicitada foi o refinamento da pesquisa, para suspeitos de falto-positivo quanto ao tema Zika-virus. O resultado da query abaixo está em [c05_res01_2-BySql.csv](../data/tutorial/c05_res01_2-BySql.csv).

 ```sql
 SELECT uid, 'forest' as theme, pub_year, summary  
 FROM c05."pubMed_resultMax-Zika-2017-10"
 WHERE summary ilike '%forest%' OR title ilike '%forest%'
 UNION
 (SELECT uid, 'birds' as theme, pub_year, summary  
 FROM c05."pubMed_resultMax-Zika-2017-10"
 WHERE summary ilike '%bird%' OR title ilike '%bird%' OR summary ilike '%ornitholog%' OR title ilike '%ornitholog%')
 ORDER BY 3,1;
```
Os resultados podem ser exportados por `COPY (SELECT ...) TO '/tmp/arquivo.csv' CSV HEADER`.

## Analisando perfil ISSNs

A ferramenta *getArtType-byPMC*  cria, a partir da listagem dos PMIDs, uma tabela PMID-ISSN-Tipo-data, para termos, antes de se restringir ao JATS, um perfil da distribuição do universo de artigos entre as diferentes revitas. Como se baseia no uso de API pode ser demorado (da ordem de 10 minutos o milhar).

```sh
php src/tools/getArtType-byPMC.php < data/tutorial/original/pubMed_resultMax-Zika-2017-10.csv \
  > data/tutorial/c05_res02_1-getIssn.csv

csvsql --db "postgresql://postgres:postgres@localhost:5432/obsjats" \
       --insert --db-schema c05  data/tutorial/c05_res02_1-getIssn.csv  
```

A nova tabela foi copiada em [c05_res02_1-getIssn.csv](../../data/tutorial/c05_res02_1-getIssn.csv). Os valores obtidos podem ser conferidos com os originais (checagem de ano por exemplo) e os ISSNs transformadors em ISSN-Ls para normalização.

Conferindo no SQL

```sql
-- lista de casos inconsistentes por ano:
SELECT r.*, z.pub_year
FROM c05."pubMed_resultMax-Zika-2017-10" z INNER JOIN c05."c05_res02_1-getIssn" r
     ON z.uid=r.pmcid WHERE substring(pubdate::text,1,4)!=z.pub_year::text
;

-- lista de quantidade por tipo
SELECT  pubtype, count(*) as n FROM c05."c05_res02_1-getIssn" group by 1 order by 2 desc;

-- lista pubtype não-esperado
SELECT r.*, z.summary
FROM c05."pubMed_resultMax-Zika-2017-10" z INNER JOIN c05."c05_res02_1-getIssn" r
  ON z.uid=r.pmcid
WHERE r.pubtype NOT IN (
  'Journal Article', 'Historical Article', 'Evaluation Studies',
  'Clinical Trial', 'Review'
);
```
Tabelas de resultados  sequência das consultas:

pmcid   |   issn    |     pubtype     |  pubdate   | pub_year
----------|-----------|-----------------|------------|----------
27795432 | 0022-538X | Journal Article | 2016-12-16 |     2017
28119857 | 2235-2988 | Journal Article | 2017-01-09 |     2016
28269838 | 1942-597X | Journal Article | 2017-02-10 |     2016
28269870 | 1942-597X | Journal Article | 2017-02-10 |     2016
28417097 | 2332-8940 | Comment         | 2016-08-05 |     2017

pubtype       |  n   
--------------------|------
Journal Article    | 2743
Letter             |  272
Editorial          |  149
News               |   92
Comment            |   85
Evaluation Studies |   22
Historical Article |   17
Published Erratum  |   13
(NULL)|    6
Interview          |    4
Biography          |    2
Congresses         |    2
Clinical Trial     |    2
Review             |    2
Practice Guideline |    1

Lista dos pubtypes não-esperados em [c05_res02_2.csv](../../data/tutorial/c05_res02_2.csv).

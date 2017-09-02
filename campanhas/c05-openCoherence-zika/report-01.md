# Relatório 01 da Campanha C05

*Contagens e avaliação estatística das amostragens*

São apresentadas as consultas e os resultados obtidos.

* Curador responsável: Ricardo.
* Expert responsável: Peter.

## Sumário das contagens ##

Conforme exposto na seção "[Levantamento de artigos sobre Zika](README.md#levantamento-de-artigos-sobre-zika)" da apresentação desta campanha, o universo foi obtido de uma busca no PubMed. Conforme dados do PMC, na data de realização da pesquisa existiam 14107 revistas (ISSN-Ls) com artigos catalogados. A pesquisa apresento resultados para 516 revistas diferentes.

Na base de dados foram conseguidos por download (via API do PMC) 2405 artigos em JATS. Alguns full-text outros apenas front-back.

* `n_arts=2405` (96% do universo inicial pesquisado)
* `n_has_body=2032` e `n_has_permiss=2032` (84,5% de n_arts)
* `n_useful1=2032` (84,5% de n_arts), contagem de  *`has_body` and `has_permiss`*
* `n_hasRefs=1778` (73,9% de n_arts)
* `n_useful2=1667` (69,3% de n_arts), contagem de  *`hasRefs` and `useful1`*
* `n_isValid=1940` (80,7% de n_arts)
* `n_useful3=1444` (60,0% de n_arts), contagem de  *`isValid` and `useful2`*

Com relação a unicidade dos artigos,
* `n_doi=2229 =n_uniq_doi` (% de n_arts)
* `n_no_doi=176`  (% de n_arts)  podem ser controlados pelo PMC-ID ou outro recurso.

Portanto  é sugerido o controle via DOI no presente levantamento.

Quanto à filtragem `n_isValid` houve certa arbitrariedade na eleição do que seriam tipos de documento válidos:

    article_type    |  n   
--------------------|------
research-article    | 1543
review-article      |  264
editorial           |  123
brief-report        |   97
letter              |   79
other               |   61
news                |   43
article-commentary  |   43
case-report         |   36
abstract            |   29
discussion          |   25
in-brief            |   20
correction          |   16
meeting-report      |    9
book-review         |    5

A restrição de *research-article, review-article, brief-report* e _case-report_ resultou no total de 1940.

```sql
SELECT count(*) as n_jous from core.journal_repository; -- 14107 universo de issn's catalogado

SELECT count(*) as n_arts     FROM core.article;--  2405
SELECT count(*) as n_has_body    FROM kx.vw_article_metas1_sql WHERE has_body; -- 2032
SELECT count(*) as n_has_permiss FROM kx.vw_article_metas1_sql WHERE has_permiss; -- 2032
SELECT count(*) as n_useful1     FROM kx.vw_article_metas1_sql WHERE has_body and has_permiss; -- 2032
SELECT count(*) as n_hasRefs  FROM kx.vw_article_metas1_sql WHERE n_refs>1; -- 1778

SELECT count(*) as n_useful2 FROM kx.vw_article_metas1_sql
WHERE has_body and has_permiss and n_refs>1;--   1667

SELECT count(*) as n_isValid FROM kx.vw_article_metas1_sql
WHERE article_type IN ('research-article', 'review-article', 'brief-report','case-report');--   1940

SELECT count(*) as n_useful3 FROM kx.vw_article_metas1_sql
WHERE has_body and has_permiss and n_refs>1 and
      article_type IN ('research-article', 'review-article', 'brief-report','case-report');--   1444

-- -- -- --
SELECT count(*) "n_hasLicense"
FROM core.article
WHERE xmlexists('//article/front//license' PASSING BY REF content); -- 1811

SELECT count(*) "n_hasCopyright"
FROM core.article
WHERE xmlexists('//article/front//copyright-statement' PASSING BY REF content); -- 1856

SELECT count(*) as n_arts,  count(doi) as n_doi,
       count(distinct doi) n_uniq_doi, sum((doi is null)::int) no_doi
FROM kx.vw_article_metas1_sql; -- 2405 |       2229|  2229 |    176
```

Demais consultas e respectivos arquivos CSV ver ...

## Refs apoio

* https://jats.nlm.nih.gov/publishing/tag-library/1.1/element/license.html
* ...

## Resultados parciais

Dump dos _datasets_ em [c05-openCoherence-zika/data](https://github.com/UnB-CIDACS/observatorio-jats/tree/master/campanhas/c05-openCoherence-zika/data): `issn_count1.csv`, `licenses_used.csv`, `pmc_result-zikaFull-2017-08.csv`. Disponíveis também [planilha ](https://docs.google.com/spreadsheets/d/1UWjhYxrD5D2SBFFhtiT2QhiI3vG6Y2QTZ7YF7wULO0Y/).

Revistas com mais de 30 artigos, totalizando ~1/3 do universo de `n_arts=2405`.

[ISSN-L](https://en.wikipedia.org/wiki/International_Standard_Serial_Number#Linking_ISSN)    | `n_arts` | `n_useful3` | Nome da revista
----------|-----|---------------|---------
1935-2727 | 209 | 183 | PLoS neglected tropical diseases
2045-2322 | 127 | 125 | Scientific reports
1080-6040 | 115 | 0   | Emerging infectious diseases - EID
1932-6203 | 106 | 103 | PloS one
0042-9686 | 91 | 10 | Bulletin of the World Health Organization
1756-3305 | 70 | 70 | Parasites & vectors
0027-8424 | 47 | 0  | PNAS, Biological Sciences
0022-538X | 46 | 6  | Journal of virology
1553-7366 | 41 | 36 | PLOS pathogens / Public Library of Science
1664-302X | 41 | 37 | Frontiers in microbiology
0002-9637 | 36 | 11 | The American journal of tropical medicine...
1471-2334 | 34 | 34 | BMC infectious diseases
1999-4915 | 31 | 30 | Viruses

Quando são impostas todas as restrições (vide definição de `n_useful3`), algumas evistas deixam de ser amostradas, e outras perdem uma parte significativa da sua amostragem.

Apesar da cobertura inicial ter apresentado 516 revistas diferentes, após a filtragem apenas 310 revistas apresentaram um ou mais artigos.

## Tabela de metadados

Para maiores detalhes ver implementação da SQL-VIEW `kx.vw_article_metas1` em [step03-kxbuild.sql](../../src/step03-kxbuild.sql).

nome        | [XPath](https://en.wikipedia.org/wiki/XPath) | Notas
------------|-----------|--------
n_articles  | `count(//article)` |validador, esperado sempre 1
article_type| `//article/@article-type`| foco em "research-article" e similares
doi         | `//article/front/article-meta/article-id[@pub-id-type="doi"]/text()`
year        | `//article/front//pub-date/year/text()` | eleição arbitrária do primeiro
volume      | `//article/front//volume/text()`
issue       | `//article/front//issue/text()`  | não-obrigatório
title       | `//article/front//article-title//text()` | obrigatório
...         | ...


Os elementos do XPath podem ser consultados em [jats.nlm.nih.gov/publishing/tag-library/1.1](https://jats.nlm.nih.gov/publishing/tag-library/1.1/index.html).

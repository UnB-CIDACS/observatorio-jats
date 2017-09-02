# Relatório 02 da Campanha C05

*Obtenção das licenças dos artigos e cálculo da OpenCoherence do conjunto*

A partir da revisão metodológica foram definidos índices e algorítimos. Os resultados obtidos são apresentados.

* Curador responsável: Ricardo.
* Expert responsável: Peter.

## Levantamentos preliminares

Conforme a metodologia descrita por Krauss (2015) as licensas dos artigos JATS em geral podem ser deduzidas diretamente da URL apresentada na tag license. Na contagem sobre o universo total, usando `n_hasLicUrl` conforme abaixo ... e a [tabela de metadados do *report-01*](report-01.md#tabela-de-metadados).

* `n_arts=1444` número de artigos no universo filtrado.
* `n_hasLicUrl=937` (65% de n_arts)

Como o número restante, ~500 (35%), ainda é elevado e a obtenção direta de URL pode levar a erros de  interpretação em textos de licença, optou-se por revisar de forma sistemática todos os textos.

```sql
SELECT count(*) as n_arts      FROM kx.c05_article; --  1444
SELECT count(*) as n_hasLicUrl FROM kx.c05_article WHERE license_url is not null; --  937

-- comparando com o universo
SELECT count(*) as n_hasLicUrl FROM kx.vw_article_metas1_sql WHERE license_url is not null; --  1166
```

## Revisão metodológica e algoritmos ##
...
### Reconhecimento da licença e sua família

1. Confere se a URL fornecida pode ser resolvida pelos _datasets_ disponíveis (`tmpcsv_license_urls`).

2. Confere se o texto de licensa fornecido pode ser resolvida pela avaliação humana realizada (_dataset_ `data/liecenses_used.csv` do c05).

3. Complementa-se os _datasets_ dos itens 1 ou 2 no sentido de garantir o máximo ou a totalidade das resoluções de licensas.

Uma vez concluído o reconhecimento das licensas, um relatório de frequência e confiabilidade das resoluções é emitido.

```sql
-- resolução da licensa fornecida diretamente pela sua URL
SELECT count(*) as n
FROM kx.c05_article
WHERE license_url IS NOT NULL AND lib.url_tocmp(license_url) IN (
    SELECT lower(url) FROM tmpcsv_license_urls
);
```
### Reconhecimento da família e cálculos de score
A resolução de família é dada pelo _dataset_ [ppKrauss/licenses/data/licenses.csv](https://github.com/ppKrauss/licenses/blob/master/data/licenses.csv), e os scores de família por uma tabela similar a [ppKrauss/licenses/data/families.csv](https://github.com/ppKrauss/licenses/blob/master/data/families.csv).  A eleição de scores foi revista em função da ordenação mais praticada atualmente, expressa pelo *"Creative Commons license spectrum"*:

![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Creative_commons_license_spectrum.svg/148px-Creative_commons_license_spectrum.svg.png)

## Resultados
...

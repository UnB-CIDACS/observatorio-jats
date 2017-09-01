---
id: c005
type: apresentação de campanha
version: 0.0.1
version_status: DRAFT
endorsed_n: 0
endorsed_status: no endorsement
layout: page
---

# Campanha observacional da OpenCoherence dos artigos sobre Zika virus

**Objetivo**: levantamento sistemático dos artigos sobre Zika e análise OpenCoherence do subconjunto de  artigos disponível em full-text JATS.

**Inicio**: 2017-08-06

## CURADORES

* Peter Krauss ([ppkrauss](https://github.com/ppkrauss) - Open Knowledge Brasil)
* Ricardo Barros Sampaio (rsampaio.br@gmail.com - UnB)
* Jorge H. C. Fernandes (jhcf@unb.br - UnB)
* ... estamos aguardando a sua participação!  

## Origem e motivações do projeto

Na presente campanha elegeu-se o tema Zika por ser um dos temas de maior relevância para a Fiocruz em 2017, e por não ter sido realizado, até o momento, um levantamento sistemático do "acervo JAST" em torno deste tema. Também em 2017 foi implementada na Fiocruz uma política de *dados abertos*, e durante sua implementação surgiram  questionamentos quanto à efetividade da publicação de pesquisas em revistas abertas.

Não existem trabalhos que comprovem causa-efeito do grau de abertura de um acervo de conhecimento científico, justamente porque não existem métricas objetivas para esse "grau de abertura". O alvo da campanha é portanto o cálculo de grau de abertura deste acervo JATS temático, tanto para aferição nos artigos individuais como nos artigos em conjunto.

### OpenCoherence dos artigos

Artigos científicos indexados em bases de dados abertas, como PubMed Central e SciELO, têm acesso gratuito e garantido por décadas. Esses bancos de dados são considerados repositórios de acesso aberto, nos quais o ato de registro assume uma licença aberta.

Para aqueles que esperam fazer pleno uso do documento (ler, entender, reutilizar e redistribuir), o direito de acesso expresso pela licença pode ser insuficiente. Idealmente, o mesmo direito de acesso seria observado aos anexos, figuras e tabelas, bem como nos documentos citados e referenciados. O documento depende destes objetos (seus componentes internos e documentos externos que cita), mas eles possuem suas próprias licenças.

Para o usuário do documento, as licenças das dependências não devem apresentar restrições adicionais ao uso: este é o princípio sobre o qual reside o [conceito de OpenCoherence](https://doi.org/10.5281/zenodo.57253), isto é, a coerência da licença de um documento com as licenças de sua dependências.

O [projeto](https://github.com/ppKrauss/openCoherence), iniciado com apoio da Open Knowledge Brasil em 2015, já determinava uma métrica  para o cálculo de grau de abertura em documentos JATS, de modo que foi natural a sua extensão no Observatório JATS.

### Zika Virus como tema

... Aguardando estudos e justificativas do Ricardo...

--------

## METODOLOGIA
... Aguardando Ricardo...

### Levantamento de artigos sobre Zika

A grosso modo o universo foi obtido de uma busca no PMC (link do engine?) com

    "zika" or "ZIKV" or "zikavirus"

que resultou na [listagem `pmc_result-zikaFull-2017-08.csv`](https://github.com/UnB-CIDACS/observatorio-jats/blob/master/campanhas/c05-openCoherence-zika/data/pmc_result-zikaFull-2017-08.csv) de 2506 artigos.

### Critérios do acervo JATS

Considera-se amostra o artigo JATS que apresente minimamente:

* tags gerais `<front>`, `<back>` e `<body>`
* `front` com confirmação do ISSN da revista onde foi resgatado.
* `front` com tag `<permission>` para que possa ser avaliado o grau de abertura do artigo, mesmo que apenas confirmando a licença default da revista.
* `body` com volume mínimo de texto e mínomo de seções, conforme padrões mínimos de um *research article*.
* `back` com mais de uma referência na sua `<ref-list>`.

### Cálculo e comparação de índices gerais

... ver refs e melhoras ...

### Cálculo da OpenCoherece de cada artigo

...

------

## ENDOSSOS

Endossos e revisores desta página

Além dos [revisores listados no histórico de *commits* deste documento](https://github.com/UnB-CIDACS/observatorio-jats/commits/master/campanhas/c01-corpusFioCruz), curdores que endossaran o seu conteúdo em uma determinada versão:

* ...

* Você curador: edite o arquivo para acrescentar **seu nome aqui**, precisamos no mínimo 2 curadores **endossando** (atestando que concorda com todo o contedo acima) para dar continuidade ao processo.

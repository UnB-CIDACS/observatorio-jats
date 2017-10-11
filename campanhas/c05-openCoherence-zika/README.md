---
id: c005
type: apresentação de campanha
version: 0.2.0
version_status: DRAFT
endorsed_n: 0
endorsed_status: no endorsement
layout: page
---

# Campanha observacional da OpenCoherence dos artigos sobre Zika virus

**Objetivo**: levantamento sistemático dos artigos sobre Zika e análise OpenCoherence do subconjunto de  artigos disponível em full-text JATS.

**Inicio**: 2017-08-06

## CURADORES

* Ricardo Barros Sampaio (rsampaio.br@gmail.com - UnB)
* Peter Krauss ([ppkrauss](https://github.com/ppkrauss) - Open Knowledge Brasil)
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

Ao declarar emergência internacional de saúde pública com o surto do vírus Zika, a OMS propiciou o surgimento de um novo momento para a Ciência no campo da saúde, a aceleração da geração de conhecimento para atender a uma epidemia.

Aparentemente essa aceleração garantiu a publicação de conteúdos com licenças abertas, principalmente entre 2016 e 2017; no entanto, essa aceleração, mesmo tendo gerado conteúdos com licenças abertas na maior parte dos casos, não parece ter resultado no mesmo grau de abertura nas dependências dos artigos, principalmente porque o tema recar citação de obras de áreas diferentes, fora desse universo mais aberto e dos efeitos da aceleração. Portanto é esperada a observação de nítida perda de coerência de abertura para as obras sobre Zika deste período.

--------

## METODOLOGIA

O levantamento sistemático requer garantia de .. e .. precisão e completeza (fig).. 
Resumindo num pass-a-passo

1. Preparo dos critérios e contexto histórico: o termo *Zika virus* se tornou um "padrão *de facto*" para a rotulação do tema, o que permite o uso eficiente de por palavra-chave. Em termos históricos sabe-se que o Zika não era conhecido antes da epidemia deflagrada em 2016, e que sua descoberta não pode ter sido anterior à década de 2000.
 
2. Levantamento do acervo de artigos sobre o tema: busca nas principais fontes de indexação de artigos científicos.

3. Normalização dos identificadores dos artigos (por DOI ou PMCID).

4. ...

6. ... artigos OpenAccess (artigos de revistas que receberam o selo DOAJ) ...


### Levantamento de artigos sobre Zika

A grosso modo o universo foi obtido de uma busca no PMC (link do engine?) com

    "zika" or "ZIKV" or "zikavirus"

que resultou na [listagem `pmc_result-zikaFull-2017-08.csv`](https://github.com/UnB-CIDACS/observatorio-jats/blob/master/campanhas/c05-openCoherence-zika/data/pmc_result-zikaFull-2017-08.csv) de 2506 artigos.

### Hiopóteses sobre os artigos

* Critério de exclusão para confirmar que o artigo versa sobre Zika: abstract ou palavras-chave fixadas pelo autor devem conter termos-chave.
 
* Critério para confirmação: média de referências por artigo que citam demais artigos do "grupo Zika".

* Efeitos da amostragem: ao reduzir o universo aos artigos OpenAccess, não haveria apenas uma redução no tamanho da amostra, mas também efeitos sobre a distribuição do assunto. Um dos efeitos relavantes e mensuráveis seria a diversidade.  Usando os índices de Pielou para equitativodade e de Simpsom para dominância, pode-se caracterizar com precisão o comportamento médio de amostras aleatórias, e o efeito do filtro OpenAccess. 


### Critérios do acervo JATS

Considera-se amostra o artigo JATS que apresente minimamente:

* tags gerais `<front>`, `<back>` e `<body>`
* `front` com confirmação do ISSN da revista onde foi resgatado.
* `front` com tag `<permission>` para que possa ser avaliado o grau de abertura do artigo, mesmo que apenas confirmando a licença default da revista.
* `body` com volume mínimo de texto e mínomo de seções, conforme padrões mínimos de um *research article*.
* `back` com mais de uma referência na sua `<ref-list>`.

### Cálculo e comparação de índices gerais

... ver refs e melhoras ...

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

---
title: Apresentação da Campanha 004
version: 0.0.1
version_status: DRAFT
endorsed_n: 0
endorsed_status: no endorsement
layout: page
---

# Campanha observacional de testes e consistência estrutural de uma coleção JATS

**Objetivo**: Realizar testes sobre a infraestrutura do Observatório JATS, e estabelecer parâmetros e metodologia para se conferir a consistência estrutural dos conteúdos JATS de uma coleção em análise nesta infraestrutura.

**Inicio**: 2017-08-06

## CURADORES

* Peter Krauss ([ppkrauss](https://github.com/ppkrauss))
* ... estamos aguardando a sua participação!  

## Origem e motivações do projeto

A recuperação de artigos isolados ou acervos inteiros de artigos JATS nem sempre é simples e direta, conforme [exemplos de procedimento realizados por usuários](https://opendata.stackexchange.com/a/6503/1313). Através de APIs de solicitação de artigos pode resultar em falhas de transmissão (ex. falha na transcrição UTF8 com perda de acentos), modo de empacotamento dos dados (ex. artigos JATS dentro de _containers_) e diversos outros constatados. Através de FTP ou download HTTP, os protocolos ainda mais comums para recuperação de grandes lotes, o lote-alvo pode estar misturado a outros lotes, ou vir segmento em lotes não-recuperados.

Em ambos os casos (lotes e APIs) há ainda o problema da indetificação das variantes de formato, principalmente versão do JATS (acervos antigos ainda em NLM v2), e variantes de estilo de marcação (ex. SciELO SPS e PubMed Central são distintos).

Uma vez inseridos na base de dados os artigos XML precisam ter seu perfil homologado através da verificação dos seus metadados, consistência estrutural (comum oferta de JATS sem `body`) e contagem dos itens da coleção, para atestar consistência (com metadados ou aferição na autoridade de orígem) do número de artigos por ano, artigos por volume ou por fascículo.

## METODOLOGIA

As avaliações e formulação metodológica foram desenvolvidas gradualmente. Um levantamento preliminar de "prova de conceito" foi realizado com o a revista ISSN-L 0074-0276 (FioCruz-Memórias), que é ofertada no SciELO com `front` e `back` (DTD "Thomson-Reuters Publishing v1.10") de toda a coleção e no PMC como JATS full-text de 2013 em diante. Em seguida complementou-se com diversos outros.

### Análise de sumários

Verificação através de compração com dados dos sumários SciELO e PMC, para homologar as coleções de arquivos. Resultados e considerações metodológicas no relatório **[report-01.md](report-01.md)**.

### Análise estrutural detalhada

Além de conferir por validação (via XML Schema ou DTD), dada a flexibilidade, as contagens e estatísticas de contagem de elementos estruturais é de grande relevância.

### Estatísticas de confiabilidade

O comportamento médio dos artigos de uma coleção, em termos de número médio de referências, volume médio de caracteres por artigo, etc. permite avaliar se houve alguma falha ou testar casos muito fora do comum que demandam verificação humana.

Estas estatísticas também auxiliam na normalização dos quantificadores que serão posteriormento utilizados para normalizar índices. Por exemplo se uma coleção inclui erratas como artigos, mesmo sem a caracterização explícita nos seus metadados, elas podem ser destacadas do restante dos artigos por seu perfil.

## ENDOSSOS

Endossos e revisores desta página

Além dos [revisores listados no histórico de *commits* deste documento](https://github.com/UnB-CIDACS/observatorio-jats/commits/master/campanhas/c01-corpusFioCruz), curdores que endossaran o seu conteúdo em uma determinada versão:

* ...

* Você curador: edite o arquivo para acrescentar **seu nome aqui**, precisamos no mínimo 2 curadores **endossando** (atestando que concorda com todo o contedo acima) para dar continuidade ao processo.

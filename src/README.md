
Scripts e demais fontes do projeto.

* Fontes de instalação: seguir a sequência _step01_ depois _step02_, etc. `step*.sql` são scripts de instalação PosgreSQL (rodar com `psql  step.sh`), `step*.sh` são shell (rodar com `sh step.sh`).

* Ferramentas: ver [tools](tools)

Para documentação  ver [docs](../docs), principalmente [docs/instalacao](../docs/instalacao.md).


## Arquitetura

![](https://yuml.me/18cf2f1a)

* [Journal](https://jats.nlm.nih.gov/publishing/tag-library/1.1/element/journal-meta.html): caracteriza o periódico, com identificaço pública garantida por seu ISSN-L.

* [Article](https://jats.nlm.nih.gov/publishing/tag-library/1.1/element/article.html): é a tabela que contém o JATS propriamente dito, cada registro caracteriza um artigo.

* [kx_Issue](https://jats.nlm.nih.gov/publishing/tag-library/1.1/element/issue.html): tabela cache (ou SQL-VIEW), opcional, constituída com dados reunidos no campo JSON `kx` do Journal.

No arquivo [step02-struct.sql](step02-struct.sql) encontram-se as definições SQL.

Para a resolução de ISSNs é importante ter na mesma base de dados o [ISSN-L-Resolver](https://github.com/okfn-brasil/ISSN-L-Resolver), que não precisa ser completo.

A formação dos caches-padrão  conseguida no [step03-kxbuild.sql](step03-kxbuild.sql), o que permite por fim constituir também a tabela-cache `kx_issue`, que permite conferir e calibrar dados das coleções.

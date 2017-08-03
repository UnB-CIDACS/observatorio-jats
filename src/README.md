![](https://yuml.me/18cf2f1a)

* [Journal](https://jats.nlm.nih.gov/publishing/tag-library/1.1/element/journal-meta.html): caracteriza o periódico, com identificaço pública garantida por seu ISSN-L.
* [Article](https://jats.nlm.nih.gov/publishing/tag-library/1.1/element/article.html): é a tabela que contém o JATS propriamente dito, cada registro caracteriza um artigo.
* [kx_Issue](https://jats.nlm.nih.gov/publishing/tag-library/1.1/element/issue.html): tabela cache (ou SQL-VIEW), opcional, constituída com dados reunidos no campo JSON `kx` do Journal.

No arquivo [step02-struct.sql](step02-struct.sql) encontram-se as definições SQL.
....


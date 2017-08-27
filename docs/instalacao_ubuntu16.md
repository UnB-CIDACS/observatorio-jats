

## Instalação no UBUNTU 16 LTS

Seguir o passo-a-passo recomendado no [suporte da OKBr](https://github.com/okfn-brasil/suporte/tree/master/webservers), 
quem parece se limitar ao NGinx... Então acrescentar a instalação do PostgreSQL conforme as próprias recomendações 
da distribuição oficial, https://www.postgresql.org/download/linux/ubuntu/

Até o passo `apt install postgresql-9.6` depois ainda adicionar `apt install postgresql-contrib-9.6`.

Para garantir todas as modificaçes fazer `service postgresql restart` e conferir com `service postgresql status`.





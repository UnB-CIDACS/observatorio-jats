(valta `apt install php-mbstring`

## Instalação no UBUNTU 16 LTS

Fazer no `/tmp`  `git clone https://github.com/okfn-brasil/suporte.git` para
seguir o passo-a-passo recomendado no [suporte da OKBr](https://github.com/okfn-brasil/suporte/tree/master/webservers),
que parece se limitar ao NGinx...

### Instalação do PostgreSQL
Então acrescentar a instalação do PostgreSQL conforme as próprias recomendações
da distribuição oficial, https://www.postgresql.org/download/linux/ubuntu/

Até o passo `apt install postgresql-9.6` depois ainda adicionar `apt install postgresql-contrib-9.6`.

Para garantir todas as modificaçes fazer `service postgresql restart` e conferir com `service postgresql status`.

Este projeto adota para todas as instruções e discusses o usuário padrão `postgres`  e sua senha de mesmo nome.

### Pegadingas do PostgreSQL

Apenas em caso de desespero use `sudo -u postgres psql`, e não irá funcionar em qualquer pasta ou pipe, é apenas para ter acesso ao `psql`.

Padronização do acesso ao usuário *postgres*:

O usuário *postgres* é padrão dentro das distribuições PostgreSQL, em todas as versões. É um usuário para testes, benchmarks e dados abertos, e pode ser bloqueado para conexões externas, mas é importante para o suporte e  manutenção, por exemplo via `ssh`.

Exceto por eventual erro de manipulação, o usuário *postgres* já existe tanto no Ubuntu (confira com `id -u postgres`) como dentro servidor postresql &mdash; certifique-se que o servidor está ativo com `service postgresql status`.

Na sequencia abaixo o `CREATE USER`  indicará erro mas é apenas sinal de que está em conformidade com os padrões. O `GRANT` reforça o uso da senha padrão.

```sh
sudo -u postgres psql  # aguarde feedback para senha, depois entre com o resto abaixo
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE postgres to postgres;
\q
```

Para criar uma base qualquer é o mesmo `sudo -u postgres psql`  com `CREATE DATABASE novaBase;`.

Até aqui não temos ainda garantia de que os comandos padronizados de `psql`  utilizados em centenas de scripts e tutoriais irão funcionar... Falta garantir no UBUNTU que o usuário *postgres*  esteja nas configurações do shell.

Configurando o shell:

... Se no seu terminal (ou `ssh`), com usuário root (ou `suso su`), o comando `PGPASSWORD=postgres psql -U postgres` não funcionar automaticamente, sem pedir senha, é sinal precisa configurar.

https://stackoverflow.com/a/26735105/287948

(trust depois md5)

## Instalação PHP

Se não for usar no server, basta para rodar antigos instaladores o

`apt install php7.0-cli php-xml php7.0-pgsql`

# Instalando seu observatório

A sequência de instruções a seguir foi testada e funcina em servidores UBUNTU 16 LTS, sempre que alguns cuidados forem tomados. 
Esses cuidados serão discutidos no final... Fique atento a eles se houverem problemas durantes a reprodução das instruções.

Supor que todas as instalação de git, etc. partem de `cd ~`, na sua área de usuário, e sem necessidade de `sodu`.

## Criando uma base PostgreSQl só para o Observatório

A base vai se chamar `obsjats`, e vamos criá-la e instalar tudo com o usuário padrão.

```sh
PGPASSWORD=postgres psql -h localhost -U postgres
CREATE DATABASE obsjats 
   WITH OWNER = postgres
        ENCODING = 'UTF8'
        TABLESPACE = pg_default
        LC_COLLATE = 'pt_BR.UTF-8'
        LC_CTYPE = 'pt_BR.UTF-8'
	CONNECTION LIMIT = -1
        TEMPLATE template0;
\q
```

## Dependências com bibliotecas externas

Por hora há dependência apenas com o ISSN-resolver, que garante a tradução de qualquer ISSN para seu ISSN-L correspodente. 
É o projeto OKBr do [ISSN-L-Resolver](http://git.ok.org.br/ISSN-L-Resolver)

```sh
git clone http://git.ok.org.br/ISSN-L-Resolver.git
cd ISSN-L-Resolver
PGPASSWORD=postgres psql -h localhost -U postgres  obsjats < src/step1-schema.sql
PGPASSWORD=postgres psql -h localhost -U postgres  obsjats < src/step2-lib.sql
PGPASSWORD=postgres psql -h localhost -U postgres  obsjats < src/step3-api.sql
```

Por hora também não precisamos de um ISSN-resolver super atualizado, é suficiente o disponivel como "demo"... Assim, continuando:
```sh
# ... ainda na pasta ISSN-L-Resolver
mkdir issnltables
cd issnltables
wget http://git.ok.org.br/oficial-backupsbig/raw/master/projeto/ISSN-L-Resolver/ISSN-to-ISSN-L.txt.zip
unzip ISSN-to-ISSN-L.txt.zip
cd ..
php src/step4-issnltables2sql.php all | PGPASSWORD=postgres psql -h localhost -U postgres obsjats
PGPASSWORD=postgres psql -h localhost -U postgres  obsjats < src/step5-assert.sql | more
rm issnltables/*.*
```
O último comando `psql` apenas faz testes de certificação, não precisa se preocupar em entender o que mostram, exceto se forem avisos de falha.

## Instalação principal

...

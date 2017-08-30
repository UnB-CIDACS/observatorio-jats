#!/usr/bin/perl -w

#@files = <*.xml>;
@lines = <STDIN>;
$p = "PGPASSWORD=postgres psql -h localhost -U postgres obs2 -c";
foreach $url (@lines) {
 $url =~ s/^\s+|\s+$//g ;
 print "\n$p \"INSERT INTO core.article (jrepo_id,uri,content) VALUES (15695,'$url',xmlparse(document '\`curl -s -H 'Accept: application/xml' '$url' | sed -e \"s/'/''/g\" \`'))\"";
}

# 15695??
# Fazer insert em PHP PDO ...

$pdo = new PDO(PG_CONSTR, PG_DFT_USER, PG_DFT_PW);
$url_base = '';

foreach(file(STDIN) as $pmid)
$statement = $link->prepare("
  INSERT INTO core.article (jrepo_id,uri,content) VALUES
  VALUES(:jrepo_id, :uri,  xmlparse(document :content) )
");
$statement->execute(array(
    "jrepo_id" => "Bob",
    "uri" => "Desaunois",
    "content" => pg_xxx
));

xmlparse(document '\`curl -s -H 'Accept: application/xml' '$url' | sed -e \"s/'/''/g\" \`'))\""

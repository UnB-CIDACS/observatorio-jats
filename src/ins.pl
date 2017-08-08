#!/usr/bin/perl -w

#@files = <*.xml>;
@lines = <STDIN>;
$p = "PGPASSWORD=postgres psql -h localhost -U postgres obs2 -c";
foreach $url (@lines) {
 $url =~ s/^\s+|\s+$//g ;
 print "\n$p \"INSERT INTO core.article (jrepo_id,uri,content) VALUES (15695,'$url',xmlparse(document '\`curl -s -H 'Accept: application/xml' '$url' | sed -e \"s/'/''/g\" \`'))\"";
}


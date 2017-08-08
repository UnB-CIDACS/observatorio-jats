#!/usr/bin/perl -w

use Cwd;
use File::Basename;

my $pwd = cwd();
$issnDir = basename($pwd);

@files = <*.xml>;
$n = @files;
if (!$n) { @files=<*.nxml>; }

$p = "PGPASSWORD=postgres psql -h localhost -U postgres obsjats -c";
foreach $file (@files) {
 print "\n\n $p \"insert into article (issn,filename,content) values (issn.n2c('$issnDir'),'$file',XMLPARSE (DOCUMENT '\`cat $file | sed -e \"s/'/''/g\" \`'))\"";
}

# curl TAMBEM FUNCIONA!
# PGPASSWORD=postgres psql -h localhost -U postgres obsjats -c "insert into t (file,xcontent) values ('PMC43022',XMLPARSE (DOCUMENT '`curl -s 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id=4304705&tool=my_tool&email=my_email@example.com' | sed -e "s/'/''/g" `'))"


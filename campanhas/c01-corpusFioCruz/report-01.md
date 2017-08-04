# Relatório 01 da Campanha C01

Relatorório de "calibração e perfil" dos dados com os originais conhecidos. Resultados obtidos.

## Escopo da calibração

O presente relatório permite testar e "calibrar" os dados, aferindo de forma ainda que grosseira a confiabilidade dos dados e algoritmos em uso no *Observatpório JATS*.

Cada uma das revistas FioCruz teve seus artigos JATS analisados e, com os metadados extraídos de cada JATS, foi constituído um sumário da revista, com a mesma estrutura que o `sci_issues` do site do SciELO.

Maiores detalhes no [scieloPages-reprodux.sql](src/scieloPages-reprodux.sql).

## Escopo do perfil
Como o SciELO não sumariza online a informação relativa à quantidade de artigos e à disponibilidade dos mesmos em JATS, o relatório de perfil não tem referência para ser validado. Algumas amostragens foram realizadas conferindo fascículos online manualmente.

O resultado do perfil foi registrado na planilha [perfil.csv](data/perfil.csv) cujas informações contemplam também o escopo da calibração.

## Revista 0074-0276

Revista *"Memórias do Instituto Oswaldo Cruz"*. ISSNs: 0074-0276 ou 1678-8060.

Compare a tabela abaixo, gerada a partir dos artigos JATS, com a [sua equivalente do SciELO](http://www.scielo.br/scielo.php?script=sci_issues&pid=0074-0276).

year | volume |                                    issues                                    
------|--------|------------------------------------------------------------------------------
2017 | 112    | 1; 2; 3; 4; 5; 6; 7
2017 | 0      | 0
2016 | 111    | 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12
2015 | 110    | 1; 2; 3; 4; 5; 6; 7; 8
2015 | 0      | 0
2014 | 109    | 1; 2; 3; 4; 5; 6; 7; 8
2013 | 108    | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2012 | 107    | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2011 | 106    | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2010 | 105    | 1; 2; 3; 4; 5; 6; 7; 8
2009 | 104    | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2008 | 103    | 1; 2; 3; 4; 5; 6; 7; 8
2007 | 102    | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2006 | 101    | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1; suppl 2
2005 | 100    | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2004 | 99     | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2003 | 98     | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2002 | 97     | 1; 2; 3; 4; 5; 6; 7; 8; suppl 1
2001 | 96     | 1; 2; 3; 4; 5; 6; 7; 8; suppl
2000 | 95     | 1; 2; 3; 4; 5; 6; suppl 1
1999 | 94     | 1; 2; 3; 4; 5; 6; suppl 1; suppl 2
1998 | 93     | 1; 2; 3; 4; 5; 6; suppl 1; suppl 2
1997 | 92     | 1; 2; 3; 4; 5; 6; suppl 1; suppl 2
1996 | 91     | 1; 2; 3; 4; 5; 6
1995 | 90     | 1; 2; 3; 4; 5; 6
1994 | 89     | 1; 2; 3; 4; suppl 2
1993 | 88     | 1; 2; 3; 4
1992 | 87     | 1; 2; 3; 4; suppl 1; suppl 3; suppl 4; suppl 5
1991 | 86     | 1; 2; 3; 4; suppl 2; suppl 3
1990 | 85     | 1; 2; 3; 4
1989 | 84     | 1; 2; 3; 4; suppl 1; suppl 3; suppl 4
1988 | 83     | 1; 2; 3; 4; suppl 1
1987 | 82     | 1; 2; 3; 4; suppl 1; suppl 2; suppl 3; suppl 4
1986 | 81     | 1; 2; 3; 4; suppl 2
1985 | 80     | 1; 2; 3; 4
1984 | 79     | 1; 2; 3; 4; suppl
1983 | 78     | 1; 2; 3; 4
1982 | 77     | 1; 2; 3; 4
1981 | 76     | 1; 2; 3; 4
1980 | 75     | 1-2; 3-4
1976 | 74     | 1; 2; 3-4
1975 | 73     | 3; 1-2
1974 | 72     | 1-2; 3-4
1973 | 71     | 3; 4; 1-2
1972 | 70     | 1; 2; 3; 4
1971 | 69     | 1; 2; 3
1970 | 68     | 1
1968 | 66     | 1; 2
1967 | 65     | 1; 2
1966 | 64     | 0
1965 | 63     | 0
1964 | 62     | 0
1963 | 61     | 1; 2; 3
1962 | 60     | 1; 2; 3
1961 | 59     | 1; 2; 3
1960 | 58     | 1; 2
1959 | 57     | 1; 2
1958 | 56     | 1; 2
1957 | 55     | 1; 2
1956 | 54     | 1; 2; 3
1955 | 53     | 1; 2-3-4
1954 | 52     | 1; 2; 3-4
1953 | 51     | 0
1952 | 50     | 0
1951 | 49     | 0
1950 | 48     | 0
1949 | 47     | 1-2; 3-4
1948 | 46     | 1; 2; 3; 4
1947 | 45     | 1; 2; 3; 4
1946 | 44     | 1; 2; 3; 4
1945 | 43     | 1; 2; 3
1945 | 42     | 1; 2; 3
1944 | 41     | 1; 2; 3
1944 | 40     | 1; 2; 3
1943 | 39     | 1; 2; 3
1943 | 38     | 1; 2; 3
1942 | 37     | 1; 2; 3; 4
1941 | 36     | 1; 2; 3; 4
1940 | 35     | 1; 2; 3; 4
1939 | 34     | 1; 2; 3; 4
1938 | 33     | 1; 2; 3; 4
1937 | 32     | 1; 2; 3; 4
1936 | 31     | 1; 2; 3; 4
1935 | 30     | 1; 2; 3
1934 | 29     | 1; 2
1934 | 28     | 1; 2; 3; 4
1933 | 27     | 1; 2; 3; 4
1932 | 26     | 1; 2; 3
1931 | 25     | 1; 2; 3; 4
1930 | 24     | 1; 2; 3; 4
1930 | 23     | 1; 2; 3; 4; 5
1929 | 22     | 1; suppl 10; suppl 11; suppl 12; suppl 5; suppl 6; suppl 7; suppl 8; suppl 9
1928 | 21     | 1; 2; suppl 1; suppl 2; suppl 3; suppl 4
1927 | 20     | 1; 2
1926 | 19     | 1; 2
1925 | 18     | 1
1924 | 17     | 1; 2
1923 | 16     | 1
1922 | 15     | 1
1922 | 14     | 1
1921 | 13     | 1
1920 | 12     | 1
1919 | 11     | 1
1918 | 10     | 1; 2
1917 | 9      | 1
1916 | 8      | 1; 2; 3
1915 | 7      | 1; 2
1914 | 6      | 1; 2; 3
1913 | 5      | 1; 2; 3
1912 | 4      | 1
1911 | 3      | 1; 2
1910 | 2      | 1; 2
1909 | 1      | 1; 2

(113 rows)

Obtida com `psql -h localhost -U postgres obsjats -c "SELECT year,volume,issues FROM report.c01_issues_listpervol WHERE issn=74027" > table.txt`.
Para a tabela em XHTML usar `SELECT report.c01_sci_issues(74027)`.

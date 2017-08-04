

CREATE VIEW report.c01_issues_listpervol AS
  SELECT issn, year, volume, array_to_string(array_agg(issue ORDER BY lpad0(issue)),'; ') as issues
  FROM article_issue_count
  GROUP BY 1,2,3
  ORDER BY 1, 2 DESC, 3 DESC
;


/**
 * Issues script dataset and structure reproduction.
 * SciELO script name: sci_issues(pid)
 * Main SQL sources: article_issue_count
 * Example for ISSN 0074-0276: http://www.scielo.br/scielo.php?script=sci_issues&pid=0074-0276
 * @param issn
 * @return relatório XHTML com mesma organização visual que a página SciELO.
 */
CREATE or replace FUNCTION report.c01_sci_issues(issnl integer)  RETURNS xml AS $func$
  SELECT
    xmlelement(name section, xmlattributes('report' as class),
      xmlelement(name header, xmlelement(name h1, name), xmlelement(
          name p,
          xmlelement( name b, 'ISSN-L '|| issn.cast(issn.n2c($1)) ),
          '. ISSNs:'|| (issn.tservice_jspack(issn,'n2ns')->>'result')::text
        )
      ),
      xmlelement(name table, xmlattributes('1' as border),
        xmlelement(name tr,
          xmlelement(name th,'year'), xmlelement(name th,'volume'), xmlelement(name th,'issues')
        ),  -- each th
        (SELECT xmlagg(
          xmlelement(name tr,
            xmlelement(name td,year), xmlelement(name td,volume), xmlelement(name td,issues)
          )) -- xmlagg
        FROM (SELECT * FROM report.c01_issues_listpervol ORDER BY year DESC, volume DESC) t
        WHERE issn=$1
      ) -- select
    )
  ) FROM journal
  WHERE issn=$1
  ;
$func$ LANGUAGE SQL IMMUTABLE;

--
-- Observatorio-JATS, core structures.
--

DROP SCHEMA IF EXISTS core CASCADE;
CREATE SCHEMA core;

CREATE TABLE core.repository (
  -- A digital repository of JATS, like PubMed Central or SciELO.
  id    integer NOT NULL PRIMARY KEY,
  name  text   NOT NULL, -- full name
  label text   NOT NULL, -- abbrev, with lower case ASCII short-name, no spaces.
  url   text,  -- official URL (as Wikipedia)
  dtds  text[],
  info jsonb,
  UNIQUE (name),
  UNIQUE (label),
  UNIQUE (url)
);

CREATE TABLE core.journal (
  -- "In use" journal... Need 1 or more articles in the database. Delete if no one.
  issn integer NOT NULL PRIMARY KEY,
  country text NOT NULL, -- 2-letter country code (but preffer cityes)
  name text,   -- full name
  abbrev text, -- like label, but an "official abbreviation"
  info JSONb,  -- all other information, like other issns, publisher, country of the publisher, languages.
  kx   JSONb,  -- cache
  UNIQUE(country,abbrev)
);


CREATE TABLE core.journal_repository (
   --
   -- All knowed journals with a knowed JATS repository.
   -- This record ensure the provenience of articles and control of valid issn in a repo
   --
  id       serial NOT NULL PRIMARY KEY,
  issnl          int    NOT NULL, -- references issn.intcode(issn_l), not need ref. core.journal
  repository_id  int    NOT NULL REFERENCES core.repository(id),
  UNIQUE (issnl,repository_id)
);

CREATE TABLE core.dtd (
  -- to control valid JATS variants, v1.0, v1.1, JATS-SPS of SciELO, etc.
  id serial NOT NULL PRIMARY KEY,
  label text NOT NULL, -- ex. jats-1.1 from "JATS-v1.1", html-5 from "HTML-v5.0", etc.
  dtd_url text NOT NULL, -- ex. jats-1.1=ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.1/
  info JSONb, -- additional information as full-name, dtd-URL, xml-schema-url, authority-url, etc.
  kx   JSONb,  -- cache with stats, etc.
  UNIQUE(label)
);

CREATE TABLE core.article (
  id serial NOT NULL PRIMARY KEY,
  jrepo_id bigint NOT NULL REFERENCES core.journal_repository(id),
  uri text,  -- official filename or doi.
  content xml,  -- JATS
  dtd  int REFERENCES core.dtd(id), -- important coherent with content.
  info JSONb,
  kx   JSONb,  -- cached from JATS contents
  UNIQUE(jrepo_id,uri) -- only one dtd per article.
);

CREATE TABLE core.article_prepare (
  -- many DTDs is possible, for prospection. No content here, only list all articles of a repo.
  id serial NOT NULL PRIMARY KEY,
  jrepo_id bigint NOT NULL REFERENCES core.journal_repository(id),
  dtd  int REFERENCES core.dtd(id),
  uri text,  -- official in the new repo
  info JSONb,
  UNIQUE(jrepo_id,uri,dtd) -- only one dtd per article.
);

-- -- -- new in v0.2

CREATE TABLE core.campaign (  -- carregar de campanha.csv
  id integer NOT NULL PRIMARY KEY, -- for 'c01', 'c02' etc.
  label text NOT NULL CHECK(label>''), -- filename complement
  kx   JSONb,   -- all info from README!
  UNIQUE(label)
);


CREATE TABLE core.article_campaign (
  id_article int NOT NULL REFERENCES core.article(id),
  id_campaign int NOT NULL REFERENCES core.campaign(id),
  info JSONb, -- for special cases
  UNIQUE(id_article,id_campaign)
);


-- -- -- --
-- Standard VIEWs

CREATE VIEW core.vw_article_journal AS
  SELECT a.*, jr.issnl, jr.repository_id
  FROM core.article a INNER JOIN core.journal_repository jr ON jr.id=a.jrepo_id
;

CREATE VIEW core.vw_journal_campaign AS  -- MATERIALIZED
   SELECT aj.issnl, ac.id_campaign, count(*) as n
   FROM core.vw_article_journal aj INNER JOIN core.article_campaign ac ON aj.id=ac.id_article
   GROUP BY 1,2
;

CREATE VIEW core.vw_article_journal_repo AS
  SELECT a.*, r.name as repo_name, r.label as repo_label, r.dtds as repo_dtds
  FROM core.vw_article_journal a INNER JOIN core.repository r  ON r.id=a.repository_id
;

-- old lixo CREATE VIEW core.vw_article_journal_repo AS ... MUDOU, revisar.


-------------
--LIB INSERT

CREATE or replace FUNCTION core.insert_article_byjou(
 p_jrepo_id int,
 p_uri text,
 p_content XML
) RETURNS int AS $f$
  INSERT INTO core.article (jrepo_id,uri,content)
  VALUES($1, $2,  $3 ) RETURNING id
  ;
$f$ LANGUAGE SQL;


CREATE or replace FUNCTION core.get_issn(xml) RETURNS int AS $f$
  SELECT issn.cast( trim((xpath(
	'//article/front/journal-meta/issn/text() | //article/front/journal-meta/issn-l/text()',
	$1
	))[1]::text) );
$f$ LANGUAGE SQL IMMUTABLE;



CREATE or replace FUNCTION core.insert_article(
 p_repo_id int,
 p_uri text,
 p_content XML
) RETURNS int AS $f$
  SELECT core.insert_article_byjou(
     (SELECT id FROM core.journal_repository WHERE  repository_id=$1 AND issnl=core.get_issn($3) )
     ,$2
     ,$3
  );
$f$ LANGUAGE SQL;


CREATE or replace FUNCTION core.get_issn(xml) RETURNS int AS $f$
  SELECT issn.cast( trim((xpath(
	'//article/front/journal-meta/issn/text() | //article/front/journal-meta/issn-l/text()',
	$1
	))[1]::text) );
$f$ LANGUAGE SQL IMMUTABLE;

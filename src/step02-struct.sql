
CREATE TABLE repository (
  id    integer NOT NULL PRIMARY KEY,
  name  text   NOT NULL,
  label text   NOT NULL, -- lower case ASCII short-name, no spaces.
  url   text,  -- official URL (as Wikipedia)
  dtds  text[],
  info jsonb,
  UNIQUE (name),
  UNIQUE (label)
);

CREATE TABLE dtd (
  id serial NOT NULL PRIMARY KEY,
  label text NOT NULL, -- ex. jats-1.1 from "JATS-v1.1", html-5 from "HTML-v5.0", etc.
  dtd_url text NOT NULL, -- ex. jats-1.1=ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.1/
  info JSONb, -- additional information as full-name, dtd-URL, xml-schema-url, authority-url, etc.
  kx   JSONb,  -- cache with stats, etc.
  UNIQUE(label)
);

CREATE TABLE journal (
  issn integer NOT NULL PRIMARY KEY,
  country text NOT NULL, -- 2-letter country code
  name text,  -- full name
  abbrev text,
  info JSONb,
  kx   JSONb,  -- cache
  UNIQUE(country,abbrev)
);

CREATE TABLE journal_repository ( -- provenience of articles and control of valid issn in a repo
  jrepo_id       serial NOT NULL PRIMARY KEY,
  issnl          int    NOT NULL, -- references issn.intcode(issn_l)
  repository_id  int    NOT NULL REFERENCES repository(id),
  UNIQUE (issnl,repository_id)
);

CREATE TABLE article (
  id serial NOT NULL PRIMARY KEY,
  issn integer  REFERENCES journal(issn), -- can be null when created
  filename text,  -- official 
  content xml,  -- JATS
  jrepo_id bigint references journal_repository(jrepo_id), -- as content provenience
  dtd  int REFERENCES dtd(id),
  info JSONb,
  kx   JSONb,  -- cache
  UNIQUE(issn,filename) -- only one dtd per article. 
);

CREATE TABLE article_alt ( -- second dtd or second repo
  id serial NOT NULL PRIMARY KEY,
  id_ref bigint NOT NULL references article(id),
  filename text,  -- official in the new repo
  content xml,  -- JATS
  dtd  int REFERENCES dtd(id),
  info JSONb,
  kx   JSONb,  -- cache
  UNIQUE(issn,filename) -- only one dtd per article. 
);


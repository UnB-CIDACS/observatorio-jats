
CREATE TABLE journal (
  issn integer NOT NULL PRIMARY KEY,
  country text NOT NULL, -- 2-letter country code
  name text,  -- full name
  abbrev text,
  info JSONb,
  kx   JSONb,  -- cache
  UNIQUE(country,abbrev)
);

CREATE TABLE dtd (
  id serial NOT NULL PRIMARY KEY,
  abbrev text, -- ex. JATS-v1.1, HTML-v5.0
  info JSONb,
  kx   JSONb,  -- cache
  UNIQUE(abbrev)
);

CREATE TABLE article (
  id serial NOT NULL PRIMARY KEY,
  issn integer  REFERENCES journal(issn), -- can be null when created
  filename text,  -- official 
  content xml,  -- JATS
  dtd  int REFERENCES dtd(id),
  info JSONb,
  kx   JSONb  -- cache
);



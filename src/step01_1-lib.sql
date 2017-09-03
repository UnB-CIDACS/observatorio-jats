-- LIBS AQUI se precisar

-- DROP SCHEMA lib CASCADE;
CREATE SCHEMA IF NOT EXISTS lib;  -- general commom library.

------------------------
-- General-use array functions from (std) LIB
-- from ISSN lib:

CREATE or replace FUNCTION lib.array_pop_off(ANYARRAY) RETURNS ANYARRAY AS $f$
    SELECT $1[2:array_length($1,1)];
$f$ LANGUAGE sql IMMUTABLE;

CREATE or replace FUNCTION lib.json_array_castext(json) RETURNS text[] AS $f$
  SELECT array_agg(x)
  FROM json_array_elements_text($1) t(x);
$f$ LANGUAGE sql IMMUTABLE;

CREATE or replace FUNCTION lib.url_tocmp(url text) RETURNS text AS $f$
  SELECT lower(trim( regexp_replace($1,'^https?://(www.)?','') , '/ '));
$f$ LANGUAGE sql IMMUTABLE;

--- agg

/**
 * Custom array_agg() for NOT NULL.
 * @see  https://stackoverflow.com/a/17303965
 * @see  http://ejrh.wordpress.com/2011/09/27/denormalisation-aggregate-function-for-postgresql/
 */
CREATE OR REPLACE FUNCTION fn_array_agg_notnull (
    a anyarray
    , b anyelement
) RETURNS ANYARRAY
AS $$
BEGIN
    IF b IS NOT NULL THEN
        a := array_append(a, b);
    END IF;
    RETURN a;
END;
$$ IMMUTABLE LANGUAGE 'plpgsql';

DROP AGGREGATE  IF EXISTS array_agg_notnull(ANYELEMENT);
CREATE AGGREGATE array_agg_notnull(ANYELEMENT) (
    SFUNC = fn_array_agg_notnull,
    STYPE = ANYARRAY,
    INITCOND = '{}'
);


---------------
-- used here at Observatorio:

CREATE or replace FUNCTION lib.lpad0(text) RETURNS  text AS $func$
  -- secure lpad for non-only-digits strings.
  SELECT  regexp_replace($1,'^([1-9])$','0\1'); -- or LPAD($1, 3, '0');
$func$ LANGUAGE SQL IMMUTABLE;

CREATE or replace FUNCTION lib.lpad0(int) RETURNS text AS $wrap$
  SELECT lib.lpad0($1::text);
$wrap$ LANGUAGE SQL IMMUTABLE;


CREATE or replace FUNCTION lib.trim2(text) RETURNS text AS $func$
  SELECT trim( regexp_replace($1, '\s+', ' ','g') );
$func$ LANGUAGE SQL IMMUTABLE;

CREATE or replace FUNCTION lib.trim2(text[]) RETURNS text AS $wrap$
  SELECT lib.trim2(array_to_string($1,''));
$wrap$ LANGUAGE SQL IMMUTABLE;

CREATE or replace FUNCTION lib.trim2(xml[]) RETURNS text AS $wrap$
  SELECT lib.trim2(array_to_string($1::text[],''));
$wrap$ LANGUAGE SQL IMMUTABLE;

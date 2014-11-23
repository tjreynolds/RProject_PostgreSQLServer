--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: hg19_refgene; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE hg19_refgene (
    bin integer,
    name text,
    chrom text,
    strand text,
    txstart integer,
    txend integer,
    cdsstart integer,
    cdsend integer,
    exoncount integer,
    exonstarts text,
    exonends text,
    score integer,
    name2 text,
    cdsstartstat text,
    cdsendstat text,
    exonframes text
);


ALTER TABLE public.hg19_refgene OWNER TO vagrant;

--
-- Name: neggene; Type: VIEW; Schema: public; Owner: vagrant
--

CREATE VIEW neggene AS
 SELECT array_to_string(array_agg(DISTINCT hg19_refgene.name), ','::text) AS name,
    array_to_string(array_agg(DISTINCT hg19_refgene.name2), ','::text) AS symbol,
    hg19_refgene.chrom,
    hg19_refgene.strand,
    hg19_refgene.txend AS tss
   FROM hg19_refgene
  WHERE ((hg19_refgene.strand = '-'::text) AND (hg19_refgene.chrom !~~ '%ctg%'::text))
  GROUP BY hg19_refgene.chrom, hg19_refgene.strand, hg19_refgene.txend;


ALTER TABLE public.neggene OWNER TO vagrant;

--
-- Name: posgene; Type: VIEW; Schema: public; Owner: vagrant
--

CREATE VIEW posgene AS
 SELECT array_to_string(array_agg(DISTINCT hg19_refgene.name), ','::text) AS name,
    array_to_string(array_agg(DISTINCT hg19_refgene.name2), ','::text) AS symbol,
    hg19_refgene.chrom,
    hg19_refgene.strand,
    hg19_refgene.txstart AS tss
   FROM hg19_refgene
  WHERE ((hg19_refgene.strand = '+'::text) AND (hg19_refgene.chrom !~~ '%ctg%'::text))
  GROUP BY hg19_refgene.chrom, hg19_refgene.strand, hg19_refgene.txstart;


ALTER TABLE public.posgene OWNER TO vagrant;

--
-- Name: bdp; Type: VIEW; Schema: public; Owner: vagrant
--

CREATE VIEW bdp AS
 SELECT pos.chrom,
    pos.tss AS pos_tss,
    neg.tss AS neg_tss,
    pos.symbol AS pos_symbol,
    neg.symbol AS neg_symbol,
    (pos.tss - neg.tss) AS spacing
   FROM posgene pos,
    neggene neg
  WHERE ((pos.chrom = neg.chrom) AND (abs((pos.tss - neg.tss)) < 1000))
  ORDER BY pos.chrom, pos.tss;


ALTER TABLE public.bdp OWNER TO vagrant;

--
-- Name: neggene_cat; Type: MATERIALIZED VIEW; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE MATERIALIZED VIEW neggene_cat AS
 SELECT array_to_string(array_agg(DISTINCT hg19_refgene.name), ','::text) AS name,
    array_to_string(array_agg(DISTINCT hg19_refgene.name2), ','::text) AS symbol,
    hg19_refgene.chrom,
    hg19_refgene.strand,
    hg19_refgene.txend AS tss
   FROM hg19_refgene
  WHERE (hg19_refgene.strand = '-'::text)
  GROUP BY hg19_refgene.chrom, hg19_refgene.strand, hg19_refgene.txend
  WITH NO DATA;


ALTER TABLE public.neggene_cat OWNER TO vagrant;

--
-- Name: posgene_cat; Type: MATERIALIZED VIEW; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE MATERIALIZED VIEW posgene_cat AS
 SELECT array_to_string(array_agg(DISTINCT hg19_refgene.name), ','::text) AS name,
    array_to_string(array_agg(DISTINCT hg19_refgene.name2), ','::text) AS symbol,
    hg19_refgene.chrom,
    hg19_refgene.strand,
    hg19_refgene.txstart AS tss
   FROM hg19_refgene
  WHERE (hg19_refgene.strand = '+'::text)
  GROUP BY hg19_refgene.chrom, hg19_refgene.strand, hg19_refgene.txstart
  WITH NO DATA;


ALTER TABLE public.posgene_cat OWNER TO vagrant;

--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


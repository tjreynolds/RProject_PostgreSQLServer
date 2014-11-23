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
-- Name: vaersdata; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE vaersdata (
    vaers_id real NOT NULL,
    recvdate date,
    state character(2),
    age_yrs real,
    cage_yr real,
    cage_mo real,
    sex character(1),
    rpt_date date,
    symptom_text character varying(2048),
    died character(1),
    datedied date,
    l_threat character(1),
    er_visit character(1),
    hospital character(1),
    hospdays real,
    x_stay character(1),
    disable character(1),
    recovd character(1),
    vax_date date,
    onset_date date,
    numdays real,
    lab_data character varying(750),
    v_adminby character(3),
    v_fundby character(3),
    other_meds character varying(750),
    cur_ill character varying(500),
    history character varying(750),
    prior_vax character varying(256),
    splttype character varying(25)
);


ALTER TABLE public.vaersdata OWNER TO vagrant;

--
-- Name: vaerssymptoms; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE vaerssymptoms (
    vaers_id real,
    symptom1 text,
    symptomversion1 real,
    symptom2 text,
    symptomversion2 real,
    symptom3 text,
    symptomversion3 real,
    symptom4 text,
    symptomversion4 real,
    symptom5 text,
    symptomversion5 real
);


ALTER TABLE public.vaerssymptoms OWNER TO vagrant;

--
-- Name: vaersvax; Type: TABLE; Schema: public; Owner: vagrant; Tablespace: 
--

CREATE TABLE vaersvax (
    vaers_id real,
    vax_type text,
    vax_manu text,
    vax_lot text,
    vax_dose text,
    vax_route text,
    vax_site text,
    vax_name text
);


ALTER TABLE public.vaersvax OWNER TO vagrant;

--
-- Data for Name: vaersdata; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY vaersdata (vaers_id, recvdate, state, age_yrs, cage_yr, cage_mo, sex, rpt_date, symptom_text, died, datedied, l_threat, er_visit, hospital, hospdays, x_stay, disable, recovd, vax_date, onset_date, numdays, lab_data, v_adminby, v_fundby, other_meds, cur_ill, history, prior_vax, splttype) FROM stdin;
\.


--
-- Data for Name: vaerssymptoms; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY vaerssymptoms (vaers_id, symptom1, symptomversion1, symptom2, symptomversion2, symptom3, symptomversion3, symptom4, symptomversion4, symptom5, symptomversion5) FROM stdin;
\.


--
-- Data for Name: vaersvax; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY vaersvax (vaers_id, vax_type, vax_manu, vax_lot, vax_dose, vax_route, vax_site, vax_name) FROM stdin;
\.


--
-- Name: vaersdata_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace: 
--

ALTER TABLE ONLY vaersdata
    ADD CONSTRAINT vaersdata_pkey PRIMARY KEY (vaers_id);


--
-- Name: vaerssymptoms_vaers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY vaerssymptoms
    ADD CONSTRAINT vaerssymptoms_vaers_id_fkey FOREIGN KEY (vaers_id) REFERENCES vaersdata(vaers_id);


--
-- Name: vaersvax_vaers_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY vaersvax
    ADD CONSTRAINT vaersvax_vaers_id_fkey FOREIGN KEY (vaers_id) REFERENCES vaersdata(vaers_id);


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


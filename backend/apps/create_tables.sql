--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;



CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'postgres';








--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Debian 15.2-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Debian 15.2-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- Database "zeppelin" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Debian 15.2-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: zeppelin; Type: DATABASE; Schema: -; Owner: postgres
--

ALTER DATABASE zeppelin OWNER TO postgres;

\connect zeppelin

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: questionnaire_adoptedlevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_adoptedlevel (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    percentage integer NOT NULL
);


ALTER TABLE public.questionnaire_adoptedlevel OWNER TO postgres;

--
-- Name: questionnaire_answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_answer (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    comment text NOT NULL,
    adopted_level_id integer NOT NULL,
    questionnaire_id integer,
    statement_id integer NOT NULL,
    organization_id integer NOT NULL
);


ALTER TABLE public.questionnaire_answer OWNER TO postgres;

--
-- Name: questionnaire_statement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_statement (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    code character varying(200),
    statement text NOT NULL,
    pe_element_id integer,
    sth_stage_id integer,
    continuous_activity_id integer
);


ALTER TABLE public.questionnaire_statement OWNER TO postgres;

--
-- Name: sth_stage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sth_stage (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.sth_stage OWNER TO postgres;

--
-- Name: answer_sth_stage_adopted_level_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.answer_sth_stage_adopted_level_view AS
 SELECT qa.organization_id,
    qal.name AS adopted_level,
    qal.id AS adopted_level_id,
    qal.percentage AS adopted_level_percentage,
    ss.name AS sth_stage,
    ss.id AS sth_stage_id,
    count(*) AS value
   FROM (((public.questionnaire_answer qa
     JOIN public.questionnaire_statement qs ON ((qa.statement_id = qs.id)))
     JOIN public.sth_stage ss ON ((ss.id = qs.sth_stage_id)))
     JOIN public.questionnaire_adoptedlevel qal ON ((qal.id = qa.adopted_level_id)))
  GROUP BY qal.name, ss.name, qal.percentage, qal.id, qa.organization_id, ss.id
  ORDER BY qal.id;


ALTER TABLE public.answer_sth_stage_adopted_level_view OWNER TO postgres;

--
-- Name: practitioners_eye_dimension; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.practitioners_eye_dimension (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.practitioners_eye_dimension OWNER TO postgres;

--
-- Name: practitioners_eye_element; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.practitioners_eye_element (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    dimension_id integer NOT NULL
);


ALTER TABLE public.practitioners_eye_element OWNER TO postgres;

--
-- Name: answer_sth_stage_eye_dimensions_adopted_level_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.answer_sth_stage_eye_dimensions_adopted_level_view AS
 SELECT qa.organization_id,
    qal.name AS adopted_level,
    qal.id AS adopted_level_id,
    qal.percentage AS adopted_level_percentage,
    ss.name AS sth_stage,
    ped.name AS eyes_dimension,
    count(*) AS practices_by_dimension
   FROM (((((public.questionnaire_answer qa
     JOIN public.questionnaire_statement qs ON ((qa.statement_id = qs.id)))
     JOIN public.sth_stage ss ON ((ss.id = qs.sth_stage_id)))
     JOIN public.practitioners_eye_element pee ON ((pee.id = qs.pe_element_id)))
     JOIN public.practitioners_eye_dimension ped ON ((ped.id = pee.dimension_id)))
     JOIN public.questionnaire_adoptedlevel qal ON ((qal.id = qa.adopted_level_id)))
  GROUP BY ped.name, qal.name, ss.name, qa.organization_id, qal.percentage, qal.id;


ALTER TABLE public.answer_sth_stage_eye_dimensions_adopted_level_view OWNER TO postgres;

--
-- Name: answer_sth_stage_eye_element_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.answer_sth_stage_eye_element_view AS
 SELECT qa.organization_id,
    qal.percentage AS adopted_level_percentage,
    ss.name AS sth_stage,
    pee.name AS eyes_element,
    count(*) AS practices_by_dimension
   FROM (((((public.questionnaire_answer qa
     JOIN public.questionnaire_statement qs ON ((qa.statement_id = qs.id)))
     JOIN public.sth_stage ss ON ((ss.id = qs.sth_stage_id)))
     JOIN public.practitioners_eye_element pee ON ((pee.id = qs.pe_element_id)))
     JOIN public.practitioners_eye_dimension ped ON ((ped.id = pee.dimension_id)))
     JOIN public.questionnaire_adoptedlevel qal ON ((qal.id = qa.adopted_level_id)))
  GROUP BY pee.name, ss.name, qa.organization_id, qal.percentage, qal.id;


ALTER TABLE public.answer_sth_stage_eye_element_view OWNER TO postgres;

--
-- Name: cse_framework_process; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cse_framework_process (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.cse_framework_process OWNER TO postgres;

--
-- Name: questionnaire_statement_fcse_processes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_statement_fcse_processes (
    id integer NOT NULL,
    statement_id integer NOT NULL,
    process_id integer NOT NULL
);


ALTER TABLE public.questionnaire_statement_fcse_processes OWNER TO postgres;

--
-- Name: answer_sth_stage_fce_process_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.answer_sth_stage_fce_process_view AS
 SELECT qa.organization_id,
    qal.percentage AS adopted_level_percentage,
    cfp.name AS process,
    ss.name AS sth_stage,
    count(*) AS practices_by_dimension
   FROM (((((public.questionnaire_answer qa
     JOIN public.questionnaire_statement qs ON ((qa.statement_id = qs.id)))
     JOIN public.questionnaire_statement_fcse_processes qsfp ON ((qsfp.statement_id = qs.id)))
     JOIN public.cse_framework_process cfp ON ((cfp.id = qsfp.process_id)))
     JOIN public.sth_stage ss ON ((ss.id = qs.sth_stage_id)))
     JOIN public.questionnaire_adoptedlevel qal ON ((qal.id = qa.adopted_level_id)))
  GROUP BY qa.organization_id, ss.name, cfp.name, qal.percentage;


ALTER TABLE public.answer_sth_stage_fce_process_view OWNER TO postgres;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: continuous_star_continuousphase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.continuous_star_continuousphase (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.continuous_star_continuousphase OWNER TO postgres;

--
-- Name: continuous_star_continuousactivities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.continuous_star_continuousactivities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.continuous_star_continuousactivities_id_seq OWNER TO postgres;

--
-- Name: continuous_star_continuousactivities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.continuous_star_continuousactivities_id_seq OWNED BY public.continuous_star_continuousphase.id;


--
-- Name: continuous_star_continuousactivity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.continuous_star_continuousactivity (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    continuous_phase_id integer NOT NULL
);


ALTER TABLE public.continuous_star_continuousactivity OWNER TO postgres;

--
-- Name: continuous_star_continuousactivity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.continuous_star_continuousactivity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.continuous_star_continuousactivity_id_seq OWNER TO postgres;

--
-- Name: continuous_star_continuousactivity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.continuous_star_continuousactivity_id_seq OWNED BY public.continuous_star_continuousactivity.id;


--
-- Name: cse_framework_process_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cse_framework_process_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cse_framework_process_id_seq OWNER TO postgres;

--
-- Name: cse_framework_process_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cse_framework_process_id_seq OWNED BY public.cse_framework_process.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: employee_academicdegree; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_academicdegree (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    category_id integer
);


ALTER TABLE public.employee_academicdegree OWNER TO postgres;

--
-- Name: employee_academicdegreecategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_academicdegreecategory (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.employee_academicdegreecategory OWNER TO postgres;

--
-- Name: employee_employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_employee (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    email character varying(254) NOT NULL,
    organization_id integer,
    role character varying(200) NOT NULL,
    position_id integer
);


ALTER TABLE public.employee_employee OWNER TO postgres;

--
-- Name: employee_employeeknowledge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_employeeknowledge (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    academic_degree_id integer NOT NULL,
    academic_degree_status_id integer NOT NULL,
    employee_id integer
);


ALTER TABLE public.employee_employeeknowledge OWNER TO postgres;

--
-- Name: employee_academic_category_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.employee_academic_category_view AS
 SELECT ea.name AS academic_category,
    employee.id AS employee_id,
    employee.organization_id
   FROM (((public.employee_academicdegreecategory ea
     JOIN public.employee_academicdegree ea2 ON ((ea2.category_id = ea.id)))
     JOIN public.employee_employeeknowledge ee ON ((ee.academic_degree_id = ea2.id)))
     JOIN public.employee_employee employee ON ((employee.id = ee.employee_id)));


ALTER TABLE public.employee_academic_category_view OWNER TO postgres;

--
-- Name: employee_experiencelevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_experiencelevel (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    value double precision NOT NULL
);


ALTER TABLE public.employee_experiencelevel OWNER TO postgres;

--
-- Name: employee_sthstageexperiencelevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_sthstageexperiencelevel (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    experience_level_id integer NOT NULL,
    stage_id integer NOT NULL,
    employee_id integer NOT NULL
);


ALTER TABLE public.employee_sthstageexperiencelevel OWNER TO postgres;

--
-- Name: employee_academic_category_experience_level_sth_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.employee_academic_category_experience_level_sth_view AS
 SELECT e_v.academic_category,
    ss.name AS sth,
    ek.value,
    count(ek.name) AS qtd
   FROM (((public.employee_academic_category_view e_v
     JOIN public.employee_sthstageexperiencelevel es ON ((es.employee_id = e_v.employee_id)))
     JOIN public.sth_stage ss ON ((ss.id = es.stage_id)))
     JOIN public.employee_experiencelevel ek ON ((ek.id = es.experience_level_id)))
  GROUP BY ss.name, e_v.academic_category, ek.value
  ORDER BY e_v.academic_category;


ALTER TABLE public.employee_academic_category_experience_level_sth_view OWNER TO postgres;

--
-- Name: employee_knwoledgelevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_knwoledgelevel (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    value double precision NOT NULL
);


ALTER TABLE public.employee_knwoledgelevel OWNER TO postgres;

--
-- Name: employee_sthstageknwoledgelevel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_sthstageknwoledgelevel (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    knwoledge_level_id integer NOT NULL,
    stage_id integer NOT NULL,
    employee_id integer NOT NULL
);


ALTER TABLE public.employee_sthstageknwoledgelevel OWNER TO postgres;

--
-- Name: employee_academic_category_knowledge_level_sth_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.employee_academic_category_knowledge_level_sth_view AS
 SELECT e_v.academic_category,
    ss.name AS sth,
    ek.value,
    count(ek.name) AS qtd
   FROM (((public.employee_academic_category_view e_v
     JOIN public.employee_sthstageknwoledgelevel es ON ((es.employee_id = e_v.employee_id)))
     JOIN public.sth_stage ss ON ((ss.id = es.stage_id)))
     JOIN public.employee_knwoledgelevel ek ON ((ek.id = es.knwoledge_level_id)))
  GROUP BY ss.name, e_v.academic_category, ek.value
  ORDER BY e_v.academic_category;


ALTER TABLE public.employee_academic_category_knowledge_level_sth_view OWNER TO postgres;

--
-- Name: employee_academiccategorydegree_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_academiccategorydegree_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_academiccategorydegree_id_seq OWNER TO postgres;

--
-- Name: employee_academiccategorydegree_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_academiccategorydegree_id_seq OWNED BY public.employee_academicdegreecategory.id;


--
-- Name: employee_academicdegree_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_academicdegree_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_academicdegree_id_seq OWNER TO postgres;

--
-- Name: employee_academicdegree_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_academicdegree_id_seq OWNED BY public.employee_academicdegree.id;


--
-- Name: employee_academicdegreestatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_academicdegreestatus (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.employee_academicdegreestatus OWNER TO postgres;

--
-- Name: employee_academicdegreestatus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_academicdegreestatus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_academicdegreestatus_id_seq OWNER TO postgres;

--
-- Name: employee_academicdegreestatus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_academicdegreestatus_id_seq OWNED BY public.employee_academicdegreestatus.id;


--
-- Name: employee_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_employee_id_seq OWNER TO postgres;

--
-- Name: employee_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_employee_id_seq OWNED BY public.employee_employee.id;


--
-- Name: employee_employeeknowledge_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_employeeknowledge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_employeeknowledge_id_seq OWNER TO postgres;

--
-- Name: employee_employeeknowledge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_employeeknowledge_id_seq OWNED BY public.employee_employeeknowledge.id;


--
-- Name: employee_experience_level_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.employee_experience_level_view AS
 SELECT ss.name AS sth,
    ek.name AS experience_level,
    ek.value,
    count(ek.name) AS qtd
   FROM (((public.employee_employee ee
     JOIN public.employee_sthstageexperiencelevel es ON ((es.employee_id = ee.id)))
     JOIN public.sth_stage ss ON ((ss.id = es.stage_id)))
     JOIN public.employee_experiencelevel ek ON ((ek.id = es.experience_level_id)))
  GROUP BY ss.name, ek.name, ek.value
  ORDER BY ss.name;


ALTER TABLE public.employee_experience_level_view OWNER TO postgres;

--
-- Name: employee_experiencelevel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_experiencelevel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_experiencelevel_id_seq OWNER TO postgres;

--
-- Name: employee_experiencelevel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_experiencelevel_id_seq OWNED BY public.employee_experiencelevel.id;


--
-- Name: employee_knwoledge_level_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.employee_knwoledge_level_view AS
 SELECT ss.name AS sth,
    ek.name AS knwoledge_level,
    ek.value,
    count(ek.name) AS qtd
   FROM (((public.employee_employee ee
     JOIN public.employee_sthstageknwoledgelevel es ON ((es.employee_id = ee.id)))
     JOIN public.sth_stage ss ON ((ss.id = es.stage_id)))
     JOIN public.employee_knwoledgelevel ek ON ((ek.id = es.knwoledge_level_id)))
  GROUP BY ss.name, ek.name, ek.value
  ORDER BY ss.name;


ALTER TABLE public.employee_knwoledge_level_view OWNER TO postgres;

--
-- Name: employee_knwoledgelevel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_knwoledgelevel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_knwoledgelevel_id_seq OWNER TO postgres;

--
-- Name: employee_knwoledgelevel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_knwoledgelevel_id_seq OWNED BY public.employee_knwoledgelevel.id;


--
-- Name: employee_position; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_position (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.employee_position OWNER TO postgres;

--
-- Name: employee_position_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_position_id_seq OWNER TO postgres;

--
-- Name: employee_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_position_id_seq OWNED BY public.employee_position.id;


--
-- Name: employee_sthstageexperiencelevel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_sthstageexperiencelevel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_sthstageexperiencelevel_id_seq OWNER TO postgres;

--
-- Name: employee_sthstageexperiencelevel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_sthstageexperiencelevel_id_seq OWNED BY public.employee_sthstageexperiencelevel.id;


--
-- Name: employee_sthstageknwoledgelevel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_sthstageknwoledgelevel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_sthstageknwoledgelevel_id_seq OWNER TO postgres;

--
-- Name: employee_sthstageknwoledgelevel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_sthstageknwoledgelevel_id_seq OWNED BY public.employee_sthstageknwoledgelevel.id;


--
-- Name: employee_team; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_team (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    organization_id integer NOT NULL,
    responsible_id integer NOT NULL
);


ALTER TABLE public.employee_team OWNER TO postgres;

--
-- Name: employee_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_team_id_seq OWNER TO postgres;

--
-- Name: employee_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_team_id_seq OWNED BY public.employee_team.id;


--
-- Name: organization_organization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_organization (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    age integer,
    location_id integer,
    organization_size_id integer,
    organization_type_id integer
);


ALTER TABLE public.organization_organization OWNER TO postgres;

--
-- Name: employee_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.employee_view AS
 SELECT DISTINCT qo.id AS organization_id,
    ee.id AS employee_id,
    ee.email AS employee_email,
    ep.name AS employee_position,
    ep.id AS employee_position_id,
    ea.name AS employee_academic_degree,
    ea.id AS employee_academic_degree_id,
    ea_status.name AS employee_academic_degree_status,
    ea_status.id AS employee_academic_degree_status_id,
    ss.name AS employee_sth_stage_knowledge,
    ss.id AS employee_sth_stage_knowledge_id,
    ek.name AS knwoledge_level,
    ek.id AS knwoledge_level_knowledge_id,
    ss2.name AS employee_sth_stage_experience,
    ss2.id AS employee_sth_stage_experience_id,
    ee2.name AS experience_level,
    ee2.id AS experience_id
   FROM (((((((((((public.organization_organization qo
     JOIN public.employee_employee ee ON ((qo.id = ee.organization_id)))
     JOIN public.employee_position ep ON ((ep.id = ee.position_id)))
     JOIN public.employee_employeeknowledge eknowledge ON ((eknowledge.employee_id = ee.id)))
     JOIN public.employee_academicdegree ea ON ((eknowledge.academic_degree_id = ea.id)))
     JOIN public.employee_academicdegreestatus ea_status ON ((ea_status.id = eknowledge.academic_degree_status_id)))
     JOIN public.employee_sthstageknwoledgelevel es ON ((es.employee_id = ee.id)))
     JOIN public.sth_stage ss ON ((ss.id = es.stage_id)))
     JOIN public.employee_knwoledgelevel ek ON ((ek.id = es.knwoledge_level_id)))
     JOIN public.employee_sthstageexperiencelevel es2 ON ((es2.employee_id = ee.id)))
     JOIN public.sth_stage ss2 ON ((ss2.id = es2.stage_id)))
     JOIN public.employee_experiencelevel ee2 ON ((ee2.id = es2.experience_level_id)));


ALTER TABLE public.employee_view OWNER TO postgres;

--
-- Name: organization_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_state (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    latitude double precision,
    longitude double precision,
    region_id integer
);


ALTER TABLE public.organization_state OWNER TO postgres;

--
-- Name: organization_location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_location_id_seq OWNER TO postgres;

--
-- Name: organization_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_location_id_seq OWNED BY public.organization_state.id;


--
-- Name: organization_organization_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_organization_id_seq OWNER TO postgres;

--
-- Name: organization_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_organization_id_seq OWNED BY public.organization_organization.id;


--
-- Name: organization_organizationcategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_organizationcategory (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.organization_organizationcategory OWNER TO postgres;

--
-- Name: organization_organizationcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_organizationcategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_organizationcategory_id_seq OWNER TO postgres;

--
-- Name: organization_organizationcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_organizationcategory_id_seq OWNED BY public.organization_organizationcategory.id;


--
-- Name: organization_organizationtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_organizationtype (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    category_id integer
);


ALTER TABLE public.organization_organizationtype OWNER TO postgres;

--
-- Name: organization_organizationtype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_organizationtype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_organizationtype_id_seq OWNER TO postgres;

--
-- Name: organization_organizationtype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_organizationtype_id_seq OWNED BY public.organization_organizationtype.id;


--
-- Name: organization_region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_region (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.organization_region OWNER TO postgres;

--
-- Name: organization_region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_region_id_seq OWNER TO postgres;

--
-- Name: organization_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_region_id_seq OWNED BY public.organization_region.id;


--
-- Name: organization_size; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization_size (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.organization_size OWNER TO postgres;

--
-- Name: organization_size_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organization_size_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_size_id_seq OWNER TO postgres;

--
-- Name: organization_size_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organization_size_id_seq OWNED BY public.organization_size.id;


--
-- Name: organization_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.organization_view AS
 SELECT oo.id AS organization_id,
    oo.name AS organization_name,
    oo.age,
    oo_type.name AS organization_type,
    oo_type.id AS type_id,
    oo_size.name AS organization_size,
    oo_size.id AS size_id,
    os.name AS state,
    orr.name AS region,
    orr.id AS region_id,
    ooc.name AS category,
    ooc.id AS category_id
   FROM (((((public.organization_organization oo
     JOIN public.organization_organizationtype oo_type ON ((oo.organization_type_id = oo_type.id)))
     JOIN public.organization_size oo_size ON ((oo.organization_size_id = oo_size.id)))
     JOIN public.organization_state os ON ((os.id = oo.location_id)))
     JOIN public.organization_region orr ON ((orr.id = os.region_id)))
     JOIN public.organization_organizationcategory ooc ON ((ooc.id = oo_type.category_id)));


ALTER TABLE public.organization_view OWNER TO postgres;

--
-- Name: practitioners_eye_dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.practitioners_eye_dimension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.practitioners_eye_dimension_id_seq OWNER TO postgres;

--
-- Name: practitioners_eye_dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.practitioners_eye_dimension_id_seq OWNED BY public.practitioners_eye_dimension.id;


--
-- Name: practitioners_eye_element_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.practitioners_eye_element_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.practitioners_eye_element_id_seq OWNER TO postgres;

--
-- Name: practitioners_eye_element_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.practitioners_eye_element_id_seq OWNED BY public.practitioners_eye_element.id;


--
-- Name: questionnaire_adoptedlevel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_adoptedlevel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questionnaire_adoptedlevel_id_seq OWNER TO postgres;

--
-- Name: questionnaire_adoptedlevel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_adoptedlevel_id_seq OWNED BY public.questionnaire_adoptedlevel.id;


--
-- Name: questionnaire_answer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_answer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questionnaire_answer_id_seq OWNER TO postgres;

--
-- Name: questionnaire_answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_answer_id_seq OWNED BY public.questionnaire_answer.id;


--
-- Name: questionnaire_answer_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.questionnaire_answer_view AS
 SELECT DISTINCT qo.name AS organization_name,
    qo.id AS organization_id,
    qa.comment AS answer_comment,
    qal.name AS adopted_level_name,
    qal.percentage AS adopted_level_percentage,
    qs.code,
    qs.statement,
    pee.name AS element,
    pec.name AS category,
    sth.name AS sth_stage,
    cfp.name AS process,
    os.name AS organization_size,
    ot.name AS organization_type,
    qo.age AS age_months
   FROM ((((((((((public.organization_organization qo
     JOIN public.questionnaire_answer qa ON ((qa.organization_id = qo.id)))
     JOIN public.questionnaire_adoptedlevel qal ON ((qal.id = qa.adopted_level_id)))
     JOIN public.questionnaire_statement qs ON ((qs.id = qa.statement_id)))
     JOIN public.practitioners_eye_element pee ON ((pee.id = qs.pe_element_id)))
     JOIN public.practitioners_eye_dimension pec ON ((pec.id = pee.dimension_id)))
     JOIN public.sth_stage sth ON ((sth.id = qs.sth_stage_id)))
     JOIN public.questionnaire_statement_fcse_processes sfp ON ((sfp.statement_id = qs.id)))
     JOIN public.cse_framework_process cfp ON ((cfp.id = sfp.process_id)))
     JOIN public.organization_size os ON ((qo.organization_size_id = os.id)))
     JOIN public.organization_organizationtype ot ON ((ot.id = qo.organization_type_id)));


ALTER TABLE public.questionnaire_answer_view OWNER TO postgres;

--
-- Name: questionnaire_feedbackquestionnaire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_feedbackquestionnaire (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    feedback_date timestamp with time zone
);


ALTER TABLE public.questionnaire_feedbackquestionnaire OWNER TO postgres;

--
-- Name: questionnaire_feedbackquestionnaire_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_feedbackquestionnaire_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questionnaire_feedbackquestionnaire_id_seq OWNER TO postgres;

--
-- Name: questionnaire_feedbackquestionnaire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_feedbackquestionnaire_id_seq OWNED BY public.questionnaire_feedbackquestionnaire.id;


--
-- Name: questionnaire_questionnaire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_questionnaire (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    modified_at timestamp with time zone NOT NULL,
    applied_date timestamp with time zone,
    document character varying(100) NOT NULL,
    uploaded_at timestamp with time zone NOT NULL,
    employee_id integer
);


ALTER TABLE public.questionnaire_questionnaire OWNER TO postgres;

--
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_questionnaire_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questionnaire_questionnaire_id_seq OWNER TO postgres;

--
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_questionnaire_id_seq OWNED BY public.questionnaire_questionnaire.id;


--
-- Name: questionnaire_questionnaireexcel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_questionnaireexcel (
    questionnaire_ptr_id integer NOT NULL,
    feedback_questionnaire_id integer
);


ALTER TABLE public.questionnaire_questionnaireexcel OWNER TO postgres;

--
-- Name: questionnaire_questionnairegoogleforms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire_questionnairegoogleforms (
    questionnaire_ptr_id integer NOT NULL
);


ALTER TABLE public.questionnaire_questionnairegoogleforms OWNER TO postgres;

--
-- Name: questionnaire_statement_fcse_processes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_statement_fcse_processes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questionnaire_statement_fcse_processes_id_seq OWNER TO postgres;

--
-- Name: questionnaire_statement_fcse_processes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_statement_fcse_processes_id_seq OWNED BY public.questionnaire_statement_fcse_processes.id;


--
-- Name: questionnaire_statement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_statement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questionnaire_statement_id_seq OWNER TO postgres;

--
-- Name: questionnaire_statement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_statement_id_seq OWNED BY public.questionnaire_statement.id;


--
-- Name: sth_stage_adopted_level_organization; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sth_stage_adopted_level_organization AS
 SELECT answer.organization_id,
    adopted_level.name AS adopted_level,
    ss.name AS sth_stage,
    count(answer.id) AS qtd_adopted_level,
    adopted_level.percentage AS adopted_level_percentege
   FROM (((public.questionnaire_adoptedlevel adopted_level
     LEFT JOIN public.questionnaire_answer answer ON ((answer.adopted_level_id = adopted_level.id)))
     JOIN public.questionnaire_statement qs ON ((qs.id = answer.statement_id)))
     JOIN public.sth_stage ss ON ((ss.id = qs.sth_stage_id)))
  GROUP BY answer.organization_id, adopted_level.name, ss.name, ss.id, adopted_level.id, adopted_level.percentage
  ORDER BY answer.organization_id, ss.id, adopted_level.id, ss.name, adopted_level.name;


ALTER TABLE public.sth_stage_adopted_level_organization OWNER TO postgres;

--
-- Name: sth_stage_adopted_level_organization_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.sth_stage_adopted_level_organization_view AS
 SELECT answer.organization_id,
    adopted_level.name AS adopted_level,
    ss.name AS sth_stage,
    count(answer.id) AS qtd_adopted_level,
    adopted_level.percentage AS adopted_level_percentege
   FROM (((public.questionnaire_adoptedlevel adopted_level
     LEFT JOIN public.questionnaire_answer answer ON ((answer.adopted_level_id = adopted_level.id)))
     JOIN public.questionnaire_statement qs ON ((qs.id = answer.statement_id)))
     JOIN public.sth_stage ss ON ((ss.id = qs.sth_stage_id)))
  GROUP BY answer.organization_id, adopted_level.name, ss.name, ss.id, adopted_level.id, adopted_level.percentage
  ORDER BY answer.organization_id, ss.id, adopted_level.id, ss.name, adopted_level.name;


ALTER TABLE public.sth_stage_adopted_level_organization_view OWNER TO postgres;

--
-- Name: sth_stage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sth_stage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sth_stage_id_seq OWNER TO postgres;

--
-- Name: sth_stage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sth_stage_id_seq OWNED BY public.sth_stage.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: continuous_star_continuousactivity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.continuous_star_continuousactivity ALTER COLUMN id SET DEFAULT nextval('public.continuous_star_continuousactivity_id_seq'::regclass);


--
-- Name: continuous_star_continuousphase id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.continuous_star_continuousphase ALTER COLUMN id SET DEFAULT nextval('public.continuous_star_continuousactivities_id_seq'::regclass);


--
-- Name: cse_framework_process id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cse_framework_process ALTER COLUMN id SET DEFAULT nextval('public.cse_framework_process_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: employee_academicdegree id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_academicdegree ALTER COLUMN id SET DEFAULT nextval('public.employee_academicdegree_id_seq'::regclass);


--
-- Name: employee_academicdegreecategory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_academicdegreecategory ALTER COLUMN id SET DEFAULT nextval('public.employee_academiccategorydegree_id_seq'::regclass);


--
-- Name: employee_academicdegreestatus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_academicdegreestatus ALTER COLUMN id SET DEFAULT nextval('public.employee_academicdegreestatus_id_seq'::regclass);


--
-- Name: employee_employee id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employee ALTER COLUMN id SET DEFAULT nextval('public.employee_employee_id_seq'::regclass);


--
-- Name: employee_employeeknowledge id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employeeknowledge ALTER COLUMN id SET DEFAULT nextval('public.employee_employeeknowledge_id_seq'::regclass);


--
-- Name: employee_experiencelevel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_experiencelevel ALTER COLUMN id SET DEFAULT nextval('public.employee_experiencelevel_id_seq'::regclass);


--
-- Name: employee_knwoledgelevel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_knwoledgelevel ALTER COLUMN id SET DEFAULT nextval('public.employee_knwoledgelevel_id_seq'::regclass);


--
-- Name: employee_position id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_position ALTER COLUMN id SET DEFAULT nextval('public.employee_position_id_seq'::regclass);


--
-- Name: employee_sthstageexperiencelevel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageexperiencelevel ALTER COLUMN id SET DEFAULT nextval('public.employee_sthstageexperiencelevel_id_seq'::regclass);


--
-- Name: employee_sthstageknwoledgelevel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageknwoledgelevel ALTER COLUMN id SET DEFAULT nextval('public.employee_sthstageknwoledgelevel_id_seq'::regclass);


--
-- Name: employee_team id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_team ALTER COLUMN id SET DEFAULT nextval('public.employee_team_id_seq'::regclass);


--
-- Name: organization_organization id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organization ALTER COLUMN id SET DEFAULT nextval('public.organization_organization_id_seq'::regclass);


--
-- Name: organization_organizationcategory id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organizationcategory ALTER COLUMN id SET DEFAULT nextval('public.organization_organizationcategory_id_seq'::regclass);


--
-- Name: organization_organizationtype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organizationtype ALTER COLUMN id SET DEFAULT nextval('public.organization_organizationtype_id_seq'::regclass);


--
-- Name: organization_region id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_region ALTER COLUMN id SET DEFAULT nextval('public.organization_region_id_seq'::regclass);


--
-- Name: organization_size id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_size ALTER COLUMN id SET DEFAULT nextval('public.organization_size_id_seq'::regclass);


--
-- Name: organization_state id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_state ALTER COLUMN id SET DEFAULT nextval('public.organization_location_id_seq'::regclass);


--
-- Name: practitioners_eye_dimension id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practitioners_eye_dimension ALTER COLUMN id SET DEFAULT nextval('public.practitioners_eye_dimension_id_seq'::regclass);


--
-- Name: practitioners_eye_element id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practitioners_eye_element ALTER COLUMN id SET DEFAULT nextval('public.practitioners_eye_element_id_seq'::regclass);


--
-- Name: questionnaire_adoptedlevel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_adoptedlevel ALTER COLUMN id SET DEFAULT nextval('public.questionnaire_adoptedlevel_id_seq'::regclass);


--
-- Name: questionnaire_answer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_answer ALTER COLUMN id SET DEFAULT nextval('public.questionnaire_answer_id_seq'::regclass);


--
-- Name: questionnaire_feedbackquestionnaire id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_feedbackquestionnaire ALTER COLUMN id SET DEFAULT nextval('public.questionnaire_feedbackquestionnaire_id_seq'::regclass);


--
-- Name: questionnaire_questionnaire id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_questionnaire ALTER COLUMN id SET DEFAULT nextval('public.questionnaire_questionnaire_id_seq'::regclass);


--
-- Name: questionnaire_statement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement ALTER COLUMN id SET DEFAULT nextval('public.questionnaire_statement_id_seq'::regclass);


--
-- Name: questionnaire_statement_fcse_processes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement_fcse_processes ALTER COLUMN id SET DEFAULT nextval('public.questionnaire_statement_fcse_processes_id_seq'::regclass);


--
-- Name: sth_stage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sth_stage ALTER COLUMN id SET DEFAULT nextval('public.sth_stage_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add activity	7	add_activity
26	Can change activity	7	change_activity
27	Can delete activity	7	delete_activity
28	Can view activity	7	view_activity
29	Can add billing	8	add_billing
30	Can change billing	8	change_billing
31	Can delete billing	8	delete_billing
32	Can view billing	8	view_billing
33	Can add location	9	add_location
34	Can change location	9	change_location
35	Can delete location	9	delete_location
36	Can view location	9	view_location
37	Can add organization type	10	add_organizationtype
38	Can change organization type	10	change_organizationtype
39	Can delete organization type	10	delete_organizationtype
40	Can view organization type	10	view_organizationtype
41	Can add size	11	add_size
42	Can change size	11	change_size
43	Can delete size	11	delete_size
44	Can view size	11	view_size
45	Can add organization	12	add_organization
46	Can change organization	12	change_organization
47	Can delete organization	12	delete_organization
48	Can view organization	12	view_organization
49	Can add development team overview	13	add_developmentteamoverview
50	Can change development team overview	13	change_developmentteamoverview
51	Can delete development team overview	13	delete_developmentteamoverview
52	Can view development team overview	13	view_developmentteamoverview
53	Can add time size	14	add_timesize
54	Can change time size	14	change_timesize
55	Can delete time size	14	delete_timesize
56	Can view time size	14	view_timesize
57	Can add academic degree	15	add_academicdegree
58	Can change academic degree	15	change_academicdegree
59	Can delete academic degree	15	delete_academicdegree
60	Can view academic degree	15	view_academicdegree
61	Can add academic degree status	16	add_academicdegreestatus
62	Can change academic degree status	16	change_academicdegreestatus
63	Can delete academic degree status	16	delete_academicdegreestatus
64	Can view academic degree status	16	view_academicdegreestatus
65	Can add employee	17	add_employee
66	Can change employee	17	change_employee
67	Can delete employee	17	delete_employee
68	Can view employee	17	view_employee
69	Can add employee knowledge	18	add_employeeknowledge
70	Can change employee knowledge	18	change_employeeknowledge
71	Can delete employee knowledge	18	delete_employeeknowledge
72	Can view employee knowledge	18	view_employeeknowledge
73	Can add experience level	19	add_experiencelevel
74	Can change experience level	19	change_experiencelevel
75	Can delete experience level	19	delete_experiencelevel
76	Can view experience level	19	view_experiencelevel
77	Can add knwoledge level	20	add_knwoledgelevel
78	Can change knwoledge level	20	change_knwoledgelevel
79	Can delete knwoledge level	20	delete_knwoledgelevel
80	Can view knwoledge level	20	view_knwoledgelevel
81	Can add team	21	add_team
82	Can change team	21	change_team
83	Can delete team	21	delete_team
84	Can view team	21	view_team
85	Can add sth stage knwoledge level	22	add_sthstageknwoledgelevel
86	Can change sth stage knwoledge level	22	change_sthstageknwoledgelevel
87	Can delete sth stage knwoledge level	22	delete_sthstageknwoledgelevel
88	Can view sth stage knwoledge level	22	view_sthstageknwoledgelevel
89	Can add sth stage experience level	23	add_sthstageexperiencelevel
90	Can change sth stage experience level	23	change_sthstageexperiencelevel
91	Can delete sth stage experience level	23	delete_sthstageexperiencelevel
92	Can view sth stage experience level	23	view_sthstageexperiencelevel
93	Can add position	24	add_position
94	Can change position	24	change_position
95	Can delete position	24	delete_position
96	Can view position	24	view_position
97	Can add process	25	add_process
98	Can change process	25	change_process
99	Can delete process	25	delete_process
100	Can view process	25	view_process
101	Can add stage	26	add_stage
102	Can change stage	26	change_stage
103	Can delete stage	26	delete_stage
104	Can view stage	26	view_stage
105	Can add element	27	add_element
106	Can change element	27	change_element
107	Can delete element	27	delete_element
108	Can view element	27	view_element
109	Can add dimension	28	add_dimension
110	Can change dimension	28	change_dimension
111	Can delete dimension	28	delete_dimension
112	Can view dimension	28	view_dimension
113	Can add adopted level	29	add_adoptedlevel
114	Can change adopted level	29	change_adoptedlevel
115	Can delete adopted level	29	delete_adoptedlevel
116	Can view adopted level	29	view_adoptedlevel
117	Can add feedback questionnaire	30	add_feedbackquestionnaire
118	Can change feedback questionnaire	30	change_feedbackquestionnaire
119	Can delete feedback questionnaire	30	delete_feedbackquestionnaire
120	Can view feedback questionnaire	30	view_feedbackquestionnaire
121	Can add statement	31	add_statement
122	Can change statement	31	change_statement
123	Can delete statement	31	delete_statement
124	Can view statement	31	view_statement
125	Can add questionnaire	32	add_questionnaire
126	Can change questionnaire	32	change_questionnaire
127	Can delete questionnaire	32	delete_questionnaire
128	Can view questionnaire	32	view_questionnaire
129	Can add answer	33	add_answer
130	Can change answer	33	change_answer
131	Can delete answer	33	delete_answer
132	Can view answer	33	view_answer
133	Can add questionnaire google forms	34	add_questionnairegoogleforms
134	Can change questionnaire google forms	34	change_questionnairegoogleforms
135	Can delete questionnaire google forms	34	delete_questionnairegoogleforms
136	Can view questionnaire google forms	34	view_questionnairegoogleforms
137	Can add questionnaire excel	35	add_questionnaireexcel
138	Can change questionnaire excel	35	change_questionnaireexcel
139	Can delete questionnaire excel	35	delete_questionnaireexcel
140	Can view questionnaire excel	35	view_questionnaireexcel
141	Can add state	9	add_state
142	Can change state	9	change_state
143	Can delete state	9	delete_state
144	Can view state	9	view_state
145	Can add region	36	add_region
146	Can change region	36	change_region
147	Can delete region	36	delete_region
148	Can view region	36	view_region
149	Can add continuous activity	37	add_continuousactivity
150	Can change continuous activity	37	change_continuousactivity
151	Can delete continuous activity	37	delete_continuousactivity
152	Can view continuous activity	37	view_continuousactivity
153	Can add continuous phase	38	add_continuousphase
154	Can change continuous phase	38	change_continuousphase
155	Can delete continuous phase	38	delete_continuousphase
156	Can view continuous phase	38	view_continuousphase
157	Can add organization category	39	add_organizationcategory
158	Can change organization category	39	change_organizationcategory
159	Can delete organization category	39	delete_organizationcategory
160	Can view organization category	39	view_organizationcategory
161	Can add academic category degree	40	add_academiccategorydegree
162	Can change academic category degree	40	change_academiccategorydegree
163	Can delete academic category degree	40	delete_academiccategorydegree
164	Can view academic category degree	40	view_academiccategorydegree
165	Can add academic degree category	40	add_academicdegreecategory
166	Can change academic degree category	40	change_academicdegreecategory
167	Can delete academic degree category	40	delete_academicdegreecategory
168	Can view academic degree category	40	view_academicdegreecategory
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$216000$f1qLzqSsp9mH$teqBYlicfwm3F9e87uLIV8gzb0NntVZkWpimF8jNIU0=	2022-04-23 21:40:53.493436+00	t	admin			admin@gmail.com	t	t	2022-04-20 22:42:25.699042+00
2	pbkdf2_sha256$390000$WVQeyFgrLodCS40n82HWdU$2jae6DgN/4PwQgvqANIVH9nTzqMQiu7aZ8OYIoml48c=	2023-02-11 14:19:36.120652+00	t	zeppelin			zeppelin@nemo.inf.ufes.br	t	t	2023-02-11 14:19:11.607504+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: continuous_star_continuousactivity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.continuous_star_continuousactivity (id, created_at, modified_at, name, description, continuous_phase_id) FROM stdin;
1	2022-04-21 17:27:42.310628+00	2022-04-21 17:27:42.310663+00	Continuous Planning	Continuous Planning	1
2	2022-04-21 17:28:12.245861+00	2022-04-21 17:28:12.245889+00	Continuous Budgeting	Continuous Budgeting	1
3	2022-04-21 17:28:32.771376+00	2022-04-21 17:28:32.771409+00	Continuous Integration	Continuous Integration	2
4	2022-04-21 17:28:46.938814+00	2022-04-21 17:28:46.93886+00	Continuous Deployment	Continuous Deployment	2
5	2022-04-21 17:29:02.016572+00	2022-04-21 17:29:02.016607+00	Continuous Delivery	Continuous Delivery	2
6	2022-04-21 17:29:23.419679+00	2022-04-21 17:29:23.419716+00	Continuous Verification/Testing	Continuous Verification/Testing	2
7	2022-04-21 17:29:44.035454+00	2022-04-21 17:29:44.035491+00	Continuous Security	Continuous Security	2
8	2022-04-21 17:30:25.267628+00	2022-04-21 17:30:25.267672+00	Continuous Compliance	Continuous Compliance	2
9	2022-04-21 17:30:50.751281+00	2022-04-21 17:30:50.751319+00	Continuous Evolution	Continuous Evolution	2
10	2022-04-21 17:31:25.749757+00	2022-04-21 17:31:25.749781+00	Continuous Use	Continuous Use	3
11	2022-04-21 17:31:43.778465+00	2022-04-21 17:31:43.778509+00	Continuous Trust	Continuous Trust	3
12	2022-04-21 17:32:11.850018+00	2022-04-21 17:32:11.850048+00	Continuous Run-Time Monitoring	Continuous Run-Time Monitoring	3
13	2022-04-21 17:34:05.346841+00	2022-04-21 17:34:05.346934+00	Continuous improvement	Continuous improvement	4
14	2022-04-21 17:34:36.292578+00	2022-04-21 17:34:36.292616+00	Continuous Innovation	Continuous Innovation	4
15	2022-04-21 17:34:52.935828+00	2022-04-21 17:34:52.935853+00	Continuous Experimentation	Continuous Experimentation	4
\.


--
-- Data for Name: continuous_star_continuousphase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.continuous_star_continuousphase (id, created_at, modified_at, name, description) FROM stdin;
1	2022-04-21 17:25:02.890503+00	2022-04-21 17:25:02.890537+00	Business Strategy & Planning	Business Strategy & Planning
2	2022-04-21 17:25:19.906473+00	2022-04-21 17:25:19.906495+00	Development	Development
3	2022-04-21 17:25:35.48229+00	2022-04-21 17:25:35.48231+00	Operations	Operations
4	2022-04-21 17:33:36.136928+00	2022-04-21 17:33:36.136952+00	Improvement and Innovation	Improvement and Innovation
\.


--
-- Data for Name: cse_framework_process; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cse_framework_process (id, created_at, modified_at, name, description) FROM stdin;
1	2022-04-20 23:37:43.144866+00	2022-04-20 23:37:43.14489+00	Business Alignment	Business Alignment
2	2022-04-20 23:37:50.544637+00	2022-04-20 23:37:50.54466+00	Continuous Planning, Monitoring and Control	Continuous Planning, Monitoring and Control
3	2022-04-20 23:37:58.838334+00	2022-04-20 23:37:58.838357+00	Continuous Quality Assurance	Continuous Quality Assurance
4	2022-04-20 23:38:18.483494+00	2022-04-20 23:38:18.483558+00	Cotinuous Improvement & Innovation	Cotinuous Improvement & Innovation
5	2022-04-20 23:38:30.938742+00	2022-04-20 23:38:30.938776+00	Continuous Knowledge Management	Continuous Knowledge Management
6	2022-04-20 23:38:40.681385+00	2022-04-20 23:38:40.681408+00	Agile Organization	Agile Organization
7	2022-04-20 23:38:51.558679+00	2022-04-20 23:38:51.558703+00	Continuous Integration	Continuous Integration
8	2022-04-20 23:39:07.259572+00	2022-04-20 23:39:07.259595+00	Continuous Deployment	Continuous Deployment
9	2022-04-20 23:39:45.844347+00	2022-04-20 23:39:45.844371+00	R&D as Innovation System	R&D as Innovation System
10	2022-04-21 20:03:23.740622+00	2022-04-21 20:03:23.740656+00	Continuous Software Measurement	Continuous Software Measurement
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2022-04-20 22:45:34.312881+00	1	Não adotada	1	[{"added": {}}]	29	1
2	2022-04-20 22:46:07.151794+00	2	Abandonada	1	[{"added": {}}]	29	1
3	2022-04-20 22:46:38.053043+00	3	Realizada no nível de projeto/produto	1	[{"added": {}}]	29	1
4	2022-04-20 22:47:04.037263+00	4	Realizada no nível de processo	1	[{"added": {}}]	29	1
5	2022-04-20 22:47:34.234223+00	5	Institucionalizada	1	[{"added": {}}]	29	1
6	2022-04-20 22:52:58.056598+00	1	Organização Ágil	1	[{"added": {}}]	26	1
7	2022-04-20 22:54:21.385069+00	2	Integração Contínua	1	[{"added": {}}]	26	1
8	2022-04-20 22:55:49.250934+00	3	Entrega Contínua	1	[{"added": {}}]	26	1
9	2022-04-20 22:57:44.116223+00	4	Experimentação Contínua	1	[{"added": {}}]	26	1
10	2022-04-20 22:58:28.289602+00	1	Organização Ágil	2	[{"changed": {"fields": ["Description"]}}]	26	1
11	2022-04-20 22:58:59.433059+00	2	Integração Contínua	2	[{"changed": {"fields": ["Description"]}}]	26	1
12	2022-04-20 22:59:29.602433+00	3	Entrega Contínua	2	[{"changed": {"fields": ["Description"]}}]	26	1
13	2022-04-20 23:00:22.260395+00	1	Fábrica de Software	1	[{"added": {}}]	10	1
14	2022-04-20 23:00:29.092685+00	2	Startup	1	[{"added": {}}]	10	1
15	2022-04-20 23:00:35.997314+00	3	Empresa Privada com departamento de TI	1	[{"added": {}}]	10	1
16	2022-04-20 23:00:42.561621+00	4	Empresa Pública com departamento de TI	1	[{"added": {}}]	10	1
17	2022-04-20 23:00:50.901253+00	5	Empresa em que um único produto de software representa o negócio (ex., PicPay, Airbnb, Uber)	1	[{"added": {}}]	10	1
18	2022-04-20 23:05:54.356502+00	1	01 a 09 funcionários	1	[{"added": {}}]	11	1
19	2022-04-20 23:06:00.830518+00	2	10 a 49 funcionários	1	[{"added": {}}]	11	1
20	2022-04-20 23:06:06.243227+00	3	50 a 99 funcionários	1	[{"added": {}}]	11	1
21	2022-04-20 23:06:12.577041+00	4	Mais de 99 funcionários	1	[{"added": {}}]	11	1
22	2022-04-20 23:12:04.969798+00	1	Region object (1)	1	[{"added": {}}]	36	1
23	2022-04-20 23:12:12.315495+00	2	Region object (2)	1	[{"added": {}}]	36	1
24	2022-04-20 23:12:56.070433+00	3	Sudeste	1	[{"added": {}}]	36	1
25	2022-04-20 23:12:59.382468+00	4	Sul	1	[{"added": {}}]	36	1
26	2022-04-20 23:13:14.9182+00	5	Centro-Oeste	1	[{"added": {}}]	36	1
27	2022-04-20 23:13:43.879229+00	1	Acre	1	[{"added": {}}]	9	1
28	2022-04-20 23:13:56.761669+00	2	Alagoas	1	[{"added": {}}]	9	1
29	2022-04-20 23:14:05.849685+00	3	Amapá	1	[{"added": {}}]	9	1
30	2022-04-20 23:14:11.952106+00	4	Amazonas	1	[{"added": {}}]	9	1
31	2022-04-20 23:14:18.535915+00	5	Bahia	1	[{"added": {}}]	9	1
32	2022-04-20 23:14:28.114487+00	6	Ceará	1	[{"added": {}}]	9	1
33	2022-04-20 23:14:34.605573+00	7	Distrito Federal	1	[{"added": {}}]	9	1
34	2022-04-20 23:14:40.424031+00	8	Espírito Santo	1	[{"added": {}}]	9	1
35	2022-04-20 23:14:46.218216+00	9	Goiás	1	[{"added": {}}]	9	1
36	2022-04-20 23:14:52.64553+00	10	Maranhão	1	[{"added": {}}]	9	1
37	2022-04-20 23:14:58.578176+00	11	Mato Grosso	1	[{"added": {}}]	9	1
38	2022-04-20 23:15:03.784618+00	12	Mato Grosso do Sul	1	[{"added": {}}]	9	1
39	2022-04-20 23:15:09.107272+00	13	Minas Gerais	1	[{"added": {}}]	9	1
40	2022-04-20 23:15:15.055207+00	14	Pará	1	[{"added": {}}]	9	1
41	2022-04-20 23:15:21.440798+00	15	Paraíba	1	[{"added": {}}]	9	1
42	2022-04-20 23:15:26.829988+00	16	Paraná	1	[{"added": {}}]	9	1
43	2022-04-20 23:15:31.954701+00	17	Pernambuco	1	[{"added": {}}]	9	1
44	2022-04-20 23:15:37.37804+00	18	Piauí	1	[{"added": {}}]	9	1
45	2022-04-20 23:15:43.365339+00	19	Rio de Janeiro	1	[{"added": {}}]	9	1
46	2022-04-20 23:15:49.604715+00	20	Rio Grande do Norte	1	[{"added": {}}]	9	1
47	2022-04-20 23:15:56.509864+00	21	Rio Grande do Sul	1	[{"added": {}}]	9	1
48	2022-04-20 23:16:03.837331+00	22	Rondônia	1	[{"added": {}}]	9	1
49	2022-04-20 23:16:09.85707+00	23	Roraima	1	[{"added": {}}]	9	1
50	2022-04-20 23:16:15.623798+00	24	Santa Catarina	1	[{"added": {}}]	9	1
51	2022-04-20 23:16:20.915781+00	25	São Paulo	1	[{"added": {}}]	9	1
52	2022-04-20 23:16:26.361968+00	26	Sergipe	1	[{"added": {}}]	9	1
53	2022-04-20 23:16:34.186308+00	27	Tocantins	1	[{"added": {}}]	9	1
54	2022-04-20 23:28:45.161752+00	1	Ensino Médio	1	[{"added": {}}]	15	1
55	2022-04-20 23:28:51.684151+00	2	Ensino Técnico	1	[{"added": {}}]	15	1
56	2022-04-20 23:29:01.298514+00	3	Ensino Superior	1	[{"added": {}}]	15	1
57	2022-04-20 23:29:08.379456+00	4	Especialização	1	[{"added": {}}]	15	1
58	2022-04-20 23:29:19.320239+00	5	Mestrado	1	[{"added": {}}]	15	1
59	2022-04-20 23:29:27.931021+00	6	Doutorado	1	[{"added": {}}]	15	1
60	2022-04-20 23:29:52.726672+00	1	Incompleto	1	[{"added": {}}]	16	1
61	2022-04-20 23:30:11.163118+00	1	Gerente de Projeto	1	[{"added": {}}]	24	1
62	2022-04-20 23:30:16.506035+00	2	Scrum Master	1	[{"added": {}}]	24	1
63	2022-04-20 23:30:23.08081+00	3	Product Owner	1	[{"added": {}}]	24	1
64	2022-04-20 23:30:28.653499+00	4	Desenvolvedor	1	[{"added": {}}]	24	1
65	2022-04-20 23:30:34.727891+00	5	Líder Técnico	1	[{"added": {}}]	24	1
66	2022-04-20 23:30:41.047858+00	6	Diretor	1	[{"added": {}}]	24	1
67	2022-04-20 23:31:47.228551+00	1	Nenhum	1	[{"added": {}}]	19	1
68	2022-04-20 23:32:07.93573+00	2	Baixo	1	[{"added": {}}]	19	1
69	2022-04-20 23:32:24.806023+00	3	Moderado	1	[{"added": {}}]	19	1
70	2022-04-20 23:32:38.224909+00	4	Alto	1	[{"added": {}}]	19	1
71	2022-04-20 23:33:19.000965+00	2	Baixo	2	[{"changed": {"fields": ["Description"]}}]	19	1
72	2022-04-20 23:33:42.282171+00	3	Moderada	2	[{"changed": {"fields": ["Name", "Description"]}}]	19	1
73	2022-04-20 23:34:02.973381+00	4	Alta	2	[{"changed": {"fields": ["Name", "Description"]}}]	19	1
74	2022-04-20 23:34:17.934111+00	2	Baixa	2	[{"changed": {"fields": ["Name"]}}]	19	1
75	2022-04-20 23:34:40.348964+00	1	Baixo	1	[{"added": {}}]	20	1
76	2022-04-20 23:34:55.64009+00	1	Nenhum	2	[{"changed": {"fields": ["Name"]}}]	20	1
77	2022-04-20 23:35:10.669741+00	2	Baixo	1	[{"added": {}}]	20	1
78	2022-04-20 23:35:29.1625+00	3	Moderado	1	[{"added": {}}]	20	1
79	2022-04-20 23:35:40.74686+00	4	Alto	1	[{"added": {}}]	20	1
80	2022-04-20 23:36:48.850709+00	2	Completo	1	[{"added": {}}]	16	1
81	2022-04-20 23:37:43.14608+00	1	Business Alignment	1	[{"added": {}}]	25	1
82	2022-04-20 23:37:50.545661+00	2	Continuous Planning, Monitoring and Control	1	[{"added": {}}]	25	1
83	2022-04-20 23:37:58.839329+00	3	Continuous Quality Assurance	1	[{"added": {}}]	25	1
84	2022-04-20 23:38:18.486421+00	4	Cotinuous Improvement & Innovation	1	[{"added": {}}]	25	1
85	2022-04-20 23:38:30.940017+00	5	Continuous Knowledge Management	1	[{"added": {}}]	25	1
86	2022-04-20 23:38:40.682522+00	6	Agile Organization	1	[{"added": {}}]	25	1
87	2022-04-20 23:38:51.559686+00	7	Continuous Integration	1	[{"added": {}}]	25	1
88	2022-04-20 23:39:07.260595+00	8	Continuous Deployment	1	[{"added": {}}]	25	1
89	2022-04-20 23:39:45.845336+00	9	R&D as Innovation System	1	[{"added": {}}]	25	1
90	2022-04-20 23:40:13.709727+00	1	Development	1	[{"added": {}}]	28	1
91	2022-04-20 23:40:20.411094+00	2	Quality	1	[{"added": {}}]	28	1
92	2022-04-20 23:40:28.196666+00	3	Software Management	1	[{"added": {}}]	28	1
93	2022-04-20 23:40:34.35201+00	4	Team	1	[{"added": {}}]	28	1
94	2022-04-20 23:40:40.120141+00	5	Technical Solution	1	[{"added": {}}]	28	1
95	2022-04-20 23:40:45.427682+00	6	Knowledge	1	[{"added": {}}]	28	1
96	2022-04-20 23:40:51.557004+00	7	Operation	1	[{"added": {}}]	28	1
97	2022-04-20 23:40:57.76251+00	8	Business	1	[{"added": {}}]	28	1
98	2022-04-20 23:41:03.30168+00	9	User/Customer	1	[{"added": {}}]	28	1
99	2022-04-20 23:41:33.397911+00	1	Development - Code coverage	1	[{"added": {}}]	27	1
100	2022-04-20 23:41:42.004866+00	2	Development - Continuous planning activities	1	[{"added": {}}]	27	1
101	2022-04-20 23:41:50.16499+00	3	Development - Continuous requirements engineering	1	[{"added": {}}]	27	1
102	2022-04-20 23:41:58.271941+00	4	Development - Focus on Feature	1	[{"added": {}}]	27	1
103	2022-04-20 23:42:07.435167+00	5	Development - Modularized archiitecture and design	1	[{"added": {}}]	27	1
104	2022-04-20 23:42:17.032117+00	6	Quality - Audits	1	[{"added": {}}]	27	1
105	2022-04-20 23:42:26.696108+00	7	Quality - Automated Tests	1	[{"added": {}}]	27	1
106	2022-04-20 23:42:36.83899+00	8	Quality - Pull-Request	1	[{"added": {}}]	27	1
107	2022-04-20 23:42:47.05094+00	9	Quality - Regular Builds	1	[{"added": {}}]	27	1
108	2022-04-20 23:42:57.543288+00	10	Software Management - Agile Practice	1	[{"added": {}}]	27	1
109	2022-04-20 23:43:07.354213+00	11	Software Management - Continuos delivery	1	[{"added": {}}]	27	1
110	2022-04-20 23:43:17.835984+00	12	Software Management - Continuos deployment of releases	1	[{"added": {}}]	27	1
111	2022-04-20 23:43:26.949363+00	13	Software Management - Continuos integration of work	1	[{"added": {}}]	27	1
112	2022-04-20 23:43:38.384396+00	14	Team - Contemporay and continuously evolving skills	1	[{"added": {}}]	27	1
113	2022-04-20 23:43:47.165243+00	15	Team - Self-reflection and discipline	1	[{"added": {}}]	27	1
114	2022-04-20 23:44:04.453761+00	16	Technical Solution - Branching strategies	1	[{"added": {}}]	27	1
115	2022-04-20 23:44:12.758556+00	17	Technical Solution - Code review	1	[{"added": {}}]	27	1
116	2022-04-20 23:44:23.934193+00	18	Technical Solution - Version control	1	[{"added": {}}]	27	1
117	2022-04-20 23:44:33.650646+00	19	Knowledge - Capturing decisions and rationale	1	[{"added": {}}]	27	1
118	2022-04-20 23:44:43.783053+00	20	Knowledge - Continuos learning	1	[{"added": {}}]	27	1
119	2022-04-20 23:44:53.97153+00	21	Knowledge - Sharing Knowledge	1	[{"added": {}}]	27	1
120	2022-04-20 23:45:06.383636+00	22	Operation - Logging and monitoring	1	[{"added": {}}]	27	1
121	2022-04-20 23:45:15.92869+00	23	Operation - Reusable infrastructure	1	[{"added": {}}]	27	1
122	2022-04-20 23:45:24.092585+00	24	Business - Appropriate product ideia	1	[{"added": {}}]	27	1
123	2022-04-20 23:45:32.064302+00	25	Business - Management commitement	1	[{"added": {}}]	27	1
124	2022-04-20 23:45:41.737603+00	26	User/Customer - Involved users other stakeholders	1	[{"added": {}}]	27	1
125	2022-04-20 23:45:51.458772+00	27	User/Customer - Learning from usage data and feedback	1	[{"added": {}}]	27	1
126	2022-04-20 23:46:00.248249+00	28	User/Customer - Proactive customers	1	[{"added": {}}]	27	1
127	2022-04-20 23:51:04.006791+00	1	AO.01-Papéis envolvidos no processo de desenvolvimento ágil (e.g., Scrum Master, Product Owner, Desenvolvedor e Tester) existem na organização.	1	[{"added": {}}]	31	1
128	2022-04-20 23:51:47.816923+00	2	AO.02-As equipes dos projetos incluem um papel (p.ex., product owner) que é responsável por representar o cliente e participa ativamente	1	[{"added": {}}]	31	1
129	2022-04-20 23:52:19.305912+00	3	AO.03-As equipes dos projetos são pequenas (geralmente entre 4 e 8 desenvolvedores), autoorganizadas e multidisciplinares.	1	[{"added": {}}]	31	1
130	2022-04-20 23:52:24.060697+00	3	AO.03-As equipes dos projetos são pequenas (geralmente entre 4 e 8 desenvolvedores), autoorganizadas e multidisciplinares.	2	[]	31	1
131	2022-04-20 23:53:05.950862+00	4	AO.03-Com o intuito de entregar valor para o cliente, os requisitos são definidos e priorizados de acordo com as necessidades do cliente, são periodicamente revisados e mudanças são absorvidas em iter	1	[{"added": {}}]	31	1
132	2022-04-20 23:53:19.339855+00	4	AO.04-Com o intuito de entregar valor para o cliente, os requisitos são definidos e priorizados de acordo com as necessidades do cliente, são periodicamente revisados e mudanças são absorvidas em iter	2	[{"changed": {"fields": ["Code"]}}]	31	1
133	2022-04-20 23:53:44.272767+00	5	AO.05-O escopo do projeto é definido gradativamente, utilizando-se um Product Backlog (ou artefato equivalente).	1	[{"added": {}}]	31	1
134	2022-04-20 23:54:13.35717+00	6	AO.06-Estimativas de esforço são realizadas pela equipe de desenvolvimento (ou em conjunto com ela) considerando-se tarefas curtas para implementar um conjunto de requisitos selecionados (e não o proj	1	[{"added": {}}]	31	1
135	2022-04-21 00:58:52.075165+00	7	AO.07-Estimativas de custos são estabelecidas com base nas estimativas de esforço, considerando-se o esforço necessário para implementar um conjunto de requisitos selecionados (e não o projeto como um	1	[{"added": {}}]	31	1
136	2022-04-21 00:59:30.932274+00	8	AO.08-O processo de desenvolvimento é ágil, sendo realizado de forma iterativa, em ciclos curtos (p.ex., duas semanas), nos quais requisitos do produto definidos em um Product Backlog (ou artefato equ	1	[{"added": {}}]	31	1
137	2022-04-21 00:59:57.414853+00	9	AO.09-Há critérios de aceitação claros para os requisitos do software e eles são usados para avaliar os artefatos produzidos (p.ex., funcionalidades) e definir se estão "prontos".	1	[{"added": {}}]	31	1
138	2022-04-21 01:01:23.442256+00	10	AO.10-O cliente recebe novas versões do produto com frequência (após um ou mais ciclos curtos de desenvolvimento), incluindo novas funcionalidades definidas de acordo com as necessidades do cliente.	1	[{"added": {}}]	31	1
139	2022-04-21 01:02:07.267425+00	11	AO.11-O processo de desenvolvimento (ágil) está alinhado ao negócio da organização e isso é percebido pela entrega de valor ao cliente e pela sua satisfação com o produto entregue.	1	[{"added": {}}]	31	1
140	2022-04-21 01:02:53.843471+00	12	AO.12-Há pelo menos um papel (p.ex., tech lead, analista de qualidade) responsável pela qualidade dos artefatos produzidos e do produto final.	1	[{"added": {}}]	31	1
141	2022-04-21 01:03:19.798505+00	13	AO.13-Os stakeholders do projeto (incluindo o cliente) são estimulados a refletir sobre seu sobre seu papel e suas responsabilidades no projeto.	1	[{"added": {}}]	31	1
223	2022-04-21 14:43:58.113612+00	21	i4sea	3		12	1
142	2022-04-21 01:03:43.174382+00	14	AO.14-A equipe do projeto possui autonomia para tomar decisões técnicas no projeto.	1	[{"added": {}}]	31	1
143	2022-04-21 01:04:19.305979+00	15	AO.15-Frequentemente (p.ex.., diariamente, a cada dois ou três dias) a equipe se reúne e reflete sobre o progresso do desenvolvimento no âmbito do que foi definido para o time-box corrente e ajusta as	1	[{"added": {}}]	31	1
144	2022-04-21 01:04:50.019443+00	16	AO.16-A equipe se reúne com frequência ao longo do projeto para discutir sobre melhorias no produto, no processo ou nas ferramentas usadas (p.ex., em reunião de retrospectiva).	1	[{"added": {}}]	31	1
145	2022-04-21 01:05:16.193008+00	17	AO.17-A equipe se reúne com frequência ao longo do projeto para discutir sobre melhorias nas competências dos membros da equipe (p.ex., em reunião de retrospectiva)	1	[{"added": {}}]	31	1
146	2022-04-21 01:05:53.240294+00	18	AO.18-O processo de desenvolvimento (ágil) é avaliado e melhorado continuamente.	1	[{"added": {}}]	31	1
147	2022-04-21 01:06:22.670873+00	19	AO.19-Boas práticas de programação são adotadas (p.ex., código coletivo, codificação padronizada, programação em pares, revisão de código)	1	[{"added": {}}]	31	1
148	2022-04-21 01:06:56.677757+00	20	AO.20-Boas práticas de testes (p.ex., teste automatizado, desenvolvimento orientado a testes) são adotadas.	1	[{"added": {}}]	31	1
149	2022-04-21 01:07:31.272786+00	21	AO.21-Dados são coletados para métricas que permitem avaliar aspectos da qualidade dos artefatos produzidos e do produto (p.ex., complexidade ciclomática, quantidade de code smells).	1	[{"added": {}}]	31	1
150	2022-04-21 01:08:08.445233+00	22	AO.22-Dados são coletados para métricas que permitem avaliar aspectos de desempenho do processo de desenvolvimento ágil (p.ex., work in progress, velocidade).	1	[{"added": {}}]	31	1
151	2022-04-21 01:08:36.656148+00	23	AO.23-Dados produzidos ao longo do processo de desenvolvimento (p.ex., data de início das tarefas, data de conclusão das tarefas, pontos de história das tarefas) são armazenados em um (ou mais) reposi	1	[{"added": {}}]	31	1
152	2022-04-21 01:09:03.23337+00	24	AO.24-Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de desenvolvimento ágil.	1	[{"added": {}}]	31	1
153	2022-04-21 01:09:43.726352+00	25	AO.25-Decisões nos projetos são tomadas com base em dados presentes no(s) repositório(s) de dados.	1	[{"added": {}}]	31	1
154	2022-04-21 01:10:04.768602+00	26	AO.26-São realizadas ações para compartilhar conhecimento relevante ao desenvolvimento ágil (p.ex., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	1	[{"added": {}}]	31	1
155	2022-04-21 01:10:55.769566+00	27	CI.01-A arquitetura do software é modular de forma a permitir a realização de testes automatizados.	1	[{"added": {}}]	31	1
156	2022-04-21 01:11:25.805631+00	28	CI.02-A arquitetura do software é modular de forma a permitir a realização de builds automatizados.	1	[{"added": {}}]	31	1
157	2022-04-21 01:12:06.714688+00	29	CI.03-O código é integrado constantemente e automaticamente.	1	[{"added": {}}]	31	1
158	2022-04-21 01:12:31.840853+00	30	CI.04-Testes são executados automaticamente, periodicamente (p.ex., sempre que código novo é integrado), em um ambiente de teste, para verificar a qualidade do código (p.ex., cobertura, corretude).	1	[{"added": {}}]	31	1
159	2022-04-21 01:13:06.642718+00	31	CI.05-Testes automatizados são utilizados para avaliar se o software implementado atende os requisitos estabelecidos.	1	[{"added": {}}]	31	1
160	2022-04-21 01:13:45.231994+00	32	CI.06-Builds ocorrem frequentemente e automaticamente.	1	[{"added": {}}]	31	1
161	2022-04-21 01:14:18.759257+00	33	CI.07-Builds são cancelados caso um ou mais testes falhem.	1	[{"added": {}}]	31	1
162	2022-04-21 01:14:44.4102+00	34	CI.08-Há controle de versões dos artefatos de software (p.ex., código, teste, scripts etc.) em um repositório	1	[{"added": {}}]	31	1
163	2022-04-21 01:15:14.13376+00	35	CI.09-Boas práticas de check in são aplicadas no trunk de desenvolvimento (p.ex., uso de ferramentas como GitFlow e Toogle Feature).	1	[{"added": {}}]	31	1
164	2022-04-21 01:15:37.997143+00	36	CI.10-Há práticas que permitem que organizações ou pessoas externas ao projeto atuem na implementação do produto (i.e., produzam e integrem código ao produto sendo desenvolvido)	1	[{"added": {}}]	31	1
165	2022-04-21 01:16:03.012853+00	37	CI.11-Dados são coletados para métricas que permitem avaliar o processo de integração contínua (p.ex., quantidade de builds cancelados, quantidade de integrações de código realizadas)	1	[{"added": {}}]	31	1
166	2022-04-21 01:16:42.86463+00	38	CI.12-Dados produzidos nos ambientes de integração contínua (p.ex., data das builds, quantidade de testes executados e percentual de cobertura)  são armazenados em um (ou mais) repositório de dados	1	[{"added": {}}]	31	1
167	2022-04-21 01:17:24.403657+00	39	CI.13-O processo de integração contínua (incluindo a realização de testes automatizados) é avaliado e melhorado continuamente	1	[{"added": {}}]	31	1
168	2022-04-21 01:17:57.409202+00	40	CI.14-Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de integração contínua.	1	[{"added": {}}]	31	1
169	2022-04-21 01:18:23.182624+00	41	CI.15-São realizadas ações para compartilhar conhecimento relacionado a integração contínua (p.ex., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	1	[{"added": {}}]	31	1
170	2022-04-21 01:19:57.295705+00	42	CD.01-Os principais clientes/consumidores são identificados e participam do processo de desenvolvimento, influenciando nas funcionalidades que serão produzidas e entregues.	1	[{"added": {}}]	31	1
171	2022-04-21 01:20:38.509057+00	43	CD.02-Há um fluxo de informação claro entre Desenvolvimento e Operação, permitindo que novas funcionalidades desenvolvidas entrem em operação automaticamente.	1	[{"added": {}}]	31	1
172	2022-04-21 01:21:05.181178+00	44	CD.03-A entrega de novas funcionalidades é realizada automaticamente e por releases.	1	[{"added": {}}]	31	1
173	2022-04-21 01:21:33.958286+00	45	CD.04-Há um fluxo de informação claro entre Operação e Negócio, permitindo que novas necessidades dos clientes/consumidores e oportunidades de negócio sejam identificadas a partir da entrega de novas 	1	[{"added": {}}]	31	1
174	2022-04-21 01:22:22.75975+00	46	CD.05-A arquitetura do software permite realizar entrega (deploy) de funcionalidades de forma independente.	1	[{"added": {}}]	31	1
175	2022-04-21 01:22:46.247247+00	47	CD.06-Clientes/consumidores recebem novas funcionalidades com frequência, inclusive, em ciclos mais curtos do que o time-box que costuma ser estabelecido no processo de desenvolvimento.	1	[{"added": {}}]	31	1
176	2022-04-21 01:23:06.979775+00	48	CD.07-Os clientes podem realizar testes no produto assim que é feita a entrega (deploy) de novas funcionalidades.	1	[{"added": {}}]	31	1
177	2022-04-21 01:23:38.765601+00	49	CD.08-O modelo de negócio da organização é constantemente avaliado e revisto (quando necessário) com base em informações dos clientes/consumidores.	1	[{"added": {}}]	31	1
224	2022-04-21 14:43:58.130932+00	15	Ifes	3		12	1
225	2022-04-21 14:43:58.1472+00	10	Kinvo	3		12	1
178	2022-04-21 01:24:11.900318+00	50	CD.09-Estratégias de marketing são constantemente avaliadas e revistas (quando necessário) com base em informações dos lead customers (clientes/consumidores mais relevantes para a organização).	1	[{"added": {}}]	31	1
179	2022-04-21 01:24:34.947999+00	51	CD.10-Estratégias de venda são constantemente avaliadas e revistas (quando necessário) com base em informações dos lead customers (clientes/consumidores mais relevantes para a organização).	1	[{"added": {}}]	31	1
180	2022-04-21 01:25:06.062898+00	52	CD.11-Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos.	1	[{"added": {}}]	31	1
181	2022-04-21 01:25:33.994935+00	53	CD.12-Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos e baseando-se em dados.	1	[{"added": {}}]	31	1
182	2022-04-21 01:26:05.642145+00	54	CD.13-Dados são coletados para métricas que permitem avaliar o processo de entrega contínua  (p.ex., quantidade de releases, densidade de defeitos nas releases).	1	[{"added": {}}]	31	1
183	2022-04-21 01:26:29.642247+00	55	CD.14-Dados produzidos nos ambientes de entrega contínua (p.ex., data das releases e versão do software entregue)  são armazenados em um (ou mais) repositório de dados.	1	[{"added": {}}]	31	1
184	2022-04-21 01:26:57.243265+00	56	CD.15-O  processo de entrega contínua é avaliado e melhorado continuamente.	1	[{"added": {}}]	31	1
185	2022-04-21 01:27:26.023726+00	57	CD.16-Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de entrega contínua.	1	[{"added": {}}]	31	1
186	2022-04-21 01:27:54.987862+00	58	CD.17-São realizadas ações para compartilhar conhecimento relacionado a entrega contínua (e.g., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	1	[{"added": {}}]	31	1
187	2022-04-21 01:29:15.745052+00	59	IS.01-Feedbacks (dados e opiniões) dos clientes/consumidores são capturados contínua e automaticamente e armazenados em um (ou mais) repositório de dados de clientes/consumidores,	1	[{"added": {}}]	31	1
188	2022-04-21 01:29:43.508086+00	60	IS.02-Feedbacks (dados e opiniões) dos clientes/consumidores (capturados contínua e automaticamente) são utilizados para melhorar os produtos (melhorar funcionalidades existentes e identificar novas).	1	[{"added": {}}]	31	1
189	2022-04-21 01:30:04.19247+00	61	IS.03-A organização identifica novas oportunidades de negócio com base nos feedbacks capturados automaticamente dos clientes/consumidores	1	[{"added": {}}]	31	1
190	2022-04-21 01:30:24.866268+00	62	IS.04-Feedbacks (dados e opiniões) dos clientes/consumidores (capturados contínua e automaticamente) são usados para experimentação e inovação	1	[{"added": {}}]	31	1
191	2022-04-21 01:30:49.791178+00	63	IS.05-Experimentos (p.ex., testes A/B) são realizados com os clientes/consumidores para melhorar os produtos	1	[{"added": {}}]	31	1
192	2022-04-21 01:31:10.775415+00	64	IS.06-São adotadas tecnologias (p.ex.., tecnologias de nuvem) que permitem potencializar a experimentação.	1	[{"added": {}}]	31	1
193	2022-04-21 01:31:33.320381+00	65	IS.07-A organização continuamente experimenta novas tecnologias e metodologias,	1	[{"added": {}}]	31	1
194	2022-04-21 01:31:58.854937+00	66	IS.08-Há um fluxo de informação claro entre o nível estratégico e a área de desenvolvimento da organização, permitindo que dados dos clientes/consumidores (capturados contínua e automaticamente) sejam	1	[{"added": {}}]	31	1
195	2022-04-21 01:32:22.861142+00	67	IS.09-Dados do repositório de dados dos clientes/consumidores são usados na tomada de decisão pela área de desenvolvimento de software.	1	[{"added": {}}]	31	1
196	2022-04-21 01:32:55.420875+00	68	IS.10-Dados do(s) repositório(a) de dados dos clientes/consumidores são usados na tomada de decisão pela área de negócios	1	[{"added": {}}]	31	1
197	2022-04-21 01:33:40.911651+00	69	IS.11-Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos e baseando-se em dados do(s) repositório(a) de dados dos	1	[{"added": {}}]	31	1
198	2022-04-21 01:34:10.159324+00	70	IS.12-O processo de experimentação contínua é avaliado e melhorado continuamente.	1	[{"added": {}}]	31	1
199	2022-04-21 01:34:43.262365+00	71	IS.13-São realizadas ações para compartilhar conhecimento relacionado a experimentação  contínua (e.g., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	1	[{"added": {}}]	31	1
200	2022-04-21 13:50:47.36176+00	1	AO.01-Papéis envolvidos no processo de desenvolvimento ágil (e.g., Scrum Master, Product Owner, Desenvolvedor e Tester) existem na organização.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
201	2022-04-21 13:52:03.976219+00	2	AO.02-As equipes dos projetos incluem um papel (p.ex., product owner) que é responsável por representar o cliente e participa ativamente	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
202	2022-04-21 13:53:18.986537+00	3	AO.03-As equipes dos projetos são pequenas (geralmente entre 4 e 8 desenvolvedores), autoorganizadas e multidisciplinares.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
203	2022-04-21 13:56:02.839092+00	3	AO.03-As equipes dos projetos são pequenas (geralmente entre 4 e 8 desenvolvedores), autoorganizadas e multidisciplinares.	2	[{"changed": {"fields": ["Pe element"]}}]	31	1
204	2022-04-21 14:22:10.157924+00	3	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__JuPRAjY.xls	1	[{"added": {}}]	34	1
205	2022-04-21 14:30:17.872195+00	3	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__JuPRAjY.xls	3		34	1
206	2022-04-21 14:35:02.700089+00	5	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__Ee8taY3.xls	1	[{"added": {}}]	34	1
207	2022-04-21 14:35:14.745061+00	5	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__Ee8taY3.xls	3		34	1
208	2022-04-21 14:42:58.099578+00	7	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__slN9LVM.xls	1	[{"added": {}}]	34	1
209	2022-04-21 14:43:24.747577+00	7	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__slN9LVM.xls	3		34	1
210	2022-04-21 14:43:57.892842+00	18		3		12	1
211	2022-04-21 14:43:57.91079+00	13		3		12	1
212	2022-04-21 14:43:57.928175+00	8		3		12	1
213	2022-04-21 14:43:57.944689+00	5		3		12	1
214	2022-04-21 14:43:57.962143+00	11	-	3		12	1
215	2022-04-21 14:43:57.9788+00	26	ArcelorMittal Sistemas	3		12	1
216	2022-04-21 14:43:57.995894+00	3	BeeBee	3		12	1
217	2022-04-21 14:43:58.012435+00	25	BITKA	3		12	1
218	2022-04-21 14:43:58.029735+00	4	Boticário	3		12	1
219	2022-04-21 14:43:58.046155+00	6	Coover	3		12	1
220	2022-04-21 14:43:58.063483+00	12	Dataprev	3		12	1
221	2022-04-21 14:43:58.079926+00	19	DTI DIGITAL	3		12	1
222	2022-04-21 14:43:58.097369+00	24	Genesis Tecnologia	3		12	1
226	2022-04-21 14:43:58.164553+00	1	Lead Applied Solutions	3		12	1
227	2022-04-21 14:43:58.181164+00	23	Localiza	3		12	1
228	2022-04-21 14:43:58.198083+00	9	MICAN	3		12	1
229	2022-04-21 14:43:58.214589+00	2	MJV	3		12	1
230	2022-04-21 14:43:58.23173+00	17	Pagar.me	3		12	1
231	2022-04-21 14:43:58.248265+00	14	Sidia	3		12	1
232	2022-04-21 14:43:58.26584+00	16	Stefanini	3		12	1
233	2022-04-21 14:43:58.282079+00	27	UFMA	3		12	1
234	2022-04-21 14:43:58.298877+00	22	Unimed Paraná	3		12	1
235	2022-04-21 14:43:58.315495+00	20	Vale	3		12	1
236	2022-04-21 14:43:58.332815+00	7	W3care	3		12	1
237	2022-04-21 14:55:28.31921+00	9	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__mOXUlpN.xls	1	[{"added": {}}]	34	1
238	2022-04-21 14:55:54.846877+00	9	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__mOXUlpN.xls	3		34	1
239	2022-04-21 14:56:11.161438+00	46		3		12	1
240	2022-04-21 14:56:11.192801+00	41		3		12	1
241	2022-04-21 14:56:11.209345+00	36		3		12	1
242	2022-04-21 14:56:11.226837+00	33		3		12	1
243	2022-04-21 14:56:11.243273+00	39	-	3		12	1
244	2022-04-21 14:56:11.259994+00	54	ArcelorMittal Sistemas	3		12	1
245	2022-04-21 14:56:11.276403+00	31	BeeBee	3		12	1
246	2022-04-21 14:56:11.293576+00	53	BITKA	3		12	1
247	2022-04-21 14:56:11.310003+00	32	Boticário	3		12	1
248	2022-04-21 14:56:11.327272+00	34	Coover	3		12	1
249	2022-04-21 14:56:11.344023+00	40	Dataprev	3		12	1
250	2022-04-21 14:56:11.361184+00	47	DTI DIGITAL	3		12	1
251	2022-04-21 14:56:11.377679+00	52	Genesis Tecnologia	3		12	1
252	2022-04-21 14:56:11.395317+00	49	i4sea	3		12	1
253	2022-04-21 14:56:11.41196+00	43	Ifes	3		12	1
254	2022-04-21 14:56:11.429351+00	38	Kinvo	3		12	1
255	2022-04-21 14:56:11.445585+00	29	Lead Applied Solutions	3		12	1
256	2022-04-21 14:56:11.4627+00	51	Localiza	3		12	1
257	2022-04-21 14:56:11.479158+00	37	MICAN	3		12	1
258	2022-04-21 14:56:11.496671+00	30	MJV	3		12	1
259	2022-04-21 14:56:11.512902+00	45	Pagar.me	3		12	1
260	2022-04-21 14:56:11.530163+00	42	Sidia	3		12	1
261	2022-04-21 14:56:11.546596+00	44	Stefanini	3		12	1
262	2022-04-21 14:56:11.56402+00	55	UFMA	3		12	1
263	2022-04-21 14:56:11.580465+00	50	Unimed Paraná	3		12	1
264	2022-04-21 14:56:11.597529+00	48	Vale	3		12	1
265	2022-04-21 14:56:11.613875+00	35	W3care	3		12	1
266	2022-04-21 15:04:52.585679+00	13	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__ZGX9Qfk.xls	1	[{"added": {}}]	34	1
267	2022-04-21 15:07:34.468378+00	13	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__ZGX9Qfk.xls	3		34	1
268	2022-04-21 15:07:52.008129+00	82		3		12	1
269	2022-04-21 15:07:52.031606+00	77		3		12	1
270	2022-04-21 15:07:52.048087+00	72		3		12	1
271	2022-04-21 15:07:52.065784+00	69		3		12	1
272	2022-04-21 15:07:52.082205+00	75	-	3		12	1
273	2022-04-21 15:07:52.099604+00	90	ArcelorMittal Sistemas	3		12	1
274	2022-04-21 15:07:52.115897+00	67	BeeBee	3		12	1
275	2022-04-21 15:07:52.13288+00	89	BITKA	3		12	1
276	2022-04-21 15:07:52.14931+00	68	Boticário	3		12	1
277	2022-04-21 15:07:52.287859+00	70	Coover	3		12	1
278	2022-04-21 15:07:52.304314+00	76	Dataprev	3		12	1
279	2022-04-21 15:07:52.321495+00	83	DTI DIGITAL	3		12	1
280	2022-04-21 15:07:52.337637+00	88	Genesis Tecnologia	3		12	1
281	2022-04-21 15:07:52.355328+00	85	i4sea	3		12	1
282	2022-04-21 15:07:52.371438+00	79	Ifes	3		12	1
283	2022-04-21 15:07:52.388963+00	74	Kinvo	3		12	1
284	2022-04-21 15:07:52.40543+00	65	Lead Applied Solutions	3		12	1
285	2022-04-21 15:07:52.422514+00	87	Localiza	3		12	1
286	2022-04-21 15:07:52.4391+00	73	MICAN	3		12	1
287	2022-04-21 15:07:52.456217+00	66	MJV	3		12	1
288	2022-04-21 15:07:52.47265+00	81	Pagar.me	3		12	1
289	2022-04-21 15:07:52.489904+00	78	Sidia	3		12	1
290	2022-04-21 15:07:52.506044+00	80	Stefanini	3		12	1
291	2022-04-21 15:07:52.523365+00	91	UFMA	3		12	1
292	2022-04-21 15:07:52.539797+00	86	Unimed Paraná	3		12	1
293	2022-04-21 15:07:52.557242+00	84	Vale	3		12	1
294	2022-04-21 15:07:52.573492+00	71	W3care	3		12	1
295	2022-04-21 15:12:20.274692+00	4	P&D como Sistema de Inovação	2	[{"changed": {"fields": ["Name"]}}]	26	1
296	2022-04-21 15:12:36.884988+00	1	Desenvolvimento Ágil	2	[{"changed": {"fields": ["Name"]}}]	26	1
297	2022-04-21 15:17:12.423807+00	14	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__PYFzQLX.xls	1	[{"added": {}}]	34	1
298	2022-04-21 15:26:31.501805+00	14	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__PYFzQLX.xls	3		34	1
299	2022-04-21 15:26:54.018626+00	109		3		12	1
300	2022-04-21 15:26:54.037323+00	104		3		12	1
301	2022-04-21 15:26:54.05471+00	99		3		12	1
302	2022-04-21 15:26:54.071382+00	96		3		12	1
303	2022-04-21 15:26:54.089091+00	102	-	3		12	1
304	2022-04-21 15:26:54.105442+00	117	ArcelorMittal Sistemas	3		12	1
305	2022-04-21 15:26:54.121741+00	94	BeeBee	3		12	1
306	2022-04-21 15:26:54.139052+00	116	BITKA	3		12	1
307	2022-04-21 15:26:54.155377+00	95	Boticário	3		12	1
308	2022-04-21 15:26:54.172851+00	97	Coover	3		12	1
309	2022-04-21 15:26:54.189406+00	103	Dataprev	3		12	1
310	2022-04-21 15:26:54.206395+00	110	DTI DIGITAL	3		12	1
311	2022-04-21 15:26:54.222718+00	115	Genesis Tecnologia	3		12	1
312	2022-04-21 15:26:54.240437+00	112	i4sea	3		12	1
313	2022-04-21 15:26:54.256611+00	106	Ifes	3		12	1
314	2022-04-21 15:26:54.273735+00	101	Kinvo	3		12	1
315	2022-04-21 15:26:54.290122+00	92	Lead Applied Solutions	3		12	1
316	2022-04-21 15:26:54.307614+00	114	Localiza	3		12	1
317	2022-04-21 15:26:54.323721+00	100	MICAN	3		12	1
318	2022-04-21 15:26:54.341347+00	93	MJV	3		12	1
319	2022-04-21 15:26:54.357362+00	108	Pagar.me	3		12	1
320	2022-04-21 15:26:54.37488+00	105	Sidia	3		12	1
321	2022-04-21 15:26:54.391127+00	107	Stefanini	3		12	1
322	2022-04-21 15:26:54.408637+00	118	UFMA	3		12	1
323	2022-04-21 15:26:54.424842+00	113	Unimed Paraná	3		12	1
324	2022-04-21 15:26:54.442179+00	111	Vale	3		12	1
325	2022-04-21 15:26:54.458485+00	98	W3care	3		12	1
326	2022-04-21 15:29:04.714696+00	1	Nenhuma	2	[{"changed": {"fields": ["Name"]}}]	19	1
327	2022-04-21 15:29:25.284282+00	16	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__2MRsGY3.xls	1	[{"added": {}}]	34	1
412	2022-04-21 16:42:02.69145+00	193	Dataprev	3		12	1
513	2022-04-21 16:49:53.34899+00	265	BeeBee	3		12	1
328	2022-04-21 15:30:44.020806+00	16	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__2MRsGY3.xls	3		32	1
329	2022-04-21 15:31:10.527334+00	137		3		12	1
330	2022-04-21 15:31:10.549781+00	132		3		12	1
331	2022-04-21 15:31:10.56714+00	127		3		12	1
332	2022-04-21 15:31:10.583989+00	124		3		12	1
333	2022-04-21 15:31:10.601166+00	130	-	3		12	1
334	2022-04-21 15:31:10.617648+00	145	ArcelorMittal Sistemas	3		12	1
335	2022-04-21 15:31:10.634964+00	122	BeeBee	3		12	1
336	2022-04-21 15:31:10.651592+00	144	BITKA	3		12	1
337	2022-04-21 15:31:10.668836+00	123	Boticário	3		12	1
338	2022-04-21 15:31:10.685538+00	125	Coover	3		12	1
339	2022-04-21 15:31:10.70238+00	131	Dataprev	3		12	1
340	2022-04-21 15:31:10.718783+00	138	DTI DIGITAL	3		12	1
341	2022-04-21 15:31:10.736241+00	143	Genesis Tecnologia	3		12	1
342	2022-04-21 15:31:10.752032+00	140	i4sea	3		12	1
343	2022-04-21 15:31:10.769515+00	134	Ifes	3		12	1
344	2022-04-21 15:31:10.785996+00	129	Kinvo	3		12	1
345	2022-04-21 15:31:10.803237+00	120	Lead Applied Solutions	3		12	1
346	2022-04-21 15:31:10.819956+00	142	Localiza	3		12	1
347	2022-04-21 15:31:10.837266+00	128	MICAN	3		12	1
348	2022-04-21 15:31:10.853527+00	121	MJV	3		12	1
349	2022-04-21 15:31:10.869826+00	136	Pagar.me	3		12	1
350	2022-04-21 15:31:10.887211+00	133	Sidia	3		12	1
351	2022-04-21 15:31:10.90331+00	135	Stefanini	3		12	1
352	2022-04-21 15:31:10.920828+00	146	UFMA	3		12	1
353	2022-04-21 15:31:10.937152+00	141	Unimed Paraná	3		12	1
354	2022-04-21 15:31:10.954636+00	139	Vale	3		12	1
355	2022-04-21 15:31:10.970831+00	126	W3care	3		12	1
356	2022-04-21 15:43:52.000564+00	18	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__3LbYHWZ.xls	1	[{"added": {}}]	34	1
357	2022-04-21 15:45:24.346791+00	18	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__3LbYHWZ.xls	3		34	1
358	2022-04-21 15:45:44.169669+00	19	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__XVA32bF.xls	1	[{"added": {}}]	34	1
359	2022-04-21 15:47:02.004022+00	19	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__XVA32bF.xls	3		34	1
360	2022-04-21 15:47:08.935106+00	20	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__1U1MzCY.xls	1	[{"added": {}}]	34	1
361	2022-04-21 15:49:09.456632+00	20	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__1U1MzCY.xls	3		34	1
362	2022-04-21 15:49:17.221255+00	21	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__YBvaSGI.xls	1	[{"added": {}}]	34	1
363	2022-04-21 15:52:34.654845+00	21	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__YBvaSGI.xls	3		34	1
364	2022-04-21 15:54:38.380136+00	22	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__6xLTV40.xls	1	[{"added": {}}]	34	1
365	2022-04-21 15:55:35.55377+00	22	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__6xLTV40.xls	3		34	1
366	2022-04-21 15:55:42.392121+00	23	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__AqsDB62.xls	1	[{"added": {}}]	34	1
367	2022-04-21 15:57:12.355925+00	23	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__AqsDB62.xls	3		34	1
368	2022-04-21 15:57:20.910031+00	24	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__PhQpnpa.xls	1	[{"added": {}}]	34	1
369	2022-04-21 15:57:40.856346+00	24	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__PhQpnpa.xls	3		34	1
370	2022-04-21 16:12:03.96771+00	4	AO.04-Com o intuito de entregar valor para o cliente, os requisitos são definidos e priorizados de acordo com as necessidades do cliente, são periodicamente revisados e mudanças são absorvidas em iter	2	[]	31	1
371	2022-04-21 16:29:41.732451+00	33	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__yYkYpBi.xls	1	[{"added": {}}]	34	1
372	2022-04-21 16:30:52.126504+00	33	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__yYkYpBi.xls	3		34	1
373	2022-04-21 16:31:12.396679+00	169		3		12	1
374	2022-04-21 16:31:12.41329+00	164		3		12	1
375	2022-04-21 16:31:12.430465+00	159		3		12	1
376	2022-04-21 16:31:12.465276+00	156		3		12	1
377	2022-04-21 16:31:12.497792+00	162	-	3		12	1
378	2022-04-21 16:31:12.532765+00	177	ArcelorMittal Sistemas	3		12	1
379	2022-04-21 16:31:12.548209+00	154	BeeBee	3		12	1
380	2022-04-21 16:31:12.565278+00	176	BITKA	3		12	1
381	2022-04-21 16:31:12.581542+00	155	Boticário	3		12	1
382	2022-04-21 16:31:12.598949+00	157	Coover	3		12	1
383	2022-04-21 16:31:12.61561+00	163	Dataprev	3		12	1
384	2022-04-21 16:31:12.632689+00	170	DTI DIGITAL	3		12	1
385	2022-04-21 16:31:12.649124+00	175	Genesis Tecnologia	3		12	1
386	2022-04-21 16:31:12.666334+00	172	i4sea	3		12	1
387	2022-04-21 16:31:12.682886+00	166	Ifes	3		12	1
388	2022-04-21 16:31:12.700371+00	161	Kinvo	3		12	1
389	2022-04-21 16:31:12.716706+00	152	Lead Applied Solutions	3		12	1
390	2022-04-21 16:31:12.733731+00	174	Localiza	3		12	1
391	2022-04-21 16:31:12.750217+00	160	MICAN	3		12	1
392	2022-04-21 16:31:12.76762+00	153	MJV	3		12	1
393	2022-04-21 16:31:12.783894+00	168	Pagar.me	3		12	1
394	2022-04-21 16:31:12.801284+00	165	Sidia	3		12	1
395	2022-04-21 16:31:12.817382+00	167	Stefanini	3		12	1
396	2022-04-21 16:31:12.834262+00	178	UFMA	3		12	1
397	2022-04-21 16:31:12.850655+00	173	Unimed Paraná	3		12	1
398	2022-04-21 16:31:12.868017+00	171	Vale	3		12	1
399	2022-04-21 16:31:12.884501+00	158	W3care	3		12	1
400	2022-04-21 16:40:55.621427+00	37	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__WT8xzpg.xls	1	[{"added": {}}]	34	1
401	2022-04-21 16:41:42.971478+00	37	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__WT8xzpg.xls	3		34	1
402	2022-04-21 16:42:02.523827+00	199		3		12	1
403	2022-04-21 16:42:02.539757+00	194		3		12	1
404	2022-04-21 16:42:02.556247+00	189		3		12	1
405	2022-04-21 16:42:02.572631+00	186		3		12	1
406	2022-04-21 16:42:02.590248+00	192	-	3		12	1
407	2022-04-21 16:42:02.606666+00	207	ArcelorMittal Sistemas	3		12	1
408	2022-04-21 16:42:02.624059+00	184	BeeBee	3		12	1
409	2022-04-21 16:42:02.640539+00	206	BITKA	3		12	1
410	2022-04-21 16:42:02.65727+00	185	Boticário	3		12	1
411	2022-04-21 16:42:02.674172+00	187	Coover	3		12	1
413	2022-04-21 16:42:02.70786+00	200	DTI DIGITAL	3		12	1
414	2022-04-21 16:42:02.725104+00	205	Genesis Tecnologia	3		12	1
415	2022-04-21 16:42:02.741615+00	202	i4sea	3		12	1
416	2022-04-21 16:42:02.758852+00	196	Ifes	3		12	1
417	2022-04-21 16:42:02.775168+00	191	Kinvo	3		12	1
418	2022-04-21 16:42:02.792755+00	182	Lead Applied Solutions	3		12	1
419	2022-04-21 16:42:02.809185+00	204	Localiza	3		12	1
420	2022-04-21 16:42:02.826201+00	190	MICAN	3		12	1
421	2022-04-21 16:42:02.842692+00	183	MJV	3		12	1
422	2022-04-21 16:42:02.859976+00	198	Pagar.me	3		12	1
423	2022-04-21 16:42:02.876627+00	195	Sidia	3		12	1
424	2022-04-21 16:42:02.893773+00	197	Stefanini	3		12	1
425	2022-04-21 16:42:02.909899+00	208	UFMA	3		12	1
426	2022-04-21 16:42:02.927724+00	203	Unimed Paraná	3		12	1
427	2022-04-21 16:42:02.943535+00	201	Vale	3		12	1
428	2022-04-21 16:42:02.960334+00	188	W3care	3		12	1
429	2022-04-21 16:42:16.71609+00	38	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__ViUVSRj.xls	1	[{"added": {}}]	34	1
430	2022-04-21 16:42:56.28132+00	38	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__ViUVSRj.xls	3		34	1
431	2022-04-21 16:43:13.93052+00	226		3		12	1
432	2022-04-21 16:43:13.94567+00	221		3		12	1
433	2022-04-21 16:43:13.963+00	216		3		12	1
434	2022-04-21 16:43:13.979464+00	213		3		12	1
435	2022-04-21 16:43:13.996808+00	219	-	3		12	1
436	2022-04-21 16:43:14.01309+00	234	ArcelorMittal Sistemas	3		12	1
437	2022-04-21 16:43:14.030399+00	211	BeeBee	3		12	1
438	2022-04-21 16:43:14.046824+00	233	BITKA	3		12	1
439	2022-04-21 16:43:14.064612+00	212	Boticário	3		12	1
440	2022-04-21 16:43:14.080986+00	214	Coover	3		12	1
441	2022-04-21 16:43:14.097291+00	220	Dataprev	3		12	1
442	2022-04-21 16:43:14.114516+00	227	DTI DIGITAL	3		12	1
443	2022-04-21 16:43:14.1309+00	232	Genesis Tecnologia	3		12	1
444	2022-04-21 16:43:14.148636+00	229	i4sea	3		12	1
445	2022-04-21 16:43:14.164626+00	223	Ifes	3		12	1
446	2022-04-21 16:43:14.181761+00	218	Kinvo	3		12	1
447	2022-04-21 16:43:14.198079+00	209	Lead Applied Solutions	3		12	1
448	2022-04-21 16:43:14.215227+00	231	Localiza	3		12	1
449	2022-04-21 16:43:14.231994+00	217	MICAN	3		12	1
450	2022-04-21 16:43:14.249367+00	210	MJV	3		12	1
451	2022-04-21 16:43:14.265418+00	225	Pagar.me	3		12	1
452	2022-04-21 16:43:14.282971+00	222	Sidia	3		12	1
453	2022-04-21 16:43:14.299581+00	224	Stefanini	3		12	1
454	2022-04-21 16:43:14.316924+00	235	UFMA	3		12	1
455	2022-04-21 16:43:14.333326+00	230	Unimed Paraná	3		12	1
456	2022-04-21 16:43:14.352944+00	228	Vale	3		12	1
457	2022-04-21 16:43:14.369068+00	215	W3care	3		12	1
458	2022-04-21 16:43:28.82054+00	39	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__nipKj57.xls	1	[{"added": {}}]	34	1
459	2022-04-21 16:44:56.498263+00	39	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__nipKj57.xls	3		34	1
460	2022-04-21 16:45:13.538707+00	253		3		12	1
461	2022-04-21 16:45:13.568454+00	248		3		12	1
462	2022-04-21 16:45:13.584788+00	243		3		12	1
463	2022-04-21 16:45:13.60218+00	240		3		12	1
464	2022-04-21 16:45:13.618827+00	246	-	3		12	1
465	2022-04-21 16:45:13.635446+00	261	ArcelorMittal Sistemas	3		12	1
466	2022-04-21 16:45:13.652778+00	238	BeeBee	3		12	1
467	2022-04-21 16:45:13.669545+00	260	BITKA	3		12	1
468	2022-04-21 16:45:13.686128+00	239	Boticário	3		12	1
469	2022-04-21 16:45:13.703172+00	241	Coover	3		12	1
470	2022-04-21 16:45:13.719908+00	247	Dataprev	3		12	1
471	2022-04-21 16:45:13.737035+00	254	DTI DIGITAL	3		12	1
472	2022-04-21 16:45:13.75337+00	259	Genesis Tecnologia	3		12	1
473	2022-04-21 16:45:13.770749+00	256	i4sea	3		12	1
474	2022-04-21 16:45:13.787339+00	250	Ifes	3		12	1
475	2022-04-21 16:45:13.804639+00	245	Kinvo	3		12	1
476	2022-04-21 16:45:13.820866+00	236	Lead Applied Solutions	3		12	1
477	2022-04-21 16:45:13.838403+00	258	Localiza	3		12	1
478	2022-04-21 16:45:13.854512+00	244	MICAN	3		12	1
479	2022-04-21 16:45:13.872308+00	237	MJV	3		12	1
480	2022-04-21 16:45:13.888672+00	252	Pagar.me	3		12	1
481	2022-04-21 16:45:13.905598+00	249	Sidia	3		12	1
482	2022-04-21 16:45:13.92176+00	251	Stefanini	3		12	1
483	2022-04-21 16:45:13.93909+00	262	UFMA	3		12	1
484	2022-04-21 16:45:13.955199+00	257	Unimed Paraná	3		12	1
485	2022-04-21 16:45:13.972744+00	255	Vale	3		12	1
486	2022-04-21 16:45:13.98912+00	242	W3care	3		12	1
487	2022-04-21 16:45:46.863707+00	40	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__D9A4sd7.xls	1	[{"added": {}}]	34	1
488	2022-04-21 16:47:15.542212+00	41	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__05m4UOr.xls	1	[{"added": {}}]	34	1
489	2022-04-21 16:48:17.525219+00	40	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__D9A4sd7.xls	3		34	1
490	2022-04-21 16:48:17.557289+00	41	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__05m4UOr.xls	3		34	1
491	2022-04-21 16:48:25.208893+00	42	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__XyS0biC.xls	1	[{"added": {}}]	34	1
492	2022-04-21 16:49:30.847978+00	42	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__XyS0biC.xls	3		34	1
493	2022-04-21 16:49:52.996447+00	334		3		12	1
494	2022-04-21 16:49:53.017837+00	329		3		12	1
495	2022-04-21 16:49:53.03538+00	324		3		12	1
496	2022-04-21 16:49:53.051964+00	321		3		12	1
497	2022-04-21 16:49:53.069405+00	307		3		12	1
498	2022-04-21 16:49:53.0857+00	302		3		12	1
499	2022-04-21 16:49:53.103203+00	297		3		12	1
500	2022-04-21 16:49:53.119379+00	294		3		12	1
501	2022-04-21 16:49:53.13695+00	280		3		12	1
502	2022-04-21 16:49:53.153491+00	275		3		12	1
503	2022-04-21 16:49:53.169545+00	270		3		12	1
504	2022-04-21 16:49:53.186761+00	267		3		12	1
505	2022-04-21 16:49:53.203074+00	327	-	3		12	1
506	2022-04-21 16:49:53.220554+00	300	-	3		12	1
507	2022-04-21 16:49:53.247871+00	273	-	3		12	1
508	2022-04-21 16:49:53.265158+00	342	ArcelorMittal Sistemas	3		12	1
509	2022-04-21 16:49:53.281607+00	315	ArcelorMittal Sistemas	3		12	1
510	2022-04-21 16:49:53.298569+00	288	ArcelorMittal Sistemas	3		12	1
511	2022-04-21 16:49:53.31501+00	319	BeeBee	3		12	1
512	2022-04-21 16:49:53.332738+00	292	BeeBee	3		12	1
514	2022-04-21 16:49:53.366289+00	341	BITKA	3		12	1
515	2022-04-21 16:49:53.382885+00	314	BITKA	3		12	1
516	2022-04-21 16:49:53.400086+00	287	BITKA	3		12	1
517	2022-04-21 16:49:53.416678+00	320	Boticário	3		12	1
518	2022-04-21 16:49:53.433703+00	293	Boticário	3		12	1
519	2022-04-21 16:49:53.450144+00	266	Boticário	3		12	1
520	2022-04-21 16:49:53.467406+00	322	Coover	3		12	1
521	2022-04-21 16:49:53.483902+00	295	Coover	3		12	1
522	2022-04-21 16:49:53.501095+00	268	Coover	3		12	1
523	2022-04-21 16:49:53.517408+00	328	Dataprev	3		12	1
524	2022-04-21 16:49:53.53487+00	301	Dataprev	3		12	1
525	2022-04-21 16:49:53.551082+00	274	Dataprev	3		12	1
526	2022-04-21 16:49:53.56859+00	335	DTI DIGITAL	3		12	1
527	2022-04-21 16:49:53.584854+00	308	DTI DIGITAL	3		12	1
528	2022-04-21 16:49:53.602058+00	281	DTI DIGITAL	3		12	1
529	2022-04-21 16:49:53.618451+00	340	Genesis Tecnologia	3		12	1
530	2022-04-21 16:49:53.635888+00	313	Genesis Tecnologia	3		12	1
531	2022-04-21 16:49:53.652241+00	286	Genesis Tecnologia	3		12	1
532	2022-04-21 16:49:53.669844+00	337	i4sea	3		12	1
533	2022-04-21 16:49:53.685965+00	310	i4sea	3		12	1
534	2022-04-21 16:49:53.703429+00	283	i4sea	3		12	1
535	2022-04-21 16:49:53.719622+00	331	Ifes	3		12	1
536	2022-04-21 16:49:53.73704+00	304	Ifes	3		12	1
537	2022-04-21 16:49:53.753192+00	277	Ifes	3		12	1
538	2022-04-21 16:49:53.770468+00	326	Kinvo	3		12	1
539	2022-04-21 16:49:53.786762+00	299	Kinvo	3		12	1
540	2022-04-21 16:49:53.804227+00	272	Kinvo	3		12	1
541	2022-04-21 16:49:53.82046+00	317	Lead Applied Solutions	3		12	1
542	2022-04-21 16:49:54.170871+00	290	Lead Applied Solutions	3		12	1
543	2022-04-21 16:49:54.20631+00	263	Lead Applied Solutions	3		12	1
544	2022-04-21 16:49:54.223642+00	339	Localiza	3		12	1
545	2022-04-21 16:49:54.240057+00	312	Localiza	3		12	1
546	2022-04-21 16:49:54.257294+00	285	Localiza	3		12	1
547	2022-04-21 16:49:54.273668+00	325	MICAN	3		12	1
548	2022-04-21 16:49:54.290777+00	298	MICAN	3		12	1
549	2022-04-21 16:49:54.307359+00	271	MICAN	3		12	1
550	2022-04-21 16:49:54.32482+00	318	MJV	3		12	1
551	2022-04-21 16:49:54.340525+00	291	MJV	3		12	1
552	2022-04-21 16:49:54.357564+00	264	MJV	3		12	1
553	2022-04-21 16:49:54.373993+00	333	Pagar.me	3		12	1
554	2022-04-21 16:49:54.391366+00	306	Pagar.me	3		12	1
555	2022-04-21 16:49:54.408242+00	279	Pagar.me	3		12	1
556	2022-04-21 16:49:54.42546+00	330	Sidia	3		12	1
557	2022-04-21 16:49:54.441788+00	303	Sidia	3		12	1
558	2022-04-21 16:49:54.459171+00	276	Sidia	3		12	1
559	2022-04-21 16:49:54.475652+00	332	Stefanini	3		12	1
560	2022-04-21 16:49:54.492946+00	305	Stefanini	3		12	1
561	2022-04-21 16:49:54.509144+00	278	Stefanini	3		12	1
562	2022-04-21 16:49:54.526493+00	343	UFMA	3		12	1
563	2022-04-21 16:49:54.542953+00	316	UFMA	3		12	1
564	2022-04-21 16:49:54.560529+00	289	UFMA	3		12	1
565	2022-04-21 16:49:54.576838+00	338	Unimed Paraná	3		12	1
566	2022-04-21 16:49:54.593302+00	311	Unimed Paraná	3		12	1
567	2022-04-21 16:49:54.610435+00	284	Unimed Paraná	3		12	1
568	2022-04-21 16:49:54.626675+00	336	Vale	3		12	1
569	2022-04-21 16:49:54.643931+00	309	Vale	3		12	1
570	2022-04-21 16:49:54.660489+00	282	Vale	3		12	1
571	2022-04-21 16:49:54.677627+00	323	W3care	3		12	1
572	2022-04-21 16:49:54.694196+00	296	W3care	3		12	1
573	2022-04-21 16:49:54.711207+00	269	W3care	3		12	1
574	2022-04-21 16:53:28.746201+00	2	AO.02-As equipes dos projetos incluem um papel (p.ex., product owner) que é responsável por representar o cliente e participa ativamente.	2	[{"changed": {"fields": ["Statement"]}}]	31	1
575	2022-04-21 17:00:17.710942+00	2	AO.02-As equipes dos projetos incluem um papel (p.ex., product owner) que é responsável por representar o cliente e participa ativamente nos projetos.	2	[{"changed": {"fields": ["Statement"]}}]	31	1
576	2022-04-21 17:00:46.829107+00	51	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__CKNlgQA.xls	1	[{"added": {}}]	34	1
577	2022-04-21 17:01:39.472781+00	51	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__CKNlgQA.xls	3		34	1
578	2022-04-21 17:01:57.489336+00	369		3		12	1
579	2022-04-21 17:01:57.559876+00	364		3		12	1
580	2022-04-21 17:01:57.630851+00	359		3		12	1
581	2022-04-21 17:01:57.714524+00	356		3		12	1
582	2022-04-21 17:01:57.741821+00	362	-	3		12	1
583	2022-04-21 17:01:57.836348+00	377	ArcelorMittal Sistemas	3		12	1
584	2022-04-21 17:01:57.852785+00	354	BeeBee	3		12	1
585	2022-04-21 17:01:57.881136+00	376	BITKA	3		12	1
586	2022-04-21 17:01:57.919156+00	355	Boticário	3		12	1
587	2022-04-21 17:01:57.958538+00	357	Coover	3		12	1
588	2022-04-21 17:01:58.058126+00	363	Dataprev	3		12	1
589	2022-04-21 17:01:58.08062+00	370	DTI DIGITAL	3		12	1
590	2022-04-21 17:01:58.097003+00	375	Genesis Tecnologia	3		12	1
591	2022-04-21 17:01:58.113004+00	372	i4sea	3		12	1
592	2022-04-21 17:01:58.163677+00	366	Ifes	3		12	1
593	2022-04-21 17:01:58.201811+00	361	Kinvo	3		12	1
594	2022-04-21 17:01:58.219316+00	352	Lead Applied Solutions	3		12	1
595	2022-04-21 17:01:58.246219+00	374	Localiza	3		12	1
596	2022-04-21 17:01:58.263587+00	360	MICAN	3		12	1
597	2022-04-21 17:01:58.313309+00	353	MJV	3		12	1
598	2022-04-21 17:01:58.341474+00	368	Pagar.me	3		12	1
599	2022-04-21 17:01:58.36871+00	365	Sidia	3		12	1
600	2022-04-21 17:01:58.385739+00	367	Stefanini	3		12	1
601	2022-04-21 17:01:58.40191+00	378	UFMA	3		12	1
602	2022-04-21 17:01:58.452665+00	373	Unimed Paraná	3		12	1
603	2022-04-21 17:01:58.50135+00	371	Vale	3		12	1
604	2022-04-21 17:01:58.541287+00	358	W3care	3		12	1
605	2022-04-21 17:04:15.987043+00	52	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__inh2qqv.xls	1	[{"added": {}}]	34	1
606	2022-04-21 17:25:02.893164+00	1	ContinuousPhase object (1)	1	[{"added": {}}]	38	1
607	2022-04-21 17:25:19.907412+00	2	ContinuousPhase object (2)	1	[{"added": {}}]	38	1
608	2022-04-21 17:25:35.483296+00	3	ContinuousPhase object (3)	1	[{"added": {}}]	38	1
609	2022-04-21 17:27:42.312443+00	1	Continuous Planning	1	[{"added": {}}]	37	1
610	2022-04-21 17:28:12.246923+00	2	Continuous Budgeting	1	[{"added": {}}]	37	1
611	2022-04-21 17:28:32.772606+00	3	Continuous Integration	1	[{"added": {}}]	37	1
612	2022-04-21 17:28:46.940663+00	4	Continuous Deployment	1	[{"added": {}}]	37	1
613	2022-04-21 17:29:02.017933+00	5	Continuous Delivery	1	[{"added": {}}]	37	1
749	2022-04-21 22:09:46.797051+00	425	Vale	3		12	1
614	2022-04-21 17:29:23.421138+00	6	Continuous Verification/Testing	1	[{"added": {}}]	37	1
615	2022-04-21 17:29:44.036841+00	7	Continuous Security	1	[{"added": {}}]	37	1
616	2022-04-21 17:30:25.268811+00	8	Continuous Compliance	1	[{"added": {}}]	37	1
617	2022-04-21 17:30:50.752709+00	9	Continuous Evolution	1	[{"added": {}}]	37	1
618	2022-04-21 17:31:25.750676+00	10	Continuous Use	1	[{"added": {}}]	37	1
619	2022-04-21 17:31:43.780052+00	11	Continuous Trust	1	[{"added": {}}]	37	1
620	2022-04-21 17:32:11.85116+00	12	Continuous Run-Time Monitoring	1	[{"added": {}}]	37	1
621	2022-04-21 17:33:36.137922+00	4	Improvement and Innovation	1	[{"added": {}}]	38	1
622	2022-04-21 17:34:05.350177+00	13	Continuous improvement	1	[{"added": {}}]	37	1
623	2022-04-21 17:34:36.294041+00	14	Continuous Innovation	1	[{"added": {}}]	37	1
624	2022-04-21 17:34:52.936803+00	15	Continuous Experimentation	1	[{"added": {}}]	37	1
625	2022-04-21 17:38:48.37008+00	2	AO.02-As equipes dos projetos incluem um papel (p.ex., product owner) que é responsável por representar o cliente e participa ativamente nos projetos.	2	[]	31	1
626	2022-04-21 19:57:33.2566+00	4	AO.04-Com o intuito de entregar valor para o cliente, os requisitos são definidos e priorizados de acordo com as necessidades do cliente, são periodicamente revisados e mudanças são absorvidas em iter	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
627	2022-04-21 19:59:22.926808+00	5	AO.05-O escopo do projeto é definido gradativamente, utilizando-se um Product Backlog (ou artefato equivalente).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
628	2022-04-21 20:00:10.443558+00	6	AO.06-Estimativas de esforço são realizadas pela equipe de desenvolvimento (ou em conjunto com ela) considerando-se tarefas curtas para implementar um conjunto de requisitos selecionados (e não o proj	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
629	2022-04-21 20:00:45.924162+00	7	AO.07-Estimativas de custos são estabelecidas com base nas estimativas de esforço, considerando-se o esforço necessário para implementar um conjunto de requisitos selecionados (e não o projeto como um	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
630	2022-04-21 20:01:45.838017+00	8	AO.08-O processo de desenvolvimento é ágil, sendo realizado de forma iterativa, em ciclos curtos (p.ex., duas semanas), nos quais requisitos do produto definidos em um Product Backlog (ou artefato equ	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
631	2022-04-21 20:03:23.742127+00	10	Continuous Software Measurement	1	[{"added": {}}]	25	1
632	2022-04-21 20:04:02.539562+00	9	AO.09-Há critérios de aceitação claros para os requisitos do software e eles são usados para avaliar os artefatos produzidos (p.ex., funcionalidades) e definir se estão "prontos".	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
633	2022-04-21 20:05:15.662985+00	10	AO.10-O cliente recebe novas versões do produto com frequência (após um ou mais ciclos curtos de desenvolvimento), incluindo novas funcionalidades definidas de acordo com as necessidades do cliente.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
634	2022-04-21 20:06:33.947198+00	11	AO.11-O processo de desenvolvimento (ágil) está alinhado ao negócio da organização e isso é percebido pela entrega de valor ao cliente e pela sua satisfação com o produto entregue.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
635	2022-04-21 20:07:25.041625+00	12	AO.12-Há pelo menos um papel (p.ex., tech lead, analista de qualidade) responsável pela qualidade dos artefatos produzidos e do produto final.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
636	2022-04-21 20:08:25.794819+00	13	AO.13-Os stakeholders do projeto (incluindo o cliente) são estimulados a refletir sobre seu sobre seu papel e suas responsabilidades no projeto.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
637	2022-04-21 20:09:56.185488+00	14	AO.14-A equipe do projeto possui autonomia para tomar decisões técnicas no projeto.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
638	2022-04-21 20:14:43.531127+00	15	AO.15-Frequentemente (p.ex.., diariamente, a cada dois ou três dias) a equipe se reúne e reflete sobre o progresso do desenvolvimento no âmbito do que foi definido para o time-box corrente e ajusta as	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
639	2022-04-21 20:15:53.642888+00	16	AO.16-A equipe se reúne com frequência ao longo do projeto para discutir sobre melhorias no produto, no processo ou nas ferramentas usadas (p.ex., em reunião de retrospectiva).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
640	2022-04-21 20:16:35.386123+00	17	AO.17-A equipe se reúne com frequência ao longo do projeto para discutir sobre melhorias nas competências dos membros da equipe (p.ex., em reunião de retrospectiva)	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
641	2022-04-21 20:19:01.780839+00	18	AO.18-O processo de desenvolvimento (ágil) é avaliado e melhorado continuamente.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
642	2022-04-21 20:20:09.689395+00	19	AO.19-Boas práticas de programação são adotadas (p.ex., código coletivo, codificação padronizada, programação em pares, revisão de código)	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
643	2022-04-21 20:20:59.254414+00	20	AO.20-Boas práticas de testes (p.ex., teste automatizado, desenvolvimento orientado a testes) são adotadas.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
644	2022-04-21 20:22:19.695719+00	21	AO.21-Dados são coletados para métricas que permitem avaliar aspectos da qualidade dos artefatos produzidos e do produto (p.ex., complexidade ciclomática, quantidade de code smells).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
645	2022-04-21 20:23:43.716561+00	22	AO.22-Dados são coletados para métricas que permitem avaliar aspectos de desempenho do processo de desenvolvimento ágil (p.ex., work in progress, velocidade).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
646	2022-04-21 20:25:33.696517+00	23	AO.23-Dados produzidos ao longo do processo de desenvolvimento (p.ex., data de início das tarefas, data de conclusão das tarefas, pontos de história das tarefas) são armazenados em um (ou mais) reposi	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
647	2022-04-21 20:26:43.477488+00	24	AO.24-Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de desenvolvimento ágil.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
648	2022-04-21 20:27:55.821165+00	25	AO.25-Decisões nos projetos são tomadas com base em dados presentes no(s) repositório(s) de dados.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
649	2022-04-21 20:28:50.903138+00	26	AO.26-São realizadas ações para compartilhar conhecimento relevante ao desenvolvimento ágil (p.ex., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
750	2022-04-21 22:09:46.814451+00	412	W3care	3		12	1
862	2022-04-21 22:31:55.759021+00	477		3		12	1
650	2022-04-21 20:31:00.001067+00	42	CD.01-Os principais clientes/consumidores são identificados e participam do processo de desenvolvimento, influenciando nas funcionalidades que serão produzidas e entregues.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
651	2022-04-21 20:32:29.711614+00	43	CD.02-Há um fluxo de informação claro entre Desenvolvimento e Operação, permitindo que novas funcionalidades desenvolvidas entrem em operação automaticamente.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
652	2022-04-21 20:34:59.93032+00	44	CD.03-A entrega de novas funcionalidades é realizada automaticamente e por releases.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
653	2022-04-21 20:36:20.768746+00	45	CD.04-Há um fluxo de informação claro entre Operação e Negócio, permitindo que novas necessidades dos clientes/consumidores e oportunidades de negócio sejam identificadas a partir da entrega de novas 	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
654	2022-04-21 20:38:00.706349+00	46	CD.05-A arquitetura do software permite realizar entrega (deploy) de funcionalidades de forma independente.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
655	2022-04-21 20:39:13.103524+00	47	CD.06-Clientes/consumidores recebem novas funcionalidades com frequência, inclusive, em ciclos mais curtos do que o time-box que costuma ser estabelecido no processo de desenvolvimento.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
656	2022-04-21 20:40:51.558083+00	48	CD.07-Os clientes podem realizar testes no produto assim que é feita a entrega (deploy) de novas funcionalidades.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
657	2022-04-21 20:41:36.401675+00	49	CD.08-O modelo de negócio da organização é constantemente avaliado e revisto (quando necessário) com base em informações dos clientes/consumidores.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
658	2022-04-21 20:42:15.686183+00	50	CD.09-Estratégias de marketing são constantemente avaliadas e revistas (quando necessário) com base em informações dos lead customers (clientes/consumidores mais relevantes para a organização).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
659	2022-04-21 20:42:55.862584+00	51	CD.10-Estratégias de venda são constantemente avaliadas e revistas (quando necessário) com base em informações dos lead customers (clientes/consumidores mais relevantes para a organização).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
660	2022-04-21 20:44:27.734281+00	52	CD.11-Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
661	2022-04-21 20:46:48.208588+00	53	CD.12-Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos e baseando-se em dados.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
662	2022-04-21 20:49:43.412765+00	54	CD.13-Dados são coletados para métricas que permitem avaliar o processo de entrega contínua  (p.ex., quantidade de releases, densidade de defeitos nas releases).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
663	2022-04-21 20:51:27.740115+00	55	CD.14-Dados produzidos nos ambientes de entrega contínua (p.ex., data das releases e versão do software entregue)  são armazenados em um (ou mais) repositório de dados.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
664	2022-04-21 20:52:37.826886+00	56	CD.15-O  processo de entrega contínua é avaliado e melhorado continuamente.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
665	2022-04-21 20:54:12.730568+00	57	CD.16-Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de entrega contínua.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
666	2022-04-21 20:54:53.984449+00	58	CD.17-São realizadas ações para compartilhar conhecimento relacionado a entrega contínua (e.g., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
667	2022-04-21 20:56:06.962887+00	27	CI.01-A arquitetura do software é modular de forma a permitir a realização de testes automatizados.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
668	2022-04-21 20:56:46.074784+00	28	CI.02-A arquitetura do software é modular de forma a permitir a realização de builds automatizados.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
669	2022-04-21 20:57:43.221692+00	29	CI.03-O código é integrado constantemente e automaticamente.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
670	2022-04-21 20:58:48.632723+00	30	CI.04-Testes são executados automaticamente, periodicamente (p.ex., sempre que código novo é integrado), em um ambiente de teste, para verificar a qualidade do código (p.ex., cobertura, corretude).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
671	2022-04-21 21:00:36.623885+00	31	CI.05-Testes automatizados são utilizados para avaliar se o software implementado atende os requisitos estabelecidos.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
672	2022-04-21 21:01:23.610357+00	32	CI.06-Builds ocorrem frequentemente e automaticamente.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
673	2022-04-21 21:02:10.635832+00	33	CI.07-Builds são cancelados caso um ou mais testes falhem.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
674	2022-04-21 21:03:13.49589+00	34	CI.08-Há controle de versões dos artefatos de software (p.ex., código, teste, scripts etc.) em um repositório	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
675	2022-04-21 21:03:51.971401+00	35	CI.09-Boas práticas de check in são aplicadas no trunk de desenvolvimento (p.ex., uso de ferramentas como GitFlow e Toogle Feature).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
676	2022-04-21 21:04:40.716536+00	36	CI.10-Há práticas que permitem que organizações ou pessoas externas ao projeto atuem na implementação do produto (i.e., produzam e integrem código ao produto sendo desenvolvido)	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
677	2022-04-21 21:06:50.856236+00	37	CI.11-Dados são coletados para métricas que permitem avaliar o processo de integração contínua (p.ex., quantidade de builds cancelados, quantidade de integrações de código realizadas)	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
678	2022-04-21 21:07:50.70813+00	38	CI.12-Dados produzidos nos ambientes de integração contínua (p.ex., data das builds, quantidade de testes executados e percentual de cobertura)  são armazenados em um (ou mais) repositório de dados	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
679	2022-04-21 21:09:08.655254+00	39	CI.13-O processo de integração contínua (incluindo a realização de testes automatizados) é avaliado e melhorado continuamente	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
860	2022-04-21 22:31:23.41924+00	479	Vale	3		12	1
861	2022-04-21 22:31:23.435625+00	466	W3care	3		12	1
680	2022-04-21 21:10:33.063205+00	40	CI.14-Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de integração contínua.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
681	2022-04-21 21:11:35.165283+00	41	CI.15-São realizadas ações para compartilhar conhecimento relacionado a integração contínua (p.ex., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
682	2022-04-21 21:12:42.684926+00	59	IS.01-Feedbacks (dados e opiniões) dos clientes/consumidores são capturados contínua e automaticamente e armazenados em um (ou mais) repositório de dados de clientes/consumidores,	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
683	2022-04-21 21:13:46.838553+00	60	IS.02-Feedbacks (dados e opiniões) dos clientes/consumidores (capturados contínua e automaticamente) são utilizados para melhorar os produtos (melhorar funcionalidades existentes e identificar novas).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
684	2022-04-21 21:14:17.321591+00	61	IS.03-A organização identifica novas oportunidades de negócio com base nos feedbacks capturados automaticamente dos clientes/consumidores	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
685	2022-04-21 21:15:40.755015+00	62	IS.04-Feedbacks (dados e opiniões) dos clientes/consumidores (capturados contínua e automaticamente) são usados para experimentação e inovação	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
686	2022-04-21 21:17:37.3053+00	63	IS.05-Experimentos (p.ex., testes A/B) são realizados com os clientes/consumidores para melhorar os produtos	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
687	2022-04-21 21:18:25.248855+00	64	IS.06-São adotadas tecnologias (p.ex.., tecnologias de nuvem) que permitem potencializar a experimentação.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
688	2022-04-21 21:19:28.931174+00	65	IS.07-A organização continuamente experimenta novas tecnologias e metodologias,	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
689	2022-04-21 21:20:52.149582+00	66	IS.08-Há um fluxo de informação claro entre o nível estratégico e a área de desenvolvimento da organização, permitindo que dados dos clientes/consumidores (capturados contínua e automaticamente) sejam	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
690	2022-04-21 21:21:59.61669+00	67	IS.09-Dados do repositório de dados dos clientes/consumidores são usados na tomada de decisão pela área de desenvolvimento de software.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
691	2022-04-21 21:22:46.325082+00	69	IS.11-Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos e baseando-se em dados do(s) repositório(a) de dados dos	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
692	2022-04-21 21:24:58.308423+00	70	IS.12-O processo de experimentação contínua é avaliado e melhorado continuamente.	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
693	2022-04-21 21:25:55.393169+00	71	IS.13-São realizadas ações para compartilhar conhecimento relacionado a experimentação  contínua (e.g., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	2	[{"changed": {"fields": ["Pe element", "Fcse processes"]}}]	31	1
694	2022-04-21 22:07:18.543899+00	52	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__inh2qqv.xls	3		34	1
695	2022-04-21 22:07:44.131992+00	396		3		12	1
696	2022-04-21 22:07:44.1648+00	391		3		12	1
697	2022-04-21 22:07:44.181244+00	386		3		12	1
698	2022-04-21 22:07:44.198456+00	383		3		12	1
699	2022-04-21 22:07:44.2149+00	389	-	3		12	1
700	2022-04-21 22:07:44.232693+00	404	ArcelorMittal Sistemas	3		12	1
701	2022-04-21 22:07:44.248407+00	381	BeeBee	3		12	1
702	2022-04-21 22:07:44.265485+00	403	BITKA	3		12	1
703	2022-04-21 22:07:44.281656+00	382	Boticário	3		12	1
704	2022-04-21 22:07:44.298994+00	384	Coover	3		12	1
705	2022-04-21 22:07:44.315543+00	390	Dataprev	3		12	1
706	2022-04-21 22:07:44.333339+00	397	DTI DIGITAL	3		12	1
707	2022-04-21 22:07:44.36686+00	402	Genesis Tecnologia	3		12	1
708	2022-04-21 22:07:44.383651+00	399	i4sea	3		12	1
709	2022-04-21 22:07:44.399914+00	393	Ifes	3		12	1
710	2022-04-21 22:07:44.417179+00	388	Kinvo	3		12	1
711	2022-04-21 22:07:44.433722+00	379	Lead Applied Solutions	3		12	1
712	2022-04-21 22:07:44.450831+00	401	Localiza	3		12	1
713	2022-04-21 22:07:44.467239+00	387	MICAN	3		12	1
714	2022-04-21 22:07:44.484642+00	380	MJV	3		12	1
715	2022-04-21 22:07:44.500969+00	395	Pagar.me	3		12	1
716	2022-04-21 22:07:44.518125+00	392	Sidia	3		12	1
717	2022-04-21 22:07:44.787468+00	394	Stefanini	3		12	1
718	2022-04-21 22:07:45.05764+00	405	UFMA	3		12	1
719	2022-04-21 22:07:45.633863+00	400	Unimed Paraná	3		12	1
720	2022-04-21 22:07:45.650238+00	398	Vale	3		12	1
721	2022-04-21 22:07:45.667765+00	385	W3care	3		12	1
722	2022-04-21 22:08:27.320714+00	53	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__jd6DhmE.xls	1	[{"added": {}}]	34	1
723	2022-04-21 22:09:18.585745+00	53	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__jd6DhmE.xls	3		34	1
724	2022-04-21 22:09:45.964785+00	423		3		12	1
725	2022-04-21 22:09:46.395185+00	418		3		12	1
726	2022-04-21 22:09:46.410752+00	413		3		12	1
727	2022-04-21 22:09:46.427976+00	410		3		12	1
728	2022-04-21 22:09:46.444108+00	416	-	3		12	1
729	2022-04-21 22:09:46.461399+00	431	ArcelorMittal Sistemas	3		12	1
730	2022-04-21 22:09:46.477853+00	408	BeeBee	3		12	1
731	2022-04-21 22:09:46.495115+00	430	BITKA	3		12	1
732	2022-04-21 22:09:46.511645+00	409	Boticário	3		12	1
733	2022-04-21 22:09:46.528897+00	411	Coover	3		12	1
734	2022-04-21 22:09:46.545264+00	417	Dataprev	3		12	1
735	2022-04-21 22:09:46.562653+00	424	DTI DIGITAL	3		12	1
736	2022-04-21 22:09:46.578977+00	429	Genesis Tecnologia	3		12	1
737	2022-04-21 22:09:46.596194+00	426	i4sea	3		12	1
738	2022-04-21 22:09:46.612925+00	420	Ifes	3		12	1
739	2022-04-21 22:09:46.629335+00	415	Kinvo	3		12	1
740	2022-04-21 22:09:46.646478+00	406	Lead Applied Solutions	3		12	1
741	2022-04-21 22:09:46.662906+00	428	Localiza	3		12	1
742	2022-04-21 22:09:46.680099+00	414	MICAN	3		12	1
743	2022-04-21 22:09:46.696616+00	407	MJV	3		12	1
744	2022-04-21 22:09:46.713788+00	422	Pagar.me	3		12	1
745	2022-04-21 22:09:46.730055+00	419	Sidia	3		12	1
746	2022-04-21 22:09:46.747555+00	421	Stefanini	3		12	1
747	2022-04-21 22:09:46.763974+00	432	UFMA	3		12	1
748	2022-04-21 22:09:46.783127+00	427	Unimed Paraná	3		12	1
751	2022-04-21 22:10:10.030249+00	54	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__wJsTSZD.xls	1	[{"added": {}}]	34	1
752	2022-04-21 22:12:21.101765+00	450		3		12	1
753	2022-04-21 22:12:21.122271+00	445		3		12	1
754	2022-04-21 22:12:21.139518+00	440		3		12	1
755	2022-04-21 22:12:21.156038+00	437		3		12	1
756	2022-04-21 22:12:21.173419+00	443	-	3		12	1
757	2022-04-21 22:12:21.189758+00	458	ArcelorMittal Sistemas	3		12	1
758	2022-04-21 22:12:21.207052+00	435	BeeBee	3		12	1
759	2022-04-21 22:12:21.22352+00	457	BITKA	3		12	1
760	2022-04-21 22:12:21.240966+00	436	Boticário	3		12	1
761	2022-04-21 22:12:21.257256+00	438	Coover	3		12	1
762	2022-04-21 22:12:21.27454+00	444	Dataprev	3		12	1
763	2022-04-21 22:12:21.290814+00	451	DTI DIGITAL	3		12	1
764	2022-04-21 22:12:21.308128+00	456	Genesis Tecnologia	3		12	1
765	2022-04-21 22:12:21.324722+00	453	i4sea	3		12	1
766	2022-04-21 22:12:21.341762+00	447	Ifes	3		12	1
767	2022-04-21 22:12:21.358287+00	442	Kinvo	3		12	1
768	2022-04-21 22:12:21.375644+00	433	Lead Applied Solutions	3		12	1
769	2022-04-21 22:12:21.392095+00	455	Localiza	3		12	1
770	2022-04-21 22:12:21.409568+00	441	MICAN	3		12	1
771	2022-04-21 22:12:21.425669+00	434	MJV	3		12	1
772	2022-04-21 22:12:21.442968+00	449	Pagar.me	3		12	1
773	2022-04-21 22:12:21.45964+00	446	Sidia	3		12	1
774	2022-04-21 22:12:21.477064+00	448	Stefanini	3		12	1
775	2022-04-21 22:12:21.510476+00	459	UFMA	3		12	1
776	2022-04-21 22:12:21.526946+00	454	Unimed Paraná	3		12	1
777	2022-04-21 22:12:21.544291+00	452	Vale	3		12	1
778	2022-04-21 22:12:21.560834+00	439	W3care	3		12	1
779	2022-04-21 22:12:55.210262+00	55	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__LxZSc6k.xls	1	[{"added": {}}]	34	1
780	2022-04-21 22:29:11.369999+00	55	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__LxZSc6k.xls	3		34	1
781	2022-04-21 22:29:29.053099+00	477		3		12	1
782	2022-04-21 22:29:29.076057+00	472		3		12	1
783	2022-04-21 22:29:29.093119+00	467		3		12	1
784	2022-04-21 22:29:29.109944+00	464		3		12	1
785	2022-04-21 22:29:29.127471+00	470	-	3		12	1
786	2022-04-21 22:29:29.143784+00	485	ArcelorMittal Sistemas	3		12	1
787	2022-04-21 22:29:29.16115+00	462	BeeBee	3		12	1
788	2022-04-21 22:29:29.177786+00	484	BITKA	3		12	1
789	2022-04-21 22:29:29.194931+00	463	Boticário	3		12	1
790	2022-04-21 22:29:29.211375+00	465	Coover	3		12	1
791	2022-04-21 22:29:29.228799+00	471	Dataprev	3		12	1
792	2022-04-21 22:29:29.245231+00	478	DTI DIGITAL	3		12	1
793	2022-04-21 22:29:29.262244+00	483	Genesis Tecnologia	3		12	1
794	2022-04-21 22:29:29.278686+00	480	i4sea	3		12	1
795	2022-04-21 22:29:29.296101+00	474	Ifes	3		12	1
796	2022-04-21 22:29:29.312639+00	469	Kinvo	3		12	1
797	2022-04-21 22:29:29.329512+00	460	Lead Applied Solutions	3		12	1
798	2022-04-21 22:29:29.345866+00	482	Localiza	3		12	1
799	2022-04-21 22:29:29.363284+00	468	MICAN	3		12	1
800	2022-04-21 22:29:29.379741+00	461	MJV	3		12	1
801	2022-04-21 22:29:29.397415+00	476	Pagar.me	3		12	1
802	2022-04-21 22:29:29.413742+00	473	Sidia	3		12	1
803	2022-04-21 22:29:29.430648+00	475	Stefanini	3		12	1
804	2022-04-21 22:29:29.447244+00	486	UFMA	3		12	1
805	2022-04-21 22:29:29.464006+00	481	Unimed Paraná	3		12	1
806	2022-04-21 22:29:29.48067+00	479	Vale	3		12	1
807	2022-04-21 22:29:29.498037+00	466	W3care	3		12	1
808	2022-04-21 22:31:01.014636+00	477		3		12	1
809	2022-04-21 22:31:01.036932+00	472		3		12	1
810	2022-04-21 22:31:01.289803+00	467		3		12	1
811	2022-04-21 22:31:01.570251+00	464		3		12	1
812	2022-04-21 22:31:02.163874+00	470	-	3		12	1
813	2022-04-21 22:31:02.19722+00	485	ArcelorMittal Sistemas	3		12	1
814	2022-04-21 22:31:02.2143+00	462	BeeBee	3		12	1
815	2022-04-21 22:31:02.230873+00	484	BITKA	3		12	1
816	2022-04-21 22:31:02.248024+00	463	Boticário	3		12	1
817	2022-04-21 22:31:02.264478+00	465	Coover	3		12	1
818	2022-04-21 22:31:02.281559+00	471	Dataprev	3		12	1
819	2022-04-21 22:31:02.298151+00	478	DTI DIGITAL	3		12	1
820	2022-04-21 22:31:02.315434+00	483	Genesis Tecnologia	3		12	1
821	2022-04-21 22:31:02.331746+00	480	i4sea	3		12	1
822	2022-04-21 22:31:02.349184+00	474	Ifes	3		12	1
823	2022-04-21 22:31:02.365439+00	469	Kinvo	3		12	1
824	2022-04-21 22:31:02.382819+00	460	Lead Applied Solutions	3		12	1
825	2022-04-21 22:31:02.399089+00	482	Localiza	3		12	1
826	2022-04-21 22:31:02.416507+00	468	MICAN	3		12	1
827	2022-04-21 22:31:02.432917+00	461	MJV	3		12	1
828	2022-04-21 22:31:02.450063+00	476	Pagar.me	3		12	1
829	2022-04-21 22:31:02.46731+00	473	Sidia	3		12	1
830	2022-04-21 22:31:02.483364+00	475	Stefanini	3		12	1
831	2022-04-21 22:31:02.499403+00	486	UFMA	3		12	1
832	2022-04-21 22:31:02.516746+00	481	Unimed Paraná	3		12	1
833	2022-04-21 22:31:02.533108+00	479	Vale	3		12	1
834	2022-04-21 22:31:02.551054+00	466	W3care	3		12	1
835	2022-04-21 22:31:22.974357+00	477		3		12	1
836	2022-04-21 22:31:22.998298+00	472		3		12	1
837	2022-04-21 22:31:23.03128+00	467		3		12	1
838	2022-04-21 22:31:23.049024+00	464		3		12	1
839	2022-04-21 22:31:23.065331+00	470	-	3		12	1
840	2022-04-21 22:31:23.082451+00	485	ArcelorMittal Sistemas	3		12	1
841	2022-04-21 22:31:23.098952+00	462	BeeBee	3		12	1
842	2022-04-21 22:31:23.116254+00	484	BITKA	3		12	1
843	2022-04-21 22:31:23.13273+00	463	Boticário	3		12	1
844	2022-04-21 22:31:23.149636+00	465	Coover	3		12	1
845	2022-04-21 22:31:23.166231+00	471	Dataprev	3		12	1
846	2022-04-21 22:31:23.183627+00	478	DTI DIGITAL	3		12	1
847	2022-04-21 22:31:23.199646+00	483	Genesis Tecnologia	3		12	1
848	2022-04-21 22:31:23.21736+00	480	i4sea	3		12	1
849	2022-04-21 22:31:23.233035+00	474	Ifes	3		12	1
850	2022-04-21 22:31:23.250442+00	469	Kinvo	3		12	1
851	2022-04-21 22:31:23.266759+00	460	Lead Applied Solutions	3		12	1
852	2022-04-21 22:31:23.284791+00	482	Localiza	3		12	1
853	2022-04-21 22:31:23.301012+00	468	MICAN	3		12	1
854	2022-04-21 22:31:23.318273+00	461	MJV	3		12	1
855	2022-04-21 22:31:23.334546+00	476	Pagar.me	3		12	1
856	2022-04-21 22:31:23.351858+00	473	Sidia	3		12	1
857	2022-04-21 22:31:23.36827+00	475	Stefanini	3		12	1
858	2022-04-21 22:31:23.38564+00	486	UFMA	3		12	1
859	2022-04-21 22:31:23.401961+00	481	Unimed Paraná	3		12	1
863	2022-04-21 22:31:55.789636+00	472		3		12	1
864	2022-04-21 22:31:55.8061+00	467		3		12	1
865	2022-04-21 22:31:55.823636+00	464		3		12	1
866	2022-04-21 22:31:55.857637+00	470	-	3		12	1
867	2022-04-21 22:31:55.874028+00	485	ArcelorMittal Sistemas	3		12	1
868	2022-04-21 22:31:55.891435+00	462	BeeBee	3		12	1
869	2022-04-21 22:31:55.907741+00	484	BITKA	3		12	1
870	2022-04-21 22:31:55.924534+00	463	Boticário	3		12	1
871	2022-04-21 22:31:55.941737+00	465	Coover	3		12	1
872	2022-04-21 22:31:55.957975+00	471	Dataprev	3		12	1
873	2022-04-21 22:31:55.975311+00	478	DTI DIGITAL	3		12	1
874	2022-04-21 22:31:55.991477+00	483	Genesis Tecnologia	3		12	1
875	2022-04-21 22:31:56.00914+00	480	i4sea	3		12	1
876	2022-04-21 22:31:56.025557+00	474	Ifes	3		12	1
877	2022-04-21 22:31:56.042631+00	469	Kinvo	3		12	1
878	2022-04-21 22:31:56.058876+00	460	Lead Applied Solutions	3		12	1
879	2022-04-21 22:31:56.076113+00	482	Localiza	3		12	1
880	2022-04-21 22:31:56.092574+00	468	MICAN	3		12	1
881	2022-04-21 22:31:56.109708+00	461	MJV	3		12	1
882	2022-04-21 22:31:56.126286+00	476	Pagar.me	3		12	1
883	2022-04-21 22:31:56.143831+00	473	Sidia	3		12	1
884	2022-04-21 22:31:56.160267+00	475	Stefanini	3		12	1
885	2022-04-21 22:31:56.179989+00	486	UFMA	3		12	1
886	2022-04-21 22:31:56.19622+00	481	Unimed Paraná	3		12	1
887	2022-04-21 22:31:56.213695+00	479	Vale	3		12	1
888	2022-04-21 22:31:56.229896+00	466	W3care	3		12	1
889	2022-04-21 22:36:26.74124+00	56	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas_novo.xls	1	[{"added": {}}]	34	1
890	2022-04-22 15:40:46.980178+00	68	IS.10-Dados do(s) repositório(a) de dados dos clientes/consumidores são usados na tomada de decisão pela área de negócios.	2	[{"changed": {"fields": ["Statement", "Pe element"]}}]	31	1
891	2022-04-22 20:50:01.990685+00	1	Acre	2	[{"changed": {"fields": ["Region"]}}]	9	1
892	2022-04-22 21:04:08.086637+00	1	Acre	2	[{"changed": {"fields": ["Region"]}}]	9	1
893	2022-04-22 21:04:25.519427+00	4	Amazonas	2	[{"changed": {"fields": ["Region"]}}]	9	1
894	2022-04-22 21:04:40.918822+00	3	Amapá	2	[{"changed": {"fields": ["Region"]}}]	9	1
895	2022-04-22 21:05:48.987178+00	14	Pará	2	[{"changed": {"fields": ["Region"]}}]	9	1
896	2022-04-22 21:06:20.539855+00	22	Rondônia	2	[{"changed": {"fields": ["Region"]}}]	9	1
897	2022-04-22 21:06:34.312067+00	23	Roraima	2	[{"changed": {"fields": ["Region"]}}]	9	1
898	2022-04-22 21:06:41.007541+00	27	Tocantins	2	[{"changed": {"fields": ["Region"]}}]	9	1
899	2022-04-22 21:07:35.491152+00	2	Alagoas	2	[{"changed": {"fields": ["Region"]}}]	9	1
900	2022-04-22 21:07:48.99222+00	5	Bahia	2	[{"changed": {"fields": ["Region"]}}]	9	1
901	2022-04-22 21:07:58.156006+00	6	Ceará	2	[{"changed": {"fields": ["Region"]}}]	9	1
902	2022-04-22 21:08:55.465637+00	10	Maranhão	2	[{"changed": {"fields": ["Region"]}}]	9	1
903	2022-04-22 21:09:11.896201+00	18	Piauí	2	[{"changed": {"fields": ["Region"]}}]	9	1
904	2022-04-22 21:09:29.220597+00	17	Pernambuco	2	[{"changed": {"fields": ["Region"]}}]	9	1
905	2022-04-22 21:09:46.644482+00	15	Paraíba	2	[{"changed": {"fields": ["Region"]}}]	9	1
906	2022-04-22 21:10:00.868891+00	20	Rio Grande do Norte	2	[{"changed": {"fields": ["Region"]}}]	9	1
907	2022-04-22 21:10:11.482254+00	26	Sergipe	2	[{"changed": {"fields": ["Region"]}}]	9	1
908	2022-04-22 21:13:59.377038+00	16	Paraná	2	[{"changed": {"fields": ["Region"]}}]	9	1
909	2022-04-22 21:14:14.15658+00	21	Rio Grande do Sul	2	[{"changed": {"fields": ["Region"]}}]	9	1
910	2022-04-22 21:14:28.362903+00	24	Santa Catarina	2	[{"changed": {"fields": ["Region"]}}]	9	1
911	2022-04-22 21:14:37.812444+00	8	Espírito Santo	2	[{"changed": {"fields": ["Region"]}}]	9	1
912	2022-04-22 21:14:49.043762+00	19	Rio de Janeiro	2	[{"changed": {"fields": ["Region"]}}]	9	1
913	2022-04-22 21:14:58.628494+00	13	Minas Gerais	2	[{"changed": {"fields": ["Region"]}}]	9	1
914	2022-04-22 21:15:07.316811+00	25	São Paulo	2	[{"changed": {"fields": ["Region"]}}]	9	1
915	2022-04-22 21:15:15.532187+00	7	Distrito Federal	2	[{"changed": {"fields": ["Region"]}}]	9	1
916	2022-04-22 21:15:22.579537+00	9	Goiás	2	[{"changed": {"fields": ["Region"]}}]	9	1
917	2022-04-22 21:15:51.116781+00	11	Mato Grosso	2	[{"changed": {"fields": ["Region"]}}]	9	1
918	2022-04-22 21:15:59.763261+00	12	Mato Grosso do Sul	2	[{"changed": {"fields": ["Region"]}}]	9	1
919	2022-04-22 21:21:59.01963+00	1	Startup	1	[{"added": {}}]	39	1
920	2022-04-22 21:22:18.619723+00	2	Fábrica de Software	1	[{"added": {}}]	39	1
921	2022-04-22 21:22:28.274127+00	3	Empresa com departamento de TI	1	[{"added": {}}]	39	1
922	2022-04-22 21:23:02.707694+00	1	Fábrica de Software	2	[{"changed": {"fields": ["Category"]}}]	10	1
923	2022-04-22 21:23:11.143738+00	9	Empresa de serviços e consultoria de TI (Sustentação de infraestrutura e aplicações, desenvolvimento de projetos e etc)	2	[{"changed": {"fields": ["Category"]}}]	10	1
924	2022-04-22 21:23:18.791746+00	5	Empresa em que um único produto de software representa o negócio (ex., PicPay, Airbnb, Uber)	2	[{"changed": {"fields": ["Category"]}}]	10	1
925	2022-04-22 21:23:26.993368+00	3	Empresa Privada com departamento de TI	2	[{"changed": {"fields": ["Category"]}}]	10	1
926	2022-04-22 21:23:36.882908+00	8	Empresa Privada com foco em inovação e tranformação digital - business agility	2	[{"changed": {"fields": ["Category"]}}]	10	1
927	2022-04-22 21:23:43.860126+00	4	Empresa Pública com departamento de TI	2	[{"changed": {"fields": ["Category"]}}]	10	1
928	2022-04-22 21:23:51.199666+00	10	Fundação Pública com departamento de TI	2	[{"changed": {"fields": ["Category"]}}]	10	1
929	2022-04-22 21:24:00.059263+00	2	Startup	2	[{"changed": {"fields": ["Category"]}}]	10	1
930	2022-04-22 21:24:42.73864+00	501	Ifes	3		12	1
931	2022-04-22 21:24:42.759161+00	487	Lead Applied Solutions	3		12	1
932	2022-04-22 21:24:42.775739+00	495	MICAN	3		12	1
933	2022-04-22 23:59:12.501493+00	1	Nenhuma	2	[{"changed": {"fields": ["Value"]}}]	19	1
934	2022-04-22 23:59:37.455805+00	2	Baixa	2	[]	19	1
935	2022-04-22 23:59:47.57548+00	4	Alta	2	[{"changed": {"fields": ["Value"]}}]	19	1
936	2022-04-22 23:59:54.563085+00	3	Moderada	2	[{"changed": {"fields": ["Value"]}}]	19	1
937	2022-04-23 00:00:04.308021+00	2	Baixo	2	[{"changed": {"fields": ["Value"]}}]	20	1
938	2022-04-23 00:00:17.525788+00	3	Moderado	2	[{"changed": {"fields": ["Value"]}}]	20	1
939	2022-04-23 00:00:23.30739+00	4	Alto	2	[{"changed": {"fields": ["Value"]}}]	20	1
940	2022-04-23 21:41:30.209595+00	56	documents/2022/04/21/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas_novo.xls	3		34	1
941	2022-04-23 21:41:53.118689+00	504		3		12	1
942	2022-04-23 21:41:53.134822+00	499		3		12	1
943	2022-04-23 21:41:53.15187+00	494		3		12	1
944	2022-04-23 21:41:53.202007+00	491		3		12	1
945	2022-04-23 21:41:53.219276+00	497	-	3		12	1
946	2022-04-23 21:41:53.23559+00	512	ArcelorMittal Sistemas	3		12	1
947	2022-04-23 21:41:53.252815+00	489	BeeBee	3		12	1
948	2022-04-23 21:41:53.269549+00	511	BITKA	3		12	1
949	2022-04-23 21:41:53.286332+00	490	Boticário	3		12	1
950	2022-04-23 21:41:53.302739+00	492	Coover	3		12	1
951	2022-04-23 21:41:53.320262+00	498	Dataprev	3		12	1
952	2022-04-23 21:41:53.336565+00	505	DTI DIGITAL	3		12	1
953	2022-04-23 21:41:53.353887+00	510	Genesis Tecnologia	3		12	1
954	2022-04-23 21:41:53.370361+00	507	i4sea	3		12	1
955	2022-04-23 21:41:53.386619+00	496	Kinvo	3		12	1
956	2022-04-23 21:41:53.404171+00	509	Localiza	3		12	1
957	2022-04-23 21:41:53.42028+00	488	MJV	3		12	1
958	2022-04-23 21:41:53.437754+00	503	Pagar.me	3		12	1
959	2022-04-23 21:41:53.487758+00	500	Sidia	3		12	1
960	2022-04-23 21:41:53.757333+00	502	Stefanini	3		12	1
961	2022-04-23 21:41:54.026571+00	513	UFMA	3		12	1
962	2022-04-23 21:41:54.553245+00	508	Unimed Paraná	3		12	1
963	2022-04-23 21:41:54.597628+00	506	Vale	3		12	1
964	2022-04-23 21:41:54.632205+00	493	W3care	3		12	1
965	2022-04-23 21:43:30.745649+00	68	IS.10-Dados do(s) repositório(a) de dados dos clientes/consumidores são usados na tomada de decisão pela área de negócios	2	[{"changed": {"fields": ["Statement"]}}]	31	1
966	2022-04-23 21:43:52.400558+00	58	documents/2022/04/23/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__hqoHkci.xls	1	[{"added": {}}]	34	1
967	2022-04-23 22:08:17.059128+00	1	Ensino Superior	1	[{"added": {}}]	40	1
968	2022-04-23 22:08:23.849917+00	2	Mestre	1	[{"added": {}}]	40	1
969	2022-04-23 22:08:29.45308+00	3	Doutor	1	[{"added": {}}]	40	1
970	2022-04-23 22:08:55.701878+00	6	Doutorado	2	[{"changed": {"fields": ["Category"]}}]	15	1
971	2022-04-23 22:09:02.932218+00	3	Ensino Superior	2	[{"changed": {"fields": ["Category"]}}]	15	1
972	2022-04-23 22:09:09.514877+00	4	Especialização	2	[{"changed": {"fields": ["Category"]}}]	15	1
973	2022-04-23 22:09:17.276043+00	5	Mestrado	2	[{"changed": {"fields": ["Category"]}}]	15	1
974	2023-02-11 14:20:19.934039+00	58	documents/2022/04/23/Zeppelin__Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas__hqoHkci.xls	3		32	2
975	2023-02-11 14:38:14.003026+00	521	W3care	3		12	2
976	2023-02-11 14:38:14.017319+00	534	Vale	3		12	2
977	2023-02-11 14:38:14.020199+00	536	Unimed Paraná	3		12	2
978	2023-02-11 14:38:14.022748+00	541	UFMA	3		12	2
979	2023-02-11 14:38:14.025246+00	530	Stefanini	3		12	2
980	2023-02-11 14:38:14.027954+00	528	Sidia	3		12	2
981	2023-02-11 14:38:14.031063+00	531	Pagar.me	3		12	2
982	2023-02-11 14:38:14.033435+00	516	MJV	3		12	2
983	2023-02-11 14:38:14.035547+00	523	MICAN	3		12	2
984	2023-02-11 14:38:14.037781+00	537	Localiza	3		12	2
985	2023-02-11 14:38:14.039879+00	515	Lead Applied Solutions	3		12	2
986	2023-02-11 14:38:14.041926+00	524	Kinvo	3		12	2
987	2023-02-11 14:38:14.044643+00	529	Ifes	3		12	2
988	2023-02-11 14:38:14.04717+00	535	i4sea	3		12	2
989	2023-02-11 14:38:14.049511+00	538	Genesis Tecnologia	3		12	2
990	2023-02-11 14:38:14.051855+00	533	DTI DIGITAL	3		12	2
991	2023-02-11 14:38:14.054254+00	526	Dataprev	3		12	2
992	2023-02-11 14:38:14.056449+00	520	Coover	3		12	2
993	2023-02-11 14:38:14.058659+00	518	Boticário	3		12	2
994	2023-02-11 14:38:14.060928+00	539	BITKA	3		12	2
995	2023-02-11 14:38:14.063315+00	517	BeeBee	3		12	2
996	2023-02-11 14:38:14.065461+00	540	ArcelorMittal Sistemas	3		12	2
997	2023-02-11 14:38:14.067452+00	525	-	3		12	2
998	2023-02-11 14:38:14.069441+00	532		3		12	2
999	2023-02-11 14:38:14.071415+00	527		3		12	2
1000	2023-02-11 14:38:14.073503+00	522		3		12	2
1001	2023-02-11 14:38:14.075625+00	519		3		12	2
1002	2023-02-11 14:47:47.592057+00	36	CI.10-Há práticas que permitem que organizações ou pessoas externas ao projeto atuem na implementação do produto (i.e., produzam e integrem código ao produto sendo desenvolvido).	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1003	2023-02-11 14:48:02.125576+00	17	AO.17-A equipe se reúne com frequência ao longo do projeto para discutir sobre melhorias nas competências dos membros da equipe (p.ex., em reunião de retrospectiva).	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1004	2023-02-11 14:48:39.269109+00	34	CI.08-Há controle de versões dos artefatos de software (p.ex., código, teste, scripts etc.) em um repositório.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1005	2023-02-11 14:49:06.421818+00	37	CI.11-Dados são coletados para métricas que permitem avaliar o processo de integração contínua (p.ex., quantidade de builds cancelados, quantidade de integrações de código realizadas).	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1006	2023-02-11 14:49:30.225094+00	61	IS.03-A organização identifica novas oportunidades de negócio com base nos feedbacks capturados automaticamente dos clientes/consumidores.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1007	2023-02-11 14:49:49.921005+00	38	CI.12-Dados produzidos nos ambientes de integração contínua (p.ex., data das builds, quantidade de testes executados e percentual de cobertura)  são armazenados em um (ou mais) repositório de dados.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1008	2023-02-11 14:50:18.60306+00	59	IS.01-Feedbacks (dados e opiniões) dos clientes/consumidores são capturados contínua e automaticamente e armazenados em um (ou mais) repositório de dados de clientes/consumidores.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1009	2023-02-11 14:50:44.028992+00	63	IS.05-Experimentos (p.ex., testes A/B) são realizados com os clientes/consumidores para melhorar os produtos.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1010	2023-02-11 14:50:59.683759+00	68	IS.10-Dados do(s) repositório(a) de dados dos clientes/consumidores são usados na tomada de decisão pela área de negócios.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1011	2023-02-11 14:51:37.298936+00	39	CI.13-O processo de integração contínua (incluindo a realização de testes automatizados) é avaliado e melhorado continuamente.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1012	2023-02-11 14:52:29.092157+00	65	IS.07-A organização continuamente experimenta novas tecnologias e metodologias.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1013	2023-02-11 14:56:06.755043+00	66	IS.08-Há um fluxo de informação claro entre o nível estratégico e a área de desenvolvimento da organização, permitindo que dados dos clientes/consumidores (capturados contínua e automaticamente) sejam	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1014	2023-02-11 14:56:34.59357+00	19	AO.19-Boas práticas de programação são adotadas (p.ex., código coletivo, codificação padronizada, programação em pares, revisão de código).	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1015	2023-02-11 15:00:37.306136+00	3	Realizada no nível de projeto/produto	2	[]	29	2
1016	2023-02-11 15:00:55.632757+00	5	Institucionalizada	2	[]	29	2
1017	2023-02-11 15:09:25.039753+00	62	IS.04-Feedbacks (dados e opiniões) dos clientes/consumidores (capturados contínua e automaticamente) são usados para experimentação e inovação.	2	[{"changed": {"fields": ["Statement"]}}]	31	2
1018	2023-02-11 15:09:52.594287+00	65	documents/2023/02/11/Zeppelin_Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas_3Uv3WP8.xls	1	[{"added": {}}]	34	2
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	organization	activity
8	organization	billing
10	organization	organizationtype
11	organization	size
12	organization	organization
13	organization	developmentteamoverview
14	organization	timesize
15	employee	academicdegree
16	employee	academicdegreestatus
17	employee	employee
18	employee	employeeknowledge
19	employee	experiencelevel
20	employee	knwoledgelevel
21	employee	team
22	employee	sthstageknwoledgelevel
23	employee	sthstageexperiencelevel
24	employee	position
25	cse_framework	process
26	sth	stage
27	practitioners_eye	element
28	practitioners_eye	dimension
29	questionnaire	adoptedlevel
30	questionnaire	feedbackquestionnaire
31	questionnaire	statement
32	questionnaire	questionnaire
33	questionnaire	answer
34	questionnaire	questionnairegoogleforms
35	questionnaire	questionnaireexcel
9	organization	state
36	organization	region
37	continuous_star	continuousactivity
38	continuous_star	continuousphase
39	organization	organizationcategory
40	employee	academicdegreecategory
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2022-04-20 22:38:22.515458+00
2	auth	0001_initial	2022-04-20 22:38:22.896641+00
3	admin	0001_initial	2022-04-20 22:38:23.689647+00
4	admin	0002_logentry_remove_auto_add	2022-04-20 22:38:23.925692+00
5	admin	0003_logentry_add_action_flag_choices	2022-04-20 22:38:24.10691+00
6	contenttypes	0002_remove_content_type_name	2022-04-20 22:38:24.160499+00
7	auth	0002_alter_permission_name_max_length	2022-04-20 22:38:24.194566+00
8	auth	0003_alter_user_email_max_length	2022-04-20 22:38:24.220898+00
9	auth	0004_alter_user_username_opts	2022-04-20 22:38:24.248115+00
10	auth	0005_alter_user_last_login_null	2022-04-20 22:38:24.291035+00
11	auth	0006_require_contenttypes_0002	2022-04-20 22:38:24.309237+00
12	auth	0007_alter_validators_add_error_messages	2022-04-20 22:38:24.350912+00
13	auth	0008_alter_user_username_max_length	2022-04-20 22:38:24.431188+00
14	auth	0009_alter_user_last_name_max_length	2022-04-20 22:38:24.484282+00
15	auth	0010_alter_group_name_max_length	2022-04-20 22:38:24.518455+00
16	auth	0011_update_proxy_permissions	2022-04-20 22:38:24.544721+00
17	auth	0012_alter_user_first_name_max_length	2022-04-20 22:38:24.569983+00
18	cse_framework	0001_initial	2022-04-20 22:38:24.657483+00
19	organization	0001_initial	2022-04-20 22:38:26.050177+00
20	organization	0002_auto_20220120_1405	2022-04-20 22:38:26.673835+00
21	organization	0003_auto_20220120_1409	2022-04-20 22:38:27.198505+00
22	organization	0004_auto_20220120_1409	2022-04-20 22:38:27.378593+00
23	organization	0005_organization_processs_develpment_organizational_unit	2022-04-20 22:38:27.429925+00
24	organization	0006_auto_20220121_1842	2022-04-20 22:38:27.614113+00
25	sth	0001_initial	2022-04-20 22:38:27.769669+00
26	employee	0001_initial	2022-04-20 22:38:29.697372+00
27	employee	0002_auto_20220120_1638	2022-04-20 22:38:31.910529+00
28	employee	0003_auto_20220121_1843	2022-04-20 22:38:32.105064+00
29	organization	0007_auto_20220213_1450	2022-04-20 22:38:32.359281+00
30	organization	0008_auto_20220213_1535	2022-04-20 22:38:32.496193+00
31	organization	0009_auto_20220214_1442	2022-04-20 22:38:32.602755+00
32	organization	0010_auto_20220214_1503	2022-04-20 22:38:32.675828+00
33	practitioners_eye	0001_initial	2022-04-20 22:38:33.715522+00
34	practitioners_eye	0002_auto_20220120_1827	2022-04-20 22:38:34.096897+00
35	practitioners_eye	0003_auto_20220120_1834	2022-04-20 22:38:34.223562+00
36	questionnaire	0001_initial	2022-04-20 22:38:35.045297+00
37	questionnaire	0002_auto_20220213_1113	2022-04-20 22:38:36.699122+00
38	questionnaire	0003_auto_20220213_1115	2022-04-20 22:38:37.075184+00
39	questionnaire	0004_auto_20220213_2329	2022-04-20 22:38:37.18492+00
40	sessions	0001_initial	2022-04-20 22:38:38.184565+00
41	organization	0011_auto_20220420_2304	2022-04-20 23:05:00.550667+00
42	organization	0012_auto_20220420_2307	2022-04-20 23:07:43.004392+00
43	organization	0013_auto_20220420_2310	2022-04-20 23:10:45.813805+00
44	organization	0014_auto_20220420_2319	2022-04-20 23:19:52.310298+00
45	questionnaire	0005_auto_20220420_2348	2022-04-20 23:49:07.029057+00
46	questionnaire	0006_auto_20220421_1603	2022-04-21 16:03:44.606978+00
47	continuous_star	0001_initial	2022-04-21 17:21:12.053747+00
48	continuous_star	0002_auto_20220421_1721	2022-04-21 17:21:12.298643+00
49	questionnaire	0007_statement_continuous_activity	2022-04-21 17:21:12.407572+00
50	continuous_star	0003_auto_20220421_1737	2022-04-21 17:37:30.350723+00
51	employee	0004_auto_20220421_2235	2022-04-21 22:35:16.91757+00
52	organization	0015_auto_20220422_2118	2022-04-22 21:19:02.719851+00
53	employee	0005_auto_20220422_2358	2022-04-22 23:58:32.898498+00
54	employee	0006_auto_20220423_2205	2022-04-23 22:05:08.867438+00
55	employee	0007_auto_20220423_2207	2022-04-23 22:07:44.289724+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
ru8zhicuu9vtrd76fhaxziuafz7y5lo9	.eJxVjMsOwiAQRf-FtSHA8HTp3m8glBmkaiAp7cr479qkC93ec859sZi2tcZt0BJnZGcm2el3m1J-UNsB3lO7dZ57W5d54rvCDzr4tSM9L4f7d1DTqN_aBqMBARxoLdBTKsKAIWeCLWCS9whauuBDhkDFKVLWKqFlKCgRCrL3B68rNtc:1nhJ21:-DGgh1elVdRZPAZIvGNAEltmg0WKfAnWbhOgS3e25DY	2022-05-04 22:42:41.53127+00
9cmiseyetor869jlasym073iq64nfmfy	.eJxVjMsOwiAQRf-FtSHA8HTp3m8glBmkaiAp7cr479qkC93ec859sZi2tcZt0BJnZGcm2el3m1J-UNsB3lO7dZ57W5d54rvCDzr4tSM9L4f7d1DTqN_aBqMBARxoLdBTKsKAIWeCLWCS9whauuBDhkDFKVLWKqFlKCgRCrL3B68rNtc:1nhJfW:2so8Llu2180G2ZXK0XeMjFL5OCpqFEs-cTR9zfGisSM	2022-05-04 23:23:30.228566+00
mzalx7yhosa4onbkgy3ellsa0y8q26cc	.eJxVjMsOwiAQRf-FtSHA8HTp3m8glBmkaiAp7cr479qkC93ec859sZi2tcZt0BJnZGcm2el3m1J-UNsB3lO7dZ57W5d54rvCDzr4tSM9L4f7d1DTqN_aBqMBARxoLdBTKsKAIWeCLWCS9whauuBDhkDFKVLWKqFlKCgRCrL3B68rNtc:1niNUr:Mz18HSE3Pr85bgvpqKXzVscjCMEnbYiujfBcYIy_974	2022-05-07 21:40:53.580032+00
8em2368o8a8i4xb9uy2x9hs74fdwreju	.eJxVjDsOwjAQBe_iGlla_0NJzxmstXeNA8iW4qRC3B0ipYD2zcx7iYjbWuM2eIkzibNQ4vS7JcwPbjugO7Zbl7m3dZmT3BV50CGvnfh5Ody_g4qjfmunnOZsrSF2UHIoCEVPwZvJgXeKggJESwApBw4aKftCnAoUxSakJN4f5AQ4nw:1pQqj2:603G_HsQw4aWQUvAzdVfwX-NteDlJPCyd5F6up9uHoo	2023-02-25 14:19:36.124256+00
\.


--
-- Data for Name: employee_academicdegree; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_academicdegree (id, created_at, modified_at, name, category_id) FROM stdin;
1	2022-04-20 23:28:45.159658+00	2022-04-20 23:28:45.159685+00	Ensino Médio	\N
2	2022-04-20 23:28:51.682745+00	2022-04-20 23:28:51.682776+00	Ensino Técnico	\N
6	2022-04-20 23:29:27.929583+00	2022-04-23 22:08:55.700725+00	Doutorado	3
3	2022-04-20 23:29:01.297612+00	2022-04-23 22:09:02.931282+00	Ensino Superior	1
4	2022-04-20 23:29:08.376357+00	2022-04-23 22:09:09.513479+00	Especialização	1
5	2022-04-20 23:29:19.31831+00	2022-04-23 22:09:17.274449+00	Mestrado	2
\.


--
-- Data for Name: employee_academicdegreecategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_academicdegreecategory (id, created_at, modified_at, name) FROM stdin;
1	2022-04-23 22:08:17.0575+00	2022-04-23 22:08:17.057526+00	Ensino Superior
2	2022-04-23 22:08:23.848929+00	2022-04-23 22:08:23.848953+00	Mestre
3	2022-04-23 22:08:29.450093+00	2022-04-23 22:08:29.450167+00	Doutor
\.


--
-- Data for Name: employee_academicdegreestatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_academicdegreestatus (id, created_at, modified_at, name) FROM stdin;
1	2022-04-20 23:29:52.725548+00	2022-04-20 23:29:52.725571+00	Incompleto
2	2022-04-20 23:36:48.847878+00	2022-04-20 23:36:48.847943+00	Completo
\.


--
-- Data for Name: employee_employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_employee (id, created_at, modified_at, name, email, organization_id, role, position_id) FROM stdin;
465	2023-02-11 15:09:46.221395+00	2023-02-11 15:09:46.226622+00		org1@org.com	547		6
466	2023-02-11 15:09:46.431845+00	2023-02-11 15:09:46.436831+00		org2@org.com	548		5
467	2023-02-11 15:09:46.637992+00	2023-02-11 15:09:46.642561+00		org3@org.com	549		5
468	2023-02-11 15:09:46.879466+00	2023-02-11 15:09:46.884156+00		org4@org.com	550		7
469	2023-02-11 15:09:47.10816+00	2023-02-11 15:09:47.112912+00		org5@org.com	551		1
470	2023-02-11 15:09:47.336504+00	2023-02-11 15:09:47.341404+00		org6@org.com	552		4
471	2023-02-11 15:09:47.552879+00	2023-02-11 15:09:47.557394+00		org7@org.com	553		6
472	2023-02-11 15:09:47.764919+00	2023-02-11 15:09:47.770223+00		org8@org.com	554		8
473	2023-02-11 15:09:47.984785+00	2023-02-11 15:09:47.989326+00		org9@org.com	555		6
474	2023-02-11 15:09:48.198229+00	2023-02-11 15:09:48.204287+00		org10@org.com	556		6
475	2023-02-11 15:09:48.429443+00	2023-02-11 15:09:48.433639+00		org11@org.com	557		6
476	2023-02-11 15:09:48.64855+00	2023-02-11 15:09:48.653334+00		org12@org.com	558		5
477	2023-02-11 15:09:48.859277+00	2023-02-11 15:09:48.863475+00		org13@org.com	559		9
478	2023-02-11 15:09:49.087843+00	2023-02-11 15:09:49.092187+00		org14@org.com	560		4
479	2023-02-11 15:09:49.309964+00	2023-02-11 15:09:49.314206+00		org15@org.com	561		10
480	2023-02-11 15:09:49.529828+00	2023-02-11 15:09:49.534086+00		org16@org.com	562		3
481	2023-02-11 15:09:49.739431+00	2023-02-11 15:09:49.745615+00		org17@org.com	563		5
482	2023-02-11 15:09:49.975675+00	2023-02-11 15:09:49.980314+00		org18@org.com	564		1
483	2023-02-11 15:09:50.1834+00	2023-02-11 15:09:50.188953+00		org19@org.com	565		6
484	2023-02-11 15:09:50.413813+00	2023-02-11 15:09:50.419335+00		org20@org.com	566		5
485	2023-02-11 15:09:50.649145+00	2023-02-11 15:09:50.653827+00		org21@org.com	567		4
486	2023-02-11 15:09:50.833083+00	2023-02-11 15:09:50.837598+00		org22@org.com	568		11
487	2023-02-11 15:09:51.00558+00	2023-02-11 15:09:51.009111+00		org23@org.com	569		12
488	2023-02-11 15:09:51.179626+00	2023-02-11 15:09:51.182974+00		org24@org.com	570		6
489	2023-02-11 15:09:51.350866+00	2023-02-11 15:09:51.354755+00		org25@org.com	571		1
490	2023-02-11 15:09:51.513337+00	2023-02-11 15:09:51.516345+00		org26@org.com	572		5
491	2023-02-11 15:09:51.718729+00	2023-02-11 15:09:51.725023+00		org27@org.com	573		6
492	2023-02-11 15:09:51.958122+00	2023-02-11 15:09:51.962515+00		org28@org.com	574		2
493	2023-02-11 15:09:52.173546+00	2023-02-11 15:09:52.177744+00		org29@org.com	575		3
494	2023-02-11 15:09:52.389445+00	2023-02-11 15:09:52.393403+00		org30@org.com	576		3
\.


--
-- Data for Name: employee_employeeknowledge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_employeeknowledge (id, created_at, modified_at, academic_degree_id, academic_degree_status_id, employee_id) FROM stdin;
492	2023-02-11 15:09:46.224491+00	2023-02-11 15:09:46.224507+00	6	2	465
493	2023-02-11 15:09:46.434159+00	2023-02-11 15:09:46.434183+00	3	2	466
494	2023-02-11 15:09:46.640429+00	2023-02-11 15:09:46.640448+00	3	2	467
495	2023-02-11 15:09:46.88187+00	2023-02-11 15:09:46.88189+00	4	1	468
496	2023-02-11 15:09:47.110596+00	2023-02-11 15:09:47.110618+00	4	2	469
497	2023-02-11 15:09:47.339044+00	2023-02-11 15:09:47.339067+00	5	1	470
498	2023-02-11 15:09:47.55541+00	2023-02-11 15:09:47.555437+00	5	2	471
499	2023-02-11 15:09:47.767363+00	2023-02-11 15:09:47.767394+00	5	2	472
500	2023-02-11 15:09:47.987298+00	2023-02-11 15:09:47.987318+00	5	2	473
501	2023-02-11 15:09:48.200848+00	2023-02-11 15:09:48.200896+00	4	2	474
502	2023-02-11 15:09:48.431499+00	2023-02-11 15:09:48.431521+00	6	1	475
503	2023-02-11 15:09:48.650677+00	2023-02-11 15:09:48.650704+00	6	1	476
504	2023-02-11 15:09:48.861547+00	2023-02-11 15:09:48.861568+00	4	2	477
505	2023-02-11 15:09:49.090045+00	2023-02-11 15:09:49.090065+00	5	2	478
506	2023-02-11 15:09:49.312201+00	2023-02-11 15:09:49.312221+00	5	2	479
507	2023-02-11 15:09:49.532061+00	2023-02-11 15:09:49.532081+00	4	2	480
508	2023-02-11 15:09:49.743574+00	2023-02-11 15:09:49.743593+00	4	1	481
509	2023-02-11 15:09:49.978223+00	2023-02-11 15:09:49.978243+00	5	2	482
510	2023-02-11 15:09:50.186781+00	2023-02-11 15:09:50.186801+00	4	2	483
511	2023-02-11 15:09:50.416277+00	2023-02-11 15:09:50.416299+00	5	1	484
512	2023-02-11 15:09:50.651686+00	2023-02-11 15:09:50.651707+00	5	2	485
513	2023-02-11 15:09:50.835523+00	2023-02-11 15:09:50.835543+00	4	2	486
514	2023-02-11 15:09:51.007397+00	2023-02-11 15:09:51.007414+00	5	1	487
515	2023-02-11 15:09:51.181371+00	2023-02-11 15:09:51.181386+00	4	2	488
516	2023-02-11 15:09:51.353138+00	2023-02-11 15:09:51.353155+00	3	2	489
517	2023-02-11 15:09:51.514868+00	2023-02-11 15:09:51.514882+00	5	2	490
518	2023-02-11 15:09:51.722609+00	2023-02-11 15:09:51.722639+00	5	1	491
519	2023-02-11 15:09:51.960419+00	2023-02-11 15:09:51.960439+00	3	1	492
520	2023-02-11 15:09:52.175747+00	2023-02-11 15:09:52.175766+00	3	1	493
521	2023-02-11 15:09:52.391557+00	2023-02-11 15:09:52.391577+00	3	1	494
\.


--
-- Data for Name: employee_experiencelevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_experiencelevel (id, created_at, modified_at, name, description, value) FROM stdin;
1	2022-04-20 23:31:47.227189+00	2022-04-22 23:59:12.499185+00	Nenhuma	Não conhece o tema.	0
2	2022-04-20 23:32:07.934455+00	2022-04-22 23:59:37.454126+00	Baixa	tem experiência de até 1 ano no tema	1
4	2022-04-20 23:32:38.223831+00	2022-04-22 23:59:47.571661+00	Alta	tem mais de 3 anos de experiência no tema.	5
3	2022-04-20 23:32:24.805003+00	2022-04-22 23:59:54.56185+00	Moderada	tem experiência de 1 a 3 anos no tema.	3
\.


--
-- Data for Name: employee_knwoledgelevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_knwoledgelevel (id, created_at, modified_at, name, description, value) FROM stdin;
1	2022-04-20 23:34:40.347564+00	2022-04-20 23:34:55.638663+00	Nenhum	não conhece o tema	1
2	2022-04-20 23:35:10.668466+00	2022-04-23 00:00:04.307148+00	Baixo	conhecimento pela  leitura de materiais ou em curso de curta duração (até 4 horas)	0
3	2022-04-20 23:35:29.161251+00	2022-04-23 00:00:17.524553+00	Moderado	conhecimento por disciplina, projeto de graduação ou Iniciação Científica no tema, ou   curso com duração superior a 4 horas;	3
4	2022-04-20 23:35:40.745633+00	2022-04-23 00:00:23.305717+00	Alto	é especialista no tema, tem certificação ou desenvolveu pesquisa de mestrado ou doutorado.	5
\.


--
-- Data for Name: employee_position; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_position (id, created_at, modified_at, name) FROM stdin;
1	2022-04-20 23:30:11.161559+00	2022-04-20 23:30:11.161592+00	Gerente de Projeto
2	2022-04-20 23:30:16.503894+00	2022-04-20 23:30:16.50393+00	Scrum Master
3	2022-04-20 23:30:23.078404+00	2022-04-20 23:30:23.07844+00	Product Owner
4	2022-04-20 23:30:28.650883+00	2022-04-20 23:30:28.650911+00	Desenvolvedor
5	2022-04-20 23:30:34.726457+00	2022-04-20 23:30:34.72649+00	Líder Técnico
6	2022-04-20 23:30:41.045679+00	2022-04-20 23:30:41.045725+00	Diretor
7	2022-04-21 15:04:52.472557+00	2022-04-21 15:04:52.47258+00	Squad Leader
8	2022-04-21 15:04:52.49958+00	2022-04-21 15:04:52.499596+00	Gerente Sênior
9	2022-04-21 15:04:52.52724+00	2022-04-21 15:04:52.527255+00	SME - Lider Técnico - Gerente de Projetos - Scrum Master
10	2022-04-21 15:04:52.537686+00	2022-04-21 15:04:52.537699+00	Professor EBTT
11	2022-04-21 15:04:52.564516+00	2022-04-21 15:04:52.564526+00	Gerente de TI
12	2022-04-21 15:04:52.568218+00	2022-04-21 15:04:52.568227+00	Coordenador de Engenharia de Software
\.


--
-- Data for Name: employee_sthstageexperiencelevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_sthstageexperiencelevel (id, created_at, modified_at, experience_level_id, stage_id, employee_id) FROM stdin;
1710	2023-02-11 15:09:46.237896+00	2023-02-11 15:09:46.237915+00	3	1	465
1711	2023-02-11 15:09:46.240184+00	2023-02-11 15:09:46.240201+00	1	2	465
1712	2023-02-11 15:09:46.242233+00	2023-02-11 15:09:46.242249+00	1	3	465
1713	2023-02-11 15:09:46.244132+00	2023-02-11 15:09:46.244145+00	2	4	465
1714	2023-02-11 15:09:46.447058+00	2023-02-11 15:09:46.447074+00	3	1	466
1715	2023-02-11 15:09:46.448859+00	2023-02-11 15:09:46.448873+00	3	2	466
1716	2023-02-11 15:09:46.450713+00	2023-02-11 15:09:46.450737+00	3	3	466
1717	2023-02-11 15:09:46.453492+00	2023-02-11 15:09:46.453511+00	2	4	466
1718	2023-02-11 15:09:46.653805+00	2023-02-11 15:09:46.653825+00	3	1	467
1719	2023-02-11 15:09:46.65638+00	2023-02-11 15:09:46.656399+00	3	2	467
1720	2023-02-11 15:09:46.658649+00	2023-02-11 15:09:46.658668+00	3	3	467
1721	2023-02-11 15:09:46.661203+00	2023-02-11 15:09:46.661284+00	1	4	467
1722	2023-02-11 15:09:46.8966+00	2023-02-11 15:09:46.896621+00	4	1	468
1723	2023-02-11 15:09:46.898882+00	2023-02-11 15:09:46.898902+00	3	2	468
1724	2023-02-11 15:09:46.90133+00	2023-02-11 15:09:46.901355+00	4	3	468
1725	2023-02-11 15:09:46.903901+00	2023-02-11 15:09:46.90392+00	2	4	468
1726	2023-02-11 15:09:47.126966+00	2023-02-11 15:09:47.126987+00	3	1	469
1727	2023-02-11 15:09:47.129513+00	2023-02-11 15:09:47.129534+00	3	2	469
1728	2023-02-11 15:09:47.132215+00	2023-02-11 15:09:47.132244+00	3	3	469
1729	2023-02-11 15:09:47.135336+00	2023-02-11 15:09:47.135368+00	2	4	469
1730	2023-02-11 15:09:47.353334+00	2023-02-11 15:09:47.353355+00	4	1	470
1731	2023-02-11 15:09:47.35553+00	2023-02-11 15:09:47.355549+00	4	2	470
1732	2023-02-11 15:09:47.357537+00	2023-02-11 15:09:47.35756+00	4	3	470
1733	2023-02-11 15:09:47.359541+00	2023-02-11 15:09:47.359559+00	2	4	470
1734	2023-02-11 15:09:47.569133+00	2023-02-11 15:09:47.569208+00	4	1	471
1735	2023-02-11 15:09:47.571447+00	2023-02-11 15:09:47.571467+00	4	2	471
1736	2023-02-11 15:09:47.573506+00	2023-02-11 15:09:47.573524+00	4	3	471
1737	2023-02-11 15:09:47.575561+00	2023-02-11 15:09:47.57558+00	3	4	471
1738	2023-02-11 15:09:47.78154+00	2023-02-11 15:09:47.781559+00	4	1	472
1739	2023-02-11 15:09:47.783816+00	2023-02-11 15:09:47.783871+00	4	2	472
1740	2023-02-11 15:09:47.786743+00	2023-02-11 15:09:47.78677+00	4	3	472
1741	2023-02-11 15:09:47.789104+00	2023-02-11 15:09:47.789124+00	4	4	472
1742	2023-02-11 15:09:47.999967+00	2023-02-11 15:09:47.999986+00	4	1	473
1743	2023-02-11 15:09:48.002951+00	2023-02-11 15:09:48.002969+00	4	2	473
1744	2023-02-11 15:09:48.005163+00	2023-02-11 15:09:48.005183+00	4	3	473
1745	2023-02-11 15:09:48.007169+00	2023-02-11 15:09:48.007188+00	4	4	473
1746	2023-02-11 15:09:48.215445+00	2023-02-11 15:09:48.215464+00	4	1	474
1747	2023-02-11 15:09:48.218305+00	2023-02-11 15:09:48.218348+00	2	2	474
1748	2023-02-11 15:09:48.221276+00	2023-02-11 15:09:48.221298+00	2	3	474
1749	2023-02-11 15:09:48.223485+00	2023-02-11 15:09:48.223504+00	3	4	474
1750	2023-02-11 15:09:48.446722+00	2023-02-11 15:09:48.446741+00	4	1	475
1751	2023-02-11 15:09:48.448778+00	2023-02-11 15:09:48.448797+00	4	2	475
1752	2023-02-11 15:09:48.451878+00	2023-02-11 15:09:48.451903+00	4	3	475
1753	2023-02-11 15:09:48.454846+00	2023-02-11 15:09:48.454864+00	3	4	475
1754	2023-02-11 15:09:48.6639+00	2023-02-11 15:09:48.663919+00	4	1	476
1755	2023-02-11 15:09:48.665971+00	2023-02-11 15:09:48.665989+00	4	2	476
1756	2023-02-11 15:09:48.668848+00	2023-02-11 15:09:48.668869+00	4	3	476
1757	2023-02-11 15:09:48.671102+00	2023-02-11 15:09:48.671122+00	4	4	476
1758	2023-02-11 15:09:48.876508+00	2023-02-11 15:09:48.876526+00	3	1	477
1759	2023-02-11 15:09:48.878572+00	2023-02-11 15:09:48.878614+00	2	2	477
1760	2023-02-11 15:09:48.880846+00	2023-02-11 15:09:48.880864+00	2	3	477
1761	2023-02-11 15:09:48.883556+00	2023-02-11 15:09:48.883613+00	3	4	477
1762	2023-02-11 15:09:49.105188+00	2023-02-11 15:09:49.105208+00	4	1	478
1763	2023-02-11 15:09:49.107399+00	2023-02-11 15:09:49.107417+00	3	2	478
1764	2023-02-11 15:09:49.109617+00	2023-02-11 15:09:49.109635+00	3	3	478
1765	2023-02-11 15:09:49.111692+00	2023-02-11 15:09:49.11171+00	1	4	478
1766	2023-02-11 15:09:49.326284+00	2023-02-11 15:09:49.326302+00	1	1	479
1767	2023-02-11 15:09:49.328396+00	2023-02-11 15:09:49.328415+00	1	2	479
1768	2023-02-11 15:09:49.330615+00	2023-02-11 15:09:49.330634+00	1	3	479
1769	2023-02-11 15:09:49.332704+00	2023-02-11 15:09:49.332722+00	1	4	479
1770	2023-02-11 15:09:49.545276+00	2023-02-11 15:09:49.545294+00	4	1	480
1771	2023-02-11 15:09:49.547247+00	2023-02-11 15:09:49.547288+00	3	2	480
1772	2023-02-11 15:09:49.549302+00	2023-02-11 15:09:49.549321+00	4	3	480
1773	2023-02-11 15:09:49.551989+00	2023-02-11 15:09:49.552008+00	3	4	480
1774	2023-02-11 15:09:49.756935+00	2023-02-11 15:09:49.756953+00	4	1	481
1775	2023-02-11 15:09:49.758819+00	2023-02-11 15:09:49.758837+00	3	2	481
1776	2023-02-11 15:09:49.760684+00	2023-02-11 15:09:49.760703+00	3	3	481
1777	2023-02-11 15:09:49.762572+00	2023-02-11 15:09:49.76259+00	2	4	481
1778	2023-02-11 15:09:49.992035+00	2023-02-11 15:09:49.992055+00	4	1	482
1779	2023-02-11 15:09:49.993836+00	2023-02-11 15:09:49.993855+00	4	2	482
1780	2023-02-11 15:09:49.995806+00	2023-02-11 15:09:49.995826+00	2	3	482
1781	2023-02-11 15:09:49.997753+00	2023-02-11 15:09:49.997775+00	2	4	482
1782	2023-02-11 15:09:50.200318+00	2023-02-11 15:09:50.200346+00	4	1	483
1783	2023-02-11 15:09:50.203043+00	2023-02-11 15:09:50.203064+00	4	2	483
1784	2023-02-11 15:09:50.205247+00	2023-02-11 15:09:50.205266+00	4	3	483
1785	2023-02-11 15:09:50.207606+00	2023-02-11 15:09:50.207624+00	4	4	483
1786	2023-02-11 15:09:50.43187+00	2023-02-11 15:09:50.431893+00	3	1	484
1787	2023-02-11 15:09:50.434896+00	2023-02-11 15:09:50.434958+00	3	2	484
1788	2023-02-11 15:09:50.437535+00	2023-02-11 15:09:50.437554+00	3	3	484
1789	2023-02-11 15:09:50.439772+00	2023-02-11 15:09:50.439803+00	3	4	484
1790	2023-02-11 15:09:50.664239+00	2023-02-11 15:09:50.664257+00	3	1	485
1791	2023-02-11 15:09:50.666182+00	2023-02-11 15:09:50.666202+00	2	2	485
1792	2023-02-11 15:09:50.66889+00	2023-02-11 15:09:50.668912+00	2	3	485
1793	2023-02-11 15:09:50.67113+00	2023-02-11 15:09:50.671151+00	2	4	485
1794	2023-02-11 15:09:50.849039+00	2023-02-11 15:09:50.849053+00	2	1	486
1795	2023-02-11 15:09:50.850895+00	2023-02-11 15:09:50.850923+00	1	2	486
1796	2023-02-11 15:09:50.853056+00	2023-02-11 15:09:50.853075+00	3	3	486
1797	2023-02-11 15:09:50.855044+00	2023-02-11 15:09:50.855062+00	1	4	486
1798	2023-02-11 15:09:51.017568+00	2023-02-11 15:09:51.017594+00	4	1	487
1799	2023-02-11 15:09:51.019882+00	2023-02-11 15:09:51.019899+00	4	2	487
1800	2023-02-11 15:09:51.021571+00	2023-02-11 15:09:51.021588+00	4	3	487
1801	2023-02-11 15:09:51.023552+00	2023-02-11 15:09:51.023568+00	2	4	487
1802	2023-02-11 15:09:51.193255+00	2023-02-11 15:09:51.193271+00	4	1	488
1803	2023-02-11 15:09:51.194886+00	2023-02-11 15:09:51.1949+00	2	2	488
1804	2023-02-11 15:09:51.196443+00	2023-02-11 15:09:51.196456+00	3	3	488
1805	2023-02-11 15:09:51.197925+00	2023-02-11 15:09:51.197938+00	1	4	488
1806	2023-02-11 15:09:51.363846+00	2023-02-11 15:09:51.36386+00	4	1	489
1807	2023-02-11 15:09:51.365486+00	2023-02-11 15:09:51.365499+00	3	2	489
1808	2023-02-11 15:09:51.36743+00	2023-02-11 15:09:51.367467+00	4	3	489
1809	2023-02-11 15:09:51.369851+00	2023-02-11 15:09:51.369869+00	4	4	489
1810	2023-02-11 15:09:51.525314+00	2023-02-11 15:09:51.525327+00	4	1	490
1811	2023-02-11 15:09:51.526817+00	2023-02-11 15:09:51.526829+00	3	2	490
1812	2023-02-11 15:09:51.528214+00	2023-02-11 15:09:51.528226+00	1	3	490
1813	2023-02-11 15:09:51.529563+00	2023-02-11 15:09:51.529576+00	1	4	490
1814	2023-02-11 15:09:51.738958+00	2023-02-11 15:09:51.738977+00	3	1	491
1815	2023-02-11 15:09:51.741458+00	2023-02-11 15:09:51.741476+00	2	2	491
1816	2023-02-11 15:09:51.743865+00	2023-02-11 15:09:51.74391+00	2	3	491
1817	2023-02-11 15:09:51.746391+00	2023-02-11 15:09:51.746418+00	3	4	491
1818	2023-02-11 15:09:51.975014+00	2023-02-11 15:09:51.975036+00	4	1	492
1819	2023-02-11 15:09:51.977411+00	2023-02-11 15:09:51.977431+00	1	2	492
1820	2023-02-11 15:09:51.979744+00	2023-02-11 15:09:51.979763+00	4	3	492
1821	2023-02-11 15:09:51.981866+00	2023-02-11 15:09:51.981911+00	1	4	492
1822	2023-02-11 15:09:52.189498+00	2023-02-11 15:09:52.189517+00	2	1	493
1823	2023-02-11 15:09:52.1916+00	2023-02-11 15:09:52.191618+00	3	2	493
1824	2023-02-11 15:09:52.193773+00	2023-02-11 15:09:52.193792+00	3	3	493
1825	2023-02-11 15:09:52.195918+00	2023-02-11 15:09:52.195937+00	1	4	493
1826	2023-02-11 15:09:52.404745+00	2023-02-11 15:09:52.404765+00	4	1	494
1827	2023-02-11 15:09:52.406787+00	2023-02-11 15:09:52.406806+00	3	2	494
1828	2023-02-11 15:09:52.408747+00	2023-02-11 15:09:52.408766+00	3	3	494
1829	2023-02-11 15:09:52.410825+00	2023-02-11 15:09:52.410845+00	1	4	494
\.


--
-- Data for Name: employee_sthstageknwoledgelevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_sthstageknwoledgelevel (id, created_at, modified_at, knwoledge_level_id, stage_id, employee_id) FROM stdin;
1821	2023-02-11 15:09:46.229069+00	2023-02-11 15:09:46.229084+00	3	1	465
1822	2023-02-11 15:09:46.231319+00	2023-02-11 15:09:46.231335+00	2	2	465
1823	2023-02-11 15:09:46.23329+00	2023-02-11 15:09:46.233305+00	2	3	465
1824	2023-02-11 15:09:46.235563+00	2023-02-11 15:09:46.235588+00	2	4	465
1825	2023-02-11 15:09:46.439438+00	2023-02-11 15:09:46.439456+00	3	1	466
1826	2023-02-11 15:09:46.441492+00	2023-02-11 15:09:46.441509+00	3	2	466
1827	2023-02-11 15:09:46.443345+00	2023-02-11 15:09:46.443359+00	3	3	466
1828	2023-02-11 15:09:46.445225+00	2023-02-11 15:09:46.44524+00	2	4	466
1829	2023-02-11 15:09:46.644867+00	2023-02-11 15:09:46.644885+00	3	1	467
1830	2023-02-11 15:09:46.646691+00	2023-02-11 15:09:46.646705+00	3	2	467
1831	2023-02-11 15:09:46.648497+00	2023-02-11 15:09:46.648516+00	3	3	467
1832	2023-02-11 15:09:46.650912+00	2023-02-11 15:09:46.650951+00	2	4	467
1833	2023-02-11 15:09:46.8877+00	2023-02-11 15:09:46.887719+00	4	1	468
1834	2023-02-11 15:09:46.889929+00	2023-02-11 15:09:46.889948+00	4	2	468
1835	2023-02-11 15:09:46.892164+00	2023-02-11 15:09:46.892184+00	4	3	468
1836	2023-02-11 15:09:46.894302+00	2023-02-11 15:09:46.894346+00	3	4	468
1837	2023-02-11 15:09:47.115867+00	2023-02-11 15:09:47.115887+00	4	1	469
1838	2023-02-11 15:09:47.118921+00	2023-02-11 15:09:47.118949+00	4	2	469
1839	2023-02-11 15:09:47.121707+00	2023-02-11 15:09:47.121732+00	4	3	469
1840	2023-02-11 15:09:47.124255+00	2023-02-11 15:09:47.124283+00	3	4	469
1841	2023-02-11 15:09:47.343944+00	2023-02-11 15:09:47.343965+00	3	1	470
1842	2023-02-11 15:09:47.346245+00	2023-02-11 15:09:47.346264+00	4	2	470
1843	2023-02-11 15:09:47.348303+00	2023-02-11 15:09:47.348323+00	4	3	470
1844	2023-02-11 15:09:47.350568+00	2023-02-11 15:09:47.350596+00	3	4	470
1845	2023-02-11 15:09:47.559911+00	2023-02-11 15:09:47.559931+00	4	1	471
1846	2023-02-11 15:09:47.561865+00	2023-02-11 15:09:47.561884+00	4	2	471
1847	2023-02-11 15:09:47.563977+00	2023-02-11 15:09:47.563995+00	4	3	471
1848	2023-02-11 15:09:47.566143+00	2023-02-11 15:09:47.566162+00	3	4	471
1849	2023-02-11 15:09:47.772692+00	2023-02-11 15:09:47.772712+00	4	1	472
1850	2023-02-11 15:09:47.774924+00	2023-02-11 15:09:47.774942+00	4	2	472
1851	2023-02-11 15:09:47.777112+00	2023-02-11 15:09:47.77713+00	4	3	472
1852	2023-02-11 15:09:47.779326+00	2023-02-11 15:09:47.779344+00	4	4	472
1853	2023-02-11 15:09:47.991853+00	2023-02-11 15:09:47.991873+00	3	1	473
1854	2023-02-11 15:09:47.993963+00	2023-02-11 15:09:47.993982+00	4	2	473
1855	2023-02-11 15:09:47.995924+00	2023-02-11 15:09:47.995943+00	2	3	473
1856	2023-02-11 15:09:47.998054+00	2023-02-11 15:09:47.998074+00	3	4	473
1857	2023-02-11 15:09:48.207084+00	2023-02-11 15:09:48.207103+00	4	1	474
1858	2023-02-11 15:09:48.209091+00	2023-02-11 15:09:48.209111+00	3	2	474
1859	2023-02-11 15:09:48.211356+00	2023-02-11 15:09:48.211375+00	3	3	474
1860	2023-02-11 15:09:48.213389+00	2023-02-11 15:09:48.213409+00	3	4	474
1861	2023-02-11 15:09:48.437458+00	2023-02-11 15:09:48.437479+00	4	1	475
1862	2023-02-11 15:09:48.439691+00	2023-02-11 15:09:48.439711+00	4	2	475
1863	2023-02-11 15:09:48.441819+00	2023-02-11 15:09:48.441838+00	4	3	475
1864	2023-02-11 15:09:48.444203+00	2023-02-11 15:09:48.444223+00	4	4	475
1865	2023-02-11 15:09:48.655834+00	2023-02-11 15:09:48.655853+00	4	1	476
1866	2023-02-11 15:09:48.657886+00	2023-02-11 15:09:48.657928+00	4	2	476
1867	2023-02-11 15:09:48.660067+00	2023-02-11 15:09:48.660085+00	4	3	476
1868	2023-02-11 15:09:48.661952+00	2023-02-11 15:09:48.661972+00	4	4	476
1869	2023-02-11 15:09:48.86641+00	2023-02-11 15:09:48.866429+00	3	1	477
1870	2023-02-11 15:09:48.869527+00	2023-02-11 15:09:48.869548+00	3	2	477
1871	2023-02-11 15:09:48.872014+00	2023-02-11 15:09:48.872035+00	3	3	477
1872	2023-02-11 15:09:48.874183+00	2023-02-11 15:09:48.874202+00	3	4	477
1873	2023-02-11 15:09:49.094695+00	2023-02-11 15:09:49.094714+00	3	1	478
1874	2023-02-11 15:09:49.096893+00	2023-02-11 15:09:49.096912+00	3	2	478
1875	2023-02-11 15:09:49.099453+00	2023-02-11 15:09:49.09948+00	3	3	478
1876	2023-02-11 15:09:49.10248+00	2023-02-11 15:09:49.102499+00	1	4	478
1877	2023-02-11 15:09:49.316813+00	2023-02-11 15:09:49.316837+00	1	1	479
1878	2023-02-11 15:09:49.31961+00	2023-02-11 15:09:49.319634+00	1	2	479
1879	2023-02-11 15:09:49.321991+00	2023-02-11 15:09:49.322009+00	2	3	479
1880	2023-02-11 15:09:49.32405+00	2023-02-11 15:09:49.324068+00	2	4	479
1881	2023-02-11 15:09:49.537001+00	2023-02-11 15:09:49.537021+00	4	1	480
1882	2023-02-11 15:09:49.539075+00	2023-02-11 15:09:49.539093+00	3	2	480
1883	2023-02-11 15:09:49.54107+00	2023-02-11 15:09:49.54109+00	4	3	480
1884	2023-02-11 15:09:49.543299+00	2023-02-11 15:09:49.543317+00	3	4	480
1885	2023-02-11 15:09:49.747922+00	2023-02-11 15:09:49.74794+00	4	1	481
1886	2023-02-11 15:09:49.749921+00	2023-02-11 15:09:49.749939+00	3	2	481
1887	2023-02-11 15:09:49.752674+00	2023-02-11 15:09:49.752694+00	3	3	481
1888	2023-02-11 15:09:49.754738+00	2023-02-11 15:09:49.754767+00	3	4	481
1889	2023-02-11 15:09:49.983081+00	2023-02-11 15:09:49.9831+00	4	1	482
1890	2023-02-11 15:09:49.985952+00	2023-02-11 15:09:49.985972+00	4	2	482
1891	2023-02-11 15:09:49.987962+00	2023-02-11 15:09:49.98798+00	2	3	482
1892	2023-02-11 15:09:49.990056+00	2023-02-11 15:09:49.990075+00	2	4	482
1893	2023-02-11 15:09:50.191489+00	2023-02-11 15:09:50.191507+00	4	1	483
1894	2023-02-11 15:09:50.193675+00	2023-02-11 15:09:50.193695+00	4	2	483
1895	2023-02-11 15:09:50.195658+00	2023-02-11 15:09:50.195676+00	4	3	483
1896	2023-02-11 15:09:50.197841+00	2023-02-11 15:09:50.197859+00	4	4	483
1897	2023-02-11 15:09:50.422268+00	2023-02-11 15:09:50.422295+00	3	1	484
1898	2023-02-11 15:09:50.424633+00	2023-02-11 15:09:50.424663+00	4	2	484
1899	2023-02-11 15:09:50.427198+00	2023-02-11 15:09:50.427218+00	4	3	484
1900	2023-02-11 15:09:50.429495+00	2023-02-11 15:09:50.429518+00	4	4	484
1901	2023-02-11 15:09:50.656286+00	2023-02-11 15:09:50.656307+00	3	1	485
1902	2023-02-11 15:09:50.658306+00	2023-02-11 15:09:50.658327+00	2	2	485
1903	2023-02-11 15:09:50.660173+00	2023-02-11 15:09:50.660193+00	2	3	485
1904	2023-02-11 15:09:50.662185+00	2023-02-11 15:09:50.662203+00	2	4	485
1905	2023-02-11 15:09:50.841706+00	2023-02-11 15:09:50.841726+00	3	1	486
1906	2023-02-11 15:09:50.843647+00	2023-02-11 15:09:50.843664+00	3	2	486
1907	2023-02-11 15:09:50.845571+00	2023-02-11 15:09:50.845586+00	4	3	486
1908	2023-02-11 15:09:50.847326+00	2023-02-11 15:09:50.84734+00	3	4	486
1909	2023-02-11 15:09:51.011036+00	2023-02-11 15:09:51.011049+00	3	1	487
1910	2023-02-11 15:09:51.01262+00	2023-02-11 15:09:51.012634+00	2	2	487
1911	2023-02-11 15:09:51.014184+00	2023-02-11 15:09:51.014198+00	2	3	487
1912	2023-02-11 15:09:51.01574+00	2023-02-11 15:09:51.015755+00	1	4	487
1913	2023-02-11 15:09:51.185712+00	2023-02-11 15:09:51.18573+00	3	1	488
1914	2023-02-11 15:09:51.187684+00	2023-02-11 15:09:51.187703+00	2	2	488
1915	2023-02-11 15:09:51.189485+00	2023-02-11 15:09:51.189498+00	3	3	488
1916	2023-02-11 15:09:51.19139+00	2023-02-11 15:09:51.191406+00	1	4	488
1917	2023-02-11 15:09:51.356944+00	2023-02-11 15:09:51.356958+00	3	1	489
1918	2023-02-11 15:09:51.35861+00	2023-02-11 15:09:51.358623+00	3	2	489
1919	2023-02-11 15:09:51.360374+00	2023-02-11 15:09:51.360389+00	3	3	489
1920	2023-02-11 15:09:51.362162+00	2023-02-11 15:09:51.362177+00	3	4	489
1921	2023-02-11 15:09:51.519101+00	2023-02-11 15:09:51.519119+00	3	1	490
1922	2023-02-11 15:09:51.520813+00	2023-02-11 15:09:51.520826+00	3	2	490
1923	2023-02-11 15:09:51.522362+00	2023-02-11 15:09:51.522376+00	2	3	490
1924	2023-02-11 15:09:51.523776+00	2023-02-11 15:09:51.523788+00	1	4	490
1925	2023-02-11 15:09:51.72859+00	2023-02-11 15:09:51.728631+00	3	1	491
1926	2023-02-11 15:09:51.731064+00	2023-02-11 15:09:51.731083+00	3	2	491
1927	2023-02-11 15:09:51.733361+00	2023-02-11 15:09:51.733391+00	3	3	491
1928	2023-02-11 15:09:51.736491+00	2023-02-11 15:09:51.73651+00	3	4	491
1929	2023-02-11 15:09:51.965327+00	2023-02-11 15:09:51.965347+00	4	1	492
1930	2023-02-11 15:09:51.968153+00	2023-02-11 15:09:51.968211+00	1	2	492
1931	2023-02-11 15:09:51.970676+00	2023-02-11 15:09:51.9707+00	4	3	492
1932	2023-02-11 15:09:51.972788+00	2023-02-11 15:09:51.972807+00	1	4	492
1933	2023-02-11 15:09:52.180387+00	2023-02-11 15:09:52.180408+00	3	1	493
1934	2023-02-11 15:09:52.182402+00	2023-02-11 15:09:52.182421+00	3	2	493
1935	2023-02-11 15:09:52.185192+00	2023-02-11 15:09:52.185212+00	3	3	493
1936	2023-02-11 15:09:52.18748+00	2023-02-11 15:09:52.1875+00	2	4	493
1937	2023-02-11 15:09:52.395771+00	2023-02-11 15:09:52.395791+00	2	1	494
1938	2023-02-11 15:09:52.397913+00	2023-02-11 15:09:52.397936+00	2	2	494
1939	2023-02-11 15:09:52.399814+00	2023-02-11 15:09:52.399832+00	2	3	494
1940	2023-02-11 15:09:52.402542+00	2023-02-11 15:09:52.402568+00	2	4	494
\.


--
-- Data for Name: employee_team; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_team (id, created_at, modified_at, name, description, organization_id, responsible_id) FROM stdin;
\.


--
-- Data for Name: organization_organization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_organization (id, created_at, modified_at, name, description, age, location_id, organization_size_id, organization_type_id) FROM stdin;
547	2023-02-11 15:09:46.213292+00	2023-02-11 15:09:46.21331+00	Org1	\N	1	8	1	2
548	2023-02-11 15:09:46.426407+00	2023-02-11 15:09:46.426421+00	Org2	\N	24	25	4	1
549	2023-02-11 15:09:46.629473+00	2023-02-11 15:09:46.629492+00	Org3	\N	4	8	2	2
550	2023-02-11 15:09:46.87277+00	2023-02-11 15:09:46.872789+00	Org4	\N	45	16	4	3
551	2023-02-11 15:09:47.099125+00	2023-02-11 15:09:47.099146+00	Org5	\N	48	14	4	1
552	2023-02-11 15:09:47.329027+00	2023-02-11 15:09:47.329052+00	Org6	\N	5	8	2	2
553	2023-02-11 15:09:47.545756+00	2023-02-11 15:09:47.545776+00	Org7	\N	3	25	2	2
554	2023-02-11 15:09:47.758781+00	2023-02-11 15:09:47.7588+00	Org8	\N	70	8	4	3
555	2023-02-11 15:09:47.977871+00	2023-02-11 15:09:47.977893+00	Org9	\N	3	8	1	2
556	2023-02-11 15:09:48.191448+00	2023-02-11 15:09:48.191467+00	Org10	\N	5	5	3	2
557	2023-02-11 15:09:48.422789+00	2023-02-11 15:09:48.422809+00	Org11	\N	26	14	2	1
558	2023-02-11 15:09:48.642049+00	2023-02-11 15:09:48.642068+00	Org12	\N	47	19	4	4
559	2023-02-11 15:09:48.85166+00	2023-02-11 15:09:48.851689+00	Org13	\N	79	8	4	3
560	2023-02-11 15:09:49.080207+00	2023-02-11 15:09:49.080224+00	Org14	\N	19	4	4	6
561	2023-02-11 15:09:49.303387+00	2023-02-11 15:09:49.303407+00	Org15	\N	112	8	4	7
562	2023-02-11 15:09:49.52297+00	2023-02-11 15:09:49.522988+00	Org16	\N	35	21	4	1
563	2023-02-11 15:09:49.732247+00	2023-02-11 15:09:49.732265+00	Org17	\N	6	25	4	5
564	2023-02-11 15:09:49.967613+00	2023-02-11 15:09:49.967651+00	Org18	\N	87	8	4	3
565	2023-02-11 15:09:50.177009+00	2023-02-11 15:09:50.177027+00	Org19	\N	13	13	4	8
566	2023-02-11 15:09:50.406483+00	2023-02-11 15:09:50.406502+00	Org20	\N	80	8	4	3
567	2023-02-11 15:09:50.642342+00	2023-02-11 15:09:50.642365+00	Org21	\N	6	5	1	2
568	2023-02-11 15:09:50.827339+00	2023-02-11 15:09:50.827356+00	Org22	\N	40	16	4	3
569	2023-02-11 15:09:50.999865+00	2023-02-11 15:09:50.999879+00	Org23	\N	49	13	4	3
570	2023-02-11 15:09:51.174012+00	2023-02-11 15:09:51.174025+00	Org24	\N	21	8	2	5
571	2023-02-11 15:09:51.34482+00	2023-02-11 15:09:51.344834+00	Org25	\N	2	13	3	2
572	2023-02-11 15:09:51.508699+00	2023-02-11 15:09:51.508713+00	Org26	\N	38	13	4	9
573	2023-02-11 15:09:51.708813+00	2023-02-11 15:09:51.708832+00	Org27	\N	56	10	3	10
574	2023-02-11 15:09:51.951236+00	2023-02-11 15:09:51.951257+00	Org28	\N	29	8	4	1
575	2023-02-11 15:09:52.165411+00	2023-02-11 15:09:52.165437+00	Org29	\N	30	12	4	1
576	2023-02-11 15:09:52.38214+00	2023-02-11 15:09:52.38216+00	Org30	\N	6	12	4	3
\.


--
-- Data for Name: organization_organizationcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_organizationcategory (id, created_at, modified_at, name) FROM stdin;
1	2022-04-22 21:21:59.018773+00	2022-04-22 21:21:59.018793+00	Startup
2	2022-04-22 21:22:18.618872+00	2022-04-22 21:22:18.6189+00	Fábrica de Software
3	2022-04-22 21:22:28.273369+00	2022-04-22 21:22:28.273391+00	Empresa com departamento de TI
\.


--
-- Data for Name: organization_organizationtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_organizationtype (id, created_at, modified_at, name, description, category_id) FROM stdin;
6	2022-04-21 14:35:02.696396+00	2022-04-21 14:35:02.69642+00	Instituto de P&D com vários departamentos de TI	Instituto de P&D com vários departamentos de TI	\N
7	2022-04-21 14:35:02.697218+00	2022-04-21 14:35:02.697239+00	Instituto Federal de Educação	Instituto Federal de Educação	\N
1	2022-04-20 23:00:22.259029+00	2022-04-22 21:23:02.644349+00	Fábrica de Software	Fábrica de Software	2
9	2022-04-21 14:35:02.698488+00	2022-04-22 21:23:11.142205+00	Empresa de serviços e consultoria de TI (Sustentação de infraestrutura e aplicações, desenvolvimento de projetos e etc)	Empresa de serviços e consultoria de TI (Sustentação de infraestrutura e aplicações, desenvolvimento de projetos e etc)	3
5	2022-04-20 23:00:50.900437+00	2022-04-22 21:23:18.790543+00	Empresa em que um único produto de software representa o negócio (ex., PicPay, Airbnb, Uber)	Empresa em que um único produto de software representa o negócio (ex., PicPay, Airbnb, Uber)	1
3	2022-04-20 23:00:35.996604+00	2022-04-22 21:23:26.989794+00	Empresa Privada com departamento de TI	Empresa Privada com departamento de TI	3
8	2022-04-21 14:35:02.697863+00	2022-04-22 21:23:36.881213+00	Empresa Privada com foco em inovação e tranformação digital - business agility	Empresa Privada com foco em inovação e tranformação digital - business agility	2
4	2022-04-20 23:00:42.560901+00	2022-04-22 21:23:43.8582+00	Empresa Pública com departamento de TI	Empresa Pública com departamento de TI	3
10	2022-04-21 14:35:02.699162+00	2022-04-22 21:23:51.197254+00	Fundação Pública com departamento de TI	Fundação Pública com departamento de TI	3
2	2022-04-20 23:00:29.090967+00	2022-04-22 21:24:00.057983+00	Startup	Startup	1
\.


--
-- Data for Name: organization_region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_region (id, created_at, modified_at, name) FROM stdin;
1	2022-04-20 23:12:04.966724+00	2022-04-20 23:12:04.966793+00	Norte
2	2022-04-20 23:12:12.313261+00	2022-04-20 23:12:12.31333+00	Nordeste
3	2022-04-20 23:12:56.06962+00	2022-04-20 23:12:56.069644+00	Sudeste
4	2022-04-20 23:12:59.381085+00	2022-04-20 23:12:59.381127+00	Sul
5	2022-04-20 23:13:14.917417+00	2022-04-20 23:13:14.91744+00	Centro-Oeste
\.


--
-- Data for Name: organization_size; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_size (id, created_at, modified_at, name) FROM stdin;
1	2022-04-20 23:05:54.354629+00	2022-04-20 23:05:54.354662+00	01 a 09 funcionários
2	2022-04-20 23:06:00.828001+00	2022-04-20 23:06:00.828078+00	10 a 49 funcionários
3	2022-04-20 23:06:06.242424+00	2022-04-20 23:06:06.242447+00	50 a 99 funcionários
4	2022-04-20 23:06:12.575513+00	2022-04-20 23:06:12.575561+00	Mais de 99 funcionários
\.


--
-- Data for Name: organization_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization_state (id, created_at, modified_at, name, latitude, longitude, region_id) FROM stdin;
1	2022-04-20 23:13:43.878115+00	2022-04-22 21:04:08.085495+00	Acre	\N	\N	1
4	2022-04-20 23:14:11.951241+00	2022-04-22 21:04:25.517729+00	Amazonas	\N	\N	1
3	2022-04-20 23:14:05.848806+00	2022-04-22 21:04:40.916604+00	Amapá	\N	\N	1
14	2022-04-20 23:15:15.053669+00	2022-04-22 21:05:48.985374+00	Pará	\N	\N	1
22	2022-04-20 23:16:03.836167+00	2022-04-22 21:06:20.538535+00	Rondônia	\N	\N	1
23	2022-04-20 23:16:09.855313+00	2022-04-22 21:06:34.309553+00	Roraima	\N	\N	1
27	2022-04-20 23:16:34.184603+00	2022-04-22 21:06:41.005806+00	Tocantins	\N	\N	1
2	2022-04-20 23:13:56.76093+00	2022-04-22 21:07:35.489987+00	Alagoas	\N	\N	2
5	2022-04-20 23:14:18.534782+00	2022-04-22 21:07:48.991206+00	Bahia	\N	\N	2
6	2022-04-20 23:14:28.113602+00	2022-04-22 21:07:58.155129+00	Ceará	\N	\N	2
10	2022-04-20 23:14:52.644386+00	2022-04-22 21:08:55.464515+00	Maranhão	\N	\N	2
18	2022-04-20 23:15:37.376833+00	2022-04-22 21:09:11.894891+00	Piauí	\N	\N	2
17	2022-04-20 23:15:31.953199+00	2022-04-22 21:09:29.219171+00	Pernambuco	\N	\N	2
15	2022-04-20 23:15:21.43983+00	2022-04-22 21:09:46.641998+00	Paraíba	\N	\N	2
20	2022-04-20 23:15:49.603402+00	2022-04-22 21:10:00.867859+00	Rio Grande do Norte	\N	\N	2
26	2022-04-20 23:16:26.36059+00	2022-04-22 21:10:11.480806+00	Sergipe	\N	\N	2
16	2022-04-20 23:15:26.828367+00	2022-04-22 21:13:59.375202+00	Paraná	\N	\N	4
21	2022-04-20 23:15:56.508899+00	2022-04-22 21:14:14.154944+00	Rio Grande do Sul	\N	\N	4
24	2022-04-20 23:16:15.621209+00	2022-04-22 21:14:28.361793+00	Santa Catarina	\N	\N	4
8	2022-04-20 23:14:40.422684+00	2022-04-22 21:14:37.809648+00	Espírito Santo	\N	\N	3
19	2022-04-20 23:15:43.36376+00	2022-04-22 21:14:49.042306+00	Rio de Janeiro	\N	\N	3
13	2022-04-20 23:15:09.106164+00	2022-04-22 21:14:58.627371+00	Minas Gerais	\N	\N	3
25	2022-04-20 23:16:20.914589+00	2022-04-22 21:15:07.315538+00	São Paulo	\N	\N	3
7	2022-04-20 23:14:34.604776+00	2022-04-22 21:15:15.531044+00	Distrito Federal	\N	\N	5
9	2022-04-20 23:14:46.216976+00	2022-04-22 21:15:22.578089+00	Goiás	\N	\N	5
11	2022-04-20 23:14:58.575702+00	2022-04-22 21:15:51.115087+00	Mato Grosso	\N	\N	5
12	2022-04-20 23:15:03.782989+00	2022-04-22 21:15:59.761641+00	Mato Grosso do Sul	\N	\N	5
\.


--
-- Data for Name: practitioners_eye_dimension; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.practitioners_eye_dimension (id, created_at, modified_at, name, description) FROM stdin;
1	2022-04-20 23:40:13.708816+00	2022-04-20 23:40:13.708839+00	Development	Development
2	2022-04-20 23:40:20.410295+00	2022-04-20 23:40:20.410319+00	Quality	Quality
3	2022-04-20 23:40:28.195885+00	2022-04-20 23:40:28.195909+00	Software Management	Software Management
4	2022-04-20 23:40:34.350974+00	2022-04-20 23:40:34.350999+00	Team	Team
5	2022-04-20 23:40:40.119358+00	2022-04-20 23:40:40.119382+00	Technical Solution	Technical Solution
6	2022-04-20 23:40:45.426826+00	2022-04-20 23:40:45.426849+00	Knowledge	Knowledge
7	2022-04-20 23:40:51.555982+00	2022-04-20 23:40:51.556029+00	Operation	Operation
8	2022-04-20 23:40:57.760983+00	2022-04-20 23:40:57.761047+00	Business	Business
9	2022-04-20 23:41:03.300163+00	2022-04-20 23:41:03.300213+00	User/Customer	User/Customer
\.


--
-- Data for Name: practitioners_eye_element; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.practitioners_eye_element (id, created_at, modified_at, name, description, dimension_id) FROM stdin;
1	2022-04-20 23:41:33.39692+00	2022-04-20 23:41:33.396944+00	Code coverage	Code coverage	1
2	2022-04-20 23:41:42.004047+00	2022-04-20 23:41:42.004068+00	Continuous planning activities	Continuous planning activities	1
3	2022-04-20 23:41:50.164055+00	2022-04-20 23:41:50.164078+00	Continuous requirements engineering	Continuous requirements engineering	1
4	2022-04-20 23:41:58.270933+00	2022-04-20 23:41:58.270961+00	Focus on Feature	Focus on Feature	1
5	2022-04-20 23:42:07.43381+00	2022-04-20 23:42:07.433843+00	Modularized archiitecture and design	Modularized archiitecture and design	1
6	2022-04-20 23:42:17.02729+00	2022-04-20 23:42:17.027349+00	Audits	Audits	2
7	2022-04-20 23:42:26.694386+00	2022-04-20 23:42:26.694413+00	Automated Tests	Automated Tests	2
8	2022-04-20 23:42:36.836246+00	2022-04-20 23:42:36.836315+00	Pull-Request	Pull-Request	2
9	2022-04-20 23:42:47.049619+00	2022-04-20 23:42:47.049649+00	Regular Builds	Regular Builds	2
10	2022-04-20 23:42:57.540991+00	2022-04-20 23:42:57.541021+00	Agile Practice	Agile Practice	3
11	2022-04-20 23:43:07.352889+00	2022-04-20 23:43:07.352923+00	Continuos delivery	Continuos delivery	3
12	2022-04-20 23:43:17.834747+00	2022-04-20 23:43:17.834779+00	Continuos deployment of releases	Continuos deployment of releases	3
13	2022-04-20 23:43:26.948283+00	2022-04-20 23:43:26.948311+00	Continuos integration of work	Continuos integration of work	3
14	2022-04-20 23:43:38.382736+00	2022-04-20 23:43:38.382786+00	Contemporay and continuously evolving skills	Contemporay and continuously evolving skills	4
15	2022-04-20 23:43:47.164364+00	2022-04-20 23:43:47.164388+00	Self-reflection and discipline	Self-reflection and discipline	4
16	2022-04-20 23:44:04.452819+00	2022-04-20 23:44:04.452842+00	Branching strategies	Branching strategies	5
17	2022-04-20 23:44:12.757273+00	2022-04-20 23:44:12.7573+00	Code review	Code review	5
18	2022-04-20 23:44:23.933301+00	2022-04-20 23:44:23.933323+00	Version control	Version control	5
19	2022-04-20 23:44:33.649774+00	2022-04-20 23:44:33.649797+00	Capturing decisions and rationale	Capturing decisions and rationale	6
20	2022-04-20 23:44:43.782136+00	2022-04-20 23:44:43.782159+00	Continuos learning	Continuos learning	6
21	2022-04-20 23:44:53.969869+00	2022-04-20 23:44:53.969905+00	Sharing Knowledge	Sharing Knowledge	6
22	2022-04-20 23:45:06.382745+00	2022-04-20 23:45:06.382776+00	Logging and monitoring	Logging and monitoring	7
23	2022-04-20 23:45:15.92758+00	2022-04-20 23:45:15.927609+00	Reusable infrastructure	Reusable infrastructure	7
24	2022-04-20 23:45:24.091656+00	2022-04-20 23:45:24.09168+00	Appropriate product ideia	Appropriate product ideia	8
25	2022-04-20 23:45:32.063359+00	2022-04-20 23:45:32.063384+00	Management commitement	Management commitement	8
26	2022-04-20 23:45:41.736644+00	2022-04-20 23:45:41.736673+00	Involved users other stakeholders	Involved users other stakeholders	9
27	2022-04-20 23:45:51.457784+00	2022-04-20 23:45:51.457808+00	Learning from usage data and feedback	Learning from usage data and feedback	9
28	2022-04-20 23:46:00.247353+00	2022-04-20 23:46:00.247377+00	Proactive customers	Proactive customers	9
\.


--
-- Data for Name: questionnaire_adoptedlevel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questionnaire_adoptedlevel (id, created_at, modified_at, name, description, percentage) FROM stdin;
1	2022-04-20 22:45:34.308744+00	2022-04-20 22:45:34.308822+00	Não adotada	A prática nunca foi dotada na organização.	0
2	2022-04-20 22:46:07.150748+00	2022-04-20 22:46:07.150771+00	Abandonada	A prática já foi realizada na organização, mas deixou de ser realizada.	10
4	2022-04-20 22:47:04.03593+00	2022-04-20 22:47:04.035957+00	Realizada no nível de processo	A prática é claramente definida na organização e é adotada de maneira consistente em vários  projetos ou produtos.	60
3	2022-04-20 22:46:38.049946+00	2023-02-11 15:00:37.303289+00	Realizada no nível de projeto/produto	A prática é adotada no contexto de algum projeto ou produto específico.	30
5	2022-04-20 22:47:34.233143+00	2023-02-11 15:00:55.625591+00	Institucionalizada	A prática é claramente definida na organização e é adotada de maneira consistente em todos os  projetos ou produtos em que se aplica.	100
\.


--
-- Data for Name: questionnaire_answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questionnaire_answer (id, created_at, modified_at, comment, adopted_level_id, questionnaire_id, statement_id, organization_id) FROM stdin;
11881	2023-02-11 15:09:46.249565+00	2023-02-11 15:09:46.249582+00		3	\N	1	547
11882	2023-02-11 15:09:46.252431+00	2023-02-11 15:09:46.252457+00		3	\N	2	547
11883	2023-02-11 15:09:46.255045+00	2023-02-11 15:09:46.255068+00		3	\N	3	547
11884	2023-02-11 15:09:46.257544+00	2023-02-11 15:09:46.257565+00		3	\N	4	547
11885	2023-02-11 15:09:46.259683+00	2023-02-11 15:09:46.259705+00		4	\N	5	547
11886	2023-02-11 15:09:46.262552+00	2023-02-11 15:09:46.262573+00		1	\N	6	547
11887	2023-02-11 15:09:46.26492+00	2023-02-11 15:09:46.264939+00		1	\N	7	547
11888	2023-02-11 15:09:46.267448+00	2023-02-11 15:09:46.267474+00		3	\N	8	547
11889	2023-02-11 15:09:46.270427+00	2023-02-11 15:09:46.270453+00		1	\N	9	547
11890	2023-02-11 15:09:46.273405+00	2023-02-11 15:09:46.27343+00		3	\N	10	547
11891	2023-02-11 15:09:46.27587+00	2023-02-11 15:09:46.275894+00		4	\N	11	547
11892	2023-02-11 15:09:46.27843+00	2023-02-11 15:09:46.278447+00		1	\N	12	547
11893	2023-02-11 15:09:46.280814+00	2023-02-11 15:09:46.280846+00		3	\N	13	547
11894	2023-02-11 15:09:46.283368+00	2023-02-11 15:09:46.283393+00		3	\N	14	547
11895	2023-02-11 15:09:46.286683+00	2023-02-11 15:09:46.286711+00		3	\N	15	547
11896	2023-02-11 15:09:46.289562+00	2023-02-11 15:09:46.289581+00		4	\N	16	547
11897	2023-02-11 15:09:46.292013+00	2023-02-11 15:09:46.292029+00		1	\N	17	547
11898	2023-02-11 15:09:46.294449+00	2023-02-11 15:09:46.294469+00		1	\N	18	547
11899	2023-02-11 15:09:46.296822+00	2023-02-11 15:09:46.296841+00		3	\N	19	547
11900	2023-02-11 15:09:46.299359+00	2023-02-11 15:09:46.299382+00		1	\N	20	547
11901	2023-02-11 15:09:46.302394+00	2023-02-11 15:09:46.302415+00		1	\N	21	547
11902	2023-02-11 15:09:46.305217+00	2023-02-11 15:09:46.30524+00		1	\N	22	547
11903	2023-02-11 15:09:46.307533+00	2023-02-11 15:09:46.30755+00		1	\N	23	547
11904	2023-02-11 15:09:46.30999+00	2023-02-11 15:09:46.310036+00		1	\N	24	547
11905	2023-02-11 15:09:46.312434+00	2023-02-11 15:09:46.312453+00		1	\N	25	547
11906	2023-02-11 15:09:46.317616+00	2023-02-11 15:09:46.317643+00		3	\N	26	547
11907	2023-02-11 15:09:46.320915+00	2023-02-11 15:09:46.320935+00		3	\N	27	547
11908	2023-02-11 15:09:46.323655+00	2023-02-11 15:09:46.32368+00		3	\N	28	547
11909	2023-02-11 15:09:46.326397+00	2023-02-11 15:09:46.326416+00		3	\N	29	547
11910	2023-02-11 15:09:46.32935+00	2023-02-11 15:09:46.329379+00		1	\N	30	547
11911	2023-02-11 15:09:46.33204+00	2023-02-11 15:09:46.33207+00		1	\N	31	547
11912	2023-02-11 15:09:46.334913+00	2023-02-11 15:09:46.334943+00		1	\N	32	547
11913	2023-02-11 15:09:46.337742+00	2023-02-11 15:09:46.337761+00		1	\N	33	547
11914	2023-02-11 15:09:46.340266+00	2023-02-11 15:09:46.340282+00		3	\N	34	547
11915	2023-02-11 15:09:46.342694+00	2023-02-11 15:09:46.342712+00		1	\N	35	547
11916	2023-02-11 15:09:46.34513+00	2023-02-11 15:09:46.345149+00		1	\N	36	547
11917	2023-02-11 15:09:46.347363+00	2023-02-11 15:09:46.347386+00		1	\N	37	547
11918	2023-02-11 15:09:46.349445+00	2023-02-11 15:09:46.34946+00		1	\N	38	547
11919	2023-02-11 15:09:46.352131+00	2023-02-11 15:09:46.352151+00		1	\N	39	547
11920	2023-02-11 15:09:46.354738+00	2023-02-11 15:09:46.354757+00		1	\N	40	547
11921	2023-02-11 15:09:46.356805+00	2023-02-11 15:09:46.35682+00		1	\N	41	547
11922	2023-02-11 15:09:46.358818+00	2023-02-11 15:09:46.35884+00		4	\N	42	547
11923	2023-02-11 15:09:46.361268+00	2023-02-11 15:09:46.361296+00		1	\N	43	547
11924	2023-02-11 15:09:46.363361+00	2023-02-11 15:09:46.363377+00		1	\N	44	547
11925	2023-02-11 15:09:46.365261+00	2023-02-11 15:09:46.365277+00		3	\N	45	547
11926	2023-02-11 15:09:46.36737+00	2023-02-11 15:09:46.36739+00		1	\N	46	547
11927	2023-02-11 15:09:46.369858+00	2023-02-11 15:09:46.369876+00		1	\N	47	547
11928	2023-02-11 15:09:46.371805+00	2023-02-11 15:09:46.37182+00		1	\N	48	547
11929	2023-02-11 15:09:46.373612+00	2023-02-11 15:09:46.373627+00		4	\N	49	547
11930	2023-02-11 15:09:46.375811+00	2023-02-11 15:09:46.375838+00		1	\N	50	547
11931	2023-02-11 15:09:46.378022+00	2023-02-11 15:09:46.37804+00		1	\N	51	547
11932	2023-02-11 15:09:46.380246+00	2023-02-11 15:09:46.380263+00		3	\N	52	547
11933	2023-02-11 15:09:46.382369+00	2023-02-11 15:09:46.382387+00		1	\N	53	547
11934	2023-02-11 15:09:46.385066+00	2023-02-11 15:09:46.385085+00		1	\N	54	547
11935	2023-02-11 15:09:46.387548+00	2023-02-11 15:09:46.387566+00		1	\N	55	547
11936	2023-02-11 15:09:46.389736+00	2023-02-11 15:09:46.389753+00		1	\N	56	547
11937	2023-02-11 15:09:46.391924+00	2023-02-11 15:09:46.391943+00		1	\N	57	547
11938	2023-02-11 15:09:46.394317+00	2023-02-11 15:09:46.394334+00		1	\N	58	547
11939	2023-02-11 15:09:46.396437+00	2023-02-11 15:09:46.396454+00		1	\N	59	547
11940	2023-02-11 15:09:46.398758+00	2023-02-11 15:09:46.398775+00		1	\N	60	547
11941	2023-02-11 15:09:46.40127+00	2023-02-11 15:09:46.401297+00		1	\N	61	547
11942	2023-02-11 15:09:46.403972+00	2023-02-11 15:09:46.40399+00		1	\N	62	547
11943	2023-02-11 15:09:46.406491+00	2023-02-11 15:09:46.406509+00		1	\N	63	547
11944	2023-02-11 15:09:46.4089+00	2023-02-11 15:09:46.408919+00		3	\N	64	547
11945	2023-02-11 15:09:46.411036+00	2023-02-11 15:09:46.411052+00		3	\N	65	547
11946	2023-02-11 15:09:46.412945+00	2023-02-11 15:09:46.412961+00		1	\N	66	547
11947	2023-02-11 15:09:46.414874+00	2023-02-11 15:09:46.41489+00		1	\N	67	547
11948	2023-02-11 15:09:46.416838+00	2023-02-11 15:09:46.416856+00		1	\N	68	547
11949	2023-02-11 15:09:46.419417+00	2023-02-11 15:09:46.419441+00		1	\N	69	547
11950	2023-02-11 15:09:46.422036+00	2023-02-11 15:09:46.422059+00		1	\N	70	547
11951	2023-02-11 15:09:46.424354+00	2023-02-11 15:09:46.424372+00		1	\N	71	547
11952	2023-02-11 15:09:46.459745+00	2023-02-11 15:09:46.459761+00		5	\N	1	548
11953	2023-02-11 15:09:46.461791+00	2023-02-11 15:09:46.461806+00		5	\N	2	548
11954	2023-02-11 15:09:46.463828+00	2023-02-11 15:09:46.463844+00		5	\N	3	548
11955	2023-02-11 15:09:46.465701+00	2023-02-11 15:09:46.465715+00		5	\N	4	548
11956	2023-02-11 15:09:46.468212+00	2023-02-11 15:09:46.468258+00		5	\N	5	548
11957	2023-02-11 15:09:46.470561+00	2023-02-11 15:09:46.470578+00		5	\N	6	548
11958	2023-02-11 15:09:46.472552+00	2023-02-11 15:09:46.472571+00		3	\N	7	548
11959	2023-02-11 15:09:46.474429+00	2023-02-11 15:09:46.474446+00		5	\N	8	548
11960	2023-02-11 15:09:46.476323+00	2023-02-11 15:09:46.476338+00		5	\N	9	548
11961	2023-02-11 15:09:46.478131+00	2023-02-11 15:09:46.478145+00		5	\N	10	548
11962	2023-02-11 15:09:46.479842+00	2023-02-11 15:09:46.479857+00		5	\N	11	548
11963	2023-02-11 15:09:46.481762+00	2023-02-11 15:09:46.481787+00		5	\N	12	548
11964	2023-02-11 15:09:46.48441+00	2023-02-11 15:09:46.48449+00		5	\N	13	548
11965	2023-02-11 15:09:46.487182+00	2023-02-11 15:09:46.487201+00		3	\N	14	548
11966	2023-02-11 15:09:46.489693+00	2023-02-11 15:09:46.48971+00		5	\N	15	548
11967	2023-02-11 15:09:46.491766+00	2023-02-11 15:09:46.491782+00		5	\N	16	548
11968	2023-02-11 15:09:46.493784+00	2023-02-11 15:09:46.4938+00		5	\N	17	548
11969	2023-02-11 15:09:46.495697+00	2023-02-11 15:09:46.495733+00		5	\N	18	548
11970	2023-02-11 15:09:46.497943+00	2023-02-11 15:09:46.497967+00		5	\N	19	548
11971	2023-02-11 15:09:46.5+00	2023-02-11 15:09:46.500019+00		2	\N	20	548
11972	2023-02-11 15:09:46.502858+00	2023-02-11 15:09:46.502878+00		1	\N	21	548
11973	2023-02-11 15:09:46.505159+00	2023-02-11 15:09:46.505177+00		1	\N	22	548
11974	2023-02-11 15:09:46.507215+00	2023-02-11 15:09:46.50723+00		5	\N	23	548
11975	2023-02-11 15:09:46.509219+00	2023-02-11 15:09:46.509289+00		5	\N	24	548
11976	2023-02-11 15:09:46.511193+00	2023-02-11 15:09:46.511208+00		5	\N	25	548
11977	2023-02-11 15:09:46.513328+00	2023-02-11 15:09:46.513346+00		5	\N	26	548
11978	2023-02-11 15:09:46.515431+00	2023-02-11 15:09:46.515448+00		3	\N	27	548
11979	2023-02-11 15:09:46.517662+00	2023-02-11 15:09:46.517691+00		5	\N	28	548
11980	2023-02-11 15:09:46.520058+00	2023-02-11 15:09:46.520076+00		5	\N	29	548
11981	2023-02-11 15:09:46.522207+00	2023-02-11 15:09:46.522223+00		1	\N	30	548
11982	2023-02-11 15:09:46.524302+00	2023-02-11 15:09:46.524319+00		1	\N	31	548
11983	2023-02-11 15:09:46.526242+00	2023-02-11 15:09:46.526257+00		5	\N	32	548
11984	2023-02-11 15:09:46.528241+00	2023-02-11 15:09:46.528263+00		1	\N	33	548
11985	2023-02-11 15:09:46.531342+00	2023-02-11 15:09:46.53136+00		5	\N	34	548
11986	2023-02-11 15:09:46.533553+00	2023-02-11 15:09:46.533582+00		5	\N	35	548
11987	2023-02-11 15:09:46.536457+00	2023-02-11 15:09:46.536477+00		3	\N	36	548
11988	2023-02-11 15:09:46.538888+00	2023-02-11 15:09:46.538904+00		3	\N	37	548
11989	2023-02-11 15:09:46.540864+00	2023-02-11 15:09:46.540879+00		3	\N	38	548
11990	2023-02-11 15:09:46.542769+00	2023-02-11 15:09:46.542783+00		1	\N	39	548
11991	2023-02-11 15:09:46.545081+00	2023-02-11 15:09:46.545137+00		3	\N	40	548
11992	2023-02-11 15:09:46.547464+00	2023-02-11 15:09:46.547488+00		5	\N	41	548
11993	2023-02-11 15:09:46.549795+00	2023-02-11 15:09:46.549809+00		5	\N	42	548
11994	2023-02-11 15:09:46.552602+00	2023-02-11 15:09:46.55262+00		3	\N	43	548
11995	2023-02-11 15:09:46.554753+00	2023-02-11 15:09:46.554769+00		1	\N	44	548
11996	2023-02-11 15:09:46.557068+00	2023-02-11 15:09:46.557087+00		3	\N	45	548
11997	2023-02-11 15:09:46.559734+00	2023-02-11 15:09:46.559763+00		5	\N	46	548
11998	2023-02-11 15:09:46.562346+00	2023-02-11 15:09:46.562371+00		5	\N	47	548
11999	2023-02-11 15:09:46.56492+00	2023-02-11 15:09:46.564942+00		5	\N	48	548
12000	2023-02-11 15:09:46.567674+00	2023-02-11 15:09:46.567717+00		3	\N	49	548
12001	2023-02-11 15:09:46.571008+00	2023-02-11 15:09:46.571028+00		3	\N	50	548
12002	2023-02-11 15:09:46.573701+00	2023-02-11 15:09:46.57372+00		4	\N	51	548
12003	2023-02-11 15:09:46.576326+00	2023-02-11 15:09:46.576344+00		5	\N	52	548
12004	2023-02-11 15:09:46.578749+00	2023-02-11 15:09:46.578768+00		5	\N	53	548
12005	2023-02-11 15:09:46.581061+00	2023-02-11 15:09:46.581081+00		5	\N	54	548
12006	2023-02-11 15:09:46.583385+00	2023-02-11 15:09:46.583404+00		5	\N	55	548
12007	2023-02-11 15:09:46.586469+00	2023-02-11 15:09:46.586495+00		1	\N	56	548
12008	2023-02-11 15:09:46.589187+00	2023-02-11 15:09:46.589206+00		3	\N	57	548
12009	2023-02-11 15:09:46.59179+00	2023-02-11 15:09:46.59181+00		1	\N	58	548
12010	2023-02-11 15:09:46.594211+00	2023-02-11 15:09:46.594235+00		1	\N	59	548
12011	2023-02-11 15:09:46.59666+00	2023-02-11 15:09:46.596679+00		1	\N	60	548
12012	2023-02-11 15:09:46.599344+00	2023-02-11 15:09:46.599372+00		1	\N	61	548
12013	2023-02-11 15:09:46.602364+00	2023-02-11 15:09:46.602384+00		1	\N	62	548
12014	2023-02-11 15:09:46.605408+00	2023-02-11 15:09:46.605433+00		1	\N	63	548
12015	2023-02-11 15:09:46.608168+00	2023-02-11 15:09:46.608193+00		5	\N	64	548
12016	2023-02-11 15:09:46.610989+00	2023-02-11 15:09:46.611013+00		3	\N	65	548
12017	2023-02-11 15:09:46.613454+00	2023-02-11 15:09:46.613473+00		1	\N	66	548
12018	2023-02-11 15:09:46.616436+00	2023-02-11 15:09:46.616454+00		3	\N	67	548
12019	2023-02-11 15:09:46.619505+00	2023-02-11 15:09:46.619532+00		3	\N	68	548
12020	2023-02-11 15:09:46.622202+00	2023-02-11 15:09:46.622226+00		5	\N	69	548
12021	2023-02-11 15:09:46.62473+00	2023-02-11 15:09:46.624749+00		1	\N	70	548
12022	2023-02-11 15:09:46.627089+00	2023-02-11 15:09:46.627107+00		1	\N	71	548
12023	2023-02-11 15:09:46.669105+00	2023-02-11 15:09:46.669133+00		4	\N	1	549
12024	2023-02-11 15:09:46.671532+00	2023-02-11 15:09:46.671559+00		5	\N	2	549
12025	2023-02-11 15:09:46.674068+00	2023-02-11 15:09:46.674086+00		4	\N	3	549
12026	2023-02-11 15:09:46.676644+00	2023-02-11 15:09:46.676662+00		5	\N	4	549
12027	2023-02-11 15:09:46.679316+00	2023-02-11 15:09:46.67934+00		5	\N	5	549
12028	2023-02-11 15:09:46.681945+00	2023-02-11 15:09:46.681965+00		5	\N	6	549
12029	2023-02-11 15:09:46.686561+00	2023-02-11 15:09:46.686592+00		1	\N	7	549
12030	2023-02-11 15:09:46.689661+00	2023-02-11 15:09:46.689681+00		5	\N	8	549
12031	2023-02-11 15:09:46.692707+00	2023-02-11 15:09:46.692727+00		1	\N	9	549
12032	2023-02-11 15:09:46.695448+00	2023-02-11 15:09:46.695468+00		4	\N	10	549
12033	2023-02-11 15:09:46.698419+00	2023-02-11 15:09:46.698444+00		4	\N	11	549
12034	2023-02-11 15:09:46.701837+00	2023-02-11 15:09:46.701861+00		4	\N	12	549
12035	2023-02-11 15:09:46.705008+00	2023-02-11 15:09:46.705029+00		1	\N	13	549
12036	2023-02-11 15:09:46.707799+00	2023-02-11 15:09:46.707827+00		4	\N	14	549
12037	2023-02-11 15:09:46.710802+00	2023-02-11 15:09:46.710822+00		4	\N	15	549
12038	2023-02-11 15:09:46.713482+00	2023-02-11 15:09:46.713514+00		4	\N	16	549
12039	2023-02-11 15:09:46.716366+00	2023-02-11 15:09:46.716386+00		1	\N	17	549
12040	2023-02-11 15:09:46.719752+00	2023-02-11 15:09:46.719777+00		4	\N	18	549
12041	2023-02-11 15:09:46.722439+00	2023-02-11 15:09:46.722468+00		4	\N	19	549
12042	2023-02-11 15:09:46.72506+00	2023-02-11 15:09:46.72508+00		3	\N	20	549
12043	2023-02-11 15:09:46.727674+00	2023-02-11 15:09:46.727699+00		1	\N	21	549
12044	2023-02-11 15:09:46.73071+00	2023-02-11 15:09:46.73073+00		1	\N	22	549
12045	2023-02-11 15:09:46.733629+00	2023-02-11 15:09:46.733659+00		4	\N	23	549
12046	2023-02-11 15:09:46.737212+00	2023-02-11 15:09:46.737234+00		1	\N	24	549
12047	2023-02-11 15:09:46.73983+00	2023-02-11 15:09:46.739851+00		1	\N	25	549
12048	2023-02-11 15:09:46.742913+00	2023-02-11 15:09:46.742933+00		4	\N	26	549
12049	2023-02-11 15:09:46.745739+00	2023-02-11 15:09:46.745768+00		4	\N	27	549
12050	2023-02-11 15:09:46.748613+00	2023-02-11 15:09:46.748633+00		5	\N	28	549
12051	2023-02-11 15:09:46.752297+00	2023-02-11 15:09:46.752327+00		4	\N	29	549
12052	2023-02-11 15:09:46.755392+00	2023-02-11 15:09:46.755421+00		1	\N	30	549
12053	2023-02-11 15:09:46.758603+00	2023-02-11 15:09:46.758633+00		1	\N	31	549
12054	2023-02-11 15:09:46.761556+00	2023-02-11 15:09:46.761592+00		4	\N	32	549
12055	2023-02-11 15:09:46.764503+00	2023-02-11 15:09:46.76453+00		1	\N	33	549
12056	2023-02-11 15:09:46.767747+00	2023-02-11 15:09:46.767797+00		5	\N	34	549
12057	2023-02-11 15:09:46.771374+00	2023-02-11 15:09:46.771404+00		5	\N	35	549
12058	2023-02-11 15:09:46.774378+00	2023-02-11 15:09:46.774413+00		1	\N	36	549
12059	2023-02-11 15:09:46.77764+00	2023-02-11 15:09:46.77767+00		1	\N	37	549
12060	2023-02-11 15:09:46.780431+00	2023-02-11 15:09:46.780452+00		1	\N	38	549
12061	2023-02-11 15:09:46.783379+00	2023-02-11 15:09:46.7834+00		4	\N	39	549
12062	2023-02-11 15:09:46.786822+00	2023-02-11 15:09:46.786844+00		1	\N	40	549
12063	2023-02-11 15:09:46.789799+00	2023-02-11 15:09:46.789853+00		4	\N	41	549
12064	2023-02-11 15:09:46.792452+00	2023-02-11 15:09:46.792473+00		1	\N	42	549
12065	2023-02-11 15:09:46.795202+00	2023-02-11 15:09:46.795221+00		4	\N	43	549
12066	2023-02-11 15:09:46.797658+00	2023-02-11 15:09:46.797679+00		5	\N	44	549
12067	2023-02-11 15:09:46.800323+00	2023-02-11 15:09:46.800354+00		5	\N	45	549
12068	2023-02-11 15:09:46.803774+00	2023-02-11 15:09:46.803797+00		5	\N	46	549
12069	2023-02-11 15:09:46.80654+00	2023-02-11 15:09:46.80656+00		1	\N	47	549
12070	2023-02-11 15:09:46.808952+00	2023-02-11 15:09:46.808973+00		5	\N	48	549
12071	2023-02-11 15:09:46.811304+00	2023-02-11 15:09:46.811324+00		4	\N	49	549
12072	2023-02-11 15:09:46.813677+00	2023-02-11 15:09:46.813697+00		1	\N	50	549
12073	2023-02-11 15:09:46.816053+00	2023-02-11 15:09:46.816073+00		1	\N	51	549
12074	2023-02-11 15:09:46.819374+00	2023-02-11 15:09:46.8194+00		4	\N	52	549
12075	2023-02-11 15:09:46.822039+00	2023-02-11 15:09:46.822059+00		1	\N	53	549
12076	2023-02-11 15:09:46.824465+00	2023-02-11 15:09:46.824485+00		1	\N	54	549
12077	2023-02-11 15:09:46.826841+00	2023-02-11 15:09:46.82686+00		1	\N	55	549
12078	2023-02-11 15:09:46.82939+00	2023-02-11 15:09:46.829412+00		4	\N	56	549
12079	2023-02-11 15:09:46.831688+00	2023-02-11 15:09:46.83171+00		1	\N	57	549
12080	2023-02-11 15:09:46.834589+00	2023-02-11 15:09:46.834626+00		4	\N	58	549
12081	2023-02-11 15:09:46.837487+00	2023-02-11 15:09:46.837508+00		1	\N	59	549
12082	2023-02-11 15:09:46.83996+00	2023-02-11 15:09:46.839979+00		4	\N	60	549
12083	2023-02-11 15:09:46.84239+00	2023-02-11 15:09:46.842411+00		4	\N	61	549
12084	2023-02-11 15:09:46.844779+00	2023-02-11 15:09:46.844799+00		1	\N	62	549
12085	2023-02-11 15:09:46.847001+00	2023-02-11 15:09:46.847021+00		1	\N	63	549
12086	2023-02-11 15:09:46.849402+00	2023-02-11 15:09:46.849422+00		5	\N	64	549
12087	2023-02-11 15:09:46.854605+00	2023-02-11 15:09:46.854624+00		5	\N	65	549
12088	2023-02-11 15:09:46.856988+00	2023-02-11 15:09:46.857007+00		1	\N	66	549
12089	2023-02-11 15:09:46.85935+00	2023-02-11 15:09:46.859371+00		1	\N	67	549
12090	2023-02-11 15:09:46.86178+00	2023-02-11 15:09:46.861799+00		1	\N	68	549
12091	2023-02-11 15:09:46.864194+00	2023-02-11 15:09:46.864214+00		1	\N	69	549
12092	2023-02-11 15:09:46.866898+00	2023-02-11 15:09:46.866925+00		1	\N	70	549
12093	2023-02-11 15:09:46.870368+00	2023-02-11 15:09:46.870388+00		1	\N	71	549
12094	2023-02-11 15:09:46.911317+00	2023-02-11 15:09:46.911337+00		5	\N	1	550
12095	2023-02-11 15:09:46.913909+00	2023-02-11 15:09:46.913929+00		5	\N	2	550
12096	2023-02-11 15:09:46.916167+00	2023-02-11 15:09:46.916192+00		5	\N	3	550
12097	2023-02-11 15:09:46.919399+00	2023-02-11 15:09:46.919444+00		5	\N	4	550
12098	2023-02-11 15:09:46.922017+00	2023-02-11 15:09:46.922037+00		5	\N	5	550
12099	2023-02-11 15:09:46.924405+00	2023-02-11 15:09:46.924426+00		5	\N	6	550
12100	2023-02-11 15:09:46.926903+00	2023-02-11 15:09:46.926923+00		4	\N	7	550
12101	2023-02-11 15:09:46.92967+00	2023-02-11 15:09:46.929691+00		5	\N	8	550
12102	2023-02-11 15:09:46.932046+00	2023-02-11 15:09:46.932067+00		3	\N	9	550
12103	2023-02-11 15:09:46.935096+00	2023-02-11 15:09:46.935211+00		5	\N	10	550
12104	2023-02-11 15:09:46.937888+00	2023-02-11 15:09:46.937908+00		5	\N	11	550
12105	2023-02-11 15:09:46.940299+00	2023-02-11 15:09:46.940319+00		5	\N	12	550
12106	2023-02-11 15:09:46.942832+00	2023-02-11 15:09:46.942853+00		3	\N	13	550
12107	2023-02-11 15:09:46.945309+00	2023-02-11 15:09:46.945329+00		5	\N	14	550
12108	2023-02-11 15:09:46.947625+00	2023-02-11 15:09:46.947645+00		5	\N	15	550
12109	2023-02-11 15:09:46.950161+00	2023-02-11 15:09:46.950183+00		5	\N	16	550
12110	2023-02-11 15:09:46.953612+00	2023-02-11 15:09:46.953632+00		5	\N	17	550
12111	2023-02-11 15:09:46.95626+00	2023-02-11 15:09:46.956281+00		5	\N	18	550
12112	2023-02-11 15:09:46.959193+00	2023-02-11 15:09:46.959213+00		5	\N	19	550
12113	2023-02-11 15:09:46.961749+00	2023-02-11 15:09:46.96177+00		3	\N	20	550
12114	2023-02-11 15:09:46.964125+00	2023-02-11 15:09:46.964144+00		3	\N	21	550
12115	2023-02-11 15:09:46.966502+00	2023-02-11 15:09:46.966521+00		3	\N	22	550
12116	2023-02-11 15:09:46.97024+00	2023-02-11 15:09:46.970261+00		3	\N	23	550
12117	2023-02-11 15:09:46.972896+00	2023-02-11 15:09:46.972917+00		5	\N	24	550
12118	2023-02-11 15:09:46.976581+00	2023-02-11 15:09:46.976651+00		5	\N	25	550
12119	2023-02-11 15:09:46.978928+00	2023-02-11 15:09:46.978947+00		5	\N	26	550
12120	2023-02-11 15:09:46.981131+00	2023-02-11 15:09:46.981149+00		5	\N	27	550
12121	2023-02-11 15:09:46.983382+00	2023-02-11 15:09:46.983401+00		5	\N	28	550
12122	2023-02-11 15:09:46.986745+00	2023-02-11 15:09:46.986765+00		5	\N	29	550
12123	2023-02-11 15:09:46.989397+00	2023-02-11 15:09:46.989423+00		3	\N	30	550
12124	2023-02-11 15:09:46.991868+00	2023-02-11 15:09:46.991887+00		4	\N	31	550
12125	2023-02-11 15:09:46.994153+00	2023-02-11 15:09:46.994174+00		5	\N	32	550
12126	2023-02-11 15:09:46.996484+00	2023-02-11 15:09:46.996505+00		3	\N	33	550
12127	2023-02-11 15:09:46.998858+00	2023-02-11 15:09:46.998877+00		4	\N	34	550
12128	2023-02-11 15:09:47.001722+00	2023-02-11 15:09:47.001759+00		3	\N	35	550
12129	2023-02-11 15:09:47.004498+00	2023-02-11 15:09:47.004518+00		5	\N	36	550
12130	2023-02-11 15:09:47.006984+00	2023-02-11 15:09:47.007003+00		5	\N	37	550
12131	2023-02-11 15:09:47.009216+00	2023-02-11 15:09:47.009235+00		5	\N	38	550
12132	2023-02-11 15:09:47.011511+00	2023-02-11 15:09:47.01153+00		5	\N	39	550
12133	2023-02-11 15:09:47.013665+00	2023-02-11 15:09:47.013684+00		5	\N	40	550
12134	2023-02-11 15:09:47.015832+00	2023-02-11 15:09:47.015851+00		5	\N	41	550
12135	2023-02-11 15:09:47.018928+00	2023-02-11 15:09:47.01895+00		2	\N	42	550
12136	2023-02-11 15:09:47.021773+00	2023-02-11 15:09:47.021796+00		5	\N	43	550
12137	2023-02-11 15:09:47.024374+00	2023-02-11 15:09:47.0244+00		5	\N	44	550
12138	2023-02-11 15:09:47.027033+00	2023-02-11 15:09:47.027054+00		5	\N	45	550
12139	2023-02-11 15:09:47.029513+00	2023-02-11 15:09:47.029533+00		5	\N	46	550
12140	2023-02-11 15:09:47.032059+00	2023-02-11 15:09:47.032084+00		5	\N	47	550
12141	2023-02-11 15:09:47.035763+00	2023-02-11 15:09:47.035838+00		5	\N	48	550
12142	2023-02-11 15:09:47.038434+00	2023-02-11 15:09:47.038455+00		5	\N	49	550
12143	2023-02-11 15:09:47.040754+00	2023-02-11 15:09:47.040781+00		5	\N	50	550
12144	2023-02-11 15:09:47.043125+00	2023-02-11 15:09:47.043144+00		5	\N	51	550
12145	2023-02-11 15:09:47.045307+00	2023-02-11 15:09:47.045326+00		5	\N	52	550
12146	2023-02-11 15:09:47.047508+00	2023-02-11 15:09:47.047532+00		5	\N	53	550
12147	2023-02-11 15:09:47.049766+00	2023-02-11 15:09:47.049787+00		5	\N	54	550
12148	2023-02-11 15:09:47.052877+00	2023-02-11 15:09:47.052898+00		5	\N	55	550
12149	2023-02-11 15:09:47.055388+00	2023-02-11 15:09:47.055407+00		5	\N	56	550
12150	2023-02-11 15:09:47.057873+00	2023-02-11 15:09:47.057893+00		5	\N	57	550
12151	2023-02-11 15:09:47.060187+00	2023-02-11 15:09:47.060208+00		5	\N	58	550
12152	2023-02-11 15:09:47.062622+00	2023-02-11 15:09:47.062642+00		5	\N	59	550
12153	2023-02-11 15:09:47.065243+00	2023-02-11 15:09:47.06527+00		5	\N	60	550
12154	2023-02-11 15:09:47.068887+00	2023-02-11 15:09:47.068919+00		5	\N	61	550
12155	2023-02-11 15:09:47.071552+00	2023-02-11 15:09:47.071572+00		5	\N	62	550
12156	2023-02-11 15:09:47.074073+00	2023-02-11 15:09:47.074093+00		5	\N	63	550
12157	2023-02-11 15:09:47.076513+00	2023-02-11 15:09:47.076534+00		5	\N	64	550
12158	2023-02-11 15:09:47.079231+00	2023-02-11 15:09:47.079253+00		5	\N	65	550
12159	2023-02-11 15:09:47.082786+00	2023-02-11 15:09:47.082806+00		5	\N	66	550
12160	2023-02-11 15:09:47.086189+00	2023-02-11 15:09:47.08622+00		5	\N	67	550
12161	2023-02-11 15:09:47.088717+00	2023-02-11 15:09:47.08876+00		5	\N	68	550
12162	2023-02-11 15:09:47.091082+00	2023-02-11 15:09:47.091101+00		5	\N	69	550
12163	2023-02-11 15:09:47.093688+00	2023-02-11 15:09:47.09372+00		5	\N	70	550
12164	2023-02-11 15:09:47.096571+00	2023-02-11 15:09:47.096593+00		5	\N	71	550
12165	2023-02-11 15:09:47.143593+00	2023-02-11 15:09:47.143615+00		3	\N	1	551
12166	2023-02-11 15:09:47.146368+00	2023-02-11 15:09:47.146387+00		4	\N	2	551
12167	2023-02-11 15:09:47.148638+00	2023-02-11 15:09:47.148656+00		3	\N	3	551
12168	2023-02-11 15:09:47.151255+00	2023-02-11 15:09:47.151303+00		3	\N	4	551
12169	2023-02-11 15:09:47.154138+00	2023-02-11 15:09:47.154167+00		3	\N	5	551
12170	2023-02-11 15:09:47.156836+00	2023-02-11 15:09:47.156855+00		3	\N	6	551
12171	2023-02-11 15:09:47.159373+00	2023-02-11 15:09:47.159394+00		3	\N	7	551
12172	2023-02-11 15:09:47.161809+00	2023-02-11 15:09:47.161828+00		3	\N	8	551
12173	2023-02-11 15:09:47.16412+00	2023-02-11 15:09:47.16414+00		3	\N	9	551
12174	2023-02-11 15:09:47.166422+00	2023-02-11 15:09:47.166442+00		3	\N	10	551
12175	2023-02-11 15:09:47.169504+00	2023-02-11 15:09:47.169536+00		3	\N	11	551
12176	2023-02-11 15:09:47.172405+00	2023-02-11 15:09:47.172432+00		3	\N	12	551
12177	2023-02-11 15:09:47.17532+00	2023-02-11 15:09:47.17534+00		3	\N	13	551
12178	2023-02-11 15:09:47.177722+00	2023-02-11 15:09:47.177741+00		3	\N	14	551
12179	2023-02-11 15:09:47.180119+00	2023-02-11 15:09:47.180139+00		4	\N	15	551
12180	2023-02-11 15:09:47.182422+00	2023-02-11 15:09:47.182444+00		3	\N	16	551
12181	2023-02-11 15:09:47.185494+00	2023-02-11 15:09:47.185523+00		3	\N	17	551
12182	2023-02-11 15:09:47.188368+00	2023-02-11 15:09:47.188388+00		3	\N	18	551
12183	2023-02-11 15:09:47.191191+00	2023-02-11 15:09:47.191211+00		3	\N	19	551
12184	2023-02-11 15:09:47.193864+00	2023-02-11 15:09:47.193882+00		3	\N	20	551
12185	2023-02-11 15:09:47.19628+00	2023-02-11 15:09:47.196301+00		3	\N	21	551
12186	2023-02-11 15:09:47.19859+00	2023-02-11 15:09:47.198609+00		3	\N	22	551
12187	2023-02-11 15:09:47.202099+00	2023-02-11 15:09:47.202121+00		3	\N	23	551
12188	2023-02-11 15:09:47.205197+00	2023-02-11 15:09:47.205226+00		3	\N	24	551
12189	2023-02-11 15:09:47.20807+00	2023-02-11 15:09:47.20809+00		3	\N	25	551
12190	2023-02-11 15:09:47.210601+00	2023-02-11 15:09:47.210622+00		3	\N	26	551
12191	2023-02-11 15:09:47.212865+00	2023-02-11 15:09:47.212884+00		3	\N	27	551
12192	2023-02-11 15:09:47.215495+00	2023-02-11 15:09:47.215532+00		3	\N	28	551
12193	2023-02-11 15:09:47.218306+00	2023-02-11 15:09:47.218332+00		3	\N	29	551
12194	2023-02-11 15:09:47.221323+00	2023-02-11 15:09:47.221347+00		1	\N	30	551
12195	2023-02-11 15:09:47.223969+00	2023-02-11 15:09:47.223992+00		1	\N	31	551
12196	2023-02-11 15:09:47.226432+00	2023-02-11 15:09:47.226451+00		3	\N	32	551
12197	2023-02-11 15:09:47.228837+00	2023-02-11 15:09:47.228856+00		3	\N	33	551
12198	2023-02-11 15:09:47.231413+00	2023-02-11 15:09:47.231433+00		3	\N	34	551
12199	2023-02-11 15:09:47.234279+00	2023-02-11 15:09:47.234317+00		3	\N	35	551
12200	2023-02-11 15:09:47.237438+00	2023-02-11 15:09:47.237457+00		1	\N	36	551
12201	2023-02-11 15:09:47.239809+00	2023-02-11 15:09:47.239828+00		1	\N	37	551
12202	2023-02-11 15:09:47.24224+00	2023-02-11 15:09:47.242262+00		3	\N	38	551
12203	2023-02-11 15:09:47.244566+00	2023-02-11 15:09:47.244585+00		3	\N	39	551
12204	2023-02-11 15:09:47.247304+00	2023-02-11 15:09:47.247324+00		3	\N	40	551
12205	2023-02-11 15:09:47.250019+00	2023-02-11 15:09:47.25004+00		3	\N	41	551
12206	2023-02-11 15:09:47.253336+00	2023-02-11 15:09:47.253355+00		3	\N	42	551
12207	2023-02-11 15:09:47.255789+00	2023-02-11 15:09:47.255809+00		1	\N	43	551
12208	2023-02-11 15:09:47.258128+00	2023-02-11 15:09:47.258146+00		3	\N	44	551
12209	2023-02-11 15:09:47.260411+00	2023-02-11 15:09:47.260429+00		3	\N	45	551
12210	2023-02-11 15:09:47.262825+00	2023-02-11 15:09:47.262844+00		3	\N	46	551
12211	2023-02-11 15:09:47.265536+00	2023-02-11 15:09:47.265556+00		3	\N	47	551
12212	2023-02-11 15:09:47.268528+00	2023-02-11 15:09:47.268551+00		3	\N	48	551
12213	2023-02-11 15:09:47.270995+00	2023-02-11 15:09:47.271013+00		3	\N	49	551
12214	2023-02-11 15:09:47.273275+00	2023-02-11 15:09:47.273293+00		3	\N	50	551
12215	2023-02-11 15:09:47.27551+00	2023-02-11 15:09:47.275531+00		3	\N	51	551
12216	2023-02-11 15:09:47.277975+00	2023-02-11 15:09:47.277994+00		3	\N	52	551
12217	2023-02-11 15:09:47.281151+00	2023-02-11 15:09:47.281171+00		3	\N	53	551
12218	2023-02-11 15:09:47.283488+00	2023-02-11 15:09:47.283576+00		3	\N	54	551
12219	2023-02-11 15:09:47.286699+00	2023-02-11 15:09:47.286719+00		3	\N	55	551
12220	2023-02-11 15:09:47.289284+00	2023-02-11 15:09:47.289305+00		3	\N	56	551
12221	2023-02-11 15:09:47.291723+00	2023-02-11 15:09:47.291742+00		3	\N	57	551
12222	2023-02-11 15:09:47.294131+00	2023-02-11 15:09:47.294151+00		3	\N	58	551
12223	2023-02-11 15:09:47.296631+00	2023-02-11 15:09:47.296649+00		1	\N	59	551
12224	2023-02-11 15:09:47.29884+00	2023-02-11 15:09:47.298858+00		3	\N	60	551
12225	2023-02-11 15:09:47.30155+00	2023-02-11 15:09:47.301571+00		3	\N	61	551
12226	2023-02-11 15:09:47.304187+00	2023-02-11 15:09:47.304206+00		3	\N	62	551
12227	2023-02-11 15:09:47.306449+00	2023-02-11 15:09:47.306468+00		1	\N	63	551
12228	2023-02-11 15:09:47.30918+00	2023-02-11 15:09:47.309206+00		3	\N	64	551
12229	2023-02-11 15:09:47.311979+00	2023-02-11 15:09:47.311998+00		1	\N	65	551
12230	2023-02-11 15:09:47.314427+00	2023-02-11 15:09:47.314457+00		1	\N	66	551
12231	2023-02-11 15:09:47.316663+00	2023-02-11 15:09:47.316683+00		1	\N	67	551
12232	2023-02-11 15:09:47.319895+00	2023-02-11 15:09:47.319914+00		1	\N	68	551
12233	2023-02-11 15:09:47.322147+00	2023-02-11 15:09:47.322166+00		1	\N	69	551
12234	2023-02-11 15:09:47.32443+00	2023-02-11 15:09:47.324448+00		1	\N	70	551
12235	2023-02-11 15:09:47.326768+00	2023-02-11 15:09:47.326787+00		1	\N	71	551
12236	2023-02-11 15:09:47.366314+00	2023-02-11 15:09:47.366334+00		3	\N	1	552
12237	2023-02-11 15:09:47.369077+00	2023-02-11 15:09:47.369097+00		2	\N	2	552
12238	2023-02-11 15:09:47.371484+00	2023-02-11 15:09:47.371502+00		5	\N	3	552
12239	2023-02-11 15:09:47.373871+00	2023-02-11 15:09:47.373892+00		5	\N	4	552
12240	2023-02-11 15:09:47.376185+00	2023-02-11 15:09:47.376203+00		5	\N	5	552
12241	2023-02-11 15:09:47.378379+00	2023-02-11 15:09:47.378398+00		5	\N	6	552
12242	2023-02-11 15:09:47.380536+00	2023-02-11 15:09:47.380554+00		5	\N	7	552
12243	2023-02-11 15:09:47.382781+00	2023-02-11 15:09:47.382801+00		5	\N	8	552
12244	2023-02-11 15:09:47.385659+00	2023-02-11 15:09:47.385683+00		2	\N	9	552
12245	2023-02-11 15:09:47.388097+00	2023-02-11 15:09:47.388116+00		5	\N	10	552
12246	2023-02-11 15:09:47.390835+00	2023-02-11 15:09:47.390854+00		5	\N	11	552
12247	2023-02-11 15:09:47.393074+00	2023-02-11 15:09:47.393092+00		2	\N	12	552
12248	2023-02-11 15:09:47.395339+00	2023-02-11 15:09:47.395358+00		2	\N	13	552
12249	2023-02-11 15:09:47.397501+00	2023-02-11 15:09:47.397521+00		5	\N	14	552
12250	2023-02-11 15:09:47.399906+00	2023-02-11 15:09:47.399931+00		3	\N	15	552
12251	2023-02-11 15:09:47.403+00	2023-02-11 15:09:47.403029+00		2	\N	16	552
12252	2023-02-11 15:09:47.4058+00	2023-02-11 15:09:47.405818+00		2	\N	17	552
12253	2023-02-11 15:09:47.408083+00	2023-02-11 15:09:47.408102+00		2	\N	18	552
12254	2023-02-11 15:09:47.410413+00	2023-02-11 15:09:47.410431+00		5	\N	19	552
12255	2023-02-11 15:09:47.41266+00	2023-02-11 15:09:47.412678+00		3	\N	20	552
12256	2023-02-11 15:09:47.414866+00	2023-02-11 15:09:47.414885+00		2	\N	21	552
12257	2023-02-11 15:09:47.417552+00	2023-02-11 15:09:47.417579+00		2	\N	22	552
12258	2023-02-11 15:09:47.420588+00	2023-02-11 15:09:47.420613+00		5	\N	23	552
12259	2023-02-11 15:09:47.422926+00	2023-02-11 15:09:47.422945+00		1	\N	24	552
12260	2023-02-11 15:09:47.425275+00	2023-02-11 15:09:47.425293+00		1	\N	25	552
12261	2023-02-11 15:09:47.427538+00	2023-02-11 15:09:47.427556+00		1	\N	26	552
12262	2023-02-11 15:09:47.42992+00	2023-02-11 15:09:47.429944+00		5	\N	27	552
12263	2023-02-11 15:09:47.432192+00	2023-02-11 15:09:47.43221+00		5	\N	28	552
12264	2023-02-11 15:09:47.435076+00	2023-02-11 15:09:47.435097+00		5	\N	29	552
12265	2023-02-11 15:09:47.437757+00	2023-02-11 15:09:47.437775+00		1	\N	30	552
12266	2023-02-11 15:09:47.440127+00	2023-02-11 15:09:47.440148+00		1	\N	31	552
12267	2023-02-11 15:09:47.442329+00	2023-02-11 15:09:47.442348+00		5	\N	32	552
12268	2023-02-11 15:09:47.444616+00	2023-02-11 15:09:47.444635+00		1	\N	33	552
12269	2023-02-11 15:09:47.447185+00	2023-02-11 15:09:47.447209+00		5	\N	34	552
12270	2023-02-11 15:09:47.449742+00	2023-02-11 15:09:47.449762+00		5	\N	35	552
12271	2023-02-11 15:09:47.453192+00	2023-02-11 15:09:47.453211+00		1	\N	36	552
12272	2023-02-11 15:09:47.455553+00	2023-02-11 15:09:47.455572+00		5	\N	37	552
12273	2023-02-11 15:09:47.457982+00	2023-02-11 15:09:47.458+00		5	\N	38	552
12274	2023-02-11 15:09:47.460329+00	2023-02-11 15:09:47.46035+00		3	\N	39	552
12275	2023-02-11 15:09:47.462854+00	2023-02-11 15:09:47.462873+00		3	\N	40	552
12276	2023-02-11 15:09:47.46535+00	2023-02-11 15:09:47.465394+00		1	\N	41	552
12277	2023-02-11 15:09:47.468222+00	2023-02-11 15:09:47.468249+00		1	\N	42	552
12278	2023-02-11 15:09:47.470681+00	2023-02-11 15:09:47.470699+00		5	\N	43	552
12279	2023-02-11 15:09:47.47297+00	2023-02-11 15:09:47.472988+00		5	\N	44	552
12280	2023-02-11 15:09:47.475436+00	2023-02-11 15:09:47.475454+00		4	\N	45	552
12281	2023-02-11 15:09:47.477762+00	2023-02-11 15:09:47.477781+00		5	\N	46	552
12282	2023-02-11 15:09:47.48006+00	2023-02-11 15:09:47.480079+00		3	\N	47	552
12283	2023-02-11 15:09:47.482247+00	2023-02-11 15:09:47.482266+00		5	\N	48	552
12284	2023-02-11 15:09:47.485472+00	2023-02-11 15:09:47.485501+00		5	\N	49	552
12285	2023-02-11 15:09:47.487969+00	2023-02-11 15:09:47.487988+00		5	\N	50	552
12286	2023-02-11 15:09:47.490141+00	2023-02-11 15:09:47.49016+00		5	\N	51	552
12287	2023-02-11 15:09:47.495626+00	2023-02-11 15:09:47.495647+00		5	\N	52	552
12288	2023-02-11 15:09:47.498207+00	2023-02-11 15:09:47.498225+00		5	\N	53	552
12289	2023-02-11 15:09:47.501523+00	2023-02-11 15:09:47.501551+00		5	\N	54	552
12290	2023-02-11 15:09:47.504173+00	2023-02-11 15:09:47.504191+00		5	\N	55	552
12291	2023-02-11 15:09:47.506726+00	2023-02-11 15:09:47.506757+00		3	\N	56	552
12292	2023-02-11 15:09:47.50903+00	2023-02-11 15:09:47.509049+00		3	\N	57	552
12293	2023-02-11 15:09:47.511408+00	2023-02-11 15:09:47.511427+00		1	\N	58	552
12294	2023-02-11 15:09:47.513672+00	2023-02-11 15:09:47.513691+00		3	\N	59	552
12295	2023-02-11 15:09:47.515879+00	2023-02-11 15:09:47.515899+00		3	\N	60	552
12296	2023-02-11 15:09:47.519054+00	2023-02-11 15:09:47.519075+00		3	\N	61	552
12297	2023-02-11 15:09:47.521405+00	2023-02-11 15:09:47.521424+00		3	\N	62	552
12298	2023-02-11 15:09:47.524016+00	2023-02-11 15:09:47.524034+00		3	\N	63	552
12299	2023-02-11 15:09:47.526606+00	2023-02-11 15:09:47.526624+00		5	\N	64	552
12300	2023-02-11 15:09:47.52889+00	2023-02-11 15:09:47.528909+00		5	\N	65	552
12301	2023-02-11 15:09:47.531025+00	2023-02-11 15:09:47.531043+00		1	\N	66	552
12302	2023-02-11 15:09:47.533188+00	2023-02-11 15:09:47.533206+00		3	\N	67	552
12303	2023-02-11 15:09:47.536229+00	2023-02-11 15:09:47.536274+00		3	\N	68	552
12304	2023-02-11 15:09:47.538888+00	2023-02-11 15:09:47.538909+00		3	\N	69	552
12305	2023-02-11 15:09:47.541202+00	2023-02-11 15:09:47.541221+00		1	\N	70	552
12306	2023-02-11 15:09:47.543584+00	2023-02-11 15:09:47.543602+00		1	\N	71	552
12307	2023-02-11 15:09:47.582497+00	2023-02-11 15:09:47.582539+00		4	\N	1	553
12308	2023-02-11 15:09:47.585865+00	2023-02-11 15:09:47.585886+00		3	\N	2	553
12309	2023-02-11 15:09:47.588341+00	2023-02-11 15:09:47.58836+00		3	\N	3	553
12310	2023-02-11 15:09:47.590765+00	2023-02-11 15:09:47.590786+00		5	\N	4	553
12311	2023-02-11 15:09:47.593115+00	2023-02-11 15:09:47.593136+00		3	\N	5	553
12312	2023-02-11 15:09:47.595266+00	2023-02-11 15:09:47.595284+00		3	\N	6	553
12313	2023-02-11 15:09:47.597541+00	2023-02-11 15:09:47.597559+00		4	\N	7	553
12314	2023-02-11 15:09:47.600026+00	2023-02-11 15:09:47.600045+00		4	\N	8	553
12315	2023-02-11 15:09:47.602757+00	2023-02-11 15:09:47.602785+00		3	\N	9	553
12316	2023-02-11 15:09:47.60542+00	2023-02-11 15:09:47.60544+00		5	\N	10	553
12317	2023-02-11 15:09:47.607825+00	2023-02-11 15:09:47.607843+00		4	\N	11	553
12318	2023-02-11 15:09:47.610066+00	2023-02-11 15:09:47.610085+00		5	\N	12	553
12319	2023-02-11 15:09:47.612289+00	2023-02-11 15:09:47.612308+00		2	\N	13	553
12320	2023-02-11 15:09:47.614597+00	2023-02-11 15:09:47.614616+00		4	\N	14	553
12321	2023-02-11 15:09:47.616972+00	2023-02-11 15:09:47.617003+00		5	\N	15	553
12322	2023-02-11 15:09:47.620409+00	2023-02-11 15:09:47.620433+00		4	\N	16	553
12323	2023-02-11 15:09:47.622668+00	2023-02-11 15:09:47.622688+00		5	\N	17	553
12324	2023-02-11 15:09:47.625076+00	2023-02-11 15:09:47.625095+00		2	\N	18	553
12325	2023-02-11 15:09:47.627422+00	2023-02-11 15:09:47.627441+00		3	\N	19	553
12326	2023-02-11 15:09:47.629858+00	2023-02-11 15:09:47.629878+00		3	\N	20	553
12327	2023-02-11 15:09:47.633105+00	2023-02-11 15:09:47.633125+00		4	\N	21	553
12328	2023-02-11 15:09:47.635892+00	2023-02-11 15:09:47.635913+00		2	\N	22	553
12329	2023-02-11 15:09:47.638262+00	2023-02-11 15:09:47.638282+00		3	\N	23	553
12330	2023-02-11 15:09:47.640331+00	2023-02-11 15:09:47.64035+00		5	\N	24	553
12331	2023-02-11 15:09:47.642417+00	2023-02-11 15:09:47.642436+00		4	\N	25	553
12332	2023-02-11 15:09:47.644655+00	2023-02-11 15:09:47.644684+00		5	\N	26	553
12333	2023-02-11 15:09:47.647046+00	2023-02-11 15:09:47.64707+00		5	\N	27	553
12334	2023-02-11 15:09:47.649555+00	2023-02-11 15:09:47.649574+00		5	\N	28	553
12335	2023-02-11 15:09:47.652653+00	2023-02-11 15:09:47.652674+00		3	\N	29	553
12336	2023-02-11 15:09:47.655054+00	2023-02-11 15:09:47.655073+00		3	\N	30	553
12337	2023-02-11 15:09:47.657572+00	2023-02-11 15:09:47.657592+00		3	\N	31	553
12338	2023-02-11 15:09:47.660088+00	2023-02-11 15:09:47.660109+00		3	\N	32	553
12339	2023-02-11 15:09:47.662616+00	2023-02-11 15:09:47.662637+00		5	\N	33	553
12340	2023-02-11 15:09:47.665066+00	2023-02-11 15:09:47.665086+00		3	\N	34	553
12341	2023-02-11 15:09:47.667764+00	2023-02-11 15:09:47.667792+00		2	\N	35	553
12342	2023-02-11 15:09:47.670383+00	2023-02-11 15:09:47.670401+00		3	\N	36	553
12343	2023-02-11 15:09:47.672665+00	2023-02-11 15:09:47.672684+00		1	\N	37	553
12344	2023-02-11 15:09:47.674914+00	2023-02-11 15:09:47.674942+00		1	\N	38	553
12345	2023-02-11 15:09:47.677431+00	2023-02-11 15:09:47.677451+00		3	\N	39	553
12346	2023-02-11 15:09:47.679921+00	2023-02-11 15:09:47.679941+00		2	\N	40	553
12347	2023-02-11 15:09:47.682175+00	2023-02-11 15:09:47.682194+00		5	\N	41	553
12348	2023-02-11 15:09:47.685289+00	2023-02-11 15:09:47.685321+00		3	\N	42	553
12349	2023-02-11 15:09:47.688036+00	2023-02-11 15:09:47.688056+00		4	\N	43	553
12350	2023-02-11 15:09:47.690455+00	2023-02-11 15:09:47.690477+00		5	\N	44	553
12351	2023-02-11 15:09:47.692959+00	2023-02-11 15:09:47.692978+00		3	\N	45	553
12352	2023-02-11 15:09:47.695262+00	2023-02-11 15:09:47.695281+00		4	\N	46	553
12353	2023-02-11 15:09:47.697344+00	2023-02-11 15:09:47.697362+00		4	\N	47	553
12354	2023-02-11 15:09:47.699598+00	2023-02-11 15:09:47.699617+00		5	\N	48	553
12355	2023-02-11 15:09:47.702285+00	2023-02-11 15:09:47.702307+00		5	\N	49	553
12356	2023-02-11 15:09:47.704634+00	2023-02-11 15:09:47.704675+00		2	\N	50	553
12357	2023-02-11 15:09:47.707164+00	2023-02-11 15:09:47.707183+00		3	\N	51	553
12358	2023-02-11 15:09:47.709699+00	2023-02-11 15:09:47.70972+00		5	\N	52	553
12359	2023-02-11 15:09:47.712022+00	2023-02-11 15:09:47.712046+00		5	\N	53	553
12360	2023-02-11 15:09:47.714399+00	2023-02-11 15:09:47.714425+00		3	\N	54	553
12361	2023-02-11 15:09:47.716726+00	2023-02-11 15:09:47.716746+00		4	\N	55	553
12362	2023-02-11 15:09:47.719564+00	2023-02-11 15:09:47.719584+00		3	\N	56	553
12363	2023-02-11 15:09:47.721901+00	2023-02-11 15:09:47.72193+00		3	\N	57	553
12364	2023-02-11 15:09:47.724227+00	2023-02-11 15:09:47.724246+00		3	\N	58	553
12365	2023-02-11 15:09:47.726616+00	2023-02-11 15:09:47.726635+00		3	\N	59	553
12366	2023-02-11 15:09:47.728965+00	2023-02-11 15:09:47.728986+00		5	\N	60	553
12367	2023-02-11 15:09:47.73117+00	2023-02-11 15:09:47.731189+00		3	\N	61	553
12368	2023-02-11 15:09:47.733621+00	2023-02-11 15:09:47.733652+00		3	\N	62	553
12369	2023-02-11 15:09:47.737278+00	2023-02-11 15:09:47.737305+00		1	\N	63	553
12370	2023-02-11 15:09:47.739887+00	2023-02-11 15:09:47.739908+00		3	\N	64	553
12371	2023-02-11 15:09:47.742095+00	2023-02-11 15:09:47.742114+00		5	\N	65	553
12372	2023-02-11 15:09:47.744409+00	2023-02-11 15:09:47.744431+00		3	\N	66	553
12373	2023-02-11 15:09:47.746793+00	2023-02-11 15:09:47.746812+00		3	\N	67	553
12374	2023-02-11 15:09:47.749004+00	2023-02-11 15:09:47.749022+00		3	\N	68	553
12375	2023-02-11 15:09:47.751595+00	2023-02-11 15:09:47.751626+00		3	\N	69	553
12376	2023-02-11 15:09:47.75428+00	2023-02-11 15:09:47.754299+00		3	\N	70	553
12377	2023-02-11 15:09:47.756603+00	2023-02-11 15:09:47.756621+00		3	\N	71	553
12378	2023-02-11 15:09:47.79702+00	2023-02-11 15:09:47.797041+00		3	\N	1	554
12379	2023-02-11 15:09:47.799836+00	2023-02-11 15:09:47.799879+00		3	\N	2	554
12380	2023-02-11 15:09:47.802959+00	2023-02-11 15:09:47.802978+00		3	\N	3	554
12381	2023-02-11 15:09:47.805484+00	2023-02-11 15:09:47.805503+00		3	\N	4	554
12382	2023-02-11 15:09:47.807934+00	2023-02-11 15:09:47.807953+00		3	\N	5	554
12383	2023-02-11 15:09:47.810406+00	2023-02-11 15:09:47.810426+00		3	\N	6	554
12384	2023-02-11 15:09:47.812853+00	2023-02-11 15:09:47.812907+00		3	\N	7	554
12385	2023-02-11 15:09:47.816722+00	2023-02-11 15:09:47.81674+00		3	\N	8	554
12386	2023-02-11 15:09:47.820152+00	2023-02-11 15:09:47.820172+00		3	\N	9	554
12387	2023-02-11 15:09:47.822442+00	2023-02-11 15:09:47.822461+00		3	\N	10	554
12388	2023-02-11 15:09:47.824742+00	2023-02-11 15:09:47.824761+00		3	\N	11	554
12389	2023-02-11 15:09:47.827198+00	2023-02-11 15:09:47.827219+00		3	\N	12	554
12390	2023-02-11 15:09:47.829766+00	2023-02-11 15:09:47.829788+00		3	\N	13	554
12391	2023-02-11 15:09:47.832213+00	2023-02-11 15:09:47.832233+00		3	\N	14	554
12392	2023-02-11 15:09:47.83503+00	2023-02-11 15:09:47.835053+00		3	\N	15	554
12393	2023-02-11 15:09:47.837696+00	2023-02-11 15:09:47.837716+00		3	\N	16	554
12394	2023-02-11 15:09:47.839905+00	2023-02-11 15:09:47.839923+00		3	\N	17	554
12395	2023-02-11 15:09:47.841965+00	2023-02-11 15:09:47.841984+00		4	\N	18	554
12396	2023-02-11 15:09:47.844666+00	2023-02-11 15:09:47.844698+00		3	\N	19	554
12397	2023-02-11 15:09:47.847367+00	2023-02-11 15:09:47.847387+00		3	\N	20	554
12398	2023-02-11 15:09:47.849629+00	2023-02-11 15:09:47.849649+00		1	\N	21	554
12399	2023-02-11 15:09:47.852405+00	2023-02-11 15:09:47.852426+00		3	\N	22	554
12400	2023-02-11 15:09:47.855045+00	2023-02-11 15:09:47.855065+00		3	\N	23	554
12401	2023-02-11 15:09:47.857412+00	2023-02-11 15:09:47.857431+00		3	\N	24	554
12402	2023-02-11 15:09:47.859821+00	2023-02-11 15:09:47.859841+00		3	\N	25	554
12403	2023-02-11 15:09:47.862112+00	2023-02-11 15:09:47.86213+00		4	\N	26	554
12404	2023-02-11 15:09:47.864416+00	2023-02-11 15:09:47.864434+00		3	\N	27	554
12405	2023-02-11 15:09:47.866568+00	2023-02-11 15:09:47.866587+00		3	\N	28	554
12406	2023-02-11 15:09:47.869651+00	2023-02-11 15:09:47.869669+00		3	\N	29	554
12407	2023-02-11 15:09:47.872034+00	2023-02-11 15:09:47.872054+00		3	\N	30	554
12408	2023-02-11 15:09:47.874463+00	2023-02-11 15:09:47.874482+00		3	\N	31	554
12409	2023-02-11 15:09:47.87714+00	2023-02-11 15:09:47.87716+00		3	\N	32	554
12410	2023-02-11 15:09:47.879348+00	2023-02-11 15:09:47.879368+00		3	\N	33	554
12411	2023-02-11 15:09:47.881623+00	2023-02-11 15:09:47.881642+00		3	\N	34	554
12412	2023-02-11 15:09:47.884324+00	2023-02-11 15:09:47.884363+00		3	\N	35	554
12413	2023-02-11 15:09:47.887218+00	2023-02-11 15:09:47.887277+00		1	\N	36	554
12414	2023-02-11 15:09:47.889624+00	2023-02-11 15:09:47.889644+00		3	\N	37	554
12415	2023-02-11 15:09:47.892457+00	2023-02-11 15:09:47.892476+00		3	\N	38	554
12416	2023-02-11 15:09:47.894839+00	2023-02-11 15:09:47.894859+00		3	\N	39	554
12417	2023-02-11 15:09:47.897197+00	2023-02-11 15:09:47.897216+00		3	\N	40	554
12418	2023-02-11 15:09:47.899528+00	2023-02-11 15:09:47.899548+00		4	\N	41	554
12419	2023-02-11 15:09:47.902565+00	2023-02-11 15:09:47.902588+00		3	\N	42	554
12420	2023-02-11 15:09:47.905049+00	2023-02-11 15:09:47.905068+00		3	\N	43	554
12421	2023-02-11 15:09:47.907288+00	2023-02-11 15:09:47.907308+00		3	\N	44	554
12422	2023-02-11 15:09:47.909521+00	2023-02-11 15:09:47.90954+00		3	\N	45	554
12423	2023-02-11 15:09:47.91201+00	2023-02-11 15:09:47.91203+00		3	\N	46	554
12424	2023-02-11 15:09:47.914167+00	2023-02-11 15:09:47.914187+00		3	\N	47	554
12425	2023-02-11 15:09:47.91662+00	2023-02-11 15:09:47.916643+00		3	\N	48	554
12426	2023-02-11 15:09:47.919841+00	2023-02-11 15:09:47.919871+00		3	\N	49	554
12427	2023-02-11 15:09:47.923429+00	2023-02-11 15:09:47.923449+00		1	\N	50	554
12428	2023-02-11 15:09:47.925671+00	2023-02-11 15:09:47.925691+00		1	\N	51	554
12429	2023-02-11 15:09:47.927968+00	2023-02-11 15:09:47.927987+00		3	\N	52	554
12430	2023-02-11 15:09:47.930268+00	2023-02-11 15:09:47.930289+00		3	\N	53	554
12431	2023-02-11 15:09:47.932632+00	2023-02-11 15:09:47.932651+00		3	\N	54	554
12432	2023-02-11 15:09:47.936341+00	2023-02-11 15:09:47.936363+00		3	\N	55	554
12433	2023-02-11 15:09:47.938908+00	2023-02-11 15:09:47.938928+00		3	\N	56	554
12434	2023-02-11 15:09:47.941468+00	2023-02-11 15:09:47.941516+00		3	\N	57	554
12435	2023-02-11 15:09:47.943685+00	2023-02-11 15:09:47.943709+00		4	\N	58	554
12436	2023-02-11 15:09:47.945935+00	2023-02-11 15:09:47.945959+00		3	\N	59	554
12437	2023-02-11 15:09:47.948095+00	2023-02-11 15:09:47.948123+00		3	\N	60	554
12438	2023-02-11 15:09:47.951133+00	2023-02-11 15:09:47.951183+00		1	\N	61	554
12439	2023-02-11 15:09:47.954009+00	2023-02-11 15:09:47.954034+00		1	\N	62	554
12440	2023-02-11 15:09:47.956357+00	2023-02-11 15:09:47.956376+00		1	\N	63	554
12441	2023-02-11 15:09:47.958774+00	2023-02-11 15:09:47.958793+00		3	\N	64	554
12442	2023-02-11 15:09:47.961014+00	2023-02-11 15:09:47.961033+00		3	\N	65	554
12443	2023-02-11 15:09:47.963323+00	2023-02-11 15:09:47.963342+00		3	\N	66	554
12444	2023-02-11 15:09:47.96565+00	2023-02-11 15:09:47.965672+00		3	\N	67	554
12445	2023-02-11 15:09:47.968681+00	2023-02-11 15:09:47.968708+00		3	\N	68	554
12446	2023-02-11 15:09:47.971347+00	2023-02-11 15:09:47.971367+00		3	\N	69	554
12447	2023-02-11 15:09:47.973513+00	2023-02-11 15:09:47.973532+00		3	\N	70	554
12448	2023-02-11 15:09:47.975631+00	2023-02-11 15:09:47.975652+00		3	\N	71	554
12449	2023-02-11 15:09:48.014501+00	2023-02-11 15:09:48.01452+00		4	\N	1	555
12450	2023-02-11 15:09:48.016724+00	2023-02-11 15:09:48.016745+00		1	\N	2	555
12451	2023-02-11 15:09:48.019466+00	2023-02-11 15:09:48.019486+00		5	\N	3	555
12452	2023-02-11 15:09:48.021736+00	2023-02-11 15:09:48.021757+00		3	\N	4	555
12453	2023-02-11 15:09:48.023813+00	2023-02-11 15:09:48.023832+00		3	\N	5	555
12454	2023-02-11 15:09:48.025987+00	2023-02-11 15:09:48.026007+00		5	\N	6	555
12455	2023-02-11 15:09:48.028811+00	2023-02-11 15:09:48.028829+00		4	\N	7	555
12456	2023-02-11 15:09:48.031177+00	2023-02-11 15:09:48.031196+00		4	\N	8	555
12457	2023-02-11 15:09:48.033481+00	2023-02-11 15:09:48.033519+00		3	\N	9	555
12458	2023-02-11 15:09:48.036352+00	2023-02-11 15:09:48.036371+00		3	\N	10	555
12459	2023-02-11 15:09:48.038757+00	2023-02-11 15:09:48.038777+00		3	\N	11	555
12460	2023-02-11 15:09:48.041064+00	2023-02-11 15:09:48.041084+00		1	\N	12	555
12461	2023-02-11 15:09:48.043644+00	2023-02-11 15:09:48.043663+00		1	\N	13	555
12462	2023-02-11 15:09:48.045997+00	2023-02-11 15:09:48.046016+00		5	\N	14	555
12463	2023-02-11 15:09:48.048245+00	2023-02-11 15:09:48.048263+00		2	\N	15	555
12464	2023-02-11 15:09:48.050592+00	2023-02-11 15:09:48.050621+00		2	\N	16	555
12465	2023-02-11 15:09:48.053534+00	2023-02-11 15:09:48.053554+00		2	\N	17	555
12466	2023-02-11 15:09:48.055667+00	2023-02-11 15:09:48.055686+00		2	\N	18	555
12467	2023-02-11 15:09:48.058241+00	2023-02-11 15:09:48.05826+00		3	\N	19	555
12468	2023-02-11 15:09:48.0622+00	2023-02-11 15:09:48.062219+00		2	\N	20	555
12469	2023-02-11 15:09:48.064478+00	2023-02-11 15:09:48.064496+00		4	\N	21	555
12470	2023-02-11 15:09:48.066857+00	2023-02-11 15:09:48.066882+00		4	\N	22	555
12471	2023-02-11 15:09:48.069711+00	2023-02-11 15:09:48.069732+00		2	\N	23	555
12472	2023-02-11 15:09:48.072172+00	2023-02-11 15:09:48.072195+00		5	\N	24	555
12473	2023-02-11 15:09:48.074407+00	2023-02-11 15:09:48.074429+00		2	\N	25	555
12474	2023-02-11 15:09:48.076692+00	2023-02-11 15:09:48.07671+00		1	\N	26	555
12475	2023-02-11 15:09:48.078761+00	2023-02-11 15:09:48.07878+00		2	\N	27	555
12476	2023-02-11 15:09:48.080916+00	2023-02-11 15:09:48.080935+00		1	\N	28	555
12477	2023-02-11 15:09:48.082962+00	2023-02-11 15:09:48.082983+00		2	\N	29	555
12478	2023-02-11 15:09:48.08594+00	2023-02-11 15:09:48.085963+00		4	\N	30	555
12479	2023-02-11 15:09:48.088349+00	2023-02-11 15:09:48.088376+00		3	\N	31	555
12480	2023-02-11 15:09:48.090819+00	2023-02-11 15:09:48.090839+00		1	\N	32	555
12481	2023-02-11 15:09:48.093065+00	2023-02-11 15:09:48.093084+00		1	\N	33	555
12482	2023-02-11 15:09:48.095219+00	2023-02-11 15:09:48.095239+00		1	\N	34	555
12483	2023-02-11 15:09:48.097311+00	2023-02-11 15:09:48.097329+00		1	\N	35	555
12484	2023-02-11 15:09:48.099596+00	2023-02-11 15:09:48.099621+00		1	\N	36	555
12485	2023-02-11 15:09:48.102958+00	2023-02-11 15:09:48.102979+00		1	\N	37	555
12486	2023-02-11 15:09:48.105437+00	2023-02-11 15:09:48.105456+00		1	\N	38	555
12487	2023-02-11 15:09:48.10763+00	2023-02-11 15:09:48.10765+00		1	\N	39	555
12488	2023-02-11 15:09:48.10979+00	2023-02-11 15:09:48.109809+00		1	\N	40	555
12489	2023-02-11 15:09:48.112094+00	2023-02-11 15:09:48.112113+00		1	\N	41	555
12490	2023-02-11 15:09:48.11421+00	2023-02-11 15:09:48.114229+00		2	\N	42	555
12491	2023-02-11 15:09:48.116377+00	2023-02-11 15:09:48.116397+00		2	\N	43	555
12492	2023-02-11 15:09:48.119914+00	2023-02-11 15:09:48.119935+00		2	\N	44	555
12493	2023-02-11 15:09:48.122467+00	2023-02-11 15:09:48.122492+00		2	\N	45	555
12494	2023-02-11 15:09:48.124869+00	2023-02-11 15:09:48.124894+00		1	\N	46	555
12495	2023-02-11 15:09:48.127164+00	2023-02-11 15:09:48.127186+00		1	\N	47	555
12496	2023-02-11 15:09:48.129452+00	2023-02-11 15:09:48.129473+00		1	\N	48	555
12497	2023-02-11 15:09:48.131858+00	2023-02-11 15:09:48.131878+00		1	\N	49	555
12498	2023-02-11 15:09:48.13439+00	2023-02-11 15:09:48.134431+00		1	\N	50	555
12499	2023-02-11 15:09:48.137457+00	2023-02-11 15:09:48.137475+00		1	\N	51	555
12500	2023-02-11 15:09:48.140069+00	2023-02-11 15:09:48.140097+00		1	\N	52	555
12501	2023-02-11 15:09:48.142564+00	2023-02-11 15:09:48.142583+00		1	\N	53	555
12502	2023-02-11 15:09:48.144882+00	2023-02-11 15:09:48.144901+00		1	\N	54	555
12503	2023-02-11 15:09:48.14707+00	2023-02-11 15:09:48.147089+00		1	\N	55	555
12504	2023-02-11 15:09:48.149288+00	2023-02-11 15:09:48.149317+00		2	\N	56	555
12505	2023-02-11 15:09:48.152493+00	2023-02-11 15:09:48.152556+00		1	\N	57	555
12506	2023-02-11 15:09:48.155332+00	2023-02-11 15:09:48.155352+00		1	\N	58	555
12507	2023-02-11 15:09:48.157877+00	2023-02-11 15:09:48.1579+00		1	\N	59	555
12508	2023-02-11 15:09:48.160189+00	2023-02-11 15:09:48.160206+00		1	\N	60	555
12509	2023-02-11 15:09:48.162445+00	2023-02-11 15:09:48.162467+00		1	\N	61	555
12510	2023-02-11 15:09:48.164756+00	2023-02-11 15:09:48.164776+00		1	\N	62	555
12511	2023-02-11 15:09:48.16741+00	2023-02-11 15:09:48.167433+00		1	\N	63	555
12512	2023-02-11 15:09:48.170496+00	2023-02-11 15:09:48.170516+00		1	\N	64	555
12513	2023-02-11 15:09:48.172883+00	2023-02-11 15:09:48.172903+00		1	\N	65	555
12514	2023-02-11 15:09:48.175443+00	2023-02-11 15:09:48.175463+00		1	\N	66	555
12515	2023-02-11 15:09:48.177934+00	2023-02-11 15:09:48.177954+00		1	\N	67	555
12516	2023-02-11 15:09:48.180495+00	2023-02-11 15:09:48.180517+00		1	\N	68	555
12517	2023-02-11 15:09:48.183073+00	2023-02-11 15:09:48.183092+00		1	\N	69	555
12518	2023-02-11 15:09:48.186345+00	2023-02-11 15:09:48.186379+00		1	\N	70	555
12519	2023-02-11 15:09:48.189112+00	2023-02-11 15:09:48.189141+00		1	\N	71	555
12520	2023-02-11 15:09:48.230895+00	2023-02-11 15:09:48.230936+00		5	\N	1	556
12521	2023-02-11 15:09:48.233237+00	2023-02-11 15:09:48.233256+00		5	\N	2	556
12522	2023-02-11 15:09:48.236819+00	2023-02-11 15:09:48.236842+00		3	\N	3	556
12523	2023-02-11 15:09:48.239228+00	2023-02-11 15:09:48.239256+00		5	\N	4	556
12524	2023-02-11 15:09:48.241814+00	2023-02-11 15:09:48.241839+00		5	\N	5	556
12525	2023-02-11 15:09:48.24441+00	2023-02-11 15:09:48.244429+00		3	\N	6	556
12526	2023-02-11 15:09:48.246731+00	2023-02-11 15:09:48.24675+00		5	\N	7	556
12527	2023-02-11 15:09:48.249128+00	2023-02-11 15:09:48.249148+00		5	\N	8	556
12528	2023-02-11 15:09:48.252244+00	2023-02-11 15:09:48.252281+00		3	\N	9	556
12529	2023-02-11 15:09:48.255243+00	2023-02-11 15:09:48.255263+00		3	\N	10	556
12530	2023-02-11 15:09:48.257802+00	2023-02-11 15:09:48.257821+00		3	\N	11	556
12531	2023-02-11 15:09:48.261655+00	2023-02-11 15:09:48.261674+00		3	\N	12	556
12532	2023-02-11 15:09:48.263982+00	2023-02-11 15:09:48.264003+00		5	\N	13	556
12533	2023-02-11 15:09:48.266392+00	2023-02-11 15:09:48.266412+00		3	\N	14	556
12534	2023-02-11 15:09:48.269741+00	2023-02-11 15:09:48.269771+00		5	\N	15	556
12535	2023-02-11 15:09:48.273226+00	2023-02-11 15:09:48.273253+00		5	\N	16	556
12536	2023-02-11 15:09:48.275852+00	2023-02-11 15:09:48.275873+00		5	\N	17	556
12537	2023-02-11 15:09:48.278276+00	2023-02-11 15:09:48.278294+00		5	\N	18	556
12538	2023-02-11 15:09:48.280568+00	2023-02-11 15:09:48.280588+00		5	\N	19	556
12539	2023-02-11 15:09:48.283061+00	2023-02-11 15:09:48.283082+00		3	\N	20	556
12540	2023-02-11 15:09:48.286715+00	2023-02-11 15:09:48.286971+00		1	\N	21	556
12541	2023-02-11 15:09:48.289757+00	2023-02-11 15:09:48.289812+00		3	\N	22	556
12542	2023-02-11 15:09:48.292333+00	2023-02-11 15:09:48.292352+00		5	\N	23	556
12543	2023-02-11 15:09:48.294674+00	2023-02-11 15:09:48.294692+00		5	\N	24	556
12544	2023-02-11 15:09:48.296801+00	2023-02-11 15:09:48.29682+00		5	\N	25	556
12545	2023-02-11 15:09:48.298964+00	2023-02-11 15:09:48.298984+00		3	\N	26	556
12546	2023-02-11 15:09:48.303291+00	2023-02-11 15:09:48.303314+00		3	\N	27	556
12547	2023-02-11 15:09:48.30639+00	2023-02-11 15:09:48.306411+00		4	\N	28	556
12548	2023-02-11 15:09:48.308621+00	2023-02-11 15:09:48.308641+00		3	\N	29	556
12549	2023-02-11 15:09:48.310895+00	2023-02-11 15:09:48.310914+00		3	\N	30	556
12550	2023-02-11 15:09:48.313116+00	2023-02-11 15:09:48.313137+00		3	\N	31	556
12551	2023-02-11 15:09:48.315407+00	2023-02-11 15:09:48.315428+00		3	\N	32	556
12552	2023-02-11 15:09:48.318917+00	2023-02-11 15:09:48.318946+00		3	\N	33	556
12553	2023-02-11 15:09:48.321927+00	2023-02-11 15:09:48.321948+00		5	\N	34	556
12554	2023-02-11 15:09:48.324442+00	2023-02-11 15:09:48.324462+00		5	\N	35	556
12555	2023-02-11 15:09:48.326747+00	2023-02-11 15:09:48.326767+00		1	\N	36	556
12556	2023-02-11 15:09:48.328786+00	2023-02-11 15:09:48.328807+00		3	\N	37	556
12557	2023-02-11 15:09:48.331043+00	2023-02-11 15:09:48.331062+00		3	\N	38	556
12558	2023-02-11 15:09:48.333701+00	2023-02-11 15:09:48.333731+00		3	\N	39	556
12559	2023-02-11 15:09:48.337874+00	2023-02-11 15:09:48.337894+00		3	\N	40	556
12560	2023-02-11 15:09:48.34073+00	2023-02-11 15:09:48.34075+00		3	\N	41	556
12561	2023-02-11 15:09:48.343096+00	2023-02-11 15:09:48.343116+00		5	\N	42	556
12562	2023-02-11 15:09:48.345726+00	2023-02-11 15:09:48.345745+00		4	\N	43	556
12563	2023-02-11 15:09:48.348045+00	2023-02-11 15:09:48.348063+00		5	\N	44	556
12564	2023-02-11 15:09:48.351725+00	2023-02-11 15:09:48.351756+00		5	\N	45	556
12565	2023-02-11 15:09:48.354899+00	2023-02-11 15:09:48.35492+00		3	\N	46	556
12566	2023-02-11 15:09:48.357442+00	2023-02-11 15:09:48.357462+00		3	\N	47	556
12567	2023-02-11 15:09:48.359663+00	2023-02-11 15:09:48.359683+00		5	\N	48	556
12568	2023-02-11 15:09:48.362042+00	2023-02-11 15:09:48.362061+00		5	\N	49	556
12569	2023-02-11 15:09:48.364382+00	2023-02-11 15:09:48.364402+00		5	\N	50	556
12570	2023-02-11 15:09:48.366791+00	2023-02-11 15:09:48.366818+00		5	\N	51	556
12571	2023-02-11 15:09:48.371117+00	2023-02-11 15:09:48.371138+00		5	\N	52	556
12572	2023-02-11 15:09:48.373649+00	2023-02-11 15:09:48.373667+00		5	\N	53	556
12573	2023-02-11 15:09:48.376204+00	2023-02-11 15:09:48.376224+00		5	\N	54	556
12574	2023-02-11 15:09:48.378435+00	2023-02-11 15:09:48.378454+00		5	\N	55	556
12575	2023-02-11 15:09:48.381194+00	2023-02-11 15:09:48.381218+00		5	\N	56	556
12576	2023-02-11 15:09:48.383573+00	2023-02-11 15:09:48.383599+00		5	\N	57	556
12577	2023-02-11 15:09:48.387406+00	2023-02-11 15:09:48.387426+00		5	\N	58	556
12578	2023-02-11 15:09:48.389823+00	2023-02-11 15:09:48.389843+00		5	\N	59	556
12579	2023-02-11 15:09:48.392022+00	2023-02-11 15:09:48.392042+00		5	\N	60	556
12580	2023-02-11 15:09:48.394251+00	2023-02-11 15:09:48.39427+00		5	\N	61	556
12581	2023-02-11 15:09:48.396545+00	2023-02-11 15:09:48.396563+00		5	\N	62	556
12582	2023-02-11 15:09:48.39882+00	2023-02-11 15:09:48.39884+00		1	\N	63	556
12583	2023-02-11 15:09:48.402008+00	2023-02-11 15:09:48.402032+00		3	\N	64	556
12584	2023-02-11 15:09:48.405313+00	2023-02-11 15:09:48.405332+00		3	\N	65	556
12585	2023-02-11 15:09:48.407474+00	2023-02-11 15:09:48.4075+00		3	\N	66	556
12586	2023-02-11 15:09:48.40987+00	2023-02-11 15:09:48.40989+00		5	\N	67	556
12587	2023-02-11 15:09:48.412252+00	2023-02-11 15:09:48.412273+00		5	\N	68	556
12588	2023-02-11 15:09:48.414654+00	2023-02-11 15:09:48.414673+00		3	\N	69	556
12589	2023-02-11 15:09:48.417134+00	2023-02-11 15:09:48.417165+00		1	\N	70	556
12590	2023-02-11 15:09:48.420596+00	2023-02-11 15:09:48.420615+00		1	\N	71	556
12591	2023-02-11 15:09:48.461859+00	2023-02-11 15:09:48.46188+00		5	\N	1	557
12592	2023-02-11 15:09:48.464005+00	2023-02-11 15:09:48.464032+00		3	\N	2	557
12593	2023-02-11 15:09:48.466397+00	2023-02-11 15:09:48.466417+00		5	\N	3	557
12594	2023-02-11 15:09:48.469142+00	2023-02-11 15:09:48.469163+00		4	\N	4	557
12595	2023-02-11 15:09:48.471949+00	2023-02-11 15:09:48.471969+00		4	\N	5	557
12596	2023-02-11 15:09:48.474718+00	2023-02-11 15:09:48.47475+00		4	\N	6	557
12597	2023-02-11 15:09:48.476992+00	2023-02-11 15:09:48.477011+00		3	\N	7	557
12598	2023-02-11 15:09:48.479177+00	2023-02-11 15:09:48.479196+00		4	\N	8	557
12599	2023-02-11 15:09:48.481274+00	2023-02-11 15:09:48.481293+00		3	\N	9	557
12600	2023-02-11 15:09:48.483539+00	2023-02-11 15:09:48.483565+00		4	\N	10	557
12601	2023-02-11 15:09:48.486945+00	2023-02-11 15:09:48.486977+00		5	\N	11	557
12602	2023-02-11 15:09:48.48961+00	2023-02-11 15:09:48.48963+00		4	\N	12	557
12603	2023-02-11 15:09:48.492311+00	2023-02-11 15:09:48.492331+00		3	\N	13	557
12604	2023-02-11 15:09:48.494553+00	2023-02-11 15:09:48.494572+00		5	\N	14	557
12605	2023-02-11 15:09:48.496885+00	2023-02-11 15:09:48.496905+00		4	\N	15	557
12606	2023-02-11 15:09:48.499119+00	2023-02-11 15:09:48.499138+00		4	\N	16	557
12607	2023-02-11 15:09:48.50189+00	2023-02-11 15:09:48.501962+00		4	\N	17	557
12608	2023-02-11 15:09:48.504764+00	2023-02-11 15:09:48.504783+00		4	\N	18	557
12609	2023-02-11 15:09:48.507414+00	2023-02-11 15:09:48.507454+00		3	\N	19	557
12610	2023-02-11 15:09:48.509801+00	2023-02-11 15:09:48.50982+00		3	\N	20	557
12611	2023-02-11 15:09:48.51208+00	2023-02-11 15:09:48.512107+00		3	\N	21	557
12612	2023-02-11 15:09:48.514245+00	2023-02-11 15:09:48.514265+00		4	\N	22	557
12613	2023-02-11 15:09:48.516615+00	2023-02-11 15:09:48.516639+00		5	\N	23	557
12614	2023-02-11 15:09:48.520675+00	2023-02-11 15:09:48.520695+00		4	\N	24	557
12615	2023-02-11 15:09:48.523438+00	2023-02-11 15:09:48.523458+00		3	\N	25	557
12616	2023-02-11 15:09:48.525708+00	2023-02-11 15:09:48.525727+00		3	\N	26	557
12617	2023-02-11 15:09:48.5279+00	2023-02-11 15:09:48.527918+00		3	\N	27	557
12618	2023-02-11 15:09:48.530029+00	2023-02-11 15:09:48.530048+00		3	\N	28	557
12619	2023-02-11 15:09:48.532254+00	2023-02-11 15:09:48.532282+00		4	\N	29	557
12620	2023-02-11 15:09:48.535271+00	2023-02-11 15:09:48.535301+00		3	\N	30	557
12621	2023-02-11 15:09:48.538627+00	2023-02-11 15:09:48.538647+00		3	\N	31	557
12622	2023-02-11 15:09:48.540893+00	2023-02-11 15:09:48.540912+00		3	\N	32	557
12623	2023-02-11 15:09:48.543119+00	2023-02-11 15:09:48.543138+00		3	\N	33	557
12624	2023-02-11 15:09:48.545417+00	2023-02-11 15:09:48.545436+00		4	\N	34	557
12625	2023-02-11 15:09:48.547945+00	2023-02-11 15:09:48.547975+00		4	\N	35	557
12626	2023-02-11 15:09:48.550289+00	2023-02-11 15:09:48.550319+00		3	\N	36	557
12627	2023-02-11 15:09:48.553898+00	2023-02-11 15:09:48.553919+00		3	\N	37	557
12628	2023-02-11 15:09:48.556437+00	2023-02-11 15:09:48.556456+00		3	\N	38	557
12629	2023-02-11 15:09:48.558644+00	2023-02-11 15:09:48.558663+00		5	\N	39	557
12630	2023-02-11 15:09:48.560855+00	2023-02-11 15:09:48.560875+00		3	\N	40	557
12631	2023-02-11 15:09:48.563264+00	2023-02-11 15:09:48.563292+00		4	\N	41	557
12632	2023-02-11 15:09:48.56879+00	2023-02-11 15:09:48.568879+00		3	\N	42	557
12633	2023-02-11 15:09:48.571772+00	2023-02-11 15:09:48.571794+00		3	\N	43	557
12634	2023-02-11 15:09:48.573945+00	2023-02-11 15:09:48.573964+00		3	\N	44	557
12635	2023-02-11 15:09:48.57628+00	2023-02-11 15:09:48.576299+00		3	\N	45	557
12636	2023-02-11 15:09:48.578447+00	2023-02-11 15:09:48.578469+00		3	\N	46	557
12637	2023-02-11 15:09:48.581024+00	2023-02-11 15:09:48.581045+00		3	\N	47	557
12638	2023-02-11 15:09:48.583286+00	2023-02-11 15:09:48.583305+00		3	\N	48	557
12639	2023-02-11 15:09:48.586318+00	2023-02-11 15:09:48.586343+00		5	\N	49	557
12640	2023-02-11 15:09:48.588514+00	2023-02-11 15:09:48.588534+00		5	\N	50	557
12641	2023-02-11 15:09:48.590816+00	2023-02-11 15:09:48.590836+00		4	\N	51	557
12642	2023-02-11 15:09:48.592864+00	2023-02-11 15:09:48.592882+00		3	\N	52	557
12643	2023-02-11 15:09:48.595316+00	2023-02-11 15:09:48.595335+00		3	\N	53	557
12644	2023-02-11 15:09:48.597781+00	2023-02-11 15:09:48.597801+00		3	\N	54	557
12645	2023-02-11 15:09:48.600104+00	2023-02-11 15:09:48.600124+00		3	\N	55	557
12646	2023-02-11 15:09:48.603226+00	2023-02-11 15:09:48.603245+00		3	\N	56	557
12647	2023-02-11 15:09:48.605411+00	2023-02-11 15:09:48.60543+00		3	\N	57	557
12648	2023-02-11 15:09:48.607571+00	2023-02-11 15:09:48.607591+00		3	\N	58	557
12649	2023-02-11 15:09:48.609925+00	2023-02-11 15:09:48.609947+00		3	\N	59	557
12650	2023-02-11 15:09:48.612161+00	2023-02-11 15:09:48.612179+00		3	\N	60	557
12651	2023-02-11 15:09:48.614414+00	2023-02-11 15:09:48.614433+00		3	\N	61	557
12652	2023-02-11 15:09:48.616629+00	2023-02-11 15:09:48.616647+00		3	\N	62	557
12653	2023-02-11 15:09:48.619964+00	2023-02-11 15:09:48.619984+00		3	\N	63	557
12654	2023-02-11 15:09:48.622219+00	2023-02-11 15:09:48.622238+00		3	\N	64	557
12655	2023-02-11 15:09:48.624694+00	2023-02-11 15:09:48.624714+00		4	\N	65	557
12656	2023-02-11 15:09:48.627122+00	2023-02-11 15:09:48.627143+00		3	\N	66	557
12657	2023-02-11 15:09:48.629467+00	2023-02-11 15:09:48.629487+00		3	\N	67	557
12658	2023-02-11 15:09:48.63163+00	2023-02-11 15:09:48.631649+00		3	\N	68	557
12659	2023-02-11 15:09:48.63407+00	2023-02-11 15:09:48.634099+00		4	\N	69	557
12660	2023-02-11 15:09:48.637171+00	2023-02-11 15:09:48.637191+00		4	\N	70	557
12661	2023-02-11 15:09:48.639635+00	2023-02-11 15:09:48.639662+00		4	\N	71	557
12662	2023-02-11 15:09:48.678006+00	2023-02-11 15:09:48.678026+00		5	\N	1	558
12663	2023-02-11 15:09:48.680134+00	2023-02-11 15:09:48.680153+00		1	\N	2	558
12664	2023-02-11 15:09:48.682364+00	2023-02-11 15:09:48.682383+00		5	\N	3	558
12665	2023-02-11 15:09:48.684817+00	2023-02-11 15:09:48.684882+00		5	\N	4	558
12666	2023-02-11 15:09:48.687239+00	2023-02-11 15:09:48.687257+00		5	\N	5	558
12667	2023-02-11 15:09:48.68943+00	2023-02-11 15:09:48.689448+00		3	\N	6	558
12668	2023-02-11 15:09:48.691576+00	2023-02-11 15:09:48.691596+00		5	\N	7	558
12669	2023-02-11 15:09:48.693793+00	2023-02-11 15:09:48.693811+00		5	\N	8	558
12670	2023-02-11 15:09:48.69604+00	2023-02-11 15:09:48.696058+00		5	\N	9	558
12671	2023-02-11 15:09:48.698156+00	2023-02-11 15:09:48.698175+00		1	\N	10	558
12672	2023-02-11 15:09:48.700289+00	2023-02-11 15:09:48.700318+00		1	\N	11	558
12673	2023-02-11 15:09:48.70329+00	2023-02-11 15:09:48.70331+00		5	\N	12	558
12674	2023-02-11 15:09:48.705939+00	2023-02-11 15:09:48.705972+00		1	\N	13	558
12675	2023-02-11 15:09:48.708316+00	2023-02-11 15:09:48.70834+00		1	\N	14	558
12676	2023-02-11 15:09:48.710814+00	2023-02-11 15:09:48.710833+00		5	\N	15	558
12677	2023-02-11 15:09:48.712817+00	2023-02-11 15:09:48.712837+00		5	\N	16	558
12678	2023-02-11 15:09:48.714985+00	2023-02-11 15:09:48.715005+00		1	\N	17	558
12679	2023-02-11 15:09:48.717214+00	2023-02-11 15:09:48.717243+00		5	\N	18	558
12680	2023-02-11 15:09:48.719671+00	2023-02-11 15:09:48.71969+00		1	\N	19	558
12681	2023-02-11 15:09:48.721782+00	2023-02-11 15:09:48.721802+00		4	\N	20	558
12682	2023-02-11 15:09:48.723862+00	2023-02-11 15:09:48.723881+00		5	\N	21	558
12683	2023-02-11 15:09:48.726043+00	2023-02-11 15:09:48.726061+00		1	\N	22	558
12684	2023-02-11 15:09:48.728333+00	2023-02-11 15:09:48.728354+00		5	\N	23	558
12685	2023-02-11 15:09:48.730607+00	2023-02-11 15:09:48.730625+00		5	\N	24	558
12686	2023-02-11 15:09:48.733042+00	2023-02-11 15:09:48.733061+00		1	\N	25	558
12687	2023-02-11 15:09:48.735707+00	2023-02-11 15:09:48.735729+00		5	\N	26	558
12688	2023-02-11 15:09:48.738266+00	2023-02-11 15:09:48.738286+00		5	\N	27	558
12689	2023-02-11 15:09:48.740737+00	2023-02-11 15:09:48.740761+00		5	\N	28	558
12690	2023-02-11 15:09:48.742994+00	2023-02-11 15:09:48.743013+00		5	\N	29	558
12691	2023-02-11 15:09:48.745316+00	2023-02-11 15:09:48.745336+00		5	\N	30	558
12692	2023-02-11 15:09:48.747542+00	2023-02-11 15:09:48.747563+00		5	\N	31	558
12693	2023-02-11 15:09:48.74997+00	2023-02-11 15:09:48.749992+00		5	\N	32	558
12694	2023-02-11 15:09:48.752997+00	2023-02-11 15:09:48.753018+00		5	\N	33	558
12695	2023-02-11 15:09:48.755074+00	2023-02-11 15:09:48.755119+00		5	\N	34	558
12696	2023-02-11 15:09:48.757169+00	2023-02-11 15:09:48.757189+00		5	\N	35	558
12697	2023-02-11 15:09:48.759441+00	2023-02-11 15:09:48.759462+00		1	\N	36	558
12698	2023-02-11 15:09:48.761676+00	2023-02-11 15:09:48.761703+00		1	\N	37	558
12699	2023-02-11 15:09:48.764285+00	2023-02-11 15:09:48.764311+00		3	\N	38	558
12700	2023-02-11 15:09:48.766391+00	2023-02-11 15:09:48.766411+00		5	\N	39	558
12701	2023-02-11 15:09:48.769118+00	2023-02-11 15:09:48.769139+00		1	\N	40	558
12702	2023-02-11 15:09:48.771303+00	2023-02-11 15:09:48.771322+00		1	\N	41	558
12703	2023-02-11 15:09:48.773383+00	2023-02-11 15:09:48.773409+00		5	\N	42	558
12704	2023-02-11 15:09:48.775614+00	2023-02-11 15:09:48.775633+00		1	\N	43	558
12705	2023-02-11 15:09:48.777835+00	2023-02-11 15:09:48.777857+00		5	\N	44	558
12706	2023-02-11 15:09:48.780883+00	2023-02-11 15:09:48.780905+00		1	\N	45	558
12707	2023-02-11 15:09:48.783331+00	2023-02-11 15:09:48.783351+00		1	\N	46	558
12708	2023-02-11 15:09:48.786647+00	2023-02-11 15:09:48.78667+00		1	\N	47	558
12709	2023-02-11 15:09:48.789028+00	2023-02-11 15:09:48.789075+00		5	\N	48	558
12710	2023-02-11 15:09:48.791707+00	2023-02-11 15:09:48.791737+00		5	\N	49	558
12711	2023-02-11 15:09:48.794112+00	2023-02-11 15:09:48.794133+00		1	\N	50	558
12712	2023-02-11 15:09:48.796389+00	2023-02-11 15:09:48.79641+00		1	\N	51	558
12713	2023-02-11 15:09:48.798534+00	2023-02-11 15:09:48.798573+00		1	\N	52	558
12714	2023-02-11 15:09:48.800987+00	2023-02-11 15:09:48.80102+00		1	\N	53	558
12715	2023-02-11 15:09:48.803955+00	2023-02-11 15:09:48.803974+00		1	\N	54	558
12716	2023-02-11 15:09:48.806278+00	2023-02-11 15:09:48.806297+00		1	\N	55	558
12717	2023-02-11 15:09:48.80887+00	2023-02-11 15:09:48.80889+00		5	\N	56	558
12718	2023-02-11 15:09:48.812266+00	2023-02-11 15:09:48.812289+00		1	\N	57	558
12719	2023-02-11 15:09:48.814754+00	2023-02-11 15:09:48.814774+00		1	\N	58	558
12720	2023-02-11 15:09:48.817624+00	2023-02-11 15:09:48.817669+00		1	\N	59	558
12721	2023-02-11 15:09:48.820891+00	2023-02-11 15:09:48.820911+00		1	\N	60	558
12722	2023-02-11 15:09:48.823561+00	2023-02-11 15:09:48.823581+00		1	\N	61	558
12723	2023-02-11 15:09:48.825961+00	2023-02-11 15:09:48.825983+00		1	\N	62	558
12724	2023-02-11 15:09:48.828389+00	2023-02-11 15:09:48.82841+00		1	\N	63	558
12725	2023-02-11 15:09:48.83078+00	2023-02-11 15:09:48.8308+00		3	\N	64	558
12726	2023-02-11 15:09:48.83315+00	2023-02-11 15:09:48.833169+00		1	\N	65	558
12727	2023-02-11 15:09:48.836142+00	2023-02-11 15:09:48.836162+00		1	\N	66	558
12728	2023-02-11 15:09:48.838831+00	2023-02-11 15:09:48.838852+00		1	\N	67	558
12729	2023-02-11 15:09:48.841384+00	2023-02-11 15:09:48.841403+00		1	\N	68	558
12730	2023-02-11 15:09:48.843839+00	2023-02-11 15:09:48.843863+00		1	\N	69	558
12731	2023-02-11 15:09:48.846263+00	2023-02-11 15:09:48.846282+00		1	\N	70	558
12732	2023-02-11 15:09:48.848781+00	2023-02-11 15:09:48.848803+00		1	\N	71	558
12733	2023-02-11 15:09:48.893891+00	2023-02-11 15:09:48.893911+00		3	\N	1	559
12734	2023-02-11 15:09:48.896727+00	2023-02-11 15:09:48.896746+00		3	\N	2	559
12735	2023-02-11 15:09:48.899808+00	2023-02-11 15:09:48.899827+00		3	\N	3	559
12736	2023-02-11 15:09:48.902734+00	2023-02-11 15:09:48.902789+00		3	\N	4	559
12737	2023-02-11 15:09:48.905225+00	2023-02-11 15:09:48.905247+00		3	\N	5	559
12738	2023-02-11 15:09:48.907651+00	2023-02-11 15:09:48.907668+00		3	\N	6	559
12739	2023-02-11 15:09:48.910271+00	2023-02-11 15:09:48.910295+00		3	\N	7	559
12740	2023-02-11 15:09:48.91256+00	2023-02-11 15:09:48.912578+00		3	\N	8	559
12741	2023-02-11 15:09:48.915225+00	2023-02-11 15:09:48.915257+00		4	\N	9	559
12742	2023-02-11 15:09:48.920136+00	2023-02-11 15:09:48.920155+00		3	\N	10	559
12743	2023-02-11 15:09:48.922778+00	2023-02-11 15:09:48.922797+00		4	\N	11	559
12744	2023-02-11 15:09:48.925214+00	2023-02-11 15:09:48.925233+00		4	\N	12	559
12745	2023-02-11 15:09:48.927525+00	2023-02-11 15:09:48.927544+00		3	\N	13	559
12746	2023-02-11 15:09:48.929931+00	2023-02-11 15:09:48.929959+00		4	\N	14	559
12747	2023-02-11 15:09:48.932439+00	2023-02-11 15:09:48.932479+00		2	\N	15	559
12748	2023-02-11 15:09:48.935318+00	2023-02-11 15:09:48.935339+00		3	\N	16	559
12749	2023-02-11 15:09:48.937677+00	2023-02-11 15:09:48.937696+00		4	\N	17	559
12750	2023-02-11 15:09:48.939763+00	2023-02-11 15:09:48.939781+00		2	\N	18	559
12751	2023-02-11 15:09:48.941948+00	2023-02-11 15:09:48.941968+00		3	\N	19	559
12752	2023-02-11 15:09:48.944177+00	2023-02-11 15:09:48.944195+00		4	\N	20	559
12753	2023-02-11 15:09:48.946684+00	2023-02-11 15:09:48.946703+00		4	\N	21	559
12754	2023-02-11 15:09:48.948955+00	2023-02-11 15:09:48.948973+00		4	\N	22	559
12755	2023-02-11 15:09:48.9519+00	2023-02-11 15:09:48.951935+00		4	\N	23	559
12756	2023-02-11 15:09:48.954277+00	2023-02-11 15:09:48.954297+00		3	\N	24	559
12757	2023-02-11 15:09:48.956777+00	2023-02-11 15:09:48.956796+00		3	\N	25	559
12758	2023-02-11 15:09:48.959071+00	2023-02-11 15:09:48.95909+00		4	\N	26	559
12759	2023-02-11 15:09:48.961562+00	2023-02-11 15:09:48.961581+00		3	\N	27	559
12760	2023-02-11 15:09:48.964149+00	2023-02-11 15:09:48.964173+00		3	\N	28	559
12761	2023-02-11 15:09:48.966717+00	2023-02-11 15:09:48.966736+00		3	\N	29	559
12762	2023-02-11 15:09:48.969928+00	2023-02-11 15:09:48.969947+00		3	\N	30	559
12763	2023-02-11 15:09:48.972483+00	2023-02-11 15:09:48.972501+00		3	\N	31	559
12764	2023-02-11 15:09:48.975314+00	2023-02-11 15:09:48.975339+00		1	\N	32	559
12765	2023-02-11 15:09:48.977838+00	2023-02-11 15:09:48.977858+00		5	\N	33	559
12766	2023-02-11 15:09:48.980387+00	2023-02-11 15:09:48.980405+00		5	\N	34	559
12767	2023-02-11 15:09:48.982667+00	2023-02-11 15:09:48.982685+00		5	\N	35	559
12768	2023-02-11 15:09:48.986098+00	2023-02-11 15:09:48.986126+00		1	\N	36	559
12769	2023-02-11 15:09:48.988397+00	2023-02-11 15:09:48.988418+00		1	\N	37	559
12770	2023-02-11 15:09:48.991168+00	2023-02-11 15:09:48.991188+00		3	\N	38	559
12771	2023-02-11 15:09:48.996353+00	2023-02-11 15:09:48.996397+00		3	\N	39	559
12772	2023-02-11 15:09:48.998707+00	2023-02-11 15:09:48.998727+00		1	\N	40	559
12773	2023-02-11 15:09:49.001584+00	2023-02-11 15:09:49.001608+00		3	\N	41	559
12774	2023-02-11 15:09:49.00427+00	2023-02-11 15:09:49.004295+00		4	\N	42	559
12775	2023-02-11 15:09:49.006685+00	2023-02-11 15:09:49.006704+00		3	\N	43	559
12776	2023-02-11 15:09:49.009211+00	2023-02-11 15:09:49.00923+00		4	\N	44	559
12777	2023-02-11 15:09:49.011629+00	2023-02-11 15:09:49.011648+00		1	\N	45	559
12778	2023-02-11 15:09:49.013879+00	2023-02-11 15:09:49.013897+00		3	\N	46	559
12779	2023-02-11 15:09:49.016329+00	2023-02-11 15:09:49.016349+00		3	\N	47	559
12780	2023-02-11 15:09:49.019265+00	2023-02-11 15:09:49.019284+00		3	\N	48	559
12781	2023-02-11 15:09:49.021967+00	2023-02-11 15:09:49.021986+00		1	\N	49	559
12782	2023-02-11 15:09:49.024516+00	2023-02-11 15:09:49.024539+00		3	\N	50	559
12783	2023-02-11 15:09:49.027154+00	2023-02-11 15:09:49.027173+00		1	\N	51	559
12784	2023-02-11 15:09:49.029555+00	2023-02-11 15:09:49.029582+00		3	\N	52	559
12785	2023-02-11 15:09:49.031908+00	2023-02-11 15:09:49.031929+00		3	\N	53	559
12786	2023-02-11 15:09:49.034922+00	2023-02-11 15:09:49.034945+00		3	\N	54	559
12787	2023-02-11 15:09:49.037714+00	2023-02-11 15:09:49.037737+00		4	\N	55	559
12788	2023-02-11 15:09:49.040029+00	2023-02-11 15:09:49.040049+00		2	\N	56	559
12789	2023-02-11 15:09:49.042303+00	2023-02-11 15:09:49.042323+00		3	\N	57	559
12790	2023-02-11 15:09:49.044641+00	2023-02-11 15:09:49.044659+00		3	\N	58	559
12791	2023-02-11 15:09:49.046756+00	2023-02-11 15:09:49.046776+00		1	\N	59	559
12792	2023-02-11 15:09:49.048855+00	2023-02-11 15:09:49.048874+00		3	\N	60	559
12793	2023-02-11 15:09:49.051693+00	2023-02-11 15:09:49.051728+00		4	\N	61	559
12794	2023-02-11 15:09:49.054658+00	2023-02-11 15:09:49.054703+00		4	\N	62	559
12795	2023-02-11 15:09:49.057055+00	2023-02-11 15:09:49.057074+00		3	\N	63	559
12796	2023-02-11 15:09:49.059555+00	2023-02-11 15:09:49.059574+00		3	\N	64	559
12797	2023-02-11 15:09:49.061918+00	2023-02-11 15:09:49.061941+00		3	\N	65	559
12798	2023-02-11 15:09:49.064295+00	2023-02-11 15:09:49.064315+00		1	\N	66	559
12799	2023-02-11 15:09:49.066608+00	2023-02-11 15:09:49.066627+00		3	\N	67	559
12800	2023-02-11 15:09:49.070107+00	2023-02-11 15:09:49.070127+00		3	\N	68	559
12801	2023-02-11 15:09:49.072601+00	2023-02-11 15:09:49.072627+00		1	\N	69	559
12802	2023-02-11 15:09:49.075281+00	2023-02-11 15:09:49.075301+00		1	\N	70	559
12803	2023-02-11 15:09:49.077895+00	2023-02-11 15:09:49.077914+00		1	\N	71	559
12804	2023-02-11 15:09:49.119467+00	2023-02-11 15:09:49.119488+00		4	\N	1	560
12805	2023-02-11 15:09:49.121826+00	2023-02-11 15:09:49.121845+00		4	\N	2	560
12806	2023-02-11 15:09:49.124007+00	2023-02-11 15:09:49.124026+00		1	\N	3	560
12807	2023-02-11 15:09:49.126375+00	2023-02-11 15:09:49.126395+00		4	\N	4	560
12808	2023-02-11 15:09:49.128669+00	2023-02-11 15:09:49.12869+00		4	\N	5	560
12809	2023-02-11 15:09:49.133763+00	2023-02-11 15:09:49.133789+00		4	\N	6	560
12810	2023-02-11 15:09:49.136816+00	2023-02-11 15:09:49.136835+00		4	\N	7	560
12811	2023-02-11 15:09:49.139386+00	2023-02-11 15:09:49.139406+00		4	\N	8	560
12812	2023-02-11 15:09:49.141792+00	2023-02-11 15:09:49.141811+00		4	\N	9	560
12813	2023-02-11 15:09:49.144309+00	2023-02-11 15:09:49.144336+00		3	\N	10	560
12814	2023-02-11 15:09:49.146794+00	2023-02-11 15:09:49.146813+00		3	\N	11	560
12815	2023-02-11 15:09:49.149189+00	2023-02-11 15:09:49.14921+00		4	\N	12	560
12816	2023-02-11 15:09:49.152116+00	2023-02-11 15:09:49.152137+00		1	\N	13	560
12817	2023-02-11 15:09:49.154563+00	2023-02-11 15:09:49.154584+00		4	\N	14	560
12818	2023-02-11 15:09:49.156804+00	2023-02-11 15:09:49.156823+00		4	\N	15	560
12819	2023-02-11 15:09:49.159068+00	2023-02-11 15:09:49.159086+00		4	\N	16	560
12820	2023-02-11 15:09:49.161409+00	2023-02-11 15:09:49.161428+00		4	\N	17	560
12821	2023-02-11 15:09:49.163696+00	2023-02-11 15:09:49.163715+00		5	\N	18	560
12822	2023-02-11 15:09:49.166037+00	2023-02-11 15:09:49.166056+00		4	\N	19	560
12823	2023-02-11 15:09:49.169448+00	2023-02-11 15:09:49.169468+00		1	\N	20	560
12824	2023-02-11 15:09:49.171747+00	2023-02-11 15:09:49.171771+00		4	\N	21	560
12825	2023-02-11 15:09:49.174104+00	2023-02-11 15:09:49.17413+00		4	\N	22	560
12826	2023-02-11 15:09:49.17685+00	2023-02-11 15:09:49.176869+00		5	\N	23	560
12827	2023-02-11 15:09:49.179383+00	2023-02-11 15:09:49.17941+00		5	\N	24	560
12828	2023-02-11 15:09:49.181715+00	2023-02-11 15:09:49.181736+00		3	\N	25	560
12829	2023-02-11 15:09:49.184695+00	2023-02-11 15:09:49.184718+00		1	\N	26	560
12830	2023-02-11 15:09:49.187403+00	2023-02-11 15:09:49.187423+00		3	\N	27	560
12831	2023-02-11 15:09:49.189966+00	2023-02-11 15:09:49.190023+00		3	\N	28	560
12832	2023-02-11 15:09:49.192622+00	2023-02-11 15:09:49.192641+00		4	\N	29	560
12833	2023-02-11 15:09:49.195236+00	2023-02-11 15:09:49.195264+00		4	\N	30	560
12834	2023-02-11 15:09:49.197528+00	2023-02-11 15:09:49.197567+00		1	\N	31	560
12835	2023-02-11 15:09:49.200088+00	2023-02-11 15:09:49.200129+00		4	\N	32	560
12836	2023-02-11 15:09:49.203166+00	2023-02-11 15:09:49.203222+00		4	\N	33	560
12837	2023-02-11 15:09:49.206155+00	2023-02-11 15:09:49.206181+00		5	\N	34	560
12838	2023-02-11 15:09:49.209707+00	2023-02-11 15:09:49.20973+00		3	\N	35	560
12839	2023-02-11 15:09:49.212217+00	2023-02-11 15:09:49.212235+00		1	\N	36	560
12840	2023-02-11 15:09:49.214698+00	2023-02-11 15:09:49.214718+00		4	\N	37	560
12841	2023-02-11 15:09:49.217252+00	2023-02-11 15:09:49.217281+00		1	\N	38	560
12842	2023-02-11 15:09:49.220227+00	2023-02-11 15:09:49.220247+00		4	\N	39	560
12843	2023-02-11 15:09:49.222886+00	2023-02-11 15:09:49.222907+00		1	\N	40	560
12844	2023-02-11 15:09:49.225476+00	2023-02-11 15:09:49.225495+00		1	\N	41	560
12845	2023-02-11 15:09:49.227893+00	2023-02-11 15:09:49.227912+00		3	\N	42	560
12846	2023-02-11 15:09:49.23028+00	2023-02-11 15:09:49.230299+00		3	\N	43	560
12847	2023-02-11 15:09:49.232666+00	2023-02-11 15:09:49.232724+00		5	\N	44	560
12848	2023-02-11 15:09:49.235947+00	2023-02-11 15:09:49.235974+00		3	\N	45	560
12849	2023-02-11 15:09:49.239382+00	2023-02-11 15:09:49.239403+00		3	\N	46	560
12850	2023-02-11 15:09:49.241776+00	2023-02-11 15:09:49.241795+00		1	\N	47	560
12851	2023-02-11 15:09:49.244124+00	2023-02-11 15:09:49.244142+00		3	\N	48	560
12852	2023-02-11 15:09:49.246486+00	2023-02-11 15:09:49.246504+00		4	\N	49	560
12853	2023-02-11 15:09:49.24888+00	2023-02-11 15:09:49.248899+00		1	\N	50	560
12854	2023-02-11 15:09:49.251788+00	2023-02-11 15:09:49.251819+00		1	\N	51	560
12855	2023-02-11 15:09:49.25457+00	2023-02-11 15:09:49.254598+00		3	\N	52	560
12856	2023-02-11 15:09:49.256868+00	2023-02-11 15:09:49.256886+00		3	\N	53	560
12857	2023-02-11 15:09:49.259102+00	2023-02-11 15:09:49.259127+00		4	\N	54	560
12858	2023-02-11 15:09:49.26143+00	2023-02-11 15:09:49.26145+00		5	\N	55	560
12859	2023-02-11 15:09:49.263687+00	2023-02-11 15:09:49.263705+00		4	\N	56	560
12860	2023-02-11 15:09:49.265936+00	2023-02-11 15:09:49.265955+00		4	\N	57	560
12861	2023-02-11 15:09:49.269088+00	2023-02-11 15:09:49.269108+00		1	\N	58	560
12862	2023-02-11 15:09:49.271502+00	2023-02-11 15:09:49.271522+00		1	\N	59	560
12863	2023-02-11 15:09:49.273864+00	2023-02-11 15:09:49.273882+00		3	\N	60	560
12864	2023-02-11 15:09:49.276294+00	2023-02-11 15:09:49.276322+00		4	\N	61	560
12865	2023-02-11 15:09:49.278774+00	2023-02-11 15:09:49.278793+00		4	\N	62	560
12866	2023-02-11 15:09:49.281105+00	2023-02-11 15:09:49.281124+00		1	\N	63	560
12867	2023-02-11 15:09:49.283296+00	2023-02-11 15:09:49.283315+00		1	\N	64	560
12868	2023-02-11 15:09:49.28628+00	2023-02-11 15:09:49.286305+00		1	\N	65	560
12869	2023-02-11 15:09:49.288882+00	2023-02-11 15:09:49.288902+00		1	\N	66	560
12870	2023-02-11 15:09:49.291096+00	2023-02-11 15:09:49.291114+00		1	\N	67	560
12871	2023-02-11 15:09:49.293367+00	2023-02-11 15:09:49.293385+00		1	\N	68	560
12872	2023-02-11 15:09:49.295626+00	2023-02-11 15:09:49.295644+00		1	\N	69	560
12873	2023-02-11 15:09:49.298046+00	2023-02-11 15:09:49.298064+00		1	\N	70	560
12874	2023-02-11 15:09:49.300432+00	2023-02-11 15:09:49.300463+00		1	\N	71	560
12875	2023-02-11 15:09:49.340589+00	2023-02-11 15:09:49.340628+00		1	\N	1	561
12876	2023-02-11 15:09:49.342804+00	2023-02-11 15:09:49.34283+00		1	\N	2	561
12877	2023-02-11 15:09:49.346673+00	2023-02-11 15:09:49.3467+00		1	\N	3	561
12878	2023-02-11 15:09:49.349041+00	2023-02-11 15:09:49.34906+00		1	\N	4	561
12879	2023-02-11 15:09:49.35194+00	2023-02-11 15:09:49.351966+00		1	\N	5	561
12880	2023-02-11 15:09:49.354753+00	2023-02-11 15:09:49.354772+00		1	\N	6	561
12881	2023-02-11 15:09:49.357059+00	2023-02-11 15:09:49.357078+00		1	\N	7	561
12882	2023-02-11 15:09:49.359395+00	2023-02-11 15:09:49.359415+00		1	\N	8	561
12883	2023-02-11 15:09:49.361912+00	2023-02-11 15:09:49.361963+00		1	\N	9	561
12884	2023-02-11 15:09:49.36423+00	2023-02-11 15:09:49.364248+00		1	\N	10	561
12885	2023-02-11 15:09:49.36665+00	2023-02-11 15:09:49.366671+00		1	\N	11	561
12886	2023-02-11 15:09:49.369848+00	2023-02-11 15:09:49.369866+00		1	\N	12	561
12887	2023-02-11 15:09:49.372203+00	2023-02-11 15:09:49.372222+00		1	\N	13	561
12888	2023-02-11 15:09:49.374501+00	2023-02-11 15:09:49.37452+00		1	\N	14	561
12889	2023-02-11 15:09:49.376862+00	2023-02-11 15:09:49.376885+00		1	\N	15	561
12890	2023-02-11 15:09:49.379254+00	2023-02-11 15:09:49.379309+00		1	\N	16	561
12891	2023-02-11 15:09:49.381653+00	2023-02-11 15:09:49.381673+00		1	\N	17	561
12892	2023-02-11 15:09:49.384128+00	2023-02-11 15:09:49.384159+00		1	\N	18	561
12893	2023-02-11 15:09:49.386899+00	2023-02-11 15:09:49.386918+00		1	\N	19	561
12894	2023-02-11 15:09:49.389434+00	2023-02-11 15:09:49.389454+00		1	\N	20	561
12895	2023-02-11 15:09:49.392066+00	2023-02-11 15:09:49.392085+00		1	\N	21	561
12896	2023-02-11 15:09:49.394397+00	2023-02-11 15:09:49.394417+00		1	\N	22	561
12897	2023-02-11 15:09:49.396838+00	2023-02-11 15:09:49.396856+00		1	\N	23	561
12898	2023-02-11 15:09:49.399238+00	2023-02-11 15:09:49.399263+00		1	\N	24	561
12899	2023-02-11 15:09:49.40237+00	2023-02-11 15:09:49.402395+00		1	\N	25	561
12900	2023-02-11 15:09:49.404974+00	2023-02-11 15:09:49.405001+00		1	\N	26	561
12901	2023-02-11 15:09:49.407393+00	2023-02-11 15:09:49.407477+00		1	\N	27	561
12902	2023-02-11 15:09:49.409831+00	2023-02-11 15:09:49.409852+00		1	\N	28	561
12903	2023-02-11 15:09:49.412096+00	2023-02-11 15:09:49.412116+00		1	\N	29	561
12904	2023-02-11 15:09:49.414062+00	2023-02-11 15:09:49.414081+00		1	\N	30	561
12905	2023-02-11 15:09:49.416368+00	2023-02-11 15:09:49.416387+00		1	\N	31	561
12906	2023-02-11 15:09:49.419243+00	2023-02-11 15:09:49.419265+00		1	\N	32	561
12907	2023-02-11 15:09:49.423127+00	2023-02-11 15:09:49.423146+00		1	\N	33	561
12908	2023-02-11 15:09:49.425375+00	2023-02-11 15:09:49.425395+00		1	\N	34	561
12909	2023-02-11 15:09:49.427884+00	2023-02-11 15:09:49.427908+00		1	\N	35	561
12910	2023-02-11 15:09:49.430179+00	2023-02-11 15:09:49.430205+00		1	\N	36	561
12911	2023-02-11 15:09:49.432744+00	2023-02-11 15:09:49.432763+00		1	\N	37	561
12912	2023-02-11 15:09:49.436299+00	2023-02-11 15:09:49.43632+00		1	\N	38	561
12913	2023-02-11 15:09:49.438847+00	2023-02-11 15:09:49.438871+00		1	\N	39	561
12914	2023-02-11 15:09:49.441299+00	2023-02-11 15:09:49.441317+00		1	\N	40	561
12915	2023-02-11 15:09:49.443908+00	2023-02-11 15:09:49.443927+00		1	\N	41	561
12916	2023-02-11 15:09:49.446506+00	2023-02-11 15:09:49.446525+00		1	\N	42	561
12917	2023-02-11 15:09:49.448839+00	2023-02-11 15:09:49.448878+00		1	\N	43	561
12918	2023-02-11 15:09:49.452035+00	2023-02-11 15:09:49.452062+00		1	\N	44	561
12919	2023-02-11 15:09:49.454489+00	2023-02-11 15:09:49.454509+00		1	\N	45	561
12920	2023-02-11 15:09:49.456892+00	2023-02-11 15:09:49.456919+00		1	\N	46	561
12921	2023-02-11 15:09:49.459401+00	2023-02-11 15:09:49.45942+00		1	\N	47	561
12922	2023-02-11 15:09:49.461909+00	2023-02-11 15:09:49.461951+00		1	\N	48	561
12923	2023-02-11 15:09:49.464355+00	2023-02-11 15:09:49.464375+00		1	\N	49	561
12924	2023-02-11 15:09:49.467067+00	2023-02-11 15:09:49.467097+00		1	\N	50	561
12925	2023-02-11 15:09:49.470147+00	2023-02-11 15:09:49.470168+00		1	\N	51	561
12926	2023-02-11 15:09:49.472638+00	2023-02-11 15:09:49.472657+00		1	\N	52	561
12927	2023-02-11 15:09:49.475009+00	2023-02-11 15:09:49.475039+00		1	\N	53	561
12928	2023-02-11 15:09:49.477442+00	2023-02-11 15:09:49.477461+00		1	\N	54	561
12929	2023-02-11 15:09:49.47987+00	2023-02-11 15:09:49.479888+00		1	\N	55	561
12930	2023-02-11 15:09:49.482565+00	2023-02-11 15:09:49.482583+00		1	\N	56	561
12931	2023-02-11 15:09:49.486018+00	2023-02-11 15:09:49.486039+00		1	\N	57	561
12932	2023-02-11 15:09:49.488957+00	2023-02-11 15:09:49.488976+00		1	\N	58	561
12933	2023-02-11 15:09:49.491288+00	2023-02-11 15:09:49.491309+00		1	\N	59	561
12934	2023-02-11 15:09:49.493541+00	2023-02-11 15:09:49.493559+00		1	\N	60	561
12935	2023-02-11 15:09:49.495873+00	2023-02-11 15:09:49.495896+00		1	\N	61	561
12936	2023-02-11 15:09:49.49845+00	2023-02-11 15:09:49.498471+00		1	\N	62	561
12937	2023-02-11 15:09:49.500843+00	2023-02-11 15:09:49.500869+00		1	\N	63	561
12938	2023-02-11 15:09:49.503756+00	2023-02-11 15:09:49.503777+00		1	\N	64	561
12939	2023-02-11 15:09:49.506123+00	2023-02-11 15:09:49.506146+00		1	\N	65	561
12940	2023-02-11 15:09:49.5086+00	2023-02-11 15:09:49.508619+00		1	\N	66	561
12941	2023-02-11 15:09:49.511014+00	2023-02-11 15:09:49.511033+00		1	\N	67	561
12942	2023-02-11 15:09:49.513318+00	2023-02-11 15:09:49.513343+00		1	\N	68	561
12943	2023-02-11 15:09:49.515493+00	2023-02-11 15:09:49.515511+00		1	\N	69	561
12944	2023-02-11 15:09:49.518343+00	2023-02-11 15:09:49.518364+00		1	\N	70	561
12945	2023-02-11 15:09:49.520865+00	2023-02-11 15:09:49.520885+00		1	\N	71	561
12946	2023-02-11 15:09:49.56092+00	2023-02-11 15:09:49.560939+00		4	\N	1	562
12947	2023-02-11 15:09:49.563461+00	2023-02-11 15:09:49.563481+00		3	\N	2	562
12948	2023-02-11 15:09:49.565656+00	2023-02-11 15:09:49.565676+00		4	\N	3	562
12949	2023-02-11 15:09:49.56802+00	2023-02-11 15:09:49.56804+00		3	\N	4	562
12950	2023-02-11 15:09:49.570573+00	2023-02-11 15:09:49.570592+00		3	\N	5	562
12951	2023-02-11 15:09:49.572918+00	2023-02-11 15:09:49.572938+00		4	\N	6	562
12952	2023-02-11 15:09:49.575859+00	2023-02-11 15:09:49.575878+00		3	\N	7	562
12953	2023-02-11 15:09:49.5782+00	2023-02-11 15:09:49.578219+00		3	\N	8	562
12954	2023-02-11 15:09:49.580587+00	2023-02-11 15:09:49.580607+00		3	\N	9	562
12955	2023-02-11 15:09:49.582843+00	2023-02-11 15:09:49.582863+00		3	\N	10	562
12956	2023-02-11 15:09:49.585459+00	2023-02-11 15:09:49.585481+00		4	\N	11	562
12957	2023-02-11 15:09:49.587929+00	2023-02-11 15:09:49.587949+00		3	\N	12	562
12958	2023-02-11 15:09:49.590255+00	2023-02-11 15:09:49.590275+00		4	\N	13	562
12959	2023-02-11 15:09:49.592981+00	2023-02-11 15:09:49.593001+00		4	\N	14	562
12960	2023-02-11 15:09:49.595207+00	2023-02-11 15:09:49.595227+00		4	\N	15	562
12961	2023-02-11 15:09:49.597388+00	2023-02-11 15:09:49.597406+00		4	\N	16	562
12962	2023-02-11 15:09:49.599741+00	2023-02-11 15:09:49.599759+00		5	\N	17	562
12963	2023-02-11 15:09:49.602408+00	2023-02-11 15:09:49.602436+00		4	\N	18	562
12964	2023-02-11 15:09:49.604644+00	2023-02-11 15:09:49.604663+00		4	\N	19	562
12965	2023-02-11 15:09:49.606889+00	2023-02-11 15:09:49.606914+00		3	\N	20	562
12966	2023-02-11 15:09:49.60934+00	2023-02-11 15:09:49.609359+00		3	\N	21	562
12967	2023-02-11 15:09:49.611715+00	2023-02-11 15:09:49.611735+00		4	\N	22	562
12968	2023-02-11 15:09:49.613828+00	2023-02-11 15:09:49.613846+00		3	\N	23	562
12969	2023-02-11 15:09:49.616069+00	2023-02-11 15:09:49.616087+00		3	\N	24	562
12970	2023-02-11 15:09:49.618779+00	2023-02-11 15:09:49.618808+00		4	\N	25	562
12971	2023-02-11 15:09:49.621416+00	2023-02-11 15:09:49.621443+00		5	\N	26	562
12972	2023-02-11 15:09:49.623972+00	2023-02-11 15:09:49.623992+00		3	\N	27	562
12973	2023-02-11 15:09:49.626299+00	2023-02-11 15:09:49.626318+00		3	\N	28	562
12974	2023-02-11 15:09:49.628404+00	2023-02-11 15:09:49.628424+00		3	\N	29	562
12975	2023-02-11 15:09:49.630575+00	2023-02-11 15:09:49.630595+00		3	\N	30	562
12976	2023-02-11 15:09:49.632879+00	2023-02-11 15:09:49.632898+00		3	\N	31	562
12977	2023-02-11 15:09:49.635755+00	2023-02-11 15:09:49.635775+00		3	\N	32	562
12978	2023-02-11 15:09:49.638318+00	2023-02-11 15:09:49.638345+00		3	\N	33	562
12979	2023-02-11 15:09:49.640772+00	2023-02-11 15:09:49.640791+00		3	\N	34	562
12980	2023-02-11 15:09:49.642796+00	2023-02-11 15:09:49.642815+00		3	\N	35	562
12981	2023-02-11 15:09:49.64482+00	2023-02-11 15:09:49.644839+00		3	\N	36	562
12982	2023-02-11 15:09:49.646981+00	2023-02-11 15:09:49.647+00		3	\N	37	562
12983	2023-02-11 15:09:49.649353+00	2023-02-11 15:09:49.649374+00		3	\N	38	562
12984	2023-02-11 15:09:49.652217+00	2023-02-11 15:09:49.652243+00		3	\N	39	562
12985	2023-02-11 15:09:49.654743+00	2023-02-11 15:09:49.654762+00		3	\N	40	562
12986	2023-02-11 15:09:49.656907+00	2023-02-11 15:09:49.656926+00		5	\N	41	562
12987	2023-02-11 15:09:49.659195+00	2023-02-11 15:09:49.659214+00		4	\N	42	562
12988	2023-02-11 15:09:49.661415+00	2023-02-11 15:09:49.661434+00		3	\N	43	562
12989	2023-02-11 15:09:49.663794+00	2023-02-11 15:09:49.663814+00		3	\N	44	562
12990	2023-02-11 15:09:49.666241+00	2023-02-11 15:09:49.66626+00		4	\N	45	562
12991	2023-02-11 15:09:49.669324+00	2023-02-11 15:09:49.669346+00		3	\N	46	562
12992	2023-02-11 15:09:49.671519+00	2023-02-11 15:09:49.671538+00		3	\N	47	562
12993	2023-02-11 15:09:49.673809+00	2023-02-11 15:09:49.673828+00		3	\N	48	562
12994	2023-02-11 15:09:49.676069+00	2023-02-11 15:09:49.676088+00		3	\N	49	562
12995	2023-02-11 15:09:49.67831+00	2023-02-11 15:09:49.678334+00		4	\N	50	562
12996	2023-02-11 15:09:49.68068+00	2023-02-11 15:09:49.6807+00		4	\N	51	562
12997	2023-02-11 15:09:49.682854+00	2023-02-11 15:09:49.682874+00		3	\N	52	562
12998	2023-02-11 15:09:49.685696+00	2023-02-11 15:09:49.685723+00		3	\N	53	562
12999	2023-02-11 15:09:49.68798+00	2023-02-11 15:09:49.687998+00		3	\N	54	562
13000	2023-02-11 15:09:49.690279+00	2023-02-11 15:09:49.690311+00		3	\N	55	562
13001	2023-02-11 15:09:49.692692+00	2023-02-11 15:09:49.692714+00		3	\N	56	562
13002	2023-02-11 15:09:49.6952+00	2023-02-11 15:09:49.69522+00		3	\N	57	562
13003	2023-02-11 15:09:49.697592+00	2023-02-11 15:09:49.697612+00		5	\N	58	562
13004	2023-02-11 15:09:49.700038+00	2023-02-11 15:09:49.700062+00		3	\N	59	562
13005	2023-02-11 15:09:49.702819+00	2023-02-11 15:09:49.702838+00		3	\N	60	562
13006	2023-02-11 15:09:49.705156+00	2023-02-11 15:09:49.705177+00		4	\N	61	562
13007	2023-02-11 15:09:49.707455+00	2023-02-11 15:09:49.707474+00		3	\N	62	562
13008	2023-02-11 15:09:49.709682+00	2023-02-11 15:09:49.709702+00		4	\N	63	562
13009	2023-02-11 15:09:49.711964+00	2023-02-11 15:09:49.712016+00		4	\N	64	562
13010	2023-02-11 15:09:49.714465+00	2023-02-11 15:09:49.714484+00		3	\N	65	562
13011	2023-02-11 15:09:49.716832+00	2023-02-11 15:09:49.716861+00		4	\N	66	562
13012	2023-02-11 15:09:49.720233+00	2023-02-11 15:09:49.720252+00		4	\N	67	562
13013	2023-02-11 15:09:49.722626+00	2023-02-11 15:09:49.722645+00		4	\N	68	562
13014	2023-02-11 15:09:49.725267+00	2023-02-11 15:09:49.725287+00		4	\N	69	562
13015	2023-02-11 15:09:49.727819+00	2023-02-11 15:09:49.727842+00		3	\N	70	562
13016	2023-02-11 15:09:49.730194+00	2023-02-11 15:09:49.730218+00		5	\N	71	562
13017	2023-02-11 15:09:49.76932+00	2023-02-11 15:09:49.76934+00		3	\N	1	563
13018	2023-02-11 15:09:49.771752+00	2023-02-11 15:09:49.771771+00		3	\N	2	563
13019	2023-02-11 15:09:49.774212+00	2023-02-11 15:09:49.77423+00		3	\N	3	563
13020	2023-02-11 15:09:49.776266+00	2023-02-11 15:09:49.776284+00		3	\N	4	563
13021	2023-02-11 15:09:49.778433+00	2023-02-11 15:09:49.778452+00		3	\N	5	563
13022	2023-02-11 15:09:49.780514+00	2023-02-11 15:09:49.780533+00		3	\N	6	563
13023	2023-02-11 15:09:49.782598+00	2023-02-11 15:09:49.782617+00		1	\N	7	563
13024	2023-02-11 15:09:49.784991+00	2023-02-11 15:09:49.785011+00		3	\N	8	563
13025	2023-02-11 15:09:49.787523+00	2023-02-11 15:09:49.787543+00		3	\N	9	563
13026	2023-02-11 15:09:49.789889+00	2023-02-11 15:09:49.789913+00		3	\N	10	563
13027	2023-02-11 15:09:49.792479+00	2023-02-11 15:09:49.792526+00		2	\N	11	563
13028	2023-02-11 15:09:49.794659+00	2023-02-11 15:09:49.794678+00		4	\N	12	563
13029	2023-02-11 15:09:49.797061+00	2023-02-11 15:09:49.797082+00		3	\N	13	563
13030	2023-02-11 15:09:49.799512+00	2023-02-11 15:09:49.799539+00		4	\N	14	563
13031	2023-02-11 15:09:49.802698+00	2023-02-11 15:09:49.802717+00		3	\N	15	563
13032	2023-02-11 15:09:49.805743+00	2023-02-11 15:09:49.805763+00		3	\N	16	563
13033	2023-02-11 15:09:49.808606+00	2023-02-11 15:09:49.808625+00		2	\N	17	563
13034	2023-02-11 15:09:49.81121+00	2023-02-11 15:09:49.811229+00		3	\N	18	563
13035	2023-02-11 15:09:49.814082+00	2023-02-11 15:09:49.8141+00		3	\N	19	563
13036	2023-02-11 15:09:49.817072+00	2023-02-11 15:09:49.8171+00		3	\N	20	563
13037	2023-02-11 15:09:49.820482+00	2023-02-11 15:09:49.820631+00		3	\N	21	563
13038	2023-02-11 15:09:49.823559+00	2023-02-11 15:09:49.823579+00		3	\N	22	563
13039	2023-02-11 15:09:49.826127+00	2023-02-11 15:09:49.826147+00		3	\N	23	563
13040	2023-02-11 15:09:49.828588+00	2023-02-11 15:09:49.828606+00		3	\N	24	563
13041	2023-02-11 15:09:49.831338+00	2023-02-11 15:09:49.83136+00		3	\N	25	563
13042	2023-02-11 15:09:49.834347+00	2023-02-11 15:09:49.834447+00		3	\N	26	563
13043	2023-02-11 15:09:49.837425+00	2023-02-11 15:09:49.837444+00		3	\N	27	563
13044	2023-02-11 15:09:49.840242+00	2023-02-11 15:09:49.840261+00		3	\N	28	563
13045	2023-02-11 15:09:49.843037+00	2023-02-11 15:09:49.843056+00		3	\N	29	563
13046	2023-02-11 15:09:49.845652+00	2023-02-11 15:09:49.845671+00		3	\N	30	563
13047	2023-02-11 15:09:49.848332+00	2023-02-11 15:09:49.848351+00		3	\N	31	563
13048	2023-02-11 15:09:49.851098+00	2023-02-11 15:09:49.851118+00		3	\N	32	563
13049	2023-02-11 15:09:49.85421+00	2023-02-11 15:09:49.85423+00		3	\N	33	563
13050	2023-02-11 15:09:49.857025+00	2023-02-11 15:09:49.857044+00		3	\N	34	563
13051	2023-02-11 15:09:49.859458+00	2023-02-11 15:09:49.859476+00		3	\N	35	563
13052	2023-02-11 15:09:49.86186+00	2023-02-11 15:09:49.861881+00		2	\N	36	563
13053	2023-02-11 15:09:49.864461+00	2023-02-11 15:09:49.864561+00		3	\N	37	563
13054	2023-02-11 15:09:49.867164+00	2023-02-11 15:09:49.867185+00		3	\N	38	563
13055	2023-02-11 15:09:49.870401+00	2023-02-11 15:09:49.87042+00		3	\N	39	563
13056	2023-02-11 15:09:49.87293+00	2023-02-11 15:09:49.872949+00		3	\N	40	563
13057	2023-02-11 15:09:49.875502+00	2023-02-11 15:09:49.875523+00		3	\N	41	563
13058	2023-02-11 15:09:49.878339+00	2023-02-11 15:09:49.878359+00		3	\N	42	563
13059	2023-02-11 15:09:49.881105+00	2023-02-11 15:09:49.881123+00		2	\N	43	563
13060	2023-02-11 15:09:49.883878+00	2023-02-11 15:09:49.883902+00		2	\N	44	563
13061	2023-02-11 15:09:49.887128+00	2023-02-11 15:09:49.887146+00		2	\N	45	563
13062	2023-02-11 15:09:49.889923+00	2023-02-11 15:09:49.889943+00		2	\N	46	563
13063	2023-02-11 15:09:49.89244+00	2023-02-11 15:09:49.89246+00		2	\N	47	563
13064	2023-02-11 15:09:49.895018+00	2023-02-11 15:09:49.895037+00		2	\N	48	563
13065	2023-02-11 15:09:49.897952+00	2023-02-11 15:09:49.897973+00		3	\N	49	563
13066	2023-02-11 15:09:49.900968+00	2023-02-11 15:09:49.901014+00		3	\N	50	563
13067	2023-02-11 15:09:49.903976+00	2023-02-11 15:09:49.903995+00		3	\N	51	563
13068	2023-02-11 15:09:49.906664+00	2023-02-11 15:09:49.906683+00		3	\N	52	563
13069	2023-02-11 15:09:49.909983+00	2023-02-11 15:09:49.910004+00		2	\N	53	563
13070	2023-02-11 15:09:49.912769+00	2023-02-11 15:09:49.912788+00		2	\N	54	563
13071	2023-02-11 15:09:49.915537+00	2023-02-11 15:09:49.915557+00		2	\N	55	563
13072	2023-02-11 15:09:49.918983+00	2023-02-11 15:09:49.919005+00		3	\N	56	563
13073	2023-02-11 15:09:49.921745+00	2023-02-11 15:09:49.921764+00		3	\N	57	563
13074	2023-02-11 15:09:49.924584+00	2023-02-11 15:09:49.924605+00		3	\N	58	563
13075	2023-02-11 15:09:49.927318+00	2023-02-11 15:09:49.927336+00		3	\N	59	563
13076	2023-02-11 15:09:49.930029+00	2023-02-11 15:09:49.93005+00		3	\N	60	563
13077	2023-02-11 15:09:49.933016+00	2023-02-11 15:09:49.933038+00		3	\N	61	563
13078	2023-02-11 15:09:49.936491+00	2023-02-11 15:09:49.93651+00		2	\N	62	563
13079	2023-02-11 15:09:49.939193+00	2023-02-11 15:09:49.939212+00		3	\N	63	563
13080	2023-02-11 15:09:49.942205+00	2023-02-11 15:09:49.942294+00		3	\N	64	563
13081	2023-02-11 15:09:49.945063+00	2023-02-11 15:09:49.945082+00		3	\N	65	563
13082	2023-02-11 15:09:49.947663+00	2023-02-11 15:09:49.947681+00		2	\N	66	563
13083	2023-02-11 15:09:49.950052+00	2023-02-11 15:09:49.950073+00		2	\N	67	563
13084	2023-02-11 15:09:49.956726+00	2023-02-11 15:09:49.956771+00		3	\N	68	563
13085	2023-02-11 15:09:49.95933+00	2023-02-11 15:09:49.959349+00		3	\N	69	563
13086	2023-02-11 15:09:49.961915+00	2023-02-11 15:09:49.961934+00		2	\N	70	563
13087	2023-02-11 15:09:49.964691+00	2023-02-11 15:09:49.964782+00		3	\N	71	563
13088	2023-02-11 15:09:50.004972+00	2023-02-11 15:09:50.004992+00		3	\N	1	564
13089	2023-02-11 15:09:50.007165+00	2023-02-11 15:09:50.007183+00		3	\N	2	564
13090	2023-02-11 15:09:50.009332+00	2023-02-11 15:09:50.00935+00		3	\N	3	564
13091	2023-02-11 15:09:50.011272+00	2023-02-11 15:09:50.01129+00		3	\N	4	564
13092	2023-02-11 15:09:50.01321+00	2023-02-11 15:09:50.013228+00		3	\N	5	564
13093	2023-02-11 15:09:50.015671+00	2023-02-11 15:09:50.01569+00		3	\N	6	564
13094	2023-02-11 15:09:50.018698+00	2023-02-11 15:09:50.018725+00		3	\N	7	564
13095	2023-02-11 15:09:50.02122+00	2023-02-11 15:09:50.021239+00		3	\N	8	564
13096	2023-02-11 15:09:50.023232+00	2023-02-11 15:09:50.023252+00		1	\N	9	564
13097	2023-02-11 15:09:50.025351+00	2023-02-11 15:09:50.025369+00		3	\N	10	564
13098	2023-02-11 15:09:50.027543+00	2023-02-11 15:09:50.027564+00		1	\N	11	564
13099	2023-02-11 15:09:50.029718+00	2023-02-11 15:09:50.029736+00		1	\N	12	564
13100	2023-02-11 15:09:50.032217+00	2023-02-11 15:09:50.032264+00		1	\N	13	564
13101	2023-02-11 15:09:50.035027+00	2023-02-11 15:09:50.035047+00		3	\N	14	564
13102	2023-02-11 15:09:50.037335+00	2023-02-11 15:09:50.037357+00		3	\N	15	564
13103	2023-02-11 15:09:50.039531+00	2023-02-11 15:09:50.039551+00		3	\N	16	564
13104	2023-02-11 15:09:50.041755+00	2023-02-11 15:09:50.041773+00		3	\N	17	564
13105	2023-02-11 15:09:50.044117+00	2023-02-11 15:09:50.044135+00		3	\N	18	564
13106	2023-02-11 15:09:50.04664+00	2023-02-11 15:09:50.046659+00		3	\N	19	564
13107	2023-02-11 15:09:50.04889+00	2023-02-11 15:09:50.048909+00		3	\N	20	564
13108	2023-02-11 15:09:50.051539+00	2023-02-11 15:09:50.05156+00		3	\N	21	564
13109	2023-02-11 15:09:50.054021+00	2023-02-11 15:09:50.05404+00		3	\N	22	564
13110	2023-02-11 15:09:50.056382+00	2023-02-11 15:09:50.056401+00		3	\N	23	564
13111	2023-02-11 15:09:50.058619+00	2023-02-11 15:09:50.05866+00		3	\N	24	564
13112	2023-02-11 15:09:50.061504+00	2023-02-11 15:09:50.061523+00		1	\N	25	564
13113	2023-02-11 15:09:50.063991+00	2023-02-11 15:09:50.064011+00		1	\N	26	564
13114	2023-02-11 15:09:50.066319+00	2023-02-11 15:09:50.066337+00		3	\N	27	564
13115	2023-02-11 15:09:50.069322+00	2023-02-11 15:09:50.069341+00		3	\N	28	564
13116	2023-02-11 15:09:50.071586+00	2023-02-11 15:09:50.071604+00		3	\N	29	564
13117	2023-02-11 15:09:50.07389+00	2023-02-11 15:09:50.073909+00		3	\N	30	564
13118	2023-02-11 15:09:50.076482+00	2023-02-11 15:09:50.076502+00		3	\N	31	564
13119	2023-02-11 15:09:50.078886+00	2023-02-11 15:09:50.078905+00		3	\N	32	564
13120	2023-02-11 15:09:50.081079+00	2023-02-11 15:09:50.081097+00		3	\N	33	564
13121	2023-02-11 15:09:50.083491+00	2023-02-11 15:09:50.08352+00		3	\N	34	564
13122	2023-02-11 15:09:50.086196+00	2023-02-11 15:09:50.086215+00		3	\N	35	564
13123	2023-02-11 15:09:50.088361+00	2023-02-11 15:09:50.088379+00		1	\N	36	564
13124	2023-02-11 15:09:50.091057+00	2023-02-11 15:09:50.091075+00		3	\N	37	564
13125	2023-02-11 15:09:50.093301+00	2023-02-11 15:09:50.09332+00		3	\N	38	564
13126	2023-02-11 15:09:50.095647+00	2023-02-11 15:09:50.095665+00		3	\N	39	564
13127	2023-02-11 15:09:50.098089+00	2023-02-11 15:09:50.098108+00		3	\N	40	564
13128	2023-02-11 15:09:50.100389+00	2023-02-11 15:09:50.100418+00		1	\N	41	564
13129	2023-02-11 15:09:50.103521+00	2023-02-11 15:09:50.10354+00		1	\N	42	564
13130	2023-02-11 15:09:50.105905+00	2023-02-11 15:09:50.105926+00		3	\N	43	564
13131	2023-02-11 15:09:50.108585+00	2023-02-11 15:09:50.108604+00		3	\N	44	564
13132	2023-02-11 15:09:50.110882+00	2023-02-11 15:09:50.110906+00		3	\N	45	564
13133	2023-02-11 15:09:50.112989+00	2023-02-11 15:09:50.113006+00		3	\N	46	564
13134	2023-02-11 15:09:50.115214+00	2023-02-11 15:09:50.115233+00		3	\N	47	564
13135	2023-02-11 15:09:50.117411+00	2023-02-11 15:09:50.117441+00		3	\N	48	564
13136	2023-02-11 15:09:50.120055+00	2023-02-11 15:09:50.120077+00		1	\N	49	564
13137	2023-02-11 15:09:50.122482+00	2023-02-11 15:09:50.122501+00		1	\N	50	564
13138	2023-02-11 15:09:50.124808+00	2023-02-11 15:09:50.124828+00		1	\N	51	564
13139	2023-02-11 15:09:50.127187+00	2023-02-11 15:09:50.127207+00		3	\N	52	564
13140	2023-02-11 15:09:50.129444+00	2023-02-11 15:09:50.129462+00		1	\N	53	564
13141	2023-02-11 15:09:50.13168+00	2023-02-11 15:09:50.131721+00		3	\N	54	564
13142	2023-02-11 15:09:50.134033+00	2023-02-11 15:09:50.134063+00		3	\N	55	564
13143	2023-02-11 15:09:50.137344+00	2023-02-11 15:09:50.137372+00		3	\N	56	564
13144	2023-02-11 15:09:50.139907+00	2023-02-11 15:09:50.139926+00		3	\N	57	564
13145	2023-02-11 15:09:50.142343+00	2023-02-11 15:09:50.142368+00		1	\N	58	564
13146	2023-02-11 15:09:50.144625+00	2023-02-11 15:09:50.144643+00		1	\N	59	564
13147	2023-02-11 15:09:50.146905+00	2023-02-11 15:09:50.146924+00		1	\N	60	564
13148	2023-02-11 15:09:50.149329+00	2023-02-11 15:09:50.149348+00		1	\N	61	564
13149	2023-02-11 15:09:50.152535+00	2023-02-11 15:09:50.152559+00		1	\N	62	564
13150	2023-02-11 15:09:50.155185+00	2023-02-11 15:09:50.155205+00		1	\N	63	564
13151	2023-02-11 15:09:50.157367+00	2023-02-11 15:09:50.157408+00		1	\N	64	564
13152	2023-02-11 15:09:50.159768+00	2023-02-11 15:09:50.159787+00		1	\N	65	564
13153	2023-02-11 15:09:50.161952+00	2023-02-11 15:09:50.16197+00		1	\N	66	564
13154	2023-02-11 15:09:50.164287+00	2023-02-11 15:09:50.164305+00		1	\N	67	564
13155	2023-02-11 15:09:50.16651+00	2023-02-11 15:09:50.166529+00		1	\N	68	564
13156	2023-02-11 15:09:50.169954+00	2023-02-11 15:09:50.169983+00		1	\N	69	564
13157	2023-02-11 15:09:50.172479+00	2023-02-11 15:09:50.172499+00		1	\N	70	564
13158	2023-02-11 15:09:50.174776+00	2023-02-11 15:09:50.174795+00		1	\N	71	564
13159	2023-02-11 15:09:50.215507+00	2023-02-11 15:09:50.215526+00		4	\N	1	565
13160	2023-02-11 15:09:50.218527+00	2023-02-11 15:09:50.218553+00		5	\N	2	565
13161	2023-02-11 15:09:50.220884+00	2023-02-11 15:09:50.220926+00		5	\N	3	565
13162	2023-02-11 15:09:50.223236+00	2023-02-11 15:09:50.223256+00		5	\N	4	565
13163	2023-02-11 15:09:50.22543+00	2023-02-11 15:09:50.225469+00		5	\N	5	565
13164	2023-02-11 15:09:50.227613+00	2023-02-11 15:09:50.227632+00		5	\N	6	565
13165	2023-02-11 15:09:50.230129+00	2023-02-11 15:09:50.230148+00		5	\N	7	565
13166	2023-02-11 15:09:50.232439+00	2023-02-11 15:09:50.232458+00		5	\N	8	565
13167	2023-02-11 15:09:50.235074+00	2023-02-11 15:09:50.235113+00		5	\N	9	565
13168	2023-02-11 15:09:50.237469+00	2023-02-11 15:09:50.237487+00		5	\N	10	565
13169	2023-02-11 15:09:50.239589+00	2023-02-11 15:09:50.239608+00		5	\N	11	565
13170	2023-02-11 15:09:50.241865+00	2023-02-11 15:09:50.241893+00		5	\N	12	565
13171	2023-02-11 15:09:50.244284+00	2023-02-11 15:09:50.244303+00		5	\N	13	565
13172	2023-02-11 15:09:50.246604+00	2023-02-11 15:09:50.246622+00		4	\N	14	565
13173	2023-02-11 15:09:50.248833+00	2023-02-11 15:09:50.248852+00		5	\N	15	565
13174	2023-02-11 15:09:50.251692+00	2023-02-11 15:09:50.251726+00		5	\N	16	565
13175	2023-02-11 15:09:50.254233+00	2023-02-11 15:09:50.254252+00		5	\N	17	565
13176	2023-02-11 15:09:50.256488+00	2023-02-11 15:09:50.256505+00		4	\N	18	565
13177	2023-02-11 15:09:50.258972+00	2023-02-11 15:09:50.258992+00		4	\N	19	565
13178	2023-02-11 15:09:50.261184+00	2023-02-11 15:09:50.261203+00		4	\N	20	565
13179	2023-02-11 15:09:50.263476+00	2023-02-11 15:09:50.263495+00		3	\N	21	565
13180	2023-02-11 15:09:50.265886+00	2023-02-11 15:09:50.265905+00		5	\N	22	565
13181	2023-02-11 15:09:50.268803+00	2023-02-11 15:09:50.268822+00		4	\N	23	565
13182	2023-02-11 15:09:50.271335+00	2023-02-11 15:09:50.271354+00		4	\N	24	565
13183	2023-02-11 15:09:50.273746+00	2023-02-11 15:09:50.273771+00		3	\N	25	565
13184	2023-02-11 15:09:50.276337+00	2023-02-11 15:09:50.276355+00		5	\N	26	565
13185	2023-02-11 15:09:50.278703+00	2023-02-11 15:09:50.278722+00		4	\N	27	565
13186	2023-02-11 15:09:50.280971+00	2023-02-11 15:09:50.280991+00		4	\N	28	565
13187	2023-02-11 15:09:50.283065+00	2023-02-11 15:09:50.283084+00		4	\N	29	565
13188	2023-02-11 15:09:50.286136+00	2023-02-11 15:09:50.286178+00		4	\N	30	565
13189	2023-02-11 15:09:50.288634+00	2023-02-11 15:09:50.288652+00		5	\N	31	565
13190	2023-02-11 15:09:50.291086+00	2023-02-11 15:09:50.29111+00		4	\N	32	565
13191	2023-02-11 15:09:50.293433+00	2023-02-11 15:09:50.293452+00		3	\N	33	565
13192	2023-02-11 15:09:50.295786+00	2023-02-11 15:09:50.295804+00		4	\N	34	565
13193	2023-02-11 15:09:50.298131+00	2023-02-11 15:09:50.29815+00		5	\N	35	565
13194	2023-02-11 15:09:50.300628+00	2023-02-11 15:09:50.300649+00		3	\N	36	565
13195	2023-02-11 15:09:50.303831+00	2023-02-11 15:09:50.30385+00		3	\N	37	565
13196	2023-02-11 15:09:50.306443+00	2023-02-11 15:09:50.306462+00		4	\N	38	565
13197	2023-02-11 15:09:50.308766+00	2023-02-11 15:09:50.308785+00		5	\N	39	565
13198	2023-02-11 15:09:50.311244+00	2023-02-11 15:09:50.31127+00		3	\N	40	565
13199	2023-02-11 15:09:50.314027+00	2023-02-11 15:09:50.314054+00		5	\N	41	565
13200	2023-02-11 15:09:50.316872+00	2023-02-11 15:09:50.316904+00		4	\N	42	565
13201	2023-02-11 15:09:50.320576+00	2023-02-11 15:09:50.320608+00		5	\N	43	565
13202	2023-02-11 15:09:50.323909+00	2023-02-11 15:09:50.323938+00		4	\N	44	565
13203	2023-02-11 15:09:50.326766+00	2023-02-11 15:09:50.326786+00		4	\N	45	565
13204	2023-02-11 15:09:50.329413+00	2023-02-11 15:09:50.329433+00		4	\N	46	565
13205	2023-02-11 15:09:50.331883+00	2023-02-11 15:09:50.331903+00		4	\N	47	565
13206	2023-02-11 15:09:50.335677+00	2023-02-11 15:09:50.335705+00		4	\N	48	565
13207	2023-02-11 15:09:50.338699+00	2023-02-11 15:09:50.338727+00		5	\N	49	565
13208	2023-02-11 15:09:50.341508+00	2023-02-11 15:09:50.341529+00		5	\N	50	565
13209	2023-02-11 15:09:50.344144+00	2023-02-11 15:09:50.344165+00		5	\N	51	565
13210	2023-02-11 15:09:50.347089+00	2023-02-11 15:09:50.347117+00		5	\N	52	565
13211	2023-02-11 15:09:50.35002+00	2023-02-11 15:09:50.350042+00		5	\N	53	565
13212	2023-02-11 15:09:50.353602+00	2023-02-11 15:09:50.353627+00		5	\N	54	565
13213	2023-02-11 15:09:50.356067+00	2023-02-11 15:09:50.356088+00		4	\N	55	565
13214	2023-02-11 15:09:50.358541+00	2023-02-11 15:09:50.358561+00		4	\N	56	565
13215	2023-02-11 15:09:50.361044+00	2023-02-11 15:09:50.361064+00		4	\N	57	565
13216	2023-02-11 15:09:50.363688+00	2023-02-11 15:09:50.363713+00		5	\N	58	565
13217	2023-02-11 15:09:50.366518+00	2023-02-11 15:09:50.366545+00		3	\N	59	565
13218	2023-02-11 15:09:50.370831+00	2023-02-11 15:09:50.370855+00		5	\N	60	565
13219	2023-02-11 15:09:50.3738+00	2023-02-11 15:09:50.373827+00		3	\N	61	565
13220	2023-02-11 15:09:50.376871+00	2023-02-11 15:09:50.376917+00		4	\N	62	565
13221	2023-02-11 15:09:50.379648+00	2023-02-11 15:09:50.379685+00		3	\N	63	565
13222	2023-02-11 15:09:50.383198+00	2023-02-11 15:09:50.38323+00		4	\N	64	565
13223	2023-02-11 15:09:50.387044+00	2023-02-11 15:09:50.387064+00		5	\N	65	565
13224	2023-02-11 15:09:50.390011+00	2023-02-11 15:09:50.390041+00		5	\N	66	565
13225	2023-02-11 15:09:50.392687+00	2023-02-11 15:09:50.392707+00		5	\N	67	565
13226	2023-02-11 15:09:50.395515+00	2023-02-11 15:09:50.395538+00		5	\N	68	565
13227	2023-02-11 15:09:50.398035+00	2023-02-11 15:09:50.398054+00		4	\N	69	565
13228	2023-02-11 15:09:50.400862+00	2023-02-11 15:09:50.400913+00		5	\N	70	565
13229	2023-02-11 15:09:50.404006+00	2023-02-11 15:09:50.404028+00		5	\N	71	565
13230	2023-02-11 15:09:50.447716+00	2023-02-11 15:09:50.44774+00		3	\N	1	566
13231	2023-02-11 15:09:50.450756+00	2023-02-11 15:09:50.450785+00		3	\N	2	566
13232	2023-02-11 15:09:50.453537+00	2023-02-11 15:09:50.453558+00		3	\N	3	566
13233	2023-02-11 15:09:50.456372+00	2023-02-11 15:09:50.456393+00		4	\N	4	566
13234	2023-02-11 15:09:50.459745+00	2023-02-11 15:09:50.459772+00		4	\N	5	566
13235	2023-02-11 15:09:50.463358+00	2023-02-11 15:09:50.463384+00		3	\N	6	566
13236	2023-02-11 15:09:50.466184+00	2023-02-11 15:09:50.46621+00		1	\N	7	566
13237	2023-02-11 15:09:50.469377+00	2023-02-11 15:09:50.469408+00		3	\N	8	566
13238	2023-02-11 15:09:50.471969+00	2023-02-11 15:09:50.471996+00		3	\N	9	566
13239	2023-02-11 15:09:50.474975+00	2023-02-11 15:09:50.474996+00		3	\N	10	566
13240	2023-02-11 15:09:50.478089+00	2023-02-11 15:09:50.47812+00		2	\N	11	566
13241	2023-02-11 15:09:50.480598+00	2023-02-11 15:09:50.480626+00		4	\N	12	566
13242	2023-02-11 15:09:50.483367+00	2023-02-11 15:09:50.483414+00		3	\N	13	566
13243	2023-02-11 15:09:50.48664+00	2023-02-11 15:09:50.486661+00		5	\N	14	566
13244	2023-02-11 15:09:50.489545+00	2023-02-11 15:09:50.489574+00		3	\N	15	566
13245	2023-02-11 15:09:50.492666+00	2023-02-11 15:09:50.49269+00		3	\N	16	566
13246	2023-02-11 15:09:50.495085+00	2023-02-11 15:09:50.495119+00		3	\N	17	566
13247	2023-02-11 15:09:50.497758+00	2023-02-11 15:09:50.497778+00		4	\N	18	566
13248	2023-02-11 15:09:50.500328+00	2023-02-11 15:09:50.50036+00		3	\N	19	566
13249	2023-02-11 15:09:50.503532+00	2023-02-11 15:09:50.503561+00		3	\N	20	566
13250	2023-02-11 15:09:50.507077+00	2023-02-11 15:09:50.507098+00		4	\N	21	566
13251	2023-02-11 15:09:50.510464+00	2023-02-11 15:09:50.510485+00		3	\N	22	566
13252	2023-02-11 15:09:50.513334+00	2023-02-11 15:09:50.513355+00		4	\N	23	566
13253	2023-02-11 15:09:50.515841+00	2023-02-11 15:09:50.51586+00		3	\N	24	566
13254	2023-02-11 15:09:50.518656+00	2023-02-11 15:09:50.518686+00		3	\N	25	566
13255	2023-02-11 15:09:50.521998+00	2023-02-11 15:09:50.522026+00		5	\N	26	566
13256	2023-02-11 15:09:50.525218+00	2023-02-11 15:09:50.525239+00		3	\N	27	566
13257	2023-02-11 15:09:50.527923+00	2023-02-11 15:09:50.527944+00		3	\N	28	566
13258	2023-02-11 15:09:50.530378+00	2023-02-11 15:09:50.530399+00		4	\N	29	566
13259	2023-02-11 15:09:50.532955+00	2023-02-11 15:09:50.532975+00		3	\N	30	566
13260	2023-02-11 15:09:50.536113+00	2023-02-11 15:09:50.536134+00		3	\N	31	566
13261	2023-02-11 15:09:50.538995+00	2023-02-11 15:09:50.539016+00		4	\N	32	566
13262	2023-02-11 15:09:50.541329+00	2023-02-11 15:09:50.54135+00		4	\N	33	566
13263	2023-02-11 15:09:50.544049+00	2023-02-11 15:09:50.544072+00		5	\N	34	566
13264	2023-02-11 15:09:50.546686+00	2023-02-11 15:09:50.546706+00		5	\N	35	566
13265	2023-02-11 15:09:50.548894+00	2023-02-11 15:09:50.548914+00		1	\N	36	566
13266	2023-02-11 15:09:50.551913+00	2023-02-11 15:09:50.551941+00		4	\N	37	566
13267	2023-02-11 15:09:50.554791+00	2023-02-11 15:09:50.554812+00		4	\N	38	566
13268	2023-02-11 15:09:50.557277+00	2023-02-11 15:09:50.557299+00		4	\N	39	566
13269	2023-02-11 15:09:50.559864+00	2023-02-11 15:09:50.559886+00		4	\N	40	566
13270	2023-02-11 15:09:50.562584+00	2023-02-11 15:09:50.562614+00		5	\N	41	566
13271	2023-02-11 15:09:50.565354+00	2023-02-11 15:09:50.565384+00		3	\N	42	566
13272	2023-02-11 15:09:50.568632+00	2023-02-11 15:09:50.56867+00		4	\N	43	566
13273	2023-02-11 15:09:50.571727+00	2023-02-11 15:09:50.571747+00		4	\N	44	566
13274	2023-02-11 15:09:50.574085+00	2023-02-11 15:09:50.574106+00		3	\N	45	566
13275	2023-02-11 15:09:50.576463+00	2023-02-11 15:09:50.576484+00		4	\N	46	566
13276	2023-02-11 15:09:50.578947+00	2023-02-11 15:09:50.578973+00		3	\N	47	566
13277	2023-02-11 15:09:50.581694+00	2023-02-11 15:09:50.581713+00		4	\N	48	566
13278	2023-02-11 15:09:50.584418+00	2023-02-11 15:09:50.584442+00		4	\N	49	566
13279	2023-02-11 15:09:50.587192+00	2023-02-11 15:09:50.587214+00		5	\N	50	566
13280	2023-02-11 15:09:50.589868+00	2023-02-11 15:09:50.589889+00		5	\N	51	566
13281	2023-02-11 15:09:50.592098+00	2023-02-11 15:09:50.592118+00		4	\N	52	566
13282	2023-02-11 15:09:50.594335+00	2023-02-11 15:09:50.594354+00		3	\N	53	566
13283	2023-02-11 15:09:50.59759+00	2023-02-11 15:09:50.597617+00		3	\N	54	566
13284	2023-02-11 15:09:50.600498+00	2023-02-11 15:09:50.600525+00		4	\N	55	566
13285	2023-02-11 15:09:50.603644+00	2023-02-11 15:09:50.603663+00		4	\N	56	566
13286	2023-02-11 15:09:50.605854+00	2023-02-11 15:09:50.605873+00		4	\N	57	566
13287	2023-02-11 15:09:50.608129+00	2023-02-11 15:09:50.60815+00		5	\N	58	566
13288	2023-02-11 15:09:50.610673+00	2023-02-11 15:09:50.610693+00		4	\N	59	566
13289	2023-02-11 15:09:50.613177+00	2023-02-11 15:09:50.613197+00		3	\N	60	566
13290	2023-02-11 15:09:50.615547+00	2023-02-11 15:09:50.615566+00		3	\N	61	566
13291	2023-02-11 15:09:50.618212+00	2023-02-11 15:09:50.61825+00		4	\N	62	566
13292	2023-02-11 15:09:50.620725+00	2023-02-11 15:09:50.620746+00		3	\N	63	566
13293	2023-02-11 15:09:50.622857+00	2023-02-11 15:09:50.622877+00		3	\N	64	566
13294	2023-02-11 15:09:50.625024+00	2023-02-11 15:09:50.625053+00		3	\N	65	566
13295	2023-02-11 15:09:50.627685+00	2023-02-11 15:09:50.627705+00		4	\N	66	566
13296	2023-02-11 15:09:50.629985+00	2023-02-11 15:09:50.630007+00		3	\N	67	566
13297	2023-02-11 15:09:50.632203+00	2023-02-11 15:09:50.632222+00		3	\N	68	566
13298	2023-02-11 15:09:50.634951+00	2023-02-11 15:09:50.634974+00		3	\N	69	566
13299	2023-02-11 15:09:50.63769+00	2023-02-11 15:09:50.637711+00		3	\N	70	566
13300	2023-02-11 15:09:50.640016+00	2023-02-11 15:09:50.640037+00		5	\N	71	566
13301	2023-02-11 15:09:50.67826+00	2023-02-11 15:09:50.67828+00		5	\N	1	567
13302	2023-02-11 15:09:50.680595+00	2023-02-11 15:09:50.680615+00		5	\N	2	567
13303	2023-02-11 15:09:50.682713+00	2023-02-11 15:09:50.682733+00		5	\N	3	567
13304	2023-02-11 15:09:50.685326+00	2023-02-11 15:09:50.685346+00		5	\N	4	567
13305	2023-02-11 15:09:50.687969+00	2023-02-11 15:09:50.687989+00		5	\N	5	567
13306	2023-02-11 15:09:50.690242+00	2023-02-11 15:09:50.690262+00		5	\N	6	567
13307	2023-02-11 15:09:50.692227+00	2023-02-11 15:09:50.692244+00		1	\N	7	567
13308	2023-02-11 15:09:50.694115+00	2023-02-11 15:09:50.694132+00		5	\N	8	567
13309	2023-02-11 15:09:50.695901+00	2023-02-11 15:09:50.695917+00		5	\N	9	567
13310	2023-02-11 15:09:50.6977+00	2023-02-11 15:09:50.697717+00		5	\N	10	567
13311	2023-02-11 15:09:50.699474+00	2023-02-11 15:09:50.699491+00		5	\N	11	567
13312	2023-02-11 15:09:50.70174+00	2023-02-11 15:09:50.701769+00		1	\N	12	567
13313	2023-02-11 15:09:50.704032+00	2023-02-11 15:09:50.704053+00		3	\N	13	567
13314	2023-02-11 15:09:50.706044+00	2023-02-11 15:09:50.706063+00		3	\N	14	567
13315	2023-02-11 15:09:50.708126+00	2023-02-11 15:09:50.708145+00		5	\N	15	567
13316	2023-02-11 15:09:50.71+00	2023-02-11 15:09:50.710016+00		5	\N	16	567
13317	2023-02-11 15:09:50.711761+00	2023-02-11 15:09:50.711777+00		3	\N	17	567
13318	2023-02-11 15:09:50.713542+00	2023-02-11 15:09:50.713558+00		5	\N	18	567
13319	2023-02-11 15:09:50.715347+00	2023-02-11 15:09:50.715363+00		4	\N	19	567
13320	2023-02-11 15:09:50.717421+00	2023-02-11 15:09:50.717446+00		4	\N	20	567
13321	2023-02-11 15:09:50.71989+00	2023-02-11 15:09:50.719915+00		3	\N	21	567
13322	2023-02-11 15:09:50.722115+00	2023-02-11 15:09:50.722133+00		3	\N	22	567
13323	2023-02-11 15:09:50.724004+00	2023-02-11 15:09:50.72402+00		5	\N	23	567
13324	2023-02-11 15:09:50.72573+00	2023-02-11 15:09:50.725747+00		3	\N	24	567
13325	2023-02-11 15:09:50.727433+00	2023-02-11 15:09:50.727449+00		3	\N	25	567
13326	2023-02-11 15:09:50.729249+00	2023-02-11 15:09:50.729265+00		3	\N	26	567
13327	2023-02-11 15:09:50.730993+00	2023-02-11 15:09:50.731009+00		5	\N	27	567
13328	2023-02-11 15:09:50.73295+00	2023-02-11 15:09:50.732968+00		5	\N	28	567
13329	2023-02-11 15:09:50.735694+00	2023-02-11 15:09:50.735716+00		4	\N	29	567
13330	2023-02-11 15:09:50.737872+00	2023-02-11 15:09:50.737889+00		5	\N	30	567
13331	2023-02-11 15:09:50.739743+00	2023-02-11 15:09:50.73976+00		3	\N	31	567
13332	2023-02-11 15:09:50.741598+00	2023-02-11 15:09:50.741614+00		3	\N	32	567
13333	2023-02-11 15:09:50.743481+00	2023-02-11 15:09:50.743497+00		3	\N	33	567
13334	2023-02-11 15:09:50.745363+00	2023-02-11 15:09:50.745379+00		5	\N	34	567
13335	2023-02-11 15:09:50.747366+00	2023-02-11 15:09:50.747384+00		1	\N	35	567
13336	2023-02-11 15:09:50.749355+00	2023-02-11 15:09:50.749374+00		3	\N	36	567
13337	2023-02-11 15:09:50.751854+00	2023-02-11 15:09:50.751875+00		1	\N	37	567
13338	2023-02-11 15:09:50.753967+00	2023-02-11 15:09:50.753985+00		1	\N	38	567
13339	2023-02-11 15:09:50.75583+00	2023-02-11 15:09:50.755846+00		3	\N	39	567
13340	2023-02-11 15:09:50.757691+00	2023-02-11 15:09:50.757712+00		1	\N	40	567
13341	2023-02-11 15:09:50.759576+00	2023-02-11 15:09:50.759591+00		3	\N	41	567
13342	2023-02-11 15:09:50.761344+00	2023-02-11 15:09:50.76136+00		5	\N	42	567
13343	2023-02-11 15:09:50.763176+00	2023-02-11 15:09:50.763194+00		5	\N	43	567
13344	2023-02-11 15:09:50.765298+00	2023-02-11 15:09:50.765316+00		5	\N	44	567
13345	2023-02-11 15:09:50.767618+00	2023-02-11 15:09:50.767651+00		5	\N	45	567
13346	2023-02-11 15:09:50.770178+00	2023-02-11 15:09:50.7702+00		1	\N	46	567
13347	2023-02-11 15:09:50.772178+00	2023-02-11 15:09:50.772194+00		5	\N	47	567
13348	2023-02-11 15:09:50.774169+00	2023-02-11 15:09:50.774184+00		1	\N	48	567
13349	2023-02-11 15:09:50.776005+00	2023-02-11 15:09:50.776021+00		5	\N	49	567
13350	2023-02-11 15:09:50.777991+00	2023-02-11 15:09:50.778008+00		5	\N	50	567
13351	2023-02-11 15:09:50.780064+00	2023-02-11 15:09:50.780082+00		5	\N	51	567
13352	2023-02-11 15:09:50.782074+00	2023-02-11 15:09:50.782143+00		5	\N	52	567
13353	2023-02-11 15:09:50.784388+00	2023-02-11 15:09:50.784414+00		5	\N	53	567
13354	2023-02-11 15:09:50.786762+00	2023-02-11 15:09:50.78678+00		1	\N	54	567
13355	2023-02-11 15:09:50.788615+00	2023-02-11 15:09:50.788633+00		1	\N	55	567
13356	2023-02-11 15:09:50.790453+00	2023-02-11 15:09:50.790471+00		3	\N	56	567
13357	2023-02-11 15:09:50.792417+00	2023-02-11 15:09:50.792442+00		3	\N	57	567
13358	2023-02-11 15:09:50.794493+00	2023-02-11 15:09:50.794511+00		3	\N	58	567
13359	2023-02-11 15:09:50.796468+00	2023-02-11 15:09:50.796486+00		5	\N	59	567
13360	2023-02-11 15:09:50.798398+00	2023-02-11 15:09:50.798421+00		5	\N	60	567
13361	2023-02-11 15:09:50.800832+00	2023-02-11 15:09:50.800863+00		5	\N	61	567
13362	2023-02-11 15:09:50.803526+00	2023-02-11 15:09:50.803547+00		5	\N	62	567
13363	2023-02-11 15:09:50.8057+00	2023-02-11 15:09:50.805715+00		3	\N	63	567
13364	2023-02-11 15:09:50.807727+00	2023-02-11 15:09:50.80775+00		2	\N	64	567
13365	2023-02-11 15:09:50.811813+00	2023-02-11 15:09:50.811832+00		3	\N	65	567
13366	2023-02-11 15:09:50.814022+00	2023-02-11 15:09:50.814037+00		5	\N	66	567
13367	2023-02-11 15:09:50.816117+00	2023-02-11 15:09:50.816132+00		3	\N	67	567
13368	2023-02-11 15:09:50.818729+00	2023-02-11 15:09:50.818748+00		3	\N	68	567
13369	2023-02-11 15:09:50.820948+00	2023-02-11 15:09:50.820965+00		3	\N	69	567
13370	2023-02-11 15:09:50.823144+00	2023-02-11 15:09:50.823161+00		3	\N	70	567
13371	2023-02-11 15:09:50.825251+00	2023-02-11 15:09:50.825269+00		1	\N	71	567
13372	2023-02-11 15:09:50.860723+00	2023-02-11 15:09:50.86074+00		1	\N	1	568
13373	2023-02-11 15:09:50.862457+00	2023-02-11 15:09:50.862473+00		4	\N	2	568
13374	2023-02-11 15:09:50.864186+00	2023-02-11 15:09:50.864201+00		3	\N	3	568
13375	2023-02-11 15:09:50.865931+00	2023-02-11 15:09:50.865946+00		5	\N	4	568
13376	2023-02-11 15:09:50.868029+00	2023-02-11 15:09:50.868056+00		3	\N	5	568
13377	2023-02-11 15:09:50.870135+00	2023-02-11 15:09:50.870153+00		1	\N	6	568
13378	2023-02-11 15:09:50.872194+00	2023-02-11 15:09:50.872211+00		1	\N	7	568
13379	2023-02-11 15:09:50.87399+00	2023-02-11 15:09:50.874005+00		4	\N	8	568
13380	2023-02-11 15:09:50.875684+00	2023-02-11 15:09:50.875699+00		4	\N	9	568
13381	2023-02-11 15:09:50.877443+00	2023-02-11 15:09:50.877458+00		5	\N	10	568
13382	2023-02-11 15:09:50.879116+00	2023-02-11 15:09:50.879151+00		3	\N	11	568
13383	2023-02-11 15:09:50.880744+00	2023-02-11 15:09:50.880758+00		5	\N	12	568
13384	2023-02-11 15:09:50.882356+00	2023-02-11 15:09:50.882371+00		4	\N	13	568
13385	2023-02-11 15:09:50.884978+00	2023-02-11 15:09:50.885011+00		5	\N	14	568
13386	2023-02-11 15:09:50.887351+00	2023-02-11 15:09:50.887369+00		5	\N	15	568
13387	2023-02-11 15:09:50.889474+00	2023-02-11 15:09:50.889491+00		3	\N	16	568
13388	2023-02-11 15:09:50.891387+00	2023-02-11 15:09:50.891402+00		1	\N	17	568
13389	2023-02-11 15:09:50.893209+00	2023-02-11 15:09:50.893225+00		3	\N	18	568
13390	2023-02-11 15:09:50.895013+00	2023-02-11 15:09:50.895028+00		3	\N	19	568
13391	2023-02-11 15:09:50.89678+00	2023-02-11 15:09:50.896795+00		4	\N	20	568
13392	2023-02-11 15:09:50.898503+00	2023-02-11 15:09:50.898519+00		5	\N	21	568
13393	2023-02-11 15:09:50.900574+00	2023-02-11 15:09:50.900593+00		5	\N	22	568
13394	2023-02-11 15:09:50.903192+00	2023-02-11 15:09:50.903211+00		5	\N	23	568
13395	2023-02-11 15:09:50.905324+00	2023-02-11 15:09:50.90534+00		4	\N	24	568
13396	2023-02-11 15:09:50.907345+00	2023-02-11 15:09:50.90736+00		4	\N	25	568
13397	2023-02-11 15:09:50.909246+00	2023-02-11 15:09:50.90926+00		3	\N	26	568
13398	2023-02-11 15:09:50.911043+00	2023-02-11 15:09:50.911058+00		3	\N	27	568
13399	2023-02-11 15:09:50.912875+00	2023-02-11 15:09:50.91289+00		4	\N	28	568
13400	2023-02-11 15:09:50.914859+00	2023-02-11 15:09:50.914879+00		4	\N	29	568
13401	2023-02-11 15:09:50.91843+00	2023-02-11 15:09:50.918458+00		3	\N	30	568
13402	2023-02-11 15:09:50.920823+00	2023-02-11 15:09:50.920841+00		3	\N	31	568
13403	2023-02-11 15:09:50.922809+00	2023-02-11 15:09:50.922826+00		4	\N	32	568
13404	2023-02-11 15:09:50.924613+00	2023-02-11 15:09:50.924629+00		4	\N	33	568
13405	2023-02-11 15:09:50.926409+00	2023-02-11 15:09:50.926426+00		5	\N	34	568
13406	2023-02-11 15:09:50.928123+00	2023-02-11 15:09:50.928138+00		3	\N	35	568
13407	2023-02-11 15:09:50.929869+00	2023-02-11 15:09:50.929886+00		1	\N	36	568
13408	2023-02-11 15:09:50.931574+00	2023-02-11 15:09:50.931589+00		1	\N	37	568
13409	2023-02-11 15:09:50.933179+00	2023-02-11 15:09:50.933193+00		4	\N	38	568
13410	2023-02-11 15:09:50.935623+00	2023-02-11 15:09:50.935648+00		4	\N	39	568
13411	2023-02-11 15:09:50.937746+00	2023-02-11 15:09:50.937763+00		3	\N	40	568
13412	2023-02-11 15:09:50.939813+00	2023-02-11 15:09:50.939828+00		1	\N	41	568
13413	2023-02-11 15:09:50.941802+00	2023-02-11 15:09:50.941819+00		4	\N	42	568
13414	2023-02-11 15:09:50.943653+00	2023-02-11 15:09:50.943668+00		5	\N	43	568
13415	2023-02-11 15:09:50.945651+00	2023-02-11 15:09:50.945669+00		5	\N	44	568
13416	2023-02-11 15:09:50.947683+00	2023-02-11 15:09:50.9477+00		5	\N	45	568
13417	2023-02-11 15:09:50.949601+00	2023-02-11 15:09:50.949616+00		5	\N	46	568
13418	2023-02-11 15:09:50.952047+00	2023-02-11 15:09:50.95207+00		5	\N	47	568
13419	2023-02-11 15:09:50.954217+00	2023-02-11 15:09:50.954232+00		3	\N	48	568
13420	2023-02-11 15:09:50.956167+00	2023-02-11 15:09:50.956184+00		1	\N	49	568
13421	2023-02-11 15:09:50.957994+00	2023-02-11 15:09:50.958014+00		3	\N	50	568
13422	2023-02-11 15:09:50.959856+00	2023-02-11 15:09:50.959871+00		3	\N	51	568
13423	2023-02-11 15:09:50.96173+00	2023-02-11 15:09:50.961745+00		4	\N	52	568
13424	2023-02-11 15:09:50.963566+00	2023-02-11 15:09:50.963582+00		3	\N	53	568
13425	2023-02-11 15:09:50.965358+00	2023-02-11 15:09:50.965375+00		4	\N	54	568
13426	2023-02-11 15:09:50.967322+00	2023-02-11 15:09:50.967346+00		5	\N	55	568
13427	2023-02-11 15:09:50.969759+00	2023-02-11 15:09:50.969777+00		1	\N	56	568
13428	2023-02-11 15:09:50.971667+00	2023-02-11 15:09:50.971683+00		3	\N	57	568
13429	2023-02-11 15:09:50.973399+00	2023-02-11 15:09:50.973414+00		1	\N	58	568
13430	2023-02-11 15:09:50.975152+00	2023-02-11 15:09:50.975175+00		1	\N	59	568
13431	2023-02-11 15:09:50.97692+00	2023-02-11 15:09:50.976936+00		1	\N	60	568
13432	2023-02-11 15:09:50.978861+00	2023-02-11 15:09:50.978905+00		1	\N	61	568
13433	2023-02-11 15:09:50.980757+00	2023-02-11 15:09:50.980772+00		1	\N	62	568
13434	2023-02-11 15:09:50.982535+00	2023-02-11 15:09:50.982549+00		1	\N	63	568
13435	2023-02-11 15:09:50.985044+00	2023-02-11 15:09:50.985064+00		1	\N	64	568
13436	2023-02-11 15:09:50.987369+00	2023-02-11 15:09:50.987385+00		3	\N	65	568
13437	2023-02-11 15:09:50.989279+00	2023-02-11 15:09:50.989294+00		1	\N	66	568
13438	2023-02-11 15:09:50.991042+00	2023-02-11 15:09:50.991058+00		1	\N	67	568
13439	2023-02-11 15:09:50.992939+00	2023-02-11 15:09:50.992983+00		1	\N	68	568
13440	2023-02-11 15:09:50.994735+00	2023-02-11 15:09:50.99475+00		1	\N	69	568
13441	2023-02-11 15:09:50.996446+00	2023-02-11 15:09:50.99646+00		1	\N	70	568
13442	2023-02-11 15:09:50.998225+00	2023-02-11 15:09:50.99824+00		1	\N	71	568
13443	2023-02-11 15:09:51.029448+00	2023-02-11 15:09:51.029464+00		5	\N	1	569
13444	2023-02-11 15:09:51.031358+00	2023-02-11 15:09:51.031373+00		5	\N	2	569
13445	2023-02-11 15:09:51.033291+00	2023-02-11 15:09:51.033306+00		5	\N	3	569
13446	2023-02-11 15:09:51.035571+00	2023-02-11 15:09:51.035588+00		5	\N	4	569
13447	2023-02-11 15:09:51.037768+00	2023-02-11 15:09:51.037788+00		5	\N	5	569
13448	2023-02-11 15:09:51.039574+00	2023-02-11 15:09:51.039589+00		5	\N	6	569
13449	2023-02-11 15:09:51.041189+00	2023-02-11 15:09:51.041205+00		5	\N	7	569
13450	2023-02-11 15:09:51.04279+00	2023-02-11 15:09:51.042805+00		5	\N	8	569
13451	2023-02-11 15:09:51.044393+00	2023-02-11 15:09:51.044407+00		4	\N	9	569
13452	2023-02-11 15:09:51.045999+00	2023-02-11 15:09:51.046014+00		4	\N	10	569
13453	2023-02-11 15:09:51.047624+00	2023-02-11 15:09:51.047639+00		4	\N	11	569
13454	2023-02-11 15:09:51.049269+00	2023-02-11 15:09:51.049284+00		3	\N	12	569
13455	2023-02-11 15:09:51.051251+00	2023-02-11 15:09:51.05127+00		5	\N	13	569
13456	2023-02-11 15:09:51.055729+00	2023-02-11 15:09:51.055748+00		3	\N	14	569
13457	2023-02-11 15:09:51.057937+00	2023-02-11 15:09:51.057954+00		5	\N	15	569
13458	2023-02-11 15:09:51.059818+00	2023-02-11 15:09:51.059833+00		5	\N	16	569
13459	2023-02-11 15:09:51.061646+00	2023-02-11 15:09:51.06166+00		5	\N	17	569
13460	2023-02-11 15:09:51.063343+00	2023-02-11 15:09:51.063357+00		5	\N	18	569
13461	2023-02-11 15:09:51.065061+00	2023-02-11 15:09:51.065078+00		4	\N	19	569
13462	2023-02-11 15:09:51.067108+00	2023-02-11 15:09:51.067131+00		4	\N	20	569
13463	2023-02-11 15:09:51.069449+00	2023-02-11 15:09:51.069467+00		4	\N	21	569
13464	2023-02-11 15:09:51.071658+00	2023-02-11 15:09:51.07168+00		5	\N	22	569
13465	2023-02-11 15:09:51.073632+00	2023-02-11 15:09:51.073648+00		5	\N	23	569
13466	2023-02-11 15:09:51.075737+00	2023-02-11 15:09:51.075754+00		3	\N	24	569
13467	2023-02-11 15:09:51.077676+00	2023-02-11 15:09:51.077692+00		4	\N	25	569
13468	2023-02-11 15:09:51.079557+00	2023-02-11 15:09:51.079578+00		5	\N	26	569
13469	2023-02-11 15:09:51.081582+00	2023-02-11 15:09:51.081602+00		4	\N	27	569
13470	2023-02-11 15:09:51.083737+00	2023-02-11 15:09:51.083756+00		5	\N	28	569
13471	2023-02-11 15:09:51.085951+00	2023-02-11 15:09:51.085971+00		5	\N	29	569
13472	2023-02-11 15:09:51.088258+00	2023-02-11 15:09:51.088275+00		5	\N	30	569
13473	2023-02-11 15:09:51.090119+00	2023-02-11 15:09:51.090134+00		4	\N	31	569
13474	2023-02-11 15:09:51.091823+00	2023-02-11 15:09:51.091838+00		5	\N	32	569
13475	2023-02-11 15:09:51.093683+00	2023-02-11 15:09:51.093697+00		5	\N	33	569
13476	2023-02-11 15:09:51.095301+00	2023-02-11 15:09:51.095315+00		5	\N	34	569
13477	2023-02-11 15:09:51.09684+00	2023-02-11 15:09:51.096854+00		3	\N	35	569
13478	2023-02-11 15:09:51.098496+00	2023-02-11 15:09:51.098511+00		1	\N	36	569
13479	2023-02-11 15:09:51.100391+00	2023-02-11 15:09:51.100414+00		5	\N	37	569
13480	2023-02-11 15:09:51.102868+00	2023-02-11 15:09:51.102889+00		5	\N	38	569
13481	2023-02-11 15:09:51.104837+00	2023-02-11 15:09:51.104853+00		4	\N	39	569
13482	2023-02-11 15:09:51.106706+00	2023-02-11 15:09:51.106721+00		4	\N	40	569
13483	2023-02-11 15:09:51.1084+00	2023-02-11 15:09:51.108414+00		5	\N	41	569
13484	2023-02-11 15:09:51.110083+00	2023-02-11 15:09:51.110097+00		5	\N	42	569
13485	2023-02-11 15:09:51.11176+00	2023-02-11 15:09:51.111774+00		1	\N	43	569
13486	2023-02-11 15:09:51.113307+00	2023-02-11 15:09:51.113321+00		1	\N	44	569
13487	2023-02-11 15:09:51.115119+00	2023-02-11 15:09:51.115136+00		3	\N	45	569
13488	2023-02-11 15:09:51.117004+00	2023-02-11 15:09:51.117028+00		3	\N	46	569
13489	2023-02-11 15:09:51.119452+00	2023-02-11 15:09:51.119481+00		4	\N	47	569
13490	2023-02-11 15:09:51.121676+00	2023-02-11 15:09:51.121693+00		5	\N	48	569
13491	2023-02-11 15:09:51.123545+00	2023-02-11 15:09:51.123561+00		3	\N	49	569
13492	2023-02-11 15:09:51.12546+00	2023-02-11 15:09:51.125474+00		3	\N	50	569
13493	2023-02-11 15:09:51.12725+00	2023-02-11 15:09:51.127265+00		3	\N	51	569
13494	2023-02-11 15:09:51.129199+00	2023-02-11 15:09:51.129222+00		3	\N	52	569
13495	2023-02-11 15:09:51.132711+00	2023-02-11 15:09:51.132734+00		3	\N	53	569
13496	2023-02-11 15:09:51.135214+00	2023-02-11 15:09:51.135233+00		3	\N	54	569
13497	2023-02-11 15:09:51.137328+00	2023-02-11 15:09:51.137345+00		5	\N	55	569
13498	2023-02-11 15:09:51.139296+00	2023-02-11 15:09:51.139312+00		3	\N	56	569
13499	2023-02-11 15:09:51.141078+00	2023-02-11 15:09:51.141115+00		3	\N	57	569
13500	2023-02-11 15:09:51.142841+00	2023-02-11 15:09:51.142855+00		3	\N	58	569
13501	2023-02-11 15:09:51.144659+00	2023-02-11 15:09:51.144677+00		3	\N	59	569
13502	2023-02-11 15:09:51.146787+00	2023-02-11 15:09:51.146809+00		3	\N	60	569
13503	2023-02-11 15:09:51.149028+00	2023-02-11 15:09:51.149051+00		3	\N	61	569
13504	2023-02-11 15:09:51.152032+00	2023-02-11 15:09:51.152061+00		3	\N	62	569
13505	2023-02-11 15:09:51.154238+00	2023-02-11 15:09:51.154255+00		3	\N	63	569
13506	2023-02-11 15:09:51.156255+00	2023-02-11 15:09:51.156271+00		5	\N	64	569
13507	2023-02-11 15:09:51.1582+00	2023-02-11 15:09:51.158214+00		3	\N	65	569
13508	2023-02-11 15:09:51.16016+00	2023-02-11 15:09:51.160184+00		3	\N	66	569
13509	2023-02-11 15:09:51.163798+00	2023-02-11 15:09:51.163815+00		3	\N	67	569
13510	2023-02-11 15:09:51.165871+00	2023-02-11 15:09:51.165886+00		3	\N	68	569
13511	2023-02-11 15:09:51.168353+00	2023-02-11 15:09:51.168395+00		3	\N	69	569
13512	2023-02-11 15:09:51.170576+00	2023-02-11 15:09:51.170592+00		3	\N	70	569
13513	2023-02-11 15:09:51.172329+00	2023-02-11 15:09:51.172344+00		4	\N	71	569
13514	2023-02-11 15:09:51.204904+00	2023-02-11 15:09:51.204922+00		4	\N	1	570
13515	2023-02-11 15:09:51.207149+00	2023-02-11 15:09:51.207166+00		4	\N	2	570
13516	2023-02-11 15:09:51.208992+00	2023-02-11 15:09:51.209008+00		4	\N	3	570
13517	2023-02-11 15:09:51.21087+00	2023-02-11 15:09:51.210885+00		4	\N	4	570
13518	2023-02-11 15:09:51.212766+00	2023-02-11 15:09:51.21278+00		4	\N	5	570
13519	2023-02-11 15:09:51.214514+00	2023-02-11 15:09:51.214528+00		4	\N	6	570
13520	2023-02-11 15:09:51.216225+00	2023-02-11 15:09:51.216239+00		4	\N	7	570
13521	2023-02-11 15:09:51.218333+00	2023-02-11 15:09:51.218351+00		4	\N	8	570
13522	2023-02-11 15:09:51.2202+00	2023-02-11 15:09:51.220217+00		4	\N	9	570
13523	2023-02-11 15:09:51.222226+00	2023-02-11 15:09:51.222248+00		4	\N	10	570
13524	2023-02-11 15:09:51.224639+00	2023-02-11 15:09:51.224656+00		5	\N	11	570
13525	2023-02-11 15:09:51.226823+00	2023-02-11 15:09:51.226839+00		4	\N	12	570
13526	2023-02-11 15:09:51.228866+00	2023-02-11 15:09:51.228881+00		2	\N	13	570
13527	2023-02-11 15:09:51.230723+00	2023-02-11 15:09:51.230738+00		5	\N	14	570
13528	2023-02-11 15:09:51.232422+00	2023-02-11 15:09:51.232437+00		2	\N	15	570
13529	2023-02-11 15:09:51.234556+00	2023-02-11 15:09:51.234582+00		4	\N	16	570
13530	2023-02-11 15:09:51.236876+00	2023-02-11 15:09:51.236895+00		4	\N	17	570
13531	2023-02-11 15:09:51.239246+00	2023-02-11 15:09:51.239271+00		1	\N	18	570
13532	2023-02-11 15:09:51.241645+00	2023-02-11 15:09:51.241663+00		2	\N	19	570
13533	2023-02-11 15:09:51.243839+00	2023-02-11 15:09:51.243856+00		3	\N	20	570
13534	2023-02-11 15:09:51.245702+00	2023-02-11 15:09:51.245719+00		1	\N	21	570
13535	2023-02-11 15:09:51.247757+00	2023-02-11 15:09:51.247774+00		2	\N	22	570
13536	2023-02-11 15:09:51.249621+00	2023-02-11 15:09:51.249638+00		3	\N	23	570
13537	2023-02-11 15:09:51.251756+00	2023-02-11 15:09:51.251775+00		1	\N	24	570
13538	2023-02-11 15:09:51.253898+00	2023-02-11 15:09:51.253975+00		3	\N	25	570
13539	2023-02-11 15:09:51.256014+00	2023-02-11 15:09:51.256031+00		4	\N	26	570
13540	2023-02-11 15:09:51.257939+00	2023-02-11 15:09:51.257956+00		3	\N	27	570
13541	2023-02-11 15:09:51.259758+00	2023-02-11 15:09:51.259774+00		3	\N	28	570
13542	2023-02-11 15:09:51.261454+00	2023-02-11 15:09:51.261469+00		3	\N	29	570
13543	2023-02-11 15:09:51.263003+00	2023-02-11 15:09:51.263017+00		3	\N	30	570
13544	2023-02-11 15:09:51.264759+00	2023-02-11 15:09:51.264774+00		3	\N	31	570
13545	2023-02-11 15:09:51.266399+00	2023-02-11 15:09:51.266414+00		3	\N	32	570
13546	2023-02-11 15:09:51.268573+00	2023-02-11 15:09:51.268598+00		3	\N	33	570
13547	2023-02-11 15:09:51.273423+00	2023-02-11 15:09:51.273442+00		4	\N	34	570
13548	2023-02-11 15:09:51.275595+00	2023-02-11 15:09:51.275611+00		1	\N	35	570
13549	2023-02-11 15:09:51.277684+00	2023-02-11 15:09:51.2777+00		1	\N	36	570
13550	2023-02-11 15:09:51.279633+00	2023-02-11 15:09:51.279649+00		1	\N	37	570
13551	2023-02-11 15:09:51.281612+00	2023-02-11 15:09:51.281628+00		3	\N	38	570
13552	2023-02-11 15:09:51.283467+00	2023-02-11 15:09:51.28349+00		3	\N	39	570
13553	2023-02-11 15:09:51.28614+00	2023-02-11 15:09:51.28616+00		1	\N	40	570
13554	2023-02-11 15:09:51.288372+00	2023-02-11 15:09:51.28839+00		4	\N	41	570
13555	2023-02-11 15:09:51.290227+00	2023-02-11 15:09:51.290242+00		3	\N	42	570
13556	2023-02-11 15:09:51.291985+00	2023-02-11 15:09:51.292+00		4	\N	43	570
13557	2023-02-11 15:09:51.293808+00	2023-02-11 15:09:51.293823+00		4	\N	44	570
13558	2023-02-11 15:09:51.295644+00	2023-02-11 15:09:51.295659+00		4	\N	45	570
13559	2023-02-11 15:09:51.297303+00	2023-02-11 15:09:51.297317+00		3	\N	46	570
13560	2023-02-11 15:09:51.298965+00	2023-02-11 15:09:51.298987+00		4	\N	47	570
13561	2023-02-11 15:09:51.300748+00	2023-02-11 15:09:51.300774+00		4	\N	48	570
13562	2023-02-11 15:09:51.303013+00	2023-02-11 15:09:51.30306+00		5	\N	49	570
13563	2023-02-11 15:09:51.304944+00	2023-02-11 15:09:51.30496+00		5	\N	50	570
13564	2023-02-11 15:09:51.306623+00	2023-02-11 15:09:51.306636+00		5	\N	51	570
13565	2023-02-11 15:09:51.308279+00	2023-02-11 15:09:51.308293+00		4	\N	52	570
13566	2023-02-11 15:09:51.309965+00	2023-02-11 15:09:51.309979+00		4	\N	53	570
13567	2023-02-11 15:09:51.311533+00	2023-02-11 15:09:51.311547+00		1	\N	54	570
13568	2023-02-11 15:09:51.313235+00	2023-02-11 15:09:51.313251+00		4	\N	55	570
13569	2023-02-11 15:09:51.315268+00	2023-02-11 15:09:51.315285+00		4	\N	56	570
13570	2023-02-11 15:09:51.317228+00	2023-02-11 15:09:51.317247+00		4	\N	57	570
13571	2023-02-11 15:09:51.319687+00	2023-02-11 15:09:51.319705+00		4	\N	58	570
13572	2023-02-11 15:09:51.321385+00	2023-02-11 15:09:51.3214+00		5	\N	59	570
13573	2023-02-11 15:09:51.323184+00	2023-02-11 15:09:51.323198+00		5	\N	60	570
13574	2023-02-11 15:09:51.324777+00	2023-02-11 15:09:51.324791+00		5	\N	61	570
13575	2023-02-11 15:09:51.326405+00	2023-02-11 15:09:51.32642+00		4	\N	62	570
13576	2023-02-11 15:09:51.328046+00	2023-02-11 15:09:51.328059+00		1	\N	63	570
13577	2023-02-11 15:09:51.32996+00	2023-02-11 15:09:51.329976+00		3	\N	64	570
13578	2023-02-11 15:09:51.331877+00	2023-02-11 15:09:51.331894+00		3	\N	65	570
13579	2023-02-11 15:09:51.333794+00	2023-02-11 15:09:51.333842+00		4	\N	66	570
13580	2023-02-11 15:09:51.336267+00	2023-02-11 15:09:51.336285+00		5	\N	67	570
13581	2023-02-11 15:09:51.338062+00	2023-02-11 15:09:51.338077+00		5	\N	68	570
13582	2023-02-11 15:09:51.339781+00	2023-02-11 15:09:51.339797+00		4	\N	69	570
13583	2023-02-11 15:09:51.341541+00	2023-02-11 15:09:51.341555+00		1	\N	70	570
13584	2023-02-11 15:09:51.343183+00	2023-02-11 15:09:51.343196+00		1	\N	71	570
13585	2023-02-11 15:09:51.375869+00	2023-02-11 15:09:51.375887+00		3	\N	1	571
13586	2023-02-11 15:09:51.378069+00	2023-02-11 15:09:51.378084+00		3	\N	2	571
13587	2023-02-11 15:09:51.379776+00	2023-02-11 15:09:51.379791+00		3	\N	3	571
13588	2023-02-11 15:09:51.381586+00	2023-02-11 15:09:51.381601+00		4	\N	4	571
13589	2023-02-11 15:09:51.383401+00	2023-02-11 15:09:51.383422+00		4	\N	5	571
13590	2023-02-11 15:09:51.385465+00	2023-02-11 15:09:51.385495+00		3	\N	6	571
13591	2023-02-11 15:09:51.387356+00	2023-02-11 15:09:51.38737+00		4	\N	7	571
13592	2023-02-11 15:09:51.389205+00	2023-02-11 15:09:51.389218+00		3	\N	8	571
13593	2023-02-11 15:09:51.390871+00	2023-02-11 15:09:51.390884+00		4	\N	9	571
13594	2023-02-11 15:09:51.392679+00	2023-02-11 15:09:51.392694+00		4	\N	10	571
13595	2023-02-11 15:09:51.394332+00	2023-02-11 15:09:51.394346+00		4	\N	11	571
13596	2023-02-11 15:09:51.396319+00	2023-02-11 15:09:51.396335+00		4	\N	12	571
13597	2023-02-11 15:09:51.398257+00	2023-02-11 15:09:51.398275+00		4	\N	13	571
13598	2023-02-11 15:09:51.400072+00	2023-02-11 15:09:51.40009+00		3	\N	14	571
13599	2023-02-11 15:09:51.402265+00	2023-02-11 15:09:51.402282+00		4	\N	15	571
13600	2023-02-11 15:09:51.404108+00	2023-02-11 15:09:51.404122+00		4	\N	16	571
13601	2023-02-11 15:09:51.405837+00	2023-02-11 15:09:51.40585+00		4	\N	17	571
13602	2023-02-11 15:09:51.40772+00	2023-02-11 15:09:51.407736+00		4	\N	18	571
13603	2023-02-11 15:09:51.409499+00	2023-02-11 15:09:51.409515+00		5	\N	19	571
13604	2023-02-11 15:09:51.411391+00	2023-02-11 15:09:51.411407+00		5	\N	20	571
13605	2023-02-11 15:09:51.413069+00	2023-02-11 15:09:51.413084+00		3	\N	21	571
13606	2023-02-11 15:09:51.414615+00	2023-02-11 15:09:51.414628+00		3	\N	22	571
13607	2023-02-11 15:09:51.41617+00	2023-02-11 15:09:51.416184+00		3	\N	23	571
13608	2023-02-11 15:09:51.418159+00	2023-02-11 15:09:51.418176+00		3	\N	24	571
13609	2023-02-11 15:09:51.419985+00	2023-02-11 15:09:51.419999+00		3	\N	25	571
13610	2023-02-11 15:09:51.421597+00	2023-02-11 15:09:51.42161+00		4	\N	26	571
13611	2023-02-11 15:09:51.423389+00	2023-02-11 15:09:51.423403+00		3	\N	27	571
13612	2023-02-11 15:09:51.425193+00	2023-02-11 15:09:51.425209+00		3	\N	28	571
13613	2023-02-11 15:09:51.427136+00	2023-02-11 15:09:51.427151+00		3	\N	29	571
13614	2023-02-11 15:09:51.428873+00	2023-02-11 15:09:51.428888+00		3	\N	30	571
13615	2023-02-11 15:09:51.430461+00	2023-02-11 15:09:51.430475+00		3	\N	31	571
13616	2023-02-11 15:09:51.432061+00	2023-02-11 15:09:51.432075+00		3	\N	32	571
13617	2023-02-11 15:09:51.433822+00	2023-02-11 15:09:51.433839+00		3	\N	33	571
13618	2023-02-11 15:09:51.435963+00	2023-02-11 15:09:51.43598+00		4	\N	34	571
13619	2023-02-11 15:09:51.437839+00	2023-02-11 15:09:51.437854+00		4	\N	35	571
13620	2023-02-11 15:09:51.439642+00	2023-02-11 15:09:51.439658+00		3	\N	36	571
13621	2023-02-11 15:09:51.441559+00	2023-02-11 15:09:51.441574+00		3	\N	37	571
13622	2023-02-11 15:09:51.443257+00	2023-02-11 15:09:51.443271+00		3	\N	38	571
13623	2023-02-11 15:09:51.444903+00	2023-02-11 15:09:51.444916+00		3	\N	39	571
13624	2023-02-11 15:09:51.446448+00	2023-02-11 15:09:51.446461+00		3	\N	40	571
13625	2023-02-11 15:09:51.448018+00	2023-02-11 15:09:51.448031+00		4	\N	41	571
13626	2023-02-11 15:09:51.449507+00	2023-02-11 15:09:51.449521+00		3	\N	42	571
13627	2023-02-11 15:09:51.451469+00	2023-02-11 15:09:51.451485+00		3	\N	43	571
13628	2023-02-11 15:09:51.453374+00	2023-02-11 15:09:51.453391+00		3	\N	44	571
13629	2023-02-11 15:09:51.456529+00	2023-02-11 15:09:51.456546+00		4	\N	45	571
13630	2023-02-11 15:09:51.458685+00	2023-02-11 15:09:51.458701+00		3	\N	46	571
13631	2023-02-11 15:09:51.46062+00	2023-02-11 15:09:51.460635+00		3	\N	47	571
13632	2023-02-11 15:09:51.462377+00	2023-02-11 15:09:51.46239+00		3	\N	48	571
13633	2023-02-11 15:09:51.464188+00	2023-02-11 15:09:51.464218+00		4	\N	49	571
13634	2023-02-11 15:09:51.466281+00	2023-02-11 15:09:51.466296+00		4	\N	50	571
13635	2023-02-11 15:09:51.46854+00	2023-02-11 15:09:51.468557+00		4	\N	51	571
13636	2023-02-11 15:09:51.470486+00	2023-02-11 15:09:51.470502+00		4	\N	52	571
13637	2023-02-11 15:09:51.472547+00	2023-02-11 15:09:51.472569+00		4	\N	53	571
13638	2023-02-11 15:09:51.474287+00	2023-02-11 15:09:51.474301+00		3	\N	54	571
13639	2023-02-11 15:09:51.475888+00	2023-02-11 15:09:51.475924+00		3	\N	55	571
13640	2023-02-11 15:09:51.477513+00	2023-02-11 15:09:51.477526+00		4	\N	56	571
13641	2023-02-11 15:09:51.479191+00	2023-02-11 15:09:51.479205+00		3	\N	57	571
13642	2023-02-11 15:09:51.480869+00	2023-02-11 15:09:51.480884+00		4	\N	58	571
13643	2023-02-11 15:09:51.482587+00	2023-02-11 15:09:51.482601+00		1	\N	59	571
13644	2023-02-11 15:09:51.484662+00	2023-02-11 15:09:51.48468+00		3	\N	60	571
13645	2023-02-11 15:09:51.488019+00	2023-02-11 15:09:51.488038+00		3	\N	61	571
13646	2023-02-11 15:09:51.490079+00	2023-02-11 15:09:51.490093+00		3	\N	62	571
13647	2023-02-11 15:09:51.49199+00	2023-02-11 15:09:51.492004+00		3	\N	63	571
13648	2023-02-11 15:09:51.493726+00	2023-02-11 15:09:51.49374+00		4	\N	64	571
13649	2023-02-11 15:09:51.495481+00	2023-02-11 15:09:51.495512+00		4	\N	65	571
13650	2023-02-11 15:09:51.497383+00	2023-02-11 15:09:51.497398+00		1	\N	66	571
13651	2023-02-11 15:09:51.499146+00	2023-02-11 15:09:51.49916+00		1	\N	67	571
13652	2023-02-11 15:09:51.501403+00	2023-02-11 15:09:51.501423+00		1	\N	68	571
13653	2023-02-11 15:09:51.503616+00	2023-02-11 15:09:51.503633+00		1	\N	69	571
13654	2023-02-11 15:09:51.505383+00	2023-02-11 15:09:51.505418+00		4	\N	70	571
13655	2023-02-11 15:09:51.507066+00	2023-02-11 15:09:51.50708+00		4	\N	71	571
13656	2023-02-11 15:09:51.535947+00	2023-02-11 15:09:51.535965+00		5	\N	1	572
13657	2023-02-11 15:09:51.537906+00	2023-02-11 15:09:51.537921+00		5	\N	2	572
13658	2023-02-11 15:09:51.539602+00	2023-02-11 15:09:51.539617+00		5	\N	3	572
13659	2023-02-11 15:09:51.541324+00	2023-02-11 15:09:51.541338+00		4	\N	4	572
13660	2023-02-11 15:09:51.542989+00	2023-02-11 15:09:51.543003+00		4	\N	5	572
13661	2023-02-11 15:09:51.54455+00	2023-02-11 15:09:51.544564+00		4	\N	6	572
13662	2023-02-11 15:09:51.5462+00	2023-02-11 15:09:51.546215+00		4	\N	7	572
13663	2023-02-11 15:09:51.547935+00	2023-02-11 15:09:51.547951+00		4	\N	8	572
13664	2023-02-11 15:09:51.549609+00	2023-02-11 15:09:51.549624+00		3	\N	9	572
13665	2023-02-11 15:09:51.552376+00	2023-02-11 15:09:51.552393+00		5	\N	10	572
13666	2023-02-11 15:09:51.554178+00	2023-02-11 15:09:51.554192+00		5	\N	11	572
13667	2023-02-11 15:09:51.555846+00	2023-02-11 15:09:51.55586+00		5	\N	12	572
13668	2023-02-11 15:09:51.557608+00	2023-02-11 15:09:51.557623+00		5	\N	13	572
13669	2023-02-11 15:09:51.5593+00	2023-02-11 15:09:51.559314+00		5	\N	14	572
13670	2023-02-11 15:09:51.560872+00	2023-02-11 15:09:51.560886+00		5	\N	15	572
13671	2023-02-11 15:09:51.562736+00	2023-02-11 15:09:51.562752+00		4	\N	16	572
13672	2023-02-11 15:09:51.564984+00	2023-02-11 15:09:51.565001+00		4	\N	17	572
13673	2023-02-11 15:09:51.566995+00	2023-02-11 15:09:51.567019+00		4	\N	18	572
13674	2023-02-11 15:09:51.56939+00	2023-02-11 15:09:51.569407+00		4	\N	19	572
13675	2023-02-11 15:09:51.571316+00	2023-02-11 15:09:51.571331+00		4	\N	20	572
13676	2023-02-11 15:09:51.573013+00	2023-02-11 15:09:51.573027+00		3	\N	21	572
13677	2023-02-11 15:09:51.574722+00	2023-02-11 15:09:51.574735+00		3	\N	22	572
13678	2023-02-11 15:09:51.576317+00	2023-02-11 15:09:51.576331+00		5	\N	23	572
13679	2023-02-11 15:09:51.578196+00	2023-02-11 15:09:51.578212+00		4	\N	24	572
13680	2023-02-11 15:09:51.579911+00	2023-02-11 15:09:51.579927+00		5	\N	25	572
13681	2023-02-11 15:09:51.581808+00	2023-02-11 15:09:51.581823+00		5	\N	26	572
13682	2023-02-11 15:09:51.583643+00	2023-02-11 15:09:51.583665+00		5	\N	27	572
13683	2023-02-11 15:09:51.586548+00	2023-02-11 15:09:51.586566+00		5	\N	28	572
13684	2023-02-11 15:09:51.589349+00	2023-02-11 15:09:51.589367+00		4	\N	29	572
13685	2023-02-11 15:09:51.591667+00	2023-02-11 15:09:51.591684+00		3	\N	30	572
13686	2023-02-11 15:09:51.596004+00	2023-02-11 15:09:51.596022+00		3	\N	31	572
13687	2023-02-11 15:09:51.598516+00	2023-02-11 15:09:51.598534+00		4	\N	32	572
13688	2023-02-11 15:09:51.60131+00	2023-02-11 15:09:51.601359+00		5	\N	33	572
13689	2023-02-11 15:09:51.603938+00	2023-02-11 15:09:51.603956+00		4	\N	34	572
13690	2023-02-11 15:09:51.606383+00	2023-02-11 15:09:51.6064+00		3	\N	35	572
13691	2023-02-11 15:09:51.608814+00	2023-02-11 15:09:51.608876+00		3	\N	36	572
13692	2023-02-11 15:09:51.611332+00	2023-02-11 15:09:51.61135+00		3	\N	37	572
13693	2023-02-11 15:09:51.613677+00	2023-02-11 15:09:51.613698+00		1	\N	38	572
13694	2023-02-11 15:09:51.616056+00	2023-02-11 15:09:51.616082+00		3	\N	39	572
13695	2023-02-11 15:09:51.61928+00	2023-02-11 15:09:51.619299+00		1	\N	40	572
13696	2023-02-11 15:09:51.621824+00	2023-02-11 15:09:51.621842+00		4	\N	41	572
13697	2023-02-11 15:09:51.624262+00	2023-02-11 15:09:51.62428+00		5	\N	42	572
13698	2023-02-11 15:09:51.6269+00	2023-02-11 15:09:51.626927+00		4	\N	43	572
13699	2023-02-11 15:09:51.6294+00	2023-02-11 15:09:51.629433+00		4	\N	44	572
13700	2023-02-11 15:09:51.63187+00	2023-02-11 15:09:51.631889+00		5	\N	45	572
13701	2023-02-11 15:09:51.634967+00	2023-02-11 15:09:51.634987+00		5	\N	46	572
13702	2023-02-11 15:09:51.637662+00	2023-02-11 15:09:51.637681+00		4	\N	47	572
13703	2023-02-11 15:09:51.640032+00	2023-02-11 15:09:51.640049+00		5	\N	48	572
13704	2023-02-11 15:09:51.642615+00	2023-02-11 15:09:51.642642+00		5	\N	49	572
13705	2023-02-11 15:09:51.645216+00	2023-02-11 15:09:51.645242+00		5	\N	50	572
13706	2023-02-11 15:09:51.647675+00	2023-02-11 15:09:51.647693+00		5	\N	51	572
13707	2023-02-11 15:09:51.650303+00	2023-02-11 15:09:51.65036+00		5	\N	52	572
13708	2023-02-11 15:09:51.653297+00	2023-02-11 15:09:51.653315+00		4	\N	53	572
13709	2023-02-11 15:09:51.655801+00	2023-02-11 15:09:51.655821+00		3	\N	54	572
13710	2023-02-11 15:09:51.658001+00	2023-02-11 15:09:51.658021+00		3	\N	55	572
13711	2023-02-11 15:09:51.660622+00	2023-02-11 15:09:51.66064+00		1	\N	56	572
13712	2023-02-11 15:09:51.662918+00	2023-02-11 15:09:51.662942+00		1	\N	57	572
13713	2023-02-11 15:09:51.665382+00	2023-02-11 15:09:51.665399+00		3	\N	58	572
13714	2023-02-11 15:09:51.668439+00	2023-02-11 15:09:51.668467+00		4	\N	59	572
13715	2023-02-11 15:09:51.671793+00	2023-02-11 15:09:51.671826+00		3	\N	60	572
13716	2023-02-11 15:09:51.674245+00	2023-02-11 15:09:51.674306+00		4	\N	61	572
13717	2023-02-11 15:09:51.676914+00	2023-02-11 15:09:51.676933+00		1	\N	62	572
13718	2023-02-11 15:09:51.679258+00	2023-02-11 15:09:51.679279+00		1	\N	63	572
13719	2023-02-11 15:09:51.6817+00	2023-02-11 15:09:51.681718+00		4	\N	64	572
13720	2023-02-11 15:09:51.684724+00	2023-02-11 15:09:51.684762+00		3	\N	65	572
13721	2023-02-11 15:09:51.68767+00	2023-02-11 15:09:51.687689+00		4	\N	66	572
13722	2023-02-11 15:09:51.690166+00	2023-02-11 15:09:51.690207+00		4	\N	67	572
13723	2023-02-11 15:09:51.692932+00	2023-02-11 15:09:51.692951+00		4	\N	68	572
13724	2023-02-11 15:09:51.696314+00	2023-02-11 15:09:51.696416+00		3	\N	69	572
13725	2023-02-11 15:09:51.701375+00	2023-02-11 15:09:51.701405+00		1	\N	70	572
13726	2023-02-11 15:09:51.70581+00	2023-02-11 15:09:51.705833+00		3	\N	71	572
13727	2023-02-11 15:09:51.756269+00	2023-02-11 15:09:51.756297+00		1	\N	1	573
13728	2023-02-11 15:09:51.759293+00	2023-02-11 15:09:51.759317+00		1	\N	2	573
13729	2023-02-11 15:09:51.762359+00	2023-02-11 15:09:51.762389+00		1	\N	3	573
13730	2023-02-11 15:09:51.765264+00	2023-02-11 15:09:51.765291+00		3	\N	4	573
13731	2023-02-11 15:09:51.768258+00	2023-02-11 15:09:51.768286+00		3	\N	5	573
13732	2023-02-11 15:09:51.771197+00	2023-02-11 15:09:51.771228+00		3	\N	6	573
13733	2023-02-11 15:09:51.77561+00	2023-02-11 15:09:51.775631+00		3	\N	7	573
13734	2023-02-11 15:09:51.778587+00	2023-02-11 15:09:51.778615+00		1	\N	8	573
13735	2023-02-11 15:09:51.781925+00	2023-02-11 15:09:51.781954+00		3	\N	9	573
13736	2023-02-11 15:09:51.784665+00	2023-02-11 15:09:51.784695+00		3	\N	10	573
13737	2023-02-11 15:09:51.78726+00	2023-02-11 15:09:51.787279+00		3	\N	11	573
13738	2023-02-11 15:09:51.789884+00	2023-02-11 15:09:51.789912+00		1	\N	12	573
13739	2023-02-11 15:09:51.792453+00	2023-02-11 15:09:51.792481+00		3	\N	13	573
13740	2023-02-11 15:09:51.795261+00	2023-02-11 15:09:51.79529+00		3	\N	14	573
13741	2023-02-11 15:09:51.7983+00	2023-02-11 15:09:51.79832+00		3	\N	15	573
13742	2023-02-11 15:09:51.801251+00	2023-02-11 15:09:51.801277+00		3	\N	16	573
13743	2023-02-11 15:09:51.803888+00	2023-02-11 15:09:51.803912+00		3	\N	17	573
13744	2023-02-11 15:09:51.806699+00	2023-02-11 15:09:51.806725+00		3	\N	18	573
13745	2023-02-11 15:09:51.809411+00	2023-02-11 15:09:51.80944+00		3	\N	19	573
13746	2023-02-11 15:09:51.812107+00	2023-02-11 15:09:51.812133+00		3	\N	20	573
13747	2023-02-11 15:09:51.81508+00	2023-02-11 15:09:51.815133+00		1	\N	21	573
13748	2023-02-11 15:09:51.818363+00	2023-02-11 15:09:51.818395+00		3	\N	22	573
13749	2023-02-11 15:09:51.822415+00	2023-02-11 15:09:51.822442+00		3	\N	23	573
13750	2023-02-11 15:09:51.825541+00	2023-02-11 15:09:51.825568+00		3	\N	24	573
13751	2023-02-11 15:09:51.828752+00	2023-02-11 15:09:51.828778+00		3	\N	25	573
13752	2023-02-11 15:09:51.831704+00	2023-02-11 15:09:51.831733+00		1	\N	26	573
13753	2023-02-11 15:09:51.834923+00	2023-02-11 15:09:51.834952+00		1	\N	27	573
13754	2023-02-11 15:09:51.83757+00	2023-02-11 15:09:51.83759+00		3	\N	28	573
13755	2023-02-11 15:09:51.840002+00	2023-02-11 15:09:51.840022+00		1	\N	29	573
13756	2023-02-11 15:09:51.84269+00	2023-02-11 15:09:51.84271+00		1	\N	30	573
13757	2023-02-11 15:09:51.845028+00	2023-02-11 15:09:51.845047+00		1	\N	31	573
13758	2023-02-11 15:09:51.847446+00	2023-02-11 15:09:51.847465+00		1	\N	32	573
13759	2023-02-11 15:09:51.850043+00	2023-02-11 15:09:51.850071+00		1	\N	33	573
13760	2023-02-11 15:09:51.85297+00	2023-02-11 15:09:51.852991+00		3	\N	34	573
13761	2023-02-11 15:09:51.855572+00	2023-02-11 15:09:51.855599+00		3	\N	35	573
13762	2023-02-11 15:09:51.857968+00	2023-02-11 15:09:51.857989+00		1	\N	36	573
13763	2023-02-11 15:09:51.860619+00	2023-02-11 15:09:51.860639+00		1	\N	37	573
13764	2023-02-11 15:09:51.862796+00	2023-02-11 15:09:51.862835+00		1	\N	38	573
13765	2023-02-11 15:09:51.865001+00	2023-02-11 15:09:51.86503+00		1	\N	39	573
13766	2023-02-11 15:09:51.867457+00	2023-02-11 15:09:51.867487+00		1	\N	40	573
13767	2023-02-11 15:09:51.870069+00	2023-02-11 15:09:51.870099+00		1	\N	41	573
13768	2023-02-11 15:09:51.872676+00	2023-02-11 15:09:51.872705+00		3	\N	42	573
13769	2023-02-11 15:09:51.87504+00	2023-02-11 15:09:51.875131+00		3	\N	43	573
13770	2023-02-11 15:09:51.877331+00	2023-02-11 15:09:51.877349+00		1	\N	44	573
13771	2023-02-11 15:09:51.87952+00	2023-02-11 15:09:51.87954+00		3	\N	45	573
13772	2023-02-11 15:09:51.881667+00	2023-02-11 15:09:51.881687+00		1	\N	46	573
13773	2023-02-11 15:09:51.88427+00	2023-02-11 15:09:51.884299+00		3	\N	47	573
13774	2023-02-11 15:09:51.887517+00	2023-02-11 15:09:51.887547+00		3	\N	48	573
13775	2023-02-11 15:09:51.890126+00	2023-02-11 15:09:51.890147+00		3	\N	49	573
13776	2023-02-11 15:09:51.892214+00	2023-02-11 15:09:51.892234+00		1	\N	50	573
13777	2023-02-11 15:09:51.894612+00	2023-02-11 15:09:51.894632+00		1	\N	51	573
13778	2023-02-11 15:09:51.896919+00	2023-02-11 15:09:51.896938+00		3	\N	52	573
13779	2023-02-11 15:09:51.899569+00	2023-02-11 15:09:51.899589+00		1	\N	53	573
13780	2023-02-11 15:09:51.902316+00	2023-02-11 15:09:51.902338+00		1	\N	54	573
13781	2023-02-11 15:09:51.90547+00	2023-02-11 15:09:51.9055+00		1	\N	55	573
13782	2023-02-11 15:09:51.908094+00	2023-02-11 15:09:51.908113+00		1	\N	56	573
13783	2023-02-11 15:09:51.910475+00	2023-02-11 15:09:51.910496+00		1	\N	57	573
13784	2023-02-11 15:09:51.913043+00	2023-02-11 15:09:51.913063+00		1	\N	58	573
13785	2023-02-11 15:09:51.915686+00	2023-02-11 15:09:51.915715+00		1	\N	59	573
13786	2023-02-11 15:09:51.920243+00	2023-02-11 15:09:51.920273+00		1	\N	60	573
13787	2023-02-11 15:09:51.922916+00	2023-02-11 15:09:51.922944+00		1	\N	61	573
13788	2023-02-11 15:09:51.925583+00	2023-02-11 15:09:51.925605+00		1	\N	62	573
13789	2023-02-11 15:09:51.927915+00	2023-02-11 15:09:51.927935+00		1	\N	63	573
13790	2023-02-11 15:09:51.93042+00	2023-02-11 15:09:51.93044+00		1	\N	64	573
13791	2023-02-11 15:09:51.932791+00	2023-02-11 15:09:51.932811+00		1	\N	65	573
13792	2023-02-11 15:09:51.936008+00	2023-02-11 15:09:51.936036+00		1	\N	66	573
13793	2023-02-11 15:09:51.938455+00	2023-02-11 15:09:51.938506+00		1	\N	67	573
13794	2023-02-11 15:09:51.940775+00	2023-02-11 15:09:51.940798+00		1	\N	68	573
13795	2023-02-11 15:09:51.943191+00	2023-02-11 15:09:51.94321+00		1	\N	69	573
13796	2023-02-11 15:09:51.945846+00	2023-02-11 15:09:51.945891+00		1	\N	70	573
13797	2023-02-11 15:09:51.948374+00	2023-02-11 15:09:51.948395+00		1	\N	71	573
13798	2023-02-11 15:09:51.989471+00	2023-02-11 15:09:51.989492+00		5	\N	1	574
13799	2023-02-11 15:09:51.99175+00	2023-02-11 15:09:51.99177+00		5	\N	2	574
13800	2023-02-11 15:09:51.994205+00	2023-02-11 15:09:51.994225+00		5	\N	3	574
13801	2023-02-11 15:09:51.996494+00	2023-02-11 15:09:51.996515+00		5	\N	4	574
13802	2023-02-11 15:09:51.998734+00	2023-02-11 15:09:51.998755+00		5	\N	5	574
13803	2023-02-11 15:09:52.001306+00	2023-02-11 15:09:52.001336+00		5	\N	6	574
13804	2023-02-11 15:09:52.003957+00	2023-02-11 15:09:52.003978+00		5	\N	7	574
13805	2023-02-11 15:09:52.006549+00	2023-02-11 15:09:52.006576+00		5	\N	8	574
13806	2023-02-11 15:09:52.008995+00	2023-02-11 15:09:52.009021+00		5	\N	9	574
13807	2023-02-11 15:09:52.01152+00	2023-02-11 15:09:52.011541+00		5	\N	10	574
13808	2023-02-11 15:09:52.013718+00	2023-02-11 15:09:52.013738+00		5	\N	11	574
13809	2023-02-11 15:09:52.015938+00	2023-02-11 15:09:52.015959+00		5	\N	12	574
13810	2023-02-11 15:09:52.018415+00	2023-02-11 15:09:52.018442+00		5	\N	13	574
13811	2023-02-11 15:09:52.02092+00	2023-02-11 15:09:52.02097+00		5	\N	14	574
13812	2023-02-11 15:09:52.025117+00	2023-02-11 15:09:52.025142+00		5	\N	15	574
13813	2023-02-11 15:09:52.027384+00	2023-02-11 15:09:52.027405+00		5	\N	16	574
13814	2023-02-11 15:09:52.029522+00	2023-02-11 15:09:52.029542+00		5	\N	17	574
13815	2023-02-11 15:09:52.031842+00	2023-02-11 15:09:52.031862+00		2	\N	18	574
13816	2023-02-11 15:09:52.0341+00	2023-02-11 15:09:52.034122+00		4	\N	19	574
13817	2023-02-11 15:09:52.036884+00	2023-02-11 15:09:52.036911+00		1	\N	20	574
13818	2023-02-11 15:09:52.039299+00	2023-02-11 15:09:52.039319+00		2	\N	21	574
13819	2023-02-11 15:09:52.041782+00	2023-02-11 15:09:52.041802+00		3	\N	22	574
13820	2023-02-11 15:09:52.04397+00	2023-02-11 15:09:52.04399+00		3	\N	23	574
13821	2023-02-11 15:09:52.046391+00	2023-02-11 15:09:52.04641+00		2	\N	24	574
13822	2023-02-11 15:09:52.048475+00	2023-02-11 15:09:52.048499+00		2	\N	25	574
13823	2023-02-11 15:09:52.050843+00	2023-02-11 15:09:52.050864+00		4	\N	26	574
13824	2023-02-11 15:09:52.053384+00	2023-02-11 15:09:52.053404+00		1	\N	27	574
13825	2023-02-11 15:09:52.055884+00	2023-02-11 15:09:52.055904+00		4	\N	28	574
13826	2023-02-11 15:09:52.058199+00	2023-02-11 15:09:52.05822+00		5	\N	29	574
13827	2023-02-11 15:09:52.060539+00	2023-02-11 15:09:52.060559+00		5	\N	30	574
13828	2023-02-11 15:09:52.062931+00	2023-02-11 15:09:52.06295+00		5	\N	31	574
13829	2023-02-11 15:09:52.06522+00	2023-02-11 15:09:52.06524+00		5	\N	32	574
13830	2023-02-11 15:09:52.068076+00	2023-02-11 15:09:52.068099+00		5	\N	33	574
13831	2023-02-11 15:09:52.071049+00	2023-02-11 15:09:52.071073+00		5	\N	34	574
13832	2023-02-11 15:09:52.073337+00	2023-02-11 15:09:52.073356+00		5	\N	35	574
13833	2023-02-11 15:09:52.075582+00	2023-02-11 15:09:52.075604+00		5	\N	36	574
13834	2023-02-11 15:09:52.077685+00	2023-02-11 15:09:52.077704+00		2	\N	37	574
13835	2023-02-11 15:09:52.079865+00	2023-02-11 15:09:52.079884+00		1	\N	38	574
13836	2023-02-11 15:09:52.082434+00	2023-02-11 15:09:52.082453+00		1	\N	39	574
13837	2023-02-11 15:09:52.085285+00	2023-02-11 15:09:52.085307+00		1	\N	40	574
13838	2023-02-11 15:09:52.087984+00	2023-02-11 15:09:52.088008+00		5	\N	41	574
13839	2023-02-11 15:09:52.090306+00	2023-02-11 15:09:52.090325+00		3	\N	42	574
13840	2023-02-11 15:09:52.092481+00	2023-02-11 15:09:52.0925+00		1	\N	43	574
13841	2023-02-11 15:09:52.094677+00	2023-02-11 15:09:52.094696+00		5	\N	44	574
13842	2023-02-11 15:09:52.096865+00	2023-02-11 15:09:52.096884+00		5	\N	45	574
13843	2023-02-11 15:09:52.099395+00	2023-02-11 15:09:52.099418+00		3	\N	46	574
13844	2023-02-11 15:09:52.102778+00	2023-02-11 15:09:52.102823+00		5	\N	47	574
13845	2023-02-11 15:09:52.105322+00	2023-02-11 15:09:52.105342+00		5	\N	48	574
13846	2023-02-11 15:09:52.107598+00	2023-02-11 15:09:52.107621+00		5	\N	49	574
13847	2023-02-11 15:09:52.110064+00	2023-02-11 15:09:52.110084+00		5	\N	50	574
13848	2023-02-11 15:09:52.112275+00	2023-02-11 15:09:52.112294+00		5	\N	51	574
13849	2023-02-11 15:09:52.114701+00	2023-02-11 15:09:52.11473+00		5	\N	52	574
13850	2023-02-11 15:09:52.117365+00	2023-02-11 15:09:52.117393+00		5	\N	53	574
13851	2023-02-11 15:09:52.120053+00	2023-02-11 15:09:52.120072+00		5	\N	54	574
13852	2023-02-11 15:09:52.122221+00	2023-02-11 15:09:52.122242+00		2	\N	55	574
13853	2023-02-11 15:09:52.124508+00	2023-02-11 15:09:52.124529+00		3	\N	56	574
13854	2023-02-11 15:09:52.126971+00	2023-02-11 15:09:52.126991+00		3	\N	57	574
13855	2023-02-11 15:09:52.129396+00	2023-02-11 15:09:52.129418+00		5	\N	58	574
13856	2023-02-11 15:09:52.132246+00	2023-02-11 15:09:52.132264+00		5	\N	59	574
13857	2023-02-11 15:09:52.13554+00	2023-02-11 15:09:52.135571+00		5	\N	60	574
13858	2023-02-11 15:09:52.138143+00	2023-02-11 15:09:52.138168+00		5	\N	61	574
13859	2023-02-11 15:09:52.140536+00	2023-02-11 15:09:52.140557+00		5	\N	62	574
13860	2023-02-11 15:09:52.142909+00	2023-02-11 15:09:52.142931+00		1	\N	63	574
13861	2023-02-11 15:09:52.145408+00	2023-02-11 15:09:52.145435+00		5	\N	64	574
13862	2023-02-11 15:09:52.147686+00	2023-02-11 15:09:52.147705+00		1	\N	65	574
13863	2023-02-11 15:09:52.149859+00	2023-02-11 15:09:52.149878+00		3	\N	66	574
13864	2023-02-11 15:09:52.152925+00	2023-02-11 15:09:52.152945+00		5	\N	67	574
13865	2023-02-11 15:09:52.155369+00	2023-02-11 15:09:52.155388+00		5	\N	68	574
13866	2023-02-11 15:09:52.157615+00	2023-02-11 15:09:52.157634+00		5	\N	69	574
13867	2023-02-11 15:09:52.160537+00	2023-02-11 15:09:52.160557+00		5	\N	70	574
13868	2023-02-11 15:09:52.163141+00	2023-02-11 15:09:52.163161+00		5	\N	71	574
13869	2023-02-11 15:09:52.203887+00	2023-02-11 15:09:52.203909+00		5	\N	1	575
13870	2023-02-11 15:09:52.206547+00	2023-02-11 15:09:52.206567+00		5	\N	2	575
13871	2023-02-11 15:09:52.20903+00	2023-02-11 15:09:52.209049+00		4	\N	3	575
13872	2023-02-11 15:09:52.211245+00	2023-02-11 15:09:52.211314+00		4	\N	4	575
13873	2023-02-11 15:09:52.213417+00	2023-02-11 15:09:52.213436+00		5	\N	5	575
13874	2023-02-11 15:09:52.215538+00	2023-02-11 15:09:52.215558+00		5	\N	6	575
13875	2023-02-11 15:09:52.21799+00	2023-02-11 15:09:52.218041+00		5	\N	7	575
13876	2023-02-11 15:09:52.220483+00	2023-02-11 15:09:52.220508+00		5	\N	8	575
13877	2023-02-11 15:09:52.22307+00	2023-02-11 15:09:52.223111+00		5	\N	9	575
13878	2023-02-11 15:09:52.225547+00	2023-02-11 15:09:52.225566+00		4	\N	10	575
13879	2023-02-11 15:09:52.227965+00	2023-02-11 15:09:52.227984+00		4	\N	11	575
13880	2023-02-11 15:09:52.230275+00	2023-02-11 15:09:52.230296+00		3	\N	12	575
13881	2023-02-11 15:09:52.232518+00	2023-02-11 15:09:52.232539+00		3	\N	13	575
13882	2023-02-11 15:09:52.236101+00	2023-02-11 15:09:52.236122+00		5	\N	14	575
13883	2023-02-11 15:09:52.241547+00	2023-02-11 15:09:52.241593+00		5	\N	15	575
13884	2023-02-11 15:09:52.243761+00	2023-02-11 15:09:52.24378+00		5	\N	16	575
13885	2023-02-11 15:09:52.246194+00	2023-02-11 15:09:52.246215+00		5	\N	17	575
13886	2023-02-11 15:09:52.248464+00	2023-02-11 15:09:52.248483+00		4	\N	18	575
13887	2023-02-11 15:09:52.25081+00	2023-02-11 15:09:52.250839+00		5	\N	19	575
13888	2023-02-11 15:09:52.253333+00	2023-02-11 15:09:52.253353+00		5	\N	20	575
13889	2023-02-11 15:09:52.255714+00	2023-02-11 15:09:52.255733+00		4	\N	21	575
13890	2023-02-11 15:09:52.257935+00	2023-02-11 15:09:52.257954+00		3	\N	22	575
13891	2023-02-11 15:09:52.260404+00	2023-02-11 15:09:52.260446+00		4	\N	23	575
13892	2023-02-11 15:09:52.262612+00	2023-02-11 15:09:52.262631+00		4	\N	24	575
13893	2023-02-11 15:09:52.26486+00	2023-02-11 15:09:52.264881+00		3	\N	25	575
13894	2023-02-11 15:09:52.267857+00	2023-02-11 15:09:52.267885+00		4	\N	26	575
13895	2023-02-11 15:09:52.270543+00	2023-02-11 15:09:52.270562+00		5	\N	27	575
13896	2023-02-11 15:09:52.272755+00	2023-02-11 15:09:52.272775+00		4	\N	28	575
13897	2023-02-11 15:09:52.274841+00	2023-02-11 15:09:52.27486+00		4	\N	29	575
13898	2023-02-11 15:09:52.276964+00	2023-02-11 15:09:52.276985+00		5	\N	30	575
13899	2023-02-11 15:09:52.279292+00	2023-02-11 15:09:52.279311+00		4	\N	31	575
13900	2023-02-11 15:09:52.281784+00	2023-02-11 15:09:52.281811+00		5	\N	32	575
13901	2023-02-11 15:09:52.284782+00	2023-02-11 15:09:52.284806+00		4	\N	33	575
13902	2023-02-11 15:09:52.287312+00	2023-02-11 15:09:52.287331+00		5	\N	34	575
13903	2023-02-11 15:09:52.28946+00	2023-02-11 15:09:52.289485+00		5	\N	35	575
13904	2023-02-11 15:09:52.291583+00	2023-02-11 15:09:52.291603+00		1	\N	36	575
13905	2023-02-11 15:09:52.293888+00	2023-02-11 15:09:52.293907+00		4	\N	37	575
13906	2023-02-11 15:09:52.296147+00	2023-02-11 15:09:52.296166+00		3	\N	38	575
13907	2023-02-11 15:09:52.29845+00	2023-02-11 15:09:52.298469+00		4	\N	39	575
13908	2023-02-11 15:09:52.30107+00	2023-02-11 15:09:52.301112+00		3	\N	40	575
13909	2023-02-11 15:09:52.303829+00	2023-02-11 15:09:52.303849+00		4	\N	41	575
13910	2023-02-11 15:09:52.306103+00	2023-02-11 15:09:52.306122+00		3	\N	42	575
13911	2023-02-11 15:09:52.308511+00	2023-02-11 15:09:52.308537+00		4	\N	43	575
13912	2023-02-11 15:09:52.310903+00	2023-02-11 15:09:52.310931+00		5	\N	44	575
13913	2023-02-11 15:09:52.315507+00	2023-02-11 15:09:52.315527+00		4	\N	45	575
13914	2023-02-11 15:09:52.318483+00	2023-02-11 15:09:52.318528+00		4	\N	46	575
13915	2023-02-11 15:09:52.320971+00	2023-02-11 15:09:52.321001+00		3	\N	47	575
13916	2023-02-11 15:09:52.323279+00	2023-02-11 15:09:52.323297+00		5	\N	48	575
13917	2023-02-11 15:09:52.325707+00	2023-02-11 15:09:52.325727+00		4	\N	49	575
13918	2023-02-11 15:09:52.328115+00	2023-02-11 15:09:52.328134+00		4	\N	50	575
13919	2023-02-11 15:09:52.330552+00	2023-02-11 15:09:52.330571+00		4	\N	51	575
13920	2023-02-11 15:09:52.332671+00	2023-02-11 15:09:52.332689+00		5	\N	52	575
13921	2023-02-11 15:09:52.335596+00	2023-02-11 15:09:52.335615+00		5	\N	53	575
13922	2023-02-11 15:09:52.338134+00	2023-02-11 15:09:52.338153+00		4	\N	54	575
13923	2023-02-11 15:09:52.34035+00	2023-02-11 15:09:52.340369+00		4	\N	55	575
13924	2023-02-11 15:09:52.343137+00	2023-02-11 15:09:52.343164+00		4	\N	56	575
13925	2023-02-11 15:09:52.346083+00	2023-02-11 15:09:52.346104+00		4	\N	57	575
13926	2023-02-11 15:09:52.3484+00	2023-02-11 15:09:52.348429+00		4	\N	58	575
13927	2023-02-11 15:09:52.351319+00	2023-02-11 15:09:52.351344+00		4	\N	59	575
13928	2023-02-11 15:09:52.35388+00	2023-02-11 15:09:52.3539+00		5	\N	60	575
13929	2023-02-11 15:09:52.356182+00	2023-02-11 15:09:52.356201+00		4	\N	61	575
13930	2023-02-11 15:09:52.358544+00	2023-02-11 15:09:52.358564+00		3	\N	62	575
13931	2023-02-11 15:09:52.360814+00	2023-02-11 15:09:52.360834+00		3	\N	63	575
13932	2023-02-11 15:09:52.363012+00	2023-02-11 15:09:52.363031+00		3	\N	64	575
13933	2023-02-11 15:09:52.365302+00	2023-02-11 15:09:52.365321+00		4	\N	65	575
13934	2023-02-11 15:09:52.367935+00	2023-02-11 15:09:52.367962+00		3	\N	66	575
13935	2023-02-11 15:09:52.370583+00	2023-02-11 15:09:52.370602+00		3	\N	67	575
13936	2023-02-11 15:09:52.373101+00	2023-02-11 15:09:52.373123+00		3	\N	68	575
13937	2023-02-11 15:09:52.375576+00	2023-02-11 15:09:52.375599+00		4	\N	69	575
13938	2023-02-11 15:09:52.377907+00	2023-02-11 15:09:52.377927+00		3	\N	70	575
13939	2023-02-11 15:09:52.380045+00	2023-02-11 15:09:52.380064+00		3	\N	71	575
13940	2023-02-11 15:09:52.418715+00	2023-02-11 15:09:52.418737+00		4	\N	1	576
13941	2023-02-11 15:09:52.421501+00	2023-02-11 15:09:52.421529+00		4	\N	2	576
13942	2023-02-11 15:09:52.423933+00	2023-02-11 15:09:52.423953+00		1	\N	3	576
13943	2023-02-11 15:09:52.426199+00	2023-02-11 15:09:52.426219+00		3	\N	4	576
13944	2023-02-11 15:09:52.428428+00	2023-02-11 15:09:52.428449+00		2	\N	5	576
13945	2023-02-11 15:09:52.430562+00	2023-02-11 15:09:52.430581+00		3	\N	6	576
13946	2023-02-11 15:09:52.432745+00	2023-02-11 15:09:52.432765+00		3	\N	7	576
13947	2023-02-11 15:09:52.435446+00	2023-02-11 15:09:52.435466+00		3	\N	8	576
13948	2023-02-11 15:09:52.438061+00	2023-02-11 15:09:52.438087+00		3	\N	9	576
13949	2023-02-11 15:09:52.440295+00	2023-02-11 15:09:52.440314+00		2	\N	10	576
13950	2023-02-11 15:09:52.442465+00	2023-02-11 15:09:52.442484+00		3	\N	11	576
13951	2023-02-11 15:09:52.444736+00	2023-02-11 15:09:52.444754+00		4	\N	12	576
13952	2023-02-11 15:09:52.446865+00	2023-02-11 15:09:52.446884+00		1	\N	13	576
13953	2023-02-11 15:09:52.449046+00	2023-02-11 15:09:52.449077+00		3	\N	14	576
13954	2023-02-11 15:09:52.452583+00	2023-02-11 15:09:52.452609+00		2	\N	15	576
13955	2023-02-11 15:09:52.455156+00	2023-02-11 15:09:52.455177+00		2	\N	16	576
13956	2023-02-11 15:09:52.457296+00	2023-02-11 15:09:52.457316+00		2	\N	17	576
13957	2023-02-11 15:09:52.45963+00	2023-02-11 15:09:52.459649+00		2	\N	18	576
13958	2023-02-11 15:09:52.461813+00	2023-02-11 15:09:52.461833+00		4	\N	19	576
13959	2023-02-11 15:09:52.464062+00	2023-02-11 15:09:52.464081+00		2	\N	20	576
13960	2023-02-11 15:09:52.466709+00	2023-02-11 15:09:52.466741+00		1	\N	21	576
13961	2023-02-11 15:09:52.469739+00	2023-02-11 15:09:52.469759+00		2	\N	22	576
13962	2023-02-11 15:09:52.471928+00	2023-02-11 15:09:52.471948+00		2	\N	23	576
13963	2023-02-11 15:09:52.474193+00	2023-02-11 15:09:52.474211+00		2	\N	24	576
13964	2023-02-11 15:09:52.478636+00	2023-02-11 15:09:52.478661+00		1	\N	25	576
13965	2023-02-11 15:09:52.481079+00	2023-02-11 15:09:52.481108+00		3	\N	26	576
13966	2023-02-11 15:09:52.483748+00	2023-02-11 15:09:52.483782+00		3	\N	27	576
13967	2023-02-11 15:09:52.486773+00	2023-02-11 15:09:52.486792+00		4	\N	28	576
13968	2023-02-11 15:09:52.489026+00	2023-02-11 15:09:52.489045+00		4	\N	29	576
13969	2023-02-11 15:09:52.491102+00	2023-02-11 15:09:52.49113+00		2	\N	30	576
13970	2023-02-11 15:09:52.493275+00	2023-02-11 15:09:52.493294+00		2	\N	31	576
13971	2023-02-11 15:09:52.495525+00	2023-02-11 15:09:52.495545+00		4	\N	32	576
13972	2023-02-11 15:09:52.497834+00	2023-02-11 15:09:52.497853+00		4	\N	33	576
13973	2023-02-11 15:09:52.500236+00	2023-02-11 15:09:52.500265+00		5	\N	34	576
13974	2023-02-11 15:09:52.503046+00	2023-02-11 15:09:52.503066+00		3	\N	35	576
13975	2023-02-11 15:09:52.505368+00	2023-02-11 15:09:52.505388+00		1	\N	36	576
13976	2023-02-11 15:09:52.507482+00	2023-02-11 15:09:52.507501+00		1	\N	37	576
13977	2023-02-11 15:09:52.509635+00	2023-02-11 15:09:52.509656+00		1	\N	38	576
13978	2023-02-11 15:09:52.511933+00	2023-02-11 15:09:52.511952+00		1	\N	39	576
13979	2023-02-11 15:09:52.514278+00	2023-02-11 15:09:52.514298+00		1	\N	40	576
13980	2023-02-11 15:09:52.516452+00	2023-02-11 15:09:52.516472+00		1	\N	41	576
13981	2023-02-11 15:09:52.519483+00	2023-02-11 15:09:52.519503+00		3	\N	42	576
13982	2023-02-11 15:09:52.521688+00	2023-02-11 15:09:52.521708+00		3	\N	43	576
13983	2023-02-11 15:09:52.523751+00	2023-02-11 15:09:52.52377+00		1	\N	44	576
13984	2023-02-11 15:09:52.525969+00	2023-02-11 15:09:52.525996+00		1	\N	45	576
13985	2023-02-11 15:09:52.529421+00	2023-02-11 15:09:52.52944+00		3	\N	46	576
13986	2023-02-11 15:09:52.532056+00	2023-02-11 15:09:52.532076+00		1	\N	47	576
13987	2023-02-11 15:09:52.534596+00	2023-02-11 15:09:52.534617+00		3	\N	48	576
13988	2023-02-11 15:09:52.53701+00	2023-02-11 15:09:52.537041+00		1	\N	49	576
13989	2023-02-11 15:09:52.539263+00	2023-02-11 15:09:52.539288+00		1	\N	50	576
13990	2023-02-11 15:09:52.541748+00	2023-02-11 15:09:52.541771+00		3	\N	51	576
13991	2023-02-11 15:09:52.544077+00	2023-02-11 15:09:52.544097+00		5	\N	52	576
13992	2023-02-11 15:09:52.546408+00	2023-02-11 15:09:52.546428+00		1	\N	53	576
13993	2023-02-11 15:09:52.548649+00	2023-02-11 15:09:52.548669+00		1	\N	54	576
13994	2023-02-11 15:09:52.551579+00	2023-02-11 15:09:52.551612+00		4	\N	55	576
13995	2023-02-11 15:09:52.554249+00	2023-02-11 15:09:52.554269+00		1	\N	56	576
13996	2023-02-11 15:09:52.556855+00	2023-02-11 15:09:52.556874+00		1	\N	57	576
13997	2023-02-11 15:09:52.559407+00	2023-02-11 15:09:52.559432+00		1	\N	58	576
13998	2023-02-11 15:09:52.561665+00	2023-02-11 15:09:52.561685+00		1	\N	59	576
13999	2023-02-11 15:09:52.563903+00	2023-02-11 15:09:52.563923+00		1	\N	60	576
14000	2023-02-11 15:09:52.566288+00	2023-02-11 15:09:52.566307+00		5	\N	61	576
14001	2023-02-11 15:09:52.569476+00	2023-02-11 15:09:52.569495+00		1	\N	62	576
14002	2023-02-11 15:09:52.572354+00	2023-02-11 15:09:52.572375+00		1	\N	63	576
14003	2023-02-11 15:09:52.574588+00	2023-02-11 15:09:52.574609+00		5	\N	64	576
14004	2023-02-11 15:09:52.576982+00	2023-02-11 15:09:52.577001+00		1	\N	65	576
14005	2023-02-11 15:09:52.579352+00	2023-02-11 15:09:52.579372+00		1	\N	66	576
14006	2023-02-11 15:09:52.581783+00	2023-02-11 15:09:52.581802+00		1	\N	67	576
14007	2023-02-11 15:09:52.584659+00	2023-02-11 15:09:52.584678+00		1	\N	68	576
14008	2023-02-11 15:09:52.587498+00	2023-02-11 15:09:52.587519+00		1	\N	69	576
14009	2023-02-11 15:09:52.589792+00	2023-02-11 15:09:52.589811+00		1	\N	70	576
14010	2023-02-11 15:09:52.592161+00	2023-02-11 15:09:52.59218+00		1	\N	71	576
\.


--
-- Data for Name: questionnaire_feedbackquestionnaire; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questionnaire_feedbackquestionnaire (id, created_at, modified_at, feedback_date) FROM stdin;
\.


--
-- Data for Name: questionnaire_questionnaire; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questionnaire_questionnaire (id, created_at, modified_at, applied_date, document, uploaded_at, employee_id) FROM stdin;
65	2023-02-11 15:09:46.129315+00	2023-02-11 15:09:52.412654+00	\N	documents/2023/02/11/Zeppelin_Um_instrumento_para_diagnosticar_-_Brasil_-_V3_respostas_3Uv3WP8.xls	2023-02-11 15:09:46.16155+00	494
\.


--
-- Data for Name: questionnaire_questionnaireexcel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questionnaire_questionnaireexcel (questionnaire_ptr_id, feedback_questionnaire_id) FROM stdin;
\.


--
-- Data for Name: questionnaire_questionnairegoogleforms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questionnaire_questionnairegoogleforms (questionnaire_ptr_id) FROM stdin;
65
\.


--
-- Data for Name: questionnaire_statement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questionnaire_statement (id, created_at, modified_at, code, statement, pe_element_id, sth_stage_id, continuous_activity_id) FROM stdin;
3	2022-04-20 23:52:19.299126+00	2022-04-21 13:56:02.836334+00	AO.03	As equipes dos projetos são pequenas (geralmente entre 4 e 8 desenvolvedores), autoorganizadas e multidisciplinares.	10	1	\N
2	2022-04-20 23:51:47.813991+00	2022-04-21 17:38:48.364207+00	AO.02	As equipes dos projetos incluem um papel (p.ex., product owner) que é responsável por representar o cliente e participa ativamente nos projetos.	10	1	\N
5	2022-04-20 23:53:44.2693+00	2022-04-21 19:59:22.923565+00	AO.05	O escopo do projeto é definido gradativamente, utilizando-se um Product Backlog (ou artefato equivalente).	2	1	\N
6	2022-04-20 23:54:13.353724+00	2022-04-21 20:00:10.439237+00	AO.06	Estimativas de esforço são realizadas pela equipe de desenvolvimento (ou em conjunto com ela) considerando-se tarefas curtas para implementar um conjunto de requisitos selecionados (e não o projeto como um todo).	2	1	\N
7	2022-04-21 00:58:52.0712+00	2022-04-21 20:00:45.919731+00	AO.07	Estimativas de custos são estabelecidas com base nas estimativas de esforço, considerando-se o esforço necessário para implementar um conjunto de requisitos selecionados (e não o projeto como um todo).	2	1	\N
8	2022-04-21 00:59:30.929446+00	2022-04-21 20:01:45.831861+00	AO.08	O processo de desenvolvimento é ágil, sendo realizado de forma iterativa, em ciclos curtos (p.ex., duas semanas), nos quais requisitos do produto definidos em um Product Backlog (ou artefato equivalente) são selecionados, registrados em um Sprint Backlog (ou artefato equivalente) e desenvolvidos.	10	1	\N
9	2022-04-21 00:59:57.411885+00	2022-04-21 20:04:02.533192+00	AO.09	Há critérios de aceitação claros para os requisitos do software e eles são usados para avaliar os artefatos produzidos (p.ex., funcionalidades) e definir se estão "prontos".	3	1	\N
10	2022-04-21 01:01:23.438428+00	2022-04-21 20:05:15.658904+00	AO.10	O cliente recebe novas versões do produto com frequência (após um ou mais ciclos curtos de desenvolvimento), incluindo novas funcionalidades definidas de acordo com as necessidades do cliente.	10	1	\N
11	2022-04-21 01:02:07.262405+00	2022-04-21 20:06:33.942597+00	AO.11	O processo de desenvolvimento (ágil) está alinhado ao negócio da organização e isso é percebido pela entrega de valor ao cliente e pela sua satisfação com o produto entregue.	2	1	\N
12	2022-04-21 01:02:53.839359+00	2022-04-21 20:07:25.030442+00	AO.12	Há pelo menos um papel (p.ex., tech lead, analista de qualidade) responsável pela qualidade dos artefatos produzidos e do produto final.	10	1	\N
13	2022-04-21 01:03:19.792488+00	2022-04-21 20:08:25.789783+00	AO.13	Os stakeholders do projeto (incluindo o cliente) são estimulados a refletir sobre seu sobre seu papel e suas responsabilidades no projeto.	15	1	\N
14	2022-04-21 01:03:43.169637+00	2022-04-21 20:09:56.179769+00	AO.14	A equipe do projeto possui autonomia para tomar decisões técnicas no projeto.	10	1	\N
15	2022-04-21 01:04:19.299579+00	2022-04-21 20:14:43.525057+00	AO.15	Frequentemente (p.ex.., diariamente, a cada dois ou três dias) a equipe se reúne e reflete sobre o progresso do desenvolvimento no âmbito do que foi definido para o time-box corrente e ajusta as tarefas se necessário (p.ex., em daily ou stand up meetings).	10	1	\N
16	2022-04-21 01:04:50.015686+00	2022-04-21 20:15:53.639605+00	AO.16	A equipe se reúne com frequência ao longo do projeto para discutir sobre melhorias no produto, no processo ou nas ferramentas usadas (p.ex., em reunião de retrospectiva).	10	1	\N
18	2022-04-21 01:05:53.237115+00	2022-04-21 20:19:01.776805+00	AO.18	O processo de desenvolvimento (ágil) é avaliado e melhorado continuamente.	10	1	\N
20	2022-04-21 01:06:56.672596+00	2022-04-21 20:20:59.249799+00	AO.20	Boas práticas de testes (p.ex., teste automatizado, desenvolvimento orientado a testes) são adotadas.	10	1	\N
21	2022-04-21 01:07:31.269354+00	2022-04-21 20:22:19.689682+00	AO.21	Dados são coletados para métricas que permitem avaliar aspectos da qualidade dos artefatos produzidos e do produto (p.ex., complexidade ciclomática, quantidade de code smells).	6	1	\N
22	2022-04-21 01:08:08.441558+00	2022-04-21 20:23:43.712679+00	AO.22	Dados são coletados para métricas que permitem avaliar aspectos de desempenho do processo de desenvolvimento ágil (p.ex., work in progress, velocidade).	6	1	\N
23	2022-04-21 01:08:36.65291+00	2022-04-21 20:25:33.693491+00	AO.23	Dados produzidos ao longo do processo de desenvolvimento (p.ex., data de início das tarefas, data de conclusão das tarefas, pontos de história das tarefas) são armazenados em um (ou mais) repositório de dados.	19	1	\N
24	2022-04-21 01:09:03.228514+00	2022-04-21 20:26:43.472797+00	AO.24	Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de desenvolvimento ágil.	2	1	\N
25	2022-04-21 01:09:43.722935+00	2022-04-21 20:27:55.817649+00	AO.25	Decisões nos projetos são tomadas com base em dados presentes no(s) repositório(s) de dados.	2	1	\N
26	2022-04-21 01:10:04.765487+00	2022-04-21 20:28:50.899278+00	AO.26	São realizadas ações para compartilhar conhecimento relevante ao desenvolvimento ágil (p.ex., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	21	1	\N
27	2022-04-21 01:10:55.766429+00	2022-04-21 20:56:06.956587+00	CI.01	A arquitetura do software é modular de forma a permitir a realização de testes automatizados.	5	2	\N
28	2022-04-21 01:11:25.802349+00	2022-04-21 20:56:46.071413+00	CI.02	A arquitetura do software é modular de forma a permitir a realização de builds automatizados.	5	2	\N
29	2022-04-21 01:12:06.711464+00	2022-04-21 20:57:43.217319+00	CI.03	O código é integrado constantemente e automaticamente.	13	2	\N
30	2022-04-21 01:12:31.837813+00	2022-04-21 20:58:48.629206+00	CI.04	Testes são executados automaticamente, periodicamente (p.ex., sempre que código novo é integrado), em um ambiente de teste, para verificar a qualidade do código (p.ex., cobertura, corretude).	7	2	\N
31	2022-04-21 01:13:06.639702+00	2022-04-21 21:00:36.620255+00	CI.05	Testes automatizados são utilizados para avaliar se o software implementado atende os requisitos estabelecidos.	1	2	\N
32	2022-04-21 01:13:45.228724+00	2022-04-21 21:01:23.607104+00	CI.06	Builds ocorrem frequentemente e automaticamente.	9	2	\N
33	2022-04-21 01:14:18.756192+00	2022-04-21 21:02:10.631385+00	CI.07	Builds são cancelados caso um ou mais testes falhem.	9	2	\N
35	2022-04-21 01:15:14.130421+00	2022-04-21 21:03:51.963945+00	CI.09	Boas práticas de check in são aplicadas no trunk de desenvolvimento (p.ex., uso de ferramentas como GitFlow e Toogle Feature).	16	2	\N
64	2022-04-21 01:31:10.771993+00	2022-04-21 21:18:25.244208+00	IS.06	São adotadas tecnologias (p.ex.., tecnologias de nuvem) que permitem potencializar a experimentação.	23	4	\N
17	2022-04-21 01:05:16.18986+00	2023-02-11 14:48:02.121346+00	AO.17	A equipe se reúne com frequência ao longo do projeto para discutir sobre melhorias nas competências dos membros da equipe (p.ex., em reunião de retrospectiva).	14	1	\N
34	2022-04-21 01:14:44.406886+00	2023-02-11 14:48:39.263587+00	CI.08	Há controle de versões dos artefatos de software (p.ex., código, teste, scripts etc.) em um repositório.	18	2	\N
37	2022-04-21 01:16:03.009454+00	2023-02-11 14:49:06.417378+00	CI.11	Dados são coletados para métricas que permitem avaliar o processo de integração contínua (p.ex., quantidade de builds cancelados, quantidade de integrações de código realizadas).	6	2	\N
65	2022-04-21 01:31:33.316999+00	2023-02-11 14:52:29.087231+00	IS.07	A organização continuamente experimenta novas tecnologias e metodologias.	20	4	\N
19	2022-04-21 01:06:22.663795+00	2023-02-11 14:56:34.588178+00	AO.19	Boas práticas de programação são adotadas (p.ex., código coletivo, codificação padronizada, programação em pares, revisão de código).	17	1	\N
67	2022-04-21 01:32:22.85681+00	2022-04-21 21:21:59.613281+00	IS.09	Dados do repositório de dados dos clientes/consumidores são usados na tomada de decisão pela área de desenvolvimento de software.	14	4	\N
69	2022-04-21 01:33:40.908151+00	2022-04-21 21:22:46.321581+00	IS.11	Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos e baseando-se em dados do(s) repositório(a) de dados dos clientes/consumidores.	14	4	\N
70	2022-04-21 01:34:10.155812+00	2022-04-21 21:24:58.30116+00	IS.12	O processo de experimentação contínua é avaliado e melhorado continuamente.	19	4	\N
71	2022-04-21 01:34:43.259049+00	2022-04-21 21:25:55.387752+00	IS.13	São realizadas ações para compartilhar conhecimento relacionado a experimentação  contínua (e.g., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	21	4	\N
1	2022-04-20 23:51:03.463834+00	2022-04-21 13:50:47.321946+00	AO.01	Papéis envolvidos no processo de desenvolvimento ágil (e.g., Scrum Master, Product Owner, Desenvolvedor e Tester) existem na organização.	25	1	\N
42	2022-04-21 01:19:57.292325+00	2022-04-21 20:30:59.996485+00	CD.01	Os principais clientes/consumidores são identificados e participam do processo de desenvolvimento, influenciando nas funcionalidades que serão produzidas e entregues.	24	3	\N
43	2022-04-21 01:20:38.505851+00	2022-04-21 20:32:29.706131+00	CD.02	Há um fluxo de informação claro entre Desenvolvimento e Operação, permitindo que novas funcionalidades desenvolvidas entrem em operação automaticamente.	25	3	\N
44	2022-04-21 01:21:05.177907+00	2022-04-21 20:34:59.923048+00	CD.03	A entrega de novas funcionalidades é realizada automaticamente e por releases.	12	3	\N
45	2022-04-21 01:21:33.954898+00	2022-04-21 20:36:20.764401+00	CD.04	Há um fluxo de informação claro entre Operação e Negócio, permitindo que novas necessidades dos clientes/consumidores e oportunidades de negócio sejam identificadas a partir da entrega de novas funcionalidades.	25	3	\N
46	2022-04-21 01:22:22.752268+00	2022-04-21 20:38:00.702283+00	CD.05	A arquitetura do software permite realizar entrega (deploy) de funcionalidades de forma independente.	5	3	\N
47	2022-04-21 01:22:46.243868+00	2022-04-21 20:39:13.098099+00	CD.06	Clientes/consumidores recebem novas funcionalidades com frequência, inclusive, em ciclos mais curtos do que o time-box que costuma ser estabelecido no processo de desenvolvimento.	11	3	\N
48	2022-04-21 01:23:06.97643+00	2022-04-21 20:40:51.553966+00	CD.07	Os clientes podem realizar testes no produto assim que é feita a entrega (deploy) de novas funcionalidades.	28	3	\N
49	2022-04-21 01:23:38.762256+00	2022-04-21 20:41:36.398201+00	CD.08	O modelo de negócio da organização é constantemente avaliado e revisto (quando necessário) com base em informações dos clientes/consumidores.	28	3	\N
50	2022-04-21 01:24:11.89722+00	2022-04-21 20:42:15.678612+00	CD.09	Estratégias de marketing são constantemente avaliadas e revistas (quando necessário) com base em informações dos lead customers (clientes/consumidores mais relevantes para a organização).	28	3	\N
51	2022-04-21 01:24:34.944101+00	2022-04-21 20:42:55.859639+00	CD.10	Estratégias de venda são constantemente avaliadas e revistas (quando necessário) com base em informações dos lead customers (clientes/consumidores mais relevantes para a organização).	28	3	\N
52	2022-04-21 01:25:06.059734+00	2022-04-21 20:44:27.730941+00	CD.11	Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos.	25	3	\N
53	2022-04-21 01:25:33.991394+00	2022-04-21 20:46:48.201148+00	CD.12	Alinhamento entre o desenvolvimento dos produtos e o negócio da organização é mantido através de verificações contínuas, em ciclos curtos e baseando-se em dados.	25	3	\N
54	2022-04-21 01:26:05.638847+00	2022-04-21 20:49:43.408728+00	CD.13	Dados são coletados para métricas que permitem avaliar o processo de entrega contínua  (p.ex., quantidade de releases, densidade de defeitos nas releases).	21	3	\N
55	2022-04-21 01:26:29.638524+00	2022-04-21 20:51:27.735553+00	CD.14	Dados produzidos nos ambientes de entrega contínua (p.ex., data das releases e versão do software entregue)  são armazenados em um (ou mais) repositório de dados.	19	3	\N
56	2022-04-21 01:26:57.239858+00	2022-04-21 20:52:37.815325+00	CD.15	O  processo de entrega contínua é avaliado e melhorado continuamente.	11	3	\N
57	2022-04-21 01:27:26.02039+00	2022-04-21 20:54:12.727105+00	CD.16	Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de entrega contínua.	21	3	\N
58	2022-04-21 01:27:54.984195+00	2022-04-21 20:54:53.981122+00	CD.17	São realizadas ações para compartilhar conhecimento relacionado a entrega contínua (e.g., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	21	3	\N
40	2022-04-21 01:17:57.405673+00	2022-04-21 21:10:33.058488+00	CI.14	Dados armazenados no(s) repositório(s) de dados são usados para melhorar o produto e o processo de integração contínua.	6	2	\N
60	2022-04-21 01:29:43.504714+00	2022-04-21 21:13:46.834805+00	IS.02	Feedbacks (dados e opiniões) dos clientes/consumidores (capturados contínua e automaticamente) são utilizados para melhorar os produtos (melhorar funcionalidades existentes e identificar novas).	24	4	\N
4	2022-04-20 23:53:05.947438+00	2022-04-21 19:57:33.227017+00	AO.04	Com o intuito de entregar valor para o cliente, os requisitos são definidos e priorizados de acordo com as necessidades do cliente, são periodicamente revisados e mudanças são absorvidas em iterações do processo de desenvolvimento.	10	1	\N
41	2022-04-21 01:18:23.179693+00	2022-04-21 21:11:35.162226+00	CI.15	São realizadas ações para compartilhar conhecimento relacionado a integração contínua (p.ex., palestras internas, tutoriais, repositórios de conhecimento, implementação de guilds).	21	2	\N
36	2022-04-21 01:15:37.993803+00	2023-02-11 14:47:47.587578+00	CI.10	Há práticas que permitem que organizações ou pessoas externas ao projeto atuem na implementação do produto (i.e., produzam e integrem código ao produto sendo desenvolvido).	10	2	\N
59	2022-04-21 01:29:15.741744+00	2023-02-11 14:50:18.596104+00	IS.01	Feedbacks (dados e opiniões) dos clientes/consumidores são capturados contínua e automaticamente e armazenados em um (ou mais) repositório de dados de clientes/consumidores.	20	4	\N
63	2022-04-21 01:30:49.785745+00	2023-02-11 14:50:44.023408+00	IS.05	Experimentos (p.ex., testes A/B) são realizados com os clientes/consumidores para melhorar os produtos.	27	4	\N
68	2022-04-21 01:32:55.417332+00	2023-02-11 14:50:59.67989+00	IS.10	Dados do(s) repositório(a) de dados dos clientes/consumidores são usados na tomada de decisão pela área de negócios.	28	4	\N
39	2022-04-21 01:17:24.400576+00	2023-02-11 14:51:37.293773+00	CI.13	O processo de integração contínua (incluindo a realização de testes automatizados) é avaliado e melhorado continuamente.	6	2	\N
66	2022-04-21 01:31:58.851597+00	2023-02-11 14:56:06.750327+00	IS.08	Há um fluxo de informação claro entre o nível estratégico e a área de desenvolvimento da organização, permitindo que dados dos clientes/consumidores (capturados contínua e automaticamente) sejam utilizados de forma alinhada na tomada de decisões técnicas e de negócio.	25	4	\N
62	2022-04-21 01:30:24.862205+00	2023-02-11 15:09:25.033541+00	IS.04	Feedbacks (dados e opiniões) dos clientes/consumidores (capturados contínua e automaticamente) são usados para experimentação e inovação.	27	4	\N
61	2022-04-21 01:30:04.187815+00	2023-02-11 14:49:30.220872+00	IS.03	A organização identifica novas oportunidades de negócio com base nos feedbacks capturados automaticamente dos clientes/consumidores.	24	4	\N
38	2022-04-21 01:16:42.860032+00	2023-02-11 14:49:49.917199+00	CI.12	Dados produzidos nos ambientes de integração contínua (p.ex., data das builds, quantidade de testes executados e percentual de cobertura)  são armazenados em um (ou mais) repositório de dados.	6	2	\N
\.


--
-- Data for Name: questionnaire_statement_fcse_processes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.questionnaire_statement_fcse_processes (id, statement_id, process_id) FROM stdin;
1	1	6
2	2	6
3	3	6
4	4	6
5	5	6
6	6	6
7	7	6
8	8	6
9	9	6
10	10	6
11	11	6
12	12	6
13	13	6
14	14	6
15	15	6
16	16	6
17	17	6
18	18	6
19	19	6
20	20	6
21	21	6
22	22	6
23	23	6
24	24	6
25	25	6
26	26	6
27	27	7
28	28	7
29	29	7
30	30	7
31	31	7
32	32	7
33	33	7
34	34	7
35	35	7
36	36	7
37	37	7
38	38	7
39	39	7
40	40	7
41	41	7
42	42	8
43	43	8
44	44	8
45	45	8
46	46	8
47	47	8
48	48	8
49	49	8
50	50	8
51	51	8
52	52	8
53	53	8
54	54	8
55	55	8
56	56	8
57	57	8
58	58	8
59	59	9
60	60	9
61	61	9
62	62	9
63	63	9
64	64	9
65	65	9
66	66	9
67	67	9
68	68	9
69	69	9
70	70	9
71	71	9
72	1	1
73	2	2
74	3	2
75	4	1
76	4	2
77	5	2
78	6	2
79	7	2
80	8	2
81	8	3
82	9	10
83	9	3
84	10	2
85	11	1
86	12	3
87	13	5
88	14	4
89	15	4
90	16	4
91	17	5
92	18	3
93	19	3
94	20	3
95	21	10
96	21	3
97	22	10
98	22	2
99	22	3
100	23	5
101	24	2
102	24	10
103	24	4
104	24	5
105	25	2
106	25	4
107	26	5
108	42	1
109	42	2
110	42	4
111	43	1
112	43	2
113	43	4
114	44	1
115	44	2
116	44	4
117	45	1
118	45	2
119	45	4
120	46	1
121	46	10
122	46	3
123	47	1
124	48	5
125	49	1
126	50	1
127	51	1
128	52	1
129	53	1
130	53	2
131	53	10
132	53	4
133	54	5
134	55	5
135	56	4
136	57	5
137	58	5
138	27	3
139	28	2
140	29	2
141	30	10
142	30	2
143	30	3
144	31	3
145	32	2
146	33	2
147	33	3
148	34	2
149	35	2
150	36	2
151	36	4
152	37	10
153	37	2
154	37	3
155	38	10
156	38	3
157	39	10
158	39	3
159	39	4
160	39	5
161	40	10
162	40	3
163	40	4
164	40	5
165	41	4
166	41	5
167	59	5
168	60	1
169	60	5
170	61	1
171	62	4
172	62	5
173	63	1
174	63	2
175	63	4
176	63	5
177	63	10
178	64	4
179	65	4
180	65	5
181	66	1
182	66	2
183	67	2
184	67	3
185	67	4
186	67	5
187	67	10
188	69	1
189	69	2
190	70	4
191	70	5
192	71	5
\.


--
-- Data for Name: sth_stage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sth_stage (id, created_at, modified_at, name, description) FROM stdin;
2	2022-04-20 22:54:21.383909+00	2022-04-20 22:58:59.431788+00	Integração Contínua	Caracterizam-se principalmente pela integração contínua e automatizada de código, realização de builds automatizados e de testes automatizados, que são realizados em um ambiente de testes.
3	2022-04-20 22:55:49.247933+00	2022-04-20 22:59:29.60142+00	Entrega Contínua	Dizem respeito a práticas realizadas para que releases do software sejam continuamente e automaticamente entregues aos clientes/consumidores. Informações dos clientes/consumidores acerca das funcionalidades entregues são usadas para melhorar o produto (p.ex., identificar novas funcionalidades) e identificar novas oportunidades de negócio.
4	2022-04-20 22:57:44.115421+00	2022-04-21 15:12:20.271198+00	P&D como Sistema de Inovação	Dizem respeito a práticas realizadas para coletar, *contínua e automaticamente*, feedback de clientes/consumidores. É utilizada *experimentação* (p.ex., testes A/B) para coleta de feedback visando à melhoria dos produtos. Os dados obtidos dos clientes/consumidores são armazenados em um repositório e são usados para melhorar os produtos e o negócio da organização.
1	2022-04-20 22:52:58.053278+00	2022-04-21 15:12:36.880964+00	Desenvolvimento Ágil	A seguir são apresentadas práticas relacionadas ao desenvolvimento de software ágil,  incluindo desenvolvimento iterativo, incremental, em ciclos curtos, com equipes pequenas e auto-organizadas, que trabalham visando à entrega de valor ao cliente.
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 168, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 2, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: continuous_star_continuousactivities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.continuous_star_continuousactivities_id_seq', 4, true);


--
-- Name: continuous_star_continuousactivity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.continuous_star_continuousactivity_id_seq', 15, true);


--
-- Name: cse_framework_process_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cse_framework_process_id_seq', 10, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1018, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 40, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 55, true);


--
-- Name: employee_academiccategorydegree_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_academiccategorydegree_id_seq', 3, true);


--
-- Name: employee_academicdegree_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_academicdegree_id_seq', 6, true);


--
-- Name: employee_academicdegreestatus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_academicdegreestatus_id_seq', 2, true);


--
-- Name: employee_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_employee_id_seq', 494, true);


--
-- Name: employee_employeeknowledge_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_employeeknowledge_id_seq', 521, true);


--
-- Name: employee_experiencelevel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_experiencelevel_id_seq', 4, true);


--
-- Name: employee_knwoledgelevel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_knwoledgelevel_id_seq', 4, true);


--
-- Name: employee_position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_position_id_seq', 12, true);


--
-- Name: employee_sthstageexperiencelevel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_sthstageexperiencelevel_id_seq', 1829, true);


--
-- Name: employee_sthstageknwoledgelevel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_sthstageknwoledgelevel_id_seq', 1940, true);


--
-- Name: employee_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_team_id_seq', 1, false);


--
-- Name: organization_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_location_id_seq', 27, true);


--
-- Name: organization_organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_organization_id_seq', 576, true);


--
-- Name: organization_organizationcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_organizationcategory_id_seq', 3, true);


--
-- Name: organization_organizationtype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_organizationtype_id_seq', 10, true);


--
-- Name: organization_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_region_id_seq', 5, true);


--
-- Name: organization_size_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_size_id_seq', 4, true);


--
-- Name: practitioners_eye_dimension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.practitioners_eye_dimension_id_seq', 9, true);


--
-- Name: practitioners_eye_element_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.practitioners_eye_element_id_seq', 28, true);


--
-- Name: questionnaire_adoptedlevel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_adoptedlevel_id_seq', 5, true);


--
-- Name: questionnaire_answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_answer_id_seq', 14010, true);


--
-- Name: questionnaire_feedbackquestionnaire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_feedbackquestionnaire_id_seq', 1, false);


--
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_questionnaire_id_seq', 65, true);


--
-- Name: questionnaire_statement_fcse_processes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_statement_fcse_processes_id_seq', 192, true);


--
-- Name: questionnaire_statement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_statement_id_seq', 71, true);


--
-- Name: sth_stage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sth_stage_id_seq', 4, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: continuous_star_continuousphase continuous_star_continuousactivities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.continuous_star_continuousphase
    ADD CONSTRAINT continuous_star_continuousactivities_pkey PRIMARY KEY (id);


--
-- Name: continuous_star_continuousactivity continuous_star_continuousactivity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.continuous_star_continuousactivity
    ADD CONSTRAINT continuous_star_continuousactivity_pkey PRIMARY KEY (id);


--
-- Name: cse_framework_process cse_framework_process_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cse_framework_process
    ADD CONSTRAINT cse_framework_process_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: employee_academicdegreecategory employee_academiccategorydegree_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_academicdegreecategory
    ADD CONSTRAINT employee_academiccategorydegree_pkey PRIMARY KEY (id);


--
-- Name: employee_academicdegree employee_academicdegree_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_academicdegree
    ADD CONSTRAINT employee_academicdegree_pkey PRIMARY KEY (id);


--
-- Name: employee_academicdegreestatus employee_academicdegreestatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_academicdegreestatus
    ADD CONSTRAINT employee_academicdegreestatus_pkey PRIMARY KEY (id);


--
-- Name: employee_employee employee_employee_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employee
    ADD CONSTRAINT employee_employee_email_key UNIQUE (email);


--
-- Name: employee_employee employee_employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employee
    ADD CONSTRAINT employee_employee_pkey PRIMARY KEY (id);


--
-- Name: employee_employeeknowledge employee_employeeknowledge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employeeknowledge
    ADD CONSTRAINT employee_employeeknowledge_pkey PRIMARY KEY (id);


--
-- Name: employee_experiencelevel employee_experiencelevel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_experiencelevel
    ADD CONSTRAINT employee_experiencelevel_pkey PRIMARY KEY (id);


--
-- Name: employee_knwoledgelevel employee_knwoledgelevel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_knwoledgelevel
    ADD CONSTRAINT employee_knwoledgelevel_pkey PRIMARY KEY (id);


--
-- Name: employee_position employee_position_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_position
    ADD CONSTRAINT employee_position_pkey PRIMARY KEY (id);


--
-- Name: employee_sthstageexperiencelevel employee_sthstageexperiencelevel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageexperiencelevel
    ADD CONSTRAINT employee_sthstageexperiencelevel_pkey PRIMARY KEY (id);


--
-- Name: employee_sthstageknwoledgelevel employee_sthstageknwoledgelevel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageknwoledgelevel
    ADD CONSTRAINT employee_sthstageknwoledgelevel_pkey PRIMARY KEY (id);


--
-- Name: employee_team employee_team_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_team
    ADD CONSTRAINT employee_team_pkey PRIMARY KEY (id);


--
-- Name: organization_state organization_location_name_68be1ff6_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_state
    ADD CONSTRAINT organization_location_name_68be1ff6_uniq UNIQUE (name);


--
-- Name: organization_state organization_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_state
    ADD CONSTRAINT organization_location_pkey PRIMARY KEY (id);


--
-- Name: organization_organization organization_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organization
    ADD CONSTRAINT organization_organization_pkey PRIMARY KEY (id);


--
-- Name: organization_organizationcategory organization_organizationcategory_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organizationcategory
    ADD CONSTRAINT organization_organizationcategory_name_key UNIQUE (name);


--
-- Name: organization_organizationcategory organization_organizationcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organizationcategory
    ADD CONSTRAINT organization_organizationcategory_pkey PRIMARY KEY (id);


--
-- Name: organization_organizationtype organization_organizationtype_name_48626b1d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organizationtype
    ADD CONSTRAINT organization_organizationtype_name_48626b1d_uniq UNIQUE (name);


--
-- Name: organization_organizationtype organization_organizationtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organizationtype
    ADD CONSTRAINT organization_organizationtype_pkey PRIMARY KEY (id);


--
-- Name: organization_region organization_region_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_region
    ADD CONSTRAINT organization_region_name_key UNIQUE (name);


--
-- Name: organization_region organization_region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_region
    ADD CONSTRAINT organization_region_pkey PRIMARY KEY (id);


--
-- Name: organization_size organization_size_name_7ae124c0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_size
    ADD CONSTRAINT organization_size_name_7ae124c0_uniq UNIQUE (name);


--
-- Name: organization_size organization_size_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_size
    ADD CONSTRAINT organization_size_pkey PRIMARY KEY (id);


--
-- Name: practitioners_eye_dimension practitioners_eye_dimension_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practitioners_eye_dimension
    ADD CONSTRAINT practitioners_eye_dimension_name_key UNIQUE (name);


--
-- Name: practitioners_eye_dimension practitioners_eye_dimension_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practitioners_eye_dimension
    ADD CONSTRAINT practitioners_eye_dimension_pkey PRIMARY KEY (id);


--
-- Name: practitioners_eye_element practitioners_eye_element_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practitioners_eye_element
    ADD CONSTRAINT practitioners_eye_element_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_adoptedlevel questionnaire_adoptedlevel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_adoptedlevel
    ADD CONSTRAINT questionnaire_adoptedlevel_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_answer questionnaire_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_answer
    ADD CONSTRAINT questionnaire_answer_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_feedbackquestionnaire questionnaire_feedbackquestionnaire_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_feedbackquestionnaire
    ADD CONSTRAINT questionnaire_feedbackquestionnaire_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_questionnaireexcel questionnaire_questionarexcel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_questionnaireexcel
    ADD CONSTRAINT questionnaire_questionarexcel_pkey PRIMARY KEY (questionnaire_ptr_id);


--
-- Name: questionnaire_questionnaire questionnaire_questionnaire_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_questionnaire
    ADD CONSTRAINT questionnaire_questionnaire_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_questionnairegoogleforms questionnaire_questionnairegoogleforms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_questionnairegoogleforms
    ADD CONSTRAINT questionnaire_questionnairegoogleforms_pkey PRIMARY KEY (questionnaire_ptr_id);


--
-- Name: questionnaire_statement_fcse_processes questionnaire_statement__statement_id_process_id_0ee10736_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement_fcse_processes
    ADD CONSTRAINT questionnaire_statement__statement_id_process_id_0ee10736_uniq UNIQUE (statement_id, process_id);


--
-- Name: questionnaire_statement_fcse_processes questionnaire_statement_fcse_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement_fcse_processes
    ADD CONSTRAINT questionnaire_statement_fcse_processes_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_statement questionnaire_statement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement
    ADD CONSTRAINT questionnaire_statement_pkey PRIMARY KEY (id);


--
-- Name: sth_stage sth_stage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sth_stage
    ADD CONSTRAINT sth_stage_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: continuous_star_continuous_continuous_phases_id_c9803afc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX continuous_star_continuous_continuous_phases_id_c9803afc ON public.continuous_star_continuousactivity USING btree (continuous_phase_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: employee_academicdegree_category_id_52f2311e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_academicdegree_category_id_52f2311e ON public.employee_academicdegree USING btree (category_id);


--
-- Name: employee_employee_email_29cdd800_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_employee_email_29cdd800_like ON public.employee_employee USING btree (email varchar_pattern_ops);


--
-- Name: employee_employee_organization_id_42bc9624; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_employee_organization_id_42bc9624 ON public.employee_employee USING btree (organization_id);


--
-- Name: employee_employee_position_id_7083276e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_employee_position_id_7083276e ON public.employee_employee USING btree (position_id);


--
-- Name: employee_employeeknowledge_academic_degree_id_81460b89; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_employeeknowledge_academic_degree_id_81460b89 ON public.employee_employeeknowledge USING btree (academic_degree_id);


--
-- Name: employee_employeeknowledge_academic_degree_status_id_c2aa9a46; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_employeeknowledge_academic_degree_status_id_c2aa9a46 ON public.employee_employeeknowledge USING btree (academic_degree_status_id);


--
-- Name: employee_employeeknowledge_employee_id_425d4851; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_employeeknowledge_employee_id_425d4851 ON public.employee_employeeknowledge USING btree (employee_id);


--
-- Name: employee_sthstageexperiencelevel_employee_id_883ca9c5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_sthstageexperiencelevel_employee_id_883ca9c5 ON public.employee_sthstageexperiencelevel USING btree (employee_id);


--
-- Name: employee_sthstageexperiencelevel_experience_level_id_4bfc36b4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_sthstageexperiencelevel_experience_level_id_4bfc36b4 ON public.employee_sthstageexperiencelevel USING btree (experience_level_id);


--
-- Name: employee_sthstageexperiencelevel_stage_id_3e949aa0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_sthstageexperiencelevel_stage_id_3e949aa0 ON public.employee_sthstageexperiencelevel USING btree (stage_id);


--
-- Name: employee_sthstageknwoledgelevel_employee_id_363555fd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_sthstageknwoledgelevel_employee_id_363555fd ON public.employee_sthstageknwoledgelevel USING btree (employee_id);


--
-- Name: employee_sthstageknwoledgelevel_knwoledge_level_id_fef8c1c6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_sthstageknwoledgelevel_knwoledge_level_id_fef8c1c6 ON public.employee_sthstageknwoledgelevel USING btree (knwoledge_level_id);


--
-- Name: employee_sthstageknwoledgelevel_stage_id_046d53a5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_sthstageknwoledgelevel_stage_id_046d53a5 ON public.employee_sthstageknwoledgelevel USING btree (stage_id);


--
-- Name: employee_team_organization_id_f3fc6980; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_team_organization_id_f3fc6980 ON public.employee_team USING btree (organization_id);


--
-- Name: employee_team_responsible_id_2d724980; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX employee_team_responsible_id_2d724980 ON public.employee_team USING btree (responsible_id);


--
-- Name: organization_location_name_68be1ff6_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_location_name_68be1ff6_like ON public.organization_state USING btree (name varchar_pattern_ops);


--
-- Name: organization_organization_location_id_19ea47fd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_organization_location_id_19ea47fd ON public.organization_organization USING btree (location_id);


--
-- Name: organization_organization_organizaton_size_id_deb5c037; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_organization_organizaton_size_id_deb5c037 ON public.organization_organization USING btree (organization_size_id);


--
-- Name: organization_organization_organizaton_type_id_e8fbac84; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_organization_organizaton_type_id_e8fbac84 ON public.organization_organization USING btree (organization_type_id);


--
-- Name: organization_organizationcategory_name_8170fa7e_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_organizationcategory_name_8170fa7e_like ON public.organization_organizationcategory USING btree (name varchar_pattern_ops);


--
-- Name: organization_organizationtype_category_id_96df7376; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_organizationtype_category_id_96df7376 ON public.organization_organizationtype USING btree (category_id);


--
-- Name: organization_organizationtype_name_48626b1d_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_organizationtype_name_48626b1d_like ON public.organization_organizationtype USING btree (name varchar_pattern_ops);


--
-- Name: organization_region_name_82f2cda3_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_region_name_82f2cda3_like ON public.organization_region USING btree (name varchar_pattern_ops);


--
-- Name: organization_size_name_7ae124c0_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_size_name_7ae124c0_like ON public.organization_size USING btree (name varchar_pattern_ops);


--
-- Name: organization_state_region_id_a0fd0664; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX organization_state_region_id_a0fd0664 ON public.organization_state USING btree (region_id);


--
-- Name: practitioners_eye_dimension_name_9af9defe_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX practitioners_eye_dimension_name_9af9defe_like ON public.practitioners_eye_dimension USING btree (name varchar_pattern_ops);


--
-- Name: practitioners_eye_element_category_id_dcb302eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX practitioners_eye_element_category_id_dcb302eb ON public.practitioners_eye_element USING btree (dimension_id);


--
-- Name: questionnaire_answer_adopted_level_id_cb3ff0bf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_answer_adopted_level_id_cb3ff0bf ON public.questionnaire_answer USING btree (adopted_level_id);


--
-- Name: questionnaire_answer_organization_id_5dbca384; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_answer_organization_id_5dbca384 ON public.questionnaire_answer USING btree (organization_id);


--
-- Name: questionnaire_answer_questionnaire_id_13524168; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_answer_questionnaire_id_13524168 ON public.questionnaire_answer USING btree (questionnaire_id);


--
-- Name: questionnaire_answer_statement_id_ebc46171; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_answer_statement_id_ebc46171 ON public.questionnaire_answer USING btree (statement_id);


--
-- Name: questionnaire_questionarex_feedback_questionnaire_id_9bca65c5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_questionarex_feedback_questionnaire_id_9bca65c5 ON public.questionnaire_questionnaireexcel USING btree (feedback_questionnaire_id);


--
-- Name: questionnaire_questionnaire_employee_id_608919d1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_questionnaire_employee_id_608919d1 ON public.questionnaire_questionnaire USING btree (employee_id);


--
-- Name: questionnaire_statement_continuous_activity_id_9a69c14c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_statement_continuous_activity_id_9a69c14c ON public.questionnaire_statement USING btree (continuous_activity_id);


--
-- Name: questionnaire_statement_fcse_processes_process_id_2c182cba; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_statement_fcse_processes_process_id_2c182cba ON public.questionnaire_statement_fcse_processes USING btree (process_id);


--
-- Name: questionnaire_statement_fcse_processes_statement_id_123c7fec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_statement_fcse_processes_statement_id_123c7fec ON public.questionnaire_statement_fcse_processes USING btree (statement_id);


--
-- Name: questionnaire_statement_pe_element_id_9dbc1c13; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_statement_pe_element_id_9dbc1c13 ON public.questionnaire_statement USING btree (pe_element_id);


--
-- Name: questionnaire_statement_sth_stage_id_30e32ff9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX questionnaire_statement_sth_stage_id_30e32ff9 ON public.questionnaire_statement USING btree (sth_stage_id);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: continuous_star_continuousactivity continuous_star_cont_continuous_phase_id_4913847f_fk_continuou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.continuous_star_continuousactivity
    ADD CONSTRAINT continuous_star_cont_continuous_phase_id_4913847f_fk_continuou FOREIGN KEY (continuous_phase_id) REFERENCES public.continuous_star_continuousphase(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_academicdegree employee_academicdeg_category_id_52f2311e_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_academicdegree
    ADD CONSTRAINT employee_academicdeg_category_id_52f2311e_fk_employee_ FOREIGN KEY (category_id) REFERENCES public.employee_academicdegreecategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_employee employee_employee_organization_id_42bc9624_fk_organizat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employee
    ADD CONSTRAINT employee_employee_organization_id_42bc9624_fk_organizat FOREIGN KEY (organization_id) REFERENCES public.organization_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_employee employee_employee_position_id_7083276e_fk_employee_position_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employee
    ADD CONSTRAINT employee_employee_position_id_7083276e_fk_employee_position_id FOREIGN KEY (position_id) REFERENCES public.employee_position(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_employeeknowledge employee_employeekno_academic_degree_id_81460b89_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employeeknowledge
    ADD CONSTRAINT employee_employeekno_academic_degree_id_81460b89_fk_employee_ FOREIGN KEY (academic_degree_id) REFERENCES public.employee_academicdegree(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_employeeknowledge employee_employeekno_academic_degree_stat_c2aa9a46_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employeeknowledge
    ADD CONSTRAINT employee_employeekno_academic_degree_stat_c2aa9a46_fk_employee_ FOREIGN KEY (academic_degree_status_id) REFERENCES public.employee_academicdegreestatus(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_employeeknowledge employee_employeekno_employee_id_425d4851_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_employeeknowledge
    ADD CONSTRAINT employee_employeekno_employee_id_425d4851_fk_employee_ FOREIGN KEY (employee_id) REFERENCES public.employee_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_sthstageexperiencelevel employee_sthstageexp_employee_id_883ca9c5_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageexperiencelevel
    ADD CONSTRAINT employee_sthstageexp_employee_id_883ca9c5_fk_employee_ FOREIGN KEY (employee_id) REFERENCES public.employee_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_sthstageexperiencelevel employee_sthstageexp_experience_level_id_4bfc36b4_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageexperiencelevel
    ADD CONSTRAINT employee_sthstageexp_experience_level_id_4bfc36b4_fk_employee_ FOREIGN KEY (experience_level_id) REFERENCES public.employee_experiencelevel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_sthstageexperiencelevel employee_sthstageexp_stage_id_3e949aa0_fk_sth_stage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageexperiencelevel
    ADD CONSTRAINT employee_sthstageexp_stage_id_3e949aa0_fk_sth_stage FOREIGN KEY (stage_id) REFERENCES public.sth_stage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_sthstageknwoledgelevel employee_sthstageknw_employee_id_363555fd_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageknwoledgelevel
    ADD CONSTRAINT employee_sthstageknw_employee_id_363555fd_fk_employee_ FOREIGN KEY (employee_id) REFERENCES public.employee_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_sthstageknwoledgelevel employee_sthstageknw_knwoledge_level_id_fef8c1c6_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageknwoledgelevel
    ADD CONSTRAINT employee_sthstageknw_knwoledge_level_id_fef8c1c6_fk_employee_ FOREIGN KEY (knwoledge_level_id) REFERENCES public.employee_knwoledgelevel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_sthstageknwoledgelevel employee_sthstageknw_stage_id_046d53a5_fk_sth_stage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_sthstageknwoledgelevel
    ADD CONSTRAINT employee_sthstageknw_stage_id_046d53a5_fk_sth_stage FOREIGN KEY (stage_id) REFERENCES public.sth_stage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_team employee_team_organization_id_f3fc6980_fk_organizat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_team
    ADD CONSTRAINT employee_team_organization_id_f3fc6980_fk_organizat FOREIGN KEY (organization_id) REFERENCES public.organization_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: employee_team employee_team_responsible_id_2d724980_fk_employee_employee_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_team
    ADD CONSTRAINT employee_team_responsible_id_2d724980_fk_employee_employee_id FOREIGN KEY (responsible_id) REFERENCES public.employee_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_organizationtype organization_organiz_category_id_96df7376_fk_organizat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organizationtype
    ADD CONSTRAINT organization_organiz_category_id_96df7376_fk_organizat FOREIGN KEY (category_id) REFERENCES public.organization_organizationcategory(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_organization organization_organiz_location_id_19ea47fd_fk_organizat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organization
    ADD CONSTRAINT organization_organiz_location_id_19ea47fd_fk_organizat FOREIGN KEY (location_id) REFERENCES public.organization_state(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_organization organization_organiz_organization_size_id_330cd63d_fk_organizat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organization
    ADD CONSTRAINT organization_organiz_organization_size_id_330cd63d_fk_organizat FOREIGN KEY (organization_size_id) REFERENCES public.organization_size(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_organization organization_organiz_organization_type_id_c2dc164b_fk_organizat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_organization
    ADD CONSTRAINT organization_organiz_organization_type_id_c2dc164b_fk_organizat FOREIGN KEY (organization_type_id) REFERENCES public.organization_organizationtype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organization_state organization_state_region_id_a0fd0664_fk_organization_region_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization_state
    ADD CONSTRAINT organization_state_region_id_a0fd0664_fk_organization_region_id FOREIGN KEY (region_id) REFERENCES public.organization_region(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: practitioners_eye_element practitioners_eye_el_dimension_id_7a82ca94_fk_practitio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practitioners_eye_element
    ADD CONSTRAINT practitioners_eye_el_dimension_id_7a82ca94_fk_practitio FOREIGN KEY (dimension_id) REFERENCES public.practitioners_eye_dimension(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_answer questionnaire_answer_adopted_level_id_cb3ff0bf_fk_questionn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_answer
    ADD CONSTRAINT questionnaire_answer_adopted_level_id_cb3ff0bf_fk_questionn FOREIGN KEY (adopted_level_id) REFERENCES public.questionnaire_adoptedlevel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_answer questionnaire_answer_organization_id_5dbca384_fk_organizat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_answer
    ADD CONSTRAINT questionnaire_answer_organization_id_5dbca384_fk_organizat FOREIGN KEY (organization_id) REFERENCES public.organization_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_answer questionnaire_answer_questionnaire_id_13524168_fk_questionn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_answer
    ADD CONSTRAINT questionnaire_answer_questionnaire_id_13524168_fk_questionn FOREIGN KEY (questionnaire_id) REFERENCES public.questionnaire_questionnaire(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_answer questionnaire_answer_statement_id_ebc46171_fk_questionn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_answer
    ADD CONSTRAINT questionnaire_answer_statement_id_ebc46171_fk_questionn FOREIGN KEY (statement_id) REFERENCES public.questionnaire_statement(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_questionnaire questionnaire_questi_employee_id_608919d1_fk_employee_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_questionnaire
    ADD CONSTRAINT questionnaire_questi_employee_id_608919d1_fk_employee_ FOREIGN KEY (employee_id) REFERENCES public.employee_employee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_questionnaireexcel questionnaire_questi_feedback_questionnai_9bca65c5_fk_questionn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_questionnaireexcel
    ADD CONSTRAINT questionnaire_questi_feedback_questionnai_9bca65c5_fk_questionn FOREIGN KEY (feedback_questionnaire_id) REFERENCES public.questionnaire_feedbackquestionnaire(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_questionnaireexcel questionnaire_questi_questionnaire_ptr_id_53818270_fk_questionn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_questionnaireexcel
    ADD CONSTRAINT questionnaire_questi_questionnaire_ptr_id_53818270_fk_questionn FOREIGN KEY (questionnaire_ptr_id) REFERENCES public.questionnaire_questionnaire(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_questionnairegoogleforms questionnaire_questi_questionnaire_ptr_id_f6b1f330_fk_questionn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_questionnairegoogleforms
    ADD CONSTRAINT questionnaire_questi_questionnaire_ptr_id_f6b1f330_fk_questionn FOREIGN KEY (questionnaire_ptr_id) REFERENCES public.questionnaire_questionnaire(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_statement questionnaire_statem_continuous_activity__9a69c14c_fk_continuou; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement
    ADD CONSTRAINT questionnaire_statem_continuous_activity__9a69c14c_fk_continuou FOREIGN KEY (continuous_activity_id) REFERENCES public.continuous_star_continuousactivity(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_statement questionnaire_statem_pe_element_id_9dbc1c13_fk_practitio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement
    ADD CONSTRAINT questionnaire_statem_pe_element_id_9dbc1c13_fk_practitio FOREIGN KEY (pe_element_id) REFERENCES public.practitioners_eye_element(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_statement_fcse_processes questionnaire_statem_process_id_2c182cba_fk_cse_frame; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement_fcse_processes
    ADD CONSTRAINT questionnaire_statem_process_id_2c182cba_fk_cse_frame FOREIGN KEY (process_id) REFERENCES public.cse_framework_process(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_statement_fcse_processes questionnaire_statem_statement_id_123c7fec_fk_questionn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement_fcse_processes
    ADD CONSTRAINT questionnaire_statem_statement_id_123c7fec_fk_questionn FOREIGN KEY (statement_id) REFERENCES public.questionnaire_statement(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: questionnaire_statement questionnaire_statement_sth_stage_id_30e32ff9_fk_sth_stage_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire_statement
    ADD CONSTRAINT questionnaire_statement_sth_stage_id_30e32ff9_fk_sth_stage_id FOREIGN KEY (sth_stage_id) REFERENCES public.sth_stage(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--


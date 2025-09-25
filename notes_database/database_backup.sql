--
-- PostgreSQL database dump
--

\restrict vgfsbgy4vM7e3poxesrWBbrzQGnChZcStOp25I762xhypyVeF40YQPkAKN4meu8

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

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

DROP DATABASE IF EXISTS myapp;
--
-- Name: myapp; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE myapp WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE myapp OWNER TO postgres;

\unrestrict vgfsbgy4vM7e3poxesrWBbrzQGnChZcStOp25I762xhypyVeF40YQPkAKN4meu8
\connect myapp
\restrict vgfsbgy4vM7e3poxesrWBbrzQGnChZcStOp25I762xhypyVeF40YQPkAKN4meu8

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: appuser
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO appuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: notes; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.notes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notes OWNER TO appuser;

--
-- Name: users; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    display_name text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO appuser;

--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.notes (id, user_id, title, content, created_at, updated_at) FROM stdin;
b0382477-fed1-4d1a-aaf2-0d0ec0062154	9e45f8bb-8a2e-4a09-b931-72c761e9b1af	Welcome to Notes	This is your first note. You can edit or delete it.	2025-09-25 11:53:53.328063+00	2025-09-25 11:53:53.328063+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.users (id, email, password_hash, display_name, is_active, created_at, updated_at) FROM stdin;
9e45f8bb-8a2e-4a09-b931-72c761e9b1af	demo@example.com	$2y$12$QhZ3zP9Q9sYQdemoPlaceholderHashJgB7q7b8mY1z	Demo User	t	2025-09-25 11:53:53.325789+00	2025-09-25 11:53:53.325789+00
\.


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_notes_created_at; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_notes_created_at ON public.notes USING btree (created_at);


--
-- Name: idx_notes_user_id; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_notes_user_id ON public.notes USING btree (user_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: notes trg_notes_set_updated_at; Type: TRIGGER; Schema: public; Owner: appuser
--

CREATE TRIGGER trg_notes_set_updated_at BEFORE UPDATE ON public.notes FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: users trg_users_set_updated_at; Type: TRIGGER; Schema: public; Owner: appuser
--

CREATE TRIGGER trg_users_set_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: notes fk_notes_user; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_notes_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: DATABASE myapp; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE myapp TO appuser;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO appuser;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v1() TO appuser;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v1mc() TO appuser;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v3(namespace uuid, name text) TO appuser;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v4() TO appuser;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v5(namespace uuid, name text) TO appuser;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_nil() TO appuser;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_ns_dns() TO appuser;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_ns_oid() TO appuser;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_ns_url() TO appuser;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_ns_x500() TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TYPES TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO appuser;


--
-- PostgreSQL database dump complete
--

\unrestrict vgfsbgy4vM7e3poxesrWBbrzQGnChZcStOp25I762xhypyVeF40YQPkAKN4meu8


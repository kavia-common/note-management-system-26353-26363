-- Core schema for notes application (PostgreSQL)
-- This script is intended to be run by a superuser or database owner.
-- It creates the necessary tables, constraints, and indexes for the app.

-- Important: Followed requirement to use single-statement commands by ensuring
-- each CREATE/ALTER/COMMENT/GRANT is a single statement.

-- Create extension for UUID generation if not present (idempotent)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table: stores application users
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    display_name TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Notes table: stores user notes
CREATE TABLE IF NOT EXISTS public.notes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_notes_user FOREIGN KEY (user_id) REFERENCES public.users (id) ON DELETE CASCADE
);

-- Indexes to optimize queries
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users (email);
CREATE INDEX IF NOT EXISTS idx_notes_user_id ON public.notes (user_id);
CREATE INDEX IF NOT EXISTS idx_notes_created_at ON public.notes (created_at);

-- Trigger function to auto-update updated_at timestamps
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers to update updated_at on row modification
DROP TRIGGER IF EXISTS trg_users_set_updated_at ON public.users;
CREATE TRIGGER trg_users_set_updated_at
BEFORE UPDATE ON public.users
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_notes_set_updated_at ON public.notes;
CREATE TRIGGER trg_notes_set_updated_at
BEFORE UPDATE ON public.notes
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- Minimal seed to help initial testing (safe/idempotent upserts)
-- Create an initial demo user if not exists
INSERT INTO public.users (id, email, password_hash, display_name)
SELECT uuid_generate_v4(), 'demo@example.com', '$2y$12$QhZ3zP9Q9sYQdemoPlaceholderHashJgB7q7b8mY1z', 'Demo User'
WHERE NOT EXISTS (SELECT 1 FROM public.users WHERE email = 'demo@example.com');

-- Create a sample note for the demo user
INSERT INTO public.notes (id, user_id, title, content)
SELECT uuid_generate_v4(), u.id, 'Welcome to Notes', 'This is your first note. You can edit or delete it.'
FROM public.users u
WHERE u.email = 'demo@example.com'
AND NOT EXISTS (SELECT 1 FROM public.notes n WHERE n.user_id = u.id);

-- supabase-schema.sql
--
-- Corre isto uma vez, inteiro, no SQL Editor do Supabase (Dashboard → SQL Editor → New query → Run).
--
-- Os nomes das colunas são exatamente os mesmos nomes que o código já usa (startTime, endTime,
-- birthDate, etc.) — foi deliberado, para o JavaScript não precisar de nenhuma tradução de campos.
--
-- IMPORTANTE sobre segurança: as políticas abaixo dão acesso de leitura E escrita a QUALQUER
-- pessoa que tenha o URL e a "anon key" do projeto (que vão ficar visíveis no código da página —
-- é inevitável numa app só de frontend, sem servidor). Não há login nem password nenhuma a
-- proteger os dados. Isto é uma troca deliberada: é o que torna possível o Tomás editar sem
-- conta nenhuma. Mantém o URL do site fora de sítios públicos (não o publiques nas redes sociais,
-- por exemplo) — a "segurança" aqui é só o link não ser conhecido de mais ninguém.

create extension if not exists pgcrypto;

-- ---------- EVENTOS (Agenda) ----------
create table events (
  id uuid primary key default gen_random_uuid(),
  category text,
  title text not null,
  date date not null,
  "startTime" text,
  "endTime" text,
  notes text,
  "createdAt" timestamptz default now()
);
alter table events enable row level security;
create policy "public select" on events for select using (true);
create policy "public insert" on events for insert with check (true);
create policy "public update" on events for update using (true);
create policy "public delete" on events for delete using (true);

-- ---------- HORÁRIO ESCOLAR ----------
-- uma única linha (id='main') com todas as aulas dentro de "slots", tal como estava no Claude
create table schedule (
  id text primary key,
  slots jsonb not null default '[]'::jsonb
);
alter table schedule enable row level security;
create policy "public select" on schedule for select using (true);
create policy "public insert" on schedule for insert with check (true);
create policy "public update" on schedule for update using (true);
create policy "public delete" on schedule for delete using (true);

-- ---------- ANIVERSÁRIOS ----------
create table birthdays (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  "birthDate" date not null,
  "partyDate" date,
  "rsvpBy" date,
  responded boolean default false,
  notes text,
  "createdAt" timestamptz default now()
);
alter table birthdays enable row level security;
create policy "public select" on birthdays for select using (true);
create policy "public insert" on birthdays for insert with check (true);
create policy "public update" on birthdays for update using (true);
create policy "public delete" on birthdays for delete using (true);

-- ---------- Realtime (para as mudanças aparecerem sozinhas nos outros telemóveis) ----------
alter publication supabase_realtime add table events, schedule, birthdays;

-- ============================================================
-- DADOS QUE JÁ EXISTIAM NO ARTEFACTO — para não perderes nada
-- ============================================================

insert into events (id, category, title, date, "startTime", "endTime", notes, "createdAt") values
  (gen_random_uuid(), 'hoquei_treino', 'Treino Sub-15 Reduzido', '2026-09-18', '19:45', '20:30', 'Pavilhão ELA', '2026-09-17T21:23:56.509Z'),
  (gen_random_uuid(), 'hoquei_jogo', 'Jogo Mealhada', '2026-09-19', '15:00', '16:00', 'Pavilhão HC Mealhada
Concentração às 14h', '2026-09-17T21:27:04.326Z'),
  (gen_random_uuid(), 'outro', 'Treino Sub-15', '2026-09-17', '20:00', '21:00', 'Pavilhão Escola Livre de Azeméis', '2026-09-17T00:00:00.000Z');

insert into schedule (id, slots) values ('main', '[
  {"day":"Segunda","end":"10:15","id":"seg1","start":"08:30","subject":"Português · Sala B3"},
  {"day":"Segunda","end":"11:20","id":"seg2","start":"10:30","subject":"Físico-Química · Sala B3"},
  {"day":"Segunda","end":"13:15","id":"seg3","start":"11:25","subject":"Ciências Naturais · Sala B3"},
  {"day":"Segunda","end":"15:10","id":"seg4","start":"13:25","subject":"Matemática · Sala B3"},
  {"day":"Segunda","end":"16:10","id":"seg5","start":"15:20","subject":"TIC · Sala A4"},
  {"day":"Segunda","end":"17:15","id":"seg6","start":"16:25","subject":"Francês · Sala B3"},
  {"day":"Terça","end":"09:20","id":"ter1","start":"08:30","subject":"Direção de Turma · Sala B3"},
  {"day":"Terça","end":"10:15","id":"ter2","start":"09:25","subject":"História · Sala B3"},
  {"day":"Terça","end":"11:20","id":"ter3","start":"10:30","subject":"Francês / Inglês · Sala B3"},
  {"day":"Terça","end":"13:15","id":"ter4","start":"11:25","subject":"Educação Física · Pavilhão"},
  {"day":"Terça","end":"15:10","id":"ter5","start":"14:20","subject":"Ciências Naturais / Físico-Química · Sala B3"},
  {"day":"Terça","end":"16:10","id":"ter6","start":"15:20","subject":"Matemática · Sala B3"},
  {"day":"Terça","end":"17:15","id":"ter7","start":"16:25","subject":"Educação Moral (Evangélica) · Sala B5"},
  {"day":"Quarta","end":"09:20","id":"qua1","start":"08:30","subject":"Educação Visual · Sala D1"},
  {"day":"Quarta","end":"11:20","id":"qua2","start":"10:30","subject":"Geografia · Sala B3"},
  {"day":"Quarta","end":"12:15","id":"qua3","start":"11:25","subject":"Inglês · Sala B3"},
  {"day":"Quarta","end":"13:15","id":"qua4","start":"12:25","subject":"Cidadania e Desenvolvimento / Cinema e Animação · Sala B3/D1"},
  {"day":"Quinta","end":"09:20","id":"qui1","start":"08:30","subject":"Inglês · Sala B5"},
  {"day":"Quinta","end":"10:15","id":"qui2","start":"09:25","subject":"Matemática · Sala B5"},
  {"day":"Quinta","end":"11:20","id":"qui3","start":"10:30","subject":"Educação Física · Pavilhão"},
  {"day":"Quinta","end":"14:15","id":"qui4","start":"13:25","subject":"Francês · Sala B3"},
  {"day":"Quinta","end":"15:10","id":"qui5","start":"14:20","subject":"Português · Sala B3"},
  {"day":"Quinta","end":"17:15","id":"qui6","start":"15:20","subject":"RAV MAT / RAV PORT · Sala B4/B3"},
  {"day":"Sexta","end":"10:15","id":"sex1","start":"08:30","subject":"Ciências Naturais / Físico-Química · Sala F1/E1"},
  {"day":"Sexta","end":"12:15","id":"sex2","start":"10:30","subject":"História · Sala B3"},
  {"day":"Sexta","end":"13:15","id":"sex3","start":"12:25","subject":"Geografia · Sala B3"}
]'::jsonb);

insert into birthdays (id, name, "birthDate", "partyDate", "rsvpBy", responded, notes, "createdAt") values
  (gen_random_uuid(), 'João', '1979-10-05', null, null, false, '', '2026-09-17T21:42:41.303Z'),
  (gen_random_uuid(), 'Graciela', '1983-10-04', null, null, false, '', '2026-09-17T21:42:07.141Z'),
  (gen_random_uuid(), 'Avó Vera', '2026-07-31', '2027-08-08', null, false, '', '2026-09-17T21:48:41.860Z');

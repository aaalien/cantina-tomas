# Hub do Tomás — versão Supabase

Site estático (1 ficheiro `index.html`) com dados partilhados via Supabase.
Sem login nenhum — qualquer pessoa com o link vê e edita. Ver `supabase-schema.sql`
para o porquê desta troca (é o que permite ao Tomás usar sem conta).

## Publicar (uma vez)

1. **Supabase**: cria um projeto grátis em supabase.com → SQL Editor → cola e corre
   `supabase-schema.sql` inteiro → Project Settings → API → copia "Project URL" e
   a "anon public" key
2. Cola esses dois valores em `index.html`, nas linhas `SUPABASE_URL` / `SUPABASE_ANON_KEY`
3. **GitHub**: sobe este conteúdo para um repositório
4. **Vercel**: vercel.com → Add New → Project → importa o repositório → Deploy
   (não precisa de nenhuma configuração extra, é HTML puro)

## Atualizar depois

Basta editar `index.html` (ex. a ementa em `WEEKS`) e fazer push — a Vercel republica
sozinha a cada push ao GitHub.

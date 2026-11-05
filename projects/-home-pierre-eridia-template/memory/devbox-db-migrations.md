---
name: devbox-db-migrations
description: "How to apply pending migrations on the shared devbox Supabase without drizzle-kit push, and why"
metadata:
  node_type: memory
  type: project
  originSessionId: 7f3a000a-d81d-50ce-b3fc-820e4ee4b963
  modified: 2026-10-22T20:02:13.564Z
---

On the shared devbox Supabase, apply pending `supabase/migrations/*.sql` files directly with psql (`POSTGRES_MIGRATIONS_URL`, `--single-transaction`), then record each one in `"_app_metadata"` as `key='sb_<timestamp>'`, `value='<file name>'` (the runner's tracking format).

**Why:** `pnpm migrate:run` (and `pnpm dev:migrate` / `RUN_MIGRATIONS=1`) runs `drizzle-kit push --force`. Per Hugo (2026-10-22, ticket ERI-57), that push no longer applies anything useful and forcing it disables RLS on Chat/Message. `pnpm next-dev` does NOT run migrations by default (`instrumentation.ts` skips them in dev unless `RUN_MIGRATIONS=1`).

**How to apply:** when the app 500s on a column missing from the DB, check `npx tsx scripts/migrate.js status` for pending Supabase migrations and apply only those files. Note that `~/supabase-local/refresh-from-dev.sh` replaces the whole devbox DB with a copy of dev.eridia.ai, which wipes local-only accounts and migrations.

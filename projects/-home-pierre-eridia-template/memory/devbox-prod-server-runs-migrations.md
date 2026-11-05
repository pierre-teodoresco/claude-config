---
name: devbox-prod-server-runs-migrations
description: "Never start a production build (node server.mjs / next start) against the shared devbox DB — startup runs drizzle-kit push, Supabase migrations and background workers"
metadata:
  node_type: memory
  type: project
  originSessionId: ecf80f89-1ba2-57a5-a5ec-3c880d19b676
  modified: 2026-10-24T18:26:44.932Z
---

Starting a production build on the devbox (`node server.mjs` or `next start`) with `~/eridia_template/.env.local` connects to the shared Supabase and, at boot, `instrumentation.ts` runs `checkAndRunMigrations()` (`drizzle-kit push --force` + pending `supabase/migrations/*.sql`) and starts the automation scheduler/worker, ChatRun sweeper, meeting worker. Migrations are skipped only when `NODE_ENV === 'development'`, and `.env.local` sets `NODE_ENV=production`.

**Why:** happened on 2026-10-24 (ERI-103 perf audit): a prod server started for Playwright measurements ran drizzle-kit push and applied 20261021120000 + 20261021130000 on the shared DB. No data loss (row counts and RLS unchanged), but it broke the "never drizzle-kit push" rule. See [[devbox-db-migrations]].

**How to apply:** to measure or run a prod build, point `POSTGRES_URL`/`POSTGRES_MIGRATIONS_URL` at a disposable clone (pg_dump into a throwaway Postgres), never at the shared DB. `pnpm next-dev` is safe (dev mode skips migrations and workers).

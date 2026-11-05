# Devbox Eridia (compte de Pierre)

## Dépôt
- Code : `~/eridia_template`, branche de base `dev`.
- Lis le `CLAUDE.md` et le `AGENTS.md` du dépôt avant de coder.

## Serveur de dev
- `pnpm next-dev` écoute sur le port 3001 (variable `PORT` de `.env.local`), visible sur https://pierre.devbox.eridia.ai.
- Le port 3000 est celui de Hugo : ne le prends pas, ne tue pas son process.

## Base de données
- Supabase local de la devbox, copie de dev.eridia.ai, **partagé avec Hugo**.
- Ne la vide pas, ne la réinitialise pas, ne lance jamais `drizzle-kit push` dessus.

## Outils
- sudo sans mot de passe et Docker sont disponibles.
- Pour les serveurs distants (dev, prod, instances clientes), voir `~/.claude/guidelines/servers-teleport.md`.

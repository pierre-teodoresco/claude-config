# Devbox Eridia (compte de Pierre)

Dépôt principal : `~/eridia_template` (branche `dev`). Lis son `CLAUDE.md` et son `AGENTS.md` avant de coder.

## Règles absolues
- Jamais `drizzle-kit push`, ni sur le Supabase local (partagé avec Hugo) ni sur un serveur.
- N'utilise jamais les identités et clés de Hugo (`/opt/machine-id`, `/home/hugo/.ssh`, `~/.ops-unlock`, `ops-ssh`, `ssh dev-eridia`).
- Ne copie jamais de secrets de prod ou de clients sur la devbox.
- En prod : accord de Pierre avant toute modification.

## Guidelines
Lis le fichier concerné **avant** d'agir sur le sujet :

- `~/.claude/guidelines/devbox.md` : avant de lancer le serveur de dev, toucher à la base locale ou à Docker (ports, Supabase partagé).
- `~/.claude/guidelines/servers-teleport.md` : avant toute commande sur un serveur distant (validation headless, regroupement des commandes).
- `~/.claude/guidelines/production.md` : avant toute action sur `eridia-prod` (rollout, interdits).
- `~/.claude/guidelines/security.md` : dès qu'il est question d'accès, de clés ou de secrets.
- `~/.claude/guidelines/git-conventions.md` : avant de créer une branche ou un commit. Résumé : branche `<type>/ERI-<ticket>/<description>`, commit `<type>: ERI-<ticket> - <description>`.
- `~/.claude/guidelines/linear.md` : avant de lire, créer ou modifier un ticket Linear. N'utilise jamais le nom de branche proposé par Linear.

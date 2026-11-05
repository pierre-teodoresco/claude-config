# Production (`eridia-prod`, app.eridia.ai)

- **Demande l'accord de Pierre avant toute modification**, même mineure. Lire est libre (dans la limite d'une validation headless par commande).
- Jamais `docker compose up -d` sur les deux réplicas Next.js à la fois : passe par `eridia-rollout`.
- Jamais `drizzle-kit push`.
- Avant de proposer une modification, montre ce qui est en place et ce que tu vas changer.
- Accès : voir `~/.claude/guidelines/servers-teleport.md`.

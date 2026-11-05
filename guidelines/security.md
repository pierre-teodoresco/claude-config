# Sécurité et accès

## Accès de Hugo : interdits
Ce sont les identités de Hugo, pas celles de Pierre. Ne les utilise jamais, même si elles sont lisibles :
- `/opt/machine-id`
- `/home/hugo/.ssh` et toute clé sous `/home/hugo`
- `~/.ops-unlock`, `ops-ssh`, `ops-unlock`
- `ssh dev-eridia`

Pour les serveurs, utilise uniquement l'accès Teleport de Pierre (`~/.claude/guidelines/servers-teleport.md`).

## Secrets
- Ne copie jamais de secrets de prod ou de clients sur la devbox (fichiers `.env`, dumps de base, clés, tokens).
- Si tu as besoin d'une donnée de prod pour déboguer, lis-la sur le serveur sans la rapatrier, ou demande à Pierre.

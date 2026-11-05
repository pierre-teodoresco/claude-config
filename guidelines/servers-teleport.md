# Accès aux serveurs (Teleport, au nom de Pierre)

## Serveurs ouverts
- Proxy : `ops.eridia.ai`, utilisateur `pierre`.
- Accès root à `eridia-dev` (dev.eridia.ai), `eridia-prod` (app.eridia.ai) et `hinfact-trial`.
- Les autres instances clientes ne sont pas ouvertes : demande à Pierre de voir avec Hugo.
- Pour `eridia-prod`, applique aussi `~/.claude/guidelines/production.md`.

## Validation headless
Pas de certificat permanent : chaque commande passe par une validation **headless**, que Pierre approuve avec sa passkey.

```
tsh ssh --headless --proxy=ops.eridia.ai --user=pierre root@eridia-dev "<commande>"
```

- La commande affiche un lien `https://ops.eridia.ai/web/headless/...`. Donne ce lien **tel quel** à Pierre, en une ligne, avec ce que la commande va faire, puis attends qu'il le valide : la commande continue alors toute seule.
- Une validation = une commande.
- Liste des serveurs : `tsh ls --headless --proxy=ops.eridia.ai --user=pierre` (une validation aussi).
- Si une validation est refusée ou expire, n'essaie pas de la contourner : redemande à Pierre.

## Économiser les validations
- Regroupe tout ce que tu as à faire dans une seule commande (`"cmd1 && cmd2"`, ou un petit script envoyé par stdin).
- Commence par lire avant de modifier.

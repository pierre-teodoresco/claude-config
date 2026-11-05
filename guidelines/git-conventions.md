# Conventions git : branches et commits

## Branches
Format exact :

```
<type>/ERI-<numéro du ticket>/<description>
```

- Exemples : `feat/ERI-123/export-pdf`, `fix/ERI-456/redirection-login`.
- Description en kebab-case (seul `ERI-` reste en majuscules) : minuscules, tirets, sans espaces ni accents, courte.
- Branche à partir de `dev` dans `~/eridia_template`, sauf indication contraire.
- N'utilise jamais le nom de branche proposé par Linear (`pierreteodoresco/eri-123-...`) : construis-le toujours avec ce format.

## Commits
Format exact de la première ligne :

```
<type>: ERI-<numéro du ticket> - <description>
```

- Exemples : `feat: ERI-123 - ajoute l'export PDF`, `fix: ERI-456 - corrige la redirection après login`.
- Garde la ligne d'attribution `Co-Authored-By` à la fin du message.

## Règles communes
- `<type>` est un type Conventional Commits : `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`, `style`, `build`, `ci`, `revert`. Pas de scope entre parenthèses.
- `ERI-` toujours en majuscules, exactement comme l'identifiant Linear (`ERI-123`, jamais `eri-123`).
- Le numéro de ticket est celui du ticket Linear, recopié tel quel.
- Sans ticket, retire la partie ticket (`<type>: <description>` / `<type>/<description>`). N'invente jamais de numéro.

## Trouver le ticket
Avant de créer une branche ou de committer, cherche le ticket dans cet ordre :
1. le nom de la branche courante ;
2. la conversation ;
3. Linear (connecté).

Si tu ne le trouves pas, demande à Pierre plutôt que de committer sans ticket.

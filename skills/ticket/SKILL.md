---
name: ticket
description: Réalise un ticket Linear ERI de bout en bout avec des agents. Raffine le ticket, planifie, développe en TDD dans un worktree, fait relire le code par un agent indépendant, corrige, ouvre une PR GitHub vers dev, la merge automatiquement si la CI est verte et que la review ne remonte rien de grave, suit le déploiement sur dev, passe le ticket en « À tester sur dev » et commente une procédure de test. Utilise-la quand Pierre tape /ticket ERI-123 ou demande de « réaliser », « faire » ou « traiter » un ticket.
---

# /ticket ERI-<n> : réaliser un ticket de bout en bout

Tu es l'**orchestrateur**. Tu ne codes pas toi-même. Tu enchaînes les phases, tu passes les relais entre agents, et tu décides aux portes. Avant de commencer, lis `~/.claude/guidelines/linear.md`, `git-conventions.md` et `devbox.md`.

Arguments : `ERI-<n>` (obligatoire) et `--valider-plan` (facultatif : s'arrêter après le plan pour que Pierre le valide).

**Autorisations données par Pierre pour ce workflow** : changer le statut du ticket, commenter le ticket, ouvrir la PR et la merger sur `dev` quand les conditions de la phase 6 sont remplies. Rien d'autre : pas d'assignation, pas de `main`, pas de prod, pas de réécriture d'une description écrite par quelqu'un d'autre.

## Phase 0 : contrôles préalables
1. `get_issue` (avec `includeRelations: true`) et `list_comments`.
2. **Arrête-toi et préviens Pierre** dans ces cas :
   - le ticket est assigné à Hugo, ou il est déjà en « In Progress » chez quelqu'un d'autre ;
   - le ticket est `blockedBy` un ticket ouvert, ou il est marqué `Duplicate`, `Canceled` ou `Done` ;
   - une branche `*/ERI-<n>/*` ou une PR ouverte existe déjà (`git ls-remote --heads origin '*ERI-<n>*'`, `gh pr list --search ERI-<n>`). Dans ce cas, propose de reprendre le travail existant.
3. Passe le ticket en **In Progress**.

## Phase 1 : raffinage et plan (agent `ticket-planner`)
Lance `ticket-planner` avec l'identifiant du ticket. Il lit tout, confronte le ticket au code, poste un commentaire « Raffinage et plan » sur le ticket, et te renvoie :
- `type` de branche, `slug` et chemin de branche ;
- critères d'acceptation vérifiables ;
- plan (fichiers, étapes, tests à écrire) ;
- `questions_bloquantes` ;
- `zones_sensibles` touchées (voir la phase 6).

Si `questions_bloquantes` n'est pas vide, pose les questions à Pierre (AskUserQuestion), puis renvoie ses réponses au planner avec SendMessage. Avec `--valider-plan`, montre le plan à Pierre et attends son accord.

## Phase 2 : worktree
Ne touche pas au checkout principal `~/eridia_template` : Pierre peut y travailler.
```bash
cd ~/eridia_template && git fetch origin dev
git worktree add -b <type>/ERI-<n>/<slug> .claude/worktrees/ERI-<n> origin/dev
cd .claude/worktrees/ERI-<n> && pnpm install --frozen-lockfile
ln -s ~/eridia_template/.env.local .env.local   # seulement si les tests en ont besoin ; jamais de copie
```

## Phase 3 : développement (agent `ticket-implementer`)
Lance `ticket-implementer` avec le chemin du worktree, les critères d'acceptation et le plan du planner (copie-les tels quels). Garde son identifiant : c'est **le même agent** qui fera les corrections. Il commite sur la branche et pousse. Il te renvoie le résumé, les commandes lancées et leur résultat.

## Phase 4 : review (agent `ticket-reviewer`, neuf)
Lance `ticket-reviewer` avec **le ticket et le diff seulement** (`git diff origin/dev...HEAD` dans le worktree), jamais le plan ni le résumé de l'implémenteur. Il renvoie des findings classés `bloquant`, `important` ou `mineur`, et une liste `inquiétudes` (doutes qu'il ne peut pas trancher : comportement produit, sécurité, données).

## Phase 5 : boucle de correction (3 tours au maximum)
S'il reste des findings `bloquant` ou `important` : SendMessage à l'implémenteur avec ces findings, puis relance un **nouveau** reviewer sur le nouveau diff. Les `mineur` sont corrigés s'ils sont triviaux, sinon listés dans la PR. Après 3 tours avec encore un bloquant ou un important : arrête-toi, ouvre la PR en draft et préviens Pierre.

## Phase 6 : PR et merge automatique
Ouvre la PR depuis le worktree :
```bash
gh pr create --base dev --head <branche> --title "<type>: ERI-<n> - <description>" --body-file <fichier>
```
Corps en français, sur le modèle de la PR #240 : `Corrige [ERI-<n>](<url>).`, puis `## Problème`, `## Cause`, `## Correctif`, `## Tests` (dire ce qui n'a pas été vérifié), `## Review` (tours, findings mineurs restants). Termine par la ligne d'attribution Claude Code.

Attends la CI : `gh pr checks <n> --watch --fail-fast` (lance-le en arrière-plan). Si la CI échoue, renvoie l'échec à l'implémenteur. Une correction de CI compte comme un tour de la phase 5.

**Merge automatique seulement si tout est vrai :**
- tous les checks sont verts ;
- la dernière review n'a ni `bloquant`, ni `important`, ni `inquiétudes` ;
- le diff ne touche aucune **zone sensible** : migrations ou schéma Drizzle (`lib/db/schema*`, `lib/db/migrations/`, `supabase/`), `.github/`, `config/defaults*`, authentification, permissions ou partage, `pnpm-lock.yaml` / dépendances, ou suppression de données.

Sinon, laisse la PR ouverte, résume à Pierre ce qui bloque et arrête-toi. Pierre merge lui-même.

Merge :
```bash
gh pr merge <n> --squash --delete-branch --subject "<type>: ERI-<n> - <description> (#<n>)"
```

## Phase 7 : statut Linear juste après le merge
Linear passe automatiquement le ticket en **Done** quand la PR liée est mergée. On veut **À tester sur dev**.
1. Juste après le merge, mets le ticket en « À tester sur dev ».
2. Relis le statut 30 s puis 2 min plus tard. S'il est repassé en Done (l'automatisation Linear arrive parfois après), remets « À tester sur dev ».

## Phase 8 : déploiement sur dev
Le push sur `dev` déclenche `build-and-push.yml`, qui construit les images puis lance le job `deploy-dev` (environ 7 à 10 min).
```bash
SHA=$(gh pr view <n> --json mergeCommit --jq .mergeCommit.oid)
gh run list --workflow build-and-push.yml --branch dev --commit $SHA --json databaseId --jq '.[0].databaseId'
gh run watch <id> --exit-status   # en arrière-plan
```
Si le run est annulé parce qu'un merge plus récent l'a remplacé (concurrency), suis le run le plus récent sur `dev` et vérifie que ton commit en fait partie (`git merge-base --is-ancestor $SHA <sha du run>`). Si le déploiement échoue, commente le ticket avec le lien du run et préviens Pierre. Ne relance rien sur le serveur.

## Phase 9 : commentaire de procédure de test
Une fois le déploiement réussi, poste un commentaire sur le ticket (`save_comment`) :

```markdown
## Déployé sur dev — procédure de test

PR #<n> (`<sha court>`), déployée sur https://dev.eridia.ai le <date>.

### Prérequis
- Compte, organisation ou données nécessaires (jamais de secret).

### Étapes
1. Aller sur …
2. Faire …
   → Attendu : …

### Critères d'acceptation
- [ ] un critère vérifiable par ligne, repris du ticket

### Non-régression
- [ ] ce qui touche le même code et pourrait casser

### Non vérifié automatiquement
- ce que les tests ne couvrent pas (UI réelle, desktop, mobile, intégration externe)
```
Reprends la section « À vérifier » du ticket quand elle existe, et complète-la avec ce que le diff change vraiment.

## Phase 10 : nettoyage et compte rendu
`git worktree remove .claude/worktrees/ERI-<n>` (seulement après le merge). Termine par un compte rendu court à Pierre : liens du ticket, de la PR et du run de déploiement, nombre de tours de review, ce qui reste à tester à la main.

## Règles absolues (rappel)
- Jamais `drizzle-kit push`. Une migration se génère avec `pnpm db:generate`, et une PR qui en contient n'est jamais mergée automatiquement.
- Jamais les identités ou clés de Hugo, jamais de secret de prod ou de client sur la devbox, dans un ticket ou dans une PR.
- Rien sur `main` ni sur la prod.

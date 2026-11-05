# Linear : lire et écrire un ticket

Workspace `eridia`, équipe **Eridia** (clé `ERI`) pour le produit et la technique. L'équipe **Business** (`BUS`) n'est pas concernée par le code.

## Nom de branche : jamais celui de Linear
Linear propose un nom de branche (`gitBranchName`, bouton « Copy git branch name », du type `pierreteodoresco/eri-94-la-page-reunion-crash...`). **Ne l'utilise jamais**, ni pour créer une branche ni comme modèle. Le nom de branche suit toujours `~/.claude/guidelines/git-conventions.md` : `<type>/ERI-<ticket>/<description>`.

## Lire un ticket
1. **Récupère le ticket complet** avec `get_issue` (`includeRelations: true`). `list_issues` tronque les descriptions : ne travaille jamais à partir de cet extrait.
2. **Lis les commentaires** (`list_comments`) : les décisions et les changements de périmètre y sont souvent, et ils priment sur la description quand ils sont plus récents.
3. **Regarde les pièces jointes et les images** (captures, logs) avec `extract_images` / `get_attachment` quand il y en a.
4. **Suis les liens** : ticket parent, sous-tickets, tickets liés (`relatedTo`, `blocks`, `blockedBy`, `duplicateOf`). Un ticket bloqué ou doublon change la façon de s'y prendre.
5. **Repère la définition de « fini »** : les cases à cocher de « Attendu » ou « À vérifier » sont les critères d'acceptation. La section « Tests » dit quels tests écrire.
6. **Confronte le ticket au code** : la cause, les fichiers et les lignes cités peuvent être périmés. Vérifie-les dans `~/eridia_template` avant de t'appuyer dessus, et signale ce qui a changé.
7. **Note le statut et l'assigné** : si le ticket est déjà en cours chez Hugo, préviens Pierre avant de commencer.
8. S'il manque une information pour agir (section « À préciser », reproduction absente, attendu ambigu), **demande à Pierre** plutôt que de deviner.

## Écrire un ticket
Écris en français, avec le style des tickets existants (ERI-80, ERI-93 sont de bons modèles).

### Titre
`<Zone> : <ce qui ne va pas ou ce qu'on veut>`
- La zone est une partie du produit ou un thème : `Fichiers`, `Onboarding`, `Mode Code`, `Cowork / Code`, `Sécurité`, `CI`, `Devbox`, `Exploration`…
- Une phrase concrète, compréhensible sans ouvrir le ticket. Exemples :
  - `Fichiers : glisser-déposer des fichiers depuis l'ordinateur directement sur la page (et dans un dossier)`
  - `Sécurité : un membre non admin peut partager des documents avec toute l'organisation via l'API`

### Description
Sections en `##`, dans cet ordre, en ne gardant que celles qui servent :

- **Symptôme** (bug) ou **Problème** (amélioration, fonctionnalité) : ce qu'on observe, où (page, route, environnement : dev, app.eridia.ai, instance client), quand et comment on l'a constaté. Pour un bug, les étapes pour reproduire.
- **Cause** : ce qu'on a trouvé dans le code, avec les fichiers et fonctions en `code` (`app/(chat)/files/page.tsx`, `handleDrop`). Distingue ce qui est vérifié de ce qui est supposé.
- **Correctif** : si un correctif existe déjà, ce qu'il change et le commit (`3fa2b79c` sur dev).
- **Attendu** : le résultat voulu, en cases à cocher (`- [ ]`), une par critère vérifiable. Marque `Bonus :` ce qui est optionnel.
- **Tests** : les tests à écrire (unitaires, composant, régression).
- **À vérifier** : les vérifications manuelles après déploiement (sur dev, puis en prod), en cases à cocher, avec la commande exacte quand il y en a une (`curl ...`).
- **À préciser** : ce qu'on ne sait pas encore. Mieux vaut une question explicite qu'un trou silencieux.

Règles de rédaction :
- Phrases courtes et factuelles, avec des dates (`le 21/10`) et des chiffres mesurés plutôt que des impressions.
- Mets en **gras** l'élément clé (le nom de la page, ce qui est exposé), pas des phrases entières.
- Cite les autres tickets par leur identifiant (`ERI-79`) et ajoute la relation dans Linear (`relatedTo`, `blocks`).
- Jamais de secret, de token, de mot de passe ni de donnée client personnelle dans un ticket. Pour un nom d'utilisateur ou d'organisation client, garde seulement ce qui est utile pour reproduire.
- Un ticket = un sujet. Si tu trouves plusieurs problèmes indépendants, fais plusieurs tickets ou des sous-tickets.

### Champs
- **Équipe** : `Eridia`.
- **Label** : `Bug` (quelque chose qui ne marche pas), `Feature` (nouvelle fonctionnalité), `Improvement` (amélioration de l'existant) ou `Chore` (maintenance invisible côté produit : dépôt, CI, devbox, dépendances, outillage, dette technique). Un seul label de type par ticket.
- **Priorité** : `Urgent` seulement pour une faille de sécurité ou une panne en prod ; sinon `High`, `Medium` ou `Low`. Laisse `No priority` si tu ne sais pas et dis-le à Pierre.
- **Projet** : seulement si le ticket entre clairement dans un projet existant (ex. `Eridia App`).
- **Assigné** : ne l'assigne à personne sans que Pierre le demande.
- **Statut** : `Backlog` par défaut. Le cycle est `Backlog` → `Todo` → `In Progress` → `À tester sur dev` → `Prêt à merge` → `Done` (ou `Canceled`, `Duplicate`). Ne change le statut d'un ticket existant que si Pierre le demande.

### Avant de créer ou de modifier
- Cherche d'abord un ticket existant sur le même sujet (`list_issues` avec `query`). S'il existe, propose de le compléter plutôt que d'en créer un doublon.
- Montre le brouillon (titre, description, champs) à Pierre avant de le créer, sauf s'il a demandé de le créer directement.
- Ne réécris pas la description d'un ticket écrit par quelqu'un d'autre : ajoute un commentaire.

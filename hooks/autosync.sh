#!/usr/bin/env bash
# Hook SessionEnd : commit + push de ~/.claude si `git status` montre une diff.
# Le travail est détaché pour ne pas bloquer la fermeture de la session.
set -u
REPO="$HOME/.claude"
LOG="$REPO/hooks/autosync.log"

cat >/dev/null  # consomme le JSON du hook sur stdin

(
  exec 9>"$REPO/.git/autosync.lock"
  flock -w 60 9 || exit 0
  cd "$REPO" || exit 0
  [ -n "$(git status --porcelain)" ] || exit 0
  git add -A
  git commit -q -m "chore: auto-sync $(date '+%Y-%m-%d %H:%M:%S') ($(hostname -s))" || exit 0
  timeout 60 git push -q origin HEAD 2>&1 || echo "$(date -Is) push échoué" 
) >>"$LOG" 2>&1 </dev/null &
disown
exit 0

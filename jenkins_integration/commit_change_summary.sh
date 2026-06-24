#!/usr/bin/env bash
# Prints Slack-oriented commit summary: parent repo (matter_extension) + third_party/matter_sdk.
# PREV_BASELINE: previous Jenkins Git commit (GIT_PREVIOUS_SUCCESSFUL_COMMIT or GIT_PREVIOUS_COMMIT).

set +e
MAX=10
PREV="${PREV_BASELINE:-}"
HEADS=$(git rev-parse --short HEAD 2>/dev/null || echo "?")
PREV_FULL=

if [ -z "$PREV" ] || ! PREV_FULL=$(git rev-parse -q --verify "${PREV}^{commit}" 2>/dev/null); then # baseline SHA not in repo (e.g. force-push, shallow clone)
  MAIN=$(git log -n "$MAX" --oneline HEAD 2>/dev/null)
  printf "*matter_extension:* no previous Jenkins baseline; last %s commits:\n%s\n\n" "$MAX" "$MAIN"
else # valid baseline commit
  PREVS=$(git rev-parse --short "$PREV_FULL" 2>/dev/null || echo "$PREV" | cut -c1-7)
  MAIN=$(git log --oneline "${PREV_FULL}..HEAD" 2>/dev/null | head -n "$MAX")
  if [ -z "$MAIN" ]; then # nothing in PREV..HEAD
    printf "*matter_extension:* no new commits (%s..%s)\n\n" "$PREVS" "$HEADS"
  else # one or more commits since baseline
    printf "*matter_extension (%s..%s):*\n%s\n\n" "$PREVS" "$HEADS" "$MAIN"
  fi
fi

git submodule update --init --quiet third_party/matter_sdk 2>/dev/null || true
CURR_SM=$(git rev-parse HEAD:third_party/matter_sdk 2>/dev/null)
PREV_SM=
if [ -n "$PREV_FULL" ]; then # baseline resolved; read gitlink at that commit
  PREV_SM=$(git rev-parse "${PREV_FULL}:third_party/matter_sdk" 2>/dev/null)
fi

if [ -n "$PREV_SM" ] && [ -n "$CURR_SM" ] && [ "$PREV_SM" != "$CURR_SM" ]; then # submodule pointer moved
  git -C third_party/matter_sdk fetch --quiet origin "$PREV_SM" "$CURR_SM" 2>/dev/null || true
  PS=$(echo "$PREV_SM" | cut -c1-7)
  CS=$(echo "$CURR_SM" | cut -c1-7)
  printf "*matter_sdk (%s..%s)*\n" "$PS" "$CS"
elif [ -z "$PREV_FULL" ] && [ -n "$CURR_SM" ]; then # no resolved baseline; only show current pointer
  CS=$(echo "$CURR_SM" | cut -c1-7)
  printf "*matter_sdk:* no previous Jenkins baseline; pointer %s\n" "$CS"
elif [ -n "$PREV_SM" ] && [ -n "$CURR_SM" ] && [ "$PREV_SM" = "$CURR_SM" ]; then # same submodule SHA as baseline
  CS=$(echo "$CURR_SM" | cut -c1-7)
  printf "*matter_sdk:* unchanged at %s\n" "$CS"
else # no gitlink on HEAD or submodule missing
  printf "*matter_sdk:* (submodule not found)\n"
fi
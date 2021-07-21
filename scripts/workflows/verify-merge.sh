#! /bin/bash
# Verify that a branch can be merged

# check branch type prefix != "poc"

if [[ "$BRANCH" =~ "poc/" ]]; then
  echo "Not allowed to merge POC branch"
  exit 1 
fi;

# need to do fetch/checkout because action just checks out sparse version of repo
git fetch
git checkout "$BRANCH"

# get message and verify doesn't start with "wip"

MSG=$(git log "$BRANCH" -1 --pretty=format:"%s")
if [[ "$MSG" = wip* ]]; then
  echo "Not allowed to merge when last commit message starts with 'wip'"
  exit 1
fi

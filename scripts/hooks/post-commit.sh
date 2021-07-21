#! /bin/bash
# Checks that the git diff is not getting to big and warns if it is


# TODO: better way to determine the branch/commit we want to check against?
# for now look back until DIFF_BRANCH and find other merge commits -- those with (#..) in the commit message
#   if none found, use DIFF_BRANCH
# NOTE: This requires enforcing merge messages

DIFF_BRANCH=develop

# find last commit with "(#<number>)" in commit message
LAST_MERGE=$(git log $DIFF_BRANCH..HEAD --pretty=oneline | sed -n "/\(#[0-9]*\)/p" | head -1 | sed "s/ .*//")

# if not exists since $DIFF_BRANCH then just use $DIFF_BRANCH
if [ -z "$LAST_MERGE" ]; then
  DIFF_COMMIT=develop
else
  DIFF_COMMIT=$LAST_MERGE
fi


FILE_LIMIT=25
LINE_LIMIT=400

FILE_LIMIT_WARNING=" ! warning: more than $FILE_LIMIT files changed since $DIFF_COMMIT "
LINE_LIMIT_WARNING=" ! warning: more than $LINE_LIMIT lines changed since $DIFF_COMMIT "

NEW_BRANCH_CMDS="Remove warning: Create new branch with 'git checkout -b <branch_name>' then push to remote with 'git push --set-upstream <remote_name> <branch_name>'"

main() {

  DIFF_FILES=$(git diff HEAD.."$DIFF_COMMIT" --stat | tail -n1 | tr ' ' '\n' | sed -n "/[[:digit:]]/p" | head -1)
  DIFF_LINES=$(git diff HEAD.."$DIFF_COMMIT" --stat | tail -n1 | tr ' ' '\n' | sed -n "/[[:digit:]]/p" | tail -1)

  WARN=false
  if [ "$DIFF_FILES" -gt $FILE_LIMIT ]; then
    echo "$(tput setaf 3)$FILE_LIMIT_WARNING$(tput sgr 0)" 
    WARN=true
  fi

  if [ "$DIFF_LINES" -gt $LINE_LIMIT ]; then
    echo "$(tput setaf 3)$LINE_LIMIT_WARNING$(tput sgr 0)"
    WARN=true
  fi

  echo "Unmerged Files: $DIFF_FILES    Lines: $DIFF_LINES
"  

  if [ $WARN = true ]; then
    echo "$NEW_BRANCH_CMDS"
    echo ""
  fi

}

main

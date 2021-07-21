#! /bin/bash
# Pre-commit githook to run before every commit to validate it locally
#   1. Check that branch name matches conventions (branch-name.sh)

# set directory for calling other scripts
DIR=$(dirname "${BASH_SOURCE[0]}")

# if in hook, then prep PATH to find in repo `scripts/hooks/` dir 
# shellcheck disable=SC2076
if [[ $DIR =~ ".git" ]]; then
  DIR+="/../../scripts/hooks"
fi


BRANCH_NAME_ERROR=" !  Branch name does not match conventions  "
BRANCH_PROTECTION_ERROR=" ! No commits on this branch   "

main() {

  # Call branch protection script
  if ! $DIR/internal/branch-protections.sh; then
    echo "$(tput setaf 1)$(tput setab 7)$BRANCH_PROTECTION_ERROR$(tput sgr 0)"
    return 1
  fi

  # Call branch name script
  
  if ! $DIR/internal/branch-name.sh; then
    echo "$(tput setaf 1)$(tput setab 7)$BRANCH_NAME_ERROR$(tput sgr 0)"
    echo "  <prefix>/<description>"
    echo "prefix options: ($($DIR/internal/prefix-list.sh))"
    return 1
  fi

}

main
  

#! /bin/bash
# Script to check github branch protections and prevent commits to protected branches

BLOCKED_BRANCH=( main develop )
BLOCKED_PREFIX=( release )

BRANCH=$(git rev-parse --abbrev-ref HEAD)

github() {

  REMOTE=$(git status -sb | sed -n "/##/p" | sed "s/.*\.\.\.//" | sed "s/\/.*//")

  if [[ ! $REMOTE =~ "##" ]]; then
    URL=$(git config --get remote."$REMOTE".url)
    
    # shellcheck disable=SC2076
    if [[  $URL =~ "github.com" ]]; then
      # shellcheck disable=SC2034,SC2207
      SPLIT=( $(echo "$URL" | sed "s/.*://" | sed  "s/\.git$//" | sed "s/\// /" ) )
      #OWNER=${SPLIT[0]}
      #REPO=${SPLIT[1]}

      #echo $OWNER
      #echo $REPO
    else
      #echo "not a github remote"
      return
    fi
  else
    #echo "no upstream branch"
    return
  fi

  # TODO: Set github token somewhere so we can get protections and check if we're allowed to push to github
  #AUTH="token "
  # curl -H "Accept: application/vnd.github.v3+json" -H "Authorization: $AUTH" "https://api.github.com/repos/$OWNER/$REPO/branches/$BRANCH/protection"

}

main() {

  # check github branch protections
  github
  
  # compare against branch name/prefixes defined in here
  if [[ "${BLOCKED_BRANCH[*]}" =~ $BRANCH ]]; then
    return 1;
  fi 
  for PREFIX in "${BLOCKED_PREFIX[@]}"; do
    if [[ $BRANCH == $PREFIX* ]]; then
      return 1;
    fi
  done
   
}

main



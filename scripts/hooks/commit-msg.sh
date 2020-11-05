#! /bin/bash
# Script to verify that commit message matches conventions

# set directory for calling other scripts
DIR=`dirname "$0"`
# if in hook, then prep PATH to find in repo `scripts/hooks/` dir 
if [[ $DIR =~ ".git" ]]; then
  DIR+="/../../scripts/hooks"
fi


MSG_PREFIXES=( 'wip' )
OTHER_PREFIXES=`$DIR/prefix-list.sh`


COMMIT_MSG_ERROR=" ! Invalid commit message  "

main() {

  COMMIT_MSG=`cat $1 | sed -n "/^[^#]/p"`
  FIRST_LINE=`echo $COMMIT_MSG | sed -n "/[^\w]*$/p" | sed "s/^ *//" | sed "s/\n//" | head`

  # create regexp for first line of commit message:      <prefix>(optional !):<description>
  regexp="^($(echo "${MSG_PREFIXES[@]} ${OTHER_PREFIXES[@]}" | sed "s/ /|/g"))(\([a-zA-Z0-9 ]*\))?\!?\:[A-Za-z0-9\._\-\s]*"

  # check that first line of message matches regexp
  if [[ ! $FIRST_LINE =~ $regexp ]]; then
    echo "$(tput setaf 1)$(tput setab 7)$COMMIT_MSG_ERROR$(tput sgr 0)"
    echo "  <prefix>:<description>"
    echo "prefix options: ($OTHER_PREFIXES $MSG_PREFIXES)"
    exit -1
  fi

}

main $1








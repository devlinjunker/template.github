#! /bin/bash


if git branch -a | grep "$RELEASE_BRANCH"; then
  echo "::error::Release Branch Already Exists";
  exit 1        
fi;
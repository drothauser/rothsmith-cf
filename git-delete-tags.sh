#!/bin/bash

if git ls-remote -t | awk '{print $2}' | cut -d '/' -f 3 | cut -d '^' -f 1  | sort -b -t . -k 1,1nr -k 2,2nr -k 3,3r -k 4,4r -k 5,5r | uniq | xargs git push --delete origin 
then 
  echo "deleted remote tags"
fi

if git tag -l | awk '{print $1}' | xargs git tag --delete 
then
  echo "deleted local tags"
fi

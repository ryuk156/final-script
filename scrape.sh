#!/bin/bash

INDEXDIR="../../meta-data/"
FILE="./module.txt"

if [ -f "$FILE" ]; then
  echo "$FILE exists."
  moduleName=$(cat "$FILE" | grep -Po '"id" *\K: *\K"[^"]*"' | sed 's/"//g' | head -n1)
  echo $moduleName
  mkdir "$INDEXDIR""$moduleName"
  echo "scraping data from $moduleName"

  touch "$INDEXDIR""$moduleName"/module.txt
  moduleDes="$INDEXDIR""$moduleName"/module.txt
  cat $FILE >"$moduleDes"
  echo "searching for readme file"

  READMEMD="README.MD"
  READMEmd="README.md"
  READMEmarkdown="README.markdown"
  readmeFound=0
  
  for F in *; do
    if [ "$F" == "$READMEMD" ] || [ "$F" == "$READMEmd" ] || [ "$F" == "$READMEmarkdown" ]; then
      echo "Readme Found"
      touch "$INDEXDIR""$moduleName"/README.md
      readmedst="$INDEXDIR""$moduleName"/README.md
      echo "$readmedst"
      cat $F >"$readmedst"
      readmeFound=readmeFound+1
    fi
  done

  if [ $readmeFound == 0 ]; then
    echo "Readme Not Found"
  fi

  defaultLogo="../../logo.png"
  logoSrcP="./logo.png"
  logoSrcJ="./logo.jpg"
  coverSrcP="./cover.png"
  coverSrcJ="./cover.jpg"

  if [ -f "$logoSrcP" ]; then
    logodst="$INDEXDIR""$moduleName"
    cp $logoSrcP $logodst
    echo "Logo Image copy done"
  elif [ -f "$logoSrcJ" ]; then
    logodst="$INDEXDIR""$moduleName"
    cp $logoSrcJ $logodst
    echo "Logo Image copy done"
  elif [ -f "$coverSrcP" ]; then
    coverdst="$INDEXDIR""$moduleName"
    cp $coverSrcP $coverdst
    echo "Cover Image copy done"
  elif [ -f "$coverSrcJ" ]; then
    coverdst="$INDEXDIR""$moduleName"
    cp $coverSrcJ $coverdst
    echo "Cover Image copy done"
  else
    coverdst="$INDEXDIR""$moduleName"
    cp $defaultLogo $coverdst
    echo "LOGO or COVER image not found, Resolved With default LOGO"
  fi

else
  echo "The repository is not module"
fi

#!/bin/bash

DIR="./meta-data"
DST="./modules"

mkdir "$DST"

for i in $(ls -d ./meta-data/*); do

  moduleFile="$i"/module.txt
  if [ -f "$moduleFile" ]; then

    moduleName=$(cat "$moduleFile" | grep -Po '"id" *\K: *\K"[^"]*"' | sed 's/"//g' | head -n1)
    moduleDisplayname=$(cat "$moduleFile" | grep -Po '"displayName" *\K: *\K"[^"]*"' | sed 's/"//g')
    moduleDescription=$(cat "$moduleFile" | grep -Po '"description" *\K: *\K"[^"]*"' | sed 's/"//g')
    moduleAuthor=$(cat "$moduleFile" | grep -Po '"author" *\K: *\K"[^"]*"' | sed 's/"//g')

    serverside=$(cat "$moduleFile" | grep -Po '"isServerSideOnly" *\K: *\K[^"]*' | sed 's/,//g')
    gameplay=$(cat "$moduleFile" | grep -Po '"isGameplay" *\K: *\K[^"]*' | sed 's/,//g')
    world=$(cat "$moduleFile" | grep -Po '"isWorld" *\K: *\K[^"]*' | sed 's/,//g')
    augment=$(cat "$moduleFile" | grep -Po '"isAugmentation" *\K: *\K[^"]*' | sed 's/,//g')
    library=$(cat "$moduleFile" | grep -Po '"isLibrary" *\K: *\K[^"]*' | sed 's/,//g')
    asset=$(cat "$moduleFile" | grep -Po '"isAsset" *\K: *\K[^"]*' | sed 's/,//g')
    specific=$(cat "$moduleFile" | grep -Po '"isSpecific" *\K: *\K[^"]*' | sed 's/,//g')

    moduleLogoP="$i"/logo.png
    moduleLogoJ="$i"/logo.jpg
    modulecoverP="$i"/cover.png
    modulecoverj="$i"/cover.jpg
    modulereadme="$i"/README.md

    mkdir "$DST"/"$moduleName"
    touch "$DST"/"$moduleName"/index.md
    echo "---" >"$DST"/"$moduleName"/index.md
    echo "posttype:  \"module\"  " >>"$DST"/"$moduleName"/index.md
    echo "title: \"$moduleDisplayname\"" >>"$DST"/"$moduleName"/index.md
    echo "description: \"$moduleDescription\"" >>"$DST"/"$moduleName"/index.md

    if [ -f "$moduleLogoP" ]; then
      cp $moduleLogoP "$DST"/"$moduleName"
      echo "cover: \"./logo.png\"" >>"$DST"/"$moduleName"/index.md
    elif [ -f "$moduleLogoJ" ]; then
      cp $moduleLogoJ "$DST"/"$moduleName"
      echo "cover: \"./logo.png\"" >>"$DST"/"$moduleName"/index.md
    elif [ -f "$modulecoverP" ]; then
      cp $modulecoverP "$DST"/"$moduleName"
      echo "cover: \"./cover.png\"" >>"$DST"/"$moduleName"/index.md
    elif [ -f "$modulecoverJ" ]; then
      cp $modulecoverJ "$DST"/"$moduleName"
      echo "cover: \"./cover.png\"" >>"$DST"/"$moduleName"/index.md
    else
      echo "No logo or cover image"
    fi

    moduleCat=()

    if [ $server ]; then
      moduleCat+=('Server')
    fi
    if [ $gameplay ]; then
      moduleCat+=('Gameplay Template')
    fi
    if [ $world ]; then
      moduleCat+=('World')
    fi
    if [ $augment ]; then
      moduleCat+=('Augment')
    fi
    if [ $library ]; then
      moduleCat+=('Library')
    fi
    if [ $asset ]; then
      moduleCat+=('Asset')
    fi
    if [ $specific ]; then
      moduleCat+=('Specific')
    fi

    if [ ${#moduleCat[*]} >0]; then
      echo "tags: \"${moduleCat[0]}\"" >>"$DST"/"$moduleName"/index.md
    fi

    echo "---" >>"$DST"/"$moduleName"/index.md

    if [ -f "$modulereadme" ]; then
      cat $modulereadme >>"$DST"/"$moduleName"/index.md
    else
      echo "No info available about this module" >>"$DST"/"$moduleName"/index.md
    fi

  fi

done

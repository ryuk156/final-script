#!/bin/bash

touch allmodules.txt

for i in {1..3}; do
        getRepos=$(curl -s "https://api.github.com/orgs/terasology/repos?q=&per_page=100&sort=name&page=$i")
        parseData=$(echo "$getRepos" | grep -oP '(?<="full_name": "Terasology/)[^"]*')
        echo "$parseData" >>allmodules.txt
done

readarray allrepos <allmodules.txt

mkdir clonedrepos
mkdir meta-data
cd clonedrepos

for value in "${allrepos[@]}"; do
        git clone "https://github.com/Terasology/${value//$'\n'/}"
        cd "${value//$'\n'/}"
        ../../scrape.sh
        cd ..
done

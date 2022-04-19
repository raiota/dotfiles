#!/usr/bin/env bash
set -eu

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    # ==> deploying
    ln -s $f "~/${f}"
    # ==> test deploying scripts
    #ln -s $f "./etc/test/${f}"
done    

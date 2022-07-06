#!/usr/bin/env bash
set -eu

usage_exit() {
    echo "Usage: $0 [-p dir] [-t] [-h]"
    exit 1
}

PLACE=$HOME

while getopts :p:th OPT
do
    case $OPT in
        p)  PLACE=$OPTARG;;
        t)  PLACE="./etc/test";;
        h)  usage_exit;;
        \?) usage_exit;;
    esac
done

echo "Start deploying dotfiles on ${PLACE} ? [y/N]"
read input

if [ $input != 'yes' ] && [ $input != 'YES' ] && [ $input != 'y' ]
then
    echo "Terminated."
    exit 1
fi
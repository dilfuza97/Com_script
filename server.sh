#!/bin/bash
servers='servers.txt'
developers='developers.txt'

if [[ -f "$servers" ]] && [[ -f "$developers" ]]
then
  while IFS= read -r server
  do
    echo "Working in server - " $server
    scp developers.txt centos@$server:/tmp
    ssh centos@$server "bash -s" < ./developers.sh
  done < "$servers"
else
  echo "The files don't exist1"
fi

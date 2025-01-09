#!/bin/bash
task_file="./read.txt"
arg1="$1"
arg2="$2"

if [[ "$arg1" == "ls" && -z "$arg2" ]]; then 
  while read -r line; do
    task="$line"
    echo "$line"
  done < "$task_file"

elif [[ "$arg1" == "add" && -n "$arg2" ]]; then
  echo "$arg2" >> "$task_file"
  echo "Added: $arg2"

else
  echo "Command not recognized. Type 'todo --help' to view all commands."
fi 


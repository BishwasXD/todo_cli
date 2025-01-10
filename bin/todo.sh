#!/bin/bash
task_file="./todo.txt"
arg1="$1"
arg2="$2"
arg3="$3"
if [[ "$arg1" == "ls" && -z "$arg2" ]]; then 
  while read -r line; do
    task="$line"
    echo "$line"
  done < "$task_file"

elif [[ "$arg1" == "add" && -n "$arg2" ]]; then
  echo "$arg2" >> "$task_file"
  echo "Added: $arg2"

elif [[ "$arg1" == "--help" && -z "$arg2" ]];then
  echo "todo ls: lists all task"
  echo "todo add task_name: add new task" 

elif [[ "$arg1" == "rm" && -n "$arg2" ]]; then
  task_name="$arg2"
  shift 2
  for arg in "$@"; do
    task_name+=" $arg"
  done
  grep -q "$task_name" "$task_file"
  if [ $? -eq 0 ]; then
      sed -i "/$task_name/d" ./todo.txt
      echo "task removed successfully"
  else
    echo "Not found"
  fi
else
  echo "Command not recognized. Type 'todo --help' to view all commands."
fi 


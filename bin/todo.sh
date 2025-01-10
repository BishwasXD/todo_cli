#!/bin/bash

task_file="$HOME/.todo.txt"

if [ ! -f "$task_file" ]; then
    touch "$task_file"
fi
arg1="$1"
arg2="$2"
arg3="$3"
if [[ "$arg1" == "ls" && -z "$arg2" ]]; then 
  while read -r line; do
    task="$line"
    echo "$line"
  done < "$task_file"

elif [[ "$arg1" == "add" && -n "$arg2" ]]; then
  task_name="$arg2"
  shift 2
  for arg in "$@"; do
    task_name+=" $arg"
  done
  echo "$task_name" >> "$task_file"
  echo "Added: $task_name"

elif [[ "$arg1" == "--help" && -z "$arg2" ]];then
  echo "todo ls: lists all task"
  echo "todo add task_name: add new task" 
  echo "todo rm task_name: remove task"
  echo "todo -m task_name: mark task done" 

elif [[ "$arg1" == "rm" && -n "$arg2" ]]; then
  task_name="$arg2"
  shift 2
  for arg in "$@"; do
    task_name+=" $arg"
  done
  grep -q "$task_name" "$task_file"
  if [ $? -eq 0 ]; then
      sed -i "/$task_name/d" "$task_file"
      echo "task removed successfully"
  else
    echo "Not found"
  fi
elif [[ "$arg1" == "-m" && -n "$arg2" ]]; then
  strike=$'\u0336'
  task_name="$arg2"
  result=""
  shift 2
  for arg in "$@"; do
    task_name+=" $arg"
  done
  grep -q "$task_name" "$task_file"
  if [ $? -eq 0 ]; then
    for(( i=0; i<${#task_name}; i++ )); do
      result+="${task_name:$i:1}$strike"
    done
    sed -i "/$task_name/d" "$task_file"
    echo "$result" >> "$task_file"
  else
    echo "task not found: 'todo ls' to list all tasks"
  fi
else
  echo "Command not recognized. Type 'todo --help' to view all commands."
fi 


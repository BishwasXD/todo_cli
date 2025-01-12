#!/bin/bash
task_file="$HOME/.todo.txt"

if [ ! -f "$task_file" ]; then
    touch "$task_file"
fi

arg1="$1"
arg2="$2"
arg3="$3"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
DEFAULT_COLOR="$GREEN"

if [[ "$arg1" == "ls" && -z "$arg2" ]]; then 
  while read -r line; do
    task="$line"
    echo "$line"
  done < "$task_file"

elif [[ "$arg1" == "add" && -n "$arg2" ]]; then
  if [[ "$arg2" == "-h" || "$arg2" == "-l" || "$arg2" == "-m" ]]; then
      task_name="$arg3"
      shift 3
      for arg in "$@"; do
        task_name+="$arg"
      done
      if [ "$arg2" == "-h" ]; then
        echo -e "${RED}$task_name" >> "$task_file"
      elif [ "$arg2" == "-l" ]; then
        echo -e "${GREEN}$task_name" >> "$task_file"
      elif [ "$arg2" == "-m" ]; then
        echo -e "${YELLOW}$task_name" >> "$task_file"
      fi
  else
    task_name="$arg2"
    shift 2
    for arg in "$@"; do
      task_name+=" $arg"
    done
    echo -e "${DEFAULT_COLOR}$task_name" >> "$task_file"
  fi
  echo "new task added: $task_name"

elif [[ "$arg1" == "--help" && -z "$arg2" ]];then
  echo "todo ls: lists all task"
  echo "todo add task_name: add new task" 
  echo "todo rm task_name: remove task"
  echo "todo -m task_name: mark task done" 

elif [[ "$arg1" == "rm" && -n "$arg2" && "$arg2" != "-m" ]]; then
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
    echo "task not found: 'todo ls' to list all tasks"
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
    echo "$task_name: task marked done"
  else
    echo "task not found: 'todo ls' to list all tasks"
  fi
elif [[ "$arg1" == "rm" && "$arg2" == "-m" && -n "$arg3" ]]; then
  task_name="$arg3"
  shift 3
  for arg in "$@"; do
    task_name+=" $arg"
  done
  strike=$'\u0336'
  marked_task=""
  for (( i=0; i<${#task_name}; i++ )); do
    marked_task+="${task_name:$i:1}$strike"
  done
  if grep -q "$marked_task" "$task_file"; then
    sed -i "/$marked_task/d" "$task_file"
    echo "task removed successfully"
  else
    echo "task not found: 'todo ls' to list all tasks"
  fi 
else
  echo "Command not recognized. Type 'todo --help' to view all commands."
fi


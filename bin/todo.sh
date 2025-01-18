#!/bin/bash
task_file="$HOME/.todo.txt"

if [ ! -f "$task_file" ]; then
    touch "$task_file"
fi

arg1="$1"
arg2="$2"
arg3="$3"
RED='\e[1;91m'
GREEN='\e[1;92m'
YELLOW='\e[1;93m'
RESET='\e[0m'
strike=$'\u0336'
if [[ "$arg1" == "ls" && -z "$arg2" ]]; then 
  tasks=""
  while read -r line; do
    task=$(echo "$line" | awk -F ";;;" '{print $1}')
    priority=$(echo "$line" | awk -F ";;;" '{print $2}')
    if [[ "$priority" == "h" ]]; then
      tasks+="${RED}${task}${RESET}    "
    elif [[ "$priority" == "m" ]]; then
      tasks+="${YELLOW}${task}${RESET}    "
    elif [[ "$priority" == "l" ]]; then
      tasks+="${GREEN}${task}${RESET}    "
    elif [[ "$priority" == "s" ]]; then
      striked=""
      for (( i=0; i<${#task}; i++ )); do
        striked+="${task:$i:1}${strike}"
      done
      tasks+="${striked}"
    else
      tasks+="$task"
    fi
  done < "$task_file"
  echo -e "$tasks"

elif [[ "$arg1" == "add" && -n "$arg2" ]]; then
  if [[ "$arg2" == "-h" || "$arg2" == "-l" || "$arg2" == "-m" ]]; then
    priority="$arg2"
    shift 3
    task="$arg3"
    for arg in "$@"; do
      task+=" $arg"
    done
    if [[ "$priority" == "-h" ]]; then
      priority_suffix="h"
    elif [[ "$priority" == "-m" ]]; then
      priority_suffix="m"
    else
      priority_suffix="l"
    fi
  else
    priority_suffix="l"
    task="$arg2"
    shift 2
    for arg in "$@"; do
      task+=" $arg"
    done
  fi
  if grep -q "^$task;;;" "$task_file"; then
    echo "duplicate task found: 'todo ls' to view all tasks"
  else
    echo "$task;;;${priority_suffix}" >> "$task_file"
    echo "task added successfully"
fi

elif [[ "$arg1" == "--help" && -z "$arg2" ]];then
  echo "todo ls: lists all task"
  echo "todo add task_name: add new task" 
  echo "todo rm task_name: remove task"
  echo "todo -m task_name: mark task done" 
  echo "todo rm -m task_name: remove marked task"
  echo "todo add -h task_name: add task as high priority"
  echo "todo add -l task_name: add task as low priority"
  echo "todo add -m task_name: add task as medium priority"

elif [[ "$arg1" == "rm" && -n "$arg2" && "$arg2" != "-m" ]]; then
  task_name="$arg2"
  shift 2
  for arg in "$@"; do
    task_name+=" $arg"
  done
  if grep -qE "^$task_name;;;[hmls]$" "$task_file";then
      escaped_task_name=$(printf '%s\n' "$task_name;;;" | sed 's/[]\/$*.^[]/\\&/g')
      sed -i "/$escaped_task_name/d" "$task_file"
      echo "task removed successfully"
  else
    echo "task not found: 'todo ls' to list all tasks"
  fi

elif [[ "$arg1" == "-m" && -n "$arg2" ]]; then
  task_name="$arg2"
  result=""
  shift 2
  for arg in "$@"; do
    task_name+=" $arg"
  done
  if grep -qE "^$task_name;;;[hml]$" "$task_file"; then
    escaped_task_name=$(printf '%s\n' "$task_name;;;" | sed 's/[]\/$*.^[]/\\&/g')
    sed -i "/$escaped_task_name/d" "$task_file"
    echo "$task_name;;;s" >> "$task_file"
    echo "task ${task} marked done"
  else
    echo "task not found: 'todo ls' to list all tasks"
  fi

elif [[ "$arg1" == "rm" && "$arg2" == "-m" && -n "$arg3" ]]; then
  task_name="$arg3"
  shift 3
  for arg in "$@"; do
    task_name+=" $arg"
  done
  marked_task=""
  for (( i=0; i<${#task_name}; i++ )); do
    marked_task+="${task_name:$i:1}$strike"
  done
  if grep -qE "^$task_name;;;[hmls]$" "$task_file";then
      escaped_task_name=$(printf '%s\n' "$task_name;;;" | sed 's/[]\/$*.^[]/\\&/g')
      sed -i "/$escaped_task_name/d" "$task_file"
      echo "task removed successfully"
  else
    echo "task not found: 'todo ls' to list all tasks"
  fi 
else
  echo "Command not recognized. Type 'todo --help' to view all commands."
fi

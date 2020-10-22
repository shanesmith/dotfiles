#!/bin/bash

railgun=$(railgun status --all)
server=$(/opt/dev/bin/dev sv status)

nothing_running=1

get_status() {
  local name=$1

  local color="#AAAAAA"

  if is_machine_running "$name"; then
    if is_server_running "$name"; then
      color="#7CAC8F"
    else
      color="#B6B785"
    fi
  else
    return
  fi

  nothing_running=0
  echo -n "#[fg=${color},bg=#202020,nobold,nounderscore,noitalics]${name} "
}

is_machine_running() {
  local name=$1
  grep "^${name}" -q <<<"$railgun"
}

is_server_running() {
  local name=$1
  grep "shopify/${name}" -q <<<"$server"
}

all_railguns() {
  defaults read com.shopify.railgun registered-project-paths | awk -F'"' '/^ / {print $2}' | xargs basename
}

for project in $(all_railguns); do
  get_status $project
done

if [[ $nothing_running == "1" ]]; then
  echo -n "#[fg=#AAAAAA,bg=#202020,nobold,nounderscore,noitalics]∅ "
fi

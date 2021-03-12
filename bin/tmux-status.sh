#!/bin/bash

railgun=$(railgun status --all | tail -1 | awk '{ print $1 }')
server=$(DEV_REAL_EVENTS=0 /opt/dev/bin/dev sv status)

get_status() {
  local name=$1

  if is_server_running "$name"; then
    color="#7CAC8F"
  else
    color="#B6B785"
  fi

  echo -n "#[fg=${color},bg=#202020,nobold,nounderscore,noitalics]${name} "
}

is_server_running() {
  local name=$1
  grep "^shopify/${name} " -q <<<"$server"
}

# all_railguns() {
#   defaults read com.shopify.railgun registered-project-paths | awk -F'"' '/^ / {print $2}' | xargs basename
# }

if [[ -z $railgun  ]]; then
  echo -n "#[fg=#AAAAAA,bg=#202020,nobold,nounderscore,noitalics]∅ "
  exit
fi

for project in $railgun; do
  get_status $project
done

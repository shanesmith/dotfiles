#!/bin/bash

WHITE="#FFFFFF"
BLACK="#202020"
RED="#E33939"
YELLOW="#E8E800"
GREEN="#28A324"

_trim() {
  local var

  if [[ $# -eq 0 ]]; then
    read -r var
  else
    var="$*"
  fi

  var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters

  echo -n "$var"
}

_status() {
  local color=$1
  local inverse=$2
  local text=$3
  local bg="#444444"
  local arrow="#444444"
  local arrow_bg="#202020"

  if [[ $inverse == "1" ]]; then
    local tmp=$bg
    bg=$color
    arrow=$color
    color=$tmp
  fi

  echo -n "#[fg=$arrow,bg=$arrow_bg,nobold,nounderscore,noitalics]#[fg=$color,bg=$bg,nobold,nounderscore,noitalics] $text #[fg=$arrow,bg=$arrow_bg,nobold,nounderscore,noitalics]"
}

docker-desktop-shell() {
  bkt -- docker run --rm --privileged --pid=host alpine nsenter -t 1 -m -u -n -i -- "$@"
}

docker_count() {
  if ! command -v docker >/dev/null; then
    return
  fi

  if ! docker info >/dev/null 2>&1; then
    _status $RED 1 "🐳"
    return
  fi

  local count=$(bkt --ttl=5s -- docker ps -q | wc -l | _trim)
  local disk_usage=$(BKT_TTL=60s docker-desktop-shell df -h /dev/vda1 | awk 'NR == 2 { print $5 }')
  local cpu_usage=$(BKT_TTL=10s docker-desktop-shell top -b -n 1 -d 5 | awk '/^CPU/ { print 100-$8 "%" }')
  local mem_usage=$(BKT_TTL=30s docker-desktop-shell free | awk 'NR == 2 { printf("%d%%", ($3/$2)*100) }')

  _status $WHITE 0 "🐳 ${count} | ${cpu_usage} | ${mem_usage} | ${disk_usage}"
}

kubectl_context() {
  if ! command -v kubectl >/dev/null; then
    return
  fi

  local title context namespace
  title="󱃾"
  # title="#[fg=#AAAAAA,nobold,nounderscore,noitalics]k8s#[fg=$WHITE,nobold,nounderscore,noitalics]"
  context=$(kubectl config current-context)
  namespace=$(kubectl config get-contexts --no-headers "${context}" | awk '{print $5}')


  _status $WHITE 0 "${title} ${context}  ${namespace:-default}"
}

aws_logged_in() {
  if ! command -v dev >/dev/null; then
    return
  fi

  if [[ ! -f ~/.aws/credentials ]]; then
    _status $RED 1 AWS
    return
  fi

  local expiry=$(awk '$1 == "x_security_token_expires" { print $3; exit }' < ~/.aws/credentials | sed -E 's/:([[:digit:]]{2})$/\1/' | xargs date -jf '%Y-%m-%dT%H:%M:%S%z' +%s)
  local remaining=$(( $expiry - $(date +%s) ))

  if [[ $remaining -lt 0 ]]; then
    _status $RED 1 AWS
  elif [[ $remaining -lt 1800 ]]; then
    _status $YELLOW 1 AWS
  elif [[ $remaining -lt 3600 ]]; then
    _status $YELLOW 0 AWS
  else
    _status $GREEN 0 AWS
  fi
}

aws_logged_in
docker_count
kubectl_context

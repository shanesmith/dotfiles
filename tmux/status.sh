#!/bin/bash

WHITE="#FFFFFF"
LIGHT_GRAY="#AAAAAA"
DARK_GRAY="#444444"
BLACK="#202020"
RED="#EF8E7D"
YELLOW="#E8E800"
GREEN="#59CE57"

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

_color() {
  local fg="fg=$1"
  local bg="${2:+,bg=$2}"
  echo -n "#[${fg}${bg}]"
}

_deco() {
  local decoration="$1"
  local text="$2"
  local no_decoration=$(echo -n "${decoration}" | sed -E 's/(^|,)/\1no/g')
  echo -n "#[${decoration}]${text}#[${no_decoration}]"
}

_status() {
  local color=$1
  local inverse=$2
  local text=$3
  local bg="${DARK_GRAY}"
  local arrow="${DARK_GRAY}"
  local arrow_bg="${BLACK}"

  if [[ $inverse == "1" ]]; then
    local tmp=$bg
    bg=$color
    arrow=$color
    color=$tmp
  fi

  echo -n "$(_color $arrow $arrow_bg)$(_color $color $bg) $text $(_color $arrow $arrow_bg)"
}

_attention() {
  local value="$1"
  local warn_level="$2"
  local danger_level="$3"

  if [[ ${value%%%} -gt ${danger_level} ]]; then
    value=$(_color $RED)${value}$(_color $WHITE)
  elif [[ ${value%%%} -gt ${warn_level} ]]; then
    value=$(_color $YELLOW)${value}$(_color $WHITE)
  fi

  echo -n "${value}"
}

docker-desktop-shell() {
  bkt -- timeout 2 docker run --rm --privileged --pid=host alpine nsenter -t 1 -m -u -n -i -- "$@"
}

docker_count() {
  if ! command -v docker >/dev/null; then
    return
  fi

  if ! timeout 2 docker info >/dev/null 2>&1; then
    _status $RED 1 "🐳"
    return
  fi

  local rawfile="$HOME/Library/Containers/com.docker.docker/Data/vms/0/data/Docker.raw"

  local count=$(BKT_TTL=5s bkt -- timeout 2 docker ps -q | wc -l | _trim)
  local disk_usage=$(stat -f '%b %z' "${rawfile}" | awk '{ printf("%d%%", ($1*512/$2)*100) }')
  local cpu_usage=$(BKT_TTL=10s docker-desktop-shell top -b -n 1 -d 5 | awk '/^CPU/ { print 100-$8 "%" }')
  local mem_usage=$(BKT_TTL=30s docker-desktop-shell free | awk 'NR == 2 { printf("%d%%", ($3/$2)*100) }')

  disk_usage=$(_attention "$disk_usage" 70 90)
  cpu_usage=$(_attention "$cpu_usage" 70 90)
  mem_usage=$(_attention "$mem_usage" 70 90)

  _status $WHITE 0 "🐳 ${count}  $(_deco dim "C:")${cpu_usage} $(_deco dim "M:")${mem_usage} $(_deco dim "D:")${disk_usage}"
}

kubectl_context() {
  if ! command -v kubectl >/dev/null; then
    return
  fi

  local title context namespace
  title="$(_color blue)󱃾$(_color $WHITE)"
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

tick_tock() {
  local cnt
  local tickfile="/tmp/tmux_status_tick"

  if [[ ! -f $tickfile ]]; then
    cnt=0
  else
    cnt=$(cat $tickfile)
  fi

  if [[ $(( cnt % 2 )) -eq 0 ]]; then
    fg=$LIGHT_GRAY
  else
    fg=$BLACK
  fi

  echo $(( cnt + 1 )) > $tickfile

  echo -n "$(_color "$fg"):"
}

aws_logged_in
docker_count
kubectl_context
tick_tock

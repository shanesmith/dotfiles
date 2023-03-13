#!/bin/bash

####################
## Hub Chain
####################

git-branch-name() {
  local ref=${1:-HEAD}
  git symbolic-ref --quiet --short "$ref"
}

hub-pr-info() {
  local branch=${1:-$(git-branch-name)}

  # pr-number state base newline
  hub pr list --state all -f "%I %pS %B %n" --head "$branch"
}

hub-pr-info-up() {
  local branch=${1:-$(git-branch-name)}

  # up-pr-number up-state up-branch newline
  hub pr list --state all -f "%I %pS %H %n" --base "$branch"
}

hub-chain() {
  local branch=$(git-branch-name)

  hub-chain-up $branch | tac | sed -e '$d' -e 's/^/  /'
  hub-chain-down $branch | sed -e '1s/^/* /' -e '2,$s/^/  /'
}

hub-chain-down() {
  local branch=$(git-branch-name)

  while [[ $branch != "master" ]]; do
    local pr_info=$(hub-pr-info $branch)

    hub-print-pr $(awk -v branch=$branch '{$3=branch; print}' <<< $pr_info)

    # local pr_number=$(awk '{print $1}' <<< $pr_info)
    # local state=$(awk '{print $2}' <<< $pr_info)
    branch=$(awk '{print $3}' <<< $pr_info)
    #
    # echo "#$pr_number [$state] $branch"

    # branch=$base
  done

  echo "master"
}

hub-chain-up() {
  local output=""

  local branch=${1:-$(git-branch-name)}

  local pr_info=$(hub-pr-info $branch)

  output+=$(hub-print-pr $(awk -v branch=$branch '{$3=branch; print}' <<< $pr_info))
  # tail -n1 <<<"$output"

  # local pr_number=$(awk '{print $1}' <<< $pr_info)
  # local state=$(awk '{print $2}' <<< $pr_info)
  # local pr_branch=$(awk '{print $3}' <<< $pr_info)
  #
  # output+="#$pr_number [$state] $branch \n"

  while true; do
    pr_info=$(hub-pr-info-up $branch)

    local pr_count=$(wc -l <<<"$pr_info")

    if [[ -z $pr_info ]]; then
      break
    elif [[ $pr_count -gt 1 ]]; then
      echo "$output"
      local i=0
      while read line; do
        ((i++))
        local prefix=$(printf '|%.0s' $(seq 1 $i))
        hub-chain-up $(awk '{print $3}' <<<"$line") | sed "s/^/$prefix /"
      done <<<"$pr_info"
      return
    fi

    output+=$'\n'$(hub-print-pr $pr_info)
    # tail -n1 <<<"$output"

    # pr_number=$(awk '{print $1}' <<< $pr_info)
    # state=$(awk '{print $2}' <<< $pr_info)
    branch=$(awk '{print $3}' <<< $pr_info)
    #
    # output+="#${pr_number} [$state] $pr_branch \n"

    # branch=$pr_branch
  done

  echo "$output"
  # echo "DONE!"
}

hub-print-pr() {
  local pr_number=$1
  local state=$2
  local branch=$3

  echo "#${pr_number} [$state] $branch"
}

hub-bob() {
  local branch=${1:-$(git-branch-name)}

  hub pr list --state all -f "%H %n" --base $branch
}

hub-base() {
  local branch=${1:-$(git-branch-name)}

  hub pr list --state all -f "%B %n" --head $branch
}

hub-set-base() {
  local base=${1}

  if [[ ! $base ]]; then
    echo "Need a base!"
    return 1
  fi

  local pr_number
  pr_number=$(awk '{print $1}' <<<"$(hub-pr-info)")

  hub api "repos/{owner}/{repo}/pulls/${pr_number}" --flat --field base=$base >/dev/null

  hub-chain
}

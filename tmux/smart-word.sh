#!/bin/bash

# set -euo pipefail

# https://github.com/Morantron/tmux-fingers/blob/9b393e5757220f708376f160a5f2f4b547b00808/src/fingers/config.cr#L29
PATTERNS=(
  # ip
  '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(:\d{1,4})?'
  # uuid
  '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
  # sha
  '[0-9a-f]{7,128}'
  # digit
  # "[0-9]{4,}"
  # url
  '(https?:\/\/|git@|git:\/\/|ssh:\/\/|ftp:\/\/|file:\/\/\/)[^\ ()\"]+'
  # path
  '([.\w\-~\$@]+)?(/[.\w\-@]+)+/?'
  # hex
  "0x[0-9a-fA-F]+"
  # brackets
  '(?<=\")[^"]*(?=\")'
  "(?<=')[^']*(?=')"
  '(?<=\[)[^]]*(?=])'
  '(?<=\<)[^>]*(?=>)'
  '(?<=\{)[^}]*(?=})'
  '(?<=\()[^)]*(?=\))'
  # kubernetes
  # "(deployment.app|binding|componentstatuse|configmap|endpoint|event|limitrange|namespace|node|persistentvolumeclaim|persistentvolume|pod|podtemplate|replicationcontroller|resourcequota|secret|serviceaccount|service|mutatingwebhookconfiguration.admissionregistration.k8s.io|validatingwebhookconfiguration.admissionregistration.k8s.io|customresourcedefinition.apiextension.k8s.io|apiservice.apiregistration.k8s.io|controllerrevision.apps|daemonset.apps|deployment.apps|replicaset.apps|statefulset.apps|tokenreview.authentication.k8s.io|localsubjectaccessreview.authorization.k8s.io|selfsubjectaccessreviews.authorization.k8s.io|selfsubjectrulesreview.authorization.k8s.io|subjectaccessreview.authorization.k8s.io|horizontalpodautoscaler.autoscaling|cronjob.batch|job.batch|certificatesigningrequest.certificates.k8s.io|events.events.k8s.io|daemonset.extensions|deployment.extensions|ingress.extensions|networkpolicies.extensions|podsecuritypolicies.extensions|replicaset.extensions|networkpolicie.networking.k8s.io|poddisruptionbudget.policy|clusterrolebinding.rbac.authorization.k8s.io|clusterrole.rbac.authorization.k8s.io|rolebinding.rbac.authorization.k8s.io|role.rbac.authorization.k8s.io|storageclasse.storage.k8s.io)[[:alnum:]_#$%&+=/@-]+"
  # git-status
  # "(modified|deleted|new file): +(?<match>.+)"
  # git-status-branch
  # "Your branch is up to date with ''."
  # diff
  # "(---|\\+\\+\\+) [ab]/(?<match>.*)"
  # word
  '(?<=(^|\s))[^\s]*(?=(\s|$))'
)

line="$1"
cursor_pos="$2"

# for pattern in "${PATTERNS[@]}"; do
#   regex="^(.{0,${cursor_pos}}?)(${pattern})(.*)$"
#
#   front=$(perl -pe "s/${regex}/\\1/" <<<"$line")
#
#   if [[ "$front" == "$line" ]]; then
#     continue
#   fi
#
#   match=$(perl -pe "s/${regex}/\\2/" <<<"$line")
#   back=$(perl -pe "s/${regex}/\\3/" <<<"$line")
#
#   move_left=$(( ${cursor_pos} - ${#front} ))
#   move_right=$(( ${#match} - 1 ))
#
#   # echo "${line}"
#   # echo "${cursor_pos}"
#   # echo "${#front} | ${front}"
#   # echo "${#match} | ${match}"
#   # echo "${#back} | ${back}"
#   # echo "${move_left} <-> ${move_right}"
#
#   tmux send -X -N "${move_left}" cursor-left
#   tmux send -X begin-selection
#   tmux send -X -N "${move_right}" cursor-right
#
#   exit
# done

debug() {
  :
  # echo "$@"
}

debug "line: $line"
debug "cursor_pos: $cursor_pos"

for pattern in "${PATTERNS[@]}"; do
  debug "pattern: $pattern"

  matches=$(rg -Pbo "${pattern}" <<<"$line")

  while read -r match; do
    if [[ -z $match ]]; then
      continue
    fi

    str="${match#*:}"
    start_pos="${match%%:*}"
    end_pos=$(( $start_pos + ${#str} ))

    debug "str: $str"
    debug "start: $start_pos"
    debug "end: $end_pos"

    if [[ $cursor_pos -lt $start_pos || $cursor_pos -gt $end_pos ]]; then
      continue
    fi

    found=1

    move_left=$(( $cursor_pos - $start_pos ))
    move_right=$(( ${#str} - 1 ))

    debug $move_left
    debug $move_right

    tmux send -X -N "${move_left}" cursor-left
    tmux send -X begin-selection
    tmux send -X -N "${move_right}" cursor-right

    exit
  done <<<"$matches"
done

debug "nothing =("

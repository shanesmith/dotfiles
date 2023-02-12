#!/bin/bash

parent_pid=$1
pid=
stat=

while true; do
  out=$(ps -o "ppid,pid,stat,command" | awk -v ppid="$parent_pid" '$1 == ppid {print; exit}')
  pid=$(awk '{ print $2 }' <<<"$out")
  stat=$(awk '{ print $3 }' <<<"$out")

  [[ -z $out || $stat =~ \+ ]] && break

  parent_pid="$pid"
done

if [[ -z $pid ]]; then
  tmux display-message "❌ Could not find process"
  exit
fi

cmd=$(ps -o "command=" -p "$pid")

if pgrep -qfx "noti --pushbullet --banner -t $cmd -w $pid"; then
  tmux display-message "✔️ Notifier already exists for ($pid) $cmd"
  exit
fi

tmux display-message "✅ Notifier set up for ($pid) $cmd"

noti --pushbullet --banner -t "$cmd" -w "$pid" &
disown

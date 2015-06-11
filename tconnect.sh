#!/bin/bash

if ! type tmux > /dev/null; then
  echo "tmux command not found."
  exit 1
fi

SSH="ssh"
if type autossh > /dev/null; then
  SSH="autossh -M 0"
fi

main () {

  local started_at=`date "+%Y%m%d-%H%M%S"`
  local session_name="tconnect-at-$started_at"

  tmux new-session -d -s "$session_name"
  tmux send-keys "$SSH $1" C-m
  shift

  for i in $@;do
    tmux split-window
    tmux select-layout tiled
    tmux send-keys "$SSH $i" C-m
  done

  tmux select-pane -t 0
  tmux set-window-option synchronize-panes on
  tmux attach-session -t "$session_name"
}

main "$@"

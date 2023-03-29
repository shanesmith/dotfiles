#!/bin/bash
#
# http://www.cita.utoronto.ca/~shirokov/soft/ssh-agent
#
# Checks authentication environment.
# If the ssh-agent is not running, starts a new one.
#

SSH_ENV=$HOME/.ssh/env-$HOSTNAME

# Initialize new agent and add authentication
sshauth_reload() {
  if [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ] && [ -n "$SSH_AGENT_PID" ]; then
    return
  fi

  if [ -f "$SSH_ENV" ]; then
    # Find SSH_AUTH_SOCK and SSH_AGENT_PID of the available daemon
    # shellcheck source=/dev/null
    . "${SSH_ENV}" > /dev/null

    # Check if the agent is still running
    # shellcheck disable=2009
    if ps -o "comm=" "${SSH_AGENT_PID}" | grep -q ssh-agent; then
      return
    fi
  fi

  mkdir -p "$(dirname "$SSH_ENV")"

  # Start authenticating daemon
  # No authentications set up yet, just starting daemon!
  ssh-agent -t 1d | head -2 > "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"

  # Find SSH_AUTH_SOCK and SSH_AGENT_PID of the available daemon
  # shellcheck source=/dev/null
  . "${SSH_ENV}" > /dev/null
}

sshauth_reload

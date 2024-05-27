#!/bin/bash

alias dk="docker"
complete -F _docker dk

alias dk-stop-all="docker ps -q | xargs -r docker stop"
alias dk-kill-all="docker ps -q | xargs -r docker kill"

alias dkc="docker-compose"
complete -F _docker_compose dkc

docker-desktop-logs() {
  # https://docs.docker.com/desktop/mac/troubleshoot/#check-the-logs
  pred='process matches ".*(ocker|vpnkit).*" || (process in {"taskgated-helper", "launchservicesd", "kernel"} && eventMessage contains[c] "docker")'
  /usr/bin/log stream --style syslog --level=debug --color=always --predicate "$pred"
}

docker-desktop-shell() {
  docker run -it --rm --privileged --pid=host justincormack/nsenter1
}

alias pd=podman
complete -o default -F __start_podman pd

alias pdc=podman-compose
alias pdm="podman machine"

podman-fw-list() {
  podman machine ssh curl --silent --fail-with-body http://gateway.containers.internal/services/forwarder/all | jq
}

podman-fw-expose() {
  podman machine ssh curl --silent --fail-with-body http://gateway.containers.internal/services/forwarder/expose -X POST -d "'{\"local\":\"$1\", \"remote\":\"$2\"}'"
}


podman-fw-unexpose() {
  podman machine ssh curl --silent --fail-with-body http://gateway.containers.internal/services/forwarder/unexpose -X POST -d "'{\"local\":\"$1\"}'"
}

pd-history() {
  podman history --no-trunc --format "{{.ID}}\t{{.Size}}\t{{.CreatedBy}}" "$@" | less
}


podman-build-podman() {
  if ! podman image exists pd-builder; then
    podman build -t pd-builder -f - . <<EOF
        FROM fedora:36

        RUN yum install -y \
          btrfs-progs-devel \
          conmon \
          containernetworking-plugins \
          containers-common \
          crun \
          device-mapper-devel \
          git \
          glib2-devel \
          glibc-devel \
          glibc-static \
          go \
          golang-github-cpuguy83-md2man \
          gpgme-devel \
          iptables \
          libassuan-devel \
          libgpg-error-devel \
          libseccomp-devel \
          libselinux-devel \
          make \
          pkgconfig

        RUN mkdir -p /root/go/src/github.com/containers \
          && git config --global --add safe.directory /root/go/src/github.com/containers/podman
EOF
  fi

  podman run --rm -v "$HOME"/Code/podman:/root/go/src/github.com/containers/podman pd-builder make -C /root/go/src/github.com/containers/podman BUILDFLAGS=-buildvcs=false podman

  # shellcheck disable=2181
  if [[ $? -eq 0 ]]; then
    sleep 2
    podman-use-built-podman
  fi
}

podman-use-built-podman() {
  podman machine ssh 'rpm-ostree usroverlay; ret=1 && while [[ $ret -ne 0 ]]; do sleep 1; echo -n "."; cp /Users/shane/Code/podman/bin/podman /usr/bin/podman 2>/dev/null; ret=$?; done && podman version'
}


podman-grow-disk() {
  local new_size="$1"

  local machine_config="$HOME/.config/containers/podman/machine/qemu/podman-machine-default.json"

  local current_size
  current_size=$(jq -r .DiskSize "$machine_config")

  [[ $new_size -le $current_size ]] && exit 0

  echo "Increasing Podman VM disk size from $current_size GB to $new_size GB"
  local machine_image
  machine_image=$(jq -r .ImagePath.Path "$machine_config")

  # Step 1: Stop the machine
  podman machine stop
  # From lib/dev/helpers/podman.rb in `dev`:
  # there's a chance podman will get in a bad state if the machine
  # is started too soon after it's stopped, so we add a bit of a delay
  sleep 3

  # Step 2: Grow the qemu virtual image size
  qemu-img resize --shrink "$machine_image" "${new_size}G"

  # Step 3: Update the Podman machine's disk size config (using a temp file because there's no `jq --in-place`)
  cp "$machine_config" "${machine_config}~"
  jq ".DiskSize = ${new_size}" > "$machine_config" < "${machine_config}~"
  rm "${machine_config}~"

  # Step 4: Start the machine
  podman machine start

  # Step 5: Grow partition and filesystem
  podman machine ssh "sudo growpart /dev/vda 4 && sudo xfs_growfs /"

  podman machine ssh df -h /
}

podman-enable-swap() {
  podman machine ssh dd if=/dev/zero of=/var/swap-file bs=1024 count=6000000
  podman machine ssh chmod 600 /var/swap-file
  podman machine ssh mkswap /var/swap-file
  podman machine ssh swapon /var/swap-file
  podman machine ssh 'echo "/var/swap-file none swap sw 0 0" | sudo tee -a /etc/fstab'
  podman machine ssh free -m
}


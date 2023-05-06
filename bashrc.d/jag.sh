#!/bin/bash

JAG_ISOGUN_TEST_SERVICES=(
  bigtable
  elasticsearch-v7
  elasticsearch-v8
  elasticsearch-v8.6
  kafka
  magellan
  memcached
  mysql
  nginx
  redis
  schema-registry
  seed-kafka-service
  toxiproxy
  zookeeper
)

jag() {
  local tasks dir devyml

  readarray -t -d "," tasks <<<"$1"
  dir=$(mktemp -d -t "jag")
  devyml="${dir}/dev.yml"

  export JAGDIR="$dir"

  echo "Project directory: ${dir}"
  echo "Tasks: ${tasks[*]}"

  echo -e "name: jag\nup:" > "$devyml"
  for t in "${tasks[@]}"; do
    echo "  - ${t}" >> "$devyml"
  done

  ( cd "$dir" && dev up )
}

cdjag() {
  # shellcheck disable=2164
  cd "$JAGDIR"
}

jag-isogun-test-all() {
  local ret
  local start=${1}
  for s in "${JAG_ISOGUN_TEST_SERVICES[@]}"; do
    if [[ -n $start ]]; then
      if [[ "$start" == "$s" ]]; then
        start=
      else
        continue
      fi
    fi
    jag-isogun-test "$s"
    ret=$?
    if [[ $ret -ne 0 ]]; then
      return 1
    fi
  done
}

jag-isogun-test() {
  local service=$1
  local dir
  dir=$(mktemp -d -t "jag-${service}")

  export JAGDIR="$dir"

  echo "👀 ${service}"

  cat <<-EOF > "${dir}/dev.yml"
    name: jag

    up:
      - isogun
EOF

  cat <<-EOF > "${dir}/isogun.yml"
    name: jag

    vm:
      ip_address: 192.168.64.123
      memory:     4G
      cores:      4

    services:
      - ${service}

    hostnames:
      - jag.railgun
EOF

  sudo -v

  ( cd "${dir}" && dev isogun reset )

  local ret=$?

  if [[ $ret -ne 0 ]]; then
    echo "'dev isogun reset' failed"
    return $ret
  fi

  ( cd "${dir}" && eval "$(shadowenv hook)" && isogun-test "${service}" )

  local ret=$?

  if [[ $ret -ne 0 ]]; then
    ( cd "${dir}" && dev isogun logs "${service}" )
    return $ret
  fi

  echo ""
  echo "✅ ${service}"
  echo ""
}

isogun-test() {
  local service="$1"

  local retry=0
  local max_retries=5

  local ret

  while true; do
    case "${service}" in
      toxiproxy) curl "$TOXIPROXY_HOST:$TOXIPROXY_PORT/version" ;;
      elasticsearch-v7) curl -fsS -I -XHEAD "$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT" | grep -q Elasticsearch ;;
      elasticsearch-v8) curl -fsS -I -XHEAD "$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT" | grep -q Elasticsearch ;;
      zookeeper) [[ $(nc "$ZOOKEEPER_HOST" "$ZOOKEEPER_PORT" <<<stat) =~ ^Zookeeper ]] ;;
      magellan) curl "$MAGELLAN_HOST:$MAGELLAN_PORT/ping" ;;
      bigtable) cbt -timeout 3s -project dev -instance dev ls ;; # 
      nginx) curl "$NGINX_HOST:$NGINX_PORT" ;;
      kafka) kcat -b "$KAFKA_HOST:$KAFKA_PORT" -L ;;
      memcached) [[ $(nc "$MEMCACHED_HOST" "$MEMCACHED_PORT" <<<$'stats\nquit') =~ ^STAT ]] ;;
      redis) [[ $(nc "$REDIS_HOST" "$REDIS_PORT" <<<$'PING\nQUIT') =~ ^\+PONG ]] ;;
      mysql) mysql -u root -h "$MYSQL_HOST" -P "$MYSQL_PORT" -e '\q' ;; 
      schema-registry) curl "$SCHEMA_REGISTRY_HOST:$SCHEMA_REGISTRY_PORT" ;;
      seed-kafka-service) curl "$SEED_KAFKA_SERVICE_HOST:$SEED_KAFKA_SERVICE_PORT/health/live" ;;
      *) echo "isogun-test does not know the service ${service}" && return 1 ;;
    esac

    ret=$?

    if [[ $ret -eq 0 || $((++retry)) -eq $max_retries ]]; then
      return $ret
    fi

    sleep 2
    echo "Retry test #${retry}..."
  done
}

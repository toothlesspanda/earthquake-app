#!/bin/bash
# wait-for-it.sh - Wait for a service to be available

TIMEOUT=30
QUIET=0
HOST=
PORT=

while test $# -gt 0; do
  case "$1" in
    *:*)
    HOST=$(printf "%s" "$1" | cut -d : -f 1)
    PORT=$(printf "%s" "$1" | cut -d : -f 2)
    shift
    ;;
    -t)
    TIMEOUT="$2"
    if [ "$TIMEOUT" = "" ]; then break; fi
    shift 2
    ;;
    -q | --quiet)
    QUIET=1
    shift
    ;;
    --)
    shift
    break
    ;;
    --help)
    echo "Usage: $0 host:port [-t timeout] [-- command args]"
    exit 0
    ;;
    *)
    break
    ;;
  esac
done

if [ "$HOST" = "" ] || [ "$PORT" = "" ]; then
  echo "Error: you need to specify a host and port to wait for."
  exit 1
fi

if [ "$TIMEOUT" -le 0 ]; then
  wait_for_service "$@"
else
  (wait_for_service "$@") &
  pid=$!
  trap "kill -9 $pid" INT TERM
  wait $pid
fi

# The main waiting function
wait_for_service() {
  for i in $(seq $TIMEOUT); do
    if nc -z "$HOST" "$PORT"; then
      if [ $QUIET -eq 0 ]; then echo "$HOST:$PORT is available after $i seconds"; fi
      exec "$@"
    fi
    sleep 1
  done
  if [ $QUIET -eq 0 ]; then echo "Timeout occurred after $TIMEOUT seconds waiting for $HOST:$PORT"; fi
  exit 1
}

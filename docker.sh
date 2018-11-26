#!/bin/sh
NAME="flaskr"
DEV_ENV="-e FLASK_APP=flaskr -e FLASK_DEBUG=1 -e FLASK_ENV=development"
DEV_CMD="flask run --host=0.0.0.0 --port=80"
INIT_DB_ENV="-e FLASK_APP=flaskr"
INIT_DB_CMD="flask init-db"
RUN_ENV="-e STATIC_PATH=/app/flaskr/static"
PORTS="127.0.0.1:80:80"
VMAP="$(pwd)/app:/app"
IMAGE="stodh/uwsgi-nginx-flaskr-security"

# Compute work dir
CALLER_SCRIPT="$(readlink -f "$0")" || true
CALLER_SCRIPT_DIR="$(dirname "$CALLER_SCRIPT")" || true
if [ -n "$CALLER_SCRIPT_DIR" ]; then
	cd $CALLER_SCRIPT_DIR
fi

# Process options
case "$1" in
dev)
    docker run --rm -d $DEV_ENV --name "$NAME" -p "$PORTS" -v "$VMAP" \
           "$IMAGE" $DEV_CMD
;;
init-db)
    docker run --rm -d $INIT_DB_ENV --name "$NAME" -p "$PORTS" -v "$VMAP" \
           "$IMAGE" $INIT_DB_CMD
;;
logs)
    docker logs -f "$NAME"
;;
reload)
    docker exec "$NAME" touch /run/uwsgi.reload
;;
run)
    docker run --rm -d $RUN_ENV --name "$NAME" -p "$PORTS" -v "$VMAP" "$IMAGE"
;;
shell)
    docker exec -ti "$NAME" /bin/sh
;;
status)
    docker ps -f name="$NAME"
;;
stop)
    docker stop "$NAME"
;;
*)
	echo "Uso: $0 [dev|logs|init-db|reload|run|shell|status|stop]"
esac

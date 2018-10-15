#!/bin/sh
if [ ! -f "./instance/flaskr.sqlite" ]; then
	export FLASK_APP=flaskr
	flask init-db
fi

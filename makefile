.PHONY: db db_console iex iex_dev iex_test

# POSTGRES_DB not provided so the POSTGRES_USER will be used as a name the default database
# POSTGER_{USER,PASSWORD} will create a user with superpower
# https://hub.docker.com/_/postgres?tab=description
db:
	docker run --rm -p 5432:5432 \
	-e POSTGRES_USER=${DB_USER} \
	-e POSTGRES_PASSWORD=${DB_PASSWORD} \
	-v `pwd`/postgres_data:/var/lib/postgresql/data \
	--name live_view_todos_db postgres:14

db_console:
	docker exec -it live_view_todos_db psql -U ${DB_PASSWORD}

iex: iex_dev

iex_srv: iex_srv_dev

iex_dev:
	iex -S mix

iex_srv_dev:
	iex -S mix phx.server

iex_test:
	MIX_ENV=test iex -S mix
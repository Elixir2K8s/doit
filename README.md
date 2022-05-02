# Doit - A simple Realtime Todo Elixir Webapp

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`127.0.0.1:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


Once you are ready, visit "/users/register"
to create your account and then access "/dev/mailbox" to
see the account confirmation email.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## via Docker-Compose
alternatively you can also work directly with docker-compose
  
  * build the image with `docker-compose build`
  * run with `docker-compose up`
  * to create initial database for the app run the folowing script `docker-compose run elixir /app/bin/doit eval "Doit.Release.create"`
  * (optional) alternatively you can also log into the database via psql in a second terminal `psql -h localhost -p 7000 -d postgres -U postgres --password`
  * then migrate with `docker-compose run elixir /app/bin/doit eval "Doit.Release.migrate"`

if you want to jump inside the elixir debian-buster distro run

  * `docker-compose run elixir /bin/sh` 

Detail information can be found in the Dockerfile as well as in the docker-compose.yml.
Environment variables for the docker environment can be set in the .env file



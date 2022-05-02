defmodule Doit.Repo do
  use Ecto.Repo,
    otp_app: :doit,
    adapter: Ecto.Adapters.Postgres
end

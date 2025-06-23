defmodule HandleStackoverflow.Repo do
  use Ecto.Repo,
    otp_app: :handle_stackoverflow,
    adapter: Ecto.Adapters.Postgres
end

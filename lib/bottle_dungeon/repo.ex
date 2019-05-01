defmodule BottleDungeon.Repo do
  use Ecto.Repo,
    otp_app: :bottle_dungeon,
    adapter: Ecto.Adapters.Postgres
end

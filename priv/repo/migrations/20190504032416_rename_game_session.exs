defmodule BottleDungeon.Repo.Migrations.RenameGameSession do
  use Ecto.Migration

  def change do
    rename table(:game_sessions), to: table(:campaigns)
  end
end

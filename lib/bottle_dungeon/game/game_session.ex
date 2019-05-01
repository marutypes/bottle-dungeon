defmodule BottleDungeon.Game.GameSession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_sessions" do
    field :description, :string
    field :title, :string
    belongs_to :user, BottleDungeon.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(game_session, attrs) do
    game_session
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end

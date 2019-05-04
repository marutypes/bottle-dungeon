defmodule BottleDungeon.Game.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  schema "campaigns" do
    field :description, :string
    field :title, :string
    belongs_to :user, BottleDungeon.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end

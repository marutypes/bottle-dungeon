defmodule BottleDungeon.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BottleDungeon.Accounts.Credential
  alias BottleDungeon.Game.Campaign

  schema "users" do
    field :username, :string
    has_one :credential, Credential
    has_many :campaigns, Campaign

    timestamps()
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end
end

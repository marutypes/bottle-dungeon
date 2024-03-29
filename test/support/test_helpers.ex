defmodule BottleDungeon.TestHelpers do
  alias BottleDungeon.{
    Accounts,
    Game
  }

  def user_fixture(attrs \\ %{}) do
    username = "user#{System.unique_integer([:positive])}"

    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: username,
        credential: %{
          email: attrs[:email] || "#{username}@example.com",
          password: attrs[:password] || "super-secret",
        }
      })
      |> Accounts.register_user()

      user
  end

  def campaign_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "A title",
        description: "a description"
      })

    {:ok, game} = Game.create_campaign(user, attrs)
    game
  end

  def campaign_count() do
    Game.count_campaigns()
  end
end

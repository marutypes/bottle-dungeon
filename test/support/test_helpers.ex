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

  def game_session_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "A title",
        description: "a description"
      })

    {:ok, game} = Game.create_game_session(user, attrs)
    game
  end

  def game_session_count() do
    Game.count_game_sessions()
  end
end

defmodule BottleDungeonWeb.GameSessionViewTest do
  use BottleDungeonWeb.ConnCase, async: true
  import Phoenix.View

  alias BottleDungeon.Game.GameSession
  alias BottleDungeon.Accounts.User

  test "renders index.html", %{conn: conn} do
    games = [
      %GameSession{id: 1, title: "CounterWeight"},
      %GameSession{id: 2, title: "Marielda"}
    ]

    content =
      render_to_string(BottleDungeonWeb.GameSessionView, "index.html",
        conn: conn,
        game_sessions: games
      )

    assert String.contains?(content, "My Games")

    for game <- games do
      assert String.contains?(content, game.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    owner = %User{}
    changeset = BottleDungeon.Game.change_game_session(%GameSession{})

    content =
      render_to_string(BottleDungeonWeb.GameSessionView, "new.html",
        conn: conn,
        changeset: changeset
      )

    assert String.contains?(content, "New Game session")
  end
end

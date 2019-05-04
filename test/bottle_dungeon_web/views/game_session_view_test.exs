defmodule BottleDungeonWeb.CampaignViewTest do
  use BottleDungeonWeb.ConnCase, async: true
  import Phoenix.View

  alias BottleDungeon.Game.Campaign
  alias BottleDungeon.Accounts.User

  test "renders index.html", %{conn: conn} do
    games = [
      %Campaign{id: 1, title: "CounterWeight"},
      %Campaign{id: 2, title: "Marielda"}
    ]

    content =
      render_to_string(BottleDungeonWeb.CampaignView, "index.html",
        conn: conn,
        campaigns: games
      )

    assert String.contains?(content, "My Games")

    for game <- games do
      assert String.contains?(content, game.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    owner = %User{}
    changeset = BottleDungeon.Game.change_campaign(%Campaign{})

    content =
      render_to_string(BottleDungeonWeb.CampaignView, "new.html",
        conn: conn,
        changeset: changeset
      )

    assert String.contains?(content, "New Game session")
  end
end

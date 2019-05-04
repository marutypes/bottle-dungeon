defmodule BottleDungeonWeb.PlayController do
  use BottleDungeonWeb, :controller

  alias BottleDungeon.Game

  def show(conn, %{"id" => id}) do
    campaign = Game.get_campaign!(id)
    render(conn, "show.html", campaign: campaign)
  end
end

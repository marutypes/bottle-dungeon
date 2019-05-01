defmodule BottleDungeonWeb.PageController do
  use BottleDungeonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

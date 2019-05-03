defmodule BottleDungeonWeb.PageControllerTest do
  use BottleDungeonWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to BottleDungeon"
  end
end

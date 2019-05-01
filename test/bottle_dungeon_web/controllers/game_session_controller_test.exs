defmodule BottleDungeonWeb.GameSessionControllerTest do
  use BottleDungeonWeb.ConnCase

  alias BottleDungeon.Game

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  def fixture(:game_session) do
    {:ok, game_session} = Game.create_game_session(@create_attrs)
    game_session
  end

  describe "index" do
    test "lists all game_sessions", %{conn: conn} do
      conn = get(conn, Routes.game_session_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Game sessions"
    end
  end

  describe "new game_session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.game_session_path(conn, :new))
      assert html_response(conn, 200) =~ "New Game session"
    end
  end

  describe "create game_session" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.game_session_path(conn, :create), game_session: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.game_session_path(conn, :show, id)

      conn = get(conn, Routes.game_session_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Game session"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.game_session_path(conn, :create), game_session: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Game session"
    end
  end

  describe "edit game_session" do
    setup [:create_game_session]

    test "renders form for editing chosen game_session", %{conn: conn, game_session: game_session} do
      conn = get(conn, Routes.game_session_path(conn, :edit, game_session))
      assert html_response(conn, 200) =~ "Edit Game session"
    end
  end

  describe "update game_session" do
    setup [:create_game_session]

    test "redirects when data is valid", %{conn: conn, game_session: game_session} do
      conn = put(conn, Routes.game_session_path(conn, :update, game_session), game_session: @update_attrs)
      assert redirected_to(conn) == Routes.game_session_path(conn, :show, game_session)

      conn = get(conn, Routes.game_session_path(conn, :show, game_session))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, game_session: game_session} do
      conn = put(conn, Routes.game_session_path(conn, :update, game_session), game_session: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Game session"
    end
  end

  describe "delete game_session" do
    setup [:create_game_session]

    test "deletes chosen game_session", %{conn: conn, game_session: game_session} do
      conn = delete(conn, Routes.game_session_path(conn, :delete, game_session))
      assert redirected_to(conn) == Routes.game_session_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.game_session_path(conn, :show, game_session))
      end
    end
  end

  defp create_game_session(_) do
    game_session = fixture(:game_session)
    {:ok, game_session: game_session}
  end
end

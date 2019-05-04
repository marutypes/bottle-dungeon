defmodule BottleDungeonWeb.GameSessionControllerTest do
  use BottleDungeonWeb.ConnCase
  alias BottleDungeon.Game

  describe "with a logged in user" do
    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    end

    @tag login_as: "mallen"
    test "lists all user's videos on the index", %{conn: conn, user: user} do
      user_game_session = game_session_fixture(user, title: "The Restless Season")
      other_user = user_fixture(username: "someone else")
      other_game_session = game_session_fixture(other_user, title: "Blades in the ARC")

      conn = get conn, Routes.game_session_path(conn, :index)
      assert String.contains?(conn.resp_body, user_game_session.title)
      refute String.contains?(conn.resp_body, other_game_session.title)
    end

    @create_attrs %{title: "Radical Game", description: "It is cool as heck"}
    @invalid_attrs %{}

    @tag login_as: "Kokusho"
    test "creates user game_session and redirects", %{conn: conn, user: user} do
      create_conn = post conn, Routes.game_session_path(conn, :create), game_session: @create_attrs

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.game_session_path(create_conn, :show, id)

      conn = get conn, Routes.game_session_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Radical Game"
      assert Game.get_game_session!(id).user_id == user.id
    end

    @tag login_as: "Catherine"
    test "does not create game_session and renders errors when invalid", %{conn: conn} do
      count_before = game_session_count()
      conn = post conn, Routes.game_session_path(conn, :create), game_session: @invalid_attrs
      assert html_response(conn, 200) =~ "check the errors"
      assert game_session_count() == count_before
    end
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.game_session_path(conn, :new)),
      get(conn, Routes.game_session_path(conn, :index)),
      get(conn, Routes.game_session_path(conn, :show, "123")),
      get(conn, Routes.game_session_path(conn, :update, "123", %{})),
      get(conn, Routes.game_session_path(conn, :create, %{})),
      get(conn, Routes.game_session_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end

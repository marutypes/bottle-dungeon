defmodule BottleDungeonWeb.AuthTest do
  use BottleDungeonWeb.ConnCase
  alias BottleDungeonWeb.Auth
  alias BottleDungeon.Accounts.User

  setup %{conn: conn} do
    result =
      conn
      |> bypass_through(BottleDungeonWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: result}}
  end

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    result = Auth.authenticate_user(conn, [])
    assert result.halted
  end

  test "authenticate_user continues when the current_user exists", %{conn: conn} do
    result =
      conn
      |> assign(:current_user, %User{})
      |> Auth.authenticate_user([])

    refute result.halted
  end

  test "login puts the user in the session", %{conn: conn} do
    login_conn =
      conn
      |> Auth.login(%User{id: 123})
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == 123
  end

  test "login drops the session", %{conn: conn} do
    logout_conn =
      conn
      |> put_session(:user_id, 123)
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  test "call places the user from session into assigns", %{conn: conn} do
    user = user_fixture()

    result =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Auth.init([]))

    assert result.assigns.current_user.id == user.id
  end

  test "call with no session sets current_user assign to nil", %{conn: conn} do
    result = Auth.call(conn, Auth.init([]))
    assert result.assigns.current_user == nil
  end

  test "login with a valid username and pass", %{conn: conn} do
    user =
      user_fixture(%{username: "kokeskusho", email: "kitboi@meow.com", password: "secretpass11"})

    {:ok, result} = Auth.login_by_email_and_pass(conn, "kitboi@meow.com", "secretpass11")

    assert result.assigns.current_user.id == user.id
  end

  test "login with a not found user", %{conn: conn} do
    assert {:error, :unauthorized, _conn} =
             Auth.login_by_email_and_pass(conn, "kitboi@meow.com", "secretpass11")
  end

  test "login with a username and password mismatch", %{conn: conn} do
    _ = user_fixture(username: "me", email: "me@test.com", password: "secretpass2")

    assert {:error, :unauthorized, _conn} =
             Auth.login_by_email_and_pass(conn, "me@test.com", "not my password")
  end
end

defmodule BottleDungeonWeb.GameSessionController do
  use BottleDungeonWeb, :controller

  alias BottleDungeon.Game

  plug :hide_if_not_owner when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    game_sessions = Game.list_user_game_sessions(user(conn))
    render(conn, "index.html", game_sessions: game_sessions)
  end

  def new(conn, _params) do
    changeset = Game.change_game_session()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game_session" => game_session_params}) do
    case Game.create_game_session(user(conn), game_session_params) do
      {:ok, game_session} ->
        conn
        |> put_flash(:info, "Game session created successfully.")
        |> redirect(to: Routes.game_session_path(conn, :show, game_session))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    game_session = conn.assigns[:game_session]
    render(conn, "show.html", game_session: game_session)
  end

  def edit(conn, _params) do
    game_session = conn.assigns[:game_session]
    changeset = Game.change_game_session(game_session)
    render(conn, "edit.html", game_session: game_session, changeset: changeset)
  end

  def update(conn, %{"game_session" => game_session_params}) do
    current_game_session = conn.assigns[:game_session]

    case Game.update_game_session(current_game_session, game_session_params) do
      {:ok, game_session} ->
        conn
        |> put_flash(:info, "Game session updated successfully.")
        |> redirect(to: Routes.game_session_path(conn, :show, game_session))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game_session: current_game_session, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    game_session = conn.assigns[:game_session]
    {:ok, _game_session} = Game.delete_game_session(game_session)

    conn
    |> put_flash(:info, "Game session deleted successfully.")
    |> redirect(to: Routes.game_session_path(conn, :index))
  end

  defp user(conn) do
    conn.assigns.current_user
  end

  def hide_if_not_owner(conn, _options) do
    id = conn.path_params["id"]
    game_session = id && Game.get_user_game_session(user(conn), id)

    if is_nil(game_session) do
      conn
      |> put_status(:not_found)
      |> put_view(BottleDungeonWeb.ErrorView)
      |> render("404.html")
      |> halt()
    else
      assign(conn, :game_session, game_session)
    end
  end
end

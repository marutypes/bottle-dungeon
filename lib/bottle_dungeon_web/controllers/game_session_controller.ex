defmodule BottleDungeonWeb.GameSessionController do
  use BottleDungeonWeb, :controller

  alias BottleDungeon.Game
  alias BottleDungeon.Game.GameSession

  def index(conn, _params) do
    game_sessions = Game.list_user_game_sessions(user(conn))
    render(conn, "index.html", game_sessions: game_sessions)
  end

  def new(conn, _params) do
    changeset = Game.change_game_session(%GameSession{})
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

  def show(conn, %{"id" => id}) do
    game_session = Game.get_user_game_session!(user(conn), id)
    render(conn, "show.html", game_session: game_session)
  end

  def edit(conn, %{"id" => id}) do
    game_session = Game.get_user_game_session!(user(conn), id)
    changeset = Game.change_game_session(game_session)
    render(conn, "edit.html", game_session: game_session, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game_session" => game_session_params}) do
    game_session = Game.get_user_game_session!(user(conn), id)

    case Game.update_game_session(game_session, game_session_params) do
      {:ok, game_session} ->
        conn
        |> put_flash(:info, "Game session updated successfully.")
        |> redirect(to: Routes.game_session_path(conn, :show, game_session))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game_session: game_session, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game_session = Game.get_game_session!(id)
    {:ok, _game_session} = Game.delete_game_session(game_session)

    conn
    |> put_flash(:info, "Game session deleted successfully.")
    |> redirect(to: Routes.game_session_path(conn, :index))
  end

  defp user(conn) do
    conn.assigns.current_user
  end
end

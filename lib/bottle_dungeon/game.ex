defmodule BottleDungeon.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false
  alias BottleDungeon.Repo
  alias BottleDungeon.Accounts
  alias BottleDungeon.Game.GameSession

  @doc """
  Returns the list of game_sessions.

  ## Examples

      iex> list_game_sessions()
      [%GameSession{}, ...]

  """
  def list_game_sessions do
    Repo.all(GameSession)
  end

  def list_user_game_sessions(%Accounts.User{} = user) do
    GameSession
    |> user_game_sessions_query(user)
    |> Repo.all()
  end

  def get_user_game_session(%Accounts.User{} = user, id) do
    from(gs in GameSession, where: gs.id == ^id)
    |> user_game_sessions_query(user)
    |> Repo.one()
  end

  defp user_game_sessions_query(query, %Accounts.User{id: user_id}) do
    from(gs in query, where: gs.user_id == ^user_id)
  end

  @doc """
  Gets a single game_session.

  Raises `Ecto.NoResultsError` if the Game session does not exist.

  ## Examples

      iex> get_game_session!(123)
      %GameSession{}

      iex> get_game_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game_session!(id), do: Repo.get!(GameSession, id)

  @doc """
  Creates a game_session.

  ## Examples

      iex> create_game_session(%Accounts.User{}, %{field: value})
      {:ok, %GameSession{}}

      iex> create_game_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game_session(%Accounts.User{} = user, attrs \\ %{}) do
    %GameSession{}
    |> GameSession.changeset(attrs)
    |> put_user(user)
    |> Repo.insert()
  end

  @doc """
  Updates a game_session.

  ## Examples

      iex> update_game_session(game_session, %{field: new_value})
      {:ok, %GameSession{}}

      iex> update_game_session(game_session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game_session(%GameSession{} = game_session, attrs) do
    game_session
    |> GameSession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a GameSession.

  ## Examples

      iex> delete_game_session(game_session)
      {:ok, %GameSession{}}

      iex> delete_game_session(game_session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game_session(%GameSession{} = game_session) do
    Repo.delete(game_session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game_session changes.

  ## Examples

      iex> change_game_session(game_session)
      %Ecto.Changeset{source: %GameSession{}}

  """
  def change_game_session(%GameSession{} = game_session \\ %GameSession{}) do
    game_session
    |> GameSession.changeset(%{})
  end

  def count_game_sessions() do
    from(p in "game_sessions", select: count(p.id))
    |> Repo.one
  end

  defp put_user(changeset, user) do
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end

  defp preload_user(game_session_or_sessions) do
    Repo.preload(game_session_or_sessions, :user)
  end
end

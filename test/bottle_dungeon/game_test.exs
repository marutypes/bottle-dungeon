defmodule BottleDungeon.GameTest do
  use BottleDungeon.DataCase

  alias BottleDungeon.Game

  describe "game_sessions" do
    alias BottleDungeon.Game.GameSession

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def game_session_fixture(attrs \\ %{}) do
      {:ok, game_session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_game_session()

      game_session
    end

    test "list_game_sessions/0 returns all game_sessions" do
      game_session = game_session_fixture()
      assert Game.list_game_sessions() == [game_session]
    end

    test "get_game_session!/1 returns the game_session with given id" do
      game_session = game_session_fixture()
      assert Game.get_game_session!(game_session.id) == game_session
    end

    test "create_game_session/1 with valid data creates a game_session" do
      assert {:ok, %GameSession{} = game_session} = Game.create_game_session(@valid_attrs)
      assert game_session.description == "some description"
      assert game_session.title == "some title"
    end

    test "create_game_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_game_session(@invalid_attrs)
    end

    test "update_game_session/2 with valid data updates the game_session" do
      game_session = game_session_fixture()
      assert {:ok, %GameSession{} = game_session} = Game.update_game_session(game_session, @update_attrs)
      assert game_session.description == "some updated description"
      assert game_session.title == "some updated title"
    end

    test "update_game_session/2 with invalid data returns error changeset" do
      game_session = game_session_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_game_session(game_session, @invalid_attrs)
      assert game_session == Game.get_game_session!(game_session.id)
    end

    test "delete_game_session/1 deletes the game_session" do
      game_session = game_session_fixture()
      assert {:ok, %GameSession{}} = Game.delete_game_session(game_session)
      assert_raise Ecto.NoResultsError, fn -> Game.get_game_session!(game_session.id) end
    end

    test "change_game_session/1 returns a game_session changeset" do
      game_session = game_session_fixture()
      assert %Ecto.Changeset{} = Game.change_game_session(game_session)
    end
  end
end

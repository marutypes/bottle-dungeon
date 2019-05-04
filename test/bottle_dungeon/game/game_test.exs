defmodule BottleDungeon.GameTest do
  use BottleDungeon.DataCase

  alias BottleDungeon.Game

  describe "game_sessions" do
    alias BottleDungeon.Game.GameSession

    @valid_attrs %{description: "desc", title: "title"}
    @invalid_attrs %{description: nil, title: nil}

    test "list_game_sessions/0 returns all the game_sessions" do
      owner = user_fixture()
      %GameSession{id: id1} = game_session_fixture(owner)

      assert [%GameSession{id: ^id1}] = Game.list_game_sessions()
      %GameSession{id: id2} = game_session_fixture(owner)
      assert [%GameSession{id: ^id1}, %GameSession{id: ^id2}] = Game.list_game_sessions()
    end

    test "get_game_session!/1" do
      owner = user_fixture()
      %GameSession{id: id} = game_session_fixture(owner)

      assert %GameSession{id: ^id} = Game.get_game_session!(id)
    end

    test "create_game_session/2 with valid data creates a game_session" do
      owner = user_fixture()

      assert {:ok, %GameSession{} = game_session} = Game.create_game_session(owner, @valid_attrs)
    end

    test "create_game_session/2 with invalid data returns error changeset" do
      owner = user_fixture()

      assert {:error, %Ecto.Changeset{}} = Game.create_game_session(owner, @invalid_attrs)
    end

    test "update_game_session/2 with valid data updates the game_session" do
      owner = user_fixture()
      game_session = game_session_fixture(owner)

      assert {:ok, game} = Game.update_game_session(game_session, %{title: "an updated title"})
      assert %GameSession{} = game
      assert game.title == "an updated title"
    end

    test "update_game_session/2 with invalid data returns error changeset" do
      owner = user_fixture()
      %GameSession{id: id} = game = game_session_fixture(owner)

      assert {:error, %Ecto.Changeset{}} = Game.update_game_session(game, @invalid_attrs)
      assert %GameSession{id: ^id} = Game.get_game_session!(id)
    end

    test "delete_game_session/1 deletes the game_session" do
      owner = user_fixture()
      game = game_session_fixture(owner)
      assert {:ok, %GameSession{}} = Game.delete_game_session(game)
      assert Game.list_game_sessions() == []
    end

    test "change_game_session/1 returns a game_session changeset" do
      owner = user_fixture()
      game = game_session_fixture(owner)
      assert %Ecto.Changeset{} = Game.change_game_session(game)
    end
  end
end

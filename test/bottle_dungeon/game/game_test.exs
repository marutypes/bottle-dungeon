defmodule BottleDungeon.GameTest do
  use BottleDungeon.DataCase

  alias BottleDungeon.Game

  describe "campaigns" do
    alias BottleDungeon.Game.Campaign

    @valid_attrs %{description: "desc", title: "title"}
    @invalid_attrs %{description: nil, title: nil}

    test "list_campaigns/0 returns all the campaigns" do
      owner = user_fixture()
      %Campaign{id: id1} = campaign_fixture(owner)

      assert [%Campaign{id: ^id1}] = Game.list_campaigns()
      %Campaign{id: id2} = campaign_fixture(owner)
      assert [%Campaign{id: ^id1}, %Campaign{id: ^id2}] = Game.list_campaigns()
    end

    test "get_campaign!/1" do
      owner = user_fixture()
      %Campaign{id: id} = campaign_fixture(owner)

      assert %Campaign{id: ^id} = Game.get_campaign!(id)
    end

    test "create_campaign/2 with valid data creates a campaign" do
      owner = user_fixture()

      assert {:ok, %Campaign{} = campaign} = Game.create_campaign(owner, @valid_attrs)
    end

    test "create_campaign/2 with invalid data returns error changeset" do
      owner = user_fixture()

      assert {:error, %Ecto.Changeset{}} = Game.create_campaign(owner, @invalid_attrs)
    end

    test "update_campaign/2 with valid data updates the campaign" do
      owner = user_fixture()
      campaign = campaign_fixture(owner)

      assert {:ok, game} = Game.update_campaign(campaign, %{title: "an updated title"})
      assert %Campaign{} = game
      assert game.title == "an updated title"
    end

    test "update_campaign/2 with invalid data returns error changeset" do
      owner = user_fixture()
      %Campaign{id: id} = game = campaign_fixture(owner)

      assert {:error, %Ecto.Changeset{}} = Game.update_campaign(game, @invalid_attrs)
      assert %Campaign{id: ^id} = Game.get_campaign!(id)
    end

    test "delete_campaign/1 deletes the campaign" do
      owner = user_fixture()
      game = campaign_fixture(owner)
      assert {:ok, %Campaign{}} = Game.delete_campaign(game)
      assert Game.list_campaigns() == []
    end

    test "change_campaign/1 returns a campaign changeset" do
      owner = user_fixture()
      game = campaign_fixture(owner)
      assert %Ecto.Changeset{} = Game.change_campaign(game)
    end
  end
end

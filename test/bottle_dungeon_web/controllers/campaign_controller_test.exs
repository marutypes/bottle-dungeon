defmodule BottleDungeonWeb.CampaignControllerTest do
  use BottleDungeonWeb.ConnCase
  alias BottleDungeon.Game

  describe "with a logged in user" do
    setup %{conn: conn, login_as: username} do
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    end

    @tag login_as: "mallen"
    test "lists all user's game sessions on the index", %{conn: conn, user: user} do
      user_campaign = campaign_fixture(user, title: "The Restless Season")
      other_user = user_fixture(username: "someone else")
      other_campaign = campaign_fixture(other_user, title: "Blades in the ARC")

      conn = get conn, Routes.campaign_path(conn, :index)
      assert String.contains?(conn.resp_body, user_campaign.title)
      refute String.contains?(conn.resp_body, other_campaign.title)
    end

    @create_attrs %{title: "Radical Game", description: "It is cool as heck"}
    @invalid_attrs %{}

    @tag login_as: "Kokusho"
    test "creates user campaign and redirects", %{conn: conn, user: user} do
      create_conn = post conn, Routes.campaign_path(conn, :create), campaign: @create_attrs

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.campaign_path(create_conn, :show, id)

      conn = get conn, Routes.campaign_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Radical Game"
      assert Game.get_campaign!(id).user_id == user.id
    end

    @tag login_as: "Catherine"
    test "does not create campaign and renders errors when invalid", %{conn: conn} do
      count_before = campaign_count()
      conn = post conn, Routes.campaign_path(conn, :create), campaign: @invalid_attrs
      assert html_response(conn, 200) =~ "check the errors"
      assert campaign_count() == count_before
    end
  end

  test "authorizes actions against access by other users", %{conn: conn} do
    owner = user_fixture(username: "owner")
    campaign = campaign_fixture(owner, @create_attrs)
    non_owner = user_fixture(username: "sneaky")
    conn = assign(conn, :current_user, non_owner)

    Enum.each([
      get(conn, Routes.campaign_path(conn, :show, campaign)),
      get(conn, Routes.campaign_path(conn, :edit, campaign)),
      put(conn, Routes.campaign_path(conn, :update, campaign, @create_attrs)),
      delete(conn, Routes.campaign_path(conn, :delete, campaign))
    ], fn result ->
      assert result.status == 404
    end)
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.campaign_path(conn, :new)),
      get(conn, Routes.campaign_path(conn, :index)),
      get(conn, Routes.campaign_path(conn, :show, "123")),
      get(conn, Routes.campaign_path(conn, :update, "123", %{})),
      get(conn, Routes.campaign_path(conn, :create, %{})),
      get(conn, Routes.campaign_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end

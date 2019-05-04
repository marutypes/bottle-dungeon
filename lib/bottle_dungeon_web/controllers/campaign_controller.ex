defmodule BottleDungeonWeb.CampaignController do
  use BottleDungeonWeb, :controller

  alias BottleDungeon.Game

  plug :hide_if_not_owner when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    campaigns = Game.list_user_campaigns(user(conn))
    render(conn, "index.html", campaigns: campaigns)
  end

  def new(conn, _params) do
    changeset = Game.change_campaign()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"campaign" => campaign_params}) do
    case Game.create_campaign(user(conn), campaign_params) do
      {:ok, campaign} ->
        conn
        |> put_flash(:info, "Game session created successfully.")
        |> redirect(to: Routes.campaign_path(conn, :show, campaign))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    campaign = conn.assigns[:campaign]
    render(conn, "show.html", campaign: campaign)
  end

  def edit(conn, _params) do
    campaign = conn.assigns[:campaign]
    changeset = Game.change_campaign(campaign)
    render(conn, "edit.html", campaign: campaign, changeset: changeset)
  end

  def update(conn, %{"campaign" => campaign_params}) do
    current_campaign = conn.assigns[:campaign]

    case Game.update_campaign(current_campaign, campaign_params) do
      {:ok, campaign} ->
        conn
        |> put_flash(:info, "Game session updated successfully.")
        |> redirect(to: Routes.campaign_path(conn, :show, campaign))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", campaign: current_campaign, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    campaign = conn.assigns[:campaign]
    {:ok, _campaign} = Game.delete_campaign(campaign)

    conn
    |> put_flash(:info, "Game session deleted successfully.")
    |> redirect(to: Routes.campaign_path(conn, :index))
  end

  defp user(conn) do
    conn.assigns.current_user
  end

  def hide_if_not_owner(conn, _options) do
    id = conn.path_params["id"]
    campaign = id && Game.get_user_campaign(user(conn), id)

    if is_nil(campaign) do
      conn
      |> put_status(:not_found)
      |> put_view(BottleDungeonWeb.ErrorView)
      |> render("404.html")
      |> halt()
    else
      assign(conn, :campaign, campaign)
    end
  end
end

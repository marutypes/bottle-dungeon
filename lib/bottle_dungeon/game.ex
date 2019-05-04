defmodule BottleDungeon.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false
  alias BottleDungeon.Repo
  alias BottleDungeon.Accounts
  alias BottleDungeon.Game.Campaign

  @doc """
  Returns the list of campaigns.

  ## Examples

      iex> list_campaigns()
      [%Campaign{}, ...]

  """
  def list_campaigns do
    Repo.all(Campaign)
  end

  def list_user_campaigns(%Accounts.User{} = user) do
    Campaign
    |> user_campaigns_query(user)
    |> Repo.all()
  end

  def get_user_campaign(%Accounts.User{} = user, id) do
    from(gs in Campaign, where: gs.id == ^id)
    |> user_campaigns_query(user)
    |> Repo.one()
  end

  defp user_campaigns_query(query, %Accounts.User{id: user_id}) do
    from(gs in query, where: gs.user_id == ^user_id)
  end

  @doc """
  Gets a single campaign.

  Raises `Ecto.NoResultsError` if the Game session does not exist.

  ## Examples

      iex> get_campaign!(123)
      %Campaign{}

      iex> get_campaign!(456)
      ** (Ecto.NoResultsError)

  """
  def get_campaign!(id), do: Repo.get!(Campaign, id)

  @doc """
  Creates a campaign.

  ## Examples

      iex> create_campaign(%Accounts.User{}, %{field: value})
      {:ok, %Campaign{}}

      iex> create_campaign(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_campaign(%Accounts.User{} = user, attrs \\ %{}) do
    %Campaign{}
    |> Campaign.changeset(attrs)
    |> put_user(user)
    |> Repo.insert()
  end

  @doc """
  Updates a campaign.

  ## Examples

      iex> update_campaign(campaign, %{field: new_value})
      {:ok, %Campaign{}}

      iex> update_campaign(campaign, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_campaign(%Campaign{} = campaign, attrs) do
    campaign
    |> Campaign.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Campaign.

  ## Examples

      iex> delete_campaign(campaign)
      {:ok, %Campaign{}}

      iex> delete_campaign(campaign)
      {:error, %Ecto.Changeset{}}

  """
  def delete_campaign(%Campaign{} = campaign) do
    Repo.delete(campaign)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking campaign changes.

  ## Examples

      iex> change_campaign(campaign)
      %Ecto.Changeset{source: %Campaign{}}

  """
  def change_campaign(%Campaign{} = campaign \\ %Campaign{}) do
    campaign
    |> Campaign.changeset(%{})
  end

  def count_campaigns() do
    from(p in "campaigns", select: count(p.id))
    |> Repo.one
  end

  defp put_user(changeset, user) do
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end

  defp preload_user(campaign_or_sessions) do
    Repo.preload(campaign_or_sessions, :user)
  end
end

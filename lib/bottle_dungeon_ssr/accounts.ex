defmodule BottleDungeon.Accounts do
  @moduledoc """
    The Accounts context.
  """

  alias BottleDungeon.Accounts.User

  def list_users do
    [
      %User{id: "1", username: "mallen"},
      %User{id: "1", username: "kokes"},
      %User{id: "1", username: "catherine"}
    ]
  end

  def get_user(id) do
    Enum.find(list_users(), fn map -> map.id == id end)
  end

  def get_user_by(params) do
    Enum.find(list_users(), fn map ->
      Enum.all?(params, fn {key, val} ->
        Map.get(map, key) == val
      end)
    end)
  end
end

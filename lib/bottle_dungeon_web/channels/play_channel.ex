defmodule BottleDungeonWeb.PlayChannel do
  use BottleDungeonWeb, :channel

  def join("play:" <> game_id, _params, socket) do
    {:ok, assign(socket, :game_id, String.to_integer(game_id))}
  end

  def handle_in("new_message", params, socket) do
    broadcast!(socket, "new_message", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    })
    {:reply, :ok, socket}
  end
end

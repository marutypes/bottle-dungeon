defmodule BottleDungeon.InlineSvgCache do
  use GenServer

  alias PhoenixInlineSvg.Helpers

  #
  # Client API
  #

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def svg_image(conn, svg) do
    svg_image(conn, svg, nil, [])
  end

  def svg_image(conn, svg, options) do
    svg_image(conn, svg, nil, options)
  end

  def svg_image(conn, svg, collection, options \\ []) do
    svg_name = "#{collection}/#{svg}"
    case lookup(svg_name) do
      {:ok, data} ->
        data
      {:error} ->
        data =
          if collection != nil do
            Helpers.svg_image(conn, svg, collection, options)
          else
            Helpers.svg_image(conn, svg, options)
          end
        insert(svg_name, data)
        data
    end
  end

  def lookup(name) do
    GenServer.call(__MODULE__, {:lookup, name})
  end

  def insert(name, data) do
    GenServer.cast(__MODULE__, {:insert, name, data})
  end

  #
  # Server API
  #

  def init(_) do
    :ets.new(:svg_image, [:named_table, read_concurrency: true])
    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, state) do
    data =
      case :ets.lookup(:svg_image, name) do
        [{^name, data}] -> {:ok, data}
        [] -> {:error}
      end
    {:reply, data, state}
  end

  def handle_cast({:insert, name, data}, state) do
    :ets.insert(:svg_image, {name, data})
    {:noreply, state}
  end
end

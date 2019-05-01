defmodule BottleDungeonWeb.GameSessionView do
  use BottleDungeonWeb, :view
  use PhoenixHtmlSanitizer, :basic_html

  def markdown(md) do
    md
    |> Earmark.as_html!()
    |> sanitize_md()
    |> raw()
  end

  defp sanitize_md(md) do
    {:safe, sanitized_md} = sanitize(md)

    sanitized_md
  end
end

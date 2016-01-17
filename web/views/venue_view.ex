defmodule Stackfooter.VenueView do
  use Stackfooter.Web, :view

  def render("heartbeat.json", %{venue: venue}) do
    %{ok: true, venue: venue}
  end

  def render("stocks.json", %{tickers: tickers}) do
    symbols =
      tickers
      |> Enum.map(fn ticker ->
         %{name: ticker.name, symbol: ticker.symbol}
      end)

    %{ok: true, symbols: symbols}
  end
end

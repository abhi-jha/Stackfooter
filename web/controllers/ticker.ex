defmodule Stackfooter.TickerController do
  use Stackfooter.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

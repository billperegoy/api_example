defmodule ApiExample.PageController do
  use ApiExample.Web, :controller

  def index(conn, _params) do
    conn
      |> put_layout(false)
      |> render("index.html")
  end
end

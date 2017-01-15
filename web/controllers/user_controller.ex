defmodule ApiExample.UserController do
  use ApiExample.Web, :controller

  def index(conn, _params) do
    users = [
      %{name: "Joe",
        email: "joe@example.com",
        password: "topsecret",
        stooge: "moe"},

      %{name: "Anne",
        email: "anne@example.com",
        password: "guessme",
        stooge: "larry"},

      %{name: "Franklin",
        email: "franklin@example.com",
        password: "guessme",
        stooge: "curly"},

    ]

    json conn, users
  end
end

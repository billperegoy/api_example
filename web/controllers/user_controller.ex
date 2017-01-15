defmodule ApiExample.UserController do
  use ApiExample.Web, :controller

  def index(conn, _params) do
    users = Repo.all(ApiExample.User)

    json conn, users
  end
end

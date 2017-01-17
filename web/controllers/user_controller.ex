defmodule ApiExample.UserController do
  use ApiExample.Web, :controller

  def index(conn, _params) do
    users = Repo.all(ApiExample.User)

    json conn, users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(ApiExample.User, String.to_integer(id))

    json conn, user
  end
end

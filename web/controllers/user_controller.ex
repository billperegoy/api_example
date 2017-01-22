defmodule ApiExample.UserController do
  use ApiExample.Web, :controller

  def index(conn, _params) do
    users = Repo.all(ApiExample.User)

    json conn_with_status(conn, users), users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(ApiExample.User, String.to_integer(id))

    json conn_with_status(conn, user), user
  end

  def create(conn, params) do
    changeset = ApiExample.User.changeset(%ApiExample.User{}, params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        json conn |> put_status(:created), user
      {:error, _changeset} ->
        json conn |> put_status(:bad_request), %{error: "Bad post"}
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = Repo.get(ApiExample.User, id)
    if user do
      changeset = ApiExample.User.changeset(user, params)
      case Repo.update(changeset) do
        {:ok, user} ->
          json conn |> put_status(:ok), user
        {:error, result} ->
          json conn |> put_status(:bad_request), %{error: "bad update"}
      end
    else
      json conn |> put_status(:not_found), %{error: "invalid user"}
    end
  end

  defp conn_with_status(conn, nil) do
    conn
      |> put_status(:not_found)
  end

  defp conn_with_status(conn, _) do
    conn
      |> put_status(:ok)
  end
end

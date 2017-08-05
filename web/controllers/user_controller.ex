defmodule ApiExample.UserController do
  use ApiExample.Web, :controller

  def index(conn, _params) do
    query = from u in ApiExample.User, order_by: u.id
    users = Repo.all(query)

    IO.inspect(users)
    json conn_with_status(conn, users), format_api_response(users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(ApiExample.User, String.to_integer(id))

    json conn_with_status(conn, user), user
  end

  def create(conn, params) do
    changeset = ApiExample.User.changeset(%ApiExample.User{}, params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        json conn |> put_status(:created), format_api_response(user)
      {:error, changeset} ->
        json conn |> put_status(:bad_request), %{errors: format_errors(changeset.errors)}
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = Repo.get(ApiExample.User, id)
    if user do
      perform_update(conn, user, params)
    else
      json conn |> put_status(:not_found), %{errors: ["invalid user"]}
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(ApiExample.User, id)
    if user do
      Repo.delete(user)
      json conn |> put_status(:accepted), format_api_response(user)
    else
      json conn |> put_status(:not_found), %{errors: ["invalid user"]}
    end
  end

  defp format_api_response(data) do
    %{data: data}
  end

  defp format_errors(errors) do
    Enum.map(errors, &format_error(&1))
  end

  # FIXME - This doesn't tell the complete error yet
  defp format_error(error) do
    IO.inspect(error)
    field = elem(error, 0)
    message = elem(error, 1) |> elem(0)
    %{field => message}
  end

  defp perform_update(conn, user, params) do
    changeset = ApiExample.User.changeset(user, params)
    case Repo.update(changeset) do
      {:ok, user} ->
        json conn |> put_status(:ok), format_api_response(user)
      {:error, changeset} ->
        json conn |> put_status(:bad_request), %{errors: format_errors(changeset.errors)}
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

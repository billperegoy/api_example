defmodule ApiExample.Router do
  use ApiExample.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", ApiExample do
    pipe_through :api

    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
  end
end

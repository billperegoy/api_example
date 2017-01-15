defmodule ApiExample.Repo do
  # use Ecto.Repo, otp_app: :api_example
  def all(ApiExample.User) do
    [
      %ApiExample.User{id: 1,
                       name: "Joe",
                       email: "joe@example.com",
                       password: "topsecret",
                       stooge: "moe"},

      %ApiExample.User{id: 2,
                       name: "Anne",
                       email: "anne@example.com",
                       password: "guessme",
                       stooge: "larry"},

      %ApiExample.User{id: 3,
                       name: "Franklin",
                       email: "franklin@example.com",
                       password: "guessme",
                       stooge: "curly"},

    ]
  end
end

defmodule ApiExample.User do
  use ApiExample.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :age, :integer
    field :password, :string
    field :stooge, :string

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:name, :email, :age, :password, :stooge])
      |> unique_constraint(:email)
  end
end

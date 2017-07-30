defmodule ApiExample.User do
  use ApiExample.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :age, :integer

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
      |> cast(params, [:name, :email, :age])
      |> validate_required(:email)
      |> unique_constraint(:email)
      |> validate_required(:name)
      |> validate_required(:age)
      |> validate_number(:age, greater_than: 10, less_than: 80)
  end
end

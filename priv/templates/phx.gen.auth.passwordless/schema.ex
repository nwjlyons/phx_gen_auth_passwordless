defmodule <%= inspect schema.module %> do
  use Ecto.Schema
  import Ecto.Changeset

  schema <%= inspect schema.table %> do
    field :email, :string

    timestamps()
  end

  def changeset(<%= schema.singular %>, attrs) do
    <%= schema.singular %>
    |> cast(attrs, [:email])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, <%= inspect schema.repo %>)
    |> unique_constraint(:email)
  end
end

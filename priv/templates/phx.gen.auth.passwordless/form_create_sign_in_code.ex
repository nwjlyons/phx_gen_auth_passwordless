defmodule <%= inspect context.web_module %>.CreateSignInCodeForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
  end

  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> update_change(:email, &String.trim/1)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "not a valid email")
    |> validate_length(:email, max: 160)
  end

  def validate(attrs) do
    changeset(attrs)
    |> apply_action(:create_sign_in_code)
  end
end

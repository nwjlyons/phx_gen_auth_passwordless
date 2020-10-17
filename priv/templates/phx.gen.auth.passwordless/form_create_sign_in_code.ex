defmodule <%= inspect context.web_module %>.CheckSignInCodeForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :code, :string
  end

  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:code])
    |> validate_required([:code])
    |> update_change(:code, &String.trim/1)
    |> validate_format(:code, ~r/^\d{6}$/, message: "should be six digits. eg. 000000")
  end

  def validate(attrs) do
    changeset(attrs)
    |> apply_action(:check_sign_in_code)
  end
end

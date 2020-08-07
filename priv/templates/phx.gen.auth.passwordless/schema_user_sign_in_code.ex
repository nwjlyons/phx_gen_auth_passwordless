defmodule <%= inspect schema.module %>SignInCode do
  use Ecto.Schema
  import Ecto.Changeset

  @sign_in_code_length 6
  @sign_in_code_regex Regex.compile!("^\\d{" <> Integer.to_string(@sign_in_code_length) <> "}$")
  @sign_in_code_example Enum.reduce(1..@sign_in_code_length, "", fn _, acc -> acc <> "0" end)

  @derive {Inspect, except: [:code]}<%= if schema.binary_id do %>
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id<% end %>
  schema "<%= schema.table %>_sign_in_codes" do
    field :code, :string, virtual: true
    field :hashed_code, :string
    belongs_to :<%= schema.singular %>, <%= inspect schema.module %>
    field :sign_in_attempts, :integer

    timestamps(updated_at: false)
  end

  @doc false
  def create_changeset(<%= schema.singular %>_sign_in_code, attrs) do
    <%= schema.singular %>_sign_in_code
    |> cast(attrs, [:code, :user_id])
    |> validate_required([:code, :user_id])
    |> validate_code()
    |> maybe_hash_code()
    |> foreign_key_constraint(:user_id)
  end

  def check_changeset(<%= schema.singular %>_sign_in_code, attrs) do
    <%= schema.singular %>_sign_in_code
    |> cast(attrs, [:code])
    |> validate_required([:code])
    |> validate_code()
  end

  def validate_code(%Ecto.Changeset{} = changeset) do
    changeset
    |> validate_format(
      :code, @sign_in_code_regex,
      message: "should be #{@sign_in_code_length} digits. eg. #{@sign_in_code_example}"
    )
  end

  def generate_sign_in_code() do
    Enum.map(1..@sign_in_code_length, fn _ -> Enum.random(0..9) end) |> Enum.join("")
  end

  defp maybe_hash_code(changeset) do
    code = get_change(changeset, :code)

    if code && changeset.valid? do
      put_change(changeset, :hashed_code, Bcrypt.hash_pwd_salt(code))
    else
      changeset
    end
  end

  def valid_code?(%__MODULE__{hashed_code: hashed_code}, code)
      when is_binary(hashed_code) and byte_size(code) == @sign_in_code_length do
    Bcrypt.verify_pass(code, hashed_code)
  end

  def valid_code?(_, _) do
    Bcrypt.no_user_verify()
  end
end

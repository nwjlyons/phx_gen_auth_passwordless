defmodule <%= inspect schema.module %>SignInCode do
  import Ecto.Changeset

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
    |> validate_format(:code, ~r/^\d{6}$/, message: "should be six digits. eg. 000000")
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
      when is_binary(hashed_code) and byte_size(code) == 6 do
    Bcrypt.verify_pass(code, hashed_code)
  end

  def valid_code?(_, _) do
    Bcrypt.no_user_verify()
  end
end

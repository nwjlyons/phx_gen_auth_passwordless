defmodule <%= inspect context.module %> do

  require Logger

  alias <%= inspect schema.repo %>
  alias <%= inspect context.module %>.{<%= inspect schema.alias %>, <%= inspect schema.alias %>SignInCode}

  @max_sign_in_attempts 3
  @lifespan_of_<%= schema.singular %>_sign_in_code_in_minutes 15

  @doc """
  Gets a single <%= schema.singular %>.

  ## Examples

      iex> get_<%= schema.singular %>("123")
      %<%= inspect schema.alias %>{}

      iex> get_<%= schema.singular %>("456")
      nil

  """
  def get_<%= schema.singular %>(id) do
    Repo.get(<%= inspect schema.alias %>, id)
  end

  @doc """
  Gets a <%= schema.singular %> by email.

  ## Examples

      iex> get_<%= schema.singular %>_by_email("foo@example.com")
      %<%= inspect schema.alias %>{}

      iex> get_<%= schema.singular %>_by_email("unknown@example.com")
      nil

  """
  def get_<%= schema.singular %>_by_email(email) do
    Repo.get_by(<%= inspect schema.alias %>, email: email)
  end

  @doc """
  Creates a <%= schema.singular %>.

  ## Examples

      iex> create_<%= schema.singular %>(%{field: value})
      {:ok, %User{}}

      iex> create_<%= schema.singular %>(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_<%= schema.singular %>(attrs \\ %{}) do
    %<%= inspect schema.alias %>{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a <%= schema.singular %>.

  ## Examples

      iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: new_value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> update_<%= schema.singular %>(<%= schema.singular %>, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>, attrs) do
    <%= schema.singular %>
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a <%= schema.singular %>.

  ## Examples

      iex> delete_<%= schema.singular %>(<%= schema.singular %>)
      {:ok, %<%= inspect schema.alias %>{}}

      iex> delete_<%= schema.singular %>(<%= schema.singular %>)
      {:error, %Ecto.Changeset{}}

  """
  def delete_<%= schema.singular %>(%<%= inspect schema.alias %>{} = <%= schema.singular %>) do
    Repo.delete(<%= schema.singular %>)
  end

  @doc """
  Gets a single <%= schema.singular %>_sign_in_code that has not exceeded the lifespan or the number of sign in attempts.

  ## Examples

      iex> get_<%= schema.singular %>_sign_in_code("123")
      %<%= inspect schema.alias %>SignInCode{}

      iex> get_<%= schema.singular %>_sign_in_code("456")
      nil
  """
  def get_<%= schema.singular %>_sign_in_code(id) do
    from(s in <%= inspect schema.alias %>SignInCode,
      where: s.id == ^id,
      where: s.inserted_at >= ago(@lifespan_of_<%= schema.singular %>_sign_in_code_in_minutes, "minute"),
      where: s.sign_in_attempts < @max_sign_in_attempts
    )
    |> Repo.one()
  end

  @doc """
  Creates a <%= schema.singular %>_sign_in_code and notifies the <%= schema.singular %>.

  ## Examples

      iex> create_<%= schema.singular %>_sign_in_code("exists@example.com")
      {:ok, %<%= inspect schema.alias %>SignInCode{}}

      iex> create_<%= schema.singular %>("does-not-exist@example.com")
      {:error, :user_not_found}

  """
  def create_<%= schema.singular %>_sign_in_code_and_notify_<%= schema.singular %>(email) do
    Logger.info("creating <%= schema.singular %> sign in code for email=#{email}")

    case get_<%= schema.singular %>_by_email(email) do
      %<%= inspect schema.alias %>{} = <%= schema.singular %> ->
        case create_<%= schema.singular %>_sign_in_code(<%= schema.singular %>) do
          {:ok, <%= schema.singular %>_sign_in_code} ->
            notify_<%= schema.singular %>_of_sign_in_code(<%= schema.singular %>, <%= schema.singular %>_sign_in_code)
            {:ok, <%= schema.singular %>_sign_in_code}

          {:error, _changeset} ->
            {:error, :not_valid}
        end

      nil ->
        {:error, :user_not_found}
    end
  end

  @doc """
  Check sign in code.

  ## Examples

      iex> check_sign_in_code("123", "000000")
      {:ok, %<%= inspect schema.alias %>SignInCode{}}

      iex> check_sign_in_code("123", "notvalid")
      {:error, :not_valid}

      iex> check_sign_in_code("456", "000000")
      {:error, :not_found_or_expired}
  """
  def check_sign_in_code(code_id, code_from_user) when is_binary(code_from_user) do
    case get_<%= schema.singular %>_sign_in_code(code_id) do
      %<%= inspect schema.alias %>SignInCode{} = <%= schema.singular %>_sign_in_code ->
        increment_sign_in_code_attempts(<%= schema.singular %>_sign_in_code)

        if <%= inspect schema.alias %>SignInCode.valid_code?(<%= schema.singular %>_sign_in_code, code_from_user) do
          delete_<%= schema.singular %>_sign_in_code(<%= schema.singular %>_sign_in_code)
          {:ok, <%= schema.singular %>_sign_in_code}
        else
          {:error, :not_valid}
        end

      nil ->
        mitigate_against_timing_attacks()
        {:error, :not_found_or_expired}
    end
  end

  def get_and_validate_sign_in_code(_code_id, _code), do: {:error, :not_found}

  @doc """
  Increments the number of sign in attempts for <%= schema.singular %>_sign_in_code.

  It returns the number of entries affected.

   ## Examples

      iex> increment_sign_in_attempts("123")
      1

      iex> increment_sign_in_attempts("456")
      0
  """
  def increment_sign_in_attempts(%<%= inspect schema.alias %>SignInCode{} = <%= schema.singular %>_sign_in_code) do
    from(s in <%= inspect schema.alias %>SignInCode,
      where: s.id == ^<%= schema.singular %>_sign_in_code.id
    )
    |> Repo.update_all(inc: [sign_in_attempts: 1])
    |> Tuple.elem(0)
  end

  @doc """
  Deletes a <%= schema.singular %>_sign_in_code.

  ## Examples

      iex> delete_<%= schema.singular %>_sign_in_code(<%= schema.singular %>_sign_in_code)
      {:ok, %<%= inspect schema.alias %>SignInCode{}}

      iex> delete_<%= schema.singular %>_sign_in_code(<%= schema.singular %>_sign_in_code)
      {:error, %Ecto.Changeset{}}

  """
  def delete_<%= schema.singular %>_sign_in_code(%<%= inspect schema.alias %>SignInCode{} = <%= schema.singular %>_sign_in_code) do
    Repo.delete(<%= schema.singular %>_sign_in_code)
  end

  defp create_<%= schema.singular %>_sign_in_code(%<%= inspect schema.alias %>{id: <%= schema.singular %>_id}) do
    %<%= inspect schema.alias %>SignInCode{}
    |> <%= inspect schema.alias %>SignInCode.create_changeset(%{user_id: user_id, code: <%= inspect schema.alias %>SignInCode.generate_sign_in_code()})
    |> Repo.insert()
  end

  defp mitigate_against_timing_attacks() do
    # Simulate work to mitigate against timing attacks.
    Bcrypt.no_user_verify()
  end

  defp notify_<%= schema.singular %>_of_sign_in_code(<%= schema.singular %>, code) do
    # For simplicity, this function simply logs messages to the terminal.
    # You should replace it by a proper e-mail or notification tool, such as:
    #
    #   * Swoosh - https://hexdocs.pm/swoosh
    #   * Bamboo - https://hexdocs.pm/bamboo
    #
    Logger.debug("""
    To: #{<%= schema.singular %>.email}
    Subject: Sign in code: #{code}

    Sign in code: #{code}
    """)
  end
end

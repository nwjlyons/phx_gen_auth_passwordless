defmodule <%= inspect context.module %> do

  alias <%= inspect schema.repo %>
  alias <%= inspect context.module %>.{<%= inspect schema.alias %>, <%= inspect schema.alias %>SignInCode}

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
  def get_<%= schema.singular %>_by_email(email) when is_binary(email) do
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
end

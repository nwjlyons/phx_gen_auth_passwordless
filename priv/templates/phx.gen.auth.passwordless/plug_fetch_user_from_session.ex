defmodule <%= inspect context.web_module %>.Auth.Plugs.FetchUserFromSession do
  @behaviour Plug
  import Plug.Conn
  alias <%= inspect context.module %>
  alias <%= inspect context.web_module %>.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, user_id} <- Auth.fetch_user_id(conn),
         %User{} = user <- <%= inspect context.alias %>.get_user(user_id) do
      assign(conn, :user, user)
    else
      _error ->
        assign(conn, :user, nil)
    end
  end
end

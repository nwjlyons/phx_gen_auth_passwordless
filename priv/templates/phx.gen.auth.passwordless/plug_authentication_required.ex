defmodule <%= inspect context.web_module %>.Auth.Plugs.AuthenticationRequired do
  @behaviour Plug
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn, only: [halt: 1]

  alias <%= inspect context.web_module %>.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if <%= inspect context.web_module %>.Auth.anonymous?(conn) do
      conn
      |> put_flash(:info, "You must sign in to access this page.")
      |> redirect(to: Routes.sign_in_code_path(conn, :create))
      |> halt()
    else
      conn
    end
  end
end

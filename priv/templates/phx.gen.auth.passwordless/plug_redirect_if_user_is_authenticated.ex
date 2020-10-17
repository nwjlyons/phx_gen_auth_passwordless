defmodule <%= inspect context.web_module %>.Auth.Plugs.RedirectIfUserIsAuthenticated do
  @behaviour Plug
  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [halt: 1]

  def init(opts), do: opts

  def call(conn, _opts) do
    if <%= inspect context.web_module %>.Auth.authenticated?(conn) do
      conn
      |> redirect(to: "/")
      |> halt()
    else
      conn
    end
  end
end

defmodule <%= inspect context.web_module %>.Auth do
  import Plug.Conn
  require Logger

  @key :user_id

  def sign_in(%Plug.Conn{} = conn, user_id) when is_binary(user_id) do
    Logger.info("sign in user user_id=#{user_id}")

    conn
    |> renew_session()
    |> put_session(@key, user_id)
  end

  def sign_out(%Plug.Conn{} = conn) do
    Logger.info("sign out user user_id=#{get_user_id(conn)}")

    conn
    |> renew_session()
  end

  def authenticated?(conn) do
    !!get_user_id(conn)
  end

  def anonymous?(conn) do
    !authenticated?(conn)
  end

  def get_user_id(%Plug.Conn{} = conn) do
    get_session(conn, @key)
  end

  def fetch_user_id(%Plug.Conn{} = conn) do
    if user_id = get_user_id(conn) do
      {:ok, user_id}
    else
      :error
    end
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end

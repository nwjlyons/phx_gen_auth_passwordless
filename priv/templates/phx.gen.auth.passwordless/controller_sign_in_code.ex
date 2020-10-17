defmodule <%= inspect context.web_module %>.SignInCodeController do
  use <%= inspect context.web_module %>, :controller

  require Logger

  alias RedSnow.SignInCodes
  alias RedSnowWeb.Auth
  alias <%= inspect context.web_module %>.CheckSignInCodeForm
  alias <%= inspect context.web_module %>.CreateSignInCodeForm

  plug RedSnowWeb.Auth.Plugs.RedirectIfUserIsAuthenticated

  def create(%{method: "GET"} = conn, _params) do
    changeset = CreateSignInCodeForm.changeset()
    render(conn, "create.html", changeset: changeset)
  end

  def create(%{method: "POST"} = conn, %{"sign_in_code" => sign_in_code_params}) do
    case CreateSignInCodeForm.validate(sign_in_code_params) do
      {:ok, create_sign_in_code_form} ->
        case SignInCodes.create_sign_in_code(create_sign_in_code_form.email) do
          {:ok, sign_in_code} ->
            conn
            |> put_session(:sign_in_code_id, sign_in_code.id)
            |> redirect(to: Routes.sign_in_code_path(conn, :check))

          {:error, _reason} ->
            # Avoid leaking which users are in the system. Act like sign in code was sent.
            conn
            |> put_session(:sign_in_code_id, nil)
            |> redirect(to: Routes.sign_in_code_path(conn, :check))
        end

      {:error, changeset} ->
        render(conn, "create.html", changeset: changeset)
    end
  end

  def check(%{method: "GET"} = conn, _params) do
    changeset = CheckSignInCodeForm.changeset()
    render(conn, "check.html", changeset: changeset)
  end

  def check(%{method: "POST"} = conn, %{"sign_in_code" => sign_in_code_params}) do
    case CheckSignInCodeForm.validate(sign_in_code_params) do
      {:ok, create_sign_in_code_form} ->
        case SignInCodes.get_and_validate_sign_in_code(
               get_session(conn, :sign_in_code_id),
               create_sign_in_code_form.code
             ) do
          {:ok, sign_in_code} ->
            conn
            |> Auth.sign_in(sign_in_code.user_id)
            |> redirect(to: Routes.page_index_path(conn, :index))

          {:error, reason} ->
            Logger.debug("sign in check failed: #{inspect(reason)}")

            changeset =
              CheckSignInCodeForm.changeset(Map.from_struct(create_sign_in_code_form))
              |> Ecto.Changeset.add_error(:code, gettext("invalid or expired"))
              |> Map.put(:action, :check_sign_in_code)

            render(conn, "check.html", changeset: changeset)
        end

      {:error, changeset} ->
        render(conn, "check.html", changeset: changeset)
    end
  end
end

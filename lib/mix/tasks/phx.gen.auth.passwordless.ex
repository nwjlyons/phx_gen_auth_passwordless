defmodule Mix.Tasks.Phx.Gen.Auth.Passwordless do
  @shortdoc "Generates passwordless authentication logic for a resource"

  @moduledoc """
  Generates passwordless authentication logic for a resource.

      mix phx.gen.auth.passwordless Accounts User users

  The first argument is the context module followed by the schema module
  and its plural name (used as the schema table name).

  ## Binary ids

  The `--binary-id` option causes the generated migration to use
  `binary_id` for its primary key and foreign keys.
  """

  use Mix.Task
  alias Mix.Phoenix.{Context, Schema}
  alias Mix.Tasks.Phx.Gen

  def run(args) do
    {context, schema} = Gen.Context.build(args, __MODULE__)

    Gen.Context.prompt_for_code_injection(context)

    binding = [context: context, schema: schema]

    paths = [".", :phx_gen_auth_passwordless, :phoenix]

    context
    |> copy_new_files(binding, paths)
  end

  defp copy_new_files(%Context{} = context, binding, paths) do
    files = files_to_be_generated(context)
    Mix.Phoenix.copy_from(paths, "priv/templates/phx.gen.auth.passwordless", binding, files)

    context
  end

  defp files_to_be_generated(%Context{schema: schema, context_app: context_app} = context) do
    web_prefix = Mix.Phoenix.web_path(context_app)
    web_test_prefix = Mix.Phoenix.web_test_path(context_app)
    migrations_prefix = Mix.Phoenix.context_app_path(context_app, "priv/repo/migrations")
    web_path = to_string(schema.web_path)

    IO.inspect(context)

    [
      {:eex, "schema_user.ex", Path.join([context.dir, "#{schema.singular}.ex"])},
      {:eex, "schema_user_sign_in_code.ex", Path.join([context.dir, "#{schema.singular}_sign_in_code.ex"])},
      {:eex, "controller_sign_in_code.ex", Path.join([web_prefix, "controllers", "sign_in_code_controller.ex"])},
      {:eex, "form_create_sign_in_code.ex", Path.join([web_prefix, "forms", "create_sign_in_code_form.ex"])},
      {:eex, "form_check_sign_in_code.ex", Path.join([web_prefix, "forms", "check_sign_in_code_form.ex"])},
      {:eex, "view_sign_in_code.ex", Path.join([web_prefix, "views", "sign_in_code_view.ex"])},
      {:text, "template_create.ex", Path.join([web_prefix, "templates", "sign_in_code", "create.html.eex"])},
      {:text, "template_check.ex", Path.join([web_prefix, "templates", "sign_in_code", "check.html.eex"])},
      {:eex, "context.ex", "#{context.dir}.ex"},
      {:eex, "migration.ex", Path.join([migrations_prefix, "#{timestamp()}_create_#{schema.table}_auth_tables.exs"])},
    ]
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)
end

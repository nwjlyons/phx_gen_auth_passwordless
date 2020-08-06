defmodule Mix.Tasks.Phx.Gen.Auth.Passwordless do
  @shortdoc "Generates passwordless authentication logic for a resource"

  use Mix.Task
  alias Mix.Phoenix.{Context, Schema}
  alias Mix.Tasks.Phx.Gen

  def run(args) do
    {context, schema} = Gen.Context.build(args, __MODULE__)

    Gen.Context.prompt_for_code_injection(context)

    binding = [context: context, schema: schema]

    paths = generator_paths()

    context
    |> copy_new_files(binding, paths)
  end

  defp files_to_be_generated(%Context{schema: schema, context_app: context_app} = context) do
    web_prefix = Mix.Phoenix.web_path(context_app)
    web_test_prefix = Mix.Phoenix.web_test_path(context_app)
    migrations_prefix = Mix.Phoenix.context_app_path(context_app, "priv/repo/migrations")
    web_path = to_string(schema.web_path)

    [
      {:eex, "schema.ex", Path.join([context.dir, "#{schema.singular}.ex"])},
    ]
  end

  defp copy_new_files(%Context{} = context, binding, paths) do
    files = files_to_be_generated(context)
    Mix.Phoenix.copy_from(paths, "priv/templates/phx.gen.auth.passwordless", binding, files)

    context
  end

  defp generator_paths do
    [".", :phx_gen_auth_passwordless, :phoenix]
  end
end

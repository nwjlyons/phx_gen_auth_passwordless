defmodule <%= inspect schema.repo %>.Migrations.Create<%= Macro.camelize(schema.table) %>AuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:<%= schema.table %><%= if schema.binary_id do %>, primary_key: false<% end %>) do
<%= if schema.binary_id do %>      add :id, :binary_id, primary_key: true<% end %>
      add :email, :citext, null: false

      timestamps()
    end

    create unique_index(:<%= schema.table %>, [:email])

    create table(:<%= schema.table %>_sign_in_codes<%= if schema.binary_id do %>, primary_key: false<% end %>) do
<%= if schema.binary_id do %>      add :id, :binary_id, primary_key: true<% end %>
      add :hashed_code, :string, null: false
      add :user_id, references(:users, <%= if schema.binary_id do %>type: :binary_id, <% end %>on_delete: :delete_all), null: false
      add :sign_in_attempts, :integer, null: false, default: 0

      timestamps(updated_at: false)
    end
  end
end

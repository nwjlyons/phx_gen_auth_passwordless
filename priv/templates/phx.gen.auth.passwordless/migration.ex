defmodule <%= inspect schema.repo %>.Migrations.Create<%= Macro.camelize(schema.table) %>AuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:<%= schema.table %>) do
      add :email, :citext

      timestamps()
    end

    create unique_index(:<%= schema.table %>, [:email])

    create table(:<%= schema.table %>_sign_in_codes) do
      add :hashed_code, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :sign_in_attempts, :integer, null: false, default: 0


      timestamps(updated_at: false)
    end
  end
end

defmodule <%= inspect schema.repo %>.Migrations.Create<%= Macro.camelize(schema.table) %>AuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext

      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_sign_in_codes) do
      add :hashed_code, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :sign_in_attempts, :integer, null: false, default: 0


      timestamps(updated_at: false)
    end
  end
end

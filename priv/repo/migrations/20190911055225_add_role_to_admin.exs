defmodule IprApi.Repo.Migrations.AddRoleToAdmin do
  use Ecto.Migration

  def up do
    alter table("admin") do
      add :id_peranan, references(:peranan, on_delete: :delete_all)
      add :id_agensi, references(:agensi, on_delete: :delete_all)
    end
  end

  def down do
    alter table("admin") do
      remove :id_peranan, references(:peranan, on_delete: :delete_all)
      remove :id_agensi, references(:agensi, on_delete: :delete_all)
    end
  end
end

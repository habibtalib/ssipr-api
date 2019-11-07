defmodule IprApi.Repo.Migrations.AddAgensiToProgram do
  use Ecto.Migration

  def up do
    alter table("program") do
      add :id_agensi, references(:agensi, on_delete: :delete_all)
    end
  end

  def down do
    alter table("program") do
      remove :id_agensi, references(:agensi, on_delete: :delete_all)
    end
  end
end

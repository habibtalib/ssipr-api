defmodule IprApi.Repo.Migrations.AlterAdminTable do
  use Ecto.Migration

  def change do
    alter table(:admin) do
      remove :id
      add :id_admin, :string, primary_key: true
      add :jawatan, :string
      add :jenis_admin, :string
      add :ic, :string
    end

    create unique_index(:admin, [:id_admin])
    create unique_index(:admin, [:ic])
  end
end

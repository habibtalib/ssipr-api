defmodule IprApi.Repo.Migrations.RemoveJadInAdminTable do
  use Ecto.Migration

  def change do
    alter table(:admin) do
      remove :jenis_admin
    end
  end
end

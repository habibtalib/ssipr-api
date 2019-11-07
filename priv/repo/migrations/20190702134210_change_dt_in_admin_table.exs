defmodule IprApi.Repo.Migrations.ChangeDtInAdminTable do
  use Ecto.Migration

  def change do
    alter table(:admin) do
      add :jenis_admin, :integer
    end
  end
end

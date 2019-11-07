defmodule IprApi.Repo.Migrations.AddStatusToDoketPermohonan do
  use Ecto.Migration

  def change do
    alter table("doket_permohonan") do
      add :status, :integer
      add :oleh_admin, :boolean
    end
  end
end

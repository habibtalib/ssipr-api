defmodule IprApi.Repo.Migrations.AddJsondataToDoketPermohonan do
  use Ecto.Migration

  def up do
    alter table("doket_permohonan") do
      add :data, :map, default: "{}"
    end
  end

  def down do
    alter table("doket_permohonan") do
      remove :data, :map, default: "{}"
    end
  end
end

defmodule IprApi.Repo.Migrations.AddExtraFieldsToPasanganTable do
  use Ecto.Migration

  def change do
    alter table("pasangan") do
      add :emel, :string
      add :no_tele, :string 
    end
  end
end

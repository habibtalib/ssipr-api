defmodule IprApi.Repo.Migrations.AddOthersFieldToProfil do
  use Ecto.Migration

  def change do
    alter table("profil") do
      add :daerah_lain, :string
      add :agama_lain, :string
      add :tahap_pendidikan, :string
      add :tahap_pendidikan_lain, :string
    end
  end
end

defmodule IprApi.Repo.Migrations.AddLengkapToProfilTable do
  use Ecto.Migration

  def change do
    alter table("profil") do
      add :profil_lengkap, :boolean
      add :jenis_rumah_pangsapuri, :boolean
      add :status_perkahwinan, :string
    end
  end
end

defmodule IprApi.Repo.Migrations.AddPengesahanAkaunToProfilTable do
  use Ecto.Migration

  def change do
    alter table("profil") do
      add :akaun_sah, :boolean
      add :oleh_admin, :boolean
      add :jenis_ic, :integer
    end
  end
end

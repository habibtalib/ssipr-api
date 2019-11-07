defmodule IprApi.Repo.Migrations.ChangePhoneDtInProfilTable do
  use Ecto.Migration

  def change do
    alter table("profil") do
      modify :tele_rumah, :string
      modify :tele_bimbit, :string
    end
  end
end

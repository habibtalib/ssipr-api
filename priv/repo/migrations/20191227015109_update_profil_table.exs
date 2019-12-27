defmodule IprApi.Repo.Migrations.UpdateProfilTable do
  use Ecto.Migration

  def change do
     create unique_index(:profil, [:tele_bimbit], where: "inserted_at > '2019-12-28 01:39:31'")
  end
end

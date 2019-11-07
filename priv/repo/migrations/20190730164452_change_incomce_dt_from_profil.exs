defmodule IprApi.Repo.Migrations.ChangeIncomceDtFromProfil do
  use Ecto.Migration

  def change do
    alter table("profil") do
      modify :pendapatan, :decimal
    end
  end
end

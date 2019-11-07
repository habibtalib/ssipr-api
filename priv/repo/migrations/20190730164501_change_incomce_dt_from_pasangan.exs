defmodule IprApi.Repo.Migrations.ChangeIncomceDtFromPasangan do
  use Ecto.Migration

  def change do
    alter table("pasangan") do
      modify :pendapatan, :decimal
    end
  end
end

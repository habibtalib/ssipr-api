defmodule IprApi.Repo.Migrations.RemoveUnwantedFieldsFromTableTt do
  use Ecto.Migration

  def change do
    alter table("tempat_tinggal") do
      remove :no_siri_jmb
      remove :email_jmb
    end
  end
end

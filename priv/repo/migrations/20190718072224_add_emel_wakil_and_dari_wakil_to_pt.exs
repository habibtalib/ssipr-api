defmodule IprApi.Repo.Migrations.AddEmelWakilAndDariWakilToPt do
  use Ecto.Migration

  def change do
    alter table("profil") do
      add :negeri, :string
      add :emel_wakil, :string
    end
  end
end

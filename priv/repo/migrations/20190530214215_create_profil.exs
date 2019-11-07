defmodule IprApi.Repo.Migrations.CreateProfil do
  use Ecto.Migration

  def change do
    create table(:profil, primary_key: false) do
      add :emel, :string
      add :hash_kata_laluan, :string
      add :nama, :string
      add :ic, :string, primary_key: true
      add :tarikh_lahir, :date
      add :jantina, :string

      timestamps()
    end

    create unique_index(:profil, [:emel])
    create unique_index(:profil, [:ic])
  end
end

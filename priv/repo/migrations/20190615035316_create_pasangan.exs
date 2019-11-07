defmodule IprApi.Repo.Migrations.CreatePasangan do
  use Ecto.Migration

  def change do
    create table(:pasangan) do
      add :ic, :string
      add :nama, :string
      add :jantina, :string
      add :pendapatan, :integer
      add :id_pemohon, references(:profil, on_delete: :delete_all, type: :string, column: :ic)

      timestamps()
    end

    create index(:pasangan, [:id_pemohon])
  end
end

defmodule IprApi.Repo.Migrations.CreateAnak do
  use Ecto.Migration

  def change do
    create table(:anak, primary_key: false) do
      add :ic, :string, primary_key: true
      add :nama, :string
      add :tarikh_lahir, :date
      add :tempat_lahir, :string
      add :id_pemohon, references(:profil, on_delete: :delete_all, type: :string, column: :ic)

      timestamps()
    end

    create unique_index(:anak, [:ic])
    create index(:anak, [:id_pemohon])
  end
end

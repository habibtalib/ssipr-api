defmodule IprApi.Repo.Migrations.CreateDoketPermohonan do
  use Ecto.Migration

  def change do
    create table(:doket_permohonan) do
      add :kod_ipr, :string
      add :terbuka, :boolean, default: false, null: false
      add :id_pemohon, references(:profil, on_delete: :delete_all, type: :string, column: :ic)

      timestamps()
    end

    create index(:doket_permohonan, [:id_pemohon])
  end
end

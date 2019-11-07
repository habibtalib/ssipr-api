defmodule IprApi.Repo.Migrations.CreatePengesahanJmb do
  use Ecto.Migration

  def change do
    create table(:pengesahan_jmb) do
      add :nama_jmb, :string
      add :nama_wakil_jmb, :string
      add :jawatan_wakil_jmb, :string
      add :tarikh_pengesahan, :date
      add :no_siri_jmb, :string
      add :no_meter_pukal, :string
      add :no_tele, :string
      add :emel_jmb, :string
      add :id_doket_permohonan, references(:doket_permohonan, on_delete: :delete_all, column: :id)

      timestamps()
    end

    create index(:pengesahan_jmb, [:id_doket_permohonan])
  end
end

defmodule IprApi.Repo.Migrations.CreateTempatTinggal do
  use Ecto.Migration

  def change do
    create table(:tempat_tinggal) do
      add :no_siri_jmb, :string
      add :email_jmb, :string
      add :disahkan, :boolean, default: false, null: false
      add :jenis_rumah_pangsapuri_kos_rendah, :boolean, default: false, null: false
      add :jenis_rumah_pangsapuri_kos_sederhana_rendah, :boolean, default: false, null: false
      add :jenis_rumah_pangsapuri_kos_sederhana, :boolean, default: false, null: false
      add :jenis_rumah_lain_lain, :boolean, default: false, null: false
      add :keterangan_jenis_rumah_lain_lain, :string
      add :jenis_kerosakan, :string
      add :no_akaun, :string
      add :id_pemohon, references(:profil, on_delete: :delete_all, type: :string, column: :ic)
      add :id_doket_permohonan, references(:doket_permohonan, on_delete: :delete_all, column: :id)

      timestamps()
    end

    create index(:tempat_tinggal, [:id_pemohon])
    create index(:tempat_tinggal, [:id_doket_permohonan])
  end
end

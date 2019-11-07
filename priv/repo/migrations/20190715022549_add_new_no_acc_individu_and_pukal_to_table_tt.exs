defmodule IprApi.Repo.Migrations.AddNewNoAccIndividuAndPukalToTableTt do
  use Ecto.Migration

  def change do
    alter table("tempat_tinggal") do
      remove :no_akaun
      remove :jenis_rumah_pangsapuri_kos_rendah
      remove :jenis_rumah_pangsapuri_kos_sederhana_rendah
      remove :jenis_rumah_pangsapuri_kos_sederhana
      remove :jenis_rumah_lain_lain
      remove :keterangan_jenis_rumah_lain_lain
      remove :pemilik_atau_penyewa
      remove :jmb
      add :no_akaun_pukal, :integer
      add :no_akaun_individu, :integer
      add :jenis_rumah, :integer
      add :jenis_rumah_lain, :string
      add :status_pemilikan, :string
    end
  end
end

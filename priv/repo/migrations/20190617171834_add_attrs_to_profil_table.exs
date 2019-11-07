defmodule IprApi.Repo.Migrations.AddAttrsToProfilTable do
  use Ecto.Migration

  def change do
    alter table("profil") do
      add :tempat_lahir, :string
      add :no_ea, :string
      add :borang_ea, :string
      add :no_kwsp, :string
      add :penyata_kwsp, :string
      add :penyata_gaji, :string
      add :penyata_pencen, :string
      add :pendapatan, :integer
      add :surat_akuan_gaji, :string
      add :pengesahan_pendapatan, :boolean
      add :tempoh_mastautin, :integer
      add :agama, :string
      add :jenis_kereta, :string
      add :no_pendaftaran_kereta, :string
      add :taraf_persekolahan, :integer
      add :bilangan_anak, :integer
      add :alamat_1, :string
      add :alamat_2, :string
      add :alamat_3, :string
      add :poskod, :integer
      add :daerah, :string
      add :mukim, :string
      add :lokaliti, :string
      add :no_geran, :string
      add :tele_rumah, :integer
      add :tele_bimbit, :integer
    end
  end
end

defmodule IprApi.Repo.Migrations.AddExtraFieldsToTempatTinggalTable do
  use Ecto.Migration

  def change do
    alter table("tempat_tinggal") do
      add :jenis_meter, :string
      add :pemilik_atau_penyewa, :boolean
      add :jmb, :boolean
    end
  end
end

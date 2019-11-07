defmodule IprApi.Repo.Migrations.AddResetPassTokenToProfil do
  use Ecto.Migration

  def change do
    alter table("profil") do
      add :token_ubah_kata_laluan, :string
    end
  end
end

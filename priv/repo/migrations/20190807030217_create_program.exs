defmodule IprApi.Repo.Migrations.CreateProgram do
  use Ecto.Migration

  def change do
    create table(:program) do
      add :nama, :string
      add :kod_ipr, :string
      add :status, :integer
      add :gambar, :string

      timestamps()
    end

  end
end

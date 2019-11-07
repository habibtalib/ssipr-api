defmodule IprApi.Repo.Migrations.CreateAgensi do
  use Ecto.Migration

  def change do
    create table(:agensi) do
      add :nama, :string
      add :gambar, :string
      add :status, :integer

      timestamps()
    end

  end
end

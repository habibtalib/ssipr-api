defmodule IprApi.Repo.Migrations.CreateAdmin do
  use Ecto.Migration

  def change do
    create table(:admin) do
      add :emel, :string
      add :hash_kata_laluan, :string
      add :nama, :string

      timestamps()
    end

  end
end

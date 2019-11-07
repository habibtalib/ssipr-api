defmodule IprApi.Repo.Migrations.CreatePeranan do
  use Ecto.Migration

  def change do
    create table(:peranan) do
      add :nama, :string
      add :kebenaran, :map, default: "{}"

      timestamps()
    end

  end
end

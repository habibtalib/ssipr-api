defmodule IprApi.Repo.Migrations.ChangeAccNoConstraintUnuqFromTableTt do
  use Ecto.Migration

  def change do
    alter table("tempat_tinggal") do
      modify :no_akaun_individu, :string
    end
    
    create unique_index(:tempat_tinggal, [:no_akaun_individu])
  end
end

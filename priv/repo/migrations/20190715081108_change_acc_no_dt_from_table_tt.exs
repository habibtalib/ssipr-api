defmodule IprApi.Repo.Migrations.ChangeAccNoDtFromTableTt do
  use Ecto.Migration

  def change do
    alter table("tempat_tinggal") do
      modify :no_akaun_pukal, :string
      modify :no_akaun_individu, :string
    end
  end
end

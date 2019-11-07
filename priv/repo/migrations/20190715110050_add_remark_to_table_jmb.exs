defmodule IprApi.Repo.Migrations.AddRemarkToTableJmb do
  use Ecto.Migration

  def change do
    alter table("pengesahan_jmb") do
      add :kenyataan, :string
    end
  end
end

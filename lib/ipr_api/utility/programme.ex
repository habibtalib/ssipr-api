defmodule IprApi.Utility.Programme do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias IprApi.Enums
  alias IprApi.Utility.Agency

  @attrs [
    :id,
    :image,
    :ipr_code,
    :name,
    :status,
    :agency_id
  ]

  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "program" do
    field :ipr_code, :string, source: :kod_ipr
    field :name, :string, source: :nama
    field :image, :string, source: :gambar
    field :status, Enums.ProgramStatusEnum, default: "aktif"

    belongs_to :agency, Agency,
      foreign_key: :agency_id,
      source: :id_agensi

    timestamps()
  end

  @doc false
  def changeset(programme, attrs) do
    programme
    |> cast(attrs, [:name, :image, :ipr_code, :status, :agency_id])
    |> validate_required([:name, :ipr_code, :agency_id])
  end

  def search(query, params) do
    base_query(query)
    |> build_query(params)
  end

  defp base_query(query) do
    from(docket in query)
  end

  defp build_query(query, params) do
    Enum.reduce(params, query, &compose_query/2)
  end

  defp compose_query({"name", name}, query) do
    where(query, [programme], ilike(programme.name, ^"%#{name}%"))
  end

  defp compose_query({"from_date", from_date}, query) do
    fd = Date.from_iso8601!(from_date)
    where(query, [programme], fragment("?::date", programme.inserted_at) >= ^fd)
  end

  defp compose_query({"to_date", to_date}, query) do
    td = Date.from_iso8601!(to_date)
    where(query, [programme], fragment("?::date", programme.inserted_at) <= ^td)
  end

  defp compose_query(_unsupported_param, query) do
    query
  end
end

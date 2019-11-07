defmodule IprApi.Utility.Agency do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias IprApi.Enums
  alias IprApi.Account.Admin
  alias IprApi.Utility.Programme

  @attrs [
    :id,
    :name
  ]

  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "agensi" do
    field :name, :string, source: :nama
    field :image, :string, source: :gambar
    field :status, Enums.AgencyStatusEnum, default: "aktif"

    has_many :programmes, Programme, foreign_key: :agency_id
    has_many :admins, Admin, foreign_key: :agency_id

    timestamps()
  end

  @doc false
  def changeset(agency, attrs) do
    agency
    |> cast(attrs, [:name, :image, :status])
    |> validate_required([:name, :status])
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
    where(query, [agency], ilike(agency.name, ^"%#{name}%"))
  end

  defp compose_query({"from_date", from_date}, query) do
    fd = Date.from_iso8601!(from_date)
    where(query, [agency], fragment("?::date", agency.inserted_at) >= ^fd)
  end

  defp compose_query({"to_date", to_date}, query) do
    td = Date.from_iso8601!(to_date)
    where(query, [agency], fragment("?::date", agency.inserted_at) <= ^td)
  end

  defp compose_query(_unsupported_param, query) do
    query
  end
end

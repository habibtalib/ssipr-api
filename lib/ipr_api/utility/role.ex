defmodule IprApi.Utility.Role do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias IprApi.Account.Admin

  @attrs [
    :id,
    :name,
    :permissions
  ]

  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "peranan" do
    field :name, :string, source: :nama
    field :permissions, :map, source: :kebenaran

    has_many :admins, Admin, foreign_key: :role_id

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :permissions])
    |> validate_required([:name])
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

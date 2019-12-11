defmodule IprApi.IPRApplicant.Docket do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias IprApi.Enums
  alias IprApi.Account.Applicant
  alias IprApi.IPRApplicant.{Residence, JMBConfirmation}

  @foreign_key_type :string

  @attrs [
    :by_admin,
    :ipr_code,
    :status
  ]

  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "doket_permohonan" do
    field :ipr_code, :string, source: :kod_ipr
    field :is_open, :boolean, default: false, source: :terbuka
    field :by_admin, :boolean, default: false, source: :oleh_admin
    field :status, Enums.DocketStatusEnum, default: "diterima_dan_sedang_diproses"
    field :data, :map

    has_one :residence, Residence, foreign_key: :docket_id
    has_one :jmb_confirmation, JMBConfirmation, foreign_key: :docket_id

    belongs_to :applicant, Applicant,
      foreign_key: :applicant_id,
      source: :id_pemohon,
      references: :ic

    timestamps()
  end

  @doc false
  def changeset(docket, attrs) do
    meter_type = attrs["residence"]["meter_type"]

    residence_changeset =
      if meter_type == "pukal" do
        &Residence.bulk_changeset/2
      else
        &Residence.individual_changeset/2
      end

    docket
    |> cast(attrs, [:ipr_code, :data])
    |> validate_required([:ipr_code])
    |> cast_assoc(:residence, required: false, with: residence_changeset)
    |> cast_assoc(:jmb_confirmation, required: false)
    |> cast_assoc(:applicant, required: false, with: &Applicant.create_changeset/2)
    |> set_status_after_create
  end

  def jmb_changeset(docket, attrs) do
    docket
    |> cast(attrs, [:ipr_code, :status])
    |> cast_assoc(:residence,
      required: true,
      with: &Residence.bulk_changeset/2
    )
    |> cast_assoc(:jmb_confirmation, required: true)
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

  defp compose_query({"ic", ic}, query) do
    where(query, [docket], ilike(docket.applicant_id, ^"%#{ic}%"))
  end

  defp compose_query({"from_date", from_date}, query) do
    fd = Date.from_iso8601!(from_date)
    where(query, [docket], fragment("?::date", docket.inserted_at) >= ^fd)
  end

  defp compose_query({"to_date", to_date}, query) do
    td = Date.from_iso8601!(to_date)
    where(query, [docket], fragment("?::date", docket.inserted_at) <= ^td)
  end

  defp compose_query({"ipr_code", ipr_code}, query) do
    where(query, [docket], ilike(docket.ipr_code, ^"%#{ipr_code}%"))
  end


  defp compose_query(_unsupported_param, query) do
    query
  end

  defp set_status_after_create(changeset) do
    ipr_code = get_field(changeset, :ipr_code)
    by_admin = changeset.data.by_admin

    case ipr_code do
      "AIR_SELANGOR" ->
        residence = get_field(changeset, :residence)

        if residence.meter_type == "pukal" do
          if by_admin do
            put_change(changeset, :status, "disemak")
          else
            put_change(changeset, :status, "diterima_dan_sedang_menunggu_semakan_jmb_/_mc")
          end
        else
          changeset
        end

      _ ->
        changeset
    end
  end
end

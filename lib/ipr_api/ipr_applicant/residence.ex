defmodule IprApi.IPRApplicant.Residence do
  use Ecto.Schema

  import Ecto.Changeset

  alias IprApi.Account.Applicant
  alias IprApi.IPRApplicant.Docket

  @attrs [
    :id,
    :damage_type,
    :bulk_meter_acc_no,
    :individual_meter_acc_no,
    :meter_type,
    :home_type,
    :other_home_type,
    :ownership_status
  ]

  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "tempat_tinggal" do
    # field :verified, :boolean, default: false, source: :disahkan
    field :damage_type, :string, source: :jenis_kerosakan
    field :meter_type, :string, source: :jenis_meter
    field :bulk_meter_acc_no, :string, source: :no_akaun_pukal
    field :individual_meter_acc_no, :string, source: :no_akaun_individu
    field :home_type, :integer, source: :jenis_rumah
    field :other_home_type, :string, source: :jenis_rumah_lain
    field :ownership_status, :string, source: :status_pemilikan

    belongs_to :applicant, Applicant,
      foreign_key: :applicant_id,
      source: :id_pemohon,
      references: :ic

    belongs_to :docket, Docket,
      foreign_key: :docket_id,
      source: :id_doket_permohonan

    timestamps()
  end

  @doc false
  def individual_changeset(residence, attrs) do
    residence
    |> cast(attrs, [:meter_type, :individual_meter_acc_no, :ownership_status])
    # |> validate_required([:meter_type])
    |> unique_constraint(:individual_meter_acc_no)
  end

  def bulk_changeset(residence, attrs) do
    residence
    |> cast(attrs, [:meter_type, :bulk_meter_acc_no, :ownership_status])
    # |> validate_required([:meter_type])
  end
end

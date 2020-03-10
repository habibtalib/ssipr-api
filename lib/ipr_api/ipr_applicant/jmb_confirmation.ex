defmodule IprApi.IPRApplicant.JMBConfirmation do
  use Ecto.Schema

  import Ecto.Changeset

  alias IprApi.IPRApplicant.Docket

  @attrs [
    :id,
    :jmb_email,
    :jmb_rep_position,
    :jmb_name,
    :jmb_rep_name,
    :bulk_meter_no,
    :jmb_serial_no,
    :tele_no,
    :confirmation_date,
    :remark
  ]

  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "pengesahan_jmb" do
    field :jmb_email, :string, source: :emel_jmb
    field :jmb_rep_position, :string, source: :jawatan_wakil_jmb
    field :jmb_name, :string, source: :nama_jmb
    field :jmb_rep_name, :string, source: :nama_wakil_jmb
    field :bulk_meter_no, :string, source: :no_meter_pukal
    field :jmb_serial_no, :string, source: :no_siri_jmb
    field :tele_no, :string, source: :no_tele
    field :confirmation_date, :date, source: :tarikh_pengesahan
    field :remark, :string, source: :kenyataan

    belongs_to :docket, Docket,
      foreign_key: :docket_id,
      source: :id_doket_permohonan

    timestamps()
  end

  @doc false
  def changeset(jmb_confirmation, attrs) do
    jmb_confirmation
    |> cast(attrs, [
      :jmb_name,
      :jmb_rep_name,
      :jmb_rep_position,
      :confirmation_date,
      :jmb_serial_no,
      :bulk_meter_no,
      :tele_no,
      :jmb_email,
      :remark
    ])
  end
end

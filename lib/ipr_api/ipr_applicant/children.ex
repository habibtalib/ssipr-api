defmodule IprApi.IPRApplicant.Children do
  use Ecto.Schema

  import Ecto.Changeset

  alias IprApi.Account.Applicant

  @primary_key {:ic, :string, []}
  @foreign_key_type :string

  @attrs [
    :dob,
    :ic,
    :name,
    :pob
  ]

  @derive {Phoenix.Param, key: :ic}
  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "anak" do
    field :name, :string, source: :nama
    field :dob, :date, source: :tarikh_lahir
    field :pob, :string, source: :tempat_lahir

    belongs_to :applicant, Applicant,
      foreign_key: :applicant_id,
      source: :id_pemohon,
      references: :ic

    timestamps()
  end

  @doc false
  def changeset(children, attrs) do
    children
    |> cast(attrs, [:ic, :name, :dob, :pob])
    |> validate_required([:ic, :name, :dob, :pob])
    |> unique_constraint(:ic)
    |> unique_constraint(:ic, name: :anak_pkey)
  end
end

defmodule IprApi.IPRApplicant.Spouse do
  use Ecto.Schema

  import Ecto.Changeset

  alias IprApi.Account.Applicant

  @foreign_key_type :string

  @attrs [
    :id,
    :ic,
    :income,
    :name,
    :tele_no,
    :email
  ]

  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "pasangan" do
    field :ic, :string
    field :gender, :string, source: :jantina
    field :name, :string, source: :nama
    field :income, :decimal, source: :pendapatan
    field :tele_no, :string, source: :no_tele
    field :email, :string, source: :emel

    belongs_to :applicant, Applicant,
      foreign_key: :applicant_id,
      source: :id_pemohon,
      references: :ic

    timestamps()
  end

  @doc false
  def changeset(spouse, attrs) do
    spouse
    |> cast(attrs, [:ic, :name, :income, :email, :tele_no])
    |> validate_required([:ic, :name, :income])
  end
end

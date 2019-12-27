defmodule IprApi.Account.Applicant do
  use Ecto.Schema

  import Ecto.Changeset

  alias IprApi.Repo
  alias IprApi.Account.Applicant
  alias IprApi.IPRApplicant.{Children, Spouse, Residence, Docket}

  @primary_key {:ic, :string, []}

  @attrs [
    :ic,
    :email,
    :rep_email,
    :name,
    :gender,
    :marital_status,
    :dob,
    :pob,
    :income,
    :residence_period,
    :religion,
    :other_religion,
    :phone_no,
    :home_no,
    :address_1,
    :address_2,
    :address_3,
    :postcode,
    :other_district,
    :state,
    :mukim,
    :other_education_level,
    :no_of_child,
    :profile_completed,
    :verified_account,
    :childrens,
    :spouses
  ]

  @derive {
    Phoenix.Param,
    key: :ic
  }
  @derive {
    Jason.Encoder,
    only: @attrs
  }

  @allowed_when_create [
    :address_2,
    :address_3,
    :residence_period,
    :home_no,
    :district,
    :other_district,
    :education_level,
    :other_education_level,
    :gender,
    :phone_no,
    :dob,
    :pob,
    :religion,
    :rep_email,
    :email,
    :other_religion
  ]

  @required_when_create [
    :name,
    :ic,
    :ic_type,
    :marital_status,
    :income,
    :address_1,
    :postcode,
    :state,
    :by_admin
  ]

  @allowed_and_required_when_reg [
    :email,
    :password,
    :password_confirmation,
    :name,
    :ic,
    :ic_type
  ]

  @allowed_when_update [
    :home_no,
    :address_2,
    :address_3,
    :other_education_level,
    :other_religion,
    :other_district
  ]

  @required_when_update [
    :gender,
    :marital_status,
    :dob,
    :pob,
    :income,
    :residence_period,
    :religion,
    :address_1,
    :postcode,
    :district,
    :state,
    :education_level,
    :profile_completed
  ]

  schema "profil" do
    field :email, :string, source: :emel
    field :rep_email, :string, source: :emel_wakil
    field :password_hash, :string, source: :hash_kata_laluan
    field :gender, :string, source: :jantina
    field :marital_status, :string, source: :status_perkahwinan
    field :name, :string, source: :nama
    field :dob, :date, source: :tarikh_lahir
    field :pob, :string, source: :tempat_lahir
    field :ea_no, :string, source: :no_ea
    field :ea_form, :string, source: :borang_ea
    field :kwsp_no, :string, source: :no_kwsp
    field :kwsp_slip, :string, source: :penyata_kwsp
    field :pay_slip, :string, source: :penyata_gaji
    field :pension_statement, :string, source: :penyata_pencen
    field :income, :decimal, source: :pendapatan
    field :salary_declaration, :string, source: :surat_akuan_gaji
    field :income_verified, :boolean, default: false, source: :pengesahan_pendapatan
    field :profile_completed, :boolean, default: false, source: :profil_lengkap
    field :by_admin, :boolean, default: false, source: :oleh_admin
    field :verified_account, :boolean, default: false, source: :akaun_sah
    field :residence_period, :integer, source: :tempoh_mastautin
    field :religion, :string, source: :agama
    field :other_religion, :string, source: :agama_lain
    field :car_type, :string, source: :jenis_kereta
    field :car_no, :string, source: :no_pendaftaran_kereta
    field :education_level, :string, source: :tahap_pendidikan
    field :other_education_level, :string, source: :tahap_pendidikan_lain
    field :no_of_child, :integer, source: :bilangan_anak
    field :address_1, :string, source: :alamat_1
    field :address_2, :string, source: :alamat_2
    field :address_3, :string, source: :alamat_3
    field :postcode, :integer, source: :poskod
    field :district, :string, source: :daerah
    field :other_district, :string, source: :daerah_lain
    field :state, :string, source: :negeri
    field :mukim, :string, source: :mukim
    field :locality, :string, source: :lokaliti
    field :grant_no, :string, source: :no_geran
    field :home_no, :string, source: :tele_rumah
    field :phone_no, :string, source: :tele_bimbit
    field :ic_type, :integer, source: :jenis_ic
    field :reset_pass_token, :string, source: :token_ubah_kata_laluan

    has_many :childrens, Children, foreign_key: :applicant_id
    has_many :spouses, Spouse, foreign_key: :applicant_id
    has_many :residences, Residence, foreign_key: :applicant_id
    has_many :dockets, Docket, foreign_key: :applicant_id

    # VIRTUAL_FIELDS
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :is_admin?, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc false
  def create_changeset(applicant, attrs) do
    ignore_fields =
      if attrs["rep_email"] != nil do
        [:email]
      else
        [:rep_email]
      end

    applicant
    |> cast(attrs, @allowed_when_create ++ @required_when_create)
    |> validate_required(@required_when_create -- ignore_fields)
    |> in_depth_validation
    |> generate_password_hash
    |> cast_assoc(:childrens, required: false)
    |> cast_assoc(:spouses, required: false)
  end

  def update_changeset(applicant, attrs) do
    applicant
    |> cast(attrs, @allowed_when_update ++ @required_when_update)
    |> validate_required(@required_when_update)
    |> in_depth_validation
    |> generate_password_hash
    |> cast_assoc(:childrens, required: false)
    |> cast_assoc(:spouses, required: false)
  end

  def registration_changeset(applicant, attrs) do
    applicant
    |> cast(attrs, @allowed_and_required_when_reg)
    |> validate_required(@allowed_and_required_when_reg)
    |> in_depth_validation
    |> generate_password_hash
  end

  def authenticate(ic, password) do
    resource =
      Repo.preload(Repo.get_by(Applicant, ic: ic), [
        :childrens,
        :spouses,
        :dockets
      ])

    case resource do
      nil ->
        {:error, %{'': ["Anda belum berdaftar. Sila klik Daftar Akaun untuk membuat pendaftaran."]}}

      applicant ->
        cond do
          !applicant.verified_account ->
            {:error, %{'': ["Anda perlu membuat pengesahan akaun untuk memohon sebarang program IPR. Sila semak email untuk membuat pengesahan akaun."]}}
          Argon2.verify_pass(password, applicant.password_hash) ->
            {:ok, applicant}
          true ->
            {:error, %{'': ["Butiran log masuk tidak sah."]}}
        end
    end
  end

  def verify_account_changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:verified_account])
  end

  def reset_pass_token_changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:reset_pass_token])
  end

  def reset_pass_changeset(applicant, attrs) do
    applicant
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> generate_password_hash
    |> Ecto.Changeset.put_change(:reset_pass_token, nil)
  end

  defp in_depth_validation(applicant) do
    applicant
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> unique_constraint(:phone_no)
    |> unique_constraint(:ic, name: :profil_pkey)
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end

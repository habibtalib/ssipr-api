defmodule IprApi.Account.Admin do
  use Ecto.Schema

  import Ecto.Changeset

  alias IprApi.Repo
  alias IprApi.Account.Admin
  alias IprApi.Utility.Agency
  alias IprApi.Utility.Role

  @primary_key {:id_admin, :string, []}

  @attrs [
    :id_admin,
    :email,
    :name,
    :role_id,
    :agency_id
  ]

  @derive {
    Phoenix.Param,
    key: :id_admin
  }
  @derive {
    Jason.Encoder,
    only: @attrs
  }

  schema "admin" do
    field :email, :string, source: :emel
    field :password_hash, :string, source: :hash_kata_laluan
    field :name, :string, source: :nama
    field :position, :string, source: :jawatan
    field :admin_type, :integer, source: :jenis_admin

    # VIRTUAL_FIELDS
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :is_admin?, :boolean, virtual: true, default: true

    belongs_to :role, Role,
      foreign_key: :role_id,
      source: :id_peranan

    belongs_to :agency, Agency,
      foreign_key: :agency_id,
      source: :id_agensi

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [
      :id_admin,
      :email,
      :password,
      :password_confirmation,
      :name,
      :role_id,
      :agency_id
    ])
    |> validate_required([
      :id_admin,
      :email,
      :password,
      :password_confirmation,
      :name,
      :role_id,
      :agency_id
    ])
    |> in_depth_validation
    |> generate_password_hash
  end

  def authenticate(id_admin, password) do
    resource =
      Repo.preload(Repo.get_by!(Admin, id_admin: id_admin), [
        :role,
        :agency
      ])

    case resource do
      nil ->
        {:error, :not_found}

      admin ->
        if Argon2.verify_pass(password, admin.password_hash) do
          {:ok, admin}
        else
          {:error, :unauthorized}
        end
    end
  end

  defp in_depth_validation(admin) do
    admin
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> unique_constraint(:ic)
    |> unique_constraint(:id_admin, name: :admin_pkey)
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

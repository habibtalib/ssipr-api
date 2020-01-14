defmodule IprApi.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false

  alias IprApi.Repo
  alias IprApi.Account.Applicant
  alias IprApi.Account.Admin

  defdelegate authorize(action, user, params), to: IprApi.Account.Policy

  @doc """
  Returns the list of applicants.

  ## Examples

      iex> list_applicants()
      [%Applicant{}, ...]

  """
  def list_applicants(params) do
    # Repo.all(Applicant)
    Applicant.search(Applicant, params)
    |> preload([:childrens, :spouses, :dockets])
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single applicant.

  Raises `Ecto.NoResultsError` if the Applicant does not exist.

  ## Examples

      iex> get_applicant!(123)
      %Applicant{}

      iex> get_applicant!(456)
      ** (Ecto.NoResultsError)

  """

  def get_applicant!(id, user) do
    with :ok <- Bodyguard.permit(IprApi.Account, :get_applicant, user, id) do
      Repo.get!(Applicant, id)
      |> Repo.preload([:childrens, :spouses, :dockets])
    end
  end

  def get_verified_applicant_by_email(email) do
    resource =
      Repo.preload(Repo.get_by(Applicant, email: email), [
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
          true ->
            {:ok, applicant}
        end
    end
  end

  def get_unverified_applicant_by_email(email) do
    resource =
      Repo.get_by(Applicant, email: email)
    
    case resource do
      nil ->
        {:error, %{'': ["Anda belum berdaftar. Sila klik Daftar Akaun untuk membuat pendaftaran."]}}

      applicant ->
        cond do
          applicant.verified_account ->
            {:error, %{'': ["Anda telah membuat pengesahan akaun. Sila log masuk untuk memohon sebarang program IPR."]}}
          true ->
            {:ok, applicant}
        end
    end
  end

  def get_applicant_by_token!(token) do
    with {:ok, ic} <- IprApi.Token.verify_applicant_token(token) do
      resource =
        Repo.preload(Repo.get!(Applicant, ic), [:childrens, :spouses, :dockets])

      case resource do
        nil ->
          {:error, :not_found}

        applicant ->
          {:ok, applicant}
      end
    end
  end

  def get_applicant_by_reset_pass_token!(token) do
    Repo.preload(Repo.get_by!(Applicant, reset_pass_token: token), [
      :childrens,
      :spouses,
      :dockets
    ])
  end

  @doc """
  Creates a applicant.

  ## Examples

      iex> create_applicant(%{field: value})
      {:ok, %Applicant{}}

      iex> create_applicant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_applicant(attrs \\ %{}) do
    %Applicant{}
    |> Applicant.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a applicant.

  ## Examples

      iex> update_applicant(applicant, %{field: new_value})
      {:ok, %Applicant{}}

      iex> update_applicant(applicant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_applicant(%Applicant{} = applicant, attrs) do
    applicant
    |> Applicant.update_changeset(attrs)
    |> Repo.update()
  end

  def reset_pass_applicant(%Applicant{} = applicant, attrs) do
    applicant
    |> Applicant.reset_pass_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Applicant.

  ## Examples

      iex> delete_applicant(applicant)
      {:ok, %Applicant{}}

      iex> delete_applicant(applicant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_applicant(%Applicant{} = applicant, user) do
    with :ok <- Bodyguard.permit(IprApi.Account, :delete_applicant, user) do
      Repo.delete(applicant)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking applicant changes.

  ## Examples

      iex> change_applicant(applicant)
      %Ecto.Changeset{source: %Applicant{}}

  """
  def change_applicant(%Applicant{} = applicant) do
    Applicant.create_changeset(applicant, %{})
  end

  @doc """
  Returns the list of admins.

  ## Examples

      iex> list_admins()
      [%Admin{}, ...]

  """
  def list_admins do
    Repo.all(Admin)
    |> Repo.preload([:role, :agency])
  end

  @doc """
  Gets a single admin.

  Raises `Ecto.NoResultsError` if the Admin does not exist.

  ## Examples

      iex> get_admin!(123)
      %Admin{}

      iex> get_admin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_admin!(id) do
    Repo.get_by!(Admin, id_admin: id)
    |> Repo.preload([:role, :agency])
  end

  @doc """
  Creates a admin.

  ## Examples

      iex> create_admin(%{field: value})
      {:ok, %Admin{}}

      iex> create_admin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_admin(attrs \\ %{}) do
    %Admin{}
    |> Admin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a admin.

  ## Examples

      iex> update_admin(admin, %{field: new_value})
      {:ok, %Admin{}}

      iex> update_admin(admin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Admin.

  ## Examples

      iex> delete_admin(admin)
      {:ok, %Admin{}}

      iex> delete_admin(admin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_admin(%Admin{} = admin, user) do
    with :ok <- Bodyguard.permit(IprApi.Account, :delete_admin, user) do
      Repo.delete(admin)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking admin changes.

  ## Examples

      iex> change_admin(admin)
      %Ecto.Changeset{source: %Admin{}}

  """
  def change_admin(%Admin{} = admin) do
    Admin.changeset(admin, %{})
  end
end

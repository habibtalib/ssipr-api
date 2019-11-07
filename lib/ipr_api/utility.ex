defmodule IprApi.Utility do
  @moduledoc """
  The Utility context.
  """

  import Ecto.Query, warn: false

  alias IprApi.Repo
  alias IprApi.Utility.Programme
  alias IprApi.Utility.Agency

  @doc """
  Returns the list of programmes.

  ## Examples

      iex> list_programmes()
      [%Programme{}, ...]

  """
  def list_programmes(params) do
    Programme.search(Programme, params)
    |> preload([:agency])
    |> order_by(asc: :name)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single programme.

  Raises `Ecto.NoResultsError` if the Programme does not exist.

  ## Examples

      iex> get_programme!(123)
      %Programme{}

      iex> get_programme!(456)
      ** (Ecto.NoResultsError)

  """
  def get_programme!(id) do
    Repo.get!(Programme, id)
    |> Repo.preload([:agency])
  end

  @doc """
  Creates a programme.

  ## Examples

      iex> create_programme(%{field: value})
      {:ok, %Programme{}}

      iex> create_programme(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_programme(attrs \\ %{}) do
    %Programme{}
    |> Programme.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a programme.

  ## Examples

      iex> update_programme(programme, %{field: new_value})
      {:ok, %Programme{}}

      iex> update_programme(programme, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_programme(%Programme{} = programme, attrs) do
    programme
    |> Programme.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Programme.

  ## Examples

      iex> delete_programme(programme)
      {:ok, %Programme{}}

      iex> delete_programme(programme)
      {:error, %Ecto.Changeset{}}

  """
  def delete_programme(%Programme{} = programme) do
    Repo.delete(programme)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking programme changes.

  ## Examples

      iex> change_programme(programme)
      %Ecto.Changeset{source: %Programme{}}

  """
  def change_programme(%Programme{} = programme) do
    Programme.changeset(programme, %{})
  end

  @doc """
  Returns the list of agencies.

  ## Examples

      iex> list_agencies()
      [%Agency{}, ...]

  """
  def list_agencies(params) do
    Agency.search(Agency, params)
    |> preload([:programmes])
    |> order_by(asc: :name)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single agency.

  Raises `Ecto.NoResultsError` if the Agency does not exist.

  ## Examples

      iex> get_agency!(123)
      %Agency{}

      iex> get_agency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_agency!(id) do
    Repo.get!(Agency, id)
    |> Repo.preload([:programmes])
  end

  @doc """
  Creates a agency.

  ## Examples

      iex> create_agency(%{field: value})
      {:ok, %Agency{}}

      iex> create_agency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_agency(attrs \\ %{}) do
    %Agency{}
    |> Agency.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a agency.

  ## Examples

      iex> update_agency(agency, %{field: new_value})
      {:ok, %Agency{}}

      iex> update_agency(agency, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_agency(%Agency{} = agency, attrs) do
    agency
    |> Agency.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Agency.

  ## Examples

      iex> delete_agency(agency)
      {:ok, %Agency{}}

      iex> delete_agency(agency)
      {:error, %Ecto.Changeset{}}

  """
  def delete_agency(%Agency{} = agency) do
    Repo.delete(agency)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking agency changes.

  ## Examples

      iex> change_agency(agency)
      %Ecto.Changeset{source: %Agency{}}

  """
  def change_agency(%Agency{} = agency) do
    Agency.changeset(agency, %{})
  end

  alias IprApi.Utility.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles(params) do
    Role.search(Role, params)
    |> order_by(asc: :name)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end
end

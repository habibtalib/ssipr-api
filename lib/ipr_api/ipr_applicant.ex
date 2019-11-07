defmodule IprApi.IPRApplicant do
  @moduledoc """
  The IPR context.
  """

  import Ecto.Query, warn: false
  
  alias IprApi.Repo
  alias IprApi.IPRApplicant.Docket

  @doc """
  Returns the list of dockets.

  ## Examples

      iex> list_dockets()
      [%Docket{}, ...]

  """
  def list_dockets(params) do
    Docket.search(Docket, params)
    |> preload([:applicant, :residence, :jmb_confirmation])
    |> preload(applicant: [:spouses, :childrens])
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(params)
  end

  def list_dockets_export(params) do
    Docket.search(Docket, params)
    |> preload([:applicant, :residence, :jmb_confirmation])
    |> preload(applicant: [:spouses, :childrens])
    |> order_by(desc: :inserted_at)
    |> Repo.all
  end

  @doc """
  Gets a single docket.

  Raises `Ecto.NoResultsError` if the Application docket does not exist.

  ## Examples

      iex> get_docket!(123)
      %Docket{}

      iex> get_docket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_docket!(id) do
    Repo.get!(Docket, id)
    |> Repo.preload([:applicant, :residence, :jmb_confirmation])
    |> Repo.preload(applicant: [:spouses, :childrens])
  end

  @doc """
  Creates a docket.

  ## Examples

      iex> create_docket(%{field: value})
      {:ok, %Docket{}}

      iex> create_docket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_docket(resource, attrs \\ %{}) do
    application =
      if resource.is_admin? do
        %Docket{by_admin: true}
      else
        %Docket{applicant_id: resource.ic}
      end

    application
    |> Docket.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a docket.

  ## Examples

      iex> update_docket(docket, %{field: new_value})
      {:ok, %Docket{}}

      iex> update_docket(docket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_docket(%Docket{} = docket, attrs) do
    docket
    |> Docket.jmb_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Docket.

  ## Examples

      iex> delete_docket(docket)
      {:ok, %Docket{}}

      iex> delete_docket(docket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_docket(%Docket{} = docket) do
    Repo.delete(docket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking docket changes.

  ## Examples

      iex> change_docket(docket)
      %Ecto.Changeset{source: %Docket{}}

  """
  def change_docket(%Docket{} = docket) do
    Docket.changeset(docket, %{})
  end

  def get_application_deocket_by_token!(token) do
    with {:ok, id} <- IprApi.Token.verify_docket_token(token) do
      docket =
        Repo.preload(Repo.get!(Docket, id), [
          :applicant,
          :residence,
          :jmb_confirmation
        ])

      docket = Repo.preload(docket, applicant: [:spouses, :childrens])

      case docket do
        nil ->
          {:error, :not_found}

        docket ->
          {:ok, docket}
      end
    end
  end
end

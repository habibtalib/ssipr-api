defmodule IprApiWeb.AgencyController do
  use IprApiWeb, :controller

  alias IprApi.Repo
  alias IprApi.Utility
  alias IprApi.Utility.Agency

  action_fallback IprApiWeb.FallbackController

  def index(conn, params) do
    page = Utility.list_agencies(params)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"agency" => agency_params}) do
    with {:ok, %Agency{} = agency} <- Utility.create_agency(agency_params) do
      agency = Repo.preload(agency, [:programmes])

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.agency_path(conn, :show, agency))
      |> render("show.json", agency: agency)
    end
  end

  def show(conn, %{"id" => id}) do
    agency = Utility.get_agency!(id)
    render(conn, "show.json", agency: agency)
  end

  def update(conn, %{"id" => id, "agency" => agency_params}) do
    agency = Utility.get_agency!(id)

    with {:ok, %Agency{} = agency} <- Utility.update_agency(agency, agency_params) do
      render(conn, "show.json", agency: agency)
    end
  end

  def delete(conn, %{"id" => id}) do
    agency = Utility.get_agency!(id)

    with {:ok, %Agency{}} <- Utility.delete_agency(agency) do
      send_resp(conn, :no_content, "")
    end
  end
end

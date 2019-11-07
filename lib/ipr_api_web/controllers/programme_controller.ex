defmodule IprApiWeb.ProgrammeController do
  use IprApiWeb, :controller

  alias IprApi.Repo
  alias IprApi.Utility
  alias IprApi.Utility.Programme

  action_fallback IprApiWeb.FallbackController

  def index(conn, params) do
    page = Utility.list_programmes(params)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"programme" => programme_params}) do
    with {:ok, %Programme{} = programme} <- Utility.create_programme(programme_params) do
      programme = Repo.preload(programme, [:agency])

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.programme_path(conn, :show, programme))
      |> render("show.json", programme: programme)
    end
  end

  def show(conn, %{"id" => id}) do
    programme = Utility.get_programme!(id)
    render(conn, "show.json", programme: programme)
  end

  def update(conn, %{"id" => id, "programme" => programme_params}) do
    programme = Utility.get_programme!(id)

    with {:ok, %Programme{} = programme} <- Utility.update_programme(programme, programme_params) do
      render(conn, "show.json", programme: programme)
    end
  end

  def delete(conn, %{"id" => id}) do
    programme = Utility.get_programme!(id)

    with {:ok, %Programme{}} <- Utility.delete_programme(programme) do
      send_resp(conn, :no_content, "")
    end
  end
end

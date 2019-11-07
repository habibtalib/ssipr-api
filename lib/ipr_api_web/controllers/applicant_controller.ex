defmodule IprApiWeb.ApplicantController do
  use IprApiWeb, :controller

  alias IprApi.Account
  alias IprApi.Account.Applicant

  action_fallback IprApiWeb.FallbackController

  def index(conn, _params) do
    applicants = Account.list_applicants()
    render(conn, "index.json", applicants: applicants)
  end

  def create(conn, %{"applicant" => applicant_params}) do
    with {:ok, %Applicant{} = applicant} <- Account.create_applicant(applicant_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.applicant_path(conn, :show, applicant))
      |> render("show.json", applicant: applicant)
    end
  end

  def show(conn, %{"id" => id}) do
    applicant = Account.get_applicant!(id, IprApi.Guardian.Plug.current_resource(conn))
    render(conn, "show.json", applicant: applicant)
  end

  def update(conn, %{"id" => id, "applicant" => applicant_params}) do
    applicant = Account.get_applicant!(id, IprApi.Guardian.Plug.current_resource(conn))

    with {:ok, %Applicant{} = applicant} <- Account.update_applicant(applicant, applicant_params) do
      render(conn, "show.json", applicant: applicant)
    end
  end

  def delete(conn, %{"id" => id}) do
    applicant = Account.get_applicant!(id, IprApi.Guardian.Plug.current_resource(conn))

    with {:ok, %Applicant{}} <-
           Account.delete_applicant(applicant, IprApi.Guardian.Plug.current_resource(conn)) do
      send_resp(conn, :no_content, "")
    end
  end

  def current(conn, _params) do
    current_applicant = IprApi.Guardian.Plug.current_resource(conn)
    applicant = Account.get_applicant!(current_applicant.ic, current_applicant)
    render(conn, "show.json", applicant: applicant)
  end
end

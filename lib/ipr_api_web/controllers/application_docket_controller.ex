defmodule IprApiWeb.DocketController do
  use IprApiWeb, :controller

  alias IprApi.Repo
  alias IprApi.IPRApplicant
  alias IprApi.IPRApplicant.Docket

  action_fallback IprApiWeb.FallbackController

  def index(conn, params) do
    page = IPRApplicant.list_dockets(params)
    render(conn, "index.json", page: page)
  end

  def export(conn, params) do
    dockets = IPRApplicant.list_dockets_export(params)

    IO.inspect(params["from_date"])

    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header("content-disposition", "attachment; filename=senarai_permohonan")
    |> render("export.xlsx", %{dockets: dockets, params: params})
  end

  def create(conn, %{"docket" => docket_params}) do
    resource = IprApi.Guardian.Plug.current_resource(conn)

    changeset = IPRApplicant.create_docket(resource, docket_params)

    with {:ok, %Docket{} = docket} <- changeset do
      docket = Repo.preload(docket, [:applicant])
      docket = Repo.preload(docket, applicant: [:spouses, :childrens])

      applicant_email = IprApi.Email.new_air_selangor(docket)
      IprApi.Mailer.deliver_later(applicant_email)

      if docket.residence.meter_type == "pukal" do
        token = IprApi.Token.generate_docket_token(docket)

        jmb_email =
          if docket.by_admin == true do
            IprApi.Email.new_jmb_by_admin(docket)
          else
            IprApi.Email.new_jmb(docket, token)
          end

        IprApi.Mailer.deliver_later(jmb_email)
      end

      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.docket_path(conn, :show, docket)
      )
      |> render("show.json", docket: docket)
    end
  end

  def show(conn, %{"id" => id}) do
    docket = IPRApplicant.get_docket!(id)
    render(conn, "show.json", docket: docket)
  end

  def update(conn, %{"id" => id, "docket" => docket_params}) do
    docket = IPRApplicant.get_docket!(id)

    with {:ok, %Docket{} = docket} <-
           IPRApplicant.update_docket(docket, docket_params) do
      render(conn, "show.json", docket: docket)
    end
  end

  def delete(conn, %{"id" => id}) do
    docket = IPRApplicant.get_docket!(id)

    with {:ok, %Docket{}} <- IPRApplicant.delete_docket(docket) do
      send_resp(conn, :no_content, "")
    end
  end

  def verify_external(conn, %{"token" => token}) do
    with {:ok, %Docket{} = docket} <-
           IPRApplicant.get_application_deocket_by_token!(token) do
      render(conn, "show.json", docket: docket)
    end
  end

  def update_external(conn, %{"id" => id, "docket" => docket_params}) do
    docket = IPRApplicant.get_docket!(id)

    with {:ok, %Docket{} = docket} <-
           IPRApplicant.update_docket(docket, docket_params) do
      jmb_email = IprApi.Email.responded_jmb_to_jmb(docket)
      applicant_email = IprApi.Email.responded_jmb_to_applicant(docket)

      IprApi.Mailer.deliver_later(jmb_email)
      IprApi.Mailer.deliver_later(applicant_email)

      render(conn, "show.json", docket: docket)
    end
  end
end

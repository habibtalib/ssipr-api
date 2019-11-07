defmodule IprApiWeb.AdminController do
  use IprApiWeb, :controller

  alias IprApi.Account
  alias IprApi.Account.Admin

  action_fallback IprApiWeb.FallbackController

  def index(conn, _params) do
    admins = Account.list_admins()
    render(conn, "index.json", admins: admins)
  end

  def create(conn, %{"admin" => admin_params}) do
    with {:ok, %Admin{} = admin} <- Account.create_admin(admin_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.admin_path(conn, :show, admin))
      |> render("show.json", admin: admin)
    end
  end

  def show(conn, %{"id" => id}) do
    admin = Account.get_admin!(id)
    render(conn, "show.json", admin: admin)
  end

  def update(conn, %{"id" => id, "admin" => admin_params}) do
    admin = Account.get_admin!(id)

    with {:ok, %Admin{} = admin} <- Account.update_admin(admin, admin_params) do
      render(conn, "show.json", admin: admin)
    end
  end

  def delete(conn, %{"id" => id}) do
    admin = Account.get_admin!(id)

    with {:ok, %Admin{}} <- Account.delete_admin(admin, IprApi.Guardian.Plug.current_resource(conn)) do
      send_resp(conn, :no_content, "")
    end
  end

  def current(conn, _params) do
    current_admin = IprApi.Guardian.Plug.current_resource(conn)
    admin = Account.get_admin!(current_admin.id_admin)
    render(conn, "show.json", admin: admin)
  end
end

defmodule IprApiWeb.RoleController do
  use IprApiWeb, :controller

  alias IprApi.Utility
  alias IprApi.Utility.Role

  action_fallback IprApiWeb.FallbackController

  def index(conn, params) do
    page = Utility.list_roles(params)
    render(conn, "index.json", page: page)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Utility.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.role_path(conn, :show, role))
      |> render("show.json", role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Utility.get_role!(id)
    render(conn, "show.json", role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Utility.get_role!(id)

    with {:ok, %Role{} = role} <- Utility.update_role(role, role_params) do
      render(conn, "show.json", role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Utility.get_role!(id)

    with {:ok, %Role{}} <- Utility.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end

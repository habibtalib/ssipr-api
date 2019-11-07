defmodule IprApiWeb.AdminView do
  use IprApiWeb, :view
  alias IprApiWeb.AdminView

  def render("index.json", %{admins: admins}) do
    %{data: render_many(admins, AdminView, "admin.json")}
  end

  def render("show.json", %{admin: admin}) do
    %{
      success: true, 
      data: render_one(admin, AdminView, "admin.json")
    }
  end

  def render("admin.json", %{admin: admin}) do
    %{
      id_admin: admin.id_admin,
      email: admin.email,
      name: admin.name,
      role: admin.role,
      agency: admin.agency
    }
  end
end

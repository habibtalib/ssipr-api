defmodule IprApiWeb.RoleView do
  use IprApiWeb, :view
  alias IprApiWeb.RoleView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, RoleView, "role.json"),
      pagination: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries
      }
    }
  end

  def render("show.json", %{role: role}) do
    %{data: render_one(role, RoleView, "role.json")}
  end

  def render("role.json", %{role: role}) do
    %{
      id: role.id,
      name: role.name,
      permissions: role.permissions,
      inserted_at: Timex.format!(role.inserted_at, "%d-%m-%Y", :strftime)
    }
  end
end

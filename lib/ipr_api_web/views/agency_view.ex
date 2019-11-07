defmodule IprApiWeb.AgencyView do
  use IprApiWeb, :view
  alias IprApiWeb.AgencyView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, AgencyView, "agency.json"),
      pagination: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries
      }
    }
  end

  def render("show.json", %{agency: agency}) do
    %{data: render_one(agency, AgencyView, "agency.json")}
  end

  def render("agency.json", %{agency: agency}) do
    %{
      id: agency.id,
      name: agency.name,
      image: agency.image,
      status: agency.status,
      programmes: agency.programmes,
      inserted_at: Timex.format!(agency.inserted_at, "%d-%m-%Y", :strftime)
    }
  end
end

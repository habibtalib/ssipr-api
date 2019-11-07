defmodule IprApiWeb.ProgrammeView do
  use IprApiWeb, :view
  alias IprApiWeb.ProgrammeView

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, ProgrammeView, "programme.json"),
      pagination: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries
      }
    }
  end

  def render("show.json", %{programme: programme}) do
    %{data: render_one(programme, ProgrammeView, "programme.json")}
  end

  def render("programme.json", %{programme: programme}) do
    %{
      id: programme.id,
      name: programme.name,
      ipr_code: programme.ipr_code,
      status: programme.status,
      image: programme.image,
      agency: programme.agency,
      inserted_at: Timex.format!(programme.inserted_at, "%d-%m-%Y", :strftime)
    }
  end
end

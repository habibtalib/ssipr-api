defmodule IprApiWeb.DocketView do
  use IprApiWeb, :view

  alias IprApiWeb.DocketView
  alias Elixlsx.{Workbook, Sheet}

  @row_headers [
    "ID Doket Permohonan",
    "Jenis Meter",
    "Tarikh",
    "ID Pemohon",
    "Nama Pemohon",
    "Status"
  ]

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, DocketView, "docket.json"),
      pagination: %{
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries
      }
    }
  end

  def render("show.json", %{docket: docket}) do
    %{data: render_one(docket, DocketView, "docket.json")}
  end

  def render("docket.json", %{docket: docket}) do
    %{
      id: docket.id,
      ipr_code: docket.ipr_code,
      status: docket.status,
      by_admin: docket.by_admin,
      inserted_at: Timex.format!(docket.inserted_at, "%d-%m-%Y", :strftime),
      applicant: docket.applicant,
      residence: docket.residence,
      jmb_confirmation: docket.jmb_confirmation,
      data: docket.data
    }
  end

  def render("export.xlsx", %{dockets: dockets, params: params}) do
    report_generator(dockets, params)
    |> Elixlsx.write_to_memory("senarai_permohonan.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def report_generator(dockets, params) do
    from =
      Timex.format!(
        Date.from_iso8601!(params["from_date"]),
        "%d-%m-%Y",
        :strftime
      )

    to =
      Timex.format!(
        Date.from_iso8601!(params["to_date"]),
        "%d-%m-%Y",
        :strftime
      )

    rows =
      dockets
      |> Enum.map(&row(&1))

    %Workbook{
      sheets: [
        %Sheet{
          name: "Senarai Permohonan",
          rows:
            [
              ["Senarai Permohonan dari #{from} hingga #{to}"],
              ["Jumlah Permohonan", Enum.count(dockets)],
              [],
              @row_headers
            ] ++ rows
        }
      ]
    }
  end

  def row(docket) do
    [
      "SADE#{docket.id}",
      docket.residence.meter_type,
      Timex.format!(docket.inserted_at, "%d-%m-%Y", :strftime),
      docket.applicant.ic,
      docket.applicant.name,
      Atom.to_string(docket.status)
    ]
  end
end

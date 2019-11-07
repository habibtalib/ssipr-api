defmodule IprApi.Repo do
  use Ecto.Repo,
    otp_app: :ipr_api,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end

defmodule IprApiWeb.HealthCheckController do
  use IprApiWeb, :controller

  def health(conn, params) do
    json conn, nil
  end
end

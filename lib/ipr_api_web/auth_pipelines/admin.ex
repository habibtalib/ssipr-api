defmodule IprApiWeb.AuthAdminPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ipr_api,
    module: IprApi.Guardian,
    error_handler: IprApiWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access", "key" => "admin"}
  plug Guardian.Plug.VerifyHeader, key: :admin

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access", "key" => "admin"}
  plug Guardian.Plug.VerifySession, key: :admin

  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access", "key" => "admin"}
  plug Guardian.Plug.EnsureAuthenticated, key: :admin

  plug Guardian.Plug.LoadResource, allow_blank: true
  plug Guardian.Plug.LoadResource, key: :admin
end

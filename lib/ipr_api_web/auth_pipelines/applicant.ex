defmodule IprApiWeb.AuthApplicantPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ipr_api,
    module: IprApi.Guardian,
    error_handler: IprApiWeb.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access", "key" => "applicant"}
    plug Guardian.Plug.VerifyHeader, key: :applicant
  
    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access", "key" => "applicant"}
    plug Guardian.Plug.VerifySession, key: :applicant
  
    plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access", "key" => "applicant"}
    plug Guardian.Plug.EnsureAuthenticated, key: :applicant
  
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug Guardian.Plug.LoadResource, key: :applicant
end
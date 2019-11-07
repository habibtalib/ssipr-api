defmodule IprApiWeb.Router do
  use IprApiWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated_admin do
    plug IprApiWeb.AuthAdminPipeline
  end

  pipeline :authenticated_applicant do
    plug IprApiWeb.AuthApplicantPipeline
  end

  scope "/api/v1", IprApiWeb do
    pipe_through :api
    
    options "/login", ApplicantAuthController, :options
    options "/register", ApplicantAuthController, :options
    options "/reset_pass", ApplicantAuthController, :options
    options "/claim_reset_pass_token", ApplicantAuthController, :options
    options "/verify", ApplicantAuthController, :options
    options "/app_doc/verify_external", DocketController, :options
    options "/app_doc/update_external/:id", DocketController, :options
    post "/login", ApplicantAuthController, :login
    post "/register", ApplicantAuthController, :register
    post "/claim_reset_pass_token", ApplicantAuthController, :claim_reset_pass_token
    get "/verify", ApplicantAuthController, :verify
    get "/verify_reset_pass_token", ApplicantAuthController, :verify_reset_pass_token
    get "/app_doc/verify_external", DocketController, :verify_external
    put "/app_doc/update_external/:id", DocketController, :update_external
    put "/reset_pass", ApplicantAuthController, :reset_pass
  
    resources "/verifications", ApplicantAuth.VerificationController, only: [:create]
    get "/health", HealthCheckController, :health

    # ADMIN
    options "/admin/login", AdminAuthController, :options
    post "/admin/login", AdminAuthController, :login
  end

  scope "/api/v1", IprApiWeb do
    pipe_through [:api, :authenticated_applicant]

    resources "/applications", DocketController, only: [:create, :update, :show]
    resources "/applicants", ApplicantController, only: [:update]
    resources "/programmes", ProgrammeController
    get "/applicants/current", ApplicantController, :current
  end

  scope "/api/v1/admin", IprApiWeb do
    pipe_through [:api, :authenticated_admin]

    resources "/admins", AdminController, except: [:new, :edit]
    resources "/applicants", ApplicantController, except: [:new, :edit]
    resources "/applications", DocketController
    resources "/programmes", ProgrammeController
    resources "/agencies", AgencyController
    resources "/roles", RoleController
    get "/export_dockets", DocketController, :export
    get "/current_admin", AdminController, :current
  end
end

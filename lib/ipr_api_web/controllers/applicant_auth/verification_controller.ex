defmodule IprApiWeb.ApplicantAuth.VerificationController do
  use IprApiWeb, :controller
  
  import Ecto.Query, warn: false

  alias IprApi.Repo
  alias IprApi.Account
  alias IprApi.Account.Applicant

  def create(conn, %{"email" => email}) do
    with {:ok, applicant} <-
      Account.get_unverified_applicant_by_email(email) do
      token = IprApi.Token.generate_new_app_acc_token(applicant)
      link = Routes.applicant_auth_url(conn, :verify, token: token)
      IprApi.Email.email_verification(applicant, link)
      |> IprApi.Mailer.deliver_later()
      
      conn
      |> put_status(:ok)
      |> put_view(IprApiWeb.ApplicantView)
      |> render("success.json", applicant: nil)
    else
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{success: false, errors: reason})
    end
  end

  def resend_verification_email(conn, _params) do
    query = from(a in Applicant, where: a.verified_account == false)
    applicants = Repo.all(query)

    Enum.each(applicants, fn applicant ->
      token = IprApi.Token.generate_new_app_acc_token(applicant)
      link = Routes.applicant_auth_url(conn, :verify, token: token)

      IprApi.Email.email_verification(applicant, link)
      |> IprApi.Mailer.deliver_later()
    end)

    conn
    |> put_status(:created)
    |> put_view(IprApiWeb.ApplicantView)
    |> render("success.json", applicant: nil)
  end
end

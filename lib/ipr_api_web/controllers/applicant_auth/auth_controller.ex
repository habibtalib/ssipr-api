defmodule IprApiWeb.ApplicantAuthController do
  use IprApiWeb, :controller

  import Ecto.Query, warn: false

  alias IprApi.Repo
  alias IprApi.Account
  alias IprApi.Account.Applicant

  action_fallback IprApiWeb.FallbackController

  def register(conn, %{"applicant" => applicant_params}) do
    changeset = Applicant.registration_changeset(%Applicant{}, applicant_params)

    case Repo.insert(changeset) do
      {:ok, applicant} ->
        token = IprApi.Token.generate_new_app_acc_token(applicant)
        link = Routes.applicant_auth_url(conn, :verify, token: token)

        send_verification_email(applicant, link)

        conn
        |> put_status(:created)
        |> put_view(IprApiWeb.ApplicantView)
        |> render("success.json", applicant: nil)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(IprApiWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def login(conn, %{"ic" => ic, "password" => password}) do
    case Applicant.authenticate(ic, password) do
      {:ok, applicant} ->
        {:ok, token, _claims} = IprApi.Guardian.encode_and_sign(applicant, key: "applicant")

        conn
        |> put_resp_header("token", token)
        |> put_view(IprApiWeb.ApplicantView)
        |> render("show.json", applicant: applicant)

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{success: false, errors: reason})
    end
  end

  def reset_pass(conn, %{"token" => token, "applicant" => applicant_params}) do
    applicant = Account.get_applicant_by_reset_pass_token!(token)

    with {:ok, %Applicant{}} <-
           Account.reset_pass_applicant(applicant, applicant_params) do
      conn
      |> put_view(IprApiWeb.ApplicantView)
      |> render("success.json", applicant: nil)
    end
  end

  def claim_reset_pass_token(conn, %{"email" => email}) do
    with {:ok, applicant} <-
           Account.get_verified_applicant_by_email(email) do
      token = IprApi.Token.generate_reset_pass_token(applicant)
      changeset = Applicant.reset_pass_token_changeset(applicant, %{reset_pass_token: token})

      case Repo.update(changeset) do
        {:ok, applicant} ->
          link = Routes.applicant_auth_url(conn, :verify_reset_pass_token, token: token)

          send_reset_pass_email(applicant, link)

          conn
          |> put_status(:ok)
          |> put_view(IprApiWeb.ApplicantView)
          |> render("success.json", applicant: nil)

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(IprApiWeb.ChangesetView)
          |> render("error.json", changeset: changeset)
      end
    else
      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{success: false, errors: reason})

        
    end
  end

  def verify(conn, %{"token" => token}) do
    with {:ok, %Applicant{verified_account: false} = applicant} <-
           Account.get_applicant_by_token!(token) do
      changeset = Applicant.verify_account_changeset(applicant, %{verified_account: true})
      url = System.get_env("APPLICANT_URL") || "http://localhost:3000"

      case Repo.update(changeset) do
        {:ok, _applicant} ->
          conn
          |> redirect(external: "#{url}?confirmed=true")

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(IprApiWeb.ChangesetView)
          |> render("error.json", changeset: changeset)
      end
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{success: false})
    end
  end

  def verify_reset_pass_token(conn, %{"token" => token}) do
    with {:ok, %Applicant{reset_pass_token: token} = _applicant} <-
           Account.get_applicant_by_token!(token) do
      url = System.get_env("APPLICANT_URL") || "http://localhost:3000"

      conn
      |> redirect(external: "#{url}/reset_password?token=#{token}")
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{success: false})
    end
  end

  defp send_verification_email(applicant, link) do
    IprApi.Email.email_verification(applicant, link)
    |> IprApi.Mailer.deliver_later()
  end

  defp send_reset_pass_email(applicant, link) do
    IprApi.Email.reset_pass(applicant, link)
    |> IprApi.Mailer.deliver_later()
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

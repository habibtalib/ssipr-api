defmodule IprApi.Guardian do
  use Guardian, otp_app: :ipr_api
  alias IprApi.Repo

  def subject_for_token(resource, claims) do
    sub =
      if claims["key"] === "applicant" do
        resource.ic
      else
        to_string(resource.id_admin)
      end

    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    resource =
      if claims["key"] === "applicant" do
        Repo.get!(IprApi.Account.Applicant, id)
      else
        IprApi.Account.get_admin!(id)
      end

    {:ok, resource}
  end
end

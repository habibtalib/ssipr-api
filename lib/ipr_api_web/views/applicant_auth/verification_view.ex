defmodule IprApiWeb.ApplicantAuth.VerificationView do
  use IprApiWeb, :view

  def render("success.json", %{applicant: _applicant}) do
    %{success: true}
  end
end
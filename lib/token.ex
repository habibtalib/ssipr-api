# 86400 == 1 DAY

defmodule IprApi.Token do
  @salt "this-shall-pass"

  def generate_new_app_acc_token(%IprApi.Account.Applicant{ic: ic}) do
    Phoenix.Token.sign(IprApiWeb.Endpoint, @salt, ic)
  end

  def verify_applicant_token(token) do
    Phoenix.Token.verify(IprApiWeb.Endpoint, @salt, token, max_age: 86400)
  end

  def generate_docket_token(%IprApi.IPRApplicant.Docket{id: id}) do
    Phoenix.Token.sign(IprApiWeb.Endpoint, @salt, id)
  end

  def verify_docket_token(token) do
    Phoenix.Token.verify(IprApiWeb.Endpoint, @salt, token, max_age: 2592000)
  end

  def generate_reset_pass_token(%IprApi.Account.Applicant{ic: ic}) do
    Phoenix.Token.sign(IprApiWeb.Endpoint, @salt, ic)
  end

  def verify_reset_pass_token(token) do
    Phoenix.Token.verify(IprApiWeb.Endpoint, @salt, token, max_age: 86400)
  end
end
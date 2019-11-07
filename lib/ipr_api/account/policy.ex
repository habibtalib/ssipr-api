defmodule IprApi.Account.Policy do
  @behaviour Bodyguard.Policy

  def authorize(:get_applicant, user, id) do
    if user.is_admin? do
      true
    else
      if user.ic === id do
        true
      else
        false
      end
    end
  end

  def authorize(:delete_admin, user, _), do: user.is_admin?
  def authorize(:delete_applicant, user, _), do: user.is_admin?
end

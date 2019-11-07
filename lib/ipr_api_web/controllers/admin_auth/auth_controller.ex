defmodule IprApiWeb.AdminAuthController do
    use IprApiWeb, :controller
  
    alias IprApi.Account.Admin
  
    action_fallback IprApiWeb.FallbackController
  
    def login(conn, %{"id_admin" => id_admin, "password" => password}) do
      case Admin.authenticate(id_admin, password) do
        {:ok, admin} ->
          {:ok, token, _claims} = IprApi.Guardian.encode_and_sign(admin, key: "admin")
  
          conn
          |> put_resp_header("token", token)
          |> put_view(IprApiWeb.AdminView)
          |> render("show.json", admin: admin)
  
        {:error, _reason} ->
          conn
          |> put_status(:unauthorized)
          |> json(%{success: false})
      end
    end
  end
  
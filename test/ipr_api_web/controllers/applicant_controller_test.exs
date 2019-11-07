defmodule IprApiWeb.ApplicantControllerTest do
  use IprApiWeb.ConnCase

  alias IprApi.Account
  alias IprApi.Account.Applicant

  @create_attrs %{
    emel: "some emel",
    hash_kata_laluan: "some hash_kata_laluan",
    ic: "some ic",
    jantina: "some jantina",
    nama: "some nama",
    tarikh_lahir: ~D[2010-04-17]
  }
  @update_attrs %{
    emel: "some updated emel",
    hash_kata_laluan: "some updated hash_kata_laluan",
    ic: "some updated ic",
    jantina: "some updated jantina",
    nama: "some updated nama",
    tarikh_lahir: ~D[2011-05-18]
  }
  @invalid_attrs %{emel: nil, hash_kata_laluan: nil, ic: nil, jantina: nil, nama: nil, tarikh_lahir: nil}

  def fixture(:applicant) do
    {:ok, applicant} = Account.create_applicant(@create_attrs)
    applicant
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all applicants", %{conn: conn} do
      conn = get(conn, Routes.applicant_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create applicant" do
    test "renders applicant when data is valid", %{conn: conn} do
      conn = post(conn, Routes.applicant_path(conn, :create), applicant: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.applicant_path(conn, :show, id))

      assert %{
               "id" => id,
               "emel" => "some emel",
               "hash_kata_laluan" => "some hash_kata_laluan",
               "ic" => "some ic",
               "jantina" => "some jantina",
               "nama" => "some nama",
               "tarikh_lahir" => "2010-04-17"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.applicant_path(conn, :create), applicant: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update applicant" do
    setup [:create_applicant]

    test "renders applicant when data is valid", %{conn: conn, applicant: %Applicant{id: id} = applicant} do
      conn = put(conn, Routes.applicant_path(conn, :update, applicant), applicant: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.applicant_path(conn, :show, id))

      assert %{
               "id" => id,
               "emel" => "some updated emel",
               "hash_kata_laluan" => "some updated hash_kata_laluan",
               "ic" => "some updated ic",
               "jantina" => "some updated jantina",
               "nama" => "some updated nama",
               "tarikh_lahir" => "2011-05-18"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, applicant: applicant} do
      conn = put(conn, Routes.applicant_path(conn, :update, applicant), applicant: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete applicant" do
    setup [:create_applicant]

    test "deletes chosen applicant", %{conn: conn, applicant: applicant} do
      conn = delete(conn, Routes.applicant_path(conn, :delete, applicant))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.applicant_path(conn, :show, applicant))
      end
    end
  end

  defp create_applicant(_) do
    applicant = fixture(:applicant)
    {:ok, applicant: applicant}
  end
end

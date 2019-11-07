defmodule IprApiWeb.DocketControllerTest do
  use IprApiWeb.ConnCase

  alias IprApi.IPRApplicant
  alias IprApi.IPRApplicant.Docket

  @create_attrs %{
    kod_ipr: "some kod_ipr",
    terbuka: true
  }
  @update_attrs %{
    kod_ipr: "some updated kod_ipr",
    terbuka: false
  }
  @invalid_attrs %{kod_ipr: nil, terbuka: nil}

  def fixture(:docket) do
    {:ok, docket} = IPRApplicant.create_docket(@create_attrs)
    docket
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all dockets", %{conn: conn} do
      conn = get(conn, Routes.docket_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create docket" do
    test "renders docket when data is valid", %{conn: conn} do
      conn = post(conn, Routes.docket_path(conn, :create), docket: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.docket_path(conn, :show, id))

      assert %{
               "id" => id,
               "kod_ipr" => "some kod_ipr",
               "terbuka" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.docket_path(conn, :create), docket: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update docket" do
    setup [:create_docket]

    test "renders docket when data is valid", %{conn: conn, docket: %Docket{id: id} = docket} do
      conn = put(conn, Routes.docket_path(conn, :update, docket), docket: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.docket_path(conn, :show, id))

      assert %{
               "id" => id,
               "kod_ipr" => "some updated kod_ipr",
               "terbuka" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, docket: docket} do
      conn = put(conn, Routes.docket_path(conn, :update, docket), docket: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete docket" do
    setup [:create_docket]

    test "deletes chosen docket", %{conn: conn, docket: docket} do
      conn = delete(conn, Routes.docket_path(conn, :delete, docket))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.docket_path(conn, :show, docket))
      end
    end
  end

  defp create_docket(_) do
    docket = fixture(:docket)
    {:ok, docket: docket}
  end
end

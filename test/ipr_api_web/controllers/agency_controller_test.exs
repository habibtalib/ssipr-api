defmodule IprApiWeb.AgencyControllerTest do
  use IprApiWeb.ConnCase

  alias IprApi.Utility
  alias IprApi.Utility.Agency

  @create_attrs %{
    image: "some image",
    nama: "some nama",
    status: 42
  }
  @update_attrs %{
    image: "some updated image",
    nama: "some updated nama",
    status: 43
  }
  @invalid_attrs %{image: nil, nama: nil, status: nil}

  def fixture(:agency) do
    {:ok, agency} = Utility.create_agency(@create_attrs)
    agency
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all agencies", %{conn: conn} do
      conn = get(conn, Routes.agency_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create agency" do
    test "renders agency when data is valid", %{conn: conn} do
      conn = post(conn, Routes.agency_path(conn, :create), agency: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.agency_path(conn, :show, id))

      assert %{
               "id" => id,
               "image" => "some image",
               "nama" => "some nama",
               "status" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.agency_path(conn, :create), agency: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update agency" do
    setup [:create_agency]

    test "renders agency when data is valid", %{conn: conn, agency: %Agency{id: id} = agency} do
      conn = put(conn, Routes.agency_path(conn, :update, agency), agency: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.agency_path(conn, :show, id))

      assert %{
               "id" => id,
               "image" => "some updated image",
               "nama" => "some updated nama",
               "status" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, agency: agency} do
      conn = put(conn, Routes.agency_path(conn, :update, agency), agency: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete agency" do
    setup [:create_agency]

    test "deletes chosen agency", %{conn: conn, agency: agency} do
      conn = delete(conn, Routes.agency_path(conn, :delete, agency))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.agency_path(conn, :show, agency))
      end
    end
  end

  defp create_agency(_) do
    agency = fixture(:agency)
    {:ok, agency: agency}
  end
end

defmodule IprApiWeb.ProgrammeControllerTest do
  use IprApiWeb.ConnCase

  alias IprApi.Utility
  alias IprApi.Utility.Programme

  @create_attrs %{
    kod_ipr: "some kod_ipr",
    nama: "some nama",
    status: 42
  }
  @update_attrs %{
    kod_ipr: "some updated kod_ipr",
    nama: "some updated nama",
    status: 43
  }
  @invalid_attrs %{kod_ipr: nil, nama: nil, status: nil}

  def fixture(:programme) do
    {:ok, programme} = Utility.create_programme(@create_attrs)
    programme
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all programmes", %{conn: conn} do
      conn = get(conn, Routes.programme_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create programme" do
    test "renders programme when data is valid", %{conn: conn} do
      conn = post(conn, Routes.programme_path(conn, :create), programme: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.programme_path(conn, :show, id))

      assert %{
               "id" => id,
               "kod_ipr" => "some kod_ipr",
               "nama" => "some nama",
               "status" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.programme_path(conn, :create), programme: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update programme" do
    setup [:create_programme]

    test "renders programme when data is valid", %{conn: conn, programme: %Programme{id: id} = programme} do
      conn = put(conn, Routes.programme_path(conn, :update, programme), programme: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.programme_path(conn, :show, id))

      assert %{
               "id" => id,
               "kod_ipr" => "some updated kod_ipr",
               "nama" => "some updated nama",
               "status" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, programme: programme} do
      conn = put(conn, Routes.programme_path(conn, :update, programme), programme: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete programme" do
    setup [:create_programme]

    test "deletes chosen programme", %{conn: conn, programme: programme} do
      conn = delete(conn, Routes.programme_path(conn, :delete, programme))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.programme_path(conn, :show, programme))
      end
    end
  end

  defp create_programme(_) do
    programme = fixture(:programme)
    {:ok, programme: programme}
  end
end

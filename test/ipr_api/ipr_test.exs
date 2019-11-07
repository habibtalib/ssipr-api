defmodule IprApi.IPRApplicantTest do
  use IprApi.DataCase

  alias IprApi.IPRApplicant

  describe "dockets" do
    alias IprApi.IPRApplicant.Docket

    @valid_attrs %{kod_ipr: "some kod_ipr", terbuka: true}
    @update_attrs %{kod_ipr: "some updated kod_ipr", terbuka: false}
    @invalid_attrs %{kod_ipr: nil, terbuka: nil}

    def docket_fixture(attrs \\ %{}) do
      {:ok, docket} =
        attrs
        |> Enum.into(@valid_attrs)
        |> IPRApplicant.create_docket()

      docket
    end

    test "list_dockets/0 returns all dockets" do
      docket = docket_fixture()
      assert IPRApplicant.list_dockets() == [docket]
    end

    test "get_docket!/1 returns the docket with given id" do
      docket = docket_fixture()
      assert IPRApplicant.get_docket!(docket.id) == docket
    end

    test "create_docket/1 with valid data creates a docket" do
      assert {:ok, %Docket{} = docket} = IPRApplicant.create_docket(@valid_attrs)
      assert docket.kod_ipr == "some kod_ipr"
      assert docket.terbuka == true
    end

    test "create_docket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = IPRApplicant.create_docket(@invalid_attrs)
    end

    test "update_docket/2 with valid data updates the docket" do
      docket = docket_fixture()
      assert {:ok, %Docket{} = docket} = IPRApplicant.update_docket(docket, @update_attrs)
      assert docket.kod_ipr == "some updated kod_ipr"
      assert docket.terbuka == false
    end

    test "update_docket/2 with invalid data returns error changeset" do
      docket = docket_fixture()
      assert {:error, %Ecto.Changeset{}} = IPRApplicant.update_docket(docket, @invalid_attrs)
      assert docket == IPRApplicant.get_docket!(docket.id)
    end

    test "delete_docket/1 deletes the docket" do
      docket = docket_fixture()
      assert {:ok, %Docket{}} = IPRApplicant.delete_docket(docket)
      assert_raise Ecto.NoResultsError, fn -> IPRApplicant.get_docket!(docket.id) end
    end

    test "change_docket/1 returns a docket changeset" do
      docket = docket_fixture()
      assert %Ecto.Changeset{} = IPRApplicant.change_docket(docket)
    end
  end
end

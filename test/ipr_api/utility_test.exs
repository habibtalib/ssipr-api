defmodule IprApi.UtilityTest do
  use IprApi.DataCase

  alias IprApi.Utility

  describe "programmes" do
    alias IprApi.Utility.Programme

    @valid_attrs %{kod_ipr: "some kod_ipr", nama: "some nama", status: 42}
    @update_attrs %{kod_ipr: "some updated kod_ipr", nama: "some updated nama", status: 43}
    @invalid_attrs %{kod_ipr: nil, nama: nil, status: nil}

    def programme_fixture(attrs \\ %{}) do
      {:ok, programme} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Utility.create_programme()

      programme
    end

    test "list_programmes/0 returns all programmes" do
      programme = programme_fixture()
      assert Utility.list_programmes() == [programme]
    end

    test "get_programme!/1 returns the programme with given id" do
      programme = programme_fixture()
      assert Utility.get_programme!(programme.id) == programme
    end

    test "create_programme/1 with valid data creates a programme" do
      assert {:ok, %Programme{} = programme} = Utility.create_programme(@valid_attrs)
      assert programme.kod_ipr == "some kod_ipr"
      assert programme.nama == "some nama"
      assert programme.status == 42
    end

    test "create_programme/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Utility.create_programme(@invalid_attrs)
    end

    test "update_programme/2 with valid data updates the programme" do
      programme = programme_fixture()
      assert {:ok, %Programme{} = programme} = Utility.update_programme(programme, @update_attrs)
      assert programme.kod_ipr == "some updated kod_ipr"
      assert programme.nama == "some updated nama"
      assert programme.status == 43
    end

    test "update_programme/2 with invalid data returns error changeset" do
      programme = programme_fixture()
      assert {:error, %Ecto.Changeset{}} = Utility.update_programme(programme, @invalid_attrs)
      assert programme == Utility.get_programme!(programme.id)
    end

    test "delete_programme/1 deletes the programme" do
      programme = programme_fixture()
      assert {:ok, %Programme{}} = Utility.delete_programme(programme)
      assert_raise Ecto.NoResultsError, fn -> Utility.get_programme!(programme.id) end
    end

    test "change_programme/1 returns a programme changeset" do
      programme = programme_fixture()
      assert %Ecto.Changeset{} = Utility.change_programme(programme)
    end
  end

  describe "agencies" do
    alias IprApi.Utility.Agency

    @valid_attrs %{image: "some image", nama: "some nama", status: 42}
    @update_attrs %{image: "some updated image", nama: "some updated nama", status: 43}
    @invalid_attrs %{image: nil, nama: nil, status: nil}

    def agency_fixture(attrs \\ %{}) do
      {:ok, agency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Utility.create_agency()

      agency
    end

    test "list_agencies/0 returns all agencies" do
      agency = agency_fixture()
      assert Utility.list_agencies() == [agency]
    end

    test "get_agency!/1 returns the agency with given id" do
      agency = agency_fixture()
      assert Utility.get_agency!(agency.id) == agency
    end

    test "create_agency/1 with valid data creates a agency" do
      assert {:ok, %Agency{} = agency} = Utility.create_agency(@valid_attrs)
      assert agency.image == "some image"
      assert agency.nama == "some nama"
      assert agency.status == 42
    end

    test "create_agency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Utility.create_agency(@invalid_attrs)
    end

    test "update_agency/2 with valid data updates the agency" do
      agency = agency_fixture()
      assert {:ok, %Agency{} = agency} = Utility.update_agency(agency, @update_attrs)
      assert agency.image == "some updated image"
      assert agency.nama == "some updated nama"
      assert agency.status == 43
    end

    test "update_agency/2 with invalid data returns error changeset" do
      agency = agency_fixture()
      assert {:error, %Ecto.Changeset{}} = Utility.update_agency(agency, @invalid_attrs)
      assert agency == Utility.get_agency!(agency.id)
    end

    test "delete_agency/1 deletes the agency" do
      agency = agency_fixture()
      assert {:ok, %Agency{}} = Utility.delete_agency(agency)
      assert_raise Ecto.NoResultsError, fn -> Utility.get_agency!(agency.id) end
    end

    test "change_agency/1 returns a agency changeset" do
      agency = agency_fixture()
      assert %Ecto.Changeset{} = Utility.change_agency(agency)
    end
  end

  describe "roles" do
    alias IprApi.Utility.Role

    @valid_attrs %{kebenaran: %{}, nama: "some nama"}
    @update_attrs %{kebenaran: %{}, nama: "some updated nama"}
    @invalid_attrs %{kebenaran: nil, nama: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Utility.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Utility.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Utility.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = Utility.create_role(@valid_attrs)
      assert role.kebenaran == %{}
      assert role.nama == "some nama"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Utility.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = Utility.update_role(role, @update_attrs)
      assert role.kebenaran == %{}
      assert role.nama == "some updated nama"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Utility.update_role(role, @invalid_attrs)
      assert role == Utility.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Utility.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Utility.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Utility.change_role(role)
    end
  end
end

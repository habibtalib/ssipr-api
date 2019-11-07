defmodule IprApi.AccountTest do
  use IprApi.DataCase

  alias IprApi.Account

  describe "applicants" do
    alias IprApi.Account.Applicant

    @valid_attrs %{emel: "some emel", hash_kata_laluan: "some hash_kata_laluan", ic: "some ic", jantina: "some jantina", nama: "some nama", tarikh_lahir: ~D[2010-04-17]}
    @update_attrs %{emel: "some updated emel", hash_kata_laluan: "some updated hash_kata_laluan", ic: "some updated ic", jantina: "some updated jantina", nama: "some updated nama", tarikh_lahir: ~D[2011-05-18]}
    @invalid_attrs %{emel: nil, hash_kata_laluan: nil, ic: nil, jantina: nil, nama: nil, tarikh_lahir: nil}

    def applicant_fixture(attrs \\ %{}) do
      {:ok, applicant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_applicant()

      applicant
    end

    test "list_applicants/0 returns all applicants" do
      applicant = applicant_fixture()
      assert Account.list_applicants() == [applicant]
    end

    test "get_applicant!/1 returns the applicant with given id" do
      applicant = applicant_fixture()
      assert Account.get_applicant!(applicant.id) == applicant
    end

    test "create_applicant/1 with valid data creates a applicant" do
      assert {:ok, %Applicant{} = applicant} = Account.create_applicant(@valid_attrs)
      assert applicant.emel == "some emel"
      assert applicant.hash_kata_laluan == "some hash_kata_laluan"
      assert applicant.ic == "some ic"
      assert applicant.jantina == "some jantina"
      assert applicant.nama == "some nama"
      assert applicant.tarikh_lahir == ~D[2010-04-17]
    end

    test "create_applicant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_applicant(@invalid_attrs)
    end

    test "update_applicant/2 with valid data updates the applicant" do
      applicant = applicant_fixture()
      assert {:ok, %Applicant{} = applicant} = Account.update_applicant(applicant, @update_attrs)
      assert applicant.emel == "some updated emel"
      assert applicant.hash_kata_laluan == "some updated hash_kata_laluan"
      assert applicant.ic == "some updated ic"
      assert applicant.jantina == "some updated jantina"
      assert applicant.nama == "some updated nama"
      assert applicant.tarikh_lahir == ~D[2011-05-18]
    end

    test "update_applicant/2 with invalid data returns error changeset" do
      applicant = applicant_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_applicant(applicant, @invalid_attrs)
      assert applicant == Account.get_applicant!(applicant.id)
    end

    test "delete_applicant/1 deletes the applicant" do
      applicant = applicant_fixture()
      assert {:ok, %Applicant{}} = Account.delete_applicant(applicant)
      assert_raise Ecto.NoResultsError, fn -> Account.get_applicant!(applicant.id) end
    end

    test "change_applicant/1 returns a applicant changeset" do
      applicant = applicant_fixture()
      assert %Ecto.Changeset{} = Account.change_applicant(applicant)
    end
  end

  describe "admins" do
    alias IprApi.Account.Admin

    @valid_attrs %{emel: "some emel", hash_kata_laluan: "some hash_kata_laluan", nama: "some nama"}
    @update_attrs %{emel: "some updated emel", hash_kata_laluan: "some updated hash_kata_laluan", nama: "some updated nama"}
    @invalid_attrs %{emel: nil, hash_kata_laluan: nil, nama: nil}

    def admin_fixture(attrs \\ %{}) do
      {:ok, admin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_admin()

      admin
    end

    test "list_admins/0 returns all admins" do
      admin = admin_fixture()
      assert Account.list_admins() == [admin]
    end

    test "get_admin!/1 returns the admin with given id" do
      admin = admin_fixture()
      assert Account.get_admin!(admin.id) == admin
    end

    test "create_admin/1 with valid data creates a admin" do
      assert {:ok, %Admin{} = admin} = Account.create_admin(@valid_attrs)
      assert admin.emel == "some emel"
      assert admin.hash_kata_laluan == "some hash_kata_laluan"
      assert admin.nama == "some nama"
    end

    test "create_admin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_admin(@invalid_attrs)
    end

    test "update_admin/2 with valid data updates the admin" do
      admin = admin_fixture()
      assert {:ok, %Admin{} = admin} = Account.update_admin(admin, @update_attrs)
      assert admin.emel == "some updated emel"
      assert admin.hash_kata_laluan == "some updated hash_kata_laluan"
      assert admin.nama == "some updated nama"
    end

    test "update_admin/2 with invalid data returns error changeset" do
      admin = admin_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_admin(admin, @invalid_attrs)
      assert admin == Account.get_admin!(admin.id)
    end

    test "delete_admin/1 deletes the admin" do
      admin = admin_fixture()
      assert {:ok, %Admin{}} = Account.delete_admin(admin)
      assert_raise Ecto.NoResultsError, fn -> Account.get_admin!(admin.id) end
    end

    test "change_admin/1 returns a admin changeset" do
      admin = admin_fixture()
      assert %Ecto.Changeset{} = Account.change_admin(admin)
    end
  end

  describe "childrens" do
    alias IprApi.IPRApplicant.Children

    @valid_attrs %{ic: "some ic", nama: "some nama", tarikh_lahir: ~D[2010-04-17], tempat_lahir: "some tempat_lahir"}
    @update_attrs %{ic: "some updated ic", nama: "some updated nama", tarikh_lahir: ~D[2011-05-18], tempat_lahir: "some updated tempat_lahir"}
    @invalid_attrs %{ic: nil, nama: nil, tarikh_lahir: nil, tempat_lahir: nil}

    def children_fixture(attrs \\ %{}) do
      {:ok, children} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_children()

      children
    end

    test "list_childrens/0 returns all childrens" do
      children = children_fixture()
      assert Account.list_childrens() == [children]
    end

    test "get_children!/1 returns the children with given id" do
      children = children_fixture()
      assert Account.get_children!(children.id) == children
    end

    test "create_children/1 with valid data creates a children" do
      assert {:ok, %Children{} = children} = Account.create_children(@valid_attrs)
      assert children.ic == "some ic"
      assert children.nama == "some nama"
      assert children.tarikh_lahir == ~D[2010-04-17]
      assert children.tempat_lahir == "some tempat_lahir"
    end

    test "create_children/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_children(@invalid_attrs)
    end

    test "update_children/2 with valid data updates the children" do
      children = children_fixture()
      assert {:ok, %Children{} = children} = Account.update_children(children, @update_attrs)
      assert children.ic == "some updated ic"
      assert children.nama == "some updated nama"
      assert children.tarikh_lahir == ~D[2011-05-18]
      assert children.tempat_lahir == "some updated tempat_lahir"
    end

    test "update_children/2 with invalid data returns error changeset" do
      children = children_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_children(children, @invalid_attrs)
      assert children == Account.get_children!(children.id)
    end

    test "delete_children/1 deletes the children" do
      children = children_fixture()
      assert {:ok, %Children{}} = Account.delete_children(children)
      assert_raise Ecto.NoResultsError, fn -> Account.get_children!(children.id) end
    end

    test "change_children/1 returns a children changeset" do
      children = children_fixture()
      assert %Ecto.Changeset{} = Account.change_children(children)
    end
  end
end

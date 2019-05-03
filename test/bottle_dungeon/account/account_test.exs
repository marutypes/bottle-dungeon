defmodule BottleDungeon.AccountTest do
  use BottleDungeon.DataCase

  alias BottleDungeon.Accounts
  alias BottleDungeon.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      username: "kokusho",
      credential: %{
        email: "kokes@cats.com",
        password: "secret-password ;)"
      }
    }
    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.username == "kokusho"
      assert user.credential.email == "kokes@cats.com"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data does not insert user" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end

    test "enforces unique usernames" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)

      assert %{username: ["has already been taken"]} = errors_on(changeset)
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "does not accept super long usernames" do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 21))
      {:error, _changeset} = Accounts.register_user(attrs)
    end

    test "require password to be at least 8 characters long" do
      attrs = put_in(@valid_attrs, [:credential, :password], "12345")
      {:error, changeset} = Accounts.register_user(attrs)

      assert %{password: ["should be at least 8 character(s)"]} =
               errors_on(changeset)[:credential]

      assert Accounts.list_users() == []
    end
  end

  describe "authenticate_by_email_and_pass/2" do
    @email "user@localhost"
    @pass "12345678"

    setup do
      {:ok, user: user_fixture(email: @email, password: @pass)}
    end

    test "returns user with correct password", %{user: %User{id: id}} do
      assert {:ok, %User{id: ^id}} = Accounts.authenticate_by_email_and_pass(@email, @pass)
    end

    test "returns unauthorized error with invalid password" do
      assert {:error, :unauthorized} =
               Accounts.authenticate_by_email_and_pass(@email, "not a good password")
    end

    test "returns unauthorized error with no matching user for email" do
      assert {:error, :unauthorized} =
               Accounts.authenticate_by_email_and_pass("bad@email.com", @pass)
    end
  end
end

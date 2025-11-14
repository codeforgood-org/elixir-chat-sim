defmodule ChatSimulator.AuthTest do
  use ExUnit.Case, async: false

  alias ChatSimulator.{Auth, Storage}

  setup do
    {:ok, _pid} = Storage.start_link()
    Storage.clear()

    on_exit(fn ->
      Storage.stop()
    end)

    :ok
  end

  describe "register/2" do
    test "successfully registers a new user" do
      assert {:ok, user} = Auth.register("alice", "password123")
      assert user.username == "alice"
    end

    test "returns error for invalid username" do
      assert {:error, reason} = Auth.register("ab", "password123")
      assert reason =~ "Invalid username"
    end

    test "returns error for invalid password" do
      assert {:error, reason} = Auth.register("alice", "short")
      assert reason =~ "Invalid password"
    end

    test "returns error for duplicate username" do
      assert {:ok, _} = Auth.register("alice", "password123")
      assert {:error, reason} = Auth.register("alice", "password456")
      assert reason =~ "already taken"
    end
  end

  describe "login/2" do
    test "successfully logs in with correct credentials" do
      {:ok, _} = Auth.register("alice", "password123")

      assert {:ok, user} = Auth.login("alice", "password123")
      assert user.username == "alice"
    end

    test "returns error for non-existent user" do
      assert {:error, reason} = Auth.login("nonexistent", "password")
      assert reason =~ "Invalid username or password"
    end

    test "returns error for incorrect password" do
      {:ok, _} = Auth.register("alice", "password123")

      assert {:error, reason} = Auth.login("alice", "wrongpassword")
      assert reason =~ "Invalid username or password"
    end
  end

  describe "user_exists?/1" do
    test "returns true for existing user" do
      {:ok, _} = Auth.register("alice", "password123")
      assert Auth.user_exists?("alice")
    end

    test "returns false for non-existent user" do
      refute Auth.user_exists?("nonexistent")
    end
  end
end

defmodule ChatSimulator.UserTest do
  use ExUnit.Case, async: true
  doctest ChatSimulator.User

  alias ChatSimulator.User

  describe "new/2" do
    test "creates a user with hashed password" do
      user = User.new("alice", "password123")

      assert user.username == "alice"
      assert user.password_hash != "password123"
      assert is_binary(user.password_hash)
      assert user.created_at != nil
    end

    test "different passwords produce different hashes" do
      user1 = User.new("alice", "password1")
      user2 = User.new("alice", "password2")

      assert user1.password_hash != user2.password_hash
    end
  end

  describe "verify_password/2" do
    test "returns true for correct password" do
      user = User.new("alice", "password123")

      assert User.verify_password(user, "password123")
    end

    test "returns false for incorrect password" do
      user = User.new("alice", "password123")

      refute User.verify_password(user, "wrongpassword")
    end
  end

  describe "valid_username?/1" do
    test "accepts valid usernames" do
      assert User.valid_username?("alice")
      assert User.valid_username?("bob123")
      assert User.valid_username?("user_name")
      assert User.valid_username?("abc")
    end

    test "rejects invalid usernames" do
      refute User.valid_username?("ab")
      refute User.valid_username?("a" <> String.duplicate("b", 20))
      refute User.valid_username?("123user")
      refute User.valid_username?("user-name")
      refute User.valid_username?("user name")
    end
  end

  describe "valid_password?/1" do
    test "accepts valid passwords" do
      assert User.valid_password?("password")
      assert User.valid_password?("pass123")
      assert User.valid_password?("a1b2c3")
    end

    test "rejects invalid passwords" do
      refute User.valid_password?("short")
      refute User.valid_password?("abc")
      refute User.valid_password?("")
    end
  end
end

defmodule ChatSimulator.StorageTest do
  use ExUnit.Case, async: false

  alias ChatSimulator.{Storage, User, Message}

  setup do
    {:ok, _pid} = Storage.start_link()
    Storage.clear()

    on_exit(fn ->
      Storage.stop()
    end)

    :ok
  end

  describe "user operations" do
    test "add_user/1 adds a user to storage" do
      user = User.new("alice", "password123")
      assert :ok = Storage.add_user(user)

      retrieved = Storage.get_user("alice")
      assert retrieved.username == "alice"
    end

    test "get_user/1 returns nil for non-existent user" do
      assert Storage.get_user("nonexistent") == nil
    end

    test "list_users/0 returns all users" do
      user1 = User.new("alice", "password123")
      user2 = User.new("bob", "password456")

      Storage.add_user(user1)
      Storage.add_user(user2)

      users = Storage.list_users()
      assert length(users) == 2
      assert Enum.any?(users, &(&1.username == "alice"))
      assert Enum.any?(users, &(&1.username == "bob"))
    end

    test "list_usernames/0 returns all usernames" do
      user1 = User.new("alice", "password123")
      user2 = User.new("bob", "password456")

      Storage.add_user(user1)
      Storage.add_user(user2)

      usernames = Storage.list_usernames()
      assert length(usernames) == 2
      assert "alice" in usernames
      assert "bob" in usernames
    end
  end

  describe "message operations" do
    test "add_message/1 adds a message to storage" do
      message = Message.new("alice", "bob", "Hello!")
      assert :ok = Storage.add_message(message)

      messages = Storage.get_messages_for("bob")
      assert length(messages) == 1
      assert hd(messages).content == "Hello!"
    end

    test "get_messages_for/1 filters by recipient" do
      msg1 = Message.new("alice", "bob", "Hello Bob!")
      msg2 = Message.new("charlie", "alice", "Hello Alice!")
      msg3 = Message.new("bob", "alice", "Hi Alice!")

      Storage.add_message(msg1)
      Storage.add_message(msg2)
      Storage.add_message(msg3)

      alice_messages = Storage.get_messages_for("alice")
      assert length(alice_messages) == 2
      assert Enum.all?(alice_messages, &(&1.to == "alice"))
    end

    test "get_conversation/2 returns messages between two users" do
      msg1 = Message.new("alice", "bob", "Hi Bob!")
      msg2 = Message.new("bob", "alice", "Hi Alice!")
      msg3 = Message.new("charlie", "alice", "Hi Alice!")

      Storage.add_message(msg1)
      Storage.add_message(msg2)
      Storage.add_message(msg3)

      conversation = Storage.get_conversation("alice", "bob")
      assert length(conversation) == 2
      assert Enum.all?(conversation, fn msg ->
        (msg.from == "alice" and msg.to == "bob") or
        (msg.from == "bob" and msg.to == "alice")
      end)
    end

    test "mark_message_read/1 marks a message as read" do
      message = Message.new("alice", "bob", "Hello!")
      Storage.add_message(message)

      Storage.mark_message_read(message.id)

      messages = Storage.get_messages_for("bob")
      assert hd(messages).read == true
    end

    test "count_unread/1 counts unread messages" do
      msg1 = Message.new("alice", "bob", "Hello!")
      msg2 = Message.new("charlie", "bob", "Hi!")

      Storage.add_message(msg1)
      Storage.add_message(msg2)

      assert Storage.count_unread("bob") == 2

      Storage.mark_message_read(msg1.id)
      assert Storage.count_unread("bob") == 1
    end
  end

  describe "clear/0" do
    test "removes all data" do
      user = User.new("alice", "password123")
      message = Message.new("alice", "bob", "Hello!")

      Storage.add_user(user)
      Storage.add_message(message)

      Storage.clear()

      assert Storage.list_users() == []
      assert Storage.get_messages_for("bob") == []
    end
  end
end

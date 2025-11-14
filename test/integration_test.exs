defmodule ChatSimulator.IntegrationTest do
  use ExUnit.Case, async: false

  alias ChatSimulator.{Storage, Auth, Message}

  setup do
    {:ok, _pid} = Storage.start_link()
    Storage.clear()

    on_exit(fn ->
      Storage.stop()
    end)

    :ok
  end

  describe "full user workflow" do
    test "complete chat session flow" do
      # Register two users
      assert {:ok, alice} = Auth.register("alice", "password123")
      assert {:ok, bob} = Auth.register("bob", "secret456")

      # Verify users exist
      assert Auth.user_exists?("alice")
      assert Auth.user_exists?("bob")
      refute Auth.user_exists?("nonexistent")

      # Login with correct credentials
      assert {:ok, _} = Auth.login("alice", "password123")
      assert {:ok, _} = Auth.login("bob", "secret456")

      # Login with wrong credentials fails
      assert {:error, _} = Auth.login("alice", "wrongpassword")

      # Send messages
      msg1 = Message.new("alice", "bob", "Hello Bob!")
      Storage.add_message(msg1)

      msg2 = Message.new("bob", "alice", "Hi Alice!")
      Storage.add_message(msg2)

      msg3 = Message.new("alice", "bob", "How are you?")
      Storage.add_message(msg3)

      # Check inboxes
      alice_inbox = Storage.get_messages_for("alice")
      bob_inbox = Storage.get_messages_for("bob")

      assert length(alice_inbox) == 1
      assert length(bob_inbox) == 2

      # Check unread counts
      assert Storage.count_unread("alice") == 1
      assert Storage.count_unread("bob") == 2

      # Check conversation
      conversation = Storage.get_conversation("alice", "bob")
      assert length(conversation) == 3

      # Verify message order
      [first, second, third] = conversation
      assert first.from == "alice"
      assert first.to == "bob"
      assert second.from == "bob"
      assert second.to == "alice"
      assert third.from == "alice"
      assert third.to == "bob"
    end

    test "persistence across restarts" do
      # Register users and send messages
      {:ok, _} = Auth.register("alice", "password123")
      {:ok, _} = Auth.register("bob", "password456")

      msg = Message.new("alice", "bob", "Hello!")
      Storage.add_message(msg)

      # Stop and restart storage
      Storage.stop()
      {:ok, _pid} = Storage.start_link()

      # Verify data persisted
      assert Auth.user_exists?("alice")
      assert Auth.user_exists?("bob")

      bob_messages = Storage.get_messages_for("bob")
      assert length(bob_messages) == 1
      assert hd(bob_messages).content == "Hello!"

      # Cleanup
      Storage.clear()
    end

    test "multiple users messaging" do
      # Register multiple users
      users = ["alice", "bob", "charlie", "diana"]

      Enum.each(users, fn username ->
        assert {:ok, _} = Auth.register(username, "password123")
      end)

      # Everyone sends a message to alice
      Enum.each(["bob", "charlie", "diana"], fn sender ->
        msg = Message.new(sender, "alice", "Hello from #{sender}!")
        Storage.add_message(msg)
      end)

      # Check alice's inbox
      alice_inbox = Storage.get_messages_for("alice")
      assert length(alice_inbox) == 3

      # Verify all senders
      senders = Enum.map(alice_inbox, & &1.from)
      assert "bob" in senders
      assert "charlie" in senders
      assert "diana" in senders
    end
  end

  describe "error handling" do
    test "prevents duplicate usernames" do
      {:ok, _} = Auth.register("alice", "password123")
      assert {:error, reason} = Auth.register("alice", "different_password")
      assert reason =~ "already taken"
    end

    test "validates username format" do
      assert {:error, reason} = Auth.register("ab", "password123")
      assert reason =~ "Invalid username"

      assert {:error, reason} = Auth.register("123invalid", "password123")
      assert reason =~ "Invalid username"
    end

    test "validates password length" do
      assert {:error, reason} = Auth.register("alice", "short")
      assert reason =~ "Invalid password"
    end

    test "validates message content" do
      refute Message.valid_content?("")
      refute Message.valid_content?(String.duplicate("a", 501))
      assert Message.valid_content?("Valid message")
    end
  end

  describe "message operations" do
    test "marks messages as read" do
      {:ok, _} = Auth.register("alice", "password123")
      {:ok, _} = Auth.register("bob", "password456")

      msg = Message.new("alice", "bob", "Hello!")
      Storage.add_message(msg)

      # Message should be unread initially
      assert Storage.count_unread("bob") == 1

      # Mark as read
      Storage.mark_message_read(msg.id)

      # Should now be read
      assert Storage.count_unread("bob") == 0

      # Verify in inbox
      [read_msg] = Storage.get_messages_for("bob")
      assert read_msg.read == true
    end

    test "conversation filtering works correctly" do
      {:ok, _} = Auth.register("alice", "password123")
      {:ok, _} = Auth.register("bob", "password456")
      {:ok, _} = Auth.register("charlie", "password789")

      # Alice and Bob conversation
      Storage.add_message(Message.new("alice", "bob", "Hello Bob"))
      Storage.add_message(Message.new("bob", "alice", "Hi Alice"))

      # Alice and Charlie conversation
      Storage.add_message(Message.new("alice", "charlie", "Hello Charlie"))
      Storage.add_message(Message.new("charlie", "alice", "Hi Alice"))

      # Bob and Charlie conversation
      Storage.add_message(Message.new("bob", "charlie", "Hello Charlie"))

      # Check Alice-Bob conversation
      alice_bob = Storage.get_conversation("alice", "bob")
      assert length(alice_bob) == 2
      assert Enum.all?(alice_bob, fn msg ->
        (msg.from == "alice" and msg.to == "bob") or
        (msg.from == "bob" and msg.to == "alice")
      end)

      # Check Alice-Charlie conversation
      alice_charlie = Storage.get_conversation("alice", "charlie")
      assert length(alice_charlie) == 2

      # Check Bob-Charlie conversation
      bob_charlie = Storage.get_conversation("bob", "charlie")
      assert length(bob_charlie) == 1
    end
  end

  describe "user management" do
    test "lists all users correctly" do
      {:ok, _} = Auth.register("alice", "password123")
      {:ok, _} = Auth.register("bob", "password456")
      {:ok, _} = Auth.register("charlie", "password789")

      usernames = Storage.list_usernames()
      assert length(usernames) == 3
      assert "alice" in usernames
      assert "bob" in usernames
      assert "charlie" in usernames
    end

    test "retrieves user by username" do
      {:ok, _} = Auth.register("alice", "password123")

      user = Storage.get_user("alice")
      assert user != nil
      assert user.username == "alice"

      non_user = Storage.get_user("nonexistent")
      assert non_user == nil
    end
  end
end

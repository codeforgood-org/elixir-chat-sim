defmodule ChatSimulator.MessageTest do
  use ExUnit.Case, async: true
  doctest ChatSimulator.Message

  alias ChatSimulator.Message

  describe "new/3" do
    test "creates a message with all required fields" do
      message = Message.new("alice", "bob", "Hello!")

      assert message.from == "alice"
      assert message.to == "bob"
      assert message.content == "Hello!"
      assert message.id != nil
      assert message.timestamp != nil
      assert message.read == false
    end

    test "generates unique IDs for different messages" do
      msg1 = Message.new("alice", "bob", "Hello!")
      msg2 = Message.new("alice", "bob", "Hello!")

      assert msg1.id != msg2.id
    end
  end

  describe "mark_read/1" do
    test "marks message as read" do
      message = Message.new("alice", "bob", "Hello!")
      refute message.read

      read_message = Message.mark_read(message)
      assert read_message.read
    end
  end

  describe "format/1" do
    test "formats message with timestamp and sender" do
      message = Message.new("alice", "bob", "Hello!")
      formatted = Message.format(message)

      assert formatted =~ "alice:"
      assert formatted =~ "Hello!"
      assert formatted =~ "[NEW]"
    end

    test "does not show [NEW] indicator for read messages" do
      message = Message.new("alice", "bob", "Hello!") |> Message.mark_read()
      formatted = Message.format(message)

      refute formatted =~ "[NEW]"
    end
  end

  describe "valid_content?/1" do
    test "accepts valid content" do
      assert Message.valid_content?("Hello")
      assert Message.valid_content?("a")
      assert Message.valid_content?(String.duplicate("a", 500))
    end

    test "rejects invalid content" do
      refute Message.valid_content?("")
      refute Message.valid_content?(String.duplicate("a", 501))
    end
  end
end

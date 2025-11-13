#!/usr/bin/env elixir

# Example: Using the Chat Simulator API programmatically
#
# This script demonstrates how to use the Chat Simulator modules
# without the interactive CLI.
#
# Run with: elixir examples/api_usage.exs

# Add the lib directory to the code path
Code.prepend_path("_build/dev/lib/chat_simulator/ebin")

alias ChatSimulator.{Storage, Auth, Message}

IO.puts("🚀 Chat Simulator API Usage Example\n")

# Start the storage
IO.puts("Starting storage...")
{:ok, _pid} = Storage.start_link()

# Register some users
IO.puts("\n📝 Registering users...")

case Auth.register("alice", "password123") do
  {:ok, _user} -> IO.puts("✓ Registered alice")
  {:error, reason} -> IO.puts("✗ Failed to register alice: #{reason}")
end

case Auth.register("bob", "secret456") do
  {:ok, _user} -> IO.puts("✓ Registered bob")
  {:error, reason} -> IO.puts("✗ Failed to register bob: #{reason}")
end

case Auth.register("charlie", "pass789") do
  {:ok, _user} -> IO.puts("✓ Registered charlie")
  {:error, reason} -> IO.puts("✗ Failed to register charlie: #{reason}")
end

# List all users
IO.puts("\n👥 Registered users:")
Storage.list_usernames()
|> Enum.each(fn username ->
  IO.puts("  • #{username}")
end)

# Send some messages
IO.puts("\n💬 Sending messages...")

msg1 = Message.new("alice", "bob", "Hey Bob! How are you?")
Storage.add_message(msg1)
IO.puts("✓ Alice → Bob: #{msg1.content}")

msg2 = Message.new("bob", "alice", "Hi Alice! I'm doing great, thanks!")
Storage.add_message(msg2)
IO.puts("✓ Bob → Alice: #{msg2.content}")

msg3 = Message.new("charlie", "alice", "Hey Alice, want to grab coffee?")
Storage.add_message(msg3)
IO.puts("✓ Charlie → Alice: #{msg3.content}")

msg4 = Message.new("alice", "charlie", "Sure! When works for you?")
Storage.add_message(msg4)
IO.puts("✓ Alice → Charlie: #{msg4.content}")

# View Alice's inbox
IO.puts("\n📬 Alice's inbox:")
alice_messages = Storage.get_messages_for("alice")

if Enum.empty?(alice_messages) do
  IO.puts("  (empty)")
else
  Enum.each(alice_messages, fn msg ->
    IO.puts("  #{Message.format(msg)}")
  end)
end

IO.puts("\n  Total: #{length(alice_messages)} message(s)")
IO.puts("  Unread: #{Storage.count_unread("alice")} message(s)")

# View conversation between Alice and Bob
IO.puts("\n💬 Conversation between Alice and Bob:")
conversation = Storage.get_conversation("alice", "bob")

Enum.each(conversation, fn msg ->
  direction = if msg.from == "alice", do: "Alice → Bob", else: "Bob → Alice"
  IO.puts("  [#{Calendar.strftime(msg.timestamp, "%H:%M:%S")}] #{direction}: #{msg.content}")
end)

# Login test
IO.puts("\n🔐 Testing authentication...")

case Auth.login("alice", "password123") do
  {:ok, _user} -> IO.puts("✓ Alice logged in successfully")
  {:error, reason} -> IO.puts("✗ Login failed: #{reason}")
end

case Auth.login("alice", "wrongpassword") do
  {:ok, _user} -> IO.puts("✗ Should have failed with wrong password")
  {:error, _reason} -> IO.puts("✓ Correctly rejected wrong password")
end

# Statistics
IO.puts("\n📊 Statistics:")
IO.puts("  Total users: #{length(Storage.list_users())}")
IO.puts("  Total messages: #{length(Storage.get_messages_for("alice")) + length(Storage.get_messages_for("bob")) + length(Storage.get_messages_for("charlie"))}")

# Clean up
IO.puts("\n🧹 Cleaning up...")
Storage.stop()
Storage.clear()

IO.puts("\n✅ Example complete!")

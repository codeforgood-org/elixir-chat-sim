#!/usr/bin/env elixir

# Example: Automated chat simulation
#
# This script simulates a conversation between multiple users
# programmatically, useful for testing and demonstration.
#
# Run with: elixir examples/automated_chat.exs

Code.prepend_path("_build/dev/lib/chat_simulator/ebin")

alias ChatSimulator.{Storage, Auth, Message}

defmodule ChatBot do
  @moduledoc """
  Simple bot that generates automated responses
  """

  @responses [
    "That's interesting!",
    "Tell me more!",
    "I see what you mean.",
    "That makes sense.",
    "Great point!",
    "I agree!",
    "Hmm, let me think about that...",
    "That's a good question."
  ]

  def random_response do
    Enum.random(@responses)
  end
end

IO.puts("🤖 Automated Chat Simulation\n")

# Start storage
{:ok, _pid} = Storage.start_link()

# Register bot users
users = ["Alice", "Bob", "Charlie", "Diana"]

IO.puts("Creating users...")
Enum.each(users, fn username ->
  {:ok, _} = Auth.register(String.downcase(username), "password123")
  IO.puts("  ✓ #{username} joined the chat")
end)

IO.puts("\n💬 Starting conversation...\n")

# Simulate a conversation
conversations = [
  {"alice", "bob", "Hey Bob, how's the Elixir project going?"},
  {"bob", "alice", "It's going great! Just finished implementing the storage layer."},
  {"charlie", "alice", "Did someone mention Elixir? I love functional programming!"},
  {"alice", "charlie", "Yes! We're building a chat simulator. Want to help?"},
  {"charlie", "alice", ChatBot.random_response()},
  {"diana", "bob", "Bob, have you tried using Agents for state management?"},
  {"bob", "diana", "Yes! That's exactly what we're using. Great suggestion!"},
  {"alice", "diana", "Diana, you should join our code review tomorrow."},
  {"diana", "alice", "Count me in! What time?"},
  {"alice", "diana", "2 PM works for everyone."}
]

Enum.each(conversations, fn {from, to, content} ->
  msg = Message.new(from, to, content)
  Storage.add_message(msg)

  IO.puts("[#{String.capitalize(from)} → #{String.capitalize(to)}]")
  IO.puts("  #{content}\n")

  # Simulate typing delay
  Process.sleep(500)
end)

# Show statistics
IO.puts("\n📊 Conversation Statistics:")
IO.puts("  Total users: #{length(Storage.list_users())}")

Enum.each(users, fn username ->
  user_lower = String.downcase(username)
  inbox_count = length(Storage.get_messages_for(user_lower))
  unread_count = Storage.count_unread(user_lower)

  IO.puts("  #{username}: #{inbox_count} messages (#{unread_count} unread)")
end)

# Show a specific user's inbox
IO.puts("\n📬 Alice's full inbox:")
Storage.get_messages_for("alice")
|> Enum.each(fn msg ->
  IO.puts("  #{Message.format(msg)}")
end)

# Clean up
Storage.stop()
File.rm(".chat_data.etf")

IO.puts("\n✅ Simulation complete!")

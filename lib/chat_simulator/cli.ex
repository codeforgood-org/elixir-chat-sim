defmodule ChatSimulator.CLI do
  @moduledoc """
  Command-line interface for the Chat Simulator.

  Provides an interactive terminal-based chat application with user
  registration, authentication, and messaging capabilities.
  """

  alias ChatSimulator.{Auth, Message, Storage}

  @doc """
  Main entry point for the CLI application.
  """
  def main(_args \\ []) do
    {:ok, _pid} = Storage.start_link()

    IO.puts("\n" <> banner())
    IO.puts("Welcome to Terminal Chat!")
    IO.puts("Type 'help' for available commands\n")

    loop(nil)

    Storage.stop()
  end

  defp banner do
    """
    ╔═══════════════════════════════════════╗
    ║      CHAT SIMULATOR v0.1.0            ║
    ║      Terminal-based Chat System       ║
    ╚═══════════════════════════════════════╝
    """
  end

  # Main command loop
  defp loop(current_user) do
    display_prompt(current_user)

    case IO.gets("> ") |> String.trim() |> String.downcase() do
      "help" ->
        display_help(current_user)
        loop(current_user)

      "register" when is_nil(current_user) ->
        new_user = handle_register()
        loop(new_user)

      "login" when is_nil(current_user) ->
        logged_in_user = handle_login()
        loop(logged_in_user)

      "logout" when not is_nil(current_user) ->
        IO.puts("Logged out successfully.")
        loop(nil)

      "send" when not is_nil(current_user) ->
        handle_send_message(current_user)
        loop(current_user)

      "inbox" when not is_nil(current_user) ->
        handle_inbox(current_user)
        loop(current_user)

      "users" when not is_nil(current_user) ->
        handle_list_users()
        loop(current_user)

      "chat" when not is_nil(current_user) ->
        handle_chat(current_user)
        loop(current_user)

      "quit" ->
        IO.puts("Thank you for using Chat Simulator. Goodbye!")
        :ok

      "exit" ->
        IO.puts("Thank you for using Chat Simulator. Goodbye!")
        :ok

      "" ->
        loop(current_user)

      command when not is_nil(current_user) and command in ["register", "login"] ->
        IO.puts("You are already logged in. Please logout first.")
        loop(current_user)

      command when is_nil(current_user) and command in ["send", "inbox", "users", "chat"] ->
        IO.puts("Please login or register first.")
        loop(current_user)

      _unknown ->
        IO.puts("Invalid command. Type 'help' for available commands.")
        loop(current_user)
    end
  end

  defp display_prompt(nil) do
    IO.puts("\n[Not logged in]")
  end

  defp display_prompt(user) do
    unread_count = Storage.count_unread(user.username)
    unread_str = if unread_count > 0, do: " (#{unread_count} unread)", else: ""
    IO.puts("\n[#{user.username}#{unread_str}]")
  end

  defp display_help(nil) do
    IO.puts("""

    Available commands:
      register  - Create a new account
      login     - Login to existing account
      help      - Show this help message
      quit/exit - Exit the application
    """)
  end

  defp display_help(_user) do
    IO.puts("""

    Available commands:
      send      - Send a message to another user
      inbox     - View your messages
      chat      - View conversation with a specific user
      users     - List all registered users
      logout    - Logout from your account
      help      - Show this help message
      quit/exit - Exit the application
    """)
  end

  defp handle_register do
    IO.puts("\n--- User Registration ---")
    username = IO.gets("Choose a username: ") |> String.trim()
    password = IO.gets("Choose a password: ") |> String.trim()

    case Auth.register(username, password) do
      {:ok, user} ->
        IO.puts("✓ Registration successful! You are now logged in as #{username}.")
        user

      {:error, reason} ->
        IO.puts("✗ Registration failed: #{reason}")
        nil
    end
  end

  defp handle_login do
    IO.puts("\n--- User Login ---")
    username = IO.gets("Username: ") |> String.trim()
    password = IO.gets("Password: ") |> String.trim()

    case Auth.login(username, password) do
      {:ok, user} ->
        IO.puts("✓ Login successful! Welcome back, #{username}.")
        user

      {:error, reason} ->
        IO.puts("✗ Login failed: #{reason}")
        nil
    end
  end

  defp handle_send_message(from_user) do
    IO.puts("\n--- Send Message ---")
    to_username = IO.gets("To (username): ") |> String.trim()

    if to_username == from_user.username do
      IO.puts("✗ You cannot send a message to yourself.")
    else
      case Storage.get_user(to_username) do
        nil ->
          IO.puts("✗ User '#{to_username}' not found.")

        _user ->
          content = IO.gets("Message: ") |> String.trim()

          if Message.valid_content?(content) do
            message = Message.new(from_user.username, to_username, content)
            Storage.add_message(message)
            IO.puts("✓ Message sent to #{to_username}.")
          else
            IO.puts("✗ Invalid message. Must be 1-500 characters.")
          end
      end
    end
  end

  defp handle_inbox(user) do
    IO.puts("\n--- Your Inbox ---")
    messages = Storage.get_messages_for(user.username)

    if Enum.empty?(messages) do
      IO.puts("No messages in your inbox.")
    else
      Enum.each(messages, fn msg ->
        IO.puts(Message.format(msg))
      end)

      IO.puts("\n#{length(messages)} message(s) total")
    end
  end

  defp handle_list_users do
    IO.puts("\n--- Registered Users ---")
    usernames = Storage.list_usernames()

    if Enum.empty?(usernames) do
      IO.puts("No users registered yet.")
    else
      Enum.each(usernames, fn username ->
        IO.puts("  • #{username}")
      end)

      IO.puts("\n#{length(usernames)} user(s) registered")
    end
  end

  defp handle_chat(current_user) do
    IO.puts("\n--- Chat History ---")
    other_user = IO.gets("View conversation with (username): ") |> String.trim()

    if other_user == current_user.username do
      IO.puts("✗ You cannot view a chat with yourself.")
    else
      case Storage.get_user(other_user) do
        nil ->
          IO.puts("✗ User '#{other_user}' not found.")

        _user ->
          messages = Storage.get_conversation(current_user.username, other_user)

          if Enum.empty?(messages) do
            IO.puts("No messages in this conversation.")
          else
            IO.puts("Conversation with #{other_user}:")
            IO.puts(String.duplicate("-", 50))

            Enum.each(messages, fn msg ->
              direction = if msg.from == current_user.username, do: "You", else: other_user
              time_str = Calendar.strftime(msg.timestamp, "%Y-%m-%d %H:%M:%S")
              IO.puts("[#{time_str}] #{direction}: #{msg.content}")
            end)

            IO.puts("\n#{length(messages)} message(s) in conversation")
          end
      end
    end
  end
end

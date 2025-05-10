defmodule ChatSimulator do
  defmodule User do
    defstruct [:username, :password]
  end

  defmodule Message do
    defstruct [:from, :to, :content, :timestamp]
  end

  def start do
    IO.puts("Welcome to Terminal Chat!")
    loop([], [], nil)
  end

  # Main loop
  defp loop(users, messages, current_user) do
    if current_user do
      IO.puts("\nLogged in as: #{current_user.username}")
      IO.puts("Commands: send | inbox | logout | quit")
    else
      IO.puts("\nCommands: register | login | quit")
    end

    case IO.gets("> ") |> String.trim() do
      "register" ->
        {users, current_user} = register_user(users)
        loop(users, messages, current_user)

      "login" ->
        case login_user(users) do
          {:ok, user} -> loop(users, messages, user)
          :error -> loop(users, messages, nil)
        end

      "send" when current_user != nil ->
        messages = send_message(current_user, users, messages)
        loop(users, messages, current_user)

      "inbox" when current_user != nil ->
        view_inbox(current_user, messages)
        loop(users, messages, current_user)

      "logout" when current_user != nil ->
        IO.puts("Logged out.")
        loop(users, messages, nil)

      "quit" ->
        IO.puts("Exiting chat.")
        :ok

      _ ->
        IO.puts("Invalid command.")
        loop(users, messages, current_user)
    end
  end

  # User registration
  defp register_user(users) do
    username = IO.gets("Choose a username: ") |> String.trim()
    if Enum.any?(users, &(&1.username == username)) do
      IO.puts("Username already taken.")
      {users, nil}
    else
      password = IO.gets("Choose a password: ") |> String.trim()
      user = %User{username: username, password: password}
      IO.puts("Registered successfully and logged in.")
      {[user | users], user}
    end
  end

  # User login
  defp login_user(users) do
    username = IO.gets("Username: ") |> String.trim()
    password = IO.gets("Password: ") |> String.trim()

    case Enum.find(users, &(&1.username == username && &1.password == password)) do
      nil ->
        IO.puts("Login failed.")
        :error
      user ->
        IO.puts("Login successful.")
        {:ok, user}
    end
  end

  # Sending a message
  defp send_message(from_user, users, messages) do
    to_user = IO.gets("To: ") |> String.trim()
    if Enum.any?(users, &(&1.username == to_user)) do
      content = IO.gets("Message: ") |> String.trim()
      msg = %Message{
        from: from_user.username,
        to: to_user,
        content: content,
        timestamp: DateTime.utc_now() |> DateTime.to_string()
      }
      IO.puts("Message sent.")
      [msg | messages]
    else
      IO.puts("User not found.")
      messages
    end
  end

  # Viewing inbox
  defp view_inbox(user, messages) do
    user_messages =
      Enum.filter(messages, fn m -> m.to == user.username end)

    if user_messages == [] do
      IO.puts("No messages.")
    else
      IO.puts("\nYour messages:")
      Enum.each(Enum.reverse(user_messages), fn m ->
        IO.puts("[#{m.timestamp}] #{m.from}: #{m.content}")
      end)
    end
  end
end

ChatSimulator.start()

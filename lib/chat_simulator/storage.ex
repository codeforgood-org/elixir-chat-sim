defmodule ChatSimulator.Storage do
  @moduledoc """
  Handles data persistence for users and messages.

  This module uses an Agent to maintain state and provides optional
  file-based persistence for data durability.
  """

  use Agent

  alias ChatSimulator.User
  alias ChatSimulator.Message

  @storage_file ".chat_data.etf"

  @doc """
  Starts the storage agent.

  Loads data from disk if available, otherwise starts with empty state.
  """
  @spec start_link(keyword()) :: Agent.on_start()
  def start_link(_opts \\ []) do
    initial_state = load_from_disk() || %{users: [], messages: []}
    Agent.start_link(fn -> initial_state end, name: __MODULE__)
  end

  @doc """
  Stops the storage agent and saves data to disk.
  """
  @spec stop() :: :ok
  def stop do
    save_to_disk()
    Agent.stop(__MODULE__)
  end

  # User operations

  @doc """
  Adds a new user to storage.
  """
  @spec add_user(User.t()) :: :ok
  def add_user(user) do
    Agent.update(__MODULE__, fn state ->
      %{state | users: [user | state.users]}
    end)

    save_to_disk()
    :ok
  end

  @doc """
  Retrieves a user by username.
  """
  @spec get_user(String.t()) :: User.t() | nil
  def get_user(username) do
    Agent.get(__MODULE__, fn state ->
      Enum.find(state.users, &(&1.username == username))
    end)
  end

  @doc """
  Lists all registered users.
  """
  @spec list_users() :: [User.t()]
  def list_users do
    Agent.get(__MODULE__, fn state -> state.users end)
  end

  @doc """
  Gets usernames of all registered users.
  """
  @spec list_usernames() :: [String.t()]
  def list_usernames do
    Agent.get(__MODULE__, fn state ->
      Enum.map(state.users, & &1.username)
    end)
  end

  # Message operations

  @doc """
  Adds a new message to storage.
  """
  @spec add_message(Message.t()) :: :ok
  def add_message(message) do
    Agent.update(__MODULE__, fn state ->
      %{state | messages: [message | state.messages]}
    end)

    save_to_disk()
    :ok
  end

  @doc """
  Retrieves all messages for a specific recipient.
  """
  @spec get_messages_for(String.t()) :: [Message.t()]
  def get_messages_for(username) do
    Agent.get(__MODULE__, fn state ->
      state.messages
      |> Enum.filter(&(&1.to == username))
      |> Enum.reverse()
    end)
  end

  @doc """
  Retrieves conversation between two users.
  """
  @spec get_conversation(String.t(), String.t()) :: [Message.t()]
  def get_conversation(user1, user2) do
    Agent.get(__MODULE__, fn state ->
      state.messages
      |> Enum.filter(fn msg ->
        (msg.from == user1 and msg.to == user2) or
          (msg.from == user2 and msg.to == user1)
      end)
      |> Enum.reverse()
    end)
  end

  @doc """
  Marks a message as read.
  """
  @spec mark_message_read(String.t()) :: :ok
  def mark_message_read(message_id) do
    Agent.update(__MODULE__, fn state ->
      messages =
        Enum.map(state.messages, fn msg ->
          if msg.id == message_id, do: Message.mark_read(msg), else: msg
        end)

      %{state | messages: messages}
    end)

    save_to_disk()
    :ok
  end

  @doc """
  Counts unread messages for a user.
  """
  @spec count_unread(String.t()) :: non_neg_integer()
  def count_unread(username) do
    Agent.get(__MODULE__, fn state ->
      state.messages
      |> Enum.filter(&(&1.to == username and not &1.read))
      |> length()
    end)
  end

  # Persistence operations

  defp save_to_disk do
    Agent.get(__MODULE__, fn state ->
      File.write(@storage_file, :erlang.term_to_binary(state))
      state
    end)
  end

  defp load_from_disk do
    case File.read(@storage_file) do
      {:ok, binary} ->
        :erlang.binary_to_term(binary)

      {:error, _} ->
        nil
    end
  end

  @doc """
  Clears all data from storage (useful for testing).
  """
  @spec clear() :: :ok
  def clear do
    Agent.update(__MODULE__, fn _state ->
      %{users: [], messages: []}
    end)

    File.rm(@storage_file)
    :ok
  end
end

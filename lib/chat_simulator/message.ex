defmodule ChatSimulator.Message do
  @moduledoc """
  Represents a message in the chat system.

  Messages are sent from one user to another with content and a timestamp.
  """

  @enforce_keys [:from, :to, :content, :timestamp]
  defstruct [:id, :from, :to, :content, :timestamp, :read]

  @type t :: %__MODULE__{
          id: String.t(),
          from: String.t(),
          to: String.t(),
          content: String.t(),
          timestamp: DateTime.t(),
          read: boolean()
        }

  @doc """
  Creates a new message.

  ## Parameters

    - from: Username of the sender
    - to: Username of the recipient
    - content: Message content

  ## Examples

      iex> ChatSimulator.Message.new("alice", "bob", "Hello!")
      %ChatSimulator.Message{from: "alice", to: "bob", content: "Hello!", ...}
  """
  @spec new(String.t(), String.t(), String.t()) :: t()
  def new(from, to, content) do
    %__MODULE__{
      id: generate_id(),
      from: from,
      to: to,
      content: content,
      timestamp: DateTime.utc_now(),
      read: false
    }
  end

  @doc """
  Marks a message as read.

  ## Parameters

    - message: The message to mark as read

  ## Examples

      iex> message = ChatSimulator.Message.new("alice", "bob", "Hello!")
      iex> ChatSimulator.Message.mark_read(message)
      %ChatSimulator.Message{read: true, ...}
  """
  @spec mark_read(t()) :: t()
  def mark_read(message) do
    %{message | read: true}
  end

  @doc """
  Formats a message for display.

  ## Parameters

    - message: The message to format

  ## Examples

      iex> message = ChatSimulator.Message.new("alice", "bob", "Hello!")
      iex> ChatSimulator.Message.format(message)
      "[2025-11-13 10:30:45] alice: Hello!"
  """
  @spec format(t()) :: String.t()
  def format(%__MODULE__{from: from, content: content, timestamp: timestamp, read: read}) do
    time_str = Calendar.strftime(timestamp, "%Y-%m-%d %H:%M:%S")
    read_indicator = if read, do: "", else: " [NEW]"
    "[#{time_str}] #{from}: #{content}#{read_indicator}"
  end

  @doc """
  Validates message content.

  Content must be:
  - Non-empty
  - Less than 500 characters

  ## Examples

      iex> ChatSimulator.Message.valid_content?("Hello!")
      true

      iex> ChatSimulator.Message.valid_content?("")
      false
  """
  @spec valid_content?(String.t()) :: boolean()
  def valid_content?(content) do
    String.length(content) > 0 and String.length(content) <= 500
  end

  # Generates a unique ID for messages
  defp generate_id do
    :crypto.strong_rand_bytes(16)
    |> Base.url_encode64()
  end
end

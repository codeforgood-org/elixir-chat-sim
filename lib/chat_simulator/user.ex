defmodule ChatSimulator.User do
  @moduledoc """
  Represents a user in the chat system.

  Users have a username and a hashed password for authentication.
  """

  @enforce_keys [:username, :password_hash]
  defstruct [:username, :password_hash, :created_at]

  @type t :: %__MODULE__{
          username: String.t(),
          password_hash: String.t(),
          created_at: DateTime.t()
        }

  @doc """
  Creates a new user with a hashed password.

  ## Parameters

    - username: The username for the new user
    - password: The plain text password (will be hashed)

  ## Examples

      iex> ChatSimulator.User.new("alice", "secret123")
      %ChatSimulator.User{username: "alice", ...}
  """
  @spec new(String.t(), String.t()) :: t()
  def new(username, password) do
    %__MODULE__{
      username: username,
      password_hash: hash_password(password),
      created_at: DateTime.utc_now()
    }
  end

  @doc """
  Verifies if a password matches the user's stored password hash.

  ## Parameters

    - user: The user struct
    - password: The plain text password to verify

  ## Examples

      iex> user = ChatSimulator.User.new("alice", "secret123")
      iex> ChatSimulator.User.verify_password(user, "secret123")
      true
  """
  @spec verify_password(t(), String.t()) :: boolean()
  def verify_password(%__MODULE__{password_hash: hash}, password) do
    hash_password(password) == hash
  end

  @doc """
  Validates a username according to chat system rules.

  Usernames must be:
  - Between 3 and 20 characters
  - Alphanumeric with underscores allowed
  - Start with a letter

  ## Examples

      iex> ChatSimulator.User.valid_username?("alice")
      true

      iex> ChatSimulator.User.valid_username?("ab")
      false
  """
  @spec valid_username?(String.t()) :: boolean()
  def valid_username?(username) do
    String.length(username) >= 3 and
      String.length(username) <= 20 and
      Regex.match?(~r/^[a-zA-Z][a-zA-Z0-9_]*$/, username)
  end

  @doc """
  Validates a password according to security requirements.

  Passwords must be at least 6 characters long.

  ## Examples

      iex> ChatSimulator.User.valid_password?("secret123")
      true

      iex> ChatSimulator.User.valid_password?("abc")
      false
  """
  @spec valid_password?(String.t()) :: boolean()
  def valid_password?(password) do
    String.length(password) >= 6
  end

  # Private function to hash passwords using SHA256
  defp hash_password(password) do
    :crypto.hash(:sha256, password)
    |> Base.encode16()
  end
end

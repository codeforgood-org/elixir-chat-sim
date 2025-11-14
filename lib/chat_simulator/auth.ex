defmodule ChatSimulator.Auth do
  @moduledoc """
  Handles user authentication and registration.

  This module provides functions for user registration, login, and session management.
  """

  alias ChatSimulator.User
  alias ChatSimulator.Storage

  @doc """
  Registers a new user.

  ## Parameters

    - username: The desired username
    - password: The password for the account

  ## Returns

    - `{:ok, user}` if registration is successful
    - `{:error, reason}` if registration fails

  ## Examples

      iex> ChatSimulator.Auth.register("alice", "secret123")
      {:ok, %ChatSimulator.User{username: "alice"}}
  """
  @spec register(String.t(), String.t()) :: {:ok, User.t()} | {:error, String.t()}
  def register(username, password) do
    with true <- User.valid_username?(username),
         true <- User.valid_password?(password),
         false <- user_exists?(username) do
      user = User.new(username, password)
      Storage.add_user(user)
      {:ok, user}
    else
      false when not User.valid_username?(username) ->
        {:error, "Invalid username. Must be 3-20 characters, alphanumeric, start with a letter."}

      false when not User.valid_password?(password) ->
        {:error, "Invalid password. Must be at least 6 characters."}

      true ->
        {:error, "Username already taken."}
    end
  end

  @doc """
  Logs in a user.

  ## Parameters

    - username: The username
    - password: The password

  ## Returns

    - `{:ok, user}` if login is successful
    - `{:error, reason}` if login fails

  ## Examples

      iex> ChatSimulator.Auth.login("alice", "secret123")
      {:ok, %ChatSimulator.User{username: "alice"}}
  """
  @spec login(String.t(), String.t()) :: {:ok, User.t()} | {:error, String.t()}
  def login(username, password) do
    case Storage.get_user(username) do
      nil ->
        {:error, "Invalid username or password."}

      user ->
        if User.verify_password(user, password) do
          {:ok, user}
        else
          {:error, "Invalid username or password."}
        end
    end
  end

  @doc """
  Checks if a user exists.

  ## Parameters

    - username: The username to check

  ## Examples

      iex> ChatSimulator.Auth.user_exists?("alice")
      true
  """
  @spec user_exists?(String.t()) :: boolean()
  def user_exists?(username) do
    Storage.get_user(username) != nil
  end
end

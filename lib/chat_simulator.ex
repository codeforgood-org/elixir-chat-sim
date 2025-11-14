defmodule ChatSimulator do
  @moduledoc """
  A terminal-based chat simulator for learning Elixir.

  ChatSimulator provides a simple but complete chat application that runs in
  the terminal. It demonstrates key Elixir concepts including:

  - Pattern matching and guards
  - Structs and protocols
  - GenServer/Agent for state management
  - File I/O for data persistence
  - Module design and organization
  - Documentation and testing

  ## Features

  - User registration and authentication
  - Password hashing for security
  - Send and receive messages
  - View inbox and conversation history
  - List registered users
  - Persistent storage

  ## Getting Started

  To run the chat simulator:

      $ mix deps.get
      $ mix escript.build
      $ ./chat_simulator

  Or run directly with Mix:

      $ mix run -e "ChatSimulator.CLI.main()"

  ## Architecture

  The application is organized into several modules:

  - `ChatSimulator.User` - User data structure and validation
  - `ChatSimulator.Message` - Message data structure and formatting
  - `ChatSimulator.Auth` - Authentication and registration logic
  - `ChatSimulator.Storage` - Data persistence using Agent
  - `ChatSimulator.CLI` - Command-line interface

  ## Examples

      # Start the application
      iex> ChatSimulator.CLI.main()

      # Or use the API directly
      iex> {:ok, _} = ChatSimulator.Storage.start_link()
      iex> {:ok, user} = ChatSimulator.Auth.register("alice", "password123")
      iex> {:ok, user} = ChatSimulator.Auth.login("alice", "password123")
  """

  alias ChatSimulator.{Auth, Message, Storage, User}

  @doc """
  Convenience function to start the chat simulator.
  """
  def start do
    ChatSimulator.CLI.main()
  end

  # Re-export commonly used functions for convenience

  @doc """
  Registers a new user. See `ChatSimulator.Auth.register/2`.
  """
  defdelegate register(username, password), to: Auth

  @doc """
  Logs in a user. See `ChatSimulator.Auth.login/2`.
  """
  defdelegate login(username, password), to: Auth

  @doc """
  Creates a new message. See `ChatSimulator.Message.new/3`.
  """
  defdelegate new_message(from, to, content), to: Message, as: :new

  @doc """
  Creates a new user. See `ChatSimulator.User.new/2`.
  """
  defdelegate new_user(username, password), to: User, as: :new
end

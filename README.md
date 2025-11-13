# Chat Simulator

[![CI](https://github.com/codeforgood-org/elixir-chat-sim/workflows/CI/badge.svg)](https://github.com/codeforgood-org/elixir-chat-sim/actions)
[![Elixir](https://img.shields.io/badge/Elixir-1.14%20to%201.16-blueviolet.svg)](https://elixir-lang.org/)
[![Erlang/OTP](https://img.shields.io/badge/Erlang%2FOTP-25%20to%2026-red.svg)](https://www.erlang.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A terminal-based chat application written in Elixir for learning and demonstration purposes.

## Features

- **User Management**
  - Secure registration with username validation
  - Password hashing using SHA256
  - Session management

- **Messaging**
  - Send messages to other users
  - View inbox with unread message indicators
  - View conversation history between users
  - Message timestamps

- **Data Persistence**
  - Automatic saving to disk
  - State maintained between sessions
  - Agent-based in-memory storage

- **User Experience**
  - Interactive CLI with clear prompts
  - List all registered users
  - Unread message counter
  - Command help system

## Installation

### Prerequisites

- Elixir 1.14 or higher
- Erlang/OTP 24 or higher

### Quick Setup

Use the automated setup script:
```bash
./scripts/setup.sh
```

Or manually:

1. Clone the repository:
```bash
git clone https://github.com/codeforgood-org/elixir-chat-sim.git
cd elixir-chat-sim
```

2. Install dependencies:
```bash
mix deps.get
```

3. Run tests to verify installation:
```bash
mix test
```

## Usage

### Running the Application

#### Option 1: Using Mix (Development)

```bash
mix run -e "ChatSimulator.CLI.main()"
```

#### Option 2: Build Executable (Production)

```bash
mix escript.build
./chat_simulator
```

#### Option 3: Docker

```bash
docker-compose up
```

Or build manually:
```bash
./scripts/docker-build.sh
docker run -it --rm chat-simulator:latest
```

### Commands

When not logged in:
- `register` - Create a new account
- `login` - Login to existing account
- `help` - Show available commands
- `quit` or `exit` - Exit the application

When logged in:
- `send` - Send a message to another user
- `inbox` - View your messages
- `chat` - View conversation with a specific user
- `users` - List all registered users
- `logout` - Logout from your account
- `help` - Show available commands
- `quit` or `exit` - Exit the application

### Example Session

```
╔═══════════════════════════════════════╗
║      CHAT SIMULATOR v0.1.0            ║
║      Terminal-based Chat System       ║
╚═══════════════════════════════════════╝
Welcome to Terminal Chat!
Type 'help' for available commands

[Not logged in]
> register
Choose a username: alice
Choose a password: secret123
✓ Registration successful! You are now logged in as alice.

[alice]
> users
--- Registered Users ---
  • alice
1 user(s) registered

[alice]
> send
--- Send Message ---
To (username): bob
✗ User 'bob' not found.

[alice]
> logout
Logged out successfully.

[Not logged in]
> quit
Thank you for using Chat Simulator. Goodbye!
```

## Architecture

The application is organized into modular components:

```
lib/
├── chat_simulator.ex           # Main module with convenience functions
└── chat_simulator/
    ├── auth.ex                 # Authentication and registration
    ├── cli.ex                  # Command-line interface
    ├── message.ex              # Message struct and operations
    ├── storage.ex              # Data persistence with Agent
    └── user.ex                 # User struct and validation
```

### Module Overview

- **ChatSimulator** - Main module providing high-level API
- **ChatSimulator.User** - User data structure with password hashing
- **ChatSimulator.Message** - Message data structure with formatting
- **ChatSimulator.Auth** - Registration and login logic
- **ChatSimulator.Storage** - Agent-based storage with file persistence
- **ChatSimulator.CLI** - Interactive command-line interface

## Development

### Running Tests

Run all tests:
```bash
mix test
```

Run tests with coverage:
```bash
mix test --cover
```

Run specific test file:
```bash
mix test test/chat_simulator/user_test.exs
```

### Code Quality

Run all checks at once:
```bash
./scripts/test.sh
```

Or individually:

Format code:
```bash
mix format
```

Run static analysis:
```bash
mix credo
```

Run dialyzer (type checking):
```bash
mix dialyzer
```

Clean build artifacts:
```bash
./scripts/clean.sh
```

### Generating Documentation

```bash
mix docs
```

Then open `doc/index.html` in your browser.

## Project Structure

```
elixir-chat-sim/
├── lib/                      # Application code
│   ├── chat_simulator.ex
│   └── chat_simulator/
│       ├── auth.ex          # Authentication
│       ├── cli.ex           # Command-line interface
│       ├── message.ex       # Message handling
│       ├── storage.ex       # Data persistence
│       └── user.ex          # User management
├── test/                     # Test suite
│   ├── test_helper.exs
│   ├── integration_test.exs
│   └── chat_simulator/
│       ├── auth_test.exs
│       ├── message_test.exs
│       ├── storage_test.exs
│       └── user_test.exs
├── config/                   # Configuration
│   ├── config.exs
│   ├── dev.exs
│   ├── test.exs
│   ├── prod.exs
│   └── runtime.exs
├── scripts/                  # Helper scripts
│   ├── setup.sh
│   ├── test.sh
│   ├── clean.sh
│   └── docker-build.sh
├── examples/                 # Usage examples
│   ├── api_usage.exs
│   └── automated_chat.exs
├── .github/                  # GitHub configs
│   ├── workflows/
│   │   └── ci.yml
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── dependabot.yml
├── Dockerfile
├── docker-compose.yml
├── .formatter.exs
├── .credo.exs
├── CHANGELOG.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── SECURITY.md
├── LICENSE
├── mix.exs
└── README.md
```

## Security Considerations

- Passwords are hashed using SHA256 before storage
- No plain-text passwords are stored
- User input is validated before processing
- Message content is limited to 500 characters

**Note:** This is an educational project. For production use, consider:
- Using a more robust password hashing algorithm (bcrypt, argon2)
- Adding rate limiting
- Implementing proper session tokens
- Adding encryption for stored data
- Input sanitization for XSS prevention

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## Examples

Check out the `examples/` directory for:

- **api_usage.exs** - Using the API programmatically
- **automated_chat.exs** - Simulated multi-user conversations

Run examples:
```bash
mix compile
elixir examples/api_usage.exs
elixir examples/automated_chat.exs
```

## Learning Resources

This project demonstrates several Elixir concepts:

1. **Structs** - Data structures for Users and Messages
2. **Pattern Matching** - Command parsing and data extraction
3. **Guards** - Function clause selection based on conditions
4. **Agents** - State management for storage
5. **Configuration** - Environment-specific settings
6. **Logging** - Application logging with Logger
7. **File I/O** - Data persistence
8. **Documentation** - Module and function documentation
9. **Testing** - Comprehensive test suite with ExUnit
10. **CI/CD** - Automated testing and deployment

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [Elixir](https://elixir-lang.org/)
- Created for educational purposes by codeforgood-org
- Inspired by classic terminal chat applications

## Roadmap

Potential future enhancements:

- [ ] Group chat functionality
- [ ] Message encryption
- [ ] User blocking/privacy features
- [ ] Message editing and deletion
- [ ] File attachments
- [ ] User profiles and status
- [ ] Network-based client-server architecture
- [ ] Web interface with Phoenix
- [ ] Message search functionality
- [ ] Emoji support

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Submit a pull request
- Contact: codeforgood-org

---

**Happy Chatting!** 💬

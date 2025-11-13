# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Complete project reorganization from single file to modular structure
- Configuration management for different environments (dev, test, prod)
- Comprehensive logging throughout the application
- Docker support with multi-stage builds
- GitHub issue and PR templates
- Security policy
- Dependabot configuration
- Example usage scripts
- Integration tests
- Helper development scripts

## [0.1.0] - 2025-11-13

### Added
- Initial Mix project structure with proper organization
- Modular architecture with 6 core modules:
  - `ChatSimulator.User` - User management and validation
  - `ChatSimulator.Message` - Message handling and formatting
  - `ChatSimulator.Auth` - Authentication and registration
  - `ChatSimulator.Storage` - Agent-based data persistence
  - `ChatSimulator.CLI` - Interactive command-line interface
  - `ChatSimulator` - Main module with convenience functions
- Password hashing using SHA256 for security
- User registration with username and password validation
- Message sending between users
- Inbox viewing with unread message indicators
- Conversation history viewing
- List all registered users
- Message read/unread tracking
- File-based data persistence
- Comprehensive ExUnit test suite
- Module and function documentation with @doc and @spec
- Code formatting configuration (.formatter.exs)
- Credo static analysis configuration
- GitHub Actions CI/CD workflow
- Multi-version testing (Elixir 1.14-1.16, OTP 25-26)
- Escript build support for standalone executable
- README with installation and usage instructions
- CONTRIBUTING.md with development guidelines
- LICENSE (MIT)

### Security
- Implemented password hashing instead of plain text storage
- Added input validation for usernames and passwords
- Message content length limits

## [0.0.1] - Initial Release

### Added
- Basic single-file chat simulator
- User registration and login
- Simple message sending
- Basic inbox viewing
- Plain text password storage (insecure)

[Unreleased]: https://github.com/codeforgood-org/elixir-chat-sim/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/codeforgood-org/elixir-chat-sim/releases/tag/v0.1.0
[0.0.1]: https://github.com/codeforgood-org/elixir-chat-sim/releases/tag/v0.0.1

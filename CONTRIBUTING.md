# Contributing to Chat Simulator

Thank you for your interest in contributing to Chat Simulator! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue on GitHub with:

1. A clear, descriptive title
2. Steps to reproduce the issue
3. Expected behavior
4. Actual behavior
5. Your environment (Elixir version, OS, etc.)
6. Any relevant error messages or logs

### Suggesting Enhancements

We welcome enhancement suggestions! Please open an issue with:

1. A clear description of the enhancement
2. Use cases and benefits
3. Potential implementation approach (optional)
4. Any relevant examples or mockups

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following our coding standards
3. **Add tests** for any new functionality
4. **Update documentation** as needed
5. **Run the test suite** to ensure all tests pass
6. **Run code quality tools** (formatter, credo)
7. **Submit a pull request** with a clear description

## Development Setup

1. Clone your fork:
```bash
git clone https://github.com/YOUR_USERNAME/elixir-chat-sim.git
cd elixir-chat-sim
```

2. Install dependencies:
```bash
mix deps.get
```

3. Run tests:
```bash
mix test
```

## Coding Standards

### Style Guide

- Follow the [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)
- Use `mix format` to format your code
- Run `mix credo` to check for code quality issues
- Keep functions small and focused
- Use descriptive variable and function names

### Documentation

- Add `@moduledoc` for all modules
- Add `@doc` for all public functions
- Include `@spec` type specifications
- Provide examples in documentation
- Update README.md for user-facing changes

### Testing

- Write tests for all new functionality
- Maintain or improve test coverage
- Use descriptive test names
- Follow the AAA pattern (Arrange, Act, Assert)
- Keep tests focused and independent

Example test structure:
```elixir
describe "function_name/arity" do
  test "describes what it should do" do
    # Arrange
    input = setup_test_data()

    # Act
    result = MyModule.function_name(input)

    # Assert
    assert result == expected_output
  end
end
```

## Code Quality Checks

Before submitting a PR, run:

```bash
# Format code
mix format

# Run tests
mix test

# Check code quality
mix credo

# Run dialyzer (optional but recommended)
mix dialyzer
```

## Commit Messages

Write clear, concise commit messages:

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and PRs when relevant

Good examples:
```
Add user blocking feature

Implement message search functionality

Fix password validation bug (#123)

Update README with new installation instructions
```

## Branch Naming

Use descriptive branch names:

- `feature/add-group-chat` - New features
- `fix/login-validation` - Bug fixes
- `docs/update-readme` - Documentation updates
- `refactor/storage-module` - Code refactoring
- `test/auth-coverage` - Test improvements

## Project Structure

```
lib/chat_simulator/
├── auth.ex       # Authentication logic
├── cli.ex        # Command-line interface
├── message.ex    # Message data structure
├── storage.ex    # Data persistence
└── user.ex       # User data structure
```

When adding new features:
- Place new modules in `lib/chat_simulator/`
- Add corresponding tests in `test/chat_simulator/`
- Update main module documentation if needed

## Testing Guidelines

### Unit Tests

- Test individual functions in isolation
- Mock external dependencies
- Cover edge cases and error conditions

### Integration Tests

- Test module interactions
- Verify data flow between components
- Test the full user workflow where applicable

### Running Tests

```bash
# Run all tests
mix test

# Run specific test file
mix test test/chat_simulator/user_test.exs

# Run tests with coverage
mix test --cover

# Run tests matching a pattern
mix test --only auth
```

## Documentation

### Generating Documentation

```bash
mix docs
```

Then open `doc/index.html` in your browser.

### Documentation Style

```elixir
@doc """
Brief one-line description.

Longer description providing context and details about
the function's behavior, edge cases, and considerations.

## Parameters

  - param1: Description of first parameter
  - param2: Description of second parameter

## Returns

Description of return value(s)

## Examples

    iex> MyModule.my_function("input")
    "expected output"

    iex> MyModule.my_function("")
    {:error, "validation error"}
"""
@spec my_function(String.t()) :: String.t() | {:error, String.t()}
def my_function(param1) do
  # implementation
end
```

## Feature Development Workflow

1. **Discuss**: Open an issue to discuss the feature
2. **Design**: Plan the implementation approach
3. **Implement**: Write code following standards
4. **Test**: Add comprehensive tests
5. **Document**: Update relevant documentation
6. **Review**: Submit PR and address feedback
7. **Merge**: Maintainers will merge when ready

## Getting Help

- Open an issue for questions
- Check existing issues and PRs
- Review the README and documentation
- Reach out to maintainers

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes for significant contributions
- README acknowledgments section (for major features)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Chat Simulator! Your efforts help make this project better for everyone.

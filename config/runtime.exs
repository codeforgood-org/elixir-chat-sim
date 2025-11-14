import Config

# Runtime configuration (loaded at application startup)

if config_env() == :prod do
  # Production runtime configuration
  config :chat_simulator, :storage,
    file: System.get_env("CHAT_DATA_FILE") || ".chat_data.etf"
end

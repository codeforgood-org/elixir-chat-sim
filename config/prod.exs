import Config

# Production environment configuration

config :chat_simulator, :storage,
  file: System.get_env("CHAT_DATA_FILE", ".chat_data.etf"),
  auto_save: true

config :logger, :console,
  level: :info

import Config

# Development environment configuration

config :chat_simulator, :storage,
  file: ".chat_data_dev.etf",
  auto_save: true

config :logger, :console,
  level: :debug

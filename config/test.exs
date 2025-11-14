import Config

# Test environment configuration

config :chat_simulator, :storage,
  file: ".chat_data_test.etf",
  auto_save: false

config :logger, :console,
  level: :warn

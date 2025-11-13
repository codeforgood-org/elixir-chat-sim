import Config

# Configuration for Chat Simulator

# Storage configuration
config :chat_simulator, :storage,
  file: ".chat_data.etf",
  auto_save: true

# User validation rules
config :chat_simulator, :user,
  min_username_length: 3,
  max_username_length: 20,
  min_password_length: 6

# Message validation rules
config :chat_simulator, :message,
  max_content_length: 500

# Logging configuration
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config
import_config "#{config_env()}.exs"

import Config

config :money,
  default_currency: :GBP

config :cashier, env: config_env()

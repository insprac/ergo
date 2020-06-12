use Mix.Config

config :ergo, ErgoWeb.Endpoint,
  pubsub_server: Ergo.PubSub,
  render_errors: [
    view: ErgoWeb.ErrorView,
    accepts: ~w(html json),
    layout: false
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :user_id]

config :phoenix, :json_library, Jason

if Mix.env() == :prod do
  config :ergo, :config_prefix, "ergo_"
else
  config :ergo, :config_prefix, "ergo_#{Mix.env()}_"
end

import_config "#{Mix.env()}.exs"

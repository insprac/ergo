use Mix.Config

config :ergo, ErgoWeb.Endpoint,
  ache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

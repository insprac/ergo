defmodule ErgoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :ergo

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_ergo_key",
    signing_salt: "7PeOVX1/"
  ]

  socket "/socket", ErgoWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :ergo,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ErgoWeb.Router

  def init(_key, options) do
    host = Ergo.Config.get!(:web_host)
    port = Ergo.Config.get!(:web_port)
    secret_key_base = Ergo.Config.get!(:web_secret_key_base)
    live_view_signing_salt = Ergo.Config.get!(:web_live_view_signing_salt)
    options =
      Keyword.merge(options, [
        http: [:inet6, port: port],
        url: [host: host, port: port],
        secret_key_base: secret_key_base,
        live_view: [signing_salt: live_view_signing_salt]
      ])
    {:ok, options}
  end
end

defmodule Ergo.Config do
  import Cony

  config env_prefix: Application.get_env(:ergo, :config_prefix) do
    add :web_host, :string
    add :web_port, :integer
    add :web_secret_key_base, :string
    add :web_live_view_signing_salt, :string
  end
end

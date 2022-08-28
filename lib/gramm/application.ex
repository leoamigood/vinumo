defmodule Gramm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    webhook_config = [
      host: Application.fetch_env!(:gramm, :host),
      local_port: Application.fetch_env!(:gramm, :local_port)
    ]

    bot_config = [
      token: Application.fetch_env!(:gramm, :token_bot),
      max_bot_concurrency: Application.fetch_env!(:gramm, :max_bot_concurrency)
    ]

    children = [
      # Start the Ecto repository
      Gramm.Repo,
      # Start the Telemetry supervisor
      GrammWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gramm.PubSub},
      # Start the Endpoint (http/https)
      GrammWeb.Endpoint,
      # Start a worker by calling: Gramm.Worker.start_link(arg)
      # {Gramm.Worker, arg}
      {Telegram.Webhook, config: webhook_config, bots: [{Gramm.Bot.Counter, bot_config}]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gramm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GrammWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

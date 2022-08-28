defmodule Gramm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Gramm.Repo,
      # Start the Telemetry supervisor
      GrammWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gramm.PubSub},
      # Start the Endpoint (http/https)
      GrammWeb.Endpoint
      # Start a worker by calling: Gramm.Worker.start_link(arg)
      # {Gramm.Worker, arg}
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

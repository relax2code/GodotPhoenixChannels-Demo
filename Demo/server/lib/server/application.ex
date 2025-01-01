defmodule GodotServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GodotServerWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GodotServer.PubSub},
      GodotServerWeb.Presence,
      # Start a worker by calling: GodotServer.Worker.start_link(arg)
      # {GodotServer.Worker, arg},
      # Start to serve requests, typically the last entry
      GodotServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GodotServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GodotServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

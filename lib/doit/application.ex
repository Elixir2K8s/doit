defmodule Doit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    #Cluster.Strategy.Epmd -> works with DNS or IP maybe better?
    topologies = Application.get_env(:libcluster, :topologies) || [
      doit: [
        strategy: Cluster.Strategy.Gossip,
        #config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]],
      ]
    ]



    children = [
      #libcluster supervisor
      {Cluster.Supervisor, [topologies, [name: Doit.ClusterSupervisor]]},
      # Start the Ecto repository
      Doit.Repo,
      # Start the Telemetry supervisor
      DoitWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Doit.PubSub},
      # Start the Endpoint (http/https)
      DoitWeb.Endpoint
      # Start a worker by calling: Doit.Worker.start_link(arg)
      # {Doit.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Doit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DoitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

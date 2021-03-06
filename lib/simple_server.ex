defmodule SimpleServer do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application
  import Plug.Adapters.Cowboy
  require Logger
  import Supervisor.Spec
  alias SimpleServer.Repo

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: SimpleServer.Worker.start_link(arg)
      # {SimpleServer.Worker, arg}
      worker(Repo, []),
      child_spec(scheme: :http, plug: SimpleServer.Router, options: [port: Application.fetch_env!(:simple_server, :port)])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleServer.Supervisor]
    Logger.info("Starting application...")
    # connect()
    Supervisor.start_link(children, opts)
  end
end

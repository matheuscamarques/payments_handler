defmodule PaymentsHandler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias PaymentsHandler.Db.Engines.EventsMap
  alias PaymentsHandler.Db.Engines.EventsEts
  alias PaymentsHandler.Db.Engines.EventsList
  alias PaymentsHandler.Db.Engines.EventsTree

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Supervisor.child_spec(
        {PaymentsHandler.Db.EventsServer, name: EventsServer, strategy: EventsTree},
        id: :default_events_engine
      ),
      Supervisor.child_spec(
        {PaymentsHandler.Db.EventsServer, name: ListEventsServer, strategy: EventsList},
        id: :list_events_engine
      ),
      Supervisor.child_spec(
        {PaymentsHandler.Db.EventsServer, name: EtsEventsServer, strategy: EventsEts},
        id: :ets_events_engine
      ),
      Supervisor.child_spec(
        {PaymentsHandler.Db.EventsServer, name: MapEventsServer, strategy: EventsMap},
        id: :map_events_engine
      ),
      # Start the Telemetry supervisor
      PaymentsHandlerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PaymentsHandler.PubSub},
      # Start Finch
      {Finch, name: PaymentsHandler.Finch},
      # Start the Endpoint (http/https)
      PaymentsHandlerWeb.Endpoint
      # Start a worker by calling: PaymentsHandler.Worker.start_link(arg)
      # {PaymentsHandler.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PaymentsHandler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PaymentsHandlerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

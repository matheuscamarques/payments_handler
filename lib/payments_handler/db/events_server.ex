defmodule PaymentsHandler.Db.EventsServer do
  use GenServer

  alias PaymentsHandler.Db.Engines.Objects.Events

  alias PaymentsHandler.Db.Engines.{
    EventsTree,
    EventsMap,
    EventsList
  }

  @strategies [
    EventsTree,
    EventsMap,
    EventsList
  ]
  def start_link(init_args),
    do: GenServer.start_link(__MODULE__, [init_args], name: Keyword.fetch!(init_args, :name))

  # TODO Use other data structures for example Map , ETS , Simple List
  def init(strategy: strategy) do
    if not Enum.find_value(@strategies, strategy) do
      throw(:strategy_is_not_defined)
    end

    strategy = strategy

    payload = %Events{
      amount: 100_000_000_000,
      destination: "SYSTEM_EVENT",
      origin: "ADMIN",
      type: "deposit"
    }

    deposits = strategy.construct()

    {:ok,
     %{
       strategy: strategy,
       withdraws: strategy.construct(),
       deposits: insert(strategy, deposits, "SYSTEM_EVENT", payload),
       transfers: strategy.construct()
     }}
  end

  def init(_args) do
    strategy = EventsList

    payload = %Events{
      amount: 100_000_000_000,
      destination: "SYSTEM_EVENT",
      origin: "ADMIN",
      type: "deposit"
    }

    deposits = strategy.construct()

    {:ok,
     %{
       strategy: strategy,
       withdraws: strategy.construct(),
       deposits: insert(strategy, deposits, "SYSTEM_EVENT", payload),
       transfers: strategy.construct()
     }}
  end

  def initial_state(strategy) do
    payload = %Events{
      amount: 100_000_000_000,
      destination: "SYSTEM_EVENT",
      origin: "ADMIN",
      type: "deposit"
    }

    deposits = strategy.construct()

    %{
      strategy: strategy,
      withdraws: strategy.construct(),
      deposits: insert(strategy, deposits, "SYSTEM_EVENT", payload),
      transfers: strategy.construct()
    }
  end

  def handle_call(:reset, _from, state) do
    {:reply, :ok, initial_state(state.strategy)}
  end

  def handle_call(
        {:withdraw, id, %Events{} = payload},
        _from,
        %{strategy: strategy, withdraws: tree} = state
      ) do
    withdraws = insert(strategy, tree, id, payload)
    {:reply, :ok, %{state | withdraws: withdraws}}
  end

  def handle_call(
        {:deposit, id, %Events{} = payload},
        _from,
        %{strategy: strategy, deposits: tree} = state
      ) do
    deposits = insert(strategy, tree, id, payload)
    {:reply, :ok, %{state | deposits: deposits}}
  end

  def handle_call(
        {:transfer, id, %Events{} = payload},
        _from,
        %{strategy: strategy, transfers: tree} = state
      ) do
    transfers = insert(strategy, tree, id, payload)
    {:reply, :ok, %{state | transfers: transfers}}
  end

  def handle_call({:state, id}, _from, %{strategy: strategy} = state) do
    %{withdraws: withdraws} = state
    %{deposits: deposits} = state
    %{transfers: transfers} = state

    # Define a function to fetch values asynchronously
    async_fetch_values = fn data, id ->
      Task.async(fn ->
        strategy.get_from_id(data, id)
      end)
    end

    # Run asynchronous tasks to fetch values
    withdraws_task = async_fetch_values.(withdraws, id)
    deposits_task = async_fetch_values.(deposits, id)
    transfers_task = async_fetch_values.(transfers, id)

    # Wait for tasks to complete and get their results
    withdraws_values =
      Task.await(withdraws_task)
      |> case do
        nil -> []
        {_index, values} -> values
      end

    deposits_values =
      Task.await(deposits_task)
      |> case do
        nil -> []
        {_index, values} -> values
      end

    transfers_values =
      Task.await(transfers_task)
      |> case do
        nil -> []
        {_index, values} -> values
      end

    sum_withdraws = Enum.map(withdraws_values, & &1.amount) |> Enum.sum()
    sum_deposits = Enum.map(deposits_values, & &1.amount) |> Enum.sum()
    balance = sum_deposits - sum_withdraws

    {:reply,
     %{
       id: id,
       events: %{
         withdraws: withdraws_values,
         transfers: transfers_values,
         deposits: deposits_values
       },
       balance: balance
     }, state}
  end

  defp insert(strategy, tree, id, payload) do
    strategy.insert(tree, id, payload)
  end
end

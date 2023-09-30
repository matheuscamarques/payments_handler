defmodule PaymentsHandler.Sages.PaymentSage do
  alias PaymentsHandler.Db.Engines.Objects.Events
  alias Sage
  # TODO use sage for this case!!
  @events_server EventsServer

  def transfer_sage(%Events{} = event) do
    Sage.new()
    |> Sage.run(:withdraw, &withdraw/2)
    |> Sage.run(:deposit, &deposit/2)
    |> Sage.run(:transfer_to_origin, &transfer_to_origin/2)
    |> Sage.run(:transfer_to_destination, &transfer_to_destination/2)
    |> Sage.execute(%{event: event})
  end

  defp withdraw(
         _,
         %{
           event:
             %Events{
               origin: origin,
               amount: amount
             } = event
         }
       ) do
    %{balance: balance} = GenServer.call(@events_server, {:state, origin})

    if balance < amount do
      {:error, "Not have amount to transfer"}
    else
      :ok = GenServer.call(@events_server, {:withdraw, origin, event})
      {:ok, origin}
    end
  end

  defp deposit(_, %{event: %Events{destination: destination} = event}) do
    :ok = GenServer.call(@events_server, {:deposit, destination, event})
    {:ok, destination}
  end

  def transfer_to_origin(_, %{event: %Events{origin: origin} = event}) do
    :ok = GenServer.call(@events_server, {:transfer, origin, event})
    {:ok, origin}
  end

  def transfer_to_destination(_, %{event: %Events{destination: destination} = event}) do
    :ok = GenServer.call(@events_server, {:transfer, destination, event})
    {:ok, destination}
  end

  def get_balance_by_id_sage(account_id) do
    Sage.new()
    |> Sage.run(:balance, &get_balance_by_id/2)
    |> Sage.execute(%{account_id: account_id})
  end

  defp get_balance_by_id(_, %{account_id: account_id}) do
    %{balance: balance} = GenServer.call(@events_server, {:state, account_id})
    {:ok, balance}
  end

  def reset_server_sage() do
    Sage.new()
    |> Sage.run(:reset, &reset_server/2)
    |> Sage.execute()
  end

  defp reset_server(_, _) do
    :ok = GenServer.call(@events_server, :reset)
    {:ok, :reset}
  end
end

defmodule PaymentsHandler.Sages.PaymentSage do
  alias PaymentsHandler.Db.Engines.Objects.Events
  alias Sage

  @events_server EventsServer

  def transfer_sage(%Events{origin: origin, destination: destination} = event) do
    # verificar se a conta de origem tem dinheiro suficiente
    case do_withdraw_sage(event) do
      :ok -> do_deposit_sage(event)
      any -> any
    end
    |> case do
      :ok ->
        GenServer.call(@events_server, {:transfer, origin, event})
        GenServer.call(@events_server, {:transfer, destination, event})

      any ->
        any
    end
  end

  def get_balance_by_id(account_id) do
    %{balance: balance} = GenServer.call(@events_server, {:state, account_id})
    balance
  end

  def reset() do
    GenServer.call(@events_server, :reset)
  end

  defp do_withdraw_sage(
         %Events{
           origin: origin,
           amount: amount
         } = event
       ) do
    %{balance: balance} = GenServer.call(@events_server, {:state, origin})

    if balance < amount do
      {:error, "Not have amount to transfer"}
    else
      GenServer.call(@events_server, {:withdraw, origin, event})
    end
  end

  defp do_deposit_sage(%Events{destination: destination} = event) do
    GenServer.call(@events_server, {:deposit, destination, event})
  end
end

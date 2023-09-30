defmodule PaymentsHandlerWeb.EventsJSON do
  alias PaymentsHandler.Db.Engines.Objects.Events
  alias PaymentsHandler.Payments

  def withdraw_json(%Events{
        origin: origin
      }) do
    %{
      origin: %{
        id: origin,
        balance: balance(origin)
      }
    }
  end

  def deposit_json(%Events{
        destination: destination
      }) do
    %{
      destination: %{
        id: destination,
        balance: balance(destination)
      }
    }
  end

  def transfer_json(%Events{
        origin: origin,
        destination: destination
      }) do
    %{
      origin: %{
        id: origin,
        balance: balance(origin)
      },
      destination: %{
        id: destination,
        balance: balance(destination)
      }
    }
  end

  def balance(id) do
    {:ok, balance, _} = Payments.get_balance_by_id(id)
    balance
  end
end

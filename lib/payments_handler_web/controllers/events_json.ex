defmodule PaymentsHandlerWeb.EventsJSON do
  alias PaymentsHandler.Db.Engines.Objects.Events
  alias PaymentsHandler.Payments

  def withdraw_json(%Events{
        origin: origin
      }) do
    %{
      origin: %{
        id: origin,
        balance: Payments.get_balance_by_id(origin)
      }
    }
  end

  def deposit_json(%Events{
        destination: destination
      }) do
    %{
      destination: %{
        id: destination,
        balance: Payments.get_balance_by_id(destination)
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
        balance: Payments.get_balance_by_id(origin)
      },
      destination: %{
        id: destination,
        balance: Payments.get_balance_by_id(destination)
      }
    }
  end
end

defmodule PaymentsHandler.Payments do
  alias PaymentsHandler.Db.Engines.Objects.Events
  alias PaymentsHandler.Sages.PaymentSage

  @moduledoc """
  The Payments context.
  """

  def transfer(%Events{} = event) do
    PaymentSage.transfer_sage(event)
  end

  def get_balance_by_id(account_id) do
    PaymentSage.get_balance_by_id(account_id)
  end

  def reset() do
    PaymentSage.reset()
  end
end

defmodule PaymentsHandler.Payments do
  alias PaymentsHandler.Sages.PaymentSage

  @moduledoc """
  The Payments context.
  """
  alias PaymentsHandler.Payments.Events

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

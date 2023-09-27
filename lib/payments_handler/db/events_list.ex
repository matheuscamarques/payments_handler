defmodule PaymentsHandler.Db.EventsList do
  alias PaymentsHandler.Db.EventsServer.ListStrategy
  alias PaymentsHandler.Payments.Events

  defdelegate construct, to: ListStrategy, as: :construct
  defdelegate get_from_id(tree, index), to: ListStrategy, as: :get_from_id

  @spec insert(tree :: any, index :: any, item :: ListStrategy.Payments.Events) :: List
  def insert(tree, index, %Events{} = item) do
    ListStrategy.insert(tree, index, item)
  end
end

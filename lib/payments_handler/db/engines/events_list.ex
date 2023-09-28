defmodule PaymentsHandler.Db.Engines.EventsList do
  alias PaymentsHandler.Db.Engines.Strategies.ListStrategy
  alias PaymentsHandler.Db.Engines.Objects.Events

  defdelegate construct, to: ListStrategy, as: :construct
  defdelegate get_from_id(tree, index), to: ListStrategy, as: :get_from_id

  @spec insert(tree :: any, index :: any, item :: ListStrategy.Payments.Events) :: List
  def insert(tree, index, %Events{} = item) do
    ListStrategy.insert(tree, index, item)
  end
end

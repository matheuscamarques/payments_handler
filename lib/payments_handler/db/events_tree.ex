defmodule PaymentsHandler.Db.EventsServer.EventsTree do
  alias PaymentsHandler.Db.EventsServer.TreeStrategy
  alias PaymentsHandler.Payments.Events

  defdelegate construct, to: TreeStrategy, as: :construct
  defdelegate get_from_id(tree, index), to: TreeStrategy, as: :get_from_id

  @spec insert(tree :: any, index :: any, item :: PaymentsHandler.Payments.Events) :: AVLTree
  def insert(tree, index, %Events{} = item) do
    TreeStrategy.insert(tree, index, item)
  end
end

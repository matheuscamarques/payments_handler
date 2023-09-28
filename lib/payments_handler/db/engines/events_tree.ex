defmodule PaymentsHandler.Db.Engines.EventsTree do
  alias PaymentsHandler.Db.StrategyBehavior.DbEngine
  alias PaymentsHandler.Db.Engines.Strategies.TreeStrategy
  alias PaymentsHandler.Db.Engines.Objects.Events

  @behaviour DbEngine

  defdelegate construct, to: TreeStrategy, as: :construct
  defdelegate get_from_id(tree, index), to: TreeStrategy, as: :get_from_id

  @spec insert(tree :: any, index :: any, item :: PaymentsHandler.Payments.Events) :: AVLTree
  def insert(tree, index, %Events{} = item) do
    TreeStrategy.insert(tree, index, item)
  end
end

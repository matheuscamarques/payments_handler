defmodule PaymentsHandler.Db.Engines.EventsMap do
  @behaviour PaymentsHandler.Db.StrategyBehavior.DbEngine
  alias PaymentsHandler.Db.Engines.Strategies.MapStrategy
  alias PaymentsHandler.Db.Engines.Objects.Events

  defdelegate construct, to: MapStrategy, as: :construct
  defdelegate get_from_id(tree, index), to: MapStrategy, as: :get_from_id

  @spec insert(tree :: any, index :: any, item :: Events) :: Map
  def insert(tree, index, %Events{} = item) do
    MapStrategy.insert(tree, index, item)
  end
end

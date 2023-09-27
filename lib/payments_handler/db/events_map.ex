defmodule PaymentsHandler.Db.EventsMap do
  @behaviour PaymentsHandler.Db.Strategy.DbEngineBehaviour
  alias PaymentsHandler.Db.EventsServer.MapStrategy
  alias PaymentsHandler.Payments.Events

  defdelegate construct, to: MapStrategy, as: :construct
  defdelegate get_from_id(tree, index), to: MapStrategy, as: :get_from_id

  @spec insert(tree :: any, index :: any, item :: PaymentsHandler.Payments.Events) :: Map
  def insert(tree, index, %Events{} = item) do
    MapStrategy.insert(tree, index, item)
  end
end

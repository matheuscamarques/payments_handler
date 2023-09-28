defmodule PaymentsHandler.Db.Engines.EventsEts do
  alias PaymentsHandler.Db.Engines.Strategies.EtsStrategy
  alias PaymentsHandler.Db.Engines.Objects.Events

  defdelegate construct, to: EtsStrategy, as: :construct
  defdelegate get_from_id(tree, index), to: EtsStrategy, as: :get_from_id

  @spec insert(tree :: any, index :: any, item :: Events) :: struct()
  def insert(tree, index, %Events{} = item) do
    EtsStrategy.insert(tree, index, item)
  end
end

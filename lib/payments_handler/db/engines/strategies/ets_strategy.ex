defmodule PaymentsHandler.Db.Engines.Strategies.EtsStrategy do
  @behaviour PaymentsHandler.Db.StrategyBehavior.DbEngine

  # Initialize an ETS table with set semantics.
  def construct(), do: :ets.new(:payment_handler_ets, [:set, :public])

  def get_from_id(table, index) do
    case :ets.lookup(table, index) do
      [] -> nil
      [{^index, values}] -> {index, values}
    end
  end

  def insert(table, index, item) do
    case get_from_id(table, index) do
      nil ->
        :ets.insert(table, {index, [item]})
        table

      {^index, values} ->
        new_values = values ++ [item]
        :ets.insert(table, {index, new_values})
        table
    end
  end
end

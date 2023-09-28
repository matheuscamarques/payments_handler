defmodule PaymentsHandler.Db.Engines.Strategies.ListStrategy do
  @behaviour PaymentsHandler.Db.StrategyBehavior.DbEngine

  def construct(), do: []

  def get_from_id(list, index) do
    Enum.find(list, fn {idx, _values} -> index == idx end)
  end

  def insert(list, index, item) do
    case get_from_id(list, index) do
      nil ->
        [{index, [item]} | list]

      {_index, values} ->
        position = Enum.find_index(list, fn {idx, _values} -> index == idx end)
        List.keyreplace(list, index, position, {index, [item | values]})
    end
  end
end

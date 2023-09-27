defmodule PaymentsHandler.Db.EventsServer.MapStrategy do
  @behaviour PaymentsHandler.Db.Strategy.DbEngineBehaviour

  def construct(), do: Map.new()

  def get_from_id(map, index) do
    case Map.get(map, index) do
      nil -> nil
      values -> {index, values}
    end
  end

  def insert(tree, index, item) do
    case get_from_id(tree, index) do
      nil ->
        Map.put(tree, index, [item])

      {_index, values} ->
        acc = values ++ [item]
        Map.put(tree, index, acc)
    end
  end
end

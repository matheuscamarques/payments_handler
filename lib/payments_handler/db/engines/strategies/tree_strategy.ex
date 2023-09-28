defmodule PaymentsHandler.Db.Engines.Strategies.TreeStrategy do
  alias AVLTree
  @behaviour PaymentsHandler.Db.StrategyBehavior.DbEngine

  def construct(), do: AVLTree.new(fn {index_a, _}, {index_b, _} -> index_a < index_b end)

  def get_from_id(tree, index), do: AVLTree.get(tree, {index, nil})

  def insert(tree, index, item) do
    case get_from_id(tree, index) do
      nil ->
        AVLTree.put(tree, {index, [item]})

      {_index, values} ->
        acc = values ++ [item]
        AVLTree.put(tree, {index, acc})
    end
  end
end

defmodule PaymentsHandler.Db.EventsServer.TreeBehaviour do
  @callback construct() :: AVLTree
  @callback get_from_id(tree :: AVLTree, index :: term) :: {index :: term, values :: term} | nil
  @callback insert(tree :: AVLTree, index :: term, item :: term) :: AVLTree
end

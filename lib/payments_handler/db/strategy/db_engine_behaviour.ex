defmodule PaymentsHandler.Db.Strategy.DbEngineBehaviour do
    @callback construct() :: struct()
    @callback get_from_id(tree :: struct(), index :: term) :: {index :: term, values :: term} | nil
    @callback insert(tree :: struct(), index :: term, item :: term) :: struct()

end

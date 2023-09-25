defmodule PaymentsHandler.Payments.Events do
  @enforce_keys [:amount, :destination, :type]

  @type t :: %__MODULE__{
          amount: integer(),
          destination: String.t(),
          type: String.t()
        }
  defstruct [:amount, :destination, :type]
end

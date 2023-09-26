defmodule PaymentsHandler.Payments.Events do
  @enforce_keys [:amount, :destination, :type, :origin]

  @type t :: %__MODULE__{
          amount: integer(),
          destination: String.t(),
          origin: String.t(),
          type: String.t()
        }
  defstruct [:amount, :destination, :type, :origin]
end

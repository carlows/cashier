defmodule Product do
  @moduledoc """
  Product represents the data structure for products in the data store.
  """
  defstruct code: nil, name: nil, price: nil

  @type t() :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: Money.t()
        }
end

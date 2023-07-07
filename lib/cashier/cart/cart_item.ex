defmodule CartItem do
  @moduledoc """
  CartItem represents the data structure for items inside the cart
  """
  defstruct product: nil, quantity: 0

  @type t() :: %__MODULE__{
          product: Product.t(),
          quantity: non_neg_integer()
        }
end

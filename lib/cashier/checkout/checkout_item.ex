defmodule CheckoutItem do
  @moduledoc """
  CheckoutItem represents the data structure for items after discounts have been applied
  """
  defstruct product: nil, quantity: 0, total_amount: nil

  @type t() :: %__MODULE__{
          product: Product.t(),
          quantity: non_neg_integer(),
          total_amount: Money.t()
        }
end

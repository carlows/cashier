defmodule ZeroDiscount do
  @moduledoc """
  ZeroDiscount is applied when we could not find any suitable discount for the product.
  """

  def apply_discount(%CartItem{product: product, quantity: quantity}) do
    %CheckoutItem{
      product: product,
      quantity: quantity,
      total_amount: Money.multiply(product.price, quantity)
    }
  end
end

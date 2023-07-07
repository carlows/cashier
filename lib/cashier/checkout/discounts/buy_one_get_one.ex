defmodule BuyOneGetOne do
  @moduledoc """
  BuyOneGetOne implements the discount to get one and get one free.
  """

  def apply_discount(
        %CartItem{product: product, quantity: quantity},
        _config
      )
      when quantity <= 0 do
    %CheckoutItem{
      product: product,
      quantity: 0,
      total_amount: Money.new(0)
    }
  end

  def apply_discount(
        %CartItem{product: product, quantity: quantity},
        %{minimum: minimum} = _config
      )
      when quantity >= minimum do
    %CheckoutItem{
      product: product,
      quantity: quantity,
      total_amount: Money.multiply(product.price, quantity - 1)
    }
  end

  def apply_discount(item, _config) do
    ZeroDiscount.apply_discount(item)
  end
end

defmodule BuyOneGetOne do
  @moduledoc """
  BuyOneGetOne implements the discount to get one and get one free.

  If the client has checkout 2 items with the BuyOneGetOne discount, he only pays for 1.
  When the client checkouts just 1 item, it gives them an extra item.
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
        _config
      )
      when quantity == 1 do
    %CheckoutItem{
      product: product,
      quantity: 2,
      total_amount: product.price,
      remarks: "We added one extra #{product.name} for free with our BuyOneGetOne promotion!"
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
      total_amount: Money.multiply(product.price, quantity - 1),
      remarks: "You get one #{product.name} for free with our BuyOneGetOne promotion!"
    }
  end

  def apply_discount(item, _config) do
    ZeroDiscount.apply_discount(item)
  end
end

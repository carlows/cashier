defmodule TwoThirdsDiscount do
  @moduledoc """
  TwoThirdsDiscount reduces the price of the product keeping two thirds of the price
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
      total_amount: calculate_two_thirds(product.price, quantity)
    }
  end

  def apply_discount(item, _config) do
    ZeroDiscount.apply_discount(item)
  end

  defp calculate_two_thirds(price, quantity) do
    price
    |> Money.multiply(Decimal.div(2, 3))
    |> Money.multiply(quantity)
  end
end

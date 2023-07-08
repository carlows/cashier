defmodule FixedDiscount do
  @moduledoc """
  FixedDiscount implements the fixed discount.

  It allows to reduce the price of a product by e.g: 10 cents.

  When the amount to deduct is higher than the price of the product, the returned amount is zero.
  """

  import Money.Sigils

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
        %{minimum: minimum, deduct_amount: deduct_amount} = _config
      )
      when quantity >= minimum do
    %CheckoutItem{
      product: product,
      quantity: quantity,
      total_amount: subtract_amount(product.price, deduct_amount, quantity)
    }
  end

  def apply_discount(
        %CartItem{product: product, quantity: quantity},
        %{minimum: minimum, deduct_amount: deduct_amount} = _config
      )
      when quantity >= minimum do
    %CheckoutItem{
      product: product,
      quantity: quantity,
      total_amount: subtract_amount(product.price, deduct_amount, quantity)
    }
  end

  def apply_discount(item, _config) do
    ZeroDiscount.apply_discount(item)
  end

  defp subtract_amount(price, deduct_amount, quantity) do
    subtracted_price =
      price
      |> Money.subtract(deduct_amount)

    case Money.negative?(subtracted_price) do
      true -> ~M[0]
      false -> subtracted_price |> Money.multiply(quantity)
    end
  end
end

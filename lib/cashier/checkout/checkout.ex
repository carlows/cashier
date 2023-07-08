defmodule Checkout do
  @moduledoc """
  Checkout is responsible for processing items in the cart by applying discounts.
  """

  @spec process_items([CartItem.t()], any) :: [CheckoutItem.t()]
  def process_items(items \\ [], config) do
    items
    |> Enum.map(fn item ->
      DiscountProcessor.apply_discount(item, config)
    end)
  end

  def calculate_total(items) do
    items
    |> Enum.reduce(Money.new(0), fn curr, acc ->
      Money.add(acc, curr.total_amount)
    end)
  end
end

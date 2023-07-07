defmodule Checkout do
  @moduledoc """
  Checkout is responsible for processing items in the cart by applying discounts.
  """

  import Money.Sigils

  @default_config [
    %{
      product_code: "GR1",
      discount: BuyOneGetOne,
      minimum: 1
    },
    %{
      product_code: "SR1",
      discount: FixedDiscount,
      minimum: 3,
      deduct_amount: ~M[0_50]
    },
    %{
      product_code: "CF1",
      discount: TwoThirdsDiscount,
      minimum: 3
    },
  ]

  @spec process_items([CartItem.t()], any) :: [CheckoutItem.t()]
  def process_items(items \\ [], config \\ @default_config) do
    items
    |> Enum.map(fn item ->
      DiscountProcessor.apply_discount(item, config)
    end)
  end

  def calculate_total(items) do
    # asdasd
  end
end

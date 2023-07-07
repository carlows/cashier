defmodule DiscountProcessorTest do
  @moduledoc false

  use ExUnit.Case, async: true
  import Money.Sigils

  test "DiscountProcessor.apply_discount/2 calculates a CheckoutItem with no discounts when no discount can be applied" do
    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: 2
    }

    result = DiscountProcessor.apply_discount(item, [])

    assert %CheckoutItem{
             product: %Product{
               code: "GR1",
               name: "Green Tea",
               price: ~M[3_11]GBP
             },
             quantity: 2,
             total_amount: ~M[6_22]GBP
           } = result
  end

  test "DiscountProcessor.apply_discount/2 calculates a CheckoutItem with no discounts when a discount matches the config but cannot be applied" do
    config = [
      %{
        product_code: "GR1",
        discount: BuyOneGetOne,
        minimum: 3
      }
    ]

    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: 2
    }

    result = DiscountProcessor.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "GR1",
               name: "Green Tea",
               price: ~M[3_11]GBP
             },
             quantity: 2,
             total_amount: ~M[6_22]GBP
           } = result
  end

  test "DiscountProcessor.apply_discount/2 calculates a CheckoutItem and applies a discount" do
    config = [
      %{
        product_code: "GR1",
        discount: BuyOneGetOne,
        minimum: 1
      }
    ]

    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: 2
    }

    result = DiscountProcessor.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "GR1",
               name: "Green Tea",
               price: ~M[3_11]GBP
             },
             quantity: 2,
             total_amount: ~M[3_11]GBP
           } = result
  end
end

defmodule TwoThirdsDiscountTest do
  @moduledoc false

  use ExUnit.Case, async: true
  import Money.Sigils

  test "TwoThirdsDiscount.apply_discount/2 applies the discount on one item when the minimum is met" do
    item = %CartItem{
      product: %Product{
        code: "CR1",
        name: "Coffee",
        price: ~M[11_23]GBP
      },
      quantity: 3
    }

    config = %{minimum: 3}

    result = TwoThirdsDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "CR1",
               name: "Coffee",
               price: ~M[11_23]GBP
             },
             quantity: 3,
             total_amount: ~M[22_46]GBP
           } = result
  end

  test "TwoThirdsDiscount.apply_discount/2 applies zero discount if the minimum is not met" do
    item = %CartItem{
      product: %Product{
        code: "CR1",
        name: "Coffee",
        price: ~M[11_23]GBP
      },
      quantity: 2
    }

    config = %{minimum: 3}

    result = TwoThirdsDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "CR1",
               name: "Coffee",
               price: ~M[11_23]GBP
             },
             quantity: 2,
             total_amount: ~M[22_46]GBP
           } = result
  end

  test "TwoThirdsDiscount.apply_discount/2 returns a total amount of zero when the quantity is zero" do
    item = %CartItem{
      product: %Product{
        code: "CR1",
        name: "Coffee",
        price: ~M[11_23]GBP
      },
      quantity: 0
    }

    config = %{minimum: 0}

    result = TwoThirdsDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "CR1",
               name: "Coffee",
               price: ~M[11_23]GBP
             },
             quantity: 0,
             total_amount: ~M[0]GBP
           } = result
  end

  test "TwoThirdsDiscount.apply_discount/2 returns a total amount of zero when the quantity is negative" do
    item = %CartItem{
      product: %Product{
        code: "CR1",
        name: "Coffee",
        price: ~M[11_23]GBP
      },
      quantity: -42
    }

    config = %{minimum: 0}

    result = TwoThirdsDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "CR1",
               name: "Coffee",
               price: ~M[11_23]GBP
             },
             quantity: 0,
             total_amount: ~M[0]GBP
           } = result
  end
end

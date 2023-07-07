defmodule FixedDiscountTest do
  @moduledoc false

  use ExUnit.Case, async: true
  import Money.Sigils

  test "FixedDiscount.apply_discount/2 applies the discount on one item when the minimum is met" do
    item = %CartItem{
      product: %Product{
        code: "SR1",
        name: "Strawberries",
        price: ~M[5_00]GBP
      },
      quantity: 3
    }

    config = %{minimum: 3, deduct_amount: ~M[0_50]GBP}

    result = FixedDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "SR1",
               name: "Strawberries",
               price: ~M[5_00]GBP
             },
             quantity: 3,
             total_amount: ~M[13_50]GBP
           } = result
  end

  test "FixedDiscount.apply_discount/2 applies zero discount when the deducted amount is higher than the product price" do
    item = %CartItem{
      product: %Product{
        code: "SR1",
        name: "Strawberries",
        price: ~M[5_00]GBP
      },
      quantity: 3
    }

    config = %{minimum: 3, deduct_amount: ~M[6_00]GBP}

    result = FixedDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "SR1",
               name: "Strawberries",
               price: ~M[5_00]GBP
             },
             quantity: 3,
             total_amount: ~M[0]GBP
           } = result
  end

  test "FixedDiscount.apply_discount/2 applies zero discount if the minimum is not met" do
    item = %CartItem{
      product: %Product{
        code: "SR1",
        name: "Strawberries",
        price: ~M[5_00]GBP
      },
      quantity: 2
    }

    config = %{minimum: 3}

    result = FixedDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "SR1",
               name: "Strawberries",
               price: ~M[5_00]GBP
             },
             quantity: 2,
             total_amount: ~M[10_00]GBP
           } = result
  end

  test "FixedDiscount.apply_discount/2 returns a total amount of zero when the quantity is zero" do
    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: 0
    }

    config = %{minimum: 0}

    result = FixedDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "GR1",
               name: "Green Tea",
               price: ~M[3_11]GBP
             },
             quantity: 0,
             total_amount: ~M[0]GBP
           } = result
  end

  test "FixedDiscount.apply_discount/2 returns a total amount of zero when the quantity is negative" do
    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: -42
    }

    config = %{minimum: 0}

    result = FixedDiscount.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "GR1",
               name: "Green Tea",
               price: ~M[3_11]GBP
             },
             quantity: 0,
             total_amount: ~M[0]GBP
           } = result
  end
end

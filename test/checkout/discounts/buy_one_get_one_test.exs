defmodule BuyOneGetOneTest do
  @moduledoc false

  use ExUnit.Case, async: true
  import Money.Sigils

  test "BuyOneGetOne.apply_discount/2 applies the discount on one item when the minimum is met" do
    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: 3
    }

    config = %{minimum: 1}

    result = BuyOneGetOne.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "GR1",
               name: "Green Tea",
               price: ~M[3_11]GBP
             },
             quantity: 3,
             total_amount: ~M[6_22]GBP,
             remarks: "You get one Green Tea for free with our BuyOneGetOne promotion!"
           } = result
  end

  test "BuyOneGetOne.apply_discount/2 applies zero discount if the minimum is not met" do
    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: 3
    }

    config = %{minimum: 4}

    result = BuyOneGetOne.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "GR1",
               name: "Green Tea",
               price: ~M[3_11]GBP
             },
             quantity: 3,
             total_amount: ~M[9_33]GBP
           } = result
  end

  test "BuyOneGetOne.apply_discount/2 returns a total amount of zero when the quantity is zero" do
    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: 0
    }

    config = %{minimum: 0}

    result = BuyOneGetOne.apply_discount(item, config)

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

  test "BuyOneGetOne.apply_discount/2 returns a total amount of zero when the quantity is negative" do
    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: -42
    }

    config = %{minimum: 0}

    result = BuyOneGetOne.apply_discount(item, config)

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

  test "BuyOneGetOne.apply_discount/2 returns the same price when quantity is 1" do
    item = %CartItem{
      product: %Product{
        code: "GR1",
        name: "Green Tea",
        price: ~M[3_11]GBP
      },
      quantity: 1
    }

    config = %{minimum: 1}

    result = BuyOneGetOne.apply_discount(item, config)

    assert %CheckoutItem{
             product: %Product{
               code: "GR1",
               name: "Green Tea",
               price: ~M[3_11]GBP
             },
             quantity: 2,
             total_amount: ~M[3_11]GBP,
             remarks: "We added one extra Green Tea for free with our BuyOneGetOne promotion!"
           } = result
  end
end

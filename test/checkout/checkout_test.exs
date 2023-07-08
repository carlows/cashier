defmodule CheckoutTest do
  @moduledoc false

  use ExUnit.Case, async: true
  import Money.Sigils

  test "Checkout.process_items/1 returns a list of CheckoutItem" do
    cart_items = %CartItem{
      product: %Product{
        code: "SR1",
        name: "Strawberries",
        price: ~M[5_00]
      },
      quantity: 1
    }

    result = Checkout.process_items([cart_items])

    assert [
             %CheckoutItem{
               product: %Product{
                 code: "SR1",
                 name: "Strawberries",
                 price: ~M[5_00]
               },
               quantity: 1,
               total_amount: ~M[5_00]
             }
           ] = result
  end

  test "Checkout.process_items/1 returns a list of discounted CheckoutItems" do
    cart_items = %CartItem{
      product: %Product{
        code: "SR1",
        name: "Strawberries",
        price: ~M[5_00]
      },
      quantity: 3
    }

    config = [
      %{
        product_code: "SR1",
        minimum: 1,
        discount: BuyOneGetOne
      }
    ]

    result = Checkout.process_items([cart_items], config)

    assert [
             %CheckoutItem{
               product: %Product{
                 code: "SR1",
                 name: "Strawberries",
                 price: ~M[5_00]
               },
               quantity: 3,
               total_amount: ~M[10_00]
             }
           ] = result
  end

  test "Checkout.calculate_total/1 returns the total amount for all the items in the checkout" do
    cart_items = [
      %CartItem{
        product: %Product{
          code: "SR1",
          name: "Strawberries",
          price: ~M[5_00]
        },
        quantity: 3
      },
      %CartItem{
        product: %Product{
          code: "GR1",
          name: "Green Tea",
          price: ~M[3_11]
        },
        quantity: 1
      }
    ]

    config = [
      %{
        product_code: "GR1",
        minimum: 1,
        discount: BuyOneGetOne
      },
      %{
        product_code: "SR1",
        minimum: 3,
        discount: FixedDiscount,
        deduct_amount: ~M[0_50]
      }
    ]

    result = Checkout.process_items(cart_items, config) |> Checkout.calculate_total()

    assert result == ~M[16_61]
  end
end

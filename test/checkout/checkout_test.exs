defmodule CheckoutTest do
  @moduledoc false

  use ExUnit.Case, async: true
  import Money.Sigils

  test "Checkout.process_items/1 returns a list of CheckoutItem" do
    cart_items = %CartItem{
      product: %Product{
        code: "SR1",
        name: "Strawberries",
        price: ~M[5]
      },
      quantity: 1
    }

    assert {:ok, result} = Checkout.process_items([cart_items])

    assert [
             %CheckoutItem{
               product: %Product{
                 code: "SR1",
                 name: "Strawberries",
                 price: ~M[5]
               },
               quantity: 1,
               total_amount: ~M[5]
             }
           ] = result
  end
end

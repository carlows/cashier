defmodule CartTest do
  @moduledoc false

  use ExUnit.Case, async: true

  setup do
    start_supervised(ProductStore)
    start_supervised(Cart)

    ProductStore.add_product(%{code: "GR1", name: "Green Tea", price: 3_11})
    ProductStore.add_product(%{code: "SR1", name: "Strawberries", price: 5})
    ProductStore.add_product(%{code: "CF1", name: "Coffee", price: 11_23})
    :ok
  end

  test "total_items returns the total items in the cart" do
    result = Cart.total_items()
    assert result == 0

    Cart.add_item("GR1")
    result = Cart.total_items()
    assert result == 1
  end

  test "add_item adds a new item to the cart" do
    result = Cart.add_item("GR1")

    total = Cart.total_items()
    assert total == 1

    assert {:ok, %CartItem{} = item} = result
    assert item.quantity == 1

    product = item.product
    assert product.name == "Green Tea"
  end

  test "add_item increments the quantity of the item in the cart" do
    Cart.add_item("GR1")
    result = Cart.add_item("GR1")

    assert {:ok, %CartItem{} = item} = result
    assert item.quantity == 2
  end

  test "add_item returns an error if the product is not found in the store" do
    result = Cart.add_item("hello?")

    assert {:error, "Product not found"} = result
  end

  test "get_items returns all the items in the cart as a list" do
    Cart.add_item("GR1")
    Cart.add_item("SR1")
    Cart.add_item("GR1")

    result = Cart.get_items()

    assert [
             %CartItem{
               product: %Product{
                 code: "GR1",
                 name: "Green Tea",
                 price: %Money{amount: 311, currency: :GBP}
               },
               quantity: 2
             },
             %CartItem{
               product: %Product{
                 code: "SR1",
                 name: "Strawberries",
                 price: %Money{amount: 5, currency: :GBP}
               },
               quantity: 1
             }
           ] = result
  end
end

defmodule ProductStoreTest do
  @moduledoc false

  use ExUnit.Case, async: true
  import Money.Sigils

  setup do
    start_supervised(ProductStore)
    :ok
  end

  test "ProductStore.add_product/1 allows to add a new product to the store" do
    result = ProductStore.add_product(%{code: "GR1", name: "Green Tea", price: 3_11})
    assert {:ok, product} = result
    assert product.code == "GR1"
    assert product.name == "Green Tea"
    assert product.price == ~M[3_11]GBP
  end

  test "ProductStore.add_product/1 returns an error on missing data" do
    result = ProductStore.add_product(%{code: "GR1"})
    assert {:error, error} = result
    assert error == "Products must have at least a code, a name and a price."
  end

  test "ProductStore.get_product/1 gets a product from the store by code" do
    ProductStore.add_product(%{code: "GR1", name: "Green Tea", price: 3_11})
    result = ProductStore.get_product("GR1")
    assert result.code == "GR1"
  end

  test "ProductStore.get_product/1 returns nil when the product is not found in the store" do
    result = ProductStore.get_product("what?")
    assert result == nil
  end
end

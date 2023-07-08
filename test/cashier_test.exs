defmodule CashierTest do
  use ExUnit.Case
  doctest Cashier

  import ExUnit.CaptureIO

  setup do
    start_supervised(ProductStore)
    start_supervised(Cart)

    ProductStore.add_product(%{code: "GR1", name: "Green Tea", price: 3_11})
    ProductStore.add_product(%{code: "SR1", name: "Strawberries", price: 5_00})
    ProductStore.add_product(%{code: "CF1", name: "Coffee", price: 11_23})
    :ok
  end

  test "Cashier.scan_item adds items to the cart" do
    assert capture_io(fn -> Cashier.scan_item("GR1") end) ==
             "Scanned product Green Tea (code: GR1, price: £3.11)\n"

    assert capture_io(fn -> Cashier.scan_item("CF1") end) ==
             "Scanned product Coffee (code: CF1, price: £11.23)\n"
  end

  test "Cashier.scan_item prints errors when products dont exist in the store" do
    assert capture_io(fn -> Cashier.scan_item("UNEX") end) == "Sorry, cannot scan this product!\n"
  end

  test "Cashier.print_totals returns the final invoice (with example 1)" do
    capture_io(fn ->
      Cashier.scan_item("GR1")
      Cashier.scan_item("SR1")
      Cashier.scan_item("GR1")
      Cashier.scan_item("GR1")
      Cashier.scan_item("CF1")
    end)

    assert capture_io(fn -> Cashier.print_totals() end) ==
             "Code: CF1 - Product: Coffee - Quantity: 1 - Item Total: £11.23\nCode: GR1 - Product: Green Tea - Quantity: 3 - Item Total: £6.22 - Remarks: You get one Green Tea for free with our BuyOneGetOne promotion!\nCode: SR1 - Product: Strawberries - Quantity: 1 - Item Total: £5.00\nCheckout total: £22.45\n"
  end

  test "Cashier.print_totals with example 2" do
    capture_io(fn ->
      Cashier.scan_item("GR1")
      Cashier.scan_item("GR1")
    end)

    assert capture_io(fn -> Cashier.print_totals() end) ==
             "Code: GR1 - Product: Green Tea - Quantity: 2 - Item Total: £3.11 - Remarks: You get one Green Tea for free with our BuyOneGetOne promotion!\nCheckout total: £3.11\n"
  end

  test "Cashier.print_totals with example 3" do
    capture_io(fn ->
      Cashier.scan_item("SR1")
      Cashier.scan_item("SR1")
      Cashier.scan_item("GR1")
      Cashier.scan_item("SR1")
    end)

    assert capture_io(fn -> Cashier.print_totals() end) ==
             "Code: GR1 - Product: Green Tea - Quantity: 2 - Item Total: £3.11 - Remarks: We added one extra Green Tea for free with our BuyOneGetOne promotion!\nCode: SR1 - Product: Strawberries - Quantity: 3 - Item Total: £13.50\nCheckout total: £16.61\n"
  end

  test "Cashier.print_totals with example 4" do
    capture_io(fn ->
      Cashier.scan_item("GR1")
      Cashier.scan_item("CF1")
      Cashier.scan_item("SR1")
      Cashier.scan_item("CF1")
      Cashier.scan_item("CF1")
    end)

    assert capture_io(fn -> Cashier.print_totals() end) ==
             "Code: CF1 - Product: Coffee - Quantity: 3 - Item Total: £22.46\nCode: GR1 - Product: Green Tea - Quantity: 2 - Item Total: £3.11 - Remarks: We added one extra Green Tea for free with our BuyOneGetOne promotion!\nCode: SR1 - Product: Strawberries - Quantity: 1 - Item Total: £5.00\nCheckout total: £30.57\n"
  end
end

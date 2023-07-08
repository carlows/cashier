# Cashier

Versions:

elixir 1.14.5, erlang 26.0.1

### Usage

Run tests:

```
mix deps.get
mix test
```

Use the cashier:

```
iex -S mix

ProductStore.add_product(%{code: "GR1", name: "Green Tea", price: 3_11})
ProductStore.add_product(%{code: "SR1", name: "Strawberries", price: 5_00})
ProductStore.add_product(%{code: "CF1", name: "Coffee", price: 11_23})

Example 1:

Cashier.clear_items()
Cashier.scan_item("GR1")
Cashier.scan_item("SR1")
Cashier.scan_item("GR1")
Cashier.scan_item("GR1")
Cashier.scan_item("CF1")

Cashier.print_totals()

Example 2:

Cashier.clear_items()
Cashier.scan_item("GR1")
Cashier.scan_item("GR1")

Cashier.print_totals()

Example 3:

Cashier.clear_items()
Cashier.scan_item("SR1")
Cashier.scan_item("SR1")
Cashier.scan_item("GR1")
Cashier.scan_item("SR1")

Cashier.print_totals()

Example 4:

Cashier.clear_items()
Cashier.scan_item("GR1")
Cashier.scan_item("CF1")
Cashier.scan_item("SR1")
Cashier.scan_item("CF1")
Cashier.scan_item("CF1")

Cashier.print_totals()
```
# Cashier

Versions:

elixir 1.14.5, erlang 26.0.1

Cashier is a very simple terminal tool that mimics a process of checkout in a supermarket. There's no graphical UI interface and can only be used through iex.

This diagram shows how the different modules interact with each other:

![image](https://api.monosnap.com/file/download?id=3zfe485puA7BcAmdwyJtA7dx4J5eZP)

The cart and product state is stored in genserver processes for simplicity. There's no user identity built in.

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
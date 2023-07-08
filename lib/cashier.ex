defmodule Cashier do
  @moduledoc """
  Documentation for `Cashier`.
  """

  import Money.Sigils

  @default_config [
    %{
      product_code: "GR1",
      discount: BuyOneGetOne,
      minimum: 1
    },
    %{
      product_code: "SR1",
      discount: FixedDiscount,
      minimum: 3,
      deduct_amount: ~M[0_50]
    },
    %{
      product_code: "CF1",
      discount: TwoThirdsDiscount,
      minimum: 3
    }
  ]

  def scan_item(product_code) when is_binary(product_code) do
    print_scanned_item(Cart.add_item(product_code))
  end

  def clear_items() do
    Cart.clear_items()

    IO.puts("Items cleared!")
  end

  def print_totals(config \\ @default_config) do
    items =
      Cart.get_items()
      |> Checkout.process_items(config)

    total =
      items
      |> Checkout.calculate_total()

    items
    |> Enum.each(fn item ->
      print_scanned_item_total(item)
    end)

    IO.puts("Checkout total: #{total}")
  end

  defp print_scanned_item({:error, "Product not found"}),
    do: IO.puts("Sorry, cannot scan this product!")

  defp print_scanned_item({:ok, %CartItem{} = item}) do
    IO.puts(
      "Scanned product #{item.product.name} (code: #{item.product.code}, price: #{Money.to_string(item.product.price)})"
    )
  end

  defp print_scanned_item_total(%CheckoutItem{remarks: remarks} = item)
       when not is_nil(remarks) do
    IO.puts(
      "Code: #{item.product.code} - Product: #{item.product.name} - Quantity: #{item.quantity} - Item Total: #{item.total_amount} - Remarks: #{remarks}"
    )
  end

  defp print_scanned_item_total(%CheckoutItem{} = item) do
    IO.puts(
      "Code: #{item.product.code} - Product: #{item.product.name} - Quantity: #{item.quantity} - Item Total: #{item.total_amount}"
    )
  end
end

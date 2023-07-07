defmodule DiscountProcessor do
  @moduledoc """
  DiscountProcessor finds the right discount to apply to a cart item
  """

  def apply_discount(%CartItem{} = item, config) do
    discount_config = find_discount_config(item.product.code, config)

    case discount_config do
      %{discount: discount_module} ->
        apply_discount_module(discount_module, item, discount_config)

      _ ->
        ZeroDiscount.apply_discount(item)
    end
  end

  defp find_discount_config(product_code, config) do
    Enum.find(config, fn %{product_code: code} -> code == product_code end)
  end

  defp apply_discount_module(discount_module, %CartItem{} = item, discount_config) do
    apply(discount_module, :apply_discount, [item, discount_config])
  end
end

defmodule Cart do
  @moduledoc """
  Cart maintains the state of the scanned products during checkout.

  For simplicity it's implemented as a global store, but we would require to think
  about how identify the user that this cart belongs to.
  """
  use GenServer

  def start_link(_initial_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call(:total_items, _from, state) do
    {:reply, Enum.count(state), state}
  end

  def handle_call({:add_item, product_code}, _from, state) do
    product = ProductStore.get_product(product_code)

    add_product_to_store(product, state)
  end

  def handle_call(:get_items, _from, state) do
    items = state |> Map.values()

    {:reply, items, state}
  end

  def total_items() do
    GenServer.call(__MODULE__, :total_items)
  end

  def add_item(code) do
    GenServer.call(__MODULE__, {:add_item, code})
  end

  def get_items() do
    GenServer.call(__MODULE__, :get_items)
  end

  defp add_product_to_store(product, state) when is_nil(product) do
    {:reply, {:error, "Product not found"}, state}
  end

  defp add_product_to_store(product, state) do
    new_state = Map.put_new(state, product.code, %CartItem{product: product, quantity: 0})
    new_quantity = new_state[product.code].quantity + 1

    new_state =
      Map.put(new_state, product.code, %CartItem{product: product, quantity: new_quantity})

    {:reply, {:ok, new_state[product.code]}, new_state}
  end
end

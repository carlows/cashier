defmodule ProductStore do
  @moduledoc """
  ProductStore maintains the state of the products available to checkout.
  """
  use GenServer

  def start_link(_initial_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call({:add_product, product}, _from, state) do
    product_item = %Product{
      code: product.code,
      name: product.name,
      price: Money.new(product.price)
    }

    updated_store = Map.put(state, product.code, product_item)

    {:reply, {:ok, product_item}, updated_store}
  end

  def handle_call({:get_product, code}, _from, state) do
    {:reply, Map.get(state, code), state}
  end

  def add_product(%{name: _name, code: _code, price: _price} = product) do
    GenServer.call(__MODULE__, {:add_product, product})
  end

  def add_product(_product) do
    {:error, "Products must have at least a code, a name and a price."}
  end

  def get_product(code) do
    GenServer.call(__MODULE__, {:get_product, code})
  end
end

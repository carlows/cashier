defmodule Cashier.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = children_per_env(Application.get_env(:cashier, :env))

    opts = [strategy: :one_for_one, name: Cashier.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children_per_env(:test) do
    []
  end

  defp children_per_env(_) do
    [
      {ProductStore, %{}},
      {Cart, %{}}
    ]
  end
end

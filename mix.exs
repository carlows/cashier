defmodule Cashier.MixProject do
  use Mix.Project

  def project do
    [
      app: :cashier,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Cashier.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:money, "~> 1.12"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end

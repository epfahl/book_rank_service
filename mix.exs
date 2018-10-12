defmodule BookRankService.MixProject do
  use Mix.Project

  def project do
    [
      app: :book_rank_service,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BookRankService.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "== 1.6.4"},
      {:cowboy, "== 2.5.0"},
      {:httpoison, "~> 1.3"},
      {:floki, "~> 0.20.4"},
      {:poison, "~> 4.0"},
      {:cors_plug, "~> 1.5"}
    ]
  end
end

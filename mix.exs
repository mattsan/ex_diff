defmodule ExDiff.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_diff,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      name: "ExDiff",
      source_url: "https://github.com/mattsan/ex_diff",
      homepage_url: "https://github.com/mattsan/ex_diff",
      docs: [
        main: "ExDiff",
        extras: [
          "README.md"
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:ex_doc, "~> 0.16", only: :dev, runtime: false}]
  end

  defp escript do
    [main_module: ExDiff.CLI]
  end
end

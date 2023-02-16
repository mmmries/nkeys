defmodule Nkeys.MixProject do
  use Mix.Project

  def project do
    [
      app: :nkeys,
      version: "0.2.2",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Support for nkey parsing and signing",
      package: [
        name: "nkeys",
        licenses: ["MIT"],
        links: %{
          "github" => "https://github.com/mmmries/nkeys"
        }
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
    [
      {:ed25519, "~> 1.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end

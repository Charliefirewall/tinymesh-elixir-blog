defmodule Bern.MixProject do
  use Mix.Project

  def project do
    [
      app: :bern,
      version: File.read!("VERSION") |> String.trim(),
      # version: "0.7.2",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        bern: [
          include_executables_for: [:unix],
          include_erts: true,
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  def application do
    [
      mod: {Bern.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:castore, "~> 0.1.5"},
      {:earmark, "1.4.15"},
      {:earmark_parser, "1.4.16"},
      {:jason, "~> 1.0"},
      {:makeup_elixir, ">= 0.0.0"},
      {:mint, "~> 1.0"},
      {:nimble_publisher, "~> 0.1.0"},
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:phoenix_live_view, "~> 0.17"},
      {:plug_cowboy, "~> 2.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:tz, "~> 0.12"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      # Dev / Test
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:floki, ">= 0.0.0", only: [:dev, :test]},
      {:finch, "~> 0.3", only: [:dev, :test]},
      {:phoenix_live_reload, "~> 1.2", only: :dev}
    ]
  end

  defp aliases do
    [
      "assets.deploy": [
        "tailwind default --minify",
        "esbuild default --minify",
        "phx.digest"
      ],
      setup: [
        "deps.get",
        "cmd npm --prefix assets install"
      ]
    ]
  end
end

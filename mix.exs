defmodule IprApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ipr_api,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {IprApi.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo, :bamboo_smtp, :edeliver, :scrivener_ecto, :timex],
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.6"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:argon2_elixir, "~> 2.0"},
      {:guardian, "~> 1.2"},
      {:cors_plug, "~> 2.0"},
      {:bodyguard, "~> 2.2"},
      {:bamboo_smtp, "~> 1.7"},
      {:distillery, "~> 2.0", warn_missing: false},
      {:edeliver, "~> 1.6"},
      {:ecto_enum, "~> 1.3"},
      {:scrivener_ecto, "~> 2.0"},
      {:timex, "~> 3.5"},
      {:elixlsx, "~> 0.4.2"},
      {:phoenix_html, "~> 2.13"},
      {:sentry, "~> 7.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

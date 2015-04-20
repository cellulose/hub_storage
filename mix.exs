defmodule HubStorage.Mixfile do
  use Mix.Project

  def project do
    [app: :hub_storage,
     version: version,
     elixir: "~> 1.0",
     deps: deps(Mix.env)]
  end

  #For testing add :cowboy and :jsx to applications
  def application, do: [
      applications: [ :hub]
  ]

  defp deps(:test), do: deps(:dev) ++ [
      { :httpotion, github: "myfreeweb/httpotion"},
      { :cowboy, "~> 1.0" },
      { :jsx, github: "talentdeficit/jsx", ref: "v1.4.3", override: true },
      { :jrtp_bridge, github: "cellulose/jrtp_bridge"}
  ]

  defp deps(_) do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.7", only: :dev},
      {:persistent_storage, github: "cellulose/persistent_storage"},
      {:hub, github: "cellulose/hub"}
    ]
  end

  defp version do
    case File.read("VERSION") do
      {:ok, ver} -> String.strip ver
      _ -> "0.0.0-dev"
    end
  end
end

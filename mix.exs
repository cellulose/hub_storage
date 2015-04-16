defmodule HubStorage.Mixfile do
  use Mix.Project

  def project do
    [app: :hub_storage,
     version: "0.1.0",
     elixir: "~> 1.0",
     deps: deps(Mix.env)]
  end

  #For testing add :cowboy and :jsx to applications
  def application, do: [
      applications: [ :hub, :logger]
  ]

  defp deps(:test), do: deps(:dev) ++ [
      { :httpotion, github: "myfreeweb/httpotion"},
      { :cowboy, "~> 1.0" },
      { :jsx, github: "talentdeficit/jsx", ref: "v1.4.3", override: true },
      { :jrtp_bridge, github: "cellulose/jrtp_bridge"}
  ]

  defp deps(_) do
    [
      {:persistent_storage, github: "cellulose/persistent_storage"},
      {:hub, github: "cellulose/hub"}
    ]
  end
end

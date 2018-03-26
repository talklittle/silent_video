defmodule SilentVideo.Mixfile do
  use Mix.Project

  def project do
    [app: :silent_video,
     version: "0.3.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ffmpex, "~> 0.5.0"},
     {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp description do
    "Convert GIF and video to silent video."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "CHANGELOG*", "LICENSE*"],
      maintainers: ["Andrew Shu"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/talklittle/silent_video"}
    ]
  end
end

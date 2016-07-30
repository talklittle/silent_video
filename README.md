# SilentVideo

Convert GIFs and videos to silent videos, optimized for mobile playback.

## Prerequisites

[FFmpeg](https://ffmpeg.org/) must be installed.

## Installation

The SilentVideo package can be installed as:

  1. Add `silent_video` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:silent_video, "~> 0.1.0"}]
    end
    ```

  2. Ensure `silent_video` is started before your application:

    ```elixir
    def application do
      [applications: [:silent_video]]
    end
    ```

## License

SilentVideo source code is licensed under the [MIT License](LICENSE.md).
# SilentVideo

[![Build Status](https://travis-ci.org/talklittle/silent_video.svg?branch=master)](https://travis-ci.org/talklittle/silent_video)

Convert GIFs and videos to silent videos, optimized for mobile playback.

Documentation: https://hexdocs.pm/silent_video/

## Example

```elixir
SilentVideo.convert_mobile("/path/to/input.gif", "/path/to/output.mp4")
```

## Prerequisites

[FFmpeg](https://ffmpeg.org/) must be installed.

## Installation

Add `silent_video` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:silent_video, "~> 0.3.1"}]
end
```

## Release notes

See the [changelog](CHANGELOG.md) for changes between versions.

## License

SilentVideo source code is licensed under the [MIT License](LICENSE.md).

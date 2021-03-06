defmodule SilentVideo do
  alias SilentVideo.Presets

  @doc """
  Convert using high compatibility settings for mobile devices.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:max_width` - An integer maximum width for the output video.
  * `:max_height` - An integer maximum height for the output video.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 384_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to 13.
  """
  @spec convert_mobile(input_file_path :: binary, output_file_path :: binary, Keyword.t)
        :: :ok | {:error, {Collectable.t, exit_status :: non_neg_integer}}
  def convert_mobile(input_file_path, output_file_path, opts \\ []) do
    Presets.mobile_1(Path.expand(input_file_path), Path.expand(output_file_path), opts)
  end

  @doc """
  Alternate high compatibility settings for mobile devices.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:max_width` - An integer maximum width for the output video.
  * `:max_height` - An integer maximum height for the output video.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 250_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to input framerate.
  """
  @spec convert_mobile_2(input_file_path :: binary, output_file_path :: binary, Keyword.t)
        :: :ok | {:error, {Collectable.t, exit_status :: non_neg_integer}}
  def convert_mobile_2(input_file_path, output_file_path, opts \\ []) do
    Presets.mobile_2(Path.expand(input_file_path), Path.expand(output_file_path), opts)
  end

  @doc """
  Settings for general web streaming.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:max_width` - An integer maximum width for the output video.
  * `:max_height` - An integer maximum height for the output video.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 500_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to input framerate.
  """
  @spec convert_web(input_file_path :: binary, output_file_path :: binary, Keyword.t)
        :: :ok | {:error, {Collectable.t, exit_status :: non_neg_integer}}
  def convert_web(input_file_path, output_file_path, opts \\ []) do
    Presets.web_1(Path.expand(input_file_path), Path.expand(output_file_path), opts)
  end

  @doc """
  Settings for tablets.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:max_width` - An integer maximum width for the output video.
  * `:max_height` - An integer maximum height for the output video.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 400_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to input framerate.
  """
  @spec convert_tablet(input_file_path :: binary, output_file_path :: binary, Keyword.t)
        :: :ok | {:error, {Collectable.t, exit_status :: non_neg_integer}}
  def convert_tablet(input_file_path, output_file_path, opts \\ []) do
    Presets.tablet_1(Path.expand(input_file_path), Path.expand(output_file_path), opts)
  end
end

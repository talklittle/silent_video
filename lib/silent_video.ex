defmodule SilentVideo do
  alias SilentVideo.Presets

  @doc """
  Convert using high compatibility settings for mobile devices.

  Options:

  * `:height` - An integer height for the output video. Defaults to input height.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 384_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to 13.
  """
  def convert_mobile(input_file_path, output_file_path, opts \\ []) do
    Presets.mobile_1(Path.expand(input_file_path), Path.expand(output_file_path), opts)
  end

  @doc """
  Alternate high compatibility settings for mobile devices.

  Options:

  * `:height` - An integer height for the output video. Defaults to input height.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 250_000.
  """
  def convert_mobile_2(input_file_path, output_file_path, opts \\ []) do
    Presets.mobile_2(Path.expand(input_file_path), Path.expand(output_file_path), opts)
  end

  @doc """
  Settings for general web streaming.

  Options:

  * `:height` - An integer height for the output video. Defaults to input height.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 500_000.
  """
  def convert_web(input_file_path, output_file_path, opts \\ []) do
    Presets.web_1(Path.expand(input_file_path), Path.expand(output_file_path), opts)
  end

  @doc """
  Settings for tablets.

  Options:

  * `:height` - An integer height for the output video. Defaults to input height.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 400_000.
  """
  def convert_tablet(input_file_path, output_file_path, opts \\ []) do
    Presets.tablet_1(Path.expand(input_file_path), Path.expand(output_file_path), opts)
  end
end

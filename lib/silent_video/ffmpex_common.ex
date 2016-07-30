defmodule SilentVideo.FFmpexCommon do
  import FFmpex
  import FFmpex.Options.Audio
  import FFmpex.Options.Video
  import FFmpex.Options.Video.Libx264

  @doc """
  Remove audio track.
  """
  def remove_audio(ffmpex_command) do
    ffmpex_command
    |> add_file_option(option_an)
  end

  @doc """
  Use yuv420p pixel format instead of FFmpeg default yuv444p.
  Requires width divisible by 2, so adds "-vf scale=..." option.
  """
  def compatible_pixel_format(ffmpex_command, output_height \\ "ih") do
    ffmpex_command
    |> add_file_option(option_pix_fmt("yuv420p"))
    |> add_file_option(option_vf("scale=trunc(oh*a/2)*2:#{output_height}"))
  end

  @doc """
  Move the index to the beginning of the file so it can be streamed.
  """
  def streamable(ffmpex_command) do
    ffmpex_command
    |> add_file_option(option_movflags("faststart"))
  end
end
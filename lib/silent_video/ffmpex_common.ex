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
  Requires width and height divisible by 2, so adds "-vf scale=..." option.
  """
  def compatible_pixel_format(ffmpex_command, output_width \\ nil, output_height \\ nil) do
    ffmpex_command
    |> add_file_option(option_pix_fmt("yuv420p"))
    |> add_file_option(option_vf(even_scale(output_width, output_height)))
  end

  defp even_scale(nil, nil) do
    "scale=trunc(iw/2)*2:trunc(ih/2)*2"
  end
  defp even_scale(nil, output_height) do
    "scale=-2:#{round(output_height/2)*2}"
  end
  defp even_scale(output_width, nil) do
    "scale=#{round(output_width/2)*2}:-2"
  end
  defp even_scale(output_width, output_height) do
    "scale=#{round(output_width/2)*2}:#{round(output_height/2)*2}"
  end

  @doc """
  Move the index to the beginning of the file so it can be streamed.
  """
  def streamable(ffmpex_command) do
    ffmpex_command
    |> add_file_option(option_movflags("faststart"))
  end
end
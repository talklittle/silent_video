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
  def compatible_pixel_format(ffmpex_command, output_width \\ nil, output_height \\ nil,
                              max_width \\ nil, max_height \\ nil) do
    ffmpex_command
    |> add_file_option(option_pix_fmt("yuv420p"))
    |> add_file_option(option_vf(even_scale(output_width, output_height, max_width, max_height)))
  end

  defp even_scale(w, h, maxw, maxh) when is_integer(w) and rem(w, 2) == 1 do
    even_scale(round(w/2)*2, h, maxw, maxh)
  end
  defp even_scale(w, h, maxw, maxh) when is_integer(h) and rem(h, 2) == 1 do
    even_scale(w, round(h/2)*2, maxw, maxh)
  end
  defp even_scale(w, h, maxw, maxh) when is_integer(maxw) and rem(maxw, 2) == 1 do
    even_scale(w, h, round(maxw/2)*2, maxh)
  end
  defp even_scale(w, h, maxw, maxh) when is_integer(maxh) and rem(maxh, 2) == 1 do
    even_scale(w, h, maxw, round(maxh/2)*2)
  end
  defp even_scale(nil, nil, nil, nil), do: "scale=trunc(iw/2)*2:trunc(ih/2)*2"
  defp even_scale(nil, h, nil, nil), do: "scale=-2:#{h}"
  defp even_scale(w, nil, nil, nil), do: "scale=#{w}:-2"
  defp even_scale(w, h, nil, nil), do: "scale=#{w}:#{h}"
  defp even_scale(nil, nil, nil, maxh), do: "scale=-2:'if(gt(ih\\,#{maxh})\\,#{maxh}\\,trunc(ih/2)*2)'"
  defp even_scale(nil, nil, maxw, nil), do: "scale='if(gt(iw\\,#{maxw})\\,#{maxw}\\,trunc(iw/2)*2)':-2"
  defp even_scale(nil, nil, maxw, maxh) do
    iw_gt_maxw = "gt(iw\\,#{maxw})"
    ih_gt_maxh = "gt(ih\\,#{maxh})"
    any_too_big = "#{iw_gt_maxw}+#{ih_gt_maxh}"
    all_too_big = "#{iw_gt_maxw}*#{ih_gt_maxh}"

    fits = "not(#{any_too_big})"
    wide_aspect = "gt(a\\,#{maxw/maxh})"

    width = Enum.join([
      # if it fits within the max, only truncate
      "'if(#{fits}\\,trunc(iw/2)*2\\,",

      # if all too big and wide aspect, then clamp width
      "if(#{all_too_big}*#{wide_aspect}\\,#{maxw}\\,",
      # else if all too big and tall aspect, then preserve aspect ratio (clamp height)
      "if(#{all_too_big}\\,-2\\,",
      # else if too wide only, then clamp width
      "if(#{iw_gt_maxw}\\,#{maxw}\\,",
      # else it's too tall, so preserve aspect ratio (clamp height)
      "-2",

      ")",
      ")",
      ")",
      ")'"
    ], "")

    height = Enum.join([
      # if it fits within the max, only truncate
      "'if(#{fits}\\,trunc(ih/2)*2\\,",

      # if all too big and wide aspect, then preserve aspect ratio (clamp width)
      "if(#{all_too_big}*#{wide_aspect}\\,-2\\,",
      # else if all too big and tall aspect, then clamp height
      "if(#{all_too_big}\\,#{maxh}\\,",
      # else if too tall only, then clamp height
      "if(#{ih_gt_maxh}\\,#{maxh}\\,",
      # else it's too wide, so preserve aspect ratio (clamp width)
      "-2",

      ")",
      ")",
      ")",
      ")'"
    ], "")

    "scale=#{width}:#{height}"
  end
  defp even_scale(nil, h, nil, maxh) when h > maxh, do: even_scale(nil, nil, nil, maxh)
  defp even_scale(nil, h, nil, _maxh), do: even_scale(nil, h, nil, nil)
  defp even_scale(w, nil, nil, maxh) do
    # use width if wide aspect ratio, otherwise clamp height
    wide_aspect = "gt(a\\,#{w/maxh})"
    width = "if(#{wide_aspect}\\,#{w}\\,-2)"
    height = "if(#{wide_aspect}\\,-2\\,#{maxh})"
    "scale=#{width}:#{height}"
  end
  defp even_scale(w, h, nil, maxh) when h > maxh, do: even_scale(w, nil, nil, maxh)
  defp even_scale(w, h, nil, _maxh), do: even_scale(w, h, nil, nil)
  defp even_scale(nil, h, maxw, nil) do
    # use height if tall aspect ratio, otherwise clamp width
    tall_aspect = "lt(a\\,#{maxw/h})"
    height = "if(#{tall_aspect}\\,#{h}\\,-2)"
    width = "if(#{tall_aspect}\\,-2\\,#{maxw})"
    "scale=#{width}:#{height}"
  end
  defp even_scale(w, nil, maxw, nil) when w > maxw, do: even_scale(nil, nil, maxw, nil)
  defp even_scale(w, nil, _maxw, nil), do: even_scale(w, nil, nil, nil)
  defp even_scale(w, h, maxw, nil) when w > maxw, do: even_scale(nil, h, maxw, nil)
  defp even_scale(w, h, _maxw, nil), do: even_scale(w, h, nil, nil)
  defp even_scale(nil, h, maxw, maxh) when h > maxh, do: even_scale(nil, nil, maxw, maxh)
  defp even_scale(nil, h, maxw, _maxh), do: even_scale(nil, h, maxw, nil)
  defp even_scale(w, nil, maxw, maxh) when w > maxw, do: even_scale(nil, nil, maxw, maxh)
  defp even_scale(w, nil, _maxw, maxh), do: even_scale(w, nil, nil, maxh)
  defp even_scale(w, h, maxw, maxh) when w > maxw and h > maxh, do: even_scale(nil, nil, maxw, maxh)
  defp even_scale(w, h, maxw, maxh) when w > maxw, do: even_scale(nil, h, maxw, maxh)
  defp even_scale(w, h, maxw, maxh) when h > maxh, do: even_scale(w, nil, maxw, maxh)
  defp even_scale(w, h, _maxw, _maxh), do: even_scale(w, h, nil, nil)

  @doc """
  Move the index to the beginning of the file so it can be streamed.
  """
  def streamable(ffmpex_command) do
    ffmpex_command
    |> add_file_option(option_movflags("faststart"))
  end
end
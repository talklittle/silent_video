defmodule SilentVideo.Presets do

  import FFmpex
  use FFmpex.Options
  import SilentVideo.FFmpexCommon

  @doc """
  A preset targeting Android and iOS devices.

  Explicitly specifies a lot of options to pin down behavior,
  although it may or may not be safer to omit some of these and use
  a predefined FFmpeg profile instead.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:max_width` - An integer maximum width for the output video.
  * `:max_height` - An integer maximum height for the output video.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 384_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to 13.
  """
  @spec mobile_1(binary, binary, keyword) :: :ok | {:error, {binary, non_neg_integer}}
  def mobile_1(input_file_path, output_file_path, opts \\ []) do
    output_width = integer_opt(opts, :width, nil)
    output_height = integer_opt(opts, :height, nil)
    max_width = integer_opt(opts, :max_width, nil)
    max_height = integer_opt(opts, :max_height, nil)
    bitrate = integer_opt(opts, :bitrate, 384_000)
    framerate = integer_opt(opts, :framerate, 13)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
      |> add_stream_specifier(stream_type: :video)
        |> add_stream_option(option_b(bitrate))
      |> add_file_option(option_vcodec("libx264"))
      |> add_file_option(option_flags("+loop+mv4"))
      |> add_file_option(option_cmp(256))
      |> add_file_option(option_partitions("+parti4x4+parti8x8+partp4x4+partp8x8"))
      |> add_file_option(option_subq(6))
      |> add_file_option(option_trellis(0))
      |> add_file_option(option_refs(5))
      |> add_file_option(option_bf(0))
      |> add_file_option(option_mixed_refs(1))
      |> add_file_option(option_coder(0))
      |> add_file_option(option_me_range(16))
      |> add_file_option(option_g(250))
      |> add_file_option(option_keyint_min(25))
      |> add_file_option(option_sc_threshold(40))
      |> add_file_option(option_i_qfactor(0.71))
      |> add_file_option(option_qmin(10))
      |> add_file_option(option_qmax(51))
      |> add_file_option(option_qdiff(4))
      |> add_file_framerate_if_number(framerate)
      |> remove_audio
      |> compatible_pixel_format(output_width, output_height, max_width, max_height)
      |> streamable
    |> execute
    |> format_return_value
  end

  @doc """
  Lower quality video targeting compatibility for older mobile devices.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:max_width` - An integer maximum width for the output video.
  * `:max_height` - An integer maximum height for the output video.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 250_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to input framerate.
  """
  @spec mobile_2(binary, binary, keyword) :: :ok | {:error, {binary, non_neg_integer}}
  def mobile_2(input_file_path, output_file_path, opts \\ []) do
    output_width = integer_opt(opts, :width, nil)
    output_height = integer_opt(opts, :height, nil)
    max_width = integer_opt(opts, :max_width, nil)
    max_height = integer_opt(opts, :max_height, nil)
    bitrate = integer_opt(opts, :bitrate, 250_000)
    framerate = integer_opt(opts, :framerate, nil)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
      |> add_stream_specifier(stream_type: :video)
        |> add_stream_option(option_codec("libx264"))
        |> add_stream_option(option_b(bitrate))
        |> add_stream_option(option_maxrate(bitrate))
        |> add_stream_option(option_bufsize(2 * bitrate))
      |> add_file_option(option_profile("baseline"))
      |> add_file_framerate_if_number(framerate)
      |> remove_audio
      |> compatible_pixel_format(output_width, output_height, max_width, max_height)
      |> streamable
    |> execute
    |> format_return_value
  end

  @doc """
  Video intended for web streaming.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:max_width` - An integer maximum width for the output video.
  * `:max_height` - An integer maximum height for the output video.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 500_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to input framerate.
  """
  @spec web_1(binary, binary, keyword) :: :ok | {:error, {binary, non_neg_integer}}
  def web_1(input_file_path, output_file_path, opts \\ []) do
    output_width = integer_opt(opts, :width, nil)
    output_height = integer_opt(opts, :height, nil)
    max_width = integer_opt(opts, :max_width, nil)
    max_height = integer_opt(opts, :max_height, nil)
    bitrate = integer_opt(opts, :bitrate, 500_000)
    framerate = integer_opt(opts, :framerate, nil)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
      |> add_stream_specifier(stream_type: :video)
        |> add_stream_option(option_codec("libx264"))
        |> add_stream_option(option_b(bitrate))
        |> add_stream_option(option_maxrate(bitrate))
        |> add_stream_option(option_bufsize(2 * bitrate))
      |> add_file_option(option_profile("high"))
      |> add_file_framerate_if_number(framerate)
      |> remove_audio
      |> compatible_pixel_format(output_width, output_height, max_width, max_height)
      |> streamable
    |> execute
    |> format_return_value
  end

  @doc """
  Targeting tablet devices.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:max_width` - An integer maximum width for the output video.
  * `:max_height` - An integer maximum height for the output video.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 400_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to input framerate.
  """
  @spec tablet_1(binary, binary, keyword) :: :ok | {:error, {binary, non_neg_integer}}
  def tablet_1(input_file_path, output_file_path, opts \\ []) do
    output_width = integer_opt(opts, :width, nil)
    output_height = integer_opt(opts, :height, nil)
    max_width = integer_opt(opts, :max_width, nil)
    max_height = integer_opt(opts, :max_height, nil)
    bitrate = integer_opt(opts, :bitrate, 400_000)
    framerate = integer_opt(opts, :framerate, nil)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
      |> add_stream_specifier(stream_type: :video)
        |> add_stream_option(option_codec("libx264"))
        |> add_stream_option(option_b(bitrate))
        |> add_stream_option(option_maxrate(bitrate))
        |> add_stream_option(option_bufsize(2 * bitrate))
      |> add_file_option(option_profile("main"))
      |> add_file_framerate_if_number(framerate)
      |> remove_audio
      |> compatible_pixel_format(output_width, output_height, max_width, max_height)
      |> streamable
    |> execute
    |> format_return_value
  end

  defp new_command_common_options do
    FFmpex.new_command
    |> add_global_option(option_y())  # overwrite output files
  end

  defp add_file_framerate_if_number(command, framerate) when is_number(framerate) do
    command |> add_file_option(option_r(framerate))
  end
  defp add_file_framerate_if_number(command, _framerate), do: command

  defp integer_opt(opts, key, default) do
    value = Keyword.get(opts, key)
    if is_integer(value), do: value, else: default
  end

  # Format the return value of FFmpex.execute/1
  defp format_return_value({:ok, _}), do: :ok
  defp format_return_value({:error, error}), do: {:error, error}
end

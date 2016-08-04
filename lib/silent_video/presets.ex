defmodule SilentVideo.Presets do

  alias FFmpex.StreamSpecifier

  import FFmpex
  import FFmpex.Options.Main
  import FFmpex.Options.Video
  import FFmpex.Options.Video.Libx264
  import SilentVideo.FFmpexCommon

  @doc """
  A preset targeting Android and iOS devices.

  Explicitly specifies a lot of options to pin down behavior,
  although it may or may not be safer to omit some of these and use
  a predefined FFmpeg profile instead.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 384_000.
  * `:framerate` - An integer framerate (frames per second). Defaults to 13.
  """
  def mobile_1(input_file_path, output_file_path, opts \\ []) do
    output_width = integer_opt(opts, :width, nil)
    output_height = integer_opt(opts, :height, nil)
    bitrate = integer_opt(opts, :bitrate, 384_000)
    framerate = integer_opt(opts, :framerate, 13)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
      |> add_stream_specifier(%StreamSpecifier{stream_type: :video})
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
      |> add_file_option(option_r(framerate))
      |> remove_audio
      |> compatible_pixel_format(output_width, output_height)
      |> streamable
    |> execute
  end

  @doc """
  Lower quality video targeting compatibility for older mobile devices.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 250_000.
  """
  def mobile_2(input_file_path, output_file_path, opts \\ []) do
    output_width = integer_opt(opts, :width, nil)
    output_height = integer_opt(opts, :height, nil)
    bitrate = integer_opt(opts, :bitrate, 250_000)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
      |> add_stream_specifier(%StreamSpecifier{stream_type: :video})
        |> add_stream_option(option_codec("libx264"))
        |> add_stream_option(option_b(bitrate))
        |> add_stream_option(option_maxrate(bitrate))
        |> add_stream_option(option_bufsize(2 * bitrate))
      |> add_file_option(option_profile("baseline"))
      |> remove_audio
      |> compatible_pixel_format(output_width, output_height)
      |> streamable
    |> execute
  end

  @doc """
  Video intended for web streaming.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 500_000.
  """
  def web_1(input_file_path, output_file_path, opts \\ []) do
    output_width = integer_opt(opts, :width, nil)
    output_height = integer_opt(opts, :height, nil)
    bitrate = integer_opt(opts, :bitrate, 500_000)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
      |> add_stream_specifier(%StreamSpecifier{stream_type: :video})
        |> add_stream_option(option_codec("libx264"))
        |> add_stream_option(option_b(bitrate))
        |> add_stream_option(option_maxrate(bitrate))
        |> add_stream_option(option_bufsize(2 * bitrate))
      |> add_file_option(option_profile("high"))
      |> remove_audio
      |> compatible_pixel_format(output_width, output_height)
      |> streamable
    |> execute
  end

  @doc """
  Targeting tablet devices.

  Options:

  * `:width` - An integer width for the output video. Defaults to input width.
  * `:height` - An integer height for the output video. Defaults to input height.
  * `:bitrate` - An integer bitrate for the output video. Defaults to 400_000.
  """
  def tablet_1(input_file_path, output_file_path, opts \\ []) do
    output_width = integer_opt(opts, :width, nil)
    output_height = integer_opt(opts, :height, nil)
    bitrate = integer_opt(opts, :bitrate, 400_000)

    new_command_common_options()
    |> add_input_file(input_file_path)
    |> add_output_file(output_file_path)
      |> add_stream_specifier(%StreamSpecifier{stream_type: :video})
        |> add_stream_option(option_codec("libx264"))
        |> add_stream_option(option_b(bitrate))
        |> add_stream_option(option_maxrate(bitrate))
        |> add_stream_option(option_bufsize(2 * bitrate))
      |> add_file_option(option_profile("main"))
      |> remove_audio
      |> compatible_pixel_format(output_width, output_height)
      |> streamable
    |> execute
  end

  defp new_command_common_options do
    FFmpex.new_command
    |> add_global_option(option_y)  # overwrite output files
  end

  defp integer_opt(opts, key, default) do
    value = Keyword.get(opts, key)
    if is_integer(value), do: value, else: default
  end
end
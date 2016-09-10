defmodule SilentVideoTest do
  use ExUnit.Case
  doctest SilentVideo

  @fixture Path.join(__DIR__, "fixtures/test-mpeg.mpg")
  @output_path Path.join(System.tmp_dir, "silent-video-test-fixture.mp4")

  setup do
    on_exit fn ->
      File.rm @output_path
    end
  end

  test "convert mobile" do
    assert :ok = SilentVideo.convert_mobile(@fixture, @output_path)
  end

  test "convert mobile 2" do
    assert :ok = SilentVideo.convert_mobile_2(@fixture, @output_path)
  end

  test "convert web" do
    assert :ok = SilentVideo.convert_web(@fixture, @output_path)
  end

  test "convert tablet" do
    assert :ok = SilentVideo.convert_tablet(@fixture, @output_path)
  end

  test "bitrate changes file size" do
    out1 = Path.rootname(@output_path) <> "1.mp4"
    out2 = Path.rootname(@output_path) <> "2.mp4"
    :ok = SilentVideo.convert_mobile(@fixture, out1, bitrate: 100_000)
    :ok = SilentVideo.convert_mobile(@fixture, out2, bitrate: 200_000)
    stat1 = File.stat! out1
    stat2 = File.stat! out2
    assert stat1.size < stat2.size
  end

  test "handles odd width and height" do
    assert :ok = SilentVideo.convert_mobile(@fixture, @output_path, width: 99, height: 99)
  end

  test "handles odd max_width and max_height" do
    assert :ok = SilentVideo.convert_mobile(@fixture, @output_path, max_width: 99, max_height: 99)
  end
end

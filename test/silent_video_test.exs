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
    assert {_, 0} = SilentVideo.convert_mobile(@fixture, @output_path)
  end

  test "convert mobile 2" do
    assert {_, 0} = SilentVideo.convert_mobile_2(@fixture, @output_path)
  end

  test "convert web" do
    assert {_, 0} = SilentVideo.convert_web(@fixture, @output_path)
  end

  test "convert tablet" do
    assert {_, 0} = SilentVideo.convert_tablet(@fixture, @output_path)
  end

  test "bitrate changes file size" do
    out1 = Path.rootname(@output_path) <> "1.mp4"
    out2 = Path.rootname(@output_path) <> "2.mp4"
    {_, 0} = SilentVideo.convert_mobile(@fixture, out1, bitrate: 100_000)
    {_, 0} = SilentVideo.convert_mobile(@fixture, out2, bitrate: 200_000)
    stat1 = File.stat! out1
    stat2 = File.stat! out2
    assert stat1.size < stat2.size
  end

  test "handles odd width and height" do
    assert {_, 0} = SilentVideo.convert_mobile(@fixture, @output_path, width: 99, height: 99)
  end
end

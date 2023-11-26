defmodule AdventOfCode.Year2019.Day08 do
  @moduledoc """
  https://adventofcode.com/2019/day/8
  """
  use AdventOfCode, year: 2019, day: 8

  @impl AdventOfCode
  def test_input, do: raise("no test data")

  def parse(input) do
    input
    |> String.trim_trailing("\n")
    |> String.to_charlist()
    |> Enum.chunk_every(25 * 6)
  end

  @impl AdventOfCode
  def part1(input) do
    layer =
      input
      |> parse()
      |> Enum.min_by(fn layer -> Enum.count(layer, &(&1 == ?0)) end)

    Enum.count(layer, &(&1 == ?1)) * Enum.count(layer, &(&1 == ?2))
  end

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.reduce(&apply_layer/2)
    |> construct_image()
  end

  def apply_layer(layer, image) do
    image
    |> Enum.zip(layer)
    |> Enum.map(fn
      {?2, layer_pixel} -> layer_pixel
      {image_pixel, _layer_pixel} -> image_pixel
    end)
  end

  def construct_image(image) do
    image
    |> Enum.map(fn
      ?0 -> ~c"  "
      ?1 -> ~c"██"
    end)
    |> Enum.chunk_every(25)
    |> Enum.intersperse("\n")
    |> IO.chardata_to_string()
  end
end

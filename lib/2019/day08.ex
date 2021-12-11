defmodule AdventOfCode.Year2019.Day08 do
  @moduledoc """
  https://adventofcode.com/2019/day/8
  """
  use AdventOfCode

  @type pixel() :: char()
  @type line() :: list(pixel())
  @type layer() :: list(line())
  @type image() :: list(layer())

  @impl AdventOfCode
  def test_input, do: raise("no test data")

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2019", "day08.in"])
    |> File.read!()
  end

  @impl AdventOfCode
  def part1(input) do
    {_zeros, list} =
      input
      |> String.trim_trailing("\n")
      |> String.to_charlist()
      |> Enum.chunk_every(25 * 6)
      |> Enum.map(fn list -> {Enum.count(list, &(&1 == ?0)), list} end)
      |> Enum.min_by(&elem(&1, 0))

    ones = Enum.count(list, &(&1 == ?1))
    twos = Enum.count(list, &(&1 == ?2))

    ones * twos
  end

  @impl AdventOfCode
  def part2(input) do
    input =
      input
      |> String.trim_trailing("\n")
      |> String.to_charlist()
      |> Enum.chunk_every(25 * 6)

    input
    |> Enum.reduce(&apply_layer/2)
    |> Enum.chunk_every(25)
    |> Enum.join("\n")
    |> String.replace("0", " ")
    |> String.replace("1", <<9_608::utf8>>)
  end

  @spec apply_layer(layer(), layer()) :: layer()
  def apply_layer(layer, image) do
    image
    |> Enum.zip(layer)
    |> Enum.map(fn
      {?2, layer_pixel} -> layer_pixel
      {image_pixel, _layer_pixel} -> image_pixel
    end)
  end
end

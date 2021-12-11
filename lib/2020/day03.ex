defmodule AdventOfCode.Year2020.Day03 do
  @moduledoc """
  https://adventofcode.com/2020/day/3
  """
  use AdventOfCode

  @impl AdventOfCode
  def test_input do
    """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2020", "day03.in"])
    |> File.read!()
  end

  @impl AdventOfCode
  def part1(input) do
    [_ | input] = input |> String.split(["\n"], trim: true)

    find_slope(input, 3)
  end

  defp find_slope(input, inc, count \\ 0, pos \\ 0)

  defp find_slope([row | input], inc, count, pos) do
    new_pos = pos + inc
    new_count = count + calc(row, new_pos)

    find_slope(input, inc, new_count, new_pos)
  end

  defp find_slope([], _inc, count, _pos), do: count

  def calc(input, pos) do
    if String.at(input, rem(pos, String.length(input))) == "#", do: 1, else: 0
  end

  @impl AdventOfCode
  def part2(input) do
    [_ | input] = String.split(input, ["\n"], trim: true)

    input
    |> find_slope(1)
    |> Kernel.*(find_slope(input, 3))
    |> Kernel.*(find_slope(input, 5))
    |> Kernel.*(find_slope(input, 7))
    |> Kernel.*(find_slope2(input, 1))
  end

  defp find_slope2(input, inc, count \\ 0, pos \\ 0)

  defp find_slope2([_, row | input], inc, count, pos) do
    new_pos = pos + inc
    new_count = count + calc(row, new_pos)

    find_slope2(input, inc, new_count, new_pos)
  end

  defp find_slope2([], _inc, count, _pos), do: count
end

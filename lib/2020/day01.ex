defmodule AdventOfCode.Year2020.Day01 do
  @moduledoc """
  https://adventofcode.com/2020/day/1
  """
  use AdventOfCode

  alias AdventOfCode.Parser

  @impl AdventOfCode
  def test_input do
    """
    1721
    979
    366
    299
    675
    1456
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2020", "day01.in"])
    |> File.read!()
  end

  @impl AdventOfCode
  def part1(input) do
    [f | _] =
      sorted =
      input
      |> Parser.lines()
      |> Enum.sort()

    # filter out obviously too big values
    filtered = Enum.filter(sorted, &(&1 <= 2020 - f))
    # get reversed input
    reversed = Enum.reverse(filtered)

    find_sum_two(filtered, reversed)
  end

  def find_sum_two([s | sorted], [r | reversed]) do
    cond do
      s + r > 2020 -> find_sum_two([s | sorted], reversed)
      s + r < 2020 -> find_sum_two(sorted, [r | reversed])
      s + r == 2020 -> s * r
    end
  end

  @impl AdventOfCode
  def part2(input) do
    [f, s | _] =
      sorted =
      input
      |> Parser.lines()
      |> Enum.sort()

    # filter out obviously too big values
    [_ | third] = filtered = Enum.filter(sorted, &(&1 < 2020 - (f + s)))
    # get reversed input
    reversed = Enum.reverse(filtered)

    find_sum_three(filtered, third, reversed)
  end

  def find_sum_three([_, f | first], [s | _], [s | _]),
    do: find_sum_three([f | first], first, Enum.reverse(first))

  def find_sum_three([f | first], [s | second], [t | third]) when f + s + t > 2020 do
    find_sum_three([f | first], [s | second], third)
  end

  def find_sum_three([f | first], [s | second], [t | third]) when f + s + t < 2020 do
    find_sum_three([f | first], second, [t | third])
  end

  def find_sum_three([f | _first], [s | _second], [t | _third]) when f + s + t == 2020 do
    f * s * t
  end
end

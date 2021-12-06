defmodule AdventOfCode.Year2020.Day01 do
  @moduledoc """
  https://adventofcode.com/2020/day/1
  """
  use AdventOfCode, year: 2020, day: 01

  alias AdventOfCode.Parser

  @impl AdventOfCode
  def input, do: input_data() |> Parser.lines() |> Enum.sort()

  @impl AdventOfCode
  def part1([f | _] = sorted) do
    # filter out obviously too big values
    filtered = Enum.filter(sorted, &(&1 < 2020 - f))
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
  def part2([f, s | _] = sorted) do
    # filter out obviously too big values
    [_ | third] = filtered = Enum.filter(sorted, &(&1 < 2020 - (f + s)))
    # get reversed input
    reversed = Enum.reverse(filtered)

    find_sum_three(filtered, third, reversed)
  end

  def find_sum_three([_, f | first], [s | _], [s | _]),
    do: find_sum_three([f | first], first, Enum.reverse(first))

  def find_sum_three([f | first], [s | second], [t | third]) do
    cond do
      f + s + t > 2020 -> find_sum_three([f | first], [s | second], third)
      f + s + t < 2020 -> find_sum_three([f | first], second, [t | third])
      f + s + t == 2020 -> f * s * t
    end
  end
end

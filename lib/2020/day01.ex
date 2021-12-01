defmodule AdventOfCode.Year2020.Day01 do
  @moduledoc """
  https://adventofcode.com/2020/day/1
  """
  use AdventOfCode, year: 2020, day: 01

  @impl AdventOfCode
  def part1 do
    # get sorted input
    [f | _] = sorted = Enum.sort(input_numbers())
    # filter out obviously too big values
    filtered = Enum.filter(sorted, &(&1 < 2020 - f))
    # get reversed input
    reversed = Enum.reverse(filtered)

    find_sum_two(filtered, reversed)
  end

  defp find_sum_two([s | sorted], [r | reversed]) do
    cond do
      s + r > 2020 -> find_sum_two([s | sorted], reversed)
      s + r < 2020 -> find_sum_two(sorted, [r | reversed])
      s + r == 2020 -> s * r
    end
  end

  @impl AdventOfCode
  def part2 do
    # get sorted input
    [f, s | _] = sorted = Enum.sort(input_numbers())
    # filter out obviously too big values
    [_ | third] = filtered = Enum.filter(sorted, &(&1 < 2020 - (f + s)))
    # get reversed input
    reversed = Enum.reverse(filtered)

    find_sum_three(filtered, third, reversed)
  end

  defp find_sum_three([_, f | first], [s | _], [s | _]),
    do: find_sum_three([f | first], first, Enum.reverse(first))

  defp find_sum_three([f | first], [s | second], [t | third]) do
    cond do
      f + s + t > 2020 -> find_sum_three([f | first], [s | second], third)
      f + s + t < 2020 -> find_sum_three([f | first], second, [t | third])
      f + s + t == 2020 -> f * s * t
    end
  end
end

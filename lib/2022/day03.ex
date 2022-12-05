defmodule AdventOfCode.Year2022.Day03 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/3
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2022", "day03.in"])
    |> File.read!()
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&(&1 |> String.to_charlist() |> Enum.map(fn char -> weight(char) end)))
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&split/1)
    |> Enum.map(&find_dup1/1)
    |> Enum.sum()
  end

  defp split(data),
    do: {split(data, div(length(data), 2)), split(data, -div(length(data), 2))}

  defp split(data, l) do
    data
    |> Enum.take(l)
    |> Enum.sort()
    |> Enum.dedup()
  end

  defp find_dup1({[x | _list1], [x | _list2]}), do: x
  defp find_dup1({[x | list1], [y | _list2] = list2}) when x < y, do: find_dup1({list1, list2})
  defp find_dup1({[x | _list1] = list1, [y | list2]}) when x > y, do: find_dup1({list1, list2})

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.map(&Enum.sort/1)
    |> Enum.map(&Enum.dedup/1)
    |> Enum.chunk_every(3)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.map(&find_dup2/1)
    |> Enum.sum()
  end

  defp find_dup2({[x | _list1], [x | _list2], [x | _list3]}), do: x

  defp find_dup2({[x | list1], [y | _list2] = list2, [z | _list3] = list3})
       when x <= y and x <= z,
       do: find_dup2({list1, list2, list3})

  defp find_dup2({[x | _list1] = list1, [y | list2], [z | _list3] = list3})
       when y <= x and y <= z,
       do: find_dup2({list1, list2, list3})

  defp find_dup2({[x | _list1] = list1, [y | _list2] = list2, [z | list3]})
       when z <= x and z <= y,
       do: find_dup2({list1, list2, list3})

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  defp weight(char) when char >= ?a and char <= ?z, do: char - ?a + 1
  defp weight(char) when char >= ?A and char <= ?Z, do: char - ?A + 27
end

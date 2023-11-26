defmodule AdventOfCode.Year2022.Day20 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/20
  """
  use AdventOfCode, year: 2022, day: 20

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    1
    2
    -3
    3
    -2
    0
    4
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    data = parse(input)
    len = length(data)

    data =
      data
      |> Enum.reduce(data, &mix(&1, &2, len))
      |> Enum.map(&elem(&1, 0))

    i = Enum.find_index(data, &(&1 == 0))

    data =
      data
      |> Stream.cycle()
      |> Stream.take(3001 + i)
      |> Enum.to_list()

    Enum.at(data, 1000 + i) + Enum.at(data, 2000 + i) + Enum.at(data, 3000 + i)
  end

  def mix({value, index}, acc, len) do
    current_index = Enum.find_index(acc, fn {_v, i} -> i == index end)

    move_index =
      case current_index + value do
        m when m >= len or m < -len -> rem(m, len) + div(m, len)
        m when m > 0 -> m
        m when m <= 0 -> m - 1
      end

    {_data, acc} = List.pop_at(acc, current_index)
    List.insert_at(acc, move_index, {value, index})
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> dbg()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================
end

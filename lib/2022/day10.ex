defmodule AdventOfCode.Year2022.Day10 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/10
  """
  use AdventOfCode, year: 2022, day: 10

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    addx 15
    addx -11
    addx 6
    addx -3
    addx 5
    addx -1
    addx -8
    addx 13
    addx 4
    noop
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx -35
    addx 1
    addx 24
    addx -19
    addx 1
    addx 16
    addx -11
    noop
    noop
    addx 21
    addx -15
    noop
    noop
    addx -3
    addx 9
    addx 1
    addx -3
    addx 8
    addx 1
    addx 5
    noop
    noop
    noop
    noop
    noop
    addx -36
    noop
    addx 1
    addx 7
    noop
    noop
    noop
    addx 2
    addx 6
    noop
    noop
    noop
    noop
    noop
    addx 1
    noop
    noop
    addx 7
    addx 1
    noop
    addx -13
    addx 13
    addx 7
    noop
    addx 1
    addx -33
    noop
    noop
    noop
    addx 2
    noop
    noop
    noop
    addx 8
    noop
    addx -1
    addx 2
    addx 1
    noop
    addx 17
    addx -9
    addx 1
    addx 1
    addx -3
    addx 11
    noop
    noop
    addx 1
    noop
    addx 1
    noop
    noop
    addx -13
    addx -19
    addx 1
    addx 3
    addx 26
    addx -30
    addx 12
    addx -1
    addx 3
    addx 1
    noop
    noop
    noop
    addx -9
    addx 18
    addx 1
    addx 2
    noop
    noop
    addx 9
    noop
    noop
    noop
    addx -1
    addx 2
    addx -37
    addx 1
    addx 3
    noop
    addx 15
    addx -21
    addx 22
    addx -6
    addx 1
    noop
    addx 2
    addx 1
    noop
    addx -10
    noop
    noop
    addx 20
    addx 1
    addx 2
    addx 2
    addx -6
    addx -11
    noop
    noop
    noop
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn
      "noop" -> :noop
      "addx " <> v -> {:add_x, String.to_integer(v)}
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    indexes = [20, 60, 100, 140, 180, 220]

    input
    |> parse()
    |> execute_program()
    |> pick(indexes)
    |> Enum.sum()
  end

  def pick(list, indexes) do
    Enum.map(indexes, &get(list, &1))
  end

  def get(list, i), do: Enum.at(list, i - 1) * i

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> execute_program()
    |> Enum.chunk_every(40, 40, :discard)
    |> Enum.map(fn row ->
      row
      |> Enum.with_index()
      |> Enum.map(fn
        {x, i} when (x - i) in [-1, 0, 1] -> ~c"██"
        _i -> ~c"  "
      end)
    end)
    |> Enum.intersperse("\n")
    |> IO.chardata_to_string()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def execute_program(instructions) do
    instructions
    |> Enum.reduce([1], fn
      :noop, [x | rest] -> [x, x | rest]
      {:add_x, v}, [x | rest] -> [v + x, x, x | rest]
    end)
    |> Enum.reverse()
  end
end

defmodule AdventOfCode.Year2024.Day04 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/4
  """
  use AdventOfCode, year: 2024, day: 04

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    puzzle = parse(input)

    xmas(puzzle, length(puzzle))
  end

  def xmas(puzzle, size, pos \\ {0, 0}, result \\ 0)

  # X is out of bounds, go to next line
  def xmas(puzzle, size, {x, y}, result) when x == size,
    do: xmas(puzzle, size, {0, y + 1}, result)

  # Y is out of bounds, return result
  def xmas(_puzzle, size, {_x, y}, result) when y == size, do: result

  # otherwise find next X and check how many XMAS it is part of
  def xmas(puzzle, size, {x, y}, result) do
    case get_in(puzzle, [Access.at(y), Access.at(x)]) do
      ?X ->
        xmas(puzzle, size, {x + 1, y}, result + find_xmas(puzzle, {x, y}))

      _otherwise ->
        xmas(puzzle, size, {x + 1, y}, result)
    end
  end

  # check all 8 vectors and return how many contain XMAS
  def find_xmas(puzzle, {x, y}) do
    Enum.count(
      [
        is_xmas(puzzle, {x, y}, {0, 1}),
        is_xmas(puzzle, {x, y}, {0, -1}),
        is_xmas(puzzle, {x, y}, {1, 1}),
        is_xmas(puzzle, {x, y}, {1, 0}),
        is_xmas(puzzle, {x, y}, {1, -1}),
        is_xmas(puzzle, {x, y}, {-1, 1}),
        is_xmas(puzzle, {x, y}, {-1, 0}),
        is_xmas(puzzle, {x, y}, {-1, -1})
      ],
      & &1
    )
  end

  # negative indexes mess up the results
  def is_xmas(_puzzle, {x, _y}, {vx, _vy}) when x + 3 * vx < 0, do: false
  def is_xmas(_puzzle, {_x, y}, {_vx, vy}) when y + 3 * vy < 0, do: false

  # check 3 position alongside the vector to find MAS
  def is_xmas(puzzle, {x, y}, {vx, vy}) do
    get_in(puzzle, [Access.at(y + vy), Access.at(x + vx)]) == ?M and
      get_in(puzzle, [Access.at(y + 2 * vy), Access.at(x + 2 * vx)]) == ?A and
      get_in(puzzle, [Access.at(y + 3 * vy), Access.at(x + 3 * vx)]) == ?S
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    puzzle = parse(input)

    x_mas(puzzle, length(puzzle))
  end

  def x_mas(puzzle, size, pos \\ {0, 0}, result \\ 0)

  # X is out of bounds, go to next line
  def x_mas(puzzle, size, {x, y}, result) when x == size,
    do: x_mas(puzzle, size, {0, y + 1}, result)

  # Y is out of bounds, return result
  def x_mas(_puzzle, size, {_x, y}, result) when y == size, do: result

  # otherwise find next A and check if it forms X-MAS or not
  def x_mas(puzzle, size, {x, y}, result) do
    case get_in(puzzle, [Access.at(y), Access.at(x)]) do
      ?A ->
        if is_x_mas(puzzle, {x, y}) do
          x_mas(puzzle, size, {x + 1, y}, result + 1)
        else
          x_mas(puzzle, size, {x + 1, y}, result)
        end

      _otherwise ->
        x_mas(puzzle, size, {x + 1, y}, result)
    end
  end

  # borders cannot form X-MAS
  def is_x_mas(_puzzle, {0, _y}), do: false
  def is_x_mas(_puzzle, {_x, 0}), do: false

  # get two diagonals and check both contain M and S
  def is_x_mas(puzzle, {x, y}) do
    a = [
      get_in(puzzle, [Access.at(y + 1), Access.at(x + 1)]),
      get_in(puzzle, [Access.at(y - 1), Access.at(x - 1)])
    ]

    b = [
      get_in(puzzle, [Access.at(y + 1), Access.at(x - 1)]),
      get_in(puzzle, [Access.at(y - 1), Access.at(x + 1)])
    ]

    (a == ~c'MS' or a == ~c'SM') and (b == ~c'MS' or b == ~c'SM')
  end
end

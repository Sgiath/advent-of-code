defmodule AdventOfCode.Year2021.Day09 do
  @moduledoc """
  https://adventofcode.com/2021/day/9
  """
  use AdventOfCode, year: 2021, day: 9

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> grid()
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    grid = parse(input)

    grid
    |> Enum.filter(&lowpoint?(grid, &1))
    |> Enum.reduce(0, fn {_point, value}, acc -> acc + value + 1 end)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    grid = parse(input)

    grid
    |> Enum.filter(&lowpoint?(grid, &1))
    |> Enum.map(fn {point, _} ->
      point
      |> basin(grid)
      |> MapSet.size()
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def basin(point, grid) do
    basin(MapSet.new(), point, grid)
  end

  defp basin(set, {row, col} = point, grid) do
    if grid[point] in [9, nil] or point in set do
      set
    else
      set
      |> MapSet.put(point)
      |> basin({row - 1, col}, grid)
      |> basin({row + 1, col}, grid)
      |> basin({row, col - 1}, grid)
      |> basin({row, col + 1}, grid)
    end
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  def grid(lines) do
    for {line, row} <- Enum.with_index(lines),
        {number, col} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{row, col}, number - ?0}
    end
  end

  def lowpoint?(grid, {{x, y}, val}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.map(&grid[&1])
    |> Enum.all?(&(&1 > val))
  end
end

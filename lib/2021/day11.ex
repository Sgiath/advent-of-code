defmodule AdventOfCode.Year2021.Day11 do
  @moduledoc """
  https://adventofcode.com/2021/day/11
  """
  use AdventOfCode, year: 2021, day: 11

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> grid()
    |> cycle(100)
  end

  @doc """
  Run specified amount of cycles and return number of flases
  """
  def cycle(grid, steps, flashes \\ 0)
  def cycle(_grid, 0, flashes), do: flashes

  def cycle(grid, steps, flashes) do
    {grid, flashed} = check_flashes(grid)

    cycle(grid, steps - 1, flashed + flashes)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> grid()
    |> find_sync()
  end

  @doc """
  Run until step with 100 flashes (sync flash) if found and return the number of the step
  """
  def find_sync(grid, step \\ 1)

  def find_sync(grid, step) do
    case check_flashes(grid) do
      {_grid, 100} -> step
      {grid, _flashes} -> find_sync(grid, step + 1)
    end
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Construct grid from the input
  """
  def grid(input) do
    for {line, row} <- input |> String.split(["\n"], trim: true) |> Enum.with_index(),
        {number, col} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{row, col}, number - ?0}
    end
  end

  @doc """
  Run the one step of flashing
  """
  def check_flashes(grid), do: check_flashes(Map.keys(grid), grid, MapSet.new())

  def check_flashes(keys, grid, fleshed)

  def check_flashes([key | keys], grid, flashed) do
    cond do
      # we are outside of the grid or we already flashed
      is_nil(grid[key]) or key in flashed ->
        check_flashes(keys, grid, flashed)

      # octopus flashes
      grid[key] >= 9 ->
        check_flashes(neighbors(key, keys), Map.put(grid, key, 0), MapSet.put(flashed, key))

      # octopus not flashes -> increase by 1
      :otherwise ->
        check_flashes(keys, Map.update!(grid, key, &(&1 + 1)), flashed)
    end
  end

  def check_flashes([], grid, flashed), do: {grid, MapSet.size(flashed)}

  @doc """
  Prepend all neighbors to keys
  """
  def neighbors({x, y}, keys) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
      | keys
    ]
  end
end

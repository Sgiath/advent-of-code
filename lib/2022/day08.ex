defmodule AdventOfCode.Year2022.Day08 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/8
  """
  use AdventOfCode, year: 2022, day: 08

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    30373
    25512
    65332
    33549
    35390
    """
  end

  def parse(input) do
    grid =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&parse_row/1)

    h = length(grid)
    w = length(List.first(grid))

    result =
      grid
      |> List.flatten()
      |> :array.from_list()

    {result, w, h}
  end

  def parse_row(row) do
    row
    |> String.to_charlist()
    |> Enum.map(&(&1 - ?0))
  end

  @doc ~S"""
  Will convert the plain grid of trees to map where key is height of each inner tree and value is
  lists of trees to each border of the grid which is less space efficient but easier to do required
  computations on top of it
  """
  def construct_tree_map({_grid, w, h} = grid) do
    for y <- 1..(h - 2), x <- 1..(w - 2) do
      {get(grid, x, y),
       [
         Enum.reverse(fetch(grid, Enum.to_list(0..(x - 1)), y)),
         fetch(grid, Enum.to_list((x + 1)..(w - 1)), y),
         Enum.reverse(fetch(grid, x, Enum.to_list(0..(y - 1)))),
         fetch(grid, x, Enum.to_list((y + 1)..(h - 1)))
       ]}
    end
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {_grid, w, h} = grid = parse(input)

    grid
    |> construct_tree_map()
    |> Enum.count(&visible?/1)
    |> Kernel.+(w * 2 + h * 2 - 4)
  end

  def visible?({v, trees}) do
    not Enum.all?(trees, fn tree_row ->
      Enum.any?(tree_row, &(&1 >= v))
    end)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> construct_tree_map()
    |> Enum.map(&score/1)
    |> Enum.max()
  end

  def score({v, trees}) do
    trees
    |> Enum.map(fn line ->
      Enum.reduce_while(line, 0, fn
        tree_height, c when tree_height < v -> {:cont, c + 1}
        _tree_height, c -> {:halt, c + 1}
      end)
    end)
    |> Enum.product()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  @doc ~S"""
  Get height of tree at coordinates x, y
  """
  def get({grid, w, _h}, x, y) do
    :array.get(y * w + x, grid)
  end

  @doc ~S"""
  Get list of heights of trees with list of coordinates
  """
  def fetch(grid, xr, y) when is_list(xr) do
    for x <- xr, do: get(grid, x, y)
  end

  def fetch(grid, x, yr) when is_list(yr) do
    for y <- yr, do: get(grid, x, y)
  end
end

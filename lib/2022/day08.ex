defmodule AdventOfCode.Year2022.Day08 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/8

  Optimized solution using tuples for O(1) access and on-demand direction walking
  instead of precomputing all tree lists.
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

  @doc """
  Parse input into a tuple-based grid for O(1) access.
  Returns {grid_tuple, width, height} where grid_tuple allows elem(grid, y * w + x) access.
  """
  def parse(input) do
    rows = String.split(input, "\n", trim: true)
    h = length(rows)
    w = byte_size(hd(rows))

    # Build a tuple of all tree heights for O(1) access
    grid =
      rows
      |> Enum.flat_map(fn row ->
        for <<char <- row>>, do: char - ?0
      end)
      |> List.to_tuple()

    {grid, w, h}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {grid, w, h} = parse(input)

    # Count visible inner trees
    inner_visible =
      for y <- 1..(h - 2),
          x <- 1..(w - 2),
          visible?(grid, w, h, x, y),
          reduce: 0 do
        acc -> acc + 1
      end

    # Add perimeter trees (always visible)
    perimeter = w * 2 + h * 2 - 4
    inner_visible + perimeter
  end

  # A tree is visible if there's at least one direction where all trees are shorter
  defp visible?(grid, w, h, x, y) do
    tree_height = get(grid, w, x, y)

    visible_left?(grid, w, tree_height, x, y) or
      visible_right?(grid, w, h, tree_height, x, y) or
      visible_up?(grid, w, tree_height, x, y) or
      visible_down?(grid, w, h, tree_height, x, y)
  end

  # Check visibility in each direction - stop early if blocked
  defp visible_left?(grid, w, height, x, y) do
    check_visible(grid, w, height, (x - 1)..0//-1, y, :horizontal)
  end

  defp visible_right?(grid, w, _h, height, x, y) do
    check_visible(grid, w, height, (x + 1)..(w - 1)//1, y, :horizontal)
  end

  defp visible_up?(grid, w, height, x, y) do
    check_visible(grid, w, height, x, (y - 1)..0//-1, :vertical)
  end

  defp visible_down?(grid, w, h, height, x, y) do
    check_visible(grid, w, height, x, (y + 1)..(h - 1)//1, :vertical)
  end

  # Check if tree is visible in a direction (no blocking tree found)
  defp check_visible(grid, w, height, x_range, y, :horizontal) do
    Enum.all?(x_range, fn xi -> get(grid, w, xi, y) < height end)
  end

  defp check_visible(grid, w, height, x, y_range, :vertical) do
    Enum.all?(y_range, fn yi -> get(grid, w, x, yi) < height end)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {grid, w, h} = parse(input)

    # Find max scenic score among all inner trees
    for y <- 1..(h - 2), x <- 1..(w - 2), reduce: 0 do
      max_score ->
        score = scenic_score(grid, w, h, x, y)
        max(max_score, score)
    end
  end

  # Calculate scenic score as product of viewing distances in all 4 directions
  defp scenic_score(grid, w, h, x, y) do
    tree_height = get(grid, w, x, y)

    view_left(grid, w, tree_height, x, y) *
      view_right(grid, w, h, tree_height, x, y) *
      view_up(grid, w, tree_height, x, y) *
      view_down(grid, w, h, tree_height, x, y)
  end

  # Count trees visible in each direction until blocked or edge
  defp view_left(grid, w, height, x, y) do
    count_visible(grid, w, height, (x - 1)..0//-1, y, :horizontal)
  end

  defp view_right(grid, w, _h, height, x, y) do
    count_visible(grid, w, height, (x + 1)..(w - 1)//1, y, :horizontal)
  end

  defp view_up(grid, w, height, x, y) do
    count_visible(grid, w, height, x, (y - 1)..0//-1, :vertical)
  end

  defp view_down(grid, w, h, height, x, y) do
    count_visible(grid, w, height, x, (y + 1)..(h - 1)//1, :vertical)
  end

  # Count trees until we hit one >= our height or reach edge
  defp count_visible(grid, w, height, x_range, y, :horizontal) do
    Enum.reduce_while(x_range, 0, fn xi, count ->
      if get(grid, w, xi, y) < height do
        {:cont, count + 1}
      else
        {:halt, count + 1}
      end
    end)
  end

  defp count_visible(grid, w, height, x, y_range, :vertical) do
    Enum.reduce_while(y_range, 0, fn yi, count ->
      if get(grid, w, x, yi) < height do
        {:cont, count + 1}
      else
        {:halt, count + 1}
      end
    end)
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  # O(1) access to grid using tuple elem/2
  defp get(grid, w, x, y) do
    elem(grid, y * w + x)
  end
end

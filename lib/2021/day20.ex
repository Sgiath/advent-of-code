defmodule AdventOfCode.Year2021.Day20 do
  @moduledoc """
  https://adventofcode.com/2021/day/20

  Optimized with padded 2D tuple representation.
  Grid is pre-padded with border pixels to eliminate bounds checking.
  """
  use AdventOfCode, year: 2021, day: 20

  import Bitwise

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
    """
  end

  def parse(input) do
    [enhancement | image_lines] =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)

    # Convert enhancement to tuple for O(1) access
    alg = List.to_tuple(enhancement)

    # Build padded grid - add 1 pixel border of 0s for initial bounds safety
    height = length(image_lines)
    width = length(hd(image_lines))

    # Pad with 1 pixel border (will expand during enhance)
    grid = build_padded_grid(image_lines, height, width, 0)

    # Image format: {grid, height, width} - grid includes 1px padding on each side
    {alg, {grid, height + 2, width + 2}}
  end

  defp parse_line(line) do
    for <<c <- line>>, do: if(c == ?#, do: 1, else: 0)
  end

  defp build_padded_grid(rows, _h, w, default) do
    # Top padding row
    pad_row = List.to_tuple(List.duplicate(default, w + 2))

    # Build grid with padding
    middle_rows =
      for row <- rows do
        List.to_tuple([default | row] ++ [default])
      end

    List.to_tuple([pad_row | middle_rows] ++ [pad_row])
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {alg, image} = parse(input)
    first = elem(alg, 0)

    image
    |> enhance(alg, 0)
    |> enhance(alg, first)
    |> count_lit()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {alg, image} = parse(input)
    first = elem(alg, 0)

    1..50
    |> Enum.reduce(image, fn i, img ->
      enhance(img, alg, if(rem(i, 2) == 1, do: 0, else: first))
    end)
    |> count_lit()
  end

  defp count_lit({grid, h, w}) do
    # Don't count padding rows/cols
    Enum.reduce(1..(h - 2), 0, fn row, acc ->
      row_tuple = elem(grid, row)

      Enum.reduce(1..(w - 2), acc, fn col, acc2 ->
        acc2 + elem(row_tuple, col)
      end)
    end)
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Run enhancement algorithm. Grid expands by 1 in each direction.
  New border is pre-filled with default value.
  """
  def enhance({grid, h, w}, alg, default) do
    new_h = h + 2
    new_w = w + 2

    # Build new grid - iterate over output coordinates
    # Input grid[r][c] corresponds to output coordinates (r, c)
    # We need to read from grid[r-1..r+1][c-1..c+1] for each output pixel
    new_grid =
      for row <- 0..(new_h - 1) do
        for col <- 0..(new_w - 1) do
          # Source coordinates in old grid
          sr = row - 1
          sc = col - 1
          elem(alg, index9(grid, h, w, sr, sc, default))
        end
        |> List.to_tuple()
      end
      |> List.to_tuple()

    {new_grid, new_h, new_w}
  end

  @doc """
  Compute 9-bit index from 3x3 neighborhood centered at (r, c) in grid.
  Uses direct elem access with bounds checking.
  """
  def index9(grid, h, w, r, c, default) do
    px(grid, h, w, r - 1, c - 1, default) <<< 8 |||
      px(grid, h, w, r - 1, c, default) <<< 7 |||
      px(grid, h, w, r - 1, c + 1, default) <<< 6 |||
      px(grid, h, w, r, c - 1, default) <<< 5 |||
      px(grid, h, w, r, c, default) <<< 4 |||
      px(grid, h, w, r, c + 1, default) <<< 3 |||
      px(grid, h, w, r + 1, c - 1, default) <<< 2 |||
      px(grid, h, w, r + 1, c, default) <<< 1 |||
      px(grid, h, w, r + 1, c + 1, default)
  end

  # Fast pixel access with inline bounds check
  @compile {:inline, px: 6}
  defp px(grid, h, w, r, c, _default) when r >= 0 and r < h and c >= 0 and c < w do
    elem(elem(grid, r), c)
  end

  defp px(_grid, _h, _w, _r, _c, default), do: default
end

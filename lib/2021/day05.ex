defmodule AdventOfCode.Year2021.Day05 do
  @moduledoc """
  https://adventofcode.com/2021/day/5
  """
  use AdventOfCode, year: 2021, day: 5

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """
  end

  def parse(input) do
    input
    |> AdventOfCode.Parser.lines([",", " -> ", "\n"])
    |> Enum.chunk_every(4)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> get_straight_lines()
    |> Enum.flat_map(&get_points/1)
    |> get_intersections()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.flat_map(&get_points/1)
    |> get_intersections()
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Filter coordinates to get only straight lines
  """
  def get_straight_lines(coordinates) do
    Enum.filter(coordinates, fn
      [x, _y1, x, _y2] -> true
      [_x1, y, _x2, y] -> true
      _diagonal -> false
    end)
  end

  @doc """
  Get individual points from list of coordinates
  """
  def get_points([x, y1, x, y2]), do: Enum.map(range(y1, y2), &{x, &1})
  def get_points([x1, y, x2, y]), do: Enum.map(range(x1, x2), &{&1, y})
  def get_points([x1, y1, x2, y2]), do: Enum.zip(range(x1, x2), range(y1, y2))

  @doc """
  Get just duplicate elements
  """
  def get_intersections(points) do
    points
    |> Enum.frequencies()
    |> Enum.count(&(elem(&1, 1) > 1))
  end
end

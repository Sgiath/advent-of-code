defmodule AdventOfCode.Year2021.Day05 do
  @moduledoc """
  https://adventofcode.com/2021/day/5
  """
  use AdventOfCode, year: 2021, day: 05

  alias AdventOfCode.Parser

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def input do
    input_data()
    |> Parser.lines([",", " -> ", "\n"])
    |> Enum.chunk_every(4)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> get_straight_lines()
    |> get_points()
    |> get_intersections()
    |> Enum.count()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> get_points()
    |> get_intersections()
    |> Enum.count()
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
  # Get points for individual coordinates
  def get_points([x, y1, x, y2]), do: Enum.map(y1..y2, &{x, &1})
  def get_points([x1, y, x2, y]), do: Enum.map(x1..x2, &{&1, y})
  def get_points([x1, y1, x2, y2]), do: Enum.zip(x1..x2, y1..y2)

  # Get points for list of coordinates
  def get_points(coordinates) do
    coordinates
    |> Enum.map(&get_points/1)
    |> List.flatten()
  end

  @doc """
  Get just duplicate elements
  """
  def get_intersections(points) do
    points
    |> Enum.frequencies()
    |> Enum.filter(&(elem(&1, 1) > 1))
  end
end

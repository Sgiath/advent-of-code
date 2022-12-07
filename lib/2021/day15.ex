defmodule AdventOfCode.Year2021.Day15 do
  @moduledoc """
  https://adventofcode.com/2021/day/15
  """
  use AdventOfCode, year: 2021, day: 15

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.with_index()
  end

  def parse_line(line) do
    line
    |> String.to_charlist()
    |> Enum.map(&(&1 - ?0))
    |> Enum.with_index()
  end

  def points(input) do
    for {row, x} <- parse(input), {w, y} <- row, into: %{} do
      {{x, y}, w}
    end
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> points()
    |> find_path()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> points()
    |> expand()
    |> find_path()
  end

  @doc """
  Expand the map according to the task description
  """
  def expand(points) do
    {max, _max_y} = end_point(points)

    for i <- 0..4, j <- 0..4, reduce: %{} do
      acc ->
        Enum.reduce(points, acc, fn {{x, y}, w}, acc ->
          new_weight = if rem(w + i + j, 9) == 0, do: 9, else: rem(w + i + j, 9)

          Map.put(acc, {x + max * i + i, y + max * j + j}, new_weight)
        end)
    end
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Get neighbors of the point
  """
  def neighbors({x, y}, graph) do
    Enum.reject([{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}], &is_nil(graph[&1]))
  end

  @doc """
  Return the final destination point
  """
  def end_point(points) do
    points
    |> Enum.max_by(fn {{x, y}, _w} -> x + y end)
    |> elem(0)
  end

  @doc """
  List of edges from the points
  """
  def edges(points) do
    Enum.reduce(points, [], fn {point, _w}, acc ->
      point
      |> neighbors(points)
      |> Enum.reduce(acc, fn neigh, acc ->
        [Graph.Edge.new(point, neigh, weight: points[neigh]) | acc]
      end)
    end)
  end

  @doc """
  Find the shortest path for the points
  """
  def find_path(points) do
    Graph.new(vertex_identifier: & &1)
    |> Graph.add_edges(edges(points))
    |> Graph.get_shortest_path({0, 0}, end_point(points))
    # compute the danger score from the path
    |> Enum.reduce(0, &(points[&1] + &2))
    # substract the starting point
    |> Kernel.-(points[{0, 0}])
  end
end

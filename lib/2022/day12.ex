defmodule AdventOfCode.Year2022.Day12 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/12
  """
  use AdventOfCode, year: 2022, day: 12

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """
  end

  def parse(input) do
    grid =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(fn line ->
        line
        |> String.to_charlist()
        |> Enum.map(fn
          e when e >= ?a and e <= ?z -> e - ?a
          ?S -> -1
          ?E -> ?z - ?a + 1
        end)
      end)

    grid = {grid |> List.flatten() |> :array.from_list(), length(grid), length(List.first(grid))}
    {start, finish} = find(grid)
    graph = graph(grid)

    {graph, start, finish}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {graph, start, finish} = parse(input)

    graph
    |> Graph.dijkstra(start, finish)
    |> length()
    |> Kernel.-(1)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> dbg()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def get({grid, _h, w}, x, y) do
    :array.get(y * w + x, grid)
  end

  def neighbors({_grid, h, w}, x, y) do
    Enum.reject([{x, y - 1}, {x, y + 1}, {x + 1, y}, {x + 1, y}], fn {nx, ny} ->
      nx < 0 or ny < 0 or nx >= w or ny >= h
    end)
  end

  def graph({_grid, h, w} = grid) do
    for y <- 0..(h - 1), x <- 0..(w - 1), reduce: Graph.new() do
      graph ->
        grid
        |> neighbors(x, y)
        |> Enum.reduce(graph, fn {nx, ny}, graph ->
          if get(grid, nx, ny) - 1 <= get(grid, x, y),
            do: Graph.add_edge(graph, {x, y}, {nx, ny}),
            else: graph
        end)
    end
  end

  def find({_grid, h, w} = grid) do
    sv = -1
    fv = ?z - ?a + 1

    for y <- 0..(h - 1), x <- 0..(w - 1), reduce: {nil, nil} do
      {start, finish} ->
        case get(grid, x, y) do
          ^sv -> {{x, y}, finish}
          ^fv -> {start, {x, y}}
          _otherwise -> {start, finish}
        end
    end
  end
end

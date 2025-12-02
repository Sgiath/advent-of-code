defmodule AdventOfCode.Year2021.Day15 do
  @moduledoc """
  https://adventofcode.com/2021/day/15

  Uses A* algorithm with Manhattan distance heuristic for optimal pathfinding.
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

  @doc """
  Parse input into a tuple-based grid for O(1) access
  Returns {grid_array, size} where grid_array is an :array
  """
  def parse(input) do
    lines = String.split(input, "\n", trim: true)
    size = length(lines)

    grid =
      lines
      |> Enum.flat_map(fn line ->
        line |> String.to_charlist() |> Enum.map(&(&1 - ?0))
      end)
      |> :array.from_list()

    {grid, size}
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {grid, size} = parse(input)
    astar(grid, size, size)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {grid, base_size} = parse(input)
    # For part 2, we expand 5x but compute weights on-the-fly
    astar_expanded(grid, base_size)
  end

  # ===============================================================================================
  # A* Algorithm - Uses integer position keys for speed
  # ===============================================================================================

  @doc """
  A* for part 1 (non-expanded grid)
  Uses integer position key (y * size + x) instead of {x, y} tuples for faster map ops
  """
  def astar(grid, size, _grid_size) do
    # Integer key for destination
    dest = size * size - 1
    # Manhattan from (0,0) to (size-1, size-1)
    h0 = (size - 1) * 2
    # {f, g, pos_key}
    queue = :gb_sets.singleton({h0, 0, 0})
    dist = %{0 => 0}

    astar_loop(queue, dist, grid, size, dest)
  end

  defp astar_loop(queue, dist, grid, size, dest) do
    {{_f, g, pos}, queue} = :gb_sets.take_smallest(queue)

    cond do
      pos == dest ->
        g

      g > Map.get(dist, pos, 0x7FFFFFFF) ->
        astar_loop(queue, dist, grid, size, dest)

      true ->
        x = rem(pos, size)
        y = div(pos, size)
        {queue, dist} = expand_neighbors(x, y, g, queue, dist, grid, size, dest)
        astar_loop(queue, dist, grid, size, dest)
    end
  end

  defp expand_neighbors(x, y, g, queue, dist, grid, size, dest) do
    {queue, dist} = try_neighbor(x - 1, y, g, queue, dist, grid, size, dest)
    {queue, dist} = try_neighbor(x + 1, y, g, queue, dist, grid, size, dest)
    {queue, dist} = try_neighbor(x, y - 1, g, queue, dist, grid, size, dest)
    try_neighbor(x, y + 1, g, queue, dist, grid, size, dest)
  end

  defp try_neighbor(nx, ny, g, queue, dist, grid, size, _dest)
       when nx >= 0 and nx < size and ny >= 0 and ny < size do
    weight = :array.get(ny * size + nx, grid)
    new_g = g + weight
    pos_key = ny * size + nx

    case dist do
      %{^pos_key => current} when new_g >= current ->
        {queue, dist}

      _ ->
        # Heuristic: Manhattan distance to bottom-right corner
        dest_x = size - 1
        dest_y = size - 1
        h = abs(dest_x - nx) + abs(dest_y - ny)
        new_f = new_g + h

        {
          :gb_sets.add({new_f, new_g, pos_key}, queue),
          Map.put(dist, pos_key, new_g)
        }
    end
  end

  defp try_neighbor(_nx, _ny, _g, queue, dist, _grid, _size, _dest) do
    {queue, dist}
  end

  # ===============================================================================================
  # A* for Expanded Grid (Part 2) - Uses integer position keys for speed
  # ===============================================================================================

  @doc """
  A* for part 2 - 5x expanded grid with on-the-fly weight computation
  Uses integer position key (y * size + x) instead of {x, y} tuples for faster map ops
  """
  def astar_expanded(grid, base_size) do
    size = base_size * 5
    # Integer key for destination
    dest = size * size - 1
    # Manhattan from (0,0) to (size-1, size-1)
    h0 = (size - 1) * 2
    # {f, g, pos_key}
    queue = :gb_sets.singleton({h0, 0, 0})
    dist = %{0 => 0}

    astar_expanded_loop(queue, dist, grid, base_size, size, dest)
  end

  defp astar_expanded_loop(queue, dist, grid, base_size, size, dest) do
    {{_f, g, pos}, queue} = :gb_sets.take_smallest(queue)

    cond do
      pos == dest ->
        g

      g > Map.get(dist, pos, 0x7FFFFFFF) ->
        astar_expanded_loop(queue, dist, grid, base_size, size, dest)

      true ->
        x = rem(pos, size)
        y = div(pos, size)
        {queue, dist} = expand_neighbors_exp(x, y, g, queue, dist, grid, base_size, size, dest)
        astar_expanded_loop(queue, dist, grid, base_size, size, dest)
    end
  end

  defp expand_neighbors_exp(x, y, g, queue, dist, grid, base_size, size, dest) do
    {queue, dist} = try_exp(x - 1, y, g, queue, dist, grid, base_size, size, dest)
    {queue, dist} = try_exp(x + 1, y, g, queue, dist, grid, base_size, size, dest)
    {queue, dist} = try_exp(x, y - 1, g, queue, dist, grid, base_size, size, dest)
    try_exp(x, y + 1, g, queue, dist, grid, base_size, size, dest)
  end

  defp try_exp(nx, ny, g, queue, dist, grid, base_size, size, _dest)
       when nx >= 0 and nx < size and ny >= 0 and ny < size do
    # Compute weight on-the-fly for expanded grid
    tile_x = div(nx, base_size)
    tile_y = div(ny, base_size)
    base_x = rem(nx, base_size)
    base_y = rem(ny, base_size)
    base_weight = :array.get(base_y * base_size + base_x, grid)
    raw_weight = base_weight + tile_x + tile_y
    weight = if raw_weight > 9, do: raw_weight - 9, else: raw_weight

    new_g = g + weight
    pos_key = ny * size + nx

    case dist do
      %{^pos_key => current} when new_g >= current ->
        {queue, dist}

      _ ->
        # Heuristic: Manhattan distance to bottom-right corner
        dest_x = size - 1
        dest_y = size - 1
        h = abs(dest_x - nx) + abs(dest_y - ny)
        new_f = new_g + h

        {
          :gb_sets.add({new_f, new_g, pos_key}, queue),
          Map.put(dist, pos_key, new_g)
        }
    end
  end

  defp try_exp(_nx, _ny, _g, queue, dist, _grid, _base_size, _size, _dest) do
    {queue, dist}
  end
end

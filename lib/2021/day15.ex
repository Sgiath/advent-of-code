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
    find_path(grid, size)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {grid, base_size} = parse(input)
    # For part 2, we expand 5x but compute weights on-the-fly
    find_path_expanded(grid, base_size)
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Get weight at position for part 1 (direct array lookup)
  """
  def get_weight(grid, size, x, y) do
    :array.get(y * size + x, grid)
  end

  @doc """
  Get weight at position for expanded grid (part 2)
  Computes the weight on-the-fly using the expansion formula
  """
  def get_weight_expanded(grid, base_size, x, y) do
    # Which tile are we in?
    tile_x = div(x, base_size)
    tile_y = div(y, base_size)
    # Position within the base tile
    base_x = rem(x, base_size)
    base_y = rem(y, base_size)
    # Get base weight and apply expansion formula
    base_weight = :array.get(base_y * base_size + base_x, grid)
    weight = base_weight + tile_x + tile_y
    if weight > 9, do: weight - 9, else: weight
  end

  @doc """
  Find shortest path for part 1 (non-expanded grid)
  """
  def find_path(grid, size) do
    destination = {size - 1, size - 1}
    queue = :gb_sets.singleton({0, {0, 0}})
    # Track best known distance to each node (not just visited)
    dist = %{{0, 0} => 0}

    dijkstra(queue, dist, grid, size, destination, &get_weight/4)
  end

  @doc """
  Find shortest path for part 2 (5x expanded grid, weights computed on-the-fly)
  """
  def find_path_expanded(grid, base_size) do
    expanded_size = base_size * 5
    destination = {expanded_size - 1, expanded_size - 1}
    queue = :gb_sets.singleton({0, {0, 0}})
    dist = %{{0, 0} => 0}

    dijkstra(queue, dist, grid, expanded_size, destination, fn g, _s, x, y ->
      get_weight_expanded(g, base_size, x, y)
    end)
  end

  defp dijkstra(queue, dist, grid, size, destination, weight_fn) do
    {{cost, {x, y} = pos}, queue} = :gb_sets.take_smallest(queue)

    cond do
      pos == destination ->
        cost

      # Skip if we've already found a better path to this node
      cost > Map.get(dist, pos, :infinity) ->
        dijkstra(queue, dist, grid, size, destination, weight_fn)

      :otherwise ->
        # Check all 4 neighbors with inline bounds checking
        {queue, dist} =
          Enum.reduce([{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}], {queue, dist}, fn
            {nx, ny} = neighbor, {q, d} when nx >= 0 and nx < size and ny >= 0 and ny < size ->
              new_cost = cost + weight_fn.(grid, size, nx, ny)
              current_best = Map.get(d, neighbor, :infinity)

              if new_cost < current_best do
                # Found a better path - update distance and add to queue
                {
                  :gb_sets.add({new_cost, neighbor}, q),
                  Map.put(d, neighbor, new_cost)
                }
              else
                {q, d}
              end

            _neighbor, {q, d} ->
              {q, d}
          end)

        dijkstra(queue, dist, grid, size, destination, weight_fn)
    end
  end
end

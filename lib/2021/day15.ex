defmodule AdventOfCode.Year2021.Day15 do
  @moduledoc """
  https://adventofcode.com/2021/day/15

  Uses Dijkstra with bucket queue (Dial's algorithm) for O(1) priority queue operations.
  Weights are bounded 1-9, so we use a circular bucket queue with 10 buckets.
  """
  use AdventOfCode, year: 2021, day: 15

  # Number of buckets for Dial's algorithm (max_weight + 1)
  @num_buckets 10

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
  Parse input into a binary for ultra-fast O(1) access (1 byte per cell)
  """
  def parse(input) do
    lines = String.split(input, "\n", trim: true)
    size = length(lines)

    grid =
      for line <- lines, <<c <- line>>, into: <<>> do
        <<c - ?0>>
      end

    {grid, size}
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {grid, size} = parse(input)
    dijkstra_bucket(grid, size, size)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {grid, base_size} = parse(input)
    dijkstra_bucket_expanded(grid, base_size)
  end

  # ===============================================================================================
  # Dijkstra with Bucket Queue (Dial's Algorithm)
  # ===============================================================================================

  @doc """
  Dijkstra for part 1 using bucket queue - O(1) insert and extract-min
  """
  def dijkstra_bucket(grid, size, _grid_size) do
    dest = size * size - 1
    # Initialize buckets as a tuple of 10 empty lists
    buckets = :erlang.make_tuple(@num_buckets, [])
    # Start position 0 with distance 0 in bucket 0
    buckets = put_elem(buckets, 0, [0])
    dist = %{0 => 0}

    bucket_loop(buckets, 0, dist, grid, size, dest)
  end

  defp bucket_loop(buckets, current_dist, dist, grid, size, dest) do
    bucket_idx = rem(current_dist, @num_buckets)

    case elem(buckets, bucket_idx) do
      [] ->
        # Empty bucket, try next distance
        bucket_loop(buckets, current_dist + 1, dist, grid, size, dest)

      [pos | rest] ->
        buckets = put_elem(buckets, bucket_idx, rest)

        cond do
          pos == dest ->
            current_dist

          # Skip if we've found a better path (stale entry)
          Map.get(dist, pos, 0x7FFFFFFF) < current_dist ->
            bucket_loop(buckets, current_dist, dist, grid, size, dest)

          true ->
            x = rem(pos, size)
            y = div(pos, size)
            {buckets, dist} = expand_bucket(x, y, current_dist, buckets, dist, grid, size)
            bucket_loop(buckets, current_dist, dist, grid, size, dest)
        end
    end
  end

  defp expand_bucket(x, y, d, buckets, dist, grid, size) do
    {buckets, dist} = try_bucket(x - 1, y, d, buckets, dist, grid, size)
    {buckets, dist} = try_bucket(x + 1, y, d, buckets, dist, grid, size)
    {buckets, dist} = try_bucket(x, y - 1, d, buckets, dist, grid, size)
    try_bucket(x, y + 1, d, buckets, dist, grid, size)
  end

  defp try_bucket(nx, ny, d, buckets, dist, grid, size)
       when nx >= 0 and nx < size and ny >= 0 and ny < size do
    pos_key = ny * size + nx
    weight = :binary.at(grid, pos_key)
    new_d = d + weight

    case dist do
      %{^pos_key => current} when new_d >= current ->
        {buckets, dist}

      _ ->
        bucket_idx = rem(new_d, @num_buckets)
        bucket = elem(buckets, bucket_idx)
        {put_elem(buckets, bucket_idx, [pos_key | bucket]), Map.put(dist, pos_key, new_d)}
    end
  end

  defp try_bucket(_nx, _ny, _d, buckets, dist, _grid, _size) do
    {buckets, dist}
  end

  # ===============================================================================================
  # Part 2 - Expanded Grid with Bucket Queue
  # ===============================================================================================

  @doc """
  Dijkstra for part 2 - precomputes expanded grid as binary for O(1) access
  """
  def dijkstra_bucket_expanded(grid, base_size) do
    size = base_size * 5
    expanded = expand_grid(grid, base_size)
    dest = size * size - 1

    buckets = :erlang.make_tuple(@num_buckets, [])
    buckets = put_elem(buckets, 0, [0])
    dist = %{0 => 0}

    bucket_loop_exp(buckets, 0, dist, expanded, size, dest)
  end

  @doc """
  Precompute the 5x5 expanded grid as a binary
  """
  def expand_grid(grid, base_size) do
    size = base_size * 5

    for y <- 0..(size - 1), x <- 0..(size - 1), into: <<>> do
      tile_x = div(x, base_size)
      tile_y = div(y, base_size)
      base_x = rem(x, base_size)
      base_y = rem(y, base_size)
      base_weight = :binary.at(grid, base_y * base_size + base_x)
      raw = base_weight + tile_x + tile_y
      weight = if raw > 9, do: raw - 9, else: raw
      <<weight>>
    end
  end

  defp bucket_loop_exp(buckets, current_dist, dist, grid, size, dest) do
    bucket_idx = rem(current_dist, @num_buckets)

    case elem(buckets, bucket_idx) do
      [] ->
        bucket_loop_exp(buckets, current_dist + 1, dist, grid, size, dest)

      [pos | rest] ->
        buckets = put_elem(buckets, bucket_idx, rest)

        cond do
          pos == dest ->
            current_dist

          Map.get(dist, pos, 0x7FFFFFFF) < current_dist ->
            bucket_loop_exp(buckets, current_dist, dist, grid, size, dest)

          true ->
            x = rem(pos, size)
            y = div(pos, size)
            {buckets, dist} = expand_bucket_exp(x, y, current_dist, buckets, dist, grid, size)
            bucket_loop_exp(buckets, current_dist, dist, grid, size, dest)
        end
    end
  end

  defp expand_bucket_exp(x, y, d, buckets, dist, grid, size) do
    {buckets, dist} = try_bucket_exp(x - 1, y, d, buckets, dist, grid, size)
    {buckets, dist} = try_bucket_exp(x + 1, y, d, buckets, dist, grid, size)
    {buckets, dist} = try_bucket_exp(x, y - 1, d, buckets, dist, grid, size)
    try_bucket_exp(x, y + 1, d, buckets, dist, grid, size)
  end

  defp try_bucket_exp(nx, ny, d, buckets, dist, grid, size)
       when nx >= 0 and nx < size and ny >= 0 and ny < size do
    pos_key = ny * size + nx
    weight = :binary.at(grid, pos_key)
    new_d = d + weight

    case dist do
      %{^pos_key => current} when new_d >= current ->
        {buckets, dist}

      _ ->
        bucket_idx = rem(new_d, @num_buckets)
        bucket = elem(buckets, bucket_idx)
        {put_elem(buckets, bucket_idx, [pos_key | bucket]), Map.put(dist, pos_key, new_d)}
    end
  end

  defp try_bucket_exp(_nx, _ny, _d, buckets, dist, _grid, _size) do
    {buckets, dist}
  end
end

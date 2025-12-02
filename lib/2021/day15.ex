defmodule AdventOfCode.Year2021.Day15 do
  @moduledoc """
  https://adventofcode.com/2021/day/15

  Uses Dijkstra with bucket queue (Dial's algorithm) for O(1) priority queue operations.
  Uses process dictionary for O(1) distance lookups. Integer position keys.
  """
  use AdventOfCode, year: 2021, day: 15

  # Use 16 buckets (power of 2) for fast modulo via band
  @num_buckets 16
  @bucket_mask 15

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
    dijkstra_pdict(grid, size)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {grid, base_size} = parse(input)
    dijkstra_pdict_expanded(grid, base_size)
  end

  # ===============================================================================================
  # Dijkstra with Process Dictionary for distances (integer keys)
  # ===============================================================================================

  @doc """
  Dijkstra for part 1 - uses process dictionary for O(1) distance operations
  """
  def dijkstra_pdict(grid, size) do
    dest = size * size - 1
    buckets = :erlang.make_tuple(@num_buckets, [])
    buckets = put_elem(buckets, 0, [0])
    :erlang.put(0, 0)

    try do
      pdict_loop(buckets, 0, grid, size, dest)
    after
      :erlang.erase()
    end
  end

  defp pdict_loop(buckets, d, grid, size, dest) do
    idx = :erlang.band(d, @bucket_mask)

    case elem(buckets, idx) do
      [] ->
        pdict_loop(buckets, d + 1, grid, size, dest)

      [pos | rest] ->
        buckets = put_elem(buckets, idx, rest)

        cond do
          pos == dest ->
            d

          :erlang.get(pos) < d ->
            pdict_loop(buckets, d, grid, size, dest)

          true ->
            x = rem(pos, size)
            y = div(pos, size)
            buckets = expand_pdict(x, y, d, buckets, grid, size)
            pdict_loop(buckets, d, grid, size, dest)
        end
    end
  end

  defp expand_pdict(x, y, d, buckets, grid, size) do
    buckets = try_pdict(x - 1, y, d, buckets, grid, size)
    buckets = try_pdict(x + 1, y, d, buckets, grid, size)
    buckets = try_pdict(x, y - 1, d, buckets, grid, size)
    try_pdict(x, y + 1, d, buckets, grid, size)
  end

  defp try_pdict(nx, ny, d, buckets, grid, size)
       when nx >= 0 and nx < size and ny >= 0 and ny < size do
    pos = ny * size + nx
    weight = :binary.at(grid, pos)
    new_d = d + weight
    current = :erlang.get(pos)

    if current == :undefined or new_d < current do
      :erlang.put(pos, new_d)
      idx = :erlang.band(new_d, @bucket_mask)
      put_elem(buckets, idx, [pos | elem(buckets, idx)])
    else
      buckets
    end
  end

  defp try_pdict(_nx, _ny, _d, buckets, _grid, _size), do: buckets

  # ===============================================================================================
  # Part 2 - Expanded Grid with Process Dictionary
  # ===============================================================================================

  @doc """
  Dijkstra for part 2 - precomputes expanded grid, uses process dictionary
  """
  def dijkstra_pdict_expanded(grid, base_size) do
    size = base_size * 5
    dest = size * size - 1
    expanded = expand_grid_fast(grid, base_size)

    buckets = :erlang.make_tuple(@num_buckets, [])
    buckets = put_elem(buckets, 0, [0])
    :erlang.put(0, 0)

    try do
      pdict_loop_exp(buckets, 0, expanded, size, dest)
    after
      :erlang.erase()
    end
  end

  @doc """
  Fast grid expansion - builds the 500x500 grid as binary
  """
  def expand_grid_fast(grid, base_size) do
    # Pre-build the grid row by row
    for ty <- 0..4, by <- 0..(base_size - 1), tx <- 0..4, bx <- 0..(base_size - 1), into: <<>> do
      base_weight = :binary.at(grid, by * base_size + bx)
      raw = base_weight + tx + ty
      <<if(raw > 9, do: raw - 9, else: raw)>>
    end
  end

  defp pdict_loop_exp(buckets, d, grid, size, dest) do
    idx = :erlang.band(d, @bucket_mask)

    case elem(buckets, idx) do
      [] ->
        pdict_loop_exp(buckets, d + 1, grid, size, dest)

      [pos | rest] ->
        buckets = put_elem(buckets, idx, rest)

        cond do
          pos == dest ->
            d

          :erlang.get(pos) < d ->
            pdict_loop_exp(buckets, d, grid, size, dest)

          true ->
            x = rem(pos, size)
            y = div(pos, size)
            buckets = expand_pdict_exp(x, y, d, buckets, grid, size)
            pdict_loop_exp(buckets, d, grid, size, dest)
        end
    end
  end

  defp expand_pdict_exp(x, y, d, buckets, grid, size) do
    buckets = try_pdict_exp(x - 1, y, d, buckets, grid, size)
    buckets = try_pdict_exp(x + 1, y, d, buckets, grid, size)
    buckets = try_pdict_exp(x, y - 1, d, buckets, grid, size)
    try_pdict_exp(x, y + 1, d, buckets, grid, size)
  end

  defp try_pdict_exp(nx, ny, d, buckets, grid, size)
       when nx >= 0 and nx < size and ny >= 0 and ny < size do
    pos = ny * size + nx
    weight = :binary.at(grid, pos)
    new_d = d + weight
    current = :erlang.get(pos)

    if current == :undefined or new_d < current do
      :erlang.put(pos, new_d)
      idx = :erlang.band(new_d, @bucket_mask)
      put_elem(buckets, idx, [pos | elem(buckets, idx)])
    else
      buckets
    end
  end

  defp try_pdict_exp(_nx, _ny, _d, buckets, _grid, _size), do: buckets
end

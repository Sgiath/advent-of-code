defmodule AdventOfCode.Year2024.Day06 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/6

  Optimized with ray casting and inline obstacle checking. Instead of rebuilding
  the obstacle structure for each test, we check the new obstacle position inline.
  """
  use AdventOfCode, year: 2024, day: 06

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """
  end

  def parse(input) do
    lines = String.split(input, "\n", trim: true)
    height = length(lines)
    width = String.length(hd(lines))

    # Parse obstacles and find guard position
    {obstacles, guard} =
      lines
      |> Enum.with_index()
      |> Enum.reduce({MapSet.new(), nil}, fn {line, y}, acc ->
        line
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, x}, {obs, g} ->
          case char do
            ?# -> {MapSet.put(obs, {x, y}), g}
            ?^ -> {obs, {{x, y}, :up}}
            ?> -> {obs, {{x, y}, :right}}
            ?v -> {obs, {{x, y}, :down}}
            ?< -> {obs, {{x, y}, :left}}
            _ -> {obs, g}
          end
        end)
      end)

    # Organize obstacles as sorted tuples for binary search
    organized = organize_obstacles(obstacles)

    {obstacles, organized, guard, width, height}
  end

  # Group obstacles by row and column as sorted tuples
  defp organize_obstacles(obstacles) do
    by_row =
      obstacles
      |> Enum.group_by(fn {_x, y} -> y end)
      |> Map.new(fn {y, obs} ->
        {y, obs |> Enum.map(fn {x, _} -> x end) |> Enum.sort() |> List.to_tuple()}
      end)

    by_col =
      obstacles
      |> Enum.group_by(fn {x, _y} -> x end)
      |> Map.new(fn {x, obs} ->
        {x, obs |> Enum.map(fn {_, y} -> y end) |> Enum.sort() |> List.to_tuple()}
      end)

    {by_row, by_col}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {_obstacles, organized, guard, width, height} = parse(input)

    walk_collecting(organized, guard, width, height, MapSet.new())
    |> MapSet.size()
  end

  defp walk_collecting({by_row, by_col}, {{x, y}, dir}, width, height, visited) do
    case find_ray_stop({by_row, by_col}, {x, y}, dir, width, height, nil) do
      {:out, end_pos} ->
        add_path(visited, {x, y}, end_pos)

      {:stop, stop_pos} ->
        visited = add_path(visited, {x, y}, stop_pos)
        walk_collecting({by_row, by_col}, {stop_pos, turn_right(dir)}, width, height, visited)
    end
  end

  defp add_path(visited, {x1, y1}, {x2, y2}) do
    cond do
      x1 == x2 ->
        Enum.reduce(min(y1, y2)..max(y1, y2), visited, &MapSet.put(&2, {x1, &1}))

      y1 == y2 ->
        Enum.reduce(min(x1, x2)..max(x1, x2), visited, &MapSet.put(&2, {&1, y1}))
    end
  end

  # Find where a ray stops, optionally considering an extra obstacle
  defp find_ray_stop({by_row, by_col}, {x, y}, dir, width, height, extra_obstacle) do
    case dir do
      :up ->
        col_obs = Map.get(by_col, x, {})
        base_obs_y = bsearch_prev(col_obs, y)

        # Check if extra obstacle blocks before the normal obstacle
        obs_y =
          case extra_obstacle do
            {^x, ey} when ey < y and (base_obs_y == nil or ey > base_obs_y) -> ey
            _ -> base_obs_y
          end

        case obs_y do
          nil -> {:out, {x, 0}}
          oy -> {:stop, {x, oy + 1}}
        end

      :down ->
        col_obs = Map.get(by_col, x, {})
        base_obs_y = bsearch_next(col_obs, y)

        obs_y =
          case extra_obstacle do
            {^x, ey} when ey > y and (base_obs_y == nil or ey < base_obs_y) -> ey
            _ -> base_obs_y
          end

        case obs_y do
          nil -> {:out, {x, height - 1}}
          oy -> {:stop, {x, oy - 1}}
        end

      :left ->
        row_obs = Map.get(by_row, y, {})
        base_obs_x = bsearch_prev(row_obs, x)

        obs_x =
          case extra_obstacle do
            {ex, ^y} when ex < x and (base_obs_x == nil or ex > base_obs_x) -> ex
            _ -> base_obs_x
          end

        case obs_x do
          nil -> {:out, {0, y}}
          ox -> {:stop, {ox + 1, y}}
        end

      :right ->
        row_obs = Map.get(by_row, y, {})
        base_obs_x = bsearch_next(row_obs, x)

        obs_x =
          case extra_obstacle do
            {ex, ^y} when ex > x and (base_obs_x == nil or ex < base_obs_x) -> ex
            _ -> base_obs_x
          end

        case obs_x do
          nil -> {:out, {width - 1, y}}
          ox -> {:stop, {ox - 1, y}}
        end
    end
  end

  # Binary search: find largest value < target
  defp bsearch_prev(tuple, _target) when tuple_size(tuple) == 0, do: nil

  defp bsearch_prev(tuple, target) do
    idx = bsearch_prev_idx(tuple, target, 0, tuple_size(tuple) - 1)
    if idx < 0, do: nil, else: elem(tuple, idx)
  end

  defp bsearch_prev_idx(_tuple, _target, low, high) when low > high, do: high

  defp bsearch_prev_idx(tuple, target, low, high) do
    mid = div(low + high, 2)

    if elem(tuple, mid) >= target do
      bsearch_prev_idx(tuple, target, low, mid - 1)
    else
      bsearch_prev_idx(tuple, target, mid + 1, high)
    end
  end

  # Binary search: find smallest value > target
  defp bsearch_next(tuple, _target) when tuple_size(tuple) == 0, do: nil

  defp bsearch_next(tuple, target) do
    size = tuple_size(tuple)
    idx = bsearch_next_idx(tuple, target, 0, size - 1)
    if idx >= size, do: nil, else: elem(tuple, idx)
  end

  defp bsearch_next_idx(_tuple, _target, low, high) when low > high, do: low

  defp bsearch_next_idx(tuple, target, low, high) do
    mid = div(low + high, 2)

    if elem(tuple, mid) <= target do
      bsearch_next_idx(tuple, target, mid + 1, high)
    else
      bsearch_next_idx(tuple, target, low, mid - 1)
    end
  end

  defp turn_right(:up), do: :right
  defp turn_right(:right), do: :down
  defp turn_right(:down), do: :left
  defp turn_right(:left), do: :up

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {_obstacles, organized, guard, width, height} = parse(input)

    {start_pos, _dir} = guard
    original_path = walk_collecting(organized, guard, width, height, MapSet.new())
    candidates = MapSet.delete(original_path, start_pos)

    # Test each candidate with inline obstacle checking (no structure rebuild)
    candidates
    |> Task.async_stream(
      fn pos ->
        causes_loop?(organized, guard, width, height, pos, MapSet.new())
      end,
      ordered: false,
      timeout: :infinity
    )
    |> Enum.count(fn {:ok, result} -> result end)
  end

  # Check for loop with an extra obstacle at extra_pos
  defp causes_loop?(organized, {{x, y}, dir}, width, height, extra_pos, visited_turns) do
    case find_ray_stop(organized, {x, y}, dir, width, height, extra_pos) do
      {:out, _} ->
        false

      {:stop, stop_pos} ->
        new_dir = turn_right(dir)
        state = {stop_pos, new_dir}

        if MapSet.member?(visited_turns, state) do
          true
        else
          visited_turns = MapSet.put(visited_turns, state)
          causes_loop?(organized, {stop_pos, new_dir}, width, height, extra_pos, visited_turns)
        end
    end
  end
end

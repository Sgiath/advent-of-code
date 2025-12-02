defmodule AdventOfCode.Year2024.Day15 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/15

  Optimized solution using Map with {x, y} tuple keys for O(log n) access/update
  instead of flat list with O(n) Enum.at/List.replace_at operations.
  """
  use AdventOfCode, year: 2024, day: 15

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    [
      """
      ########
      #..O.O.#
      ##@.O..#
      #...O..#
      #.#.O..#
      #...O..#
      #......#
      ########

      <^^>>>vv<v>>v<<
      """,
      """
      ##########
      #..O..O.O#
      #......O.#
      #.OO..O.O#
      #..O@..O.#
      #O#..O...#
      #O..O..O.#
      #.OO.O.OO#
      #....O...#
      ##########

      <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
      vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
      ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
      <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
      ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
      ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
      >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
      <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
      ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
      v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
      """
    ]
  end

  def parse(input) do
    [map_str, inputs_str] = String.split(input, "\n\n", trim: true)
    {parse_map(map_str), parse_inputs(inputs_str)}
  end

  # Parse the map into a Map with {x, y} keys for O(log n) access
  def parse_map(data) do
    rows = String.split(data, "\n", trim: true)

    {map, robot} =
      rows
      |> Enum.with_index()
      |> Enum.reduce({%{}, nil}, fn {row, y}, {map, robot} ->
        row
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.reduce({map, robot}, fn {char, x}, {map, robot} ->
          pos = {x, y}
          cell = parse_cell(char)
          new_robot = if cell == :robot, do: pos, else: robot
          {Map.put(map, pos, cell), new_robot}
        end)
      end)

    {map, robot}
  end

  defp parse_cell(?#), do: :wall
  defp parse_cell(?O), do: :box
  defp parse_cell(?@), do: :robot
  defp parse_cell(?.), do: :empty

  def parse_inputs(data) do
    data
    |> String.to_charlist()
    |> Enum.flat_map(fn
      ?v -> [{0, 1}]
      ?> -> [{1, 0}]
      ?^ -> [{0, -1}]
      ?< -> [{-1, 0}]
      ?\n -> []
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {{map, robot}, inputs} = parse(input)

    {final_map, _robot} = Enum.reduce(inputs, {map, robot}, &move/2)

    gps(final_map)
  end

  # Move the robot in the given direction
  def move({dx, dy}, {map, {x, y}}) do
    next_pos = {x + dx, y + dy}

    case Map.get(map, next_pos) do
      :empty ->
        # Move robot to empty space
        new_map =
          map
          |> Map.put(next_pos, :robot)
          |> Map.put({x, y}, :empty)

        {new_map, next_pos}

      :wall ->
        # Can't move into wall
        {map, {x, y}}

      :box ->
        # Try to push the chain of boxes
        case find_empty_space(map, next_pos, {dx, dy}) do
          nil ->
            # No empty space found (hit wall), can't move
            {map, {x, y}}

          empty_pos ->
            # Found empty space, push all boxes and move robot
            new_map =
              map
              |> Map.put(empty_pos, :box)
              |> Map.put(next_pos, :robot)
              |> Map.put({x, y}, :empty)

            {new_map, next_pos}
        end
    end
  end

  # Walk along direction until we find :empty or :wall
  # Returns the empty position or nil if we hit a wall
  defp find_empty_space(map, {x, y}, {dx, dy}) do
    next_pos = {x + dx, y + dy}

    case Map.get(map, next_pos) do
      :empty -> next_pos
      :wall -> nil
      :box -> find_empty_space(map, next_pos, {dx, dy})
    end
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

  # Calculate GPS sum directly from the Map
  def gps(map) do
    map
    |> Enum.reduce(0, fn
      {{x, y}, :box}, acc -> acc + 100 * y + x
      _, acc -> acc
    end)
  end
end

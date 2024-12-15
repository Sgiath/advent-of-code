defmodule AdventOfCode.Year2024.Day15 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/15
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
    [map, inputs] = String.split(input, ["\n\n"], trim: true)

    {parse_map(map), parse_inputs(inputs)}
  end

  def parse_map(data) do
    map =
      data
      |> String.split(["\n"], trim: true)
      |> Enum.map(fn row ->
        row
        |> String.to_charlist()
        |> Enum.map(fn
          ?# -> :wall
          ?O -> :box
          ?@ -> :robot
          ?. -> :empty
        end)
      end)

    l = length(map)
    map = List.flatten(map)
    i = Enum.find_index(map, &(&1 == :robot))

    {map, l, {rem(i, l), div(i, l)}}
  end

  def parse_inputs(data) do
    data
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> List.flatten()
    |> Enum.map(fn
      ?v -> {0, 1}
      ?> -> {1, 0}
      ?^ -> {0, -1}
      ?< -> {-1, 0}
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {{map, size, robot}, inputs} = parse(input)

    inputs
    |> Enum.reduce({map, size, robot}, &move/2)
    |> gps()
  end

  def move({vx, vy}, {map, size, {x, y}}) do
    # IO.puts("Move: #{vx}, #{vy}")
    # print({map, size})
    # IO.puts("")

    npos = {x + vx, y + vy}

    case get({map, size}, npos) do
      :empty ->
        {map, size} =
          {map, size}
          |> set(npos, :robot)
          |> set({x, y}, :empty)

        {map, size, npos}

      :wall ->
        {map, size, {x, y}}

      :box ->
        {{map, size}, pushed?} = move_box({map, size}, npos, {vx, vy})

        {map, size, if(pushed?, do: npos, else: {x, y})}
    end
  end

  def move_box(map, {x, y}, {vx, vy}) do
    npos = {x + vx, y + vy}

    case get(map, npos) do
      :box -> move_box(map, npos, {vx, vy})
      :wall -> {map, false}
      :empty -> {push_boxes(map, {x, y}, {vx, vy}), true}
    end
  end

  def push_boxes(map, {x, y}, {vx, vy}) do
    case get(map, {x, y}) do
      :box ->
        map
        |> set({x + vx, y + vy}, :box)
        |> set({x, y}, :empty)
        |> push_boxes({x - vx, y - vy}, {vx, vy})

      :robot ->
        map
        |> set({x + vx, y + vy}, :robot)
        |> set({x, y}, :empty)
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

  def get({map, size}, {x, y}), do: Enum.at(map, y * size + x)
  def set({map, size}, {x, y}, val), do: {List.replace_at(map, y * size + x, val), size}

  def gps({map, size, _robot}) do
    map
    |> Enum.chunk_every(size)
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {type, x} -> {type, {x, y}} end)
    end)
    |> List.flatten()
    |> Enum.filter(fn {type, _pos} -> type == :box end)
    |> Enum.map(fn {_type, {x, y}} -> 100 * y + x end)
    |> Enum.sum()
  end

  def print({map, size}) do
    map
    |> Enum.map(fn
      :wall -> "#"
      :empty -> "."
      :box -> "O"
      :robot -> "@"
    end)
    |> Enum.chunk_every(size)
    |> Enum.intersperse("\n")
    |> List.flatten()
    |> Enum.join()
    |> IO.puts()
  end
end

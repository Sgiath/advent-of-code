defmodule AdventOfCode.Year2024.Day06 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/6
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
    map =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&String.to_charlist/1)

    map = {List.flatten(map), length(map)}

    {map, find_initial(map)}
  end

  def find_initial({map, l}) do
    # index in map
    i = Enum.find_index(map, &(&1 in [?^, ?>, ?<, ?v]))

    # intial vector
    v =
      case Enum.at(map, i) do
        ?^ -> {0, -1}
        ?> -> {1, 0}
        ?v -> {0, 1}
        ?< -> {-1, 0}
      end

    # intial position
    y = Integer.floor_div(i, l)
    x = i - y * l

    {{x, y}, v}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {map, {pos, _vector} = init} = parse(input)

    map
    |> set(pos, ?X)
    |> path(init)
    |> then(fn {map, _length} -> map end)
    |> Enum.count(&(&1 == ?X))
  end

  # when out of bounds return
  def path({map, l}, {{x, y}, {vx, vy}})
      when x + vx >= l or x + vx < 0 or y + vy >= l or y + vy < 0,
      do: {map, l}

  def path(map, {{x, y}, {vx, vy} = vector}) do
    next = {x + vx, y + vy}

    case get(map, next) do
      # on unvisited place mark as visited and move to next position
      ?. ->
        map
        |> set(next, ?X)
        |> path({next, vector})

      # if already visited, just move to next position
      ?X ->
        path(map, {next, vector})

      # when next is obstacle, don't move but turn
      ?# ->
        path(map, {{x, y}, turn(vector)})
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

  def get({map, l}, {x, y}) do
    Enum.at(map, y * l + x)
  end

  def set({map, l}, {x, y}, val) do
    {List.replace_at(map, y * l + x, val), l}
  end

  def turn({0, -1}), do: {1, 0}
  def turn({1, 0}), do: {0, 1}
  def turn({0, 1}), do: {-1, 0}
  def turn({-1, 0}), do: {0, -1}
end

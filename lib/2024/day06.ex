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

    # intial position
    y = Integer.floor_div(i, l)
    x = i - y * l

    {{x, y}, Enum.at(map, i)}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @vectors [?^, ?>, ?v, ?<]

  @impl AdventOfCode
  def part1(input) do
    {map, head} = parse(input)

    map
    |> set(head)
    |> path(head)
    |> Enum.count(&(&1 in @vectors))
  end

  # when out of bounds return
  def path({map, _l}, {{_x, y}, ?^}) when y == 0, do: map
  def path({map, l}, {{x, _y}, ?>}) when x + 1 == l, do: map
  def path({map, l}, {{_x, y}, ?v}) when y + 1 == l, do: map
  def path({map, _l}, {{x, _y}, ?<}) when x == 0, do: map

  def path(map, {_pos, vec} = head) do
    # next position by the current vector
    next = move(head)

    case get(map, next) do
      # on unvisited place mark as visited and move to next position
      ?. ->
        map
        |> set(next)
        |> path(next)

      a when a == vec ->
        :loop

      # if already visited, just move to next position
      a when a in @vectors ->
        path(map, next)

      # when next is obstacle, don't move but turn
      ?# ->
        path(map, turn(head))
    end
  end

  # =============================================================================================
  # Part 2
  # this is slow as fuck (over 40s) but gets a job done :D
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {map, head} = parse(input)

    map
    |> set(head)
    |> path2(head)
    |> Task.await_many(:infinity)
    |> Enum.count(fn a -> a == :loop end)
  end

  # when out of bounds return empty (we know the full run without traps is not a loop)
  def path2({_map, _l}, {{_x, y}, ?^}) when y == 0, do: []
  def path2({_map, l}, {{x, _y}, ?>}) when x + 1 == l, do: []
  def path2({_map, l}, {{_x, y}, ?v}) when y + 1 == l, do: []
  def path2({_map, _l}, {{x, _y}, ?<}) when x == 0, do: []

  def path2(map, {_pos, vec} = head) do
    # next position by the current vector
    {pos, _v} = next = move(head)

    case get(map, next) do
      # on unvisited place mark as visited and move to next position
      ?. ->
        normal =
          map
          |> set(next)
          |> path2(next)

        trap =
          Task.async(fn ->
            map
            |> set({pos, ?#})
            |> path(turn(head))
          end)

        [trap | normal]

      a when a == vec ->
        :loop

      # if already visited, just move to next position
      a when a in @vectors ->
        path2(map, next)

      # when next is obstacle, don't move but turn
      ?# ->
        path2(map, turn(head))
    end
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  # get posion on map
  def get({map, l}, {{x, y}, _v}) do
    Enum.at(map, y * l + x)
  end

  # set position on map
  def set({map, l}, {{x, y}, v}) do
    {List.replace_at(map, y * l + x, v), l}
  end

  # turn 90 degrees in terms of vectors
  def turn({pos, ?^}), do: {pos, ?>}
  def turn({pos, ?>}), do: {pos, ?v}
  def turn({pos, ?v}), do: {pos, ?<}
  def turn({pos, ?<}), do: {pos, ?^}

  # move along vector
  def move({{x, y}, ?^}), do: {{x, y - 1}, ?^}
  def move({{x, y}, ?>}), do: {{x + 1, y}, ?>}
  def move({{x, y}, ?v}), do: {{x, y + 1}, ?v}
  def move({{x, y}, ?<}), do: {{x - 1, y}, ?<}
end

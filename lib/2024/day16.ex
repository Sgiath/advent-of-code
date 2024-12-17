defmodule AdventOfCode.Year2024.Day16 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/16
  """
  use AdventOfCode, year: 2024, day: 16

  alias AdventOfCode.Grid

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    [
      """
      ###############
      #.......#....E#
      #.#.###.#.###.#
      #.....#.#...#.#
      #.###.#####.#.#
      #.#.#.......#.#
      #.#.#####.###.#
      #...........#.#
      ###.#.#####.#.#
      #...#.....#.#.#
      #.#.#.###.#.#.#
      #.....#...#.#.#
      #.###.#.#.#.#.#
      #S..#.....#...#
      ###############
      """,
      """
      #################
      #...#...#...#..E#
      #.#.#.#.#.#.#.#.#
      #.#.#.#...#...#.#
      #.#.#.#.###.#.#.#
      #...#.#.#.....#.#
      #.#.#.#.#.#####.#
      #.#...#.#.#.....#
      #.#.#####.#.###.#
      #.#.#.......#...#
      #.#.###.#####.###
      #.#.#...#.....#.#
      #.#.#.#####.###.#
      #.#.#.........#.#
      #.#.#.#########.#
      #S#.............#
      #################
      """
    ]
  end

  @pallete %{
    ?# => :wall,
    ?. => :empty,
    ?S => :start,
    ?E => :end
  }

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    map = Grid.parse(input, @pallete)
    # start location
    start = Grid.find(map, :start)
    # start head
    head = [{start, {-1, 0}, 0, MapSet.new()}]

    # head = search(map, head)
    search(map, head)
  end

  @doc """
  This actually works but takes a VERY long time to finish, probably all the list flatten and
  sorting. Don't have time to investigate further - work and stuff :)
  """
  def search(map, [{{x, y}, {vx, vy}, score, visitied} | heads]) do
    new_heads =
      case Grid.get(map, {x, y}) do
        :wall ->
          []

        :end ->
          score

        _otherwise ->
          if MapSet.member?(visitied, {{x, y}, {vx, vy}}) do
            []
          else
            # visitied = MapSet.put(visitied, {{x, y}, {vx, vy}})

            [
              {{x + vx, y + vy}, {vx, vy}, score + 1, visitied},
              {{x, y}, {vy, vx}, score + 1000, visitied},
              {{x, y}, {-vy, -vx}, score + 1000, visitied}
            ]
          end
      end

    if is_integer(new_heads) do
      new_heads
    else
      heads =
        [new_heads | heads]
        |> List.flatten()
        |> Enum.sort_by(&elem(&1, 2))

      search(map, heads)
    end
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> Grid.parse(@pallete)
    |> dbg()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def get({map, size}, {x, y}), do: Enum.at(map, y * size + x)

  def start({map, size}) do
    i = Enum.find_index(map, &(&1 == ?S))
    {{rem(i, size), div(i, size)}, {1, 0}}
  end
end

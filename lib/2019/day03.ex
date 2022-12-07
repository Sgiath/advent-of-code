defmodule AdventOfCode.Year2019.Day03 do
  @moduledoc """
  https://adventofcode.com/2019/day/3
  """
  use AdventOfCode, year: 2019, day: 3

  @type direction() :: {:up | :left | :down | :right, integer()}
  @type path() :: list(direction())
  @type point() :: {integer(), integer()}

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83
    """
  end

  def parse_line(line) do
    line
    |> String.split(",", trim: true)
    |> Enum.map(&parse_path/1)
    |> path_to_points()
  end

  @spec parse_path(String.t()) :: direction()
  def parse_path("U" <> distance), do: {:up, String.to_integer(distance)}
  def parse_path("R" <> distance), do: {:right, String.to_integer(distance)}
  def parse_path("D" <> distance), do: {:down, String.to_integer(distance)}
  def parse_path("L" <> distance), do: {:left, String.to_integer(distance)}

  @doc """
  Convert path description to the list of points

  # Examples

  iex> AdventOfCode.Year2019.Day03.path_to_points([up: 1])
  [{0, 1}]

  iex> AdventOfCode.Year2019.Day03.path_to_points([right: 2, up: 1])
  [{1, 0}, {2, 0}, {2, 1}]

  iex> AdventOfCode.Year2019.Day03.path_to_points([down: 1, left: 3])
  [{0, -1}, {-1, -1}, {-2, -1}, {-3, -1}]
  """
  @spec path_to_points(wire_path :: path()) :: list(point())
  def path_to_points(wire_path) do
    {{0, 0}, wire_points} =
      wire_path
      |> Enum.reduce([{0, 0}], &add_points/2)
      |> List.pop_at(-1)

    Enum.reverse(wire_points)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&parse_line/1)
    |> select_common()
    |> Enum.map(&calc_distance/1)
    |> Enum.min()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    [wire1, wire2] =
      wires =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&parse_line/1)

    wires
    |> select_common()
    |> Enum.map(&calc_delay(wire1, wire2, &1))
    |> Enum.min()
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Function for reducer to generate all points for one instruction
  """
  @spec add_points({:up | :right | :down | :left, integer()}, list(point())) :: list(point())
  def add_points({_direction, 0}, wire_points), do: wire_points

  def add_points({:up, distance}, [{current_x, current_y} | _rest] = wire_points) do
    add_points({:up, distance - 1}, [{current_x, current_y + 1} | wire_points])
  end

  def add_points({:right, distance}, [{current_x, current_y} | _rest] = wire_points) do
    add_points({:right, distance - 1}, [{current_x + 1, current_y} | wire_points])
  end

  def add_points({:down, distance}, [{current_x, current_y} | _rest] = wire_points) do
    add_points({:down, distance - 1}, [{current_x, current_y - 1} | wire_points])
  end

  def add_points({:left, distance}, [{current_x, current_y} | _rest] = wire_points) do
    add_points({:left, distance - 1}, [{current_x - 1, current_y} | wire_points])
  end

  @doc """
  Select common point between two wires - itersections

  # Examples

  iex> AdventOfCode.Year2019.Day03.select_common([[{1, 1}, {2, 1}], [{3, 1}, {1, 1}]])
  [{1, 1}]
  """
  @spec select_common([[point()]]) :: list(point())
  def select_common([wire1, wire2]) do
    MapSet.to_list(MapSet.intersection(MapSet.new(wire1), MapSet.new(wire2)))
  end

  @doc """
  Calculate Manhattan distance for the point and {0, 0}

  iex> AdventOfCode.Year2019.Day03.calc_distance({4, 5})
  9

  iex> AdventOfCode.Year2019.Day03.calc_distance({34, -23})
  57
  """
  @spec calc_distance(point()) :: integer()
  def calc_distance({x, y}), do: abs(x) + abs(y)

  @doc """
  Calculate delay for the point - index in the path list

  Adding 2 to accomodate for lists starting from 0
  """
  @spec calc_delay(wire1 :: list(point()), wire2 :: list(point()), point()) :: integer()
  def calc_delay(wire1, wire2, point) do
    Enum.find_index(wire1, &(&1 == point)) + Enum.find_index(wire2, &(&1 == point)) + 2
  end
end

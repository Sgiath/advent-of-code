defmodule AdventOfCode.Year2019.Day03 do
  @moduledoc """
  https://adventofcode.com/2019/day/3
  """
  use AdventOfCode, year: 2019, day: 03

  require Logger

  @type direction() :: {:up | :left | :down | :right, integer()}
  @type path() :: list(direction())
  @type point() :: {integer(), integer()}

  def parse_path("U" <> distance), do: {:up, String.to_integer(distance)}
  def parse_path("R" <> distance), do: {:right, String.to_integer(distance)}
  def parse_path("D" <> distance), do: {:down, String.to_integer(distance)}
  def parse_path("L" <> distance), do: {:left, String.to_integer(distance)}

  @impl AdventOfCode
  def input do
    ","
    |> input_lists(&parse_path/1)
    |> Enum.map(&path_to_points/1)
  end

  @impl AdventOfCode
  def part1([wire1, wire2]) do
    wire1
    |> select_common(wire2)
    |> Enum.map(&calc_distance/1)
    |> Enum.min()
  end

  @impl AdventOfCode
  def part2([wire1, wire2]) do
    wire1
    |> select_common(wire2)
    |> Enum.map(&calc_delay(wire1, wire2, &1))
    |> Enum.min()
  end

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

  iex> AdventOfCode.Year2019.Day03.select_common([{1, 1}, {2, 1}], [{3, 1}, {1, 1}])
  [{1, 1}]
  """
  @spec select_common(wire1 :: list(point()), wire2 :: list(point())) :: list(point())
  def select_common(wire1, wire2) do
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

defmodule AdventOfCode.Year2023.Day10 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/10
  """
  use AdventOfCode, year: 2023, day: 10

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input, do: test_input3()

  def test_input1 do
    """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """
  end

  def test_input2 do
    """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """
  end

  def test_input3 do
    """
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """
  end

  def test_input4 do
    """
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    """
  end

  def test_input5 do
    """
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    """
  end

  def parse(input) do
    schema =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&String.graphemes/1)

    {schema, find(schema, "S")}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {schema, {x, y}} = parse(input)

    n1 = neigh(schema, {x - 1, y})
    n2 = neigh(schema, {x + 1, y})
    n3 = neigh(schema, {x, y - 1})
    n4 = neigh(schema, {x, y + 1})

    [start | _rest] =
      [[{x - 1, y} | n1], [{x + 1, y} | n2], [{x, y - 1} | n3], [{x, y + 1} | n4]]
      |> Enum.filter(&({x, y} in &1))
      |> List.first()

    {_schema, len} =
      schema
      |> put({x, y}, "#")
      |> traverse(start, 1)

    div(len, 2)
  end

  def traverse(schema, {x, y}, at) do
    [n1, n2] = schema |> neigh({x, y})
    schema = put(schema, {x, y}, "#")

    cond do
      get(schema, n1) != "#" -> traverse(schema, n1, at + 1)
      get(schema, n2) != "#" -> traverse(schema, n2, at + 1)
      :otherwise -> {schema, at}
    end
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {schema, {x, y}} = parse(input)

    n1 = neigh(schema, {x - 1, y})
    n2 = neigh(schema, {x + 1, y})
    n3 = neigh(schema, {x, y - 1})
    n4 = neigh(schema, {x, y + 1})

    [start | _rest] =
      [[{x - 1, y} | n1], [{x + 1, y} | n2], [{x, y - 1} | n3], [{x, y + 1} | n4]]
      |> Enum.filter(&({x, y} in &1))
      |> List.first()

    {schema, _len} =
      schema
      |> put({x, y}, "#")
      |> traverse(start, 1)

    schema
    |> Enum.reduce([], &[process_line(&1) | &2])
    |> Enum.reverse()
    |> List.flatten()
    |> Enum.count(&(&1 == "I"))
    |> dbg()
  end

  def process_line(line) do
    {line, _last} =
      Enum.reduce(line, {[], :out}, fn
        "#", {acc, :out} -> {["#" | acc], :in}
        "#", {acc, :in} -> {["#" | acc], :out}
        _val, {acc, :out} -> {["O" | acc], :out}
        _val, {acc, :in} -> {["I" | acc], :in}
      end)

    Enum.reverse(line)
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def get(schema, {x, y}) when x >= 0 and y >= 0, do: get_in(schema, [Access.at(y), Access.at(x)])
  def get(_schema, _invalid_position), do: "."

  def find(schema, char) do
    y = Enum.find_index(schema, &(char in &1))
    x = schema |> Enum.at(y) |> Enum.find_index(&(&1 == char))
    {x, y}
  end

  def put(schema, {x, y}, value) do
    put_in(schema, [Access.at(y), Access.at(x)], value)
  end

  def neigh(schema, {x, y}) do
    case get(schema, {x, y}) do
      "-" -> [{x - 1, y}, {x + 1, y}]
      "|" -> [{x, y - 1}, {x, y + 1}]
      "L" -> [{x + 1, y}, {x, y - 1}]
      "J" -> [{x - 1, y}, {x, y - 1}]
      "7" -> [{x - 1, y}, {x, y + 1}]
      "F" -> [{x + 1, y}, {x, y + 1}]
      _otherwise -> []
    end
  end
end

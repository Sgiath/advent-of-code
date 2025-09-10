defmodule AdventOfCode.Year2022.Day14 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/14
  """
  use AdventOfCode, year: 2022, day: 14

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    """
  end

  def parse(input) do
    rocks =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&parse_line/1)
      |> Enum.map(&fill_gaps/1)
      |> List.flatten()

    lowest =
      rocks
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    {Enum.into(rocks, MapSet.new()), lowest}
  end

  def parse_line(line) do
    line
    |> String.split([",", " -> "], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def fill_gaps(line, acc \\ [])

  def fill_gaps([{x1, y1}, {x2, y2} | rest], acc) do
    acc =
      for x <- range(x1, x2), y <- range(y1, y2), reduce: acc do
        acc -> [{x, y} | acc]
      end

    fill_gaps([{x2, y2} | rest], acc)
  end

  def fill_gaps([_last_point], acc), do: acc

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {rocks, lowest} = parse(input)
    sand = simulate1({rocks, lowest})

    MapSet.size(sand) - MapSet.size(rocks)
  end

  def simulate1(world, sand \\ {500, 0})

  def simulate1({world, lowest}, {x, y}) do
    cond do
      # if sand is lower then lowest rock it falls into abbys and we are done
      y > lowest ->
        world

      # first try to move down
      {x, y + 1} not in world ->
        simulate1({world, lowest}, {x, y + 1})

      # try to move down and left
      {x - 1, y + 1} not in world ->
        simulate1({world, lowest}, {x - 1, y + 1})

      # try to move down and right
      {x + 1, y + 1} not in world ->
        simulate1({world, lowest}, {x + 1, y + 1})

      # sand is still, simulate next sand
      :otherwise ->
        simulate1({MapSet.put(world, {x, y}), lowest})
    end
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {rocks, lowest} = parse(input)
    sand = simulate2({rocks, lowest})

    MapSet.size(sand) - MapSet.size(rocks)
  end

  def simulate2(world, sand \\ {500, 0})

  def simulate2({world, lowest}, {x, y}) do
    cond do
      # sand is on the floor, simulate next sand
      y == lowest + 1 ->
        simulate2({MapSet.put(world, {x, y}), lowest})

      # first try to move down
      {x, y + 1} not in world ->
        simulate2({world, lowest}, {x, y + 1})

      # try to move down and left
      {x - 1, y + 1} not in world ->
        simulate2({world, lowest}, {x - 1, y + 1})

      # try to move down and right
      {x + 1, y + 1} not in world ->
        simulate2({world, lowest}, {x + 1, y + 1})

      # sand is still and is at the starting point, finish simulation
      x == 500 and y == 0 ->
        MapSet.put(world, {x, y})

      # sand is still, continue simulation with next sand
      :otherwise ->
        simulate2({MapSet.put(world, {x, y}), lowest})
    end
  end
end

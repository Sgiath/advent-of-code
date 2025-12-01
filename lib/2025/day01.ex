defmodule AdventOfCode.Year2025.Day01 do
  @moduledoc ~S"""
  https://adventofcode.com/2025/day/1
  """
  use AdventOfCode, year: 2025, day: 01

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn 
      "L" <> distance -> {:left, String.to_integer(distance)}
      "R" <> distance -> {:right, String.to_integer(distance)}
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn move, {pos, count} ->
      case move(move, pos) do
        {0, _count} -> {0, count + 1}
        {new_pos, _count} -> {new_pos, count}
      end
    end)
    |> elem(1)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.reduce({50, 0}, fn move, {pos, count} ->
      {new_pos, new_count} = move(move, pos)

      {new_pos, count + new_count}
    end)
    |> elem(1)
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def move(move, pos, count \\ 0)

  # move more then one full circle
  def move({:left, distance}, pos, count) when distance >= 100 do
    move({:left, rem(distance, 100)}, pos, count + div(distance, 100))
  end

  # starting at 0 (do not count the click at 0)
  def move({:left, distance}, 0, count) do
    {100 - distance, count}
  end

  # move will cross 0
  def move({:left, distance}, pos, count) when distance > pos do
    {pos - distance + 100, count + 1}
  end

  # move that will end at 0
  def move({:left, distance}, pos, count) when distance == pos do
    {0, count + 1}
  end

  # normal move
  def move({:left, distance}, pos, count) do
    {pos - distance, count}
  end

  # move more then one full circle
  def move({:right, distance}, pos, count) when distance >= 100 do
    move({:right, rem(distance, 100)}, pos, count + div(distance, 100))
  end

  # move will cross 0
  def move({:right, distance}, pos, count) when distance + pos > 100 do
    {rem(pos + distance, 100), count + 1}
  end

  # move that will end at 0
  def move({:right, distance}, pos, count) when distance + pos == 100 do
    {0, count + 1}
  end

  # normal move
  def move({:right, distance}, pos, count) do
    {pos + distance, count}
  end
end

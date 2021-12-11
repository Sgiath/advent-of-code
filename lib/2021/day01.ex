defmodule AdventOfCode.Year2021.Day01 do
  @moduledoc """
  https://adventofcode.com/2021/day/1
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day01.in"])
    |> File.read!()
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> part1(0)
  end

  def part1([a, b | rest], acc) when a < b, do: part1([b | rest], acc + 1)
  def part1([_a | rest], acc), do: part1(rest, acc)
  def part1(_measurements, acc), do: acc

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> part2(0)
  end

  def part2([a, b, c, d | rest], acc) when a < d, do: part2([b, c, d | rest], acc + 1)
  def part2([_a | rest], acc), do: part2(rest, acc)
  def part2(_measurements, acc), do: acc

  # ===============================================================================================
  # Enum soultion
  # ===============================================================================================

  # I find this solutin more appealing but it is much slower than my original solution (8 μs vs
  # 150 μs)
  def part1_chunk(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  def part2_chunk(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  # ===============================================================================================
  # Benchmarks
  # ===============================================================================================

  @impl AdventOfCode
  def bench do
    [
      %{
        part1_pattern: &part1/1,
        part1_chunk: &part1_chunk/1
      },
      %{
        part2_pattern: &part2/1,
        part2_chunk: &part2_chunk/1
      }
    ]
  end
end

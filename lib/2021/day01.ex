defmodule AdventOfCode.Year2021.Day01 do
  @moduledoc """
  https://adventofcode.com/2021/day/1
  """
  use AdventOfCode, year: 2021, day: 01

  @impl AdventOfCode
  def input, do: input_numbers()

  @impl AdventOfCode
  def part1(input, acc \\ 0)
  def part1([a, b | rest], acc) when a < b, do: part1([b | rest], acc + 1)
  def part1([_ | rest], acc), do: part1(rest, acc)
  def part1(_, acc), do: acc

  @impl AdventOfCode
  def part2(measurements, acc \\ 0)
  def part2([a, b, c, d | rest], acc) when a < d, do: part2([b, c, d | rest], acc + 1)
  def part2([_ | rest], acc), do: part2(rest, acc)
  def part2(_, acc), do: acc

  # ===============================================================================================
  # Other solutions
  # ===============================================================================================

  # I find this solutin more appealing but it is much slower than my original solution
  def part1_chunk(input) do
    input
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  def part2_chunk(input) do
    input
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  # Benchmarking different solutions
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

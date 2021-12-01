defmodule AdventOfCode.Year2021.Day01 do
  @moduledoc """
  https://adventofcode.com/2021/day/1
  """
  use AdventOfCode, year: 2021, day: 01

  @impl AdventOfCode
  def part1 do
    input_numbers()
    |> Enum.to_list()
    |> count_inc()
  end

  @spec count_inc([integer()], non_neg_integer()) :: non_neg_integer()
  def count_inc(measurements, acc \\ 0)
  def count_inc([a, b | rest], acc) when a < b, do: count_inc([b | rest], acc + 1)
  def count_inc([_ | rest], acc), do: count_inc(rest, acc)
  def count_inc(_, acc), do: acc

  @impl AdventOfCode
  def part2 do
    input_numbers()
    |> Enum.to_list()
    |> count_slide()
  end

  @spec count_slide([integer()], non_neg_integer()) :: non_neg_integer()
  def count_slide(measurements, acc \\ 0)
  def count_slide([a, b, c, d | rest], acc) when a < d, do: count_slide([b, c, d | rest], acc + 1)
  def count_slide([_ | rest], acc), do: count_slide(rest, acc)
  def count_slide(_, acc), do: acc
end

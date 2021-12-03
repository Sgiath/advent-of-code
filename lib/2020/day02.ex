defmodule AdventOfCode.Year2020.Day02 do
  @moduledoc """
  https://adventofcode.com/2020/day/2
  """
  use AdventOfCode, year: 2020, day: 02

  @impl AdventOfCode
  def input do
    regex = ~r/(?<min>\d+)-(?<max>\d+) (?<char>[a-z]): (?<pass>[a-z]+)/

    Enum.map(input_lines(), fn line ->
      regex
      |> Regex.named_captures(line)
      |> Map.update!("min", &String.to_integer/1)
      |> Map.update!("max", &String.to_integer/1)
    end)
  end

  @impl AdventOfCode
  def part1(input) do
    input
    |> Enum.filter(&valid_count?/1)
    |> length()
  end

  defp valid_count?(%{"min" => min, "max" => max, "char" => char, "pass" => pass}) do
    count =
      pass
      |> String.graphemes()
      |> Enum.filter(&(&1 == char))
      |> length()

    min <= count and count <= max
  end

  @impl AdventOfCode
  def part2(input) do
    input
    |> Enum.filter(&valid_pos?/1)
    |> length()
  end

  defp valid_pos?(%{"min" => min, "max" => max, "char" => char, "pass" => pass}) do
    first = String.at(pass, min - 1) == char
    second = String.at(pass, max - 1) == char

    # XOR
    (first or second) and not (first and second)
  end
end

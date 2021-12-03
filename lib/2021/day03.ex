defmodule AdventOfCode.Year2021.Day03 do
  @moduledoc """
  https://adventofcode.com/2021/day/3
  """
  use AdventOfCode, year: 2021, day: 03

  @impl AdventOfCode
  def input do
    input_lines()
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(fn row -> Enum.map(row, &(&1 - ?0)) end)
    |> Enum.to_list()
  end

  @impl AdventOfCode
  def part1(input) do
    rate =
      input
      |> Enum.reduce(&list_sum/2)
      |> Enum.map(&if &1 > 500, do: 1, else: 0)

    list_to_integer(rate) * list_to_integer(invert(rate))
  end

  def list_sum(a, b, acc \\ [])
  def list_sum([a | a_rest], [b | b_rest], acc), do: list_sum(a_rest, b_rest, [a + b | acc])
  def list_sum([], [], acc), do: Enum.reverse(acc)

  def list_to_integer(input) do
    input
    |> Enum.map(&if &1 == 0, do: ?0, else: ?1)
    |> List.to_string()
    |> String.to_integer(2)
  end

  def invert(input) do
    Enum.map(input, &if(&1 == 0, do: 1, else: 0))
  end

  @impl AdventOfCode
  def part2(input) do
    oxygen(input) * co2(input)
  end

  def oxygen(input, pos \\ 0)

  def oxygen([result], _pos), do: list_to_integer(result)

  def oxygen(input, pos) do
    f = freq(input, pos)

    input
    |> Enum.filter(&(Enum.at(&1, pos) == f))
    |> oxygen(pos + 1)
  end

  def co2(input, pos \\ 0)

  def co2([result], _pos), do: list_to_integer(result)

  def co2(input, pos) do
    f = freq(input, pos)

    input
    |> Enum.filter(&(Enum.at(&1, pos) != f))
    |> co2(pos + 1)
  end

  def freq(input, pos) do
    input
    |> Enum.map(&Enum.at(&1, pos))
    |> IO.inspect(label: "freq")
    |> Enum.sum()
    |> Kernel.>=(div(length(input) + 1, 2))
    |> case do
      true -> 1
      false -> 0
    end
  end
end

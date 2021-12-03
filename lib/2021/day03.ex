defmodule AdventOfCode.Year2021.Day03 do
  @moduledoc """
  https://adventofcode.com/2021/day/3
  """
  use AdventOfCode, year: 2021, day: 03
  use Bitwise

  @impl AdventOfCode
  def input do
    input_lines()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(fn row -> Enum.map(row, &(&1 - ?0)) end)
  end

  @impl AdventOfCode
  def part1(input) do
    h = half(input)

    input
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sum/1)
    |> Enum.map(&if(&1 > h, do: 1, else: 0))
    |> list_to_integer()
    |> then(&(&1 * bxor(&1, 0b111111111111)))
  end

  @doc """
  Get half of the length of the list
  """
  def half(input), do: div(length(input) + 1, 2)

  @doc """
  Convert list of 1 and 0 to integer
  """
  def list_to_integer(input) do
    input
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, &bor(&2, elem(&1, 0) <<< elem(&1, 1)))
  end

  @impl AdventOfCode
  def part2(input) do
    rating(input, &Kernel.==/2) * rating(input, &Kernel.!=/2)
  end

  def rating(input, filter, pos \\ 0)

  def rating([result], _filter, _pos), do: list_to_integer(result)

  def rating(input, filter, pos) do
    # get most frequent bit for position
    freq =
      input
      |> Enum.map(&Enum.at(&1, pos))
      |> Enum.sum()
      |> then(&if &1 >= half(input), do: 1, else: 0)

    # filter out not matching inputs
    input
    |> Enum.filter(&filter.(Enum.at(&1, pos), freq))
    |> rating(filter, pos + 1)
  end
end

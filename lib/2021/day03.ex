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
    |> Enum.map(&Tuple.sum/1)
    |> Enum.map(&if(&1 > h, do: 1, else: 0))
    |> list_to_integer()
    |> then(&(&1 * bxor(&1, 0b111111111111)))
  end

  # Get half of the length of the list
  defp half(input), do: div(length(input) + 1, 2)

  # Convert list of 1 and 0 to integer
  defp list_to_integer(input) do
    input
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {bit, index}, acc -> bor(acc, bit <<< index) end)
  end

  @impl AdventOfCode
  def part2(input) do
    rating(input, &Kernel.==/2) * rating(input, &Kernel.!=/2)
  end

  defp rating(input, filter, pos \\ 0)
  defp rating([result], _filter, _pos), do: list_to_integer(result)

  defp rating(input, filter, pos) do
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

defmodule AdventOfCode.Year2021.Day03 do
  @moduledoc """
  https://adventofcode.com/2021/day/3
  """
  use AdventOfCode, year: 2021, day: 03
  use Bitwise

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def input, do: input_data()

  def parse_line(line) do
    line
    |> String.to_charlist()
    |> Enum.map(fn x -> x - ?0 end)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    [sample | _rest] =
      input =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&parse_line/1)

    h = half(input)

    input
    |> Enum.zip()
    |> Enum.map(&if(Tuple.sum(&1) > h, do: 1, else: 0))
    |> list_to_integer()
    |> then(&(&1 * bxor(&1, 2 ** length(sample) - 1)))
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&parse_line/1)

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

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  # Get half of the length of the list
  defp half(input), do: div(length(input) + 1, 2)

  # Convert list of 1 and 0 to integer
  defp list_to_integer(input) do
    input
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {bit, index}, acc -> bor(acc, bit <<< index) end)
  end
end

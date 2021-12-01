defmodule AdventOfCode.Year2019.Day04 do
  @moduledoc """
  https://adventofcode.com/2019/day/4
  """
  use AdventOfCode, year: 2019, day: 04

  @doc """
  Compute task 1
  """
  @impl AdventOfCode
  def part1 do
    168_630..718_098
    |> Stream.map(&Integer.to_charlist/1)
    |> Stream.filter(&increasing?/1)
    |> Stream.filter(&same_digits?/1)
    |> Enum.count()
  end

  @doc """
  Compute task 2
  """
  @impl AdventOfCode
  def part2 do
    168_630..718_098
    |> Stream.map(&Integer.to_charlist/1)
    |> Stream.filter(&increasing?/1)
    |> Stream.filter(&one_two_digit_group?/1)
    |> Enum.count()
  end

  @doc """
  Check if the digits in the code are not decreasing

  # Examples

  iex> AdventOfCode.Year2019.Day04.increasing?([1, 1, 1, 1, 1, 1])
  true

  iex> AdventOfCode.Year2019.Day04.increasing?([2, 2, 3, 4, 5, 0])
  false

  iex> AdventOfCode.Year2019.Day04.increasing?([1, 2, 3, 7, 8, 9])
  true
  """
  @spec increasing?(code :: charlist()) :: boolean()
  def increasing?([dig1, dig2 | rest]) when dig1 <= dig2 do
    increasing?([dig2 | rest])
  end

  def increasing?([_single_digit]), do: true
  def increasing?(_), do: false

  @doc """
  Check if list contains some duplicated numbers

  # Examples

  iex> AdventOfCode.Year2019.Day04.same_digits?([1, 1, 1, 1, 1, 1])
  true

  iex> AdventOfCode.Year2019.Day04.same_digits?([2, 2, 3, 4, 5, 0])
  true

  iex> AdventOfCode.Year2019.Day04.same_digits?([1, 2, 3, 7, 8, 9])
  false
  """
  @spec same_digits?(code :: charlist()) :: boolean()
  def same_digits?(code) do
    Enum.count(Enum.dedup(code)) < 6
  end

  @doc """
  Check if list contains at least one group of exactly two digits

  # Examples

  iex> AdventOfCode.Year2019.Day04.one_two_digit_group?([1, 1, 2, 2, 3, 3])
  true

  iex> AdventOfCode.Year2019.Day04.one_two_digit_group?([1, 2, 3, 4, 4, 4])
  false

  iex> AdventOfCode.Year2019.Day04.one_two_digit_group?([1, 1, 1, 1, 2, 2])
  true
  """
  @spec one_two_digit_group?(code :: charlist()) :: boolean()
  def one_two_digit_group?(code) do
    code
    |> Enum.chunk_by(& &1)
    |> Enum.any?(&(length(&1) == 2))
  end
end

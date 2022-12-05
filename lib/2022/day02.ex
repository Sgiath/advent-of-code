defmodule AdventOfCode.Year2022.Day02 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/2
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    A Y
    B X
    C Z
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2022", "day02.in"])
    |> File.read!()
  end

  def parse(input) do
    input
    |> String.split(["\n", " "], trim: true)
    |> Enum.chunk_every(2)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(fn [p1, p2] -> [convert1(p1), convert1(p2)] end)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  defp convert1("A"), do: :rock
  defp convert1("X"), do: :rock
  defp convert1("B"), do: :paper
  defp convert1("Y"), do: :paper
  defp convert1("C"), do: :scissors
  defp convert1("Z"), do: :scissors

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.map(&convert2/1)
    |> Enum.map(&score/1)
    |> Enum.sum()
  end

  defp convert2(["A", "X"]), do: [:rock, :scissors]
  defp convert2(["A", "Y"]), do: [:rock, :rock]
  defp convert2(["A", "Z"]), do: [:rock, :paper]
  defp convert2(["B", "X"]), do: [:paper, :rock]
  defp convert2(["B", "Y"]), do: [:paper, :paper]
  defp convert2(["B", "Z"]), do: [:paper, :scissors]
  defp convert2(["C", "X"]), do: [:scissors, :paper]
  defp convert2(["C", "Y"]), do: [:scissors, :scissors]
  defp convert2(["C", "Z"]), do: [:scissors, :rock]

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  defp score([:rock, :rock]), do: 4
  defp score([:paper, :paper]), do: 5
  defp score([:scissors, :scissors]), do: 6
  defp score([:rock, :paper]), do: 8
  defp score([:rock, :scissors]), do: 3
  defp score([:paper, :rock]), do: 1
  defp score([:paper, :scissors]), do: 9
  defp score([:scissors, :rock]), do: 7
  defp score([:scissors, :paper]), do: 2
end

defmodule AdventOfCode.Year2018.Day01 do
  @moduledoc """
  https://adventofcode.com/2018/day/1
  """
  use AdventOfCode, year: 2018, day: 01

  @impl AdventOfCode
  def input, do: input_numbers()

  @impl AdventOfCode
  def part1(input) do
    Enum.sum(input)
  end

  @impl AdventOfCode
  def part2(input) do
    input
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn num, {last_freq, freq} ->
      new_freq = last_freq + num

      if new_freq in freq do
        {:halt, new_freq}
      else
        {:cont, {new_freq, MapSet.put(freq, new_freq)}}
      end
    end)
  end
end

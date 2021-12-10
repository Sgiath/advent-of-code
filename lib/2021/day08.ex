defmodule AdventOfCode.Year2021.Day08 do
  @moduledoc """
  https://adventofcode.com/2021/day/8
  """
  use AdventOfCode, year: 2021, day: 08

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def input, do: input_data()

  def parse_line(data) do
    data
    |> Enum.chunk_every(10)
    |> then(fn [signal, output] ->
      {Enum.sort_by(signal, &length/1), output}
    end)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> String.split([" ", " | ", "\n"], trim: true)
    |> Enum.map(&(&1 |> String.graphemes() |> Enum.sort()))
    |> Enum.chunk_every(14)
    |> Enum.map(&parse_line/1)
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.count(&(length(&1) in [2, 3, 4, 7]))
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> String.split([" ", " | ", "\n"], trim: true)
    |> Enum.map(&(&1 |> String.graphemes() |> Enum.sort()))
    |> Enum.chunk_every(14)
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn {signal, output} ->
      mapping = compute_mapping(signal)

      output
      |> Enum.map_join(&Map.get(mapping, &1))
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Compute mapping from signal data
  """
  def compute_mapping(signal) do
    signal
    |> Enum.reduce(%{}, &find_digits/2)
    |> Enum.into(%{}, fn {key, val} -> {val, Integer.to_string(key)} end)
  end

  @doc """
  Determine digit based on the segment data and previously determined digits
  """
  def find_digits(data, acc) when length(data) == 2, do: Map.put(acc, 1, data)
  def find_digits(data, acc) when length(data) == 3, do: Map.put(acc, 7, data)
  def find_digits(data, acc) when length(data) == 4, do: Map.put(acc, 4, data)
  def find_digits(data, acc) when length(data) == 7, do: Map.put(acc, 8, data)

  def find_digits(data, %{1 => one, 4 => four} = acc) when length(data) == 5 do
    cond do
      # three contains all segments of one
      Enum.all?(one, &(&1 in data)) ->
        Map.put(acc, 3, data)

      # two contains 2 segments from four
      Enum.count(data, &(&1 in four)) == 2 ->
        Map.put(acc, 2, data)

      # five contains 3 segments from four
      :otherwise ->
        Map.put(acc, 5, data)
    end
  end

  def find_digits(data, %{1 => one, 4 => four} = acc) when length(data) == 6 do
    cond do
      # nine contains all segments from four
      Enum.all?(four, &(&1 in data)) ->
        Map.put(acc, 9, data)

      # zero contains all segments from one
      Enum.all?(one, &(&1 in data)) ->
        Map.put(acc, 0, data)

      # six is the only 6 segment number left
      :otherwise ->
        Map.put(acc, 6, data)
    end
  end
end

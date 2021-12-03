defmodule AdventOfCode.Year2018.Day02 do
  @moduledoc """
  https://adventofcode.com/2018/day/2
  """
  use AdventOfCode, year: 2018, day: 02

  @impl AdventOfCode
  def input, do: input_lines()

  @impl AdventOfCode
  def part1(input) do
    # Compute number of words containing pairs and triples
    {pairs, triples} =
      Enum.reduce(input, {0, 0}, fn id, {pairs, triples} ->
        # Get pair and triple for one word
        {pair, triple} = get_pair_and_triple(id)

        # Sum it with accumulator
        {pair + pairs, triple + triples}
      end)

    # Compute final checksum
    pairs * triples
  end

  @doc "Compute if string contains pair or triple"
  @spec get_pair_and_triple(string :: String.t()) :: {0 | 1, 0 | 1}
  def get_pair_and_triple(string) when is_binary(string) do
    string
    |> String.to_charlist()
    # Count occurrence of different characters in ID
    |> Enum.reduce(%{}, fn char, acc -> Map.update(acc, char, 1, &(&1 + 1)) end)
    # Count pairs and triples
    |> Enum.reduce({0, 0}, &pt_counts/2)
  end

  @doc "Reducer which counts if pair or triple occurred"
  def pt_counts(counts, accumulator \\ {0, 0})
  def pt_counts({_char, 2}, {_pairs, tripples}), do: {1, tripples}
  def pt_counts({_char, 3}, {pairs, _tripples}), do: {pairs, 1}
  def pt_counts(_counts, accumulator), do: accumulator

  @impl AdventOfCode
  def part2(input) do
    input
    # Convert to actual list and also every string ID to charlist
    |> Enum.map(&String.to_charlist/1)
    |> boxes()
  end

  @doc "Find similar ID for the first ID in the list. If not found call recursively"
  @spec boxes(list :: list(charlist())) :: String.t()
  def boxes([head | tail]) do
    Enum.find_value(tail, &similar(&1, head)) || boxes(tail)
  end

  @doc "Decide if two words are similar - different in just one char"
  @spec similar(word1 :: charlist(), word2 :: charlist()) :: String.t() | nil
  def similar(word1, word2) do
    word1
    |> Enum.zip(word2)
    |> Enum.split_with(fn {bit1, bit2} -> bit1 == bit2 end)
    |> case do
      # Different chars is list with one element
      {same, [_char] = _different} ->
        # Convert zipped charlists to string
        same
        |> Enum.map(fn {x, _} -> x end)
        |> List.to_string()

      # Everything else is invalid
      _value ->
        nil
    end
  end
end

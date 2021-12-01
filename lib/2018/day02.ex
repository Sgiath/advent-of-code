defmodule AdventOfCode.Year2018.Day02 do
  @moduledoc """
  Advent of Code - Box IDs - 2th December

  https://adventofcode.com/2018/day/2
  """
  use AdventOfCode, year: 2018, day: 02

  @doc """
  Late at night, you sneak to the warehouse - who knows what kinds of paradoxes you
  could cause if you were discovered - and use your fancy wrist device to quickly scan
  every box and produce a list of the likely candidates (your puzzle input).

  To make sure you didn't miss any, you scan the likely candidate boxes again, counting
  the number that have an ID containing exactly two of any letter and then separately
  counting those with exactly three of any letter. You can multiply those two counts
  together to get a rudimentary checksum and compare it to what your device predicts.

  For example, if you see the following box IDs:

    - abcdef contains no letters that appear exactly two or three times.
    - bababc contains two a and three b, so it counts for both.
    - abbcde contains two b, but no letter appears exactly three times.
    - abcccd contains three c, but no letter appears exactly two times.
    - aabcdd contains two a and two d, but it only counts once.
    - abcdee contains two e.
    - ababab contains three a and three b, but it only counts once.

  Of these box IDs, four of them contain a letter which appears exactly twice, and
  three of them contain a letter which appears exactly three times. Multiplying these
  together produces a checksum of 4 * 3 = 12.

  What is the checksum for your list of box IDs?
  """
  @impl AdventOfCode
  def part1 do
    # Compute number of words containing pairs and triples
    {pairs, triples} =
      Enum.reduce(input_lines(), {0, 0}, fn id, {pairs, triples} ->
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

  @doc """
  Confident that your list of box IDs is complete, you're ready to find the boxes full
  of prototype fabric.

  The boxes will have IDs which differ by exactly one character at the same position
  in both strings. For example, given the following box IDs:

    - abcde
    - fghij
    - klmno
    - pqrst
    - fguij
    - axcye
    - wvxyz

  The IDs abcde and axcye are close, but they differ by two characters (the second and
  fourth). However, the IDs fghij and fguij differ by exactly one character, the third
  (h and u). Those must be the correct boxes.

  What letters are common between the two correct box IDs? (In the example above, this
  is found by removing the differing character from either ID, producing fgij.)
  """
  @impl AdventOfCode
  def part2 do
    input_lines()
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
      _ ->
        nil
    end
  end
end

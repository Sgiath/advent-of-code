defmodule AdventOfCode.Year2021.Day18 do
  @moduledoc """
  https://adventofcode.com/2021/day/18

  Uses flat list representation: [[1,2],3] becomes [{1,2}, {2,2}, {3,1}]
  where each element is {value, depth}. This eliminates tree traversal.
  """
  use AdventOfCode, year: 2021, day: 18

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    """
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  # Parse a line directly into flat representation
  defp parse_line(line) do
    line
    |> String.to_charlist()
    |> parse_chars(0, [])
    |> Enum.reverse()
  end

  defp parse_chars([], _depth, acc), do: acc
  defp parse_chars([?[ | rest], depth, acc), do: parse_chars(rest, depth + 1, acc)
  defp parse_chars([?] | rest], depth, acc), do: parse_chars(rest, depth - 1, acc)
  defp parse_chars([?, | rest], depth, acc), do: parse_chars(rest, depth, acc)

  defp parse_chars([d | rest], depth, acc) when d >= ?0 and d <= ?9 do
    {num, remaining} = parse_number([d | rest], 0)
    parse_chars(remaining, depth, [{num, depth} | acc])
  end

  defp parse_number([d | rest], acc) when d >= ?0 and d <= ?9 do
    parse_number(rest, acc * 10 + (d - ?0))
  end

  defp parse_number(rest, acc), do: {acc, rest}

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.reduce(&add_and_reduce(&2, &1))
    |> magnitude()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    numbers = parse(input)

    for a <- numbers, b <- numbers, a !== b, reduce: 0 do
      max_mag -> max(max_mag, magnitude(add_and_reduce(a, b)))
    end
  end

  # ===============================================================================================
  # Core Operations
  # ===============================================================================================

  @doc """
  Add two numbers and reduce. Addition increases all depths by 1.
  """
  def add_and_reduce(a, b) do
    reduce(inc_depth(a) ++ inc_depth(b))
  end

  defp inc_depth(list), do: inc_depth(list, [])
  defp inc_depth([], acc), do: :lists.reverse(acc)
  defp inc_depth([{v, d} | rest], acc), do: inc_depth(rest, [{v, d + 1} | acc])

  @doc """
  Reduce: repeatedly explode (priority) then split until stable.
  """
  def reduce(number) do
    case explode(number) do
      {:exploded, new} ->
        reduce(new)

      :no_explode ->
        case split(number) do
          {:split, new} -> reduce(new)
          :no_split -> number
        end
    end
  end

  @doc """
  Find first pair at depth > 4 and explode it.
  """
  def explode(number), do: explode(number, [])

  defp explode([{v1, d}, {v2, d} | rest], acc) when d > 4 do
    # Found explosion - add v1 to left neighbor, v2 to right neighbor
    {:exploded, rev_prepend(add_right(acc, v1), [{0, d - 1} | add_left(rest, v2)])}
  end

  defp explode([elem | rest], acc), do: explode(rest, [elem | acc])
  defp explode([], _acc), do: :no_explode

  defp add_right([], _val), do: []
  defp add_right([{v, d} | rest], val), do: [{v + val, d} | rest]

  defp add_left([], _val), do: []
  defp add_left([{v, d} | rest], val), do: [{v + val, d} | rest]

  # Reverse first list and prepend to second (avoids Enum.reverse intermediate)
  defp rev_prepend([], acc), do: acc
  defp rev_prepend([h | t], acc), do: rev_prepend(t, [h | acc])

  @doc """
  Find first value >= 10 and split it.
  """
  def split(number), do: split(number, [])

  defp split([{v, d} | rest], acc) when v >= 10 do
    left = div(v, 2)
    {:split, rev_prepend(acc, [{left, d + 1}, {v - left, d + 1} | rest])}
  end

  defp split([elem | rest], acc), do: split(rest, [elem | acc])
  defp split([], _acc), do: :no_split

  @doc """
  Compute magnitude by repeatedly combining adjacent pairs at the same depth.
  Adjacent elements at the same depth are always siblings in the binary tree.
  """
  def magnitude([{v, _d}]), do: v
  def magnitude(number), do: number |> reduce_one_pair() |> magnitude()

  defp reduce_one_pair(number), do: reduce_one_pair(number, [])

  defp reduce_one_pair([{v1, d}, {v2, d} | rest], acc) do
    rev_prepend(acc, [{3 * v1 + 2 * v2, d - 1} | rest])
  end

  defp reduce_one_pair([elem | rest], acc), do: reduce_one_pair(rest, [elem | acc])
end

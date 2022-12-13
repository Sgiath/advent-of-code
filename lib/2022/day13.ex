defmodule AdventOfCode.Year2022.Day13 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/13
  """
  use AdventOfCode, year: 2022, day: 13

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> Code.eval_string()
    |> elem(0)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.map(&correct_order?/1)
    |> Enum.with_index(1)
    |> Enum.filter(fn {value, _index} -> value end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    sorted = Enum.sort([[[2]], [[6]] | parse(input)], &correct_order?/2)

    (Enum.find_index(sorted, &(&1 == [[2]])) + 1) * (Enum.find_index(sorted, &(&1 == [[6]])) + 1)
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def correct_order?({[], [_right | _rest]}), do: true
  def correct_order?({[_left | _rest], []}), do: false

  def correct_order?({[left | rest1], [right | rest2]}),
    do: correct_order?({left, right}, {rest1, rest2})

  def correct_order?([rest1 | rest]),
    do: correct_order?(rest1, rest)

  def correct_order?(left, right) when is_list(left) and is_list(right),
    do: correct_order?({left, right})

  # both are integers
  def correct_order?({left, right}, _rest)
      when is_integer(left) and is_integer(right) and left < right,
      do: true

  def correct_order?({left, right}, _rest)
      when is_integer(left) and is_integer(right) and left > right,
      do: false

  def correct_order?({left, right}, rest)
      when is_integer(left) and is_integer(right) and left == right,
      do: correct_order?(rest)

  # exactly one is integer
  def correct_order?({left, right}, rest) when is_list(left) and is_integer(right),
    do: correct_order?({left, [right]}, rest)

  def correct_order?({left, right}, rest) when is_integer(left) and is_list(right),
    do: correct_order?({[left], right}, rest)

  # both are lists
  def correct_order?({[], []}, rest), do: correct_order?(rest)
  def correct_order?({[], [_right | _rest1]}, _rest), do: true
  def correct_order?({[_left | _rest1], []}, _rest), do: false

  def correct_order?({[left | rest1], [right | rest2]}, rest) when is_tuple(rest),
    do: correct_order?({left, right}, [{rest1, rest2}, rest])

  def correct_order?({[left | rest1], [right | rest2]}, rest) when is_list(rest),
    do: correct_order?({left, right}, [{rest1, rest2} | rest])
end

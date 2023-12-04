defmodule AdventOfCode.Year2023.Day03 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/3
  """
  use AdventOfCode, year: 2023, day: 03

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """
  end

  def parse(input) do
    [first_row | _rest] =
      schema =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&String.to_charlist/1)

    # size of schema
    l_x = length(first_row)
    l_y = length(schema)

    numbers =
      schema
      |> find_with_index(&find_numbers/1)
      # calculate all neighbors for numbers
      |> Enum.map(&neighbors(&1, {l_x, l_y}))

    {numbers, schema}
  end

  def find_numbers(line, current \\ nil, final \\ [])

  def find_numbers({[], _y}, nil, final), do: Enum.reverse(final)
  def find_numbers({[], _y}, current, final), do: Enum.reverse([to_num(current) | final])

  def find_numbers({[{first, x} | rest], y}, nil, final) when first >= ?0 and first <= ?9 do
    find_numbers({rest, y}, {[first - ?0], x, y}, final)
  end

  def find_numbers({[{first, _x} | rest], y}, {current, x, y}, final)
      when first >= ?0 and first <= ?9 do
    find_numbers({rest, y}, {[first - ?0 | current], x, y}, final)
  end

  def find_numbers({[_first | rest], y}, nil, final), do: find_numbers({rest, y}, nil, final)

  def find_numbers({[_first | rest], y}, current, final),
    do: find_numbers({rest, y}, nil, [to_num(current) | final])

  # convert list of digits (reversed) to actual number and add length
  def to_num(values, i \\ 0, acc \\ 0)
  def to_num({[], x, y}, i, acc), do: {acc, x, y, i}

  def to_num({[v | rest], x, y}, i, acc),
    do: to_num({rest, x, y}, i + 1, acc + v * Integer.pow(10, i))

  # get all neighbors for a number
  def neighbors({value, x, y, l}, {l_x, l_y}) do
    # coordinates of the number (all digits)
    orig = Enum.map(x..(x + l - 1), fn x -> {x, y} end)

    n =
      orig
      |> Enum.map(&neigh/1)
      |> List.flatten()
      |> Enum.sort()
      |> Enum.dedup()
      # reject the coordinates of original numbers
      |> Enum.reject(&(&1 in orig))
      # reject all outside of schema
      |> Enum.reject(fn {x, y} -> x < 0 or y < 0 or x >= l_x or y >= l_y end)

    {value, n}
  end

  # get all 8 neighbors for a point
  def neigh({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {numbers, schema} = parse(input)

    numbers
    |> Enum.filter(&has_symbol?(&1, schema))
    |> Enum.map(fn {value, _neigh} -> value end)
    |> Enum.sum()
  end

  # does number has any other neighbor then '.'?
  def has_symbol?({_num, neigh}, schema) do
    neigh
    |> Enum.map(&get_value(&1, schema))
    |> Enum.any?(&(&1 != ?.))
  end

  def get_value({x, y}, schema) do
    schema
    |> Enum.at(y)
    |> Enum.at(x)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {numbers, schema} = parse(input)

    schema
    |> find_with_index(&find_gears/1)
    |> Enum.map(fn gear ->
      numbers
      |> Enum.filter(fn {_value, neigh} -> gear in neigh end)
      |> Enum.map(fn {value, _neigh} -> value end)
    end)
    |> Enum.reject(&(length(&1) != 2))
    |> Enum.map(&Enum.product/1)
    |> Enum.sum()
  end

  def find_gears(line, acc \\ [])
  def find_gears({[], _y}, acc), do: acc
  def find_gears({[{?*, x} | rest], y}, acc), do: find_gears({rest, y}, [{x, y} | acc])
  def find_gears({[_not_gear | rest], y}, acc), do: find_gears({rest, y}, acc)

  # =============================================================================================
  # Utils
  # =============================================================================================

  def find_with_index(schema, fun) when is_function(fun, 1) do
    schema
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      fun.({Enum.with_index(line), y})
    end)
    |> List.flatten()
  end
end

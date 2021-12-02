defmodule AdventOfCode.Year2021.Day02 do
  @moduledoc """
  https://adventofcode.com/2021/day/2
  """
  use AdventOfCode, year: 2021, day: 02

  @impl AdventOfCode
  def part1 do
    input_lines()
    |> Enum.reduce({0, 0}, &count_reducer/2)
    |> Tuple.product()
  end

  def count_reducer("forward " <> val, {h, d}), do: {h + String.to_integer(val), d}
  def count_reducer("down " <> val, {h, d}), do: {h, d + String.to_integer(val)}
  def count_reducer("up " <> val, {h, d}), do: {h, d - String.to_integer(val)}

  @impl AdventOfCode
  def part2 do
    input_lines()
    |> Enum.reduce({0, 0, 0}, &count_aim_reducer/2)
    |> Tuple.delete_at(2)
    |> Tuple.product()
  end

  def count_aim_reducer("forward " <> val, {h, d, a}),
    do: {h + String.to_integer(val), d + a * String.to_integer(val), a}

  def count_aim_reducer("down " <> val, {h, d, a}), do: {h, d, a + String.to_integer(val)}
  def count_aim_reducer("up " <> val, {h, d, a}), do: {h, d, a - String.to_integer(val)}
end

defmodule AdventOfCode.Year2022.Day09 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/9
  """
  use AdventOfCode, year: 2022, day: 09

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
    """
  end

  def parse(input) do
    input
    |> String.split(["\n", " "], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(fn
      ["R", num] -> {:r, String.to_integer(num)}
      ["L", num] -> {:l, String.to_integer(num)}
      ["U", num] -> {:u, String.to_integer(num)}
      ["D", num] -> {:d, String.to_integer(num)}
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.reduce({{{0, 0}, {0, 0}}, MapSet.new()}, &simulate/2)
    |> elem(1)
    |> MapSet.size()
    |> dbg()
  end

  def simulate({:r, num}, {positions, visited}) do
    Enum.reduce(1..num, {positions, visited}, fn _i, {pos, vis} ->
      {_head, tail} = new_pos = right_step(pos)
      {new_pos, MapSet.put(vis, tail)}
    end)
  end

  def simulate({:l, num}, {positions, visited}) do
    Enum.reduce(1..num, {positions, visited}, fn _i, {pos, vis} ->
      {_head, tail} = new_pos = left_step(pos)
      {new_pos, MapSet.put(vis, tail)}
    end)
  end

  def simulate({:u, num}, {positions, visited}) do
    Enum.reduce(1..num, {positions, visited}, fn _i, {pos, vis} ->
      {_head, tail} = new_pos = up_step(pos)
      {new_pos, MapSet.put(vis, tail)}
    end)
  end

  def simulate({:d, num}, {positions, visited}) do
    Enum.reduce(1..num, {positions, visited}, fn _i, {pos, vis} ->
      {_head, tail} = new_pos = down_step(pos)
      {new_pos, MapSet.put(vis, tail)}
    end)
  end

  def right_step({{xh, yh}, {xt, yt}}) when xh > xt and yh > yt,
    do: {{xh + 1, yh}, {xt + 1, yt + 1}}

  def right_step({{xh, yh}, {xt, yt}}) when xh > xt and yh < yt,
    do: {{xh + 1, yh}, {xt + 1, yt - 1}}

  def right_step({{xh, yh}, {xt, yt}}) when xh > xt, do: {{xh + 1, yh}, {xt + 1, yt}}
  def right_step({{xh, yh}, {xt, yt}}), do: {{xh + 1, yh}, {xt, yt}}

  def left_step({{xh, yh}, {xt, yt}}) when xh < xt and yh > yt,
    do: {{xh - 1, yh}, {xt - 1, yt + 1}}

  def left_step({{xh, yh}, {xt, yt}}) when xh < xt and yh < yt,
    do: {{xh - 1, yh}, {xt - 1, yt - 1}}

  def left_step({{xh, yh}, {xt, yt}}) when xh < xt, do: {{xh - 1, yh}, {xt - 1, yt}}
  def left_step({{xh, yh}, {xt, yt}}), do: {{xh - 1, yh}, {xt, yt}}

  def up_step({{xh, yh}, {xt, yt}}) when xh > xt and yh > yt,
    do: {{xh, yh + 1}, {xt + 1, yt + 1}}

  def up_step({{xh, yh}, {xt, yt}}) when xh < xt and yh > yt,
    do: {{xh, yh + 1}, {xt - 1, yt + 1}}

  def up_step({{xh, yh}, {xt, yt}}) when xh > xt, do: {{xh, yh + 1}, {xt, yt + 1}}
  def up_step({{xh, yh}, {xt, yt}}), do: {{xh, yh + 1}, {xt, yt}}

  def down_step({{xh, yh}, {xt, yt}}) when xh > xt and yh < yt,
    do: {{xh, yh - 1}, {xt + 1, yt - 1}}

  def down_step({{xh, yh}, {xt, yt}}) when xh < xt and yh < yt,
    do: {{xh, yh - 1}, {xt - 1, yt - 1}}

  def down_step({{xh, yh}, {xt, yt}}) when xh < xt, do: {{xh, yh - 1}, {xt, yt - 1}}
  def down_step({{xh, yh}, {xt, yt}}), do: {{xh, yh - 1}, {xt, yt}}

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> dbg()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================
end

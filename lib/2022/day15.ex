defmodule AdventOfCode.Year2022.Day15 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/15
  """
  use AdventOfCode, year: 2022, day: 15

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line("Sensor at x=" <> line) do
    %{"xb" => xb, "xs" => xs, "yb" => yb, "ys" => ys} =
      Regex.named_captures(
        ~r/(?<xs>-?\d+), y=(?<ys>-?\d+): closest beacon is at x=(?<xb>-?\d+), y=(?<yb>-?\d+)/,
        line
      )

    {{String.to_integer(xs), String.to_integer(ys)},
     {String.to_integer(xb), String.to_integer(yb)}}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================
  defguard md(x1, y1, x2, y2, d) when abs(x1 - x2) + abs(y1 - y2) <= d

  @impl AdventOfCode
  def part1(input, row \\ 2_000_000) do
    sensors = parse(input)

    sensors
    |> Enum.reduce([], fn {{xs, ys}, {xb, yb}}, map ->
      d = distance({xs, ys}, {xb, yb})

      if row in (ys - d)..(ys + d) do
        [{xs - d + abs(ys - row), xs + d - abs(ys - row)} | map]
      else
        map
      end
    end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.reduce([], fn
      x, [] -> [x]
      {x1, x2}, [{f1, f2} | acc] when x1 <= f2 and x2 >= f2 -> [{f1, x2} | acc]
      {x1, x2}, [{f1, f2} | acc] when x1 <= f2 and x2 <= f2 -> [{f1, f2} | acc]
      x, acc -> [x | acc]
    end)
    |> Enum.map(fn {x1, x2} -> x2 - x1 end)
    |> Enum.sum()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input, limit \\ 20) do
    sensors = parse(input)

    for row <- 0..limit do
      sensors
      |> Enum.reduce([], fn {{xs, ys}, {xb, yb}}, map ->
        d = distance({xs, ys}, {xb, yb})

        if row in (ys - d)..(ys + d) do
          [{max(xs - d + abs(ys - row), 0), min(xs + d - abs(ys - row), limit)} | map]
        else
          map
        end
      end)
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.reduce([], fn
        x, [] -> [x]
        {x1, x2}, [{f1, f2} | acc] when x1 <= f2 and x2 >= f2 -> [{f1, x2} | acc]
        {x1, x2}, [{f1, f2} | acc] when x1 <= f2 and x2 <= f2 -> [{f1, f2} | acc]
        x, acc -> [x | acc]
      end)
    end
    |> Enum.with_index()
    |> Enum.reject(&(elem(&1, 0) == [{0, limit}]))
    |> Enum.map(fn {[{x1, _x2}, {_x3, _x4}], y} -> {x1 - 1, y} end)
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)
end

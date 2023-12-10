defmodule AdventOfCode.Year2023.Day05 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/5
  """
  use AdventOfCode, year: 2023, day: 05

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """
  end

  def parse(input) do
    [seeds, soil, fert, water, light, temp, hum, loc] = String.split(input, ["\n\n"], trim: true)

    {parse_seeds(seeds),
     [
       parse_map(soil),
       parse_map(fert),
       parse_map(water),
       parse_map(light),
       parse_map(temp),
       parse_map(hum),
       parse_map(loc)
     ]}
  end

  def parse_seeds("seeds: " <> seeds) do
    seeds
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_map(data) do
    [_head | ranges] = String.split(data, "\n", trim: true)

    ranges
    |> Enum.map(fn range ->
      [d, s, l] =
        range
        |> String.split(" ", trim: true)
        |> Enum.map(fn value -> String.to_integer(value) end)

      {s..(s + l - 1), d - s}
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {seeds, steps} = parse(input)

    steps
    |> Enum.reduce(seeds, fn maps, seeds ->
      Enum.map(seeds, fn seed ->
        seed + Enum.find_value(maps, 0, fn {r, o} -> if seed in r, do: o end)
      end)
    end)
    |> Enum.min()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {seeds, steps} = parse(input)
    seeds = to_ranges(seeds)

    steps
    |> Enum.reduce(seeds, fn _maps, seeds ->
      Enum.map(seeds, fn seed ->
        # TODO
        seed
      end)
    end)
    |> dbg()
  end

  def to_ranges(seeds, acc \\ [])
  def to_ranges([], acc), do: acc

  def to_ranges([start, len | rest], acc) do
    to_ranges(rest, [start..(start + len - 1) | acc])
  end

  # =============================================================================================
  # Utils
  # =============================================================================================
end

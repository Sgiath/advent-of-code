defmodule AdventOfCode.Year2022.Day16 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/16
  """
  use AdventOfCode, year: 2022, day: 16

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    Valve BB has flow rate=13; tunnels lead to valves CC, AA
    Valve CC has flow rate=2; tunnels lead to valves DD, BB
    Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
    Valve EE has flow rate=3; tunnels lead to valves FF, DD
    Valve FF has flow rate=0; tunnels lead to valves EE, GG
    Valve GG has flow rate=0; tunnels lead to valves FF, HH
    Valve HH has flow rate=22; tunnel leads to valve GG
    Valve II has flow rate=0; tunnels lead to valves AA, JJ
    Valve JJ has flow rate=21; tunnel leads to valve II
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&parse_valve/1)
    |> Enum.into(%{})
  end

  def parse_valve(valve) do
    %{"l" => l, "r" => r, "v" => v} =
      Regex.named_captures(
        ~r/Valve (?<v>[A-Z]+) has flow rate=(?<r>\d+); tunnels? leads? to valves? (?<l>.*)/,
        valve
      )

    {v, %{r: String.to_integer(r), n: String.split(l, ", ", trim: true)}}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> traverse()
    |> dbg()
  end

  def traverse(map, valve \\ "AA", time \\ 30, ppm \\ 0, pressure \\ 0)
  def traverse(_map, _valve, time, _ppm, pressure) when time <= 0, do: pressure

  def traverse(map, valve, time, ppm, pressure) do
    if Enum.all?(map, fn {_name, %{r: r}} -> r == 0 end) do
      pressure + ppm * time
    else
      %{n: ns, r: r} = map[valve]

      for n <- ns do
        if r == 0 do
          traverse(map, n, time - 1, ppm, pressure + ppm)
        else
          traverse(put_in(map, [valve, :r], 0), n, time - 2, ppm + r, pressure + ppm)
        end
      end
    end
  end

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

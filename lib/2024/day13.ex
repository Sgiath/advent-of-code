defmodule AdventOfCode.Year2024.Day13 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/13
  """
  use AdventOfCode, year: 2024, day: 13

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400

    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176

    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450

    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """
  end

  def parse(input) do
    input
    |> String.split(["\n\n"], trim: true)
    |> Enum.map(fn machine ->
      ["Button A: " <> button_a, "Button B: " <> button_b, "Prize: " <> prize] =
        String.split(machine, ["\n"], trim: true)

      {ax, ay} = parse_data(button_a)
      {bx, by} = parse_data(button_b)
      {px, py} = parse_data(prize)

      # {Nx.tensor([[ax, bx], [ay, by]]), Nx.tensor([[tx], [ty]])}
      {{ax, ay}, {bx, by}, {px, py}}
    end)
  end

  def parse_data(button) do
    ["X", x, "Y", y] = String.split(button, ["+", "=", ", "])
    {String.to_integer(x), String.to_integer(y)}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&cramer/1)
    |> cost()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    adj = 10_000_000_000_000

    input
    |> parse()
    |> Enum.map(fn {a, b, {px, py}} -> {a, b, {adj + px, adj + py}} end)
    |> Enum.map(&cramer/1)
    |> cost()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  # calculate solution using cramer's method
  def cramer({{ax, ay}, {bx, by}, {px, py}}) do
    a = (px * by - py * bx) / (ax * by - ay * bx)
    b = (ax * py - ay * px) / (ax * by - ay * bx)

    {a, b}
  end

  # calculate cost for solutions
  def cost([]), do: 0

  def cost([{a, b} | rest]) when floor(a) == a and floor(b) == b do
    floor(a) * 3 + floor(b) + cost(rest)
  end

  def cost([_first | rest]), do: cost(rest)
end

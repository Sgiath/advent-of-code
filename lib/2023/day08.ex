defmodule AdventOfCode.Year2023.Day08 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/8
  """
  use AdventOfCode, year: 2023, day: 08

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input, do: test_input3()

  def test_input1 do
    """
    RL

    AAA = (BBB, CCC)
    BBB = (DDD, EEE)
    CCC = (ZZZ, GGG)
    DDD = (DDD, DDD)
    EEE = (EEE, EEE)
    GGG = (GGG, GGG)
    ZZZ = (ZZZ, ZZZ)
    """
  end

  def test_input2 do
    """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """
  end

  def test_input3 do
    """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """
  end

  def parse(input) do
    [instructions | network] = String.split(input, ["\n"], trim: true)

    {String.to_charlist(instructions), parse_network(network)}
  end

  def parse_network(network) do
    Enum.map(network, fn
      <<id::binary-size(3), " = (", <<left::binary-size(3)>>, ", ", <<right::binary-size(3)>>,
        ")">> ->
        {id, [left, right]}
    end)
    |> Enum.into(%{})
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {instructions, network} = parse(input)

    instructions
    |> Stream.cycle()
    |> Enum.reduce_while({0, "AAA"}, fn
      ?L, {steps, current} ->
        [left, _right] = network[current]
        if left == "ZZZ", do: {:halt, steps + 1}, else: {:cont, {steps + 1, left}}

      ?R, {steps, current} ->
        [_left, right] = network[current]
        if right == "ZZZ", do: {:halt, steps + 1}, else: {:cont, {steps + 1, right}}
    end)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {instructions, network} = parse(input)

    # Find all starting nodes (those ending with 'A')
    starts =
      network
      |> Map.keys()
      |> Enum.filter(&String.ends_with?(&1, "A"))

    # For each starting node, find the cycle length (steps to reach a 'Z' node)
    # Then compute the LCM of all cycle lengths
    starts
    |> Enum.map(&find_cycle_length(&1, instructions, network))
    |> Enum.reduce(&lcm/2)
  end

  # Find how many steps it takes from a starting node to reach any node ending with 'Z'
  defp find_cycle_length(start, instructions, network) do
    instructions
    |> Stream.cycle()
    |> Enum.reduce_while({0, start}, fn direction, {steps, current} ->
      next =
        case direction do
          ?L -> hd(network[current])
          ?R -> hd(tl(network[current]))
        end

      if String.ends_with?(next, "Z") do
        {:halt, steps + 1}
      else
        {:cont, {steps + 1, next}}
      end
    end)
  end

  # Greatest Common Divisor using Euclidean algorithm
  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))

  # Least Common Multiple
  defp lcm(a, b), do: div(a * b, gcd(a, b))

  # =============================================================================================
  # Utils
  # =============================================================================================
end

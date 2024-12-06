defmodule AdventOfCode.Year2024.Day05 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/5
  """
  use AdventOfCode, year: 2024, day: 05

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """
  end

  def parse(input) do
    [rules, updates] = String.split(input, ["\n\n"], trim: true)

    {parse_rules(rules), parse_updates(updates)}
  end

  defp parse_rules(data) do
    data
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn pages ->
      [a, b] = String.split(pages, ["|"], trim: true)
      {String.to_integer(a), String.to_integer(b)}
    end)
  end

  defp parse_updates(data) do
    data
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn update ->
      update
      |> String.split([","], trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {rules, updates} = parse(input)

    updates
    |> Enum.filter(&is_correct(&1, rules))
    |> control_number()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {rules, updates} = parse(input)

    updates
    |> Enum.reject(&is_correct(&1, rules))
    # this kind of sort assumes that there is rule for every page combination
    # but it seems to work and is really simple
    |> Enum.map(&Enum.sort(&1, fn a, b -> {a, b} in rules end))
    |> control_number()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  # this checker assumes there is rule for every combination of pages
  def is_correct([a, b], rules), do: {a, b} in rules

  def is_correct([a, b | update], rules) do
    if {a, b} in rules do
      is_correct([b | update], rules)
    else
      false
    end
  end

  def control_number(updates) do
    updates
    |> Enum.map(&Enum.at(&1, Integer.floor_div(length(&1), 2)))
    |> Enum.sum()
  end
end

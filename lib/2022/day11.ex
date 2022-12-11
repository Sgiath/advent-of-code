defmodule AdventOfCode.Year2022.Day11 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/11
  """
  use AdventOfCode, year: 2022, day: 11

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
    """
  end

  def parse(input) do
    input
    |> String.split(["\n\n"], trim: true)
    |> Enum.map(&parse_monkey/1)
  end

  def parse_monkey(monkey) do
    ["Monkey " <> i, "  Starting items: " <> items, "  Operation: " <> operation | test] =
      String.split(monkey, "\n", trim: true)

    {items, _bindings} = Code.eval_string("[#{items}]")

    %{
      i: String.to_integer(String.trim_trailing(i, ":")),
      items: items,
      operation: parse_operation(operation),
      test: parse_test(test),
      processed: 0
    }
  end

  def parse_operation(operation) do
    Code.string_to_quoted!(operation)
  end

  def parse_test([
        "  Test: divisible by " <> divisor,
        "    If true: throw to monkey " <> if_true,
        "    If false: throw to monkey " <> if_false
      ]) do
    {String.to_integer(divisor), String.to_integer(if_true), String.to_integer(if_false)}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    monkeys = parse(input)
    l = length(monkeys)

    1..20
    |> Enum.reduce(monkeys, fn _i, monkeys -> step(monkeys, &div(&1, 3), l) end)
    |> Enum.map(&Map.get(&1, :processed))
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    monkeys = parse(input)
    l = length(monkeys)

    lcm =
      monkeys
      |> Enum.map(fn %{test: {x, _t, _f}} -> x end)
      |> Enum.product()

    1..10_000
    |> Enum.reduce(monkeys, fn _i, monkeys -> step(monkeys, &rem(&1, lcm), l) end)
    |> Enum.map(&Map.get(&1, :processed))
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def step(monkeys, mod, len, i \\ 0)

  def step(monkeys, mod, len, i) when i < len do
    %{items: items, operation: operation, test: {d, t, f}} = Enum.at(monkeys, i)

    items
    |> Enum.reduce(monkeys, fn worry, monkeys ->
      x = operation |> Code.eval_quoted(old: worry) |> elem(0) |> mod.()
      i_t = if rem(x, d) == 0, do: t, else: f

      update_in(monkeys, [Access.at(i_t), :items], fn items ->
        Enum.reverse([x | Enum.reverse(items)])
      end)
    end)
    |> put_in([Access.at(i), :items], [])
    |> update_in([Access.at(i), :processed], fn x -> x + length(items) end)
    |> step(mod, len, i + 1)
  end

  def step(monkeys, _mod, _len, _i), do: monkeys
end

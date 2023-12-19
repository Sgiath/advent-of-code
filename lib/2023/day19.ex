defmodule AdventOfCode.Year2023.Day19 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/19
  """
  use AdventOfCode, year: 2023, day: 19

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}

    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}
    """
  end

  def parse(input) do
    [workflows, ratings] = String.split(input, ["\n\n"], trim: true)

    {
      workflows
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_workflow/1)
      |> Enum.into(%{}),
      ratings |> String.split("\n", trim: true) |> Enum.map(&parse_ratings/1)
    }
  end

  def parse_workflow(workflow) do
    [name | rules] = String.split(workflow, ["{", "}", ","], trim: true)
    {name, Enum.map(rules, &parse_rule/1)}
  end

  def parse_rule("R"), do: :reject
  def parse_rule("A"), do: :accept

  def parse_rule(rule) do
    case String.split(rule, ":", trim: true) do
      [name] ->
        {:goto, name}

      [<<key::binary-size(1), ">", val::binary>>, dest] ->
        {String.to_existing_atom(key), :greater, String.to_integer(val), parse_rule(dest)}

      [<<key::binary-size(1), "<", val::binary>>, dest] ->
        {String.to_existing_atom(key), :lower, String.to_integer(val), parse_rule(dest)}
    end
  end

  def parse_ratings(part) do
    [x, m, a, s] = String.split(part, ["{", "x=", ",m=", ",a=", ",s=", "}"], trim: true)

    %{
      x: String.to_integer(x),
      m: String.to_integer(m),
      a: String.to_integer(a),
      s: String.to_integer(s)
    }
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {rules, parts} = parse(input)

    parts
    |> Enum.map(&process_rules(&1, rules))
    |> Enum.sum()
  end

  def process_rules(part, rules, workflow \\ {:goto, "in"})
  def process_rules(part, _rules, :accept), do: part.x + part.m + part.a + part.s
  def process_rules(_part, _rules, :reject), do: 0

  def process_rules(part, rules, {:goto, dest}) do
    dest =
      rules
      |> Map.get(dest)
      |> Enum.reduce_while(nil, fn
        {key, :lower, val, dest}, nil ->
          if part[key] < val, do: {:halt, dest}, else: {:cont, nil}

        {key, :greater, val, dest}, nil ->
          if part[key] > val, do: {:halt, dest}, else: {:cont, nil}

        dest, nil ->
          {:halt, dest}
      end)

    process_rules(part, rules, dest)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {rules, _parts} = parse(input)

    # TODO: squash the ranges
    rules
  end
end

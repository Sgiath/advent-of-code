defmodule AdventOfCode.Year2021.Day14 do
  @moduledoc """
  https://adventofcode.com/2021/day/14
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day14.in"])
    |> File.read!()
  end

  def parse(input) do
    [template | pairs] = String.split(input, "\n", trim: true)

    pairs = Enum.into(pairs, %{}, fn <<a::8, b::8, " -> ", c::8>> -> {[a, b], c} end)

    {String.to_charlist(template), pairs}
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {template, pairs} = parse(input)

    1..10
    |> Enum.reduce(template, fn _i, template -> step_naive(template, pairs) end)
    |> Enum.frequencies()
    |> Enum.map(&elem(&1, 1))
    |> Enum.min_max()
    |> then(&(elem(&1, 1) - elem(&1, 0)))
  end

  @doc """
  Run the step on the whole template
  """
  def step_naive(template, pairs, result \\ [])

  def step_naive([a, b | template], pairs, result) do
    pairs
    |> Enum.reduce_while(result, fn
      {[^a, ^b], c}, result -> {:halt, [c, a | result]}
      _pair, result -> {:cont, result}
    end)
    |> then(&step_naive([b | template], pairs, &1))
  end

  def step_naive([a], _pairs, result), do: Enum.reverse([a | result])

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {template, pairs} = parse(input)

    # get frequencies for initial template
    freq =
      template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()

    1..40
    # update frequencies with step function 40 times
    |> Enum.reduce(freq, fn _i, freq -> step(freq, pairs) end)
    # get values for individual letters
    |> Enum.reduce(%{}, fn {[a, b], value}, acc ->
      acc
      |> Map.update(a, value, &(&1 + value))
      |> Map.update(b, value, &(&1 + value))
    end)
    # divide the values by 2 (because every letter is included in two pairs)
    |> Enum.map(fn {_letter, value} -> ceil(value / 2) end)
    |> Enum.min_max()
    |> then(&(elem(&1, 1) - elem(&1, 0)))
  end

  @doc """
  Run the step on the pair frequencies

  Go over all pair frequencies in the template and construct new pair frequencies with the middle
  letter
  """
  def step(freq, pairs) do
    Enum.reduce(freq, %{}, fn {[a, b] = key, value}, acc ->
      middle = pairs[key]

      acc
      |> Map.update([a, middle], value, &(&1 + value))
      |> Map.update([middle, b], value, &(&1 + value))
    end)
  end
end

defmodule AdventOfCode.Year2021.Day14 do
  @moduledoc """
  https://adventofcode.com/2021/day/14
  """
  use AdventOfCode, year: 2021, day: 14

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

  def parse(input) do
    [template | pairs] = String.split(input, "\n", trim: true)

    pairs = Enum.into(pairs, %{}, fn <<a::8, b::8, " -> ", c::8>> -> {[a, b], c} end)

    {String.to_charlist(template), pairs}
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input), do: naive(input)

  @doc """
  Naive solution with specified number of steps
  """
  def naive(input, steps \\ 10) do
    {template, pairs} = parse(input)

    1..steps
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
  def part2(input), do: optimized(input)

  @doc """
  Optimized solution with specified number of steps
  """
  def optimized(input, steps \\ 40) do
    {template, pairs} = parse(input)

    # get frequencies for initial template
    freq =
      template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()

    1..steps
    # update frequencies with step function 40 times
    |> Enum.reduce(freq, fn _i, freq -> step(freq, pairs) end)
    # get values for individual letters (count only the second one)
    |> Enum.reduce(%{}, fn {[_a, b], value}, acc -> Map.update(acc, b, value, &(&1 + value)) end)
    # get just values (we no longer care about associated letters)
    |> Enum.map(&elem(&1, 1))
    # get min and max values
    |> Enum.min_max()
    # compute final result
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

  # ===============================================================================================
  # Benchmark
  # ===============================================================================================

  def bench do
    %{
      "naive 10": &naive/1,
      "optimized 10": &optimized(&1, 10),
      "optimized 40": &optimized/1
    }
  end
end

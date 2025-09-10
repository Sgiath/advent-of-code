defmodule AdventOfCode.Year2021.Day17 do
  @moduledoc """
  https://adventofcode.com/2021/day/17
  """
  use AdventOfCode, year: 2021, day: 17

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    target area: x=20..30, y=-10..-5
    """
  end

  def parse(input) do
    ~r/target area: x=(?<x_min>\d+)..(?<x_max>\d+), y=(?<y_min>-?\d+)..(?<y_max>-?\d+)/
    |> Regex.named_captures(String.trim_trailing(input, "\n"))
    |> then(fn %{"x_min" => x_min, "x_max" => x_max, "y_min" => y_min, "y_max" => y_max} ->
      {
        {String.to_integer(x_min), String.to_integer(x_max)},
        {String.to_integer(y_min), String.to_integer(y_max)}
      }
    end)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> max_height()
  end

  def max_height({_x_range, {y_min, _y_max}}) do
    y_min
    |> abs()
    |> then(&(&1 * (&1 - 1)))
    |> div(2)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> search_space()
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Search whole space of possible solutions
  """
  def search_space({{_x_min, x_max}, {y_min, _y_max}} = target) do
    for x <- range(floor(:math.sqrt(x_max)), x_max), y <- range(-y_min, y_min), reduce: 0 do
      count -> count + hit_or_miss(target, {x, y})
    end
  end

  @doc """
  Calculate max height for the initial velocity
  """
  def hit_or_miss(target, velocity, path \\ {0, 0})

  # too low or too far right - we missed the target
  def hit_or_miss({{_x_min, x_max}, {y_min, _y_max}}, _velocity, {x, y})
      when x > x_max or y < y_min,
      do: 0

  # we are on target
  def hit_or_miss({{x_min, x_max}, {y_min, y_max}}, _velocity, {x, y})
      when x >= x_min and x <= x_max and y >= y_min and y <= y_max,
      do: 1

  # next position
  def hit_or_miss(target, {x_v, y_v}, {x, y}) do
    hit_or_miss(target, {max(0, x_v - 1), y_v - 1}, {x + x_v, y + y_v})
  end

  # ===============================================================================================
  # Other solutions
  # ===============================================================================================

  def search_space_flow({{_x_min, x_max}, {y_min, _y_max}} = target) do
    for x <- range(floor(:math.sqrt(x_max)), x_max), y <- range(-y_min, y_min) do
      {x, y}
    end
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.reduce(fn -> 0 end, &(hit_or_miss(target, &1) + &2))
    |> Flow.departition(fn -> 0 end, &Kernel.+/2, & &1)
    |> Enum.to_list()
    |> List.first()
  end

  def search_space_task({{_x_min, x_max}, {y_min, _y_max}} = target) do
    for x <- range(floor(:math.sqrt(x_max)), x_max) do
      Task.async(fn ->
        for y <- range(-y_min, y_min), reduce: 0 do
          count -> count + hit_or_miss(target, {x, y})
        end
      end)
    end
    |> Task.await_many()
    |> Enum.sum()
  end

  # ===============================================================================================
  # Benchmark
  # ===============================================================================================

  def bench do
    %{
      sequential: &(&1 |> parse() |> search_space()),
      flow: &(&1 |> parse() |> search_space_flow()),
      parallel: &(&1 |> parse() |> search_space_task())
    }
  end
end

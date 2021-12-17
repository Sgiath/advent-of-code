defmodule AdventOfCode.Year2021.Day17 do
  @moduledoc """
  https://adventofcode.com/2021/day/17
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    target area: x=20..30, y=-10..-5
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day17.in"])
    |> File.read!()
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
    |> search_space()
    |> Enum.reject(&(&1 == :miss))
    |> Enum.max()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> search_space()
    |> Enum.count(&(&1 != :miss))
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Search whole space of possible solutions
  """
  def search_space({{_x_min, x_max}, {y_min, _y_max}} = target) do
    for x <- 1..x_max, y <- -y_min..y_min do
      calculate_height(target, {x, y})
    end
  end

  @doc """
  Calculate max height for the initial velocity
  """
  def calculate_height(target, velocity, path \\ {0, 0}, height \\ 0)

  # too low or too far right - we missed the target
  def calculate_height({{_x_min, x_max}, {y_min, _y_max}}, _velocity, {x, y}, _height)
      when x > x_max or y < y_min,
      do: :miss

  # we are on target
  def calculate_height({{x_min, x_max}, {y_min, y_max}}, _velocity, {x, y}, height)
      when x >= x_min and x <= x_max and y >= y_min and y <= y_max do
    height
  end

  # next position
  def calculate_height(target, {x_v, y_v}, {x, y}, height) do
    calculate_height(target, {max(0, x_v - 1), y_v - 1}, {x + x_v, y + y_v}, max(height, y + y_v))
  end
end

defmodule AdventOfCode.Year2023.Day02 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/2
  """
  use AdventOfCode, year: 2023, day: 02

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn game ->
      ["Game " <> id, sets] = String.split(game, ": ", trim: true)

      {String.to_integer(id), sets |> String.split("; ") |> Enum.map(&parse_set/1)}
    end)
  end

  def parse_set(set) do
    parsed =
      set
      |> String.split(", ", trim: true)
      |> Enum.map(fn color ->
        [val, col] = String.split(color, " ", trim: true)
        {col, String.to_integer(val)}
      end)
      |> Enum.into(%{})

    {Map.get(parsed, "red", 0), Map.get(parsed, "green", 0), Map.get(parsed, "blue", 0)}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.filter(&game_valid?/1)
    |> Enum.map(fn {id, _sets} -> id end)
    |> Enum.sum()
  end

  def game_valid?({_id, []}), do: true

  def game_valid?({id, [{r, g, b} | sets]}) when r <= 12 and g <= 13 and b <= 14 do
    game_valid?({id, sets})
  end

  def game_valid?(_otherwise), do: false

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.map(&min_set(&1, {0, 0, 0}))
    |> Enum.sum()
  end

  def min_set({_id, []}, {r, g, b}), do: r * g * b
  def min_set({id, [{r, g, b} | sets]}, {r_fin, g_fin, b_fin}) do
    min_set({id, sets}, {max(r, r_fin), max(g, g_fin), max(b, b_fin)})
  end
end

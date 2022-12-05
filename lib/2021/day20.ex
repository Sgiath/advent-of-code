defmodule AdventOfCode.Year2021.Day20 do
  @moduledoc """
  https://adventofcode.com/2021/day/20
  """
  use AdventOfCode

  import Bitwise

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

    #..#.
    #....
    ##..#
    ..#..
    ..###
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day20.in"])
    |> File.read!()
  end

  def parse(input) do
    [enhancement | image] =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(fn line ->
        line
        |> String.to_charlist()
        |> Enum.map(fn
          35 -> 1
          46 -> 0
        end)
      end)

    image =
      for {line, i} <- Enum.with_index(image), {val, j} <- Enum.with_index(line), into: %{} do
        {{i, j}, val}
      end

    {enhancement, image}
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {[first | _rest] = alg, image} = parse(input)

    image
    |> enhance(alg, 0)
    |> enhance(alg, first)
    |> Enum.count(fn {_point, val} -> val == 1 end)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {[first | _rest] = alg, image} = parse(input)

    1..50
    |> Enum.reduce(image, fn i, image ->
      enhance(image, alg, if(rem(i, 2) == 0, do: first, else: 0))
    end)
    |> Enum.count(fn {_point, val} -> val == 1 end)
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Run enhancement algorithm on the image one time
  """
  def enhance(image, alg, default) do
    image
    |> add_points(default)
    |> Enum.reduce(%{}, fn {point, _val}, acc ->
      Map.put(acc, point, Enum.at(alg, index(image, point, default)))
    end)
  end

  @doc """
  Add explicit points around the known image
  """
  def add_points(image, default) do
    {{min_x, min_y}, {max_x, max_y}} = boundaries(image)

    image =
      Enum.reduce((min_x - 1)..(max_x + 1), image, fn x, image ->
        image
        |> Map.put({x, min_y - 1}, default)
        |> Map.put({x, max_y + 1}, default)
      end)

    Enum.reduce((min_y - 1)..(max_y + 1), image, fn y, image ->
      image
      |> Map.put({min_x - 1, y}, default)
      |> Map.put({max_x + 1, y}, default)
    end)
  end

  @doc """
  Get boundaries of known image
  """
  def boundaries(image) do
    {{{min_x, _y1}, _val1}, {{max_x, _y2}, _val2}} =
      Enum.min_max_by(image, fn {{x, _y}, _val} -> x end)

    {{{_x1, min_y}, _val1}, {{_x2, max_y}, _val2}} =
      Enum.min_max_by(image, fn {{_x, y}, _val} -> y end)

    {{min_x, min_y}, {max_x, max_y}}
  end

  @doc """
  Return index of new value in enhancment data
  """
  def index(image, {x, y}, default) do
    (get(image, {x - 1, y - 1}, default) <<< 8) +
      (get(image, {x - 1, y}, default) <<< 7) +
      (get(image, {x - 1, y + 1}, default) <<< 6) +
      (get(image, {x, y - 1}, default) <<< 5) +
      (get(image, {x, y}, default) <<< 4) +
      (get(image, {x, y + 1}, default) <<< 3) +
      (get(image, {x + 1, y - 1}, default) <<< 2) +
      (get(image, {x + 1, y}, default) <<< 1) +
      get(image, {x + 1, y + 1}, default)
  end

  @doc """
  Get value on position in image
  """
  def get(image, pos, default), do: Map.get(image, pos, default)
end

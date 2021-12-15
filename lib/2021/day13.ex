defmodule AdventOfCode.Year2021.Day13 do
  @moduledoc """
  https://adventofcode.com/2021/day/13
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day13.in"])
    |> File.read!()
  end

  def parse_dots(dots) do
    dots
    |> String.split(["\n", ","], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.into(MapSet.new(), &List.to_tuple/1)
  end

  def parse_folds(folds) do
    folds
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      <<"fold along ", line::8, "=", coord::binary>> ->
        {line, String.to_integer(coord)}
    end)
  end

  def parse(input) do
    [dots, folds] = String.split(input, ["\n\n"], trim: true)

    {parse_dots(dots), parse_folds(folds)}
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {dots, [fold | _folds]} = parse(input)

    fold
    |> fold_paper(dots)
    |> MapSet.size()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {dots, folds} = parse(input)

    folds
    |> Enum.reduce(dots, &fold_paper/2)
    |> construct_image()
  end

  @doc """
  Receives list of points and constructs two-dimensional list of characters which are then joined
  to strings so they can be printed into console

  Uses "█" (<<9_608::utf8>>) for full square and " " (space) for blank square
  """
  def construct_image(dots) do
    # get image dimensions
    {max_x, max_y} =
      Enum.reduce(dots, {0, 0}, fn {x, y}, {m_x, m_y} -> {max(x, m_x), max(y, m_y)} end)

    for y <- 0..max_y do
      for x <- 0..max_x do
        if MapSet.member?(dots, {x, y}), do: '██', else: '  '
      end
    end
    |> Enum.intersperse("\n")
    |> IO.chardata_to_string()
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Folds the dots along the line
  """
  def fold_paper({?x, line}, dots) do
    Enum.reduce(dots, MapSet.new(), fn
      {x, y}, acc when x > line -> MapSet.put(acc, {line - (x - line), y})
      point, acc -> MapSet.put(acc, point)
    end)
  end

  def fold_paper({?y, line}, dots) do
    Enum.reduce(dots, MapSet.new(), fn
      {x, y}, acc when y > line -> MapSet.put(acc, {x, line - (y - line)})
      point, acc -> MapSet.put(acc, point)
    end)
  end
end

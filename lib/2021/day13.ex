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
    |> Enum.map(&List.to_tuple/1)
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

    dots
    |> fold_paper(fold)
    |> Enum.count()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {dots, folds} = parse(input)

    folds
    |> Enum.reduce(dots, &fold_paper(&2, &1))
    |> construct_image()
  end

  @doc """
  Receives list of points and constructs two-dimensional list of characters which are then joined
  to strings so they can be printed into console
  """
  def construct_image(dots) do
    {max_x, _y} = Enum.max_by(dots, &elem(&1, 0))
    {_x, max_y} = Enum.max_by(dots, &elem(&1, 1))

    max_y..0
    |> Enum.reduce([], fn y, grid ->
      row =
        max_x..0
        |> Enum.reduce([], fn x, row ->
          if Enum.member?(dots, {x, y}), do: [<<9_608::utf8>> | row], else: [" " | row]
        end)
        |> Enum.join()

      [row | grid]
    end)
    |> Enum.join("\n")
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Folds the dots along the line
  """
  def fold_paper(dots, {?x, line}) do
    dots
    |> Enum.map(fn
      {x, y} when x > line -> {line - (x - line), y}
      point -> point
    end)
    |> Enum.uniq()
  end

  def fold_paper(dots, {?y, line}) do
    dots
    |> Enum.map(fn
      {x, y} when y > line -> {x, line - (y - line)}
      point -> point
    end)
    |> Enum.uniq()
  end
end

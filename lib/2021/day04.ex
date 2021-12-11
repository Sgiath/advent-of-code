defmodule AdventOfCode.Year2021.Day04 do
  @moduledoc """
  https://adventofcode.com/2021/day/4
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
    8  2 23  4 24
    21  9 14 16  7
    6 10  3 18  5
    1 12 20 15 19

    3 15  0  2 22
    9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
    2  0 12  3  7
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day04.in"])
    |> File.read!()
  end

  def parse_draw_nums(draw) do
    draw
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def parse_boards(boards) do
    boards
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(25)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    [draw | boards] = String.split(input, ["\n", " "], trim: true)

    draw = parse_draw_nums(draw)
    boards = parse_boards(boards)

    Enum.reduce_while(draw, boards, &draw_reducer_first/2)
  end

  def draw_reducer_first(draw_num, boards) do
    boards
    |> Enum.map(&mark_board(&1, draw_num))
    |> filter_wins_first(draw_num)
  end

  def filter_wins_first(boards, draw_num) do
    case Enum.find(boards, &bingo?/1) do
      nil -> {:cont, boards}
      board when is_list(board) -> {:halt, score_board(board, draw_num)}
    end
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    [draw | boards] = String.split(input, ["\n", " "], trim: true)

    draw = parse_draw_nums(draw)
    boards = parse_boards(boards)
    Enum.reduce_while(draw, boards, &draw_reducer_last/2)
  end

  def draw_reducer_last(draw_num, boards) do
    boards
    |> Enum.map(&mark_board(&1, draw_num))
    |> filter_wins_last(draw_num)
  end

  # In case only last board remains
  def filter_wins_last([board], draw_num) do
    if bingo?(board) do
      {:halt, score_board(board, draw_num)}
    else
      {:cont, [board]}
    end
  end

  # Multiple boards remain to process
  def filter_wins_last(boards, _draw_num) do
    {:cont, Enum.reject(boards, &bingo?/1)}
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Convert all matching numbers in all boards to nils
  """
  def mark_board(board, draw_num) do
    Enum.map(board, &if(&1 == draw_num, do: nil, else: &1))
  end

  @doc """
  Check if board is finished
  """
  # bingo in rows
  def bingo?([nil, nil, nil, nil, nil, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _]),
      do: true

  def bingo?([_, _, _, _, _, nil, nil, nil, nil, nil, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _]),
      do: true

  def bingo?([_, _, _, _, _, _, _, _, _, _, nil, nil, nil, nil, nil, _, _, _, _, _, _, _, _, _, _]),
      do: true

  def bingo?([_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, nil, nil, nil, nil, nil, _, _, _, _, _]),
      do: true

  def bingo?([_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, nil, nil, nil, nil, nil]),
      do: true

  # bingo in cols
  def bingo?([nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _]),
      do: true

  def bingo?([_, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _]),
      do: true

  def bingo?([_, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _]),
      do: true

  def bingo?([_, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _]),
      do: true

  def bingo?([_, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil, _, _, _, _, nil]),
      do: true

  # no bingo
  def bingo?(_board), do: false

  @doc """
  Compute final score of the board
  """
  def score_board(board, draw_num) do
    board
    |> Enum.reduce(0, fn
      nil, acc -> acc
      num, acc -> acc + num
    end)
    |> Kernel.*(draw_num)
  end
end

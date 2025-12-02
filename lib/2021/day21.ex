defmodule AdventOfCode.Year2021.Day21 do
  @moduledoc """
  https://adventofcode.com/2021/day/21

  Part 2 uses memoized recursion to count winning universes efficiently.
  The key insight is that the state space is finite:
  - positions: 1-10 (10 values each)
  - scores: 0-20 (21 values each, game ends at 21)
  - whose turn: 2 values
  Total: 10 * 21 * 10 * 21 * 2 = 88,200 possible states

  We recursively compute {wins_p1, wins_p2} from any state, using a memo map
  to avoid recomputing the same states.
  """
  use AdventOfCode, year: 2021, day: 21

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Player 1 starting position: 4
    Player 2 starting position: 8
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn <<"Player ", _player::8, " starting position: ", pos::8>> -> pos - ?0 end)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    [pos1, pos2] = parse(input)

    1..100
    |> Stream.cycle()
    |> Stream.chunk_every(3)
    |> Enum.reduce_while({{pos1, 0}, {pos2, 0}, 0}, fn
      _rolls, {{_pos1, score1}, {_pos2, score2}, step} when score1 >= 1000 ->
        {:halt, score2 * step * 3}

      _rolls, {{_pos1, score1}, {_pos2, score2}, step} when score2 >= 1000 ->
        {:halt, score1 * step * 3}

      rolls, {{pos1, score1}, {pos2, score2}, step} ->
        if rem(step, 2) == 0 do
          pos1 = move(pos1, Enum.sum(rolls))
          {:cont, {{pos1, score1 + pos1}, {pos2, score2}, step + 1}}
        else
          pos2 = move(pos2, Enum.sum(rolls))
          {:cont, {{pos1, score1}, {pos2, score2 + pos2}, step + 1}}
        end
    end)
  end

  # Calculate new position after moving (positions are 1-10, wrapping)
  defp move(pos, rolls) do
    case rem(pos + rolls, 10) do
      0 -> 10
      val -> val
    end
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  # Distribution of sums when rolling 3d3 (three 3-sided dice)
  # Each roll is 1, 2, or 3, so sum ranges from 3 to 9
  # The frequencies represent how many of the 27 universes produce each sum
  @dice_outcomes [{3, 1}, {4, 3}, {5, 6}, {6, 7}, {7, 6}, {8, 3}, {9, 1}]

  @impl AdventOfCode
  def part2(input) do
    [pos1, pos2] = parse(input)

    {wins1, wins2, _memo} = count_wins(pos1, 0, pos2, 0, true, %{})
    max(wins1, wins2)
  end

  @doc """
  Count the number of universes where each player wins from the given state.
  Returns {wins_player1, wins_player2, updated_memo}.

  State is defined by:
  - pos1, score1: player 1's position and score
  - pos2, score2: player 2's position and score
  - player1_turn: true if it's player 1's turn (represented as 1 or 0 in key)

  Uses a memo map to avoid recomputing the same states.
  """
  def count_wins(pos1, score1, pos2, score2, player1_turn, memo) do
    # Use a compact key for memoization
    key = {pos1, score1, pos2, score2, player1_turn}

    case Map.fetch(memo, key) do
      {:ok, {w1, w2}} ->
        {w1, w2, memo}

      :error ->
        {w1, w2, memo} = compute_wins(pos1, score1, pos2, score2, player1_turn, memo)
        {w1, w2, Map.put(memo, key, {w1, w2})}
    end
  end

  # Base cases: someone has won
  defp compute_wins(_pos1, score1, _pos2, _score2, _turn, memo) when score1 >= 21,
    do: {1, 0, memo}

  defp compute_wins(_pos1, _score1, _pos2, score2, _turn, memo) when score2 >= 21,
    do: {0, 1, memo}

  # Player 1's turn
  defp compute_wins(pos1, score1, pos2, score2, true, memo) do
    Enum.reduce(@dice_outcomes, {0, 0, memo}, fn {roll, freq}, {total_w1, total_w2, memo} ->
      new_pos1 = move(pos1, roll)
      new_score1 = score1 + new_pos1
      {w1, w2, memo} = count_wins(new_pos1, new_score1, pos2, score2, false, memo)
      {total_w1 + freq * w1, total_w2 + freq * w2, memo}
    end)
  end

  # Player 2's turn
  defp compute_wins(pos1, score1, pos2, score2, false, memo) do
    Enum.reduce(@dice_outcomes, {0, 0, memo}, fn {roll, freq}, {total_w1, total_w2, memo} ->
      new_pos2 = move(pos2, roll)
      new_score2 = score2 + new_pos2
      {w1, w2, memo} = count_wins(pos1, score1, new_pos2, new_score2, true, memo)
      {total_w1 + freq * w1, total_w2 + freq * w2, memo}
    end)
  end
end

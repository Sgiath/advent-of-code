defmodule AdventOfCode.Year2021.Day21 do
  @moduledoc """
  https://adventofcode.com/2021/day/21
  """
  use AdventOfCode

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

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day21.in"])
    |> File.read!()
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
          pos1 = pos(pos1, Enum.sum(rolls))
          {:cont, {{pos1, score1 + pos1}, {pos2, score2}, step + 1}}
        else
          pos2 = pos(pos2, Enum.sum(rolls))
          {:cont, {{pos1, score1}, {pos2, score2 + pos2}, step + 1}}
        end
    end)
  end

  def pos(pos, rolls) do
    case rem(pos + rolls, 10) do
      0 -> 10
      val -> val
    end
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @base %{
    3 => 1,
    4 => 3,
    5 => 6,
    6 => 7,
    7 => 6,
    8 => 3,
    9 => 1
  }

  @impl AdventOfCode
  def part2(input) do
    [pos1, pos2] = parse(input)

    find_winners({%{{{pos1, 0}, {pos2, 0}, true, false} => 1}, 0, 0})
  end

  @doc """
  Run the steps until all universes reach win
  """
  def find_winners({state, win1, win2}) do
    state
    |> Enum.reduce({%{}, win1, win2}, &update_state/2)
    |> check_wins()
  end

  @doc """
  Check if any undecided universe is left and return the winner, otherwise run the next step
  """
  def check_wins({state, w1, w2}) do
    if Enum.empty?(state), do: max(w1, w2), else: find_winners({state, w1, w2})
  end

  @doc """
  Update the state of the multiverse
  """

  # universe is decided
  def update_state({{{_p1, s1}, _p2, _step, true}, universes}, {new_state, w1, w2}) do
    if s1 >= 21, do: {new_state, w1 + universes, w2}, else: {new_state, w1, w2 + universes}
  end

  # undecided, player 1 turn
  def update_state({{{pos1, score1}, p2, true, false}, universes}, {state, w1, w2}) do
    new_state =
      Enum.reduce(@base, state, fn {roll, freq}, new_state ->
        pos1 = pos(pos1, roll)
        score1 = score1 + pos1

        Map.update(
          new_state,
          {{pos1, score1}, p2, false, score1 >= 21},
          freq * universes,
          &(&1 + freq * universes)
        )
      end)

    {new_state, w1, w2}
  end

  # undecided, player 2 turn
  def update_state({{p1, {pos2, score2}, false, false}, universes}, {state, w1, w2}) do
    new_state =
      Enum.reduce(@base, state, fn {roll, freq}, new_state ->
        pos2 = pos(pos2, roll)
        score2 = score2 + pos2

        Map.update(
          new_state,
          {p1, {pos2, score2}, true, score2 >= 21},
          freq * universes,
          &(&1 + freq * universes)
        )
      end)

    {new_state, w1, w2}
  end
end

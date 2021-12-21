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

    find_winners(%{{{pos1, 0}, {pos2, 0}, true} => 1})
  end

  def find_winners({win1, win2}), do: max(win1, win2)

  def find_winners(%{} = state) do
    state
    |> step()
    |> check_wins()
    |> find_winners()
  end

  def check_wins(state) do
    if Enum.all?(state, &win?/1), do: count_wins(state), else: state
  end

  def count_wins(state) do
    Enum.reduce(state, {0, 0}, fn {{{_p1, score1}, {_p2, _score2}, _step}, count}, {w1, w2} ->
      if score1 >= 21, do: {w1 + count, w2}, else: {w1, w2 + count}
    end)
  end

  def win?({{{_p1, score1}, {_p2, score2}, _step}, _count}) do
    score1 >= 21 or score2 >= 21
  end

  def step(state) do
    Enum.reduce(state, %{}, &update_state/2)
  end

  def update_state({{{_p1, score1}, {_p2, score2}, _step} = state, universes}, new_state)
      when score1 >= 21 or score2 >= 21 do
    Map.update(new_state, state, universes, &(&1 + universes))
  end

  def update_state({{{pos1, score1}, {pos2, score2}, step}, universes}, new_state) do
    Enum.reduce(@base, new_state, fn {roll, freq}, new_state ->
      state =
        if step do
          pos1 = pos(pos1, roll)
          {{pos1, score1 + pos1}, {pos2, score2}, false}
        else
          pos2 = pos(pos2, roll)
          {{pos1, score1}, {pos2, score2 + pos2}, true}
        end

      Map.update(new_state, state, freq * universes, &(&1 + freq * universes))
    end)
  end
end

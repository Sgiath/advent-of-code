defmodule AdventOfCode.Year2022.Day17 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/17
  """
  use AdventOfCode, year: 2022, day: 17
  use TypedStruct

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> List.first()
    |> String.to_charlist()
    |> Enum.map(fn
      ?> -> :r
      ?< -> :l
    end)
  end

  typedstruct module: State do
    field :chamber, MapSet.t(),
      default: MapSet.new([{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}, {0, 5}, {0, 6}])

    field :movements, [:r | :l], default: []
    field :mov_backup, [:r | :l], enforce: true
    field :height, non_neg_integer(), default: 0
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    1..2022
    |> Enum.reduce(%State{mov_backup: parse(input)}, &simulate/2)
    |> Map.get(:height)

    # |> draw()
  end

  def simulate(s, %State{} = state) when rem(s, 5) == 1, do: simulate_line(state)
  def simulate(s, %State{} = state) when rem(s, 5) == 2, do: simulate_cross(state)
  def simulate(s, %State{} = state) when rem(s, 5) == 3, do: simulate_l(state)
  def simulate(s, %State{} = state) when rem(s, 5) == 4, do: simulate_beam(state)
  def simulate(s, %State{} = state) when rem(s, 5) == 0, do: simulate_square(state)

  def simulate_line(%State{height: h} = state) do
    sim_fall(state, [{h + 4, 2}, {h + 4, 3}, {h + 4, 4}, {h + 4, 5}])
  end

  def simulate_cross(%State{height: h} = state) do
    sim_fall(state, [{h + 4, 3}, {h + 5, 2}, {h + 5, 3}, {h + 5, 4}, {h + 6, 3}])
  end

  def simulate_l(%State{height: h} = state) do
    sim_fall(state, [{h + 4, 2}, {h + 4, 3}, {h + 4, 4}, {h + 5, 4}, {h + 6, 4}])
  end

  def simulate_beam(%State{height: h} = state) do
    sim_fall(state, [{h + 4, 2}, {h + 5, 2}, {h + 6, 2}, {h + 7, 2}])
  end

  def simulate_square(%State{height: h} = state) do
    sim_fall(state, [{h + 4, 2}, {h + 4, 3}, {h + 5, 2}, {h + 5, 3}])
  end

  def sim_fall(%State{movements: [], mov_backup: m} = state, rock),
    do: sim_fall(%State{state | movements: m}, rock)

  def sim_fall(%State{} = state, rock) do
    case pop_in(state, [Access.key!(:movements), Access.at!(0)]) do
      {:r, state} ->
        rock = move_right(state, rock)
        move_down(state, rock)

      {:l, state} ->
        rock = move_left(state, rock)
        move_down(state, rock)
    end
  end

  def move_right(%State{chamber: c}, rock) do
    if Enum.any?(rock, fn {_x, y} -> y == 6 end) do
      rock
    else
      new_rock = Enum.map(rock, fn {x, y} -> {x, y + 1} end)

      if MapSet.disjoint?(MapSet.new(new_rock), c), do: new_rock, else: rock
    end
  end

  def move_left(%State{chamber: c}, rock) do
    if Enum.any?(rock, fn {_x, y} -> y == 0 end) do
      rock
    else
      new_rock = Enum.map(rock, fn {x, y} -> {x, y - 1} end)

      if MapSet.disjoint?(MapSet.new(new_rock), c), do: new_rock, else: rock
    end
  end

  def move_down(%State{chamber: c, height: h} = state, rock) do
    new_rock = Enum.map(rock, fn {x, y} -> {x - 1, y} end)

    if MapSet.disjoint?(MapSet.new(new_rock), c) do
      sim_fall(state, new_rock)
    else
      state
      |> Map.put(:chamber, MapSet.union(c, MapSet.new(rock)))
      |> Map.put(:height, rock |> Enum.max_by(fn {x, _y} -> x end) |> elem(0) |> max(h))
    end
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    1..1_000_000_000_000
    |> Enum.reduce(%State{mov_backup: parse(input)}, &simulate/2)
    |> Map.get(:height)
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def draw(%State{chamber: c, height: h}) do
    for x <- 0..(h + 4), y <- 0..6 do
      if MapSet.member?(c, {x, y}), do: "#", else: "."
    end
    |> Enum.chunk_every(7)
    |> Enum.reverse()
    |> Enum.intersperse("|\n|")
    |> List.insert_at(0, "|")
    |> List.insert_at(-1, "|\n+-------+")
    |> IO.chardata_to_string()
  end
end

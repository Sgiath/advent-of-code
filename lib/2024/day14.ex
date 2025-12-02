defmodule AdventOfCode.Year2024.Day14 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/14
  """
  use AdventOfCode, year: 2024, day: 14

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn robot ->
      ["p", x, y, "v", vx, vy] = String.split(robot, ["=", ",", " "], trim: true)

      {{String.to_integer(x), String.to_integer(y)},
       {String.to_integer(vx), String.to_integer(vy)}}
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input, s \\ {101, 103}) do
    # quadrant borders
    sx = div(elem(s, 0) - 1, 2)
    sy = div(elem(s, 1) - 1, 2)

    input
    |> parse()
    |> Enum.map(&simulate(&1, s, 100))
    |> Enum.group_by(fn
      {{x, y}, _v} when x < sx and y < sy -> 1
      {{x, y}, _v} when x > sx and y < sy -> 2
      {{x, y}, _v} when x < sx and y > sy -> 3
      {{x, y}, _v} when x > sx and y > sy -> 4
      _otherwise -> 0
    end)
    |> Enum.reduce(1, fn
      {0, _robots}, acc -> acc
      {_quadrant, robots}, acc -> acc * length(robots)
    end)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input, interactive \\ true) do
    input
    |> parse()
    |> next_state(interactive)
  end

  def next_state(robots, interactive, i \\ 1)

  def next_state(robots, interactive, i) do
    # simulate next itteration
    robots = Enum.map(robots, &simulate(&1, {101, 103}))

    if is_interesting?(robots) do
      if interactive do
        # print robots
        print(robots)
        # print what itteration are we on
        IO.puts("itteration: #{i}")

        case IO.gets("Search for next? [y/N] ") do
          "y\n" -> next_state(robots, interactive, i + 1)
          "Y\n" -> next_state(robots, interactive, i + 1)
          _otherwise -> :ok
        end
      else
        i
      end
    else
      # if the state is not intersting continue without printing
      next_state(robots, interactive, i + 1)
    end
  end

  def print(robots) do
    # construct empty map
    line = Stream.cycle(["  "]) |> Enum.take(101)
    map = Stream.cycle([line]) |> Enum.take(103)

    IO.puts("+-" <> String.duplicate("--", 101) <> "-+")

    robots
    # insert all robots into map
    |> Enum.reduce(map, fn {{x, y}, _v}, map ->
      put_in(map, [Access.at(y), Access.at(x)], "\u2588\u2588")
    end)
    # print line by line
    |> Enum.map(fn line -> IO.puts("| " <> Enum.join(line) <> " |") end)

    IO.puts("+-" <> String.duplicate("--", 101) <> "-+")
  end

  @doc """
  This was determined kinda by trial and error:
    - First I printed all variances I get, it sits around 800 - 900 but I have noticed it
      sometimes was as low as 330
    - So next itteration was printing every state with variance lower then 500 (x or y). That way
      I found my solution but I had to visually inspect few states
    - Then I also printed variances for each "interesting" state and noticed that for the solution
      both x and y variances were around 330 so I switched to "and" and arrived to the solution
      immediately
  """
  def is_interesting?(robots) do
    # Single-pass variance calculation for both x and y
    # Using: Var(X) = E[X²] - E[X]² = (sum_sq / n) - (sum / n)²
    {sum_x, sum_x_sq, sum_y, sum_y_sq, n} =
      Enum.reduce(robots, {0, 0, 0, 0, 0}, fn {{x, y}, _v}, {sx, sxsq, sy, sysq, count} ->
        {sx + x, sxsq + x * x, sy + y, sysq + y * y, count + 1}
      end)

    var_x = sum_x_sq / n - sum_x / n * (sum_x / n)
    var_y = sum_y_sq / n - sum_y / n * (sum_y / n)

    var_x < 500 and var_y < 500
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def simulate(robot, size, rounds \\ 1)
  def simulate(robot, _size, 0), do: robot

  def simulate({{x, y}, {vx, vy}}, {sx, sy}, 1) do
    {{rem(x + vx + sx, sx), rem(y + vy + sy, sy)}, {vx, vy}}
  end

  def simulate({{x, y}, {vx, vy}}, {sx, sy}, rounds) do
    nx = rem(x + vx + sx, sx)
    ny = rem(y + vy + sy, sy)

    simulate({{nx, ny}, {vx, vy}}, {sx, sy}, rounds - 1)
  end
end

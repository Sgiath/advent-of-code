defmodule AdventOfCode.Year2022.Day05 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/5
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
        [D]    \n[N] [C]    \n[Z] [M] [P]\n 1   2   3 \n

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2022", "day05.in"])
    |> File.read!()
  end

  def parse(input) do
    [config, moves] = String.split(input, ["\n\n"], trim: true)

    [_stacks | config] =
      config
      |> String.split(["\n"], trim: true)
      |> Enum.reverse()

    config =
      config
      |> Enum.reverse()
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(fn [_first | line] -> line end)
      |> Enum.map(&Enum.take_every(&1, 4))
      |> Enum.zip()
      |> Enum.map(fn stack ->
        stack
        |> Tuple.to_list()
        |> Enum.reject(&(&1 == " "))
      end)

    moves =
      moves
      |> String.split(["\n"], trim: true)
      |> Enum.map(fn line ->
        %{"c" => c, "f" => f, "t" => t} =
          Regex.named_captures(~r/move (?<c>\d+) from (?<f>\d+) to (?<t>\d+)/, line)

        {String.to_integer(c), String.to_integer(f) - 1, String.to_integer(t) - 1}
      end)

    {config, moves}
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {config, moves} = parse(input)

    moves
    |> Enum.reduce(config, &execute_9000/2)
    |> Enum.map(&List.first/1)
    |> Enum.join()
  end

  defp execute_9000({0, _from, _to}, config), do: config

  defp execute_9000({count, from, to}, config) do
    [crate | _rest] = Enum.at(config, from)

    config =
      config
      |> List.update_at(from, fn [_c | rest] -> rest end)
      |> List.update_at(to, fn stack -> [crate | stack] end)

    execute_9000({count - 1, from, to}, config)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {config, moves} = parse(input)

    moves
    |> Enum.reduce(config, &execute_9001/2)
    |> Enum.map(&List.first/1)
    |> Enum.join()
  end

  defp execute_9001({count, from, to}, config) do
    {move, f} = config |> Enum.at(from) |> Enum.split(count)

    config
    |> List.replace_at(from, f)
    |> List.update_at(to, fn stack -> move ++ stack end)
  end
end

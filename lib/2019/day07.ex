defmodule AdventOfCode.Year2019.Day07 do
  @moduledoc """
  https://adventofcode.com/2019/day/7
  """
  use AdventOfCode, year: 2019, day: 7

  alias AdventOfCode.Parser
  alias AdventOfCode.Year2019.Intcode

  @impl AdventOfCode
  def test_input do
    """
    3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0
    """
  end

  @impl AdventOfCode
  def part1(input) do
    0..4
    |> Enum.to_list()
    |> permutations()
    |> Enum.map(&run_config(Parser.intcode(input), &1))
    |> Enum.max()
  end

  @doc """
  question
  """
  @impl AdventOfCode
  def part2(input) do
    5..9
    |> Enum.to_list()
    |> permutations()
    |> Enum.map(&run_config_recursive(Parser.intcode(input), &1))
    |> Enum.max()
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
  end

  def start(memory, num, acc \\ [])

  def start(_memory, 0, acc), do: acc

  def start(memory, num, []) do
    start(memory, num - 1, [Intcode.start_link(memory, self(), self())])
  end

  def start(memory, num, [pid | _rest] = acc) do
    start(memory, num - 1, [Intcode.start_link(memory, self(), pid) | acc])
  end

  defp run_config(memory, p) do
    [pid1 | _rest] = pids = start(memory, 5)

    pids
    |> Enum.zip(p)
    |> Enum.each(fn {pid, p} ->
      Intcode.run_program_async(pid)
      send(pid, p)
    end)

    send(pid1, 0)

    receive do
      {:output, val} -> val
    end
  end

  defp run_config_recursive(memory, [p1, p2, p3, p4, p5]) do
    pid5 = Intcode.start_link(memory, self(), self())
    pid4 = Intcode.start_link(memory, self(), pid5)
    pid3 = Intcode.start_link(memory, self(), pid4)
    pid2 = Intcode.start_link(memory, self(), pid3)
    pid1 = Intcode.start_link(memory, self(), pid2)

    Intcode.add_output(pid5, pid1)

    Intcode.run_program_async(pid1)
    Intcode.run_program_async(pid2)
    Intcode.run_program_async(pid3)
    Intcode.run_program_async(pid4)
    Intcode.run_program_async(pid5)

    send(pid1, p1)
    send(pid2, p2)
    send(pid3, p3)
    send(pid4, p4)
    send(pid5, p5)
    send(pid1, 0)

    List.first(get_outputs())
  end

  defp get_outputs(output \\ []) do
    receive do
      {:output, val} ->
        get_outputs([val | output])

      :halt ->
        if output == [] do
          get_outputs([])
        else
          output
        end
    end
  end
end

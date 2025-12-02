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
    memory = Parser.intcode(input)

    0..4
    |> Enum.to_list()
    |> permutations()
    |> Enum.map(&run_amplifier_chain(memory, &1))
    |> Enum.max()
  end

  @doc """
  Part 2 uses feedback loop mode where amplifiers run concurrently
  """
  @impl AdventOfCode
  def part2(input) do
    memory = Parser.intcode(input)

    5..9
    |> Enum.to_list()
    |> permutations()
    |> Enum.map(&run_feedback_loop(memory, &1))
    |> Enum.max()
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
  end

  # Part 1: Simple chain using functional API - each amplifier runs to completion
  defp run_amplifier_chain(memory, phases) do
    Enum.reduce(phases, 0, fn phase, signal ->
      [output] = Intcode.run_collecting(memory, inputs: [phase, signal])
      output
    end)
  end

  # Part 2: Feedback loop requires process-based I/O for concurrent execution
  defp run_feedback_loop(memory, [p1, p2, p3, p4, p5]) do
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

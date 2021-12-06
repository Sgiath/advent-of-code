defmodule AdventOfCode.Year2019.Day09 do
  @moduledoc """
  https://adventofcode.com/2019/day/9
  """
  use AdventOfCode, year: 2019, day: 09

  alias AdventOfCode.Parser
  alias AdventOfCode.Year2019.Intcode

  @impl AdventOfCode
  def input, do: Parser.intcode(input_data())

  defp get_output(output \\ []) do
    receive do
      :halt -> Enum.reverse(output)
      {:output, val} -> get_output([val | output])
    end
  end

  @impl AdventOfCode
  def part1(input) do
    pid = Intcode.start_link(input, self(), self())

    Intcode.run_program_async(pid)

    send(pid, 1)

    output = get_output()

    if Enum.count(output) > 1 do
      IO.puts("Tests didn't work. Fix your computer")
      inspect(output)
    else
      List.first(output)
    end
  end

  @impl AdventOfCode
  def part2(input) do
    pid = Intcode.start_link(input, self(), self())

    Intcode.run_program_async(pid)

    send(pid, 2)

    receive do
      {:output, val} -> val
    end
  end
end

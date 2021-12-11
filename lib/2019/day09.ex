defmodule AdventOfCode.Year2019.Day09 do
  @moduledoc """
  https://adventofcode.com/2019/day/9
  """
  use AdventOfCode

  alias AdventOfCode.Parser
  alias AdventOfCode.Year2019.Intcode

  @impl AdventOfCode
  def test_input do
    """
    109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2019", "day09.in"])
    |> File.read!()
  end

  defp get_output(output \\ []) do
    receive do
      :halt -> Enum.reverse(output)
      {:output, val} -> get_output([val | output])
    end
  end

  @impl AdventOfCode
  def part1(input) do
    pid = input |> Parser.intcode() |> Intcode.start_link(self(), self())

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
    pid = input |> Parser.intcode() |> Intcode.start_link(self(), self())

    Intcode.run_program_async(pid)

    send(pid, 2)

    receive do
      {:output, val} -> val
    end
  end
end

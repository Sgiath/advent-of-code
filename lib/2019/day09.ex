defmodule AdventOfCode.Year2019.Day09 do
  @moduledoc """
  https://adventofcode.com/2019/day/9
  """
  use AdventOfCode, year: 2019, day: 9

  alias AdventOfCode.Parser
  alias AdventOfCode.Year2019.Intcode

  @impl AdventOfCode
  def test_input do
    """
    109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99
    """
  end

  @impl AdventOfCode
  def part1(input) do
    # Run BOOST program in test mode (input 1)
    output =
      input
      |> Parser.intcode()
      |> Intcode.run_collecting(inputs: [1])

    if Enum.count(output) > 1 do
      IO.puts("Tests didn't work. Fix your computer")
      inspect(output)
    else
      List.first(output)
    end
  end

  @impl AdventOfCode
  def part2(input) do
    # Run BOOST program in sensor boost mode (input 2)
    input
    |> Parser.intcode()
    |> Intcode.run_collecting(inputs: [2])
    |> List.first()
  end
end

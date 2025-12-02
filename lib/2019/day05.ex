defmodule AdventOfCode.Year2019.Day05 do
  @moduledoc false
  use AdventOfCode, year: 2019, day: 5

  alias AdventOfCode.Parser
  alias AdventOfCode.Year2019.Intcode

  @impl AdventOfCode
  def test_input do
    """
    3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
    """
  end

  @impl AdventOfCode
  def part1(input) do
    # Run with input 1 and collect outputs using functional API
    [code | rest] =
      input
      |> Parser.intcode()
      |> Intcode.run_collecting(inputs: [1])
      |> Enum.reverse()

    if Enum.all?(rest, &(&1 == 0)), do: code, else: raise("tests didn't pass")
  end

  @doc """
  This time, when the TEST diagnostic program runs its input instruction to get the ID of the
  system to test, provide it 5, the ID for the ship's thermal radiator controller. This
  diagnostic test suite only outputs one number, the diagnostic code.

  What is the diagnostic code for system ID 5?
  """
  @impl AdventOfCode
  def part2(input) do
    # Run with input 5 and get the single diagnostic code
    input
    |> Parser.intcode()
    |> Intcode.run_collecting(inputs: [5])
    |> List.first()
  end
end

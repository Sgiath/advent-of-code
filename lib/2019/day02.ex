defmodule AdventOfCode.Year2019.Day02 do
  @moduledoc """
  https://adventofcode.com/2019/day/2
  """
  use AdventOfCode, year: 2019, day: 02

  alias AdventOfCode.Year2019.Intcode
  alias AdventOfCode.Year2019.Intcode.Memory
  alias AdventOfCode.Year2019.Intcode.State

  require Logger

  @doc """
  Once you have a working computer, the first step is to restore the gravity assist program (your
  puzzle input) to the "1202 program alarm" state it had just before the last computer caught
  fire. To do this, before running the program, replace position 1 with the value 12 and replace
  position 2 with the value 2. What value is left at position 0 after the program halts?
  """
  @impl AdventOfCode
  def part1 do
    input_list()
    |> run_program(12, 2)
  end

  @doc """
  Find the input noun and verb that cause the program to produce the output 19690720. What is
  100 * noun + verb? (For example, if noun=12 and verb=2, the answer would be 1202.)
  """
  @impl AdventOfCode
  def part2 do
    find_combination(input_list())
  end

  @doc """
  Run program with two arguments
  """
  def run_program(memory, arg1, arg2) do
    %State{memory: memory} =
      memory
      |> List.replace_at(1, arg1)
      |> List.replace_at(2, arg2)
      |> Intcode.start_link()
      |> Intcode.run_program()

    Memory.get_value(memory, 0)
  end

  @doc """
  Run programs with different inputs until required output is found
  """
  def find_combination(program) do
    options = for noun <- 0..99, verb <- 0..99, into: [], do: {noun, verb}

    options
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(fn {noun, verb} -> {run_program(program, noun, verb), 100 * noun + verb} end)
    |> Enum.find_value(fn
      {19_690_720, result} -> result
      _ -> false
    end)
  end
end

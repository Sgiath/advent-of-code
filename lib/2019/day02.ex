defmodule AdventOfCode.Year2019.Day02 do
  @moduledoc """
  https://adventofcode.com/2019/day/2
  """
  use AdventOfCode

  alias AdventOfCode.Parser
  alias AdventOfCode.Year2019.Intcode
  alias AdventOfCode.Year2019.Intcode.Memory
  alias AdventOfCode.Year2019.Intcode.State

  require Logger

  @impl AdventOfCode
  def test_input do
    """
    1,1,1,4,99,5,6,0,99
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2019", "day02.in"])
    |> File.read!()
  end

  @impl AdventOfCode
  def part1(input) do
    input
    |> Parser.intcode()
    |> run_program(12, 2)
  end

  @doc """
  Find the input noun and verb that cause the program to produce the output 19690720. What is
  100 * noun + verb? (For example, if noun=12 and verb=2, the answer would be 1202.)
  """
  @impl AdventOfCode
  def part2(input) do
    input
    |> Parser.intcode()
    |> find_combination()
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
      _value -> false
    end)
  end
end

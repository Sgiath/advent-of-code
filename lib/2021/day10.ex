defmodule AdventOfCode.Year2021.Day10 do
  @moduledoc """
  https://adventofcode.com/2021/day/10
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day10.in"])
    |> File.read!()
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, &(&1 |> check_syntax() |> score_syntax() |> Kernel.+(&2)))
  end

  def score_syntax({:error, ?)}), do: 3
  def score_syntax({:error, ?]}), do: 57
  def score_syntax({:error, ?}}), do: 1197
  def score_syntax({:error, ?>}), do: 25_137
  def score_syntax({:incomplete, _completion}), do: 0

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> check_syntax() |> score_completion()))
    |> Enum.reject(&is_nil/1)
    |> Statistics.median()
  end

  @doc """
  Score completion based on the received stack
  """
  def score_completion(result, acc \\ 0)
  def score_completion({:error, _char}, 0), do: nil
  def score_completion({:incomplete, stack}, 0), do: score_completion(stack, 0)
  def score_completion([?) | stack], acc), do: score_completion(stack, acc * 5 + 1)
  def score_completion([?] | stack], acc), do: score_completion(stack, acc * 5 + 2)
  def score_completion([?} | stack], acc), do: score_completion(stack, acc * 5 + 3)
  def score_completion([?> | stack], acc), do: score_completion(stack, acc * 5 + 4)
  def score_completion([], acc), do: acc

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Check syntax of the line

  Returns:
    - `{:error, bracket}` where `bracket` is the first corrupted bracket on the line
    - `{:incomplete, stack}` where `stack` is list of unclosed brackets
    - `:ok` if the line is completed (shouldn't happen)
  """
  def check_syntax(line, stack \\ [])
  # add starting bracket to stack
  def check_syntax(<<?(, rest::binary>>, stack), do: check_syntax(rest, [?) | stack])
  def check_syntax(<<?[, rest::binary>>, stack), do: check_syntax(rest, [?] | stack])
  def check_syntax(<<?{, rest::binary>>, stack), do: check_syntax(rest, [?} | stack])
  def check_syntax(<<?<, rest::binary>>, stack), do: check_syntax(rest, [?> | stack])
  # remove bracket from stack on complete pair
  def check_syntax(<<char::8, rest::binary>>, [char | stack]), do: check_syntax(rest, stack)
  # return error when bracket is not in pair with bracket on stack
  def check_syntax(<<char::8, _rest::binary>>, _stack), do: {:error, char}
  # return success when we are at the end of line and stack is empty
  def check_syntax(<<>>, []), do: :ok
  # return incomplete when we are at the end but stack is not empty
  def check_syntax(<<>>, stack), do: {:incomplete, stack}
end

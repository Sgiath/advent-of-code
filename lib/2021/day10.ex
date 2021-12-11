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
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&check_syntax/1)
    |> Enum.reduce(0, &score_syntax/2)
  end

  def score_syntax({:error, ")"}, acc), do: acc + 3
  def score_syntax({:error, "]"}, acc), do: acc + 57
  def score_syntax({:error, "}"}, acc), do: acc + 1197
  def score_syntax({:error, ">"}, acc), do: acc + 25137
  def score_syntax({:incomplete, _completion}, acc), do: acc

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&check_syntax/1)
    |> Enum.filter(&(elem(&1, 0) == :incomplete))
    |> Enum.map(&score_completion/1)
    |> Statistics.median()
  end

  @doc """
  Score completion based on the received stack
  """
  def score_completion(result, acc \\ 0)
  def score_completion({:incomplete, stack}, 0), do: score_completion(stack, 0)
  def score_completion(["(" | stack], acc), do: score_completion(stack, acc * 5 + 1)
  def score_completion(["[" | stack], acc), do: score_completion(stack, acc * 5 + 2)
  def score_completion(["{" | stack], acc), do: score_completion(stack, acc * 5 + 3)
  def score_completion(["<" | stack], acc), do: score_completion(stack, acc * 5 + 4)
  def score_completion([], acc), do: acc

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Check if bracket is starting one
  """
  defguard is_starting(a) when a in ["(", "[", "{", "<"]

  @doc """
  Check if two brackets are simple bracket pair
  """
  defguard is_simple(a, b) when a == "(" and b == ")"

  @doc """
  Check if two brackets are square bracket pair
  """
  defguard is_square(a, b) when a == "[" and b == "]"

  @doc """
  Check if two brackets are curly bracket pair
  """
  defguard is_curly(a, b) when a == "{" and b == "}"

  @doc """
  Check if two brackets are pointy bracket pair
  """
  defguard is_pointy(a, b) when a == "<" and b == ">"

  @doc """
  Check if two brackets are any bracket pair
  """
  defguard is_pair(a, b)
           when is_simple(a, b) or is_square(a, b) or is_curly(a, b) or is_pointy(a, b)

  @doc """
  Check syntax of the line

  Returns:
    - `{:error, bracket}` where `bracket` is the first corrupted bracket on the line
    - `{:incomplete, stack}` where `stack` is list of unclosed brackets
    - `:success` if the line is completed (shouldn't happen)
  """
  def check_syntax(line, stack \\ [])
  # add starting bracket to stack
  def check_syntax([a | rest], stack) when is_starting(a), do: check_syntax(rest, [a | stack])
  # remove bracket from stack on complete pair
  def check_syntax([a | rest], [b | stack]) when is_pair(b, a), do: check_syntax(rest, stack)
  # return error when bracket is not in pair with bracket on stack
  def check_syntax([a | _rest], _stack), do: {:error, a}
  # return incomplete when we are at the end but stack is not empty
  def check_syntax([], stack) when length(stack) > 0, do: {:incomplete, stack}
  # return success when we are at the end of line and stack is empty
  def check_syntax([], []), do: :success
end

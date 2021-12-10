defmodule AdventOfCode.Year2021.Day10 do
  @moduledoc """
  https://adventofcode.com/2021/day/10
  """
  use AdventOfCode, year: 2021, day: 10

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def input do
    input_data()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
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
    |> Enum.map(&check_syntax/1)
    |> Enum.filter(&(elem(&1, 0) == :incomplete))
    |> Enum.map(&score_completion/1)
    |> Statistics.median()
  end

  def score_completion(rest, acc \\ 0)
  def score_completion({:incomplete, rest}, 0), do: score_completion(rest, 0)
  def score_completion(["(" | rest], acc), do: score_completion(rest, acc * 5 + 1)
  def score_completion(["[" | rest], acc), do: score_completion(rest, acc * 5 + 2)
  def score_completion(["{" | rest], acc), do: score_completion(rest, acc * 5 + 3)
  def score_completion(["<" | rest], acc), do: score_completion(rest, acc * 5 + 4)
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
    - `{:incomplete, completion}` where `completion` is list of missing brackets
    - `:success` if the line is completed (shouldn't happen)
  """
  def check_syntax(line, acc \\ [])
  def check_syntax([a | rest], acc) when is_starting(a), do: check_syntax(rest, [a | acc])
  def check_syntax([a | rest], [b | acc]) when is_pair(b, a), do: check_syntax(rest, acc)
  def check_syntax([a | _rest], _acc), do: {:error, a}
  def check_syntax([], acc) when length(acc) > 0, do: {:incomplete, acc}
  def check_syntax([], []), do: :success
end

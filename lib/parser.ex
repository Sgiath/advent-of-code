defmodule AdventOfCode.Parser do
  @moduledoc ~S"""
  Groups all parsing functions in one place
  """

  @doc ~S"""
  Split to lines and run parser on each line
  """
  @spec lines(String.t(), String.t() | [String.t()], fun()) :: []
  def lines(data, splitter \\ "\n", parser \\ &String.to_integer/1) do
    data
    |> String.split(splitter, trim: true)
    |> Enum.map(parser)
  end

  @doc ~S"""
  First line as numbers
  """
  @spec line(String.t()) :: [integer()]
  def line(data), do: lines(data, [",", "\n"])

  @doc ~S"""
  Custom function for Intcode input data
  """
  @spec intcode(String.t()) :: [integer()]
  def intcode(data), do: line(data)
end

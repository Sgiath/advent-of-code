defmodule AdventOfCode do
  @moduledoc """
  Behaviour and helper functions for Advent of Code day solutions
  """

  defmacro __using__(opts) do
    year = Keyword.get(opts, :year)
    day = Keyword.get(opts, :day)

    quote do
      @behaviour AdventOfCode

      @spec input_file() :: String.t()
      def input_file do
        AdventOfCode.input_file(unquote(year), unquote(day))
      end

      @spec input_lines() :: Enumerable.t()
      def input_lines do
        AdventOfCode.input_lines(unquote(year), unquote(day))
      end

      @spec input_line() :: String.t()
      def input_line do
        AdventOfCode.input_line(unquote(year), unquote(day))
      end

      @spec input_numbers() :: Enumerable.t()
      def input_numbers do
        AdventOfCode.input_numbers(unquote(year), unquote(day))
      end

      @spec input_chars() :: Enumerable.t()
      def input_chars do
        AdventOfCode.input_chars(unquote(year), unquote(day))
      end

      @spec input_lists(splitter :: String.t(), mapper :: function()) :: Enumerable.t()
      def input_lists(splitter \\ ",", mapper \\ &String.to_integer/1) do
        AdventOfCode.input_lists(unquote(year), unquote(day), splitter, mapper)
      end

      @spec input_list(splitter :: String.t(), mapper :: function()) :: []
      def input_list(splitter \\ ",", mapper \\ &String.to_integer/1) do
        AdventOfCode.input_list(unquote(year), unquote(day), splitter, mapper)
      end

      @impl AdventOfCode
      def bench do
        %{
          part1: &part1/1,
          part2: &part2/1
        }
      end

      defoverridable bench: 0
    end
  end

  @callback input :: any()
  @callback part1(any()) :: any()
  @callback part2(any()) :: any()
  @callback bench :: map() | [map()]

  @doc """
  Get path for input file for specific year and day
  """
  @spec input_file(year :: non_neg_integer(), day :: non_neg_integer()) :: String.t()
  def input_file(year, day) do
    Path.join([Application.app_dir(:advent_of_code, "priv"), format(year, day, "in")])
  end

  @doc """
  Get exercise input as list of strings
  """
  @spec input_lines(year :: non_neg_integer(), day :: non_neg_integer()) :: Enumerable.t()
  def input_lines(year, day) do
    input_file(year, day)
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  @doc """
  Get first line of the input file
  """
  @spec input_line(year :: non_neg_integer(), day :: non_neg_integer()) :: String.t()
  def input_line(year, day) do
    input_lines(year, day)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
  end

  @doc """
  Get exercise input as list of numbers
  """
  @spec input_numbers(year :: non_neg_integer(), day :: non_neg_integer()) :: Enumerable.t()
  def input_numbers(year, day) do
    input_lines(year, day)
    |> Stream.map(&String.to_integer/1)
  end

  @doc """
  Get exercise input as list of charlists
  """
  @spec input_chars(year :: non_neg_integer(), day :: non_neg_integer()) :: Enumerable.t()
  def input_chars(year, day) do
    input_lines(year, day)
    |> Stream.map(&String.graphemes/1)
  end

  @doc """
  Get exercise input as list of lists
  """
  @spec input_lists(integer(), integer(), String.t(), function()) :: Enumerable.t()
  def input_lists(year, day, splitter \\ ",", mapper \\ &String.to_integer/1) do
    input_lines(year, day)
    |> Stream.map(&String.split(&1, splitter))
    |> Stream.map(&Enum.map(&1, mapper))
  end

  @doc """
  Get first line of input file as list
  """
  @spec input_list(integer(), integer(), String.t(), function()) :: []
  def input_list(year, day, splitter \\ ",", mapper \\ &String.to_integer/1) do
    input_lists(year, day, splitter, mapper)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
  end

  defp format(year, day, sufix) do
    "#{year}/day#{day |> Integer.to_string() |> String.pad_leading(2, "0")}.#{sufix}"
  end
end

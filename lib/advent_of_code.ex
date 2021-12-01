defmodule AdventOfCode do
  @moduledoc """
  Behaviour and helper functions for Advent of Code day solutions
  """

  defmacro __using__(opts) do
    year = Keyword.get(opts, :year)
    day = opts |> Keyword.get(:day) |> Integer.to_string() |> String.pad_leading(2, "0")

    quote do
      @behaviour AdventOfCode

      @spec input_file() :: String.t()
      def input_file do
        Path.join([
          Application.app_dir(:advent_of_code, "priv"),
          "#{unquote(year)}",
          "day#{unquote(day)}.in"
        ])
      end

      @spec input_lines() :: Enumerable.t()
      def input_lines do
        input_file()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
      end

      @spec input_line() :: String.t()
      def input_line do
        input_lines()
        |> Stream.take(1)
        |> Enum.to_list()
        |> List.first()
      end

      @spec input_numbers() :: Enumerable.t()
      def input_numbers do
        input_lines()
        |> Stream.map(&String.to_integer/1)
      end

      @spec input_chars() :: Enumerable.t()
      def input_chars do
        input_lines()
        |> Stream.map(&String.graphemes/1)
      end

      @spec input_lists(mapper :: function()) :: Enumerable.t()
      def input_lists(mapper \\ &String.to_integer/1) do
        input_lines()
        |> Stream.map(&String.split(&1, ","))
        |> Stream.map(&Enum.map(&1, mapper))
      end

      @spec input_list(mapper :: function()) :: []
      def input_list(mapper \\ &String.to_integer/1) do
        input_lists()
        |> Stream.take(1)
        |> Enum.to_list()
        |> List.first()
      end
    end
  end

  @callback part1 :: any()
  @callback part2 :: any()
end

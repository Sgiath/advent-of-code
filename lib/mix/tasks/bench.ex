defmodule Mix.Tasks.AdventOfCode.Bench do
  @shortdoc "Run Benchmark for Advent of Code excercise"
  @moduledoc """
  Runs solution for particular day of Advent of Code challenge

  ## Command line options

    * `--year / -y <NUM>` - which year to run (default 2021)
    * `--day / -d <NUM>` - which day to run (required)
  """
  use Mix.Task

  @strict [year: :integer, day: :integer]
  @aliases [y: :year, d: :day]

  @impl Mix.Task
  def run(args) do
    {opts, [], []} = OptionParser.parse(args, strict: @strict, aliases: @aliases)
    year = Keyword.get(opts, :year, 2021)
    day = opts |> Keyword.get(:day) |> Integer.to_string() |> String.pad_leading(2, "0")

    module = :"Elixir.AdventOfCode.Year#{year}.Day#{day}"

    case Code.ensure_compiled(module) do
      {:module, _} ->
        Benchee.run(%{
          part1: &module.part1/0,
          part2: &module.part2/0
        })

      {:error, _} ->
        IO.puts("\n#{IO.ANSI.red()}Year #{year}, day #{day} not implemented!#{IO.ANSI.reset()}")
    end
  end
end

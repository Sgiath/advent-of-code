defmodule Mix.Tasks.AdventOfCode.Init do
  @shortdoc "Initialise Advent of Code excercise"
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
    year = opts |> Keyword.get(:year, 2021) |> Integer.to_string()
    day = opts |> Keyword.get(:day) |> Integer.to_string() |> String.pad_leading(2, "0")

    template = Path.join([File.cwd!(), "priv", "template.eex"])
    script = Path.join([File.cwd!(), "lib", year, "day#{day}.ex"])
    input = Path.join([File.cwd!(), "priv", year, "day#{day}.in"])

    content = EEx.eval_file(template, year: year, day: day)

    File.open(script, [:write, :utf8], &IO.write(&1, content))
    File.open(input, [:write, :utf8], &IO.write(&1, ""))
  end
end

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
    cookie = Path.join([File.cwd!(), "priv", "COOKIE"])
    script = Path.join([File.cwd!(), "lib", year, "day#{day}.ex"])
    input = Path.join([File.cwd!(), "priv", year, "day#{day}.in"])

    content = EEx.eval_file(template, year: year, day: day)

    File.open(script, [:write, :utf8], &IO.write(&1, content))

    input_url = "http://adventofcode.com/#{year}/day/#{String.to_integer(day)}/input"
    cookie = String.to_charlist("session=#{File.read!(cookie)}")

    {:ok, {_status, _headers, input_data}} =
      :httpc.request(:get, {input_url, [{'Cookie', cookie}]}, [], [])

    File.open(input, [:write, :utf8], &IO.write(&1, input_data))
  end
end

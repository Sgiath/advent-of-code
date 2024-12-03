defmodule Mix.Tasks.AdventOfCode do
  @shortdoc "Execute Advent of Code exercise"
  @moduledoc ~S"""
  Runs solution for particular day of Advent of Code challenge

  ## Command line options

    * `--year / -y <NUM>` - which year to run (default current year)
    * `--day / -d <NUM>` - which day to run (default current day of month)
    * `--part1` - execute first part of the solution
    * `--part2` - execute second part of the solution
  """
  use Mix.Task

  alias AdventOfCode.Utils

  @strict [year: :integer, day: :integer, part1: :boolean, part2: :boolean, test: :boolean]
  @aliases [y: :year, d: :day, t: :test]

  @impl Mix.Task
  def run(args) do
    {opts, [], []} = OptionParser.parse(args, strict: @strict, aliases: @aliases)
    {year, opts} = Keyword.pop(opts, :year, Utils.default_year())
    {day, opts} = Keyword.pop(opts, :day, Date.utc_today().day)
    day = day |> Integer.to_string() |> String.pad_leading(2, "0")

    unless File.exists?("priv/#{year}/day#{day}.in") do
      Application.ensure_all_started(:advent_of_code)
      Utils.save_input(year, String.to_integer(day))
    end

    module = String.to_atom("Elixir.AdventOfCode.Year#{year}.Day#{day}")

    case Code.ensure_compiled(module) do
      {:module, _} ->
        if Keyword.get(opts, :part1, false), do: run_part(module, 1, opts)
        if Keyword.get(opts, :part2, false), do: run_part(module, 2, opts)

      {:error, _} ->
        IO.puts("\n#{IO.ANSI.red()}Year #{year}, day #{day} not implemented!#{IO.ANSI.reset()}")
    end
  end

  defp run_part(module, part, opts) do
    IO.puts("\n#{IO.ANSI.bright()}#{IO.ANSI.blue()}Part #{part}#{IO.ANSI.reset()}")
    input = if Keyword.get(opts, :test, false), do: module.test_input(), else: module.input()

    {time, solution} = :timer.tc(module, String.to_existing_atom("part#{part}"), [input])

    if is_binary(solution),
      do: IO.puts(solution),
      else: IO.inspect(solution, charlists: :as_lists, pretty: true)

    IO.puts("#{IO.ANSI.light_black()}#{time} μs#{IO.ANSI.reset()}\n")
  end
end

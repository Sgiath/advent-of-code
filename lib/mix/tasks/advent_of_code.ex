defmodule Mix.Tasks.AdventOfCode do
  @shortdoc "Execute Advent of Code excercise"
  @moduledoc """
  Runs solution for particular day of Advent of Code challenge

  ## Command line options

    * `--year / -y <NUM>` - which year to run (default 2021)
    * `--day / -d <NUM>` - which day to run (required)
    * `--part1` - execute first part of the solution
    * `--part2` - execute second part of the solution
  """
  use Mix.Task

  @strict [year: :integer, day: :integer, part1: :boolean, part2: :boolean]
  @aliases [y: :year, d: :day]

  @impl Mix.Task
  def run(args) do
    {opts, [], []} = OptionParser.parse(args, strict: @strict, aliases: @aliases)
    year = Keyword.get(opts, :year, 2021)
    day = opts |> Keyword.get(:day) |> Integer.to_string() |> String.pad_leading(2, "0")

    module = :"Elixir.AdventOfCode.Year#{year}.Day#{day}"

    case Code.ensure_compiled(module) do
      {:module, _} ->
        if Keyword.get(opts, :part1, false), do: run_part(module, 1)
        if Keyword.get(opts, :part2, false), do: run_part(module, 2)

      {:error, _} ->
        IO.puts("\n#{IO.ANSI.red()}Year #{year}, day #{day} not implemented!#{IO.ANSI.reset()}")
    end
  end

  defp run_part(module, part) do
    IO.puts("\n#{IO.ANSI.bright()}#{IO.ANSI.blue()}Part #{part}#{IO.ANSI.reset()}")

    {time, solution} = :timer.tc(fn -> apply(module, :"part#{part}", []) end)

    if is_binary(solution), do: IO.puts(solution), else: IO.inspect(solution)
    IO.puts("#{IO.ANSI.light_black()}#{div(time, 1000)} ms#{IO.ANSI.reset()}\n")
  end
end

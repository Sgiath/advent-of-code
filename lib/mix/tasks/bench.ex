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
        case module.bench() do
          config when is_map(config) -> do_bench(config, module)
          config when is_list(config) -> Enum.each(config, &do_bench(&1, module))
        end

      {:error, _} ->
        IO.puts("\n#{IO.ANSI.red()}Year #{year}, day #{day} not implemented!#{IO.ANSI.reset()}")
    end
  end

  defp do_bench(config, module) do
    IO.puts("\n#{IO.ANSI.yellow()}Running benchmark...#{IO.ANSI.reset()}")

    Benchee.run(
      config,
      time: 10,
      inputs: %{"base" => module.input()},
      print: %{
        benchmarking: false,
        configuration: false
      },
      unit_scaling: :smallest,
      formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
    )

    IO.puts("")
  end
end

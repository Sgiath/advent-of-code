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
    {year, day, module} = parse_args(args)

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

  def parse_args(args) do
    opts = args |> OptionParser.parse(strict: @strict, aliases: @aliases) |> elem(0)

    year = Keyword.get(opts, :year, 2021)
    day = opts |> Keyword.get(:day) |> Integer.to_string() |> String.pad_leading(2, "0")

    {year, day, String.to_existing_atom("Elixir.AdventOfCode.Year#{year}.Day#{day}")}
  end

  defp do_bench(config, module) do
    IO.puts("\n#{IO.ANSI.yellow()}Running benchmark...#{IO.ANSI.reset()}")

    Benchee.run(
      config,
      time: 10,
      inputs: %{"test" => module.test_input(), "task" => module.input()},
      print: %{
        benchmarking: false,
        configuration: false
      },
      unit_scaling: :smallest
    )
  end
end

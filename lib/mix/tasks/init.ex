defmodule Mix.Tasks.AdventOfCode.Init do
  @shortdoc "Initialize Advent of Code exercise"
  @moduledoc ~S"""
  Runs solution for particular day of Advent of Code challenge

  This script requires correct session cookie in your config. You can obtain it by going to
  https://aventofcode.com, logging in and than press F12 to open devtools. Than go to
  "Application" tab, expand "Cookies" menu on the left and click on "https://adventofcode.com".
  Here you should see cookie with name "session", copy the value and paste it to the
  `config/secret.exs` file:

      config :advent_of_code, session_id: "<your-session-cookie-here>"

  The cookie should be valid for about a month so you have to do this just once in a year. Do not
  commit the cookie since it basically acts as your login information for the site (much safer but
  still - do not share it).

  ## Command line options

    * `--year / -y <NUM>` - which year to run (default current year)
    * `--day / -d <NUM>` - which day to run (default current day of month)
  """
  use Mix.Task

  alias AdventOfCode.Utils

  @strict [year: :integer, day: :integer]
  @aliases [y: :year, d: :day]

  @template_path Path.join([File.cwd!(), "priv", "template.eex"])
  @test_path Path.join([File.cwd!(), "priv", "template_test.eex"])
  @livebook_path Path.join([File.cwd!(), "priv", "template.livemd"])

  @impl Mix.Task
  def run(args) do
    {year, day} =
      args
      |> OptionParser.parse(strict: @strict, aliases: @aliases)
      |> elem(0)
      |> parse_args()

    # create folders
    File.mkdir_p!(Path.join([File.cwd!(), "lib", year]))
    File.mkdir_p!(Path.join([File.cwd!(), "test", year]))
    File.mkdir_p!(Path.join([File.cwd!(), "livebook", year]))

    # write file with script template
    generate_file([File.cwd!(), "lib", year, "day#{day}.ex"], @template_path, year, day)
    generate_file([File.cwd!(), "test", year, "day#{day}_test.exs"], @test_path, year, day)
    generate_file([File.cwd!(), "livebook", year, "day#{day}.livemd"], @livebook_path, year, day)

    # write file with input data
    Utils.save_input(year, day)
  end

  defp parse_args(args) do
    year = args |> Keyword.get(:year, Utils.default_year()) |> Integer.to_string()

    day =
      args
      |> Keyword.get(:day, Date.utc_today().day)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    {year, day}
  end

  defp generate_file(path, template, year, day) do
    path = Path.join(path)

    unless File.exists?(path) do
      File.open(
        path,
        [:write, :utf8],
        &IO.write(&1, EEx.eval_file(template, year: year, day: day))
      )
    end
  end
end

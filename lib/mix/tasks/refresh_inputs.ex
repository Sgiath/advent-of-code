defmodule Mix.Tasks.AdventOfCode.RefreshInputs do
  @shortdoc "Refresh all Advent of Code excercise inputs"
  @moduledoc """
  Redownloads all input files from previous years with you COOKIE file
  """
  use Mix.Task

  alias AdventOfCode.Utils

  @impl Mix.Task
  def run(_args) do
    for year <- 2015..2020,
        day <- 1..25 do
      Utils.save_input(
        Integer.to_string(year),
        day |> Integer.to_string() |> String.pad_leading(2, "0")
      )
    end
  end
end

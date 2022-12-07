defmodule Mix.Tasks.AdventOfCode.RefreshInputs do
  @shortdoc "Refresh all Advent of Code exercise inputs"
  @moduledoc ~S"""
  Re-downloads all input files from previous years
  """
  use Mix.Task

  alias AdventOfCode.Utils

  @impl Mix.Task
  def run(_args) do
    for year <- 2015..2021,
        day <- 1..25 do
      Utils.save_input(year, day)
    end
  end
end

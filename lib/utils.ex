defmodule AdventOfCode.Utils do
  @moduledoc ~S"""
  Util functions around interacting with Advent of Code API
  """

  @session_id Application.compile_env(:advent_of_code, :session_id)

  @doc ~S"""
  Download input file and save it as file
  """
  def save_input(year, day) do
    dir = Path.join([File.cwd!(), "priv", year])
    File.mkdir_p!(dir)

    [dir, "day#{day}.in"]
    |> Path.join()
    |> File.open([:write, :utf8], &IO.write(&1, get_input(year, day)))
  end

  @doc ~S"""
  Download input file and return it as string
  """
  def get_input(year, day) do
    request = {input_url(year, day), [{'Cookie', String.to_charlist("session=#{@session_id}")}]}

    {:ok, {_status, _headers, input_data}} =
      :httpc.request(:get, request, [], verify: :verify_none)

    input_data
  end

  @doc ~S"""
  Format input URL
  """
  def input_url(year, day) do
    "http://adventofcode.com/#{year}/day/#{String.to_integer(day)}/input"
  end
end

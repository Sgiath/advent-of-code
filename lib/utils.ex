defmodule AdventOfCode.Utils do
  @moduledoc """
  Util functions around interacting with Advent of Code API
  """

  @cookie_path Path.join([File.cwd!(), "priv", "COOKIE"])

  @doc """
  Download input file and save it as file
  """
  def save_input(year, day) do
    [File.cwd!(), "priv", year, "day#{day}.in"]
    |> Path.join()
    |> File.open([:write, :utf8], &IO.write(&1, get_input(year, day)))
  end

  @doc """
  Download input file and return it as string
  """
  def get_input(year, day) do
    cookie = String.to_charlist("session=#{File.read!(@cookie_path)}")
    request = {input_url(year, day), [{'Cookie', cookie}]}

    {:ok, {_status, _headers, input_data}} = :httpc.request(:get, request, [], [])

    input_data
  end

  @doc """
  Format input URL
  """
  def input_url(year, day) do
    "http://adventofcode.com/#{year}/day/#{String.to_integer(day)}/input"
  end
end

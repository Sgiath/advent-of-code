defmodule AdventOfCode.Utils do
  @moduledoc ~S"""
  Util functions around interacting with Advent of Code API
  """

  @doc ~S"""
  Download input file and save it as file
  """
  def save_input(year, day) when is_integer(year) or is_integer(day) do
    year = Integer.to_string(year)
    day = day |> Integer.to_string() |> String.pad_leading(2, "0")

    save_input(year, day)
  end

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
    session_id = Application.get_env(:advent_of_code, :session_id)
    headers = [cookie: "session=#{session_id}"]
    url = input_url(year, day)

    Req.request!(url: url, headers: headers).body
  end

  @doc ~S"""
  Format input URL
  """
  def input_url(year, day) do
    "https://adventofcode.com/#{year}/day/#{String.to_integer(day)}/input"
  end

  def default_year do
    if Date.utc_today().month < 12 do
      Date.utc_today().year - 1
    else
      Date.utc_today().year
    end
  end

  @doc ~S"""
  Range helper to avoid stupid warnings
  """
  def range(start, stop) when start <= stop, do: start..stop
  def range(start, stop) when start > stop, do: start..stop//-1
end

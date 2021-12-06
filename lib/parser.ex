defmodule AdventOfCode.Parser do
  def lines(data, splitter \\ "\n", parser \\ &String.to_integer/1) do
    data
    |> String.split(splitter, trim: true)
    |> Enum.map(parser)
  end

  def intcode(data), do: lines(data, [",", "\n"])
end

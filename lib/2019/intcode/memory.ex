defmodule AdventOfCode.Year2019.Intcode.Memory do
  @moduledoc false

  @type memory() :: :array.array(integer())

  @doc """
  Get value from memory on position
  """
  @spec get_value(memory(), integer()) :: integer()
  def get_value(memory, position) do
    position
    |> :array.get(memory)
    |> normalize()
  end

  @doc """
  Set value in memory on position
  """
  @spec set_value(memory(), integer(), integer()) :: memory()
  def set_value(memory, position, value) do
    position
    |> :array.set(value, memory)
  end

  defp normalize(:undefined), do: 0
  defp normalize(val), do: val
end

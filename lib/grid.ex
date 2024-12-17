defmodule AdventOfCode.Grid do
  use TypedStruct

  typedstruct do
    field :data, :array.t()
    field :size, {integer(), integer()}
    field :pallete, map()
  end

  @default_pallete %{
    ?# => :wall,
    ?. => :empty
  }

  def default_pallete, do: @default_pallete

  def parse(data, pallete \\ @default_pallete) do
    grid =
      data
      |> String.split(["\n"], trim: true)
      |> Enum.map(&String.to_charlist/1)

    sx = length(hd(grid))
    sy = length(grid)

    grid =
      grid
      |> List.flatten()
      |> Enum.map(&pallete[&1])
      |> :array.from_list()
      |> :array.fix()

    reverse_pallete =
      pallete
      |> Enum.map(fn {key, val} -> {val, key} end)
      |> Enum.into(%{})

    %__MODULE__{
      data: grid,
      size: {sx, sy},
      pallete: reverse_pallete
    }
  end

  def get(%__MODULE__{size: {sx, _sy}}, {x, _y}) when x >= sx, do: :out_of_bounds
  def get(%__MODULE__{size: {_sx, sy}}, {_x, y}) when y >= sy, do: :out_of_bounds

  def get(%__MODULE__{data: data, size: {_sx, sy}}, {x, y}) do
    :array.get(y * sy + x, data)
  end

  def set(%__MODULE__{size: {sx, _sy}}, {x, _y}, _val) when x >= sx, do: :out_of_bounds
  def set(%__MODULE__{size: {_sx, sy}}, {_x, y}, _val) when y >= sy, do: :out_of_bounds

  def set(%__MODULE__{data: data, size: {sx, _sy}} = grid, {x, y}, val) do
    %__MODULE__{grid | data: :array.set(y * sx + x, val, data)}
  end

  def find(%__MODULE__{data: data, size: {sx, _sy}}, val) do
    data
    |> :array.to_list()
    |> Enum.find_index(&(&1 == val))
    |> case do
      nil -> :not_found
      i -> {rem(i, sx), div(i, sx)}
    end
  end

  def print(%__MODULE__{data: data, size: {sx, _sy}, pallete: pallete}) do
    data
    |> :array.to_list()
    |> Enum.map(&pallete[&1])
    |> Enum.chunk_every(sx)
    |> Enum.intersperse("\n")
    |> IO.chardata_to_string()
    |> IO.puts()
  end
end

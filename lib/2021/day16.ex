defmodule AdventOfCode.Year2021.Day16 do
  @moduledoc """
  https://adventofcode.com/2021/day/16
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    D8005AC2A8F0
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day16.in"])
    |> File.read!()
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> sum_versions()
  end

  @doc """
  Sum version numbers of all packets

  ## Example

      iex> AdventOfCode.Year2021.Day16.sum_versions({1, nil, [{2, nil, nil}, {3, nil, nil}]})
      6
  """
  def sum_versions(packet, acc \\ 0)

  def sum_versions({ver, _type, value}, acc) when is_list(value) do
    value
    |> Enum.map(&sum_versions/1)
    |> Enum.sum()
    |> Kernel.+(ver)
    |> Kernel.+(acc)
  end

  def sum_versions({ver, _type, _value}, acc), do: ver + acc

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> evaluate()
  end

  @doc """
  Evaluate the packets

  ## Example

      iex> AdventOfCode.Year2021.Day16.evaluate({nil, 0, [{nil, 4, 2}, {nil, 4, 8}]})
      10
      iex> AdventOfCode.Year2021.Day16.evaluate({nil, 1, [{nil, 4, 2}, {nil, 4, 8}]})
      16
      iex> AdventOfCode.Year2021.Day16.evaluate({nil, 2, [{nil, 4, 2}, {nil, 4, 8}]})
      2
      iex> AdventOfCode.Year2021.Day16.evaluate({nil, 3, [{nil, 4, 2}, {nil, 4, 8}]})
      8
      iex> AdventOfCode.Year2021.Day16.evaluate({nil, 4, 5})
      5
      iex> AdventOfCode.Year2021.Day16.evaluate({nil, 5, [{nil, 4, 2}, {nil, 4, 8}]})
      1
      iex> AdventOfCode.Year2021.Day16.evaluate({nil, 6, [{nil, 4, 2}, {nil, 4, 8}]})
      0
      iex> AdventOfCode.Year2021.Day16.evaluate({nil, 7, [{nil, 4, 2}, {nil, 4, 8}]})
      0
  """
  def evaluate({_ver, 0, packets}), do: packets |> Enum.map(&evaluate/1) |> Enum.sum()
  def evaluate({_ver, 1, packets}), do: packets |> Enum.map(&evaluate/1) |> Enum.product()
  def evaluate({_ver, 2, packets}), do: packets |> Enum.map(&evaluate/1) |> Enum.min()
  def evaluate({_ver, 3, packets}), do: packets |> Enum.map(&evaluate/1) |> Enum.max()
  def evaluate({_ver, 4, number}), do: number
  def evaluate({_ver, 5, [p1, p2]}), do: if(evaluate(p2) > evaluate(p1), do: 1, else: 0)
  def evaluate({_ver, 6, [p1, p2]}), do: if(evaluate(p2) < evaluate(p1), do: 1, else: 0)
  def evaluate({_ver, 7, [p1, p2]}), do: if(evaluate(p1) == evaluate(p2), do: 1, else: 0)

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Parse input string into packet representation
  """
  def parse(input) do
    input
    |> String.trim_trailing("\n")
    |> Base.decode16!()
    |> parse_packet()
    |> List.first()
  end

  @doc """
  Parse packet and return it with the rest of the input

  ## Examples

      iex> AdventOfCode.Year2021.Day16.parse_packet(<<0b1111001011001100000::19>>)
      [{7, 4, 0b01101100}, <<0::3>>]
  """
  def parse_packet(<<ver::3, 4::3, data::bitstring>>) do
    data
    |> parse_number()
    |> then(fn {value, rest} -> [{ver, 0b100, value}, rest] end)
  end

  def parse_packet(<<ver::3, type::3, 0::1, bits::15, data::bitstring>>) do
    data
    |> parse_subpacket({:bits, bits})
    |> then(fn {value, rest} -> [{ver, type, value}, rest] end)
  end

  def parse_packet(<<ver::3, type::3, 1::1, count::11, data::bitstring>>) do
    data
    |> parse_subpacket({:count, count})
    |> then(fn {value, rest} -> [{ver, type, value}, rest] end)
  end

  @doc """
  Parse number data

  ## Examples

      iex> AdventOfCode.Year2021.Day16.parse_number(<<0b1011001100::10>>)
      {0b01101100, <<>>}
      iex> AdventOfCode.Year2021.Day16.parse_number(<<0b101101011101100::15>>)
      {0b011001111100, <<>>}
  """
  def parse_number(data, acc \\ {<<>>, 0})

  def parse_number(<<0::1, bits::4, rest::bitstring>>, {acc, size}) do
    size = size + 4
    <<number::integer-size(size)>> = <<acc::bitstring, bits::4>>
    {number, rest}
  end

  def parse_number(<<1::1, bits::4, rest::bitstring>>, {acc, size}) do
    parse_number(rest, {<<acc::bitstring, bits::4>>, size + 4})
  end

  @doc """
  Parse subpacket data
  """
  def parse_subpacket(data, packet_type, acc \\ [])
  def parse_subpacket(data, {_type, 0}, acc), do: {acc, data}

  def parse_subpacket(data, {:count, count}, acc) do
    [packet, rest] = parse_packet(data)

    parse_subpacket(rest, {:count, count - 1}, [packet | acc])
  end

  def parse_subpacket(data, {:bits, bits}, acc) do
    [packet, rest] = parse_packet(data)
    data_len = bit_size(data) - bit_size(rest)

    parse_subpacket(rest, {:bits, bits - data_len}, [packet | acc])
  end
end

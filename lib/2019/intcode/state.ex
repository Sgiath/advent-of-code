defmodule AdventOfCode.Year2019.Intcode.State do
  @moduledoc false
  use TypedStruct

  alias __MODULE__
  alias AdventOfCode.Year2019.Intcode.Memory

  require Logger

  @type mode() :: :position | :immediate | :relative

  @type opcode() ::
          :add
          | :multiply
          | :input
          | :output
          | :jump_true
          | :jump_false
          | :less_then
          | :equals
          | :adjust_rb
          | :halt

  typedstruct do
    field :memory, Memory.memory()
    field :opcode, opcode()
    field :instruction_pointer, non_neg_integer(), default: 0
    field :relative_base, non_neg_integer(), default: 0
    field :io_service, {pid() | nil, pid() | nil, pid() | nil}, default: {nil, nil, nil}
    field :arg1, non_neg_integer()
    field :arg1_value, integer()
    field :arg1_mode, mode()
    field :arg2, non_neg_integer()
    field :arg2_value, integer()
    field :arg2_mode, mode()
    field :arg3, non_neg_integer()
    field :arg3_value, integer()
    field :arg3_mode, mode()
  end

  @spec reset(t()) :: t()
  def reset(%State{} = state) do
    %State{state | opcode: nil, arg1: nil, arg2: nil, arg3: nil}
  end

  @spec next_instruction(t()) :: t()
  def next_instruction(%State{instruction_pointer: ip} = state) do
    %State{state | instruction_pointer: ip + 1}
  end

  @spec load_opcode(t()) :: t()
  def load_opcode(%State{memory: memory, instruction_pointer: ip} = state) do
    %State{state | opcode: get_opcode(memory, ip)}
  end

  @spec load_modes(t()) :: t()
  def load_modes(%State{memory: memory, instruction_pointer: ip} = state) do
    [mode1, mode2, mode3] = get_modes(memory, ip)

    %State{state | arg1_mode: mode1, arg2_mode: mode2, arg3_mode: mode3}
  end

  @spec load_arg1(t()) :: t()
  def load_arg1(%State{} = state) do
    state
    |> load_arg1_addr()
    |> load_arg1_value()
  end

  defp load_arg1_addr(%State{memory: memory, instruction_pointer: ip} = state) do
    %State{state | arg1: Memory.get_value(memory, ip)}
  end

  defp load_arg1_value(%State{memory: memory, arg1: arg1, arg1_mode: :position} = state) do
    %State{state | arg1_value: Memory.get_value(memory, arg1)}
  end

  defp load_arg1_value(%State{arg1: arg1, arg1_mode: :immediate} = state) do
    %State{state | arg1_value: arg1}
  end

  defp load_arg1_value(
         %State{memory: memory, relative_base: rb, arg1: arg1, arg1_mode: :relative} = state
       ) do
    %State{state | arg1: arg1 + rb, arg1_value: Memory.get_value(memory, rb + arg1)}
  end

  @spec load_arg2(t()) :: t()
  def load_arg2(%State{} = state) do
    state
    |> load_arg2_addr()
    |> load_arg2_value()
  end

  defp load_arg2_addr(%State{memory: memory, instruction_pointer: ip} = state) do
    %State{state | arg2: Memory.get_value(memory, ip)}
  end

  defp load_arg2_value(%State{memory: memory, arg2: arg2, arg2_mode: :position} = state) do
    %State{state | arg2_value: Memory.get_value(memory, arg2)}
  end

  defp load_arg2_value(%State{arg2: arg2, arg2_mode: :immediate} = state) do
    %State{state | arg2_value: arg2}
  end

  defp load_arg2_value(
         %State{memory: memory, relative_base: rb, arg2: arg2, arg2_mode: :relative} = state
       ) do
    %State{state | arg2: arg2 + rb, arg2_value: Memory.get_value(memory, rb + arg2)}
  end

  @spec load_arg3(t()) :: t()
  def load_arg3(%State{} = state) do
    state
    |> load_arg3_addr()
    |> load_arg3_value()
  end

  defp load_arg3_addr(%State{memory: memory, instruction_pointer: ip} = state) do
    %State{state | arg3: Memory.get_value(memory, ip)}
  end

  defp load_arg3_value(%State{memory: memory, arg3: arg3, arg3_mode: :position} = state) do
    %State{state | arg3_value: Memory.get_value(memory, arg3)}
  end

  defp load_arg3_value(%State{arg3: arg3, arg3_mode: :immediate} = state) do
    %State{state | arg3_value: arg3}
  end

  defp load_arg3_value(
         %State{memory: memory, relative_base: rb, arg3: arg3, arg3_mode: :relative} = state
       ) do
    %State{state | arg3: arg3 + rb, arg3_value: Memory.get_value(memory, rb + arg3)}
  end

  @doc """
  iex> AdventOfCode.Intcode3.State.get_opcode(:array.from_list([203]), 0)
  :input
  """
  @spec get_opcode(Memory.memory(), non_neg_integer()) :: opcode()
  def get_opcode(memory, ip) do
    memory
    |> Memory.get_value(ip)
    |> rem(100)
    |> opcode_decode()
  end

  defp opcode_decode(1), do: :add
  defp opcode_decode(2), do: :multiply
  defp opcode_decode(3), do: :input
  defp opcode_decode(4), do: :output
  defp opcode_decode(5), do: :jump_true
  defp opcode_decode(6), do: :jump_false
  defp opcode_decode(7), do: :less_then
  defp opcode_decode(8), do: :equals
  defp opcode_decode(9), do: :adjust_rb
  defp opcode_decode(99), do: :halt

  defp get_modes(memory, ip) do
    memory
    |> Memory.get_value(ip)
    |> div(100)
    |> Integer.to_string()
    |> String.pad_leading(3, "0")
    |> String.graphemes()
    |> Enum.map(fn
      "0" -> :position
      "1" -> :immediate
      "2" -> :relative
    end)
    |> Enum.reverse()
  end
end

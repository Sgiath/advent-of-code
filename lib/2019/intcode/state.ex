defmodule AdventOfCode.Year2019.Intcode.State do
  @moduledoc false
  use TypedStruct

  alias __MODULE__
  alias AdventOfCode.Year2019.Intcode.Memory

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

  @type io_service :: {input :: pid() | nil, output :: pid() | nil, secondary :: pid() | nil}

  typedstruct do
    field :memory, Memory.memory()
    field :opcode, opcode()
    field :instruction_pointer, non_neg_integer(), default: 0
    field :relative_base, non_neg_integer(), default: 0
    field :io_service, io_service(), default: {nil, nil, nil}
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

  @doc """
  Fetch a complete instruction: decode opcode, modes, and all arguments at once.
  This is more efficient than loading arguments one by one.
  """
  @spec fetch_instruction(t()) :: t()
  def fetch_instruction(
        %State{memory: memory, instruction_pointer: ip, relative_base: rb} = state
      ) do
    raw = Memory.get_value(memory, ip)
    opcode = opcode_decode(rem(raw, 100))
    [mode1, mode2, mode3] = decode_modes(raw)

    case instruction_arity(opcode) do
      0 ->
        # halt - no arguments
        %State{state | opcode: opcode, instruction_pointer: ip + 1}

      1 ->
        # input, output, adjust_rb - one argument
        {arg1, arg1_value} = fetch_arg(memory, ip + 1, mode1, rb)

        %State{
          state
          | opcode: opcode,
            instruction_pointer: ip + 2,
            arg1: arg1,
            arg1_value: arg1_value,
            arg1_mode: mode1
        }

      2 ->
        # jump_true, jump_false - two arguments
        {arg1, arg1_value} = fetch_arg(memory, ip + 1, mode1, rb)
        {arg2, arg2_value} = fetch_arg(memory, ip + 2, mode2, rb)

        %State{
          state
          | opcode: opcode,
            instruction_pointer: ip + 3,
            arg1: arg1,
            arg1_value: arg1_value,
            arg1_mode: mode1,
            arg2: arg2,
            arg2_value: arg2_value,
            arg2_mode: mode2
        }

      3 ->
        # add, multiply, less_then, equals - three arguments
        {arg1, arg1_value} = fetch_arg(memory, ip + 1, mode1, rb)
        {arg2, arg2_value} = fetch_arg(memory, ip + 2, mode2, rb)
        {arg3, arg3_value} = fetch_arg(memory, ip + 3, mode3, rb)

        %State{
          state
          | opcode: opcode,
            instruction_pointer: ip + 4,
            arg1: arg1,
            arg1_value: arg1_value,
            arg1_mode: mode1,
            arg2: arg2,
            arg2_value: arg2_value,
            arg2_mode: mode2,
            arg3: arg3,
            arg3_value: arg3_value,
            arg3_mode: mode3
        }
    end
  end

  # Returns the number of arguments for each opcode
  defp instruction_arity(:halt), do: 0
  defp instruction_arity(:input), do: 1
  defp instruction_arity(:output), do: 1
  defp instruction_arity(:adjust_rb), do: 1
  defp instruction_arity(:jump_true), do: 2
  defp instruction_arity(:jump_false), do: 2
  defp instruction_arity(:add), do: 3
  defp instruction_arity(:multiply), do: 3
  defp instruction_arity(:less_then), do: 3
  defp instruction_arity(:equals), do: 3

  # Fetch a single argument, returning both address and value
  defp fetch_arg(memory, addr, :position, _rb) do
    raw = Memory.get_value(memory, addr)
    {raw, Memory.get_value(memory, raw)}
  end

  defp fetch_arg(memory, addr, :immediate, _rb) do
    raw = Memory.get_value(memory, addr)
    {raw, raw}
  end

  defp fetch_arg(memory, addr, :relative, rb) do
    raw = Memory.get_value(memory, addr)
    {raw + rb, Memory.get_value(memory, rb + raw)}
  end

  # Decode modes from raw instruction value using integer math (faster than string manipulation)
  defp decode_modes(raw) do
    mode_bits = div(raw, 100)

    [
      decode_mode(rem(mode_bits, 10)),
      decode_mode(rem(div(mode_bits, 10), 10)),
      decode_mode(div(mode_bits, 100))
    ]
  end

  defp decode_mode(0), do: :position
  defp decode_mode(1), do: :immediate
  defp decode_mode(2), do: :relative

  # Opcode decoding
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
end

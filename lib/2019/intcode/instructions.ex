defmodule AdventOfCode.Year2019.Intcode.Instructions do
  @moduledoc false

  alias AdventOfCode.Year2019.Intcode.IO
  alias AdventOfCode.Year2019.Intcode.Memory
  alias AdventOfCode.Year2019.Intcode.State

  require Logger

  @spec add(State.t()) :: State.t()
  def add(%State{memory: memory, arg1_value: arg1, arg2_value: arg2, arg3: arg3} = state) do
    %State{state | memory: Memory.set_value(memory, arg3, arg1 + arg2)}
  end

  @spec multiply(State.t()) :: State.t()
  def multiply(%State{memory: memory, arg1_value: arg1, arg2_value: arg2, arg3: arg3} = state) do
    %State{state | memory: Memory.set_value(memory, arg3, arg1 * arg2)}
  end

  @spec input(State.t()) :: State.t()
  def input(%State{io_service: {nil, _, _}}), do: raise("Invalid state")

  def input(%State{memory: memory, arg1: arg1, io_service: {input, _, _}} = state) do
    input = IO.get_input(input)

    %State{state | memory: Memory.set_value(memory, arg1, input)}
  end

  @spec output(State.t()) :: State.t()
  def output(%State{io_service: {_, nil, _}}), do: raise("Invalid state")

  def output(%State{arg1_value: arg1, io_service: {_, output, secondary}} = state) do
    IO.set_output(output, arg1, secondary)

    state
  end

  @spec jump_true(State.t()) :: State.t()
  def jump_true(%State{arg1_value: 0} = state), do: state
  def jump_true(%State{arg2_value: arg2} = state), do: %State{state | instruction_pointer: arg2}

  @spec jump_false(State.t()) :: State.t()
  def jump_false(%State{arg1_value: 0, arg2_value: arg2} = state),
    do: %State{state | instruction_pointer: arg2}

  def jump_false(%State{} = state), do: state

  @spec less_then(State.t()) :: State.t()
  def less_then(%State{memory: memory, arg1_value: arg1, arg2_value: arg2, arg3: arg3} = state)
      when arg1 < arg2 do
    %State{state | memory: Memory.set_value(memory, arg3, 1)}
  end

  def less_then(%State{memory: memory, arg3: arg3} = state) do
    %State{state | memory: Memory.set_value(memory, arg3, 0)}
  end

  @spec equals(State.t()) :: State.t()
  def equals(%State{memory: memory, arg1_value: arg1, arg2_value: arg2, arg3: arg3} = state)
      when arg1 == arg2 do
    %State{state | memory: Memory.set_value(memory, arg3, 1)}
  end

  def equals(%State{memory: memory, arg3: arg3} = state) do
    %State{state | memory: Memory.set_value(memory, arg3, 0)}
  end

  @spec adjust_rb(State.t()) :: State.t()
  def adjust_rb(%State{relative_base: rb, arg1_value: arg1} = state) do
    %State{state | relative_base: rb + arg1}
  end
end

defmodule AdventOfCode.Year2024.Day17 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/17
  """
  use AdventOfCode, year: 2024, day: 17
  use TypedStruct

  import Bitwise

  typedstruct module: State, enforce: true do
    field :memory, [integer()]
    field :memory_size, integer()
    field :register_a, integer()
    field :register_b, integer()
    field :register_c, integer()
    field :instruction_pointer, integer(), default: 0
    field :output, [integer()], default: []
    field :output_size, integer(), default: 0
    field :halted, boolean(), default: false
    field :output_check, boolean(), default: false
  end

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Register A: 2024
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
    """
  end

  def parse(input) do
    [registers, "Program: " <> memory] = String.split(input, ["\n\n"], trim: true)

    {a, b, c} = parse_registers(registers)
    memory = parse_memory(memory)
    size = :array.size(memory)

    memory = :array.set(size, :halt, memory)
    memory = :array.set(size + 1, :halt, memory)

    %State{
      register_a: a,
      register_b: b,
      register_c: c,
      memory_size: size,
      memory: :array.fix(memory)
    }
  end

  def parse_memory(data) do
    data
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list()
  end

  def parse_registers(data) do
    [
      "Register A: " <> a,
      "Register B: " <> b,
      "Register C: " <> c
    ] = String.split(data, ["\n"], trim: true)

    {String.to_integer(a), String.to_integer(b), String.to_integer(c)}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> run()
    |> then(fn %State{output: output} ->
      output
      |> Enum.reverse()
      |> Enum.join(",")
    end)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    state = parse(input)
    find_a(%{state | output_check: true}, 0)
  end

  def find_a(%State{} = state, a) do
    new_state = run(%{state | register_a: a})

    if state.memory_size == new_state.output_size do
      a
    else
      find_a(state, a + 1)
    end
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def run(%State{halted: true} = state), do: state

  def run(%State{memory: memory, instruction_pointer: ip} = state) do
    inst = :array.get(ip, memory)
    op = :array.get(ip + 1, memory)

    state
    |> instruction(inst, op)
    |> run()
  end

  def instruction(%State{} = state, :halt, _op), do: %{state | halted: true}

  # adv instruction
  def instruction(%State{register_a: a} = state, 0, op) do
    val = combo(state, op)
    next_ip(%{state | register_a: floor(a / 2 ** val)})
  end

  # bxl instruction
  def instruction(%State{register_b: b} = state, 1, op) do
    next_ip(%{state | register_b: bxor(b, op)})
  end

  # bst instruction
  def instruction(%State{} = state, 2, op) do
    val = combo(state, op)
    next_ip(%{state | register_b: rem(val, 8)})
  end

  # jnz instruction
  def instruction(%State{register_a: 0} = state, 3, _op), do: next_ip(state)
  def instruction(%State{register_a: _a} = state, 3, op), do: %{state | instruction_pointer: op}

  # bxc instruction
  def instruction(%State{register_b: b, register_c: c} = state, 4, _op) do
    next_ip(%{state | register_b: bxor(b, c)})
  end

  # out instruction
  def instruction(%State{output: output, output_check: false} = state, 5, op) do
    val = combo(state, op)
    next_ip(%{state | output: [rem(val, 8) | output]})
  end

  # out instruction that exists if the output does not match memory
  def instruction(%State{output: output, output_size: s, memory: mem} = state, 5, op) do
    val = combo(state, op)
    res = rem(val, 8)

    if :array.get(s, mem) == res do
      next_ip(%{state | output: [res | output], output_size: s + 1})
    else
      %{state | halted: true}
    end
  end

  # bdv instruction
  def instruction(%State{register_a: a} = state, 6, op) do
    val = combo(state, op)
    next_ip(%{state | register_b: floor(a / 2 ** val)})
  end

  # cdv instruction
  def instruction(%State{register_a: a} = state, 7, op) do
    val = combo(state, op)
    next_ip(%{state | register_c: floor(a / 2 ** val)})
  end

  def combo(%State{}, 0), do: 0
  def combo(%State{}, 1), do: 1
  def combo(%State{}, 2), do: 2
  def combo(%State{}, 3), do: 3
  def combo(%State{register_a: a}, 4), do: a
  def combo(%State{register_b: b}, 5), do: b
  def combo(%State{register_c: c}, 6), do: c
  def combo(%State{}, 7), do: raise("Reserved combo value")

  def next_ip(%State{instruction_pointer: ip} = state), do: %{state | instruction_pointer: ip + 2}
end

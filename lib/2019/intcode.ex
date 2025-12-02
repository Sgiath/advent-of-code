defmodule AdventOfCode.Year2019.Intcode do
  @moduledoc """
  Intcode interpreter for Advent of Code 2019.

  Provides two execution modes:
  1. Functional (synchronous) - for simple programs without complex I/O
  2. GenServer (async) - for process-based I/O and feedback loops

  ## Functional API

      # Run with inputs, get outputs
      {:ok, outputs, state} = Intcode.run(memory, inputs: [1, 2])

      # Run without I/O (Day 02 style)
      {:ok, [], state} = Intcode.run(memory)

  ## GenServer API

      # Start a process-based interpreter
      pid = Intcode.start_link(memory, input_pid, output_pid)
      Intcode.run_program_async(pid)
  """

  use GenServer

  alias __MODULE__
  alias __MODULE__.Instructions
  alias __MODULE__.Memory
  alias __MODULE__.State

  # =============================================================================
  # Functional API (synchronous, no GenServer overhead)
  # =============================================================================

  @doc """
  Run an Intcode program synchronously without GenServer.

  ## Options
    - `:inputs` - list of input values to provide (default: [])

  ## Returns
    - `{:ok, outputs, final_state}` on successful completion
    - `{:error, reason}` if program needs more input than provided

  ## Examples

      iex> Intcode.run([1,0,0,0,99])
      {:ok, [], %State{...}}

      iex> Intcode.run([3,0,4,0,99], inputs: [42])
      {:ok, [42], %State{...}}
  """
  @spec run(list(integer()), keyword()) :: {:ok, list(integer()), State.t()} | {:error, term()}
  def run(memory, opts \\ []) do
    inputs = Keyword.get(opts, :inputs, [])

    state = %State{
      memory: :array.from_list(memory),
      io_service: {:functional, inputs, []}
    }

    case run_functional(state) do
      {:ok, %State{io_service: {:functional, _, outputs}} = final_state} ->
        {:ok, Enum.reverse(outputs), final_state}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Run program and collect outputs - simpler interface when you just need outputs.

  ## Examples

      iex> Intcode.run_collecting([104,42,104,99,99], inputs: [])
      [42, 99]

      iex> Intcode.run_collecting([3,0,4,0,99], inputs: [5])
      [5]
  """
  @spec run_collecting(list(integer()), keyword()) :: list(integer())
  def run_collecting(memory, opts \\ []) do
    case run(memory, opts) do
      {:ok, outputs, _state} -> outputs
      {:error, reason} -> raise "Intcode execution failed: #{inspect(reason)}"
    end
  end

  @doc """
  Run program and return final memory value at position 0.
  Useful for Day 02 style puzzles.

  ## Examples

      iex> Intcode.run_and_get_result([1,0,0,0,99])
      2
  """
  @spec run_and_get_result(list(integer()), keyword()) :: integer()
  def run_and_get_result(memory, opts \\ []) do
    case run(memory, opts) do
      {:ok, _outputs, %State{memory: mem}} -> Memory.get_value(mem, 0)
      {:error, reason} -> raise "Intcode execution failed: #{inspect(reason)}"
    end
  end

  @doc """
  Run program with callback-based I/O for more complex scenarios.

  ## Options
    - `:input_fn` - function that returns the next input value (called when input needed)
    - `:output_fn` - function that receives each output value

  ## Examples

      counter = :counters.new(1, [:atomics])
      Intcode.run_with_io(memory,
        input_fn: fn -> :counters.get(counter, 1) end,
        output_fn: fn val -> IO.puts("Output: \#{val}") end
      )
  """
  @spec run_with_io(list(integer()), keyword()) :: {:ok, State.t()} | {:error, term()}
  def run_with_io(memory, opts \\ []) do
    input_fn = Keyword.get(opts, :input_fn, fn -> raise "No input function provided" end)
    output_fn = Keyword.get(opts, :output_fn, fn _ -> :ok end)

    state = %State{
      memory: :array.from_list(memory),
      io_service: {:callback, input_fn, output_fn}
    }

    run_callback(state)
  end

  # Callback-based execution loop
  defp run_callback(%State{opcode: nil} = state) do
    state
    |> State.fetch_instruction()
    |> run_callback()
  end

  defp run_callback(%State{opcode: :halt} = state) do
    {:ok, state}
  end

  defp run_callback(
         %State{
           opcode: :input,
           memory: memory,
           arg1: arg1,
           io_service: {:callback, input_fn, _output_fn}
         } = state
       ) do
    input = input_fn.()

    %State{
      state
      | memory: Memory.set_value(memory, arg1, input),
        opcode: nil
    }
    |> run_callback()
  end

  defp run_callback(
         %State{opcode: :output, arg1_value: value, io_service: {:callback, _, output_fn}} = state
       ) do
    output_fn.(value)
    %State{state | opcode: nil} |> run_callback()
  end

  defp run_callback(%State{opcode: :adjust_rb} = state) do
    state |> Instructions.adjust_rb() |> State.reset() |> run_callback()
  end

  defp run_callback(%State{opcode: :jump_true} = state) do
    state |> Instructions.jump_true() |> State.reset() |> run_callback()
  end

  defp run_callback(%State{opcode: :jump_false} = state) do
    state |> Instructions.jump_false() |> State.reset() |> run_callback()
  end

  defp run_callback(%State{opcode: :add} = state) do
    state |> Instructions.add() |> State.reset() |> run_callback()
  end

  defp run_callback(%State{opcode: :multiply} = state) do
    state |> Instructions.multiply() |> State.reset() |> run_callback()
  end

  defp run_callback(%State{opcode: :less_then} = state) do
    state |> Instructions.less_then() |> State.reset() |> run_callback()
  end

  defp run_callback(%State{opcode: :equals} = state) do
    state |> Instructions.equals() |> State.reset() |> run_callback()
  end

  # Functional execution loop
  defp run_functional(%State{opcode: nil} = state) do
    state
    |> State.fetch_instruction()
    |> run_functional()
  end

  defp run_functional(%State{opcode: :halt} = state) do
    {:ok, state}
  end

  defp run_functional(%State{opcode: :input, io_service: {:functional, [], _}} = _state) do
    {:error, :input_exhausted}
  end

  defp run_functional(
         %State{
           opcode: :input,
           memory: memory,
           arg1: arg1,
           io_service: {:functional, [input | rest], outputs}
         } = state
       ) do
    %State{
      state
      | memory: Memory.set_value(memory, arg1, input),
        io_service: {:functional, rest, outputs},
        opcode: nil
    }
    |> run_functional()
  end

  defp run_functional(
         %State{opcode: :output, arg1_value: value, io_service: {:functional, inputs, outputs}} =
           state
       ) do
    %State{state | io_service: {:functional, inputs, [value | outputs]}, opcode: nil}
    |> run_functional()
  end

  defp run_functional(%State{opcode: :adjust_rb} = state) do
    state |> Instructions.adjust_rb() |> State.reset() |> run_functional()
  end

  defp run_functional(%State{opcode: :jump_true} = state) do
    state |> Instructions.jump_true() |> State.reset() |> run_functional()
  end

  defp run_functional(%State{opcode: :jump_false} = state) do
    state |> Instructions.jump_false() |> State.reset() |> run_functional()
  end

  defp run_functional(%State{opcode: :add} = state) do
    state |> Instructions.add() |> State.reset() |> run_functional()
  end

  defp run_functional(%State{opcode: :multiply} = state) do
    state |> Instructions.multiply() |> State.reset() |> run_functional()
  end

  defp run_functional(%State{opcode: :less_then} = state) do
    state |> Instructions.less_then() |> State.reset() |> run_functional()
  end

  defp run_functional(%State{opcode: :equals} = state) do
    state |> Instructions.equals() |> State.reset() |> run_functional()
  end

  # =============================================================================
  # GenServer API (async, process-based I/O)
  # =============================================================================

  @spec start_link(list(integer()), pid() | nil, pid() | nil) :: pid()
  def start_link(memory, input \\ nil, output \\ nil) do
    {:ok, pid} = GenServer.start_link(Intcode, {memory, input, output})

    pid
  end

  @impl GenServer
  def init({memory, input, output}) do
    {:ok, %State{memory: :array.from_list(memory), io_service: {input, output, nil}}}
  end

  @spec run_program_async(pid()) :: :ok
  def run_program_async(pid) do
    GenServer.cast(pid, :run_program)
  end

  @spec run_program(pid()) :: State.t()
  def run_program(pid) do
    GenServer.call(pid, :run_program)
  end

  @spec finished?(pid()) :: boolean()
  def finished?(pid) do
    GenServer.call(pid, :finished?)
  end

  @spec get_state(pid()) :: State.t()
  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  @spec add_output(pid(), pid()) :: :ok
  def add_output(pid, output) do
    GenServer.cast(pid, {:add_output, output})
  end

  @impl GenServer
  def handle_cast(:run_program, %State{} = state) do
    {:noreply, cycle(state)}
  end

  def handle_cast({:add_output, secondary}, %State{io_service: {input, output, _}} = state) do
    {:noreply, %State{state | io_service: {input, output, secondary}}}
  end

  @impl GenServer
  def handle_call(:finished?, _from, %State{opcode: :halt} = state) do
    {:reply, true, state}
  end

  def handle_call(:finished?, _from, %State{} = state) do
    {:reply, false, state}
  end

  def handle_call(:get_state, _from, %State{} = state) do
    {:reply, state, state}
  end

  def handle_call(:run_program, _from, %State{} = state) do
    state = cycle(state)
    {:reply, state, state}
  end

  @impl GenServer
  def handle_info(:halt, %State{} = state) do
    {:noreply, state}
  end

  def handle_info({:output, _}, %State{opcode: :halt} = state) do
    {:noreply, state}
  end

  # Optimized execution cycle using batched instruction fetching
  # Fetches opcode, modes, and all arguments in one step
  defp cycle(%State{opcode: nil} = state) do
    state
    |> State.fetch_instruction()
    |> execute()
  end

  # Execute the current instruction and continue the cycle
  defp execute(%State{opcode: :halt, io_service: {_, nil, nil}} = state) do
    state
  end

  defp execute(%State{opcode: :halt, io_service: {_, output, nil}} = state) do
    send(output, :halt)
    state
  end

  defp execute(%State{opcode: :halt, io_service: {_, output, secondary}} = state) do
    send(output, :halt)
    send(secondary, :halt)
    state
  end

  defp execute(%State{opcode: :input} = state) do
    state |> Instructions.input() |> State.reset() |> cycle()
  end

  defp execute(%State{opcode: :output} = state) do
    state |> Instructions.output() |> State.reset() |> cycle()
  end

  defp execute(%State{opcode: :adjust_rb} = state) do
    state |> Instructions.adjust_rb() |> State.reset() |> cycle()
  end

  defp execute(%State{opcode: :jump_true} = state) do
    state |> Instructions.jump_true() |> State.reset() |> cycle()
  end

  defp execute(%State{opcode: :jump_false} = state) do
    state |> Instructions.jump_false() |> State.reset() |> cycle()
  end

  defp execute(%State{opcode: :add} = state) do
    state |> Instructions.add() |> State.reset() |> cycle()
  end

  defp execute(%State{opcode: :multiply} = state) do
    state |> Instructions.multiply() |> State.reset() |> cycle()
  end

  defp execute(%State{opcode: :less_then} = state) do
    state |> Instructions.less_then() |> State.reset() |> cycle()
  end

  defp execute(%State{opcode: :equals} = state) do
    state |> Instructions.equals() |> State.reset() |> cycle()
  end
end

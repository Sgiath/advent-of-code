defmodule AdventOfCode.Year2019.Intcode do
  @moduledoc false

  use GenServer

  alias __MODULE__
  alias __MODULE__.Instructions
  alias __MODULE__.State

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

  defp cycle(%State{opcode: nil} = state) do
    state
    |> State.load_opcode()
    |> State.load_modes()
    |> State.next_instruction()
    |> cycle()
  end

  defp cycle(%State{opcode: :halt, io_service: {_, nil, nil}} = state) do
    state
  end

  defp cycle(%State{opcode: :halt, io_service: {_, output, nil}} = state) do
    send(output, :halt)
    state
  end

  defp cycle(%State{opcode: :halt, io_service: {_, output, secondary}} = state) do
    send(output, :halt)
    send(secondary, :halt)
    state
  end

  defp cycle(%State{arg1: nil} = state) do
    state
    |> State.load_arg1()
    |> State.next_instruction()
    |> cycle()
  end

  defp cycle(%State{opcode: :input} = state) do
    state
    |> Instructions.input()
    |> State.reset()
    |> cycle()
  end

  defp cycle(%State{opcode: :output} = state) do
    state
    |> Instructions.output()
    |> State.reset()
    |> cycle()
  end

  defp cycle(%State{opcode: :adjust_rb} = state) do
    state
    |> Instructions.adjust_rb()
    |> State.reset()
    |> cycle()
  end

  defp cycle(%State{arg2: nil} = state) do
    state
    |> State.load_arg2()
    |> State.next_instruction()
    |> cycle()
  end

  defp cycle(%State{opcode: :jump_true} = state) do
    state
    |> Instructions.jump_true()
    |> State.reset()
    |> cycle()
  end

  defp cycle(%State{opcode: :jump_false} = state) do
    state
    |> Instructions.jump_false()
    |> State.reset()
    |> cycle()
  end

  defp cycle(%State{arg3: nil} = state) do
    state
    |> State.load_arg3()
    |> State.next_instruction()
    |> cycle()
  end

  defp cycle(%State{opcode: :add} = state) do
    state
    |> Instructions.add()
    |> State.reset()
    |> cycle()
  end

  defp cycle(%State{opcode: :multiply} = state) do
    state
    |> Instructions.multiply()
    |> State.reset()
    |> cycle()
  end

  defp cycle(%State{opcode: :less_then} = state) do
    state
    |> Instructions.less_then()
    |> State.reset()
    |> cycle()
  end

  defp cycle(%State{opcode: :equals} = state) do
    state
    |> Instructions.equals()
    |> State.reset()
    |> cycle()
  end
end

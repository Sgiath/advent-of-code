defmodule AdventOfCode.Year2019.Day05 do
  @moduledoc false
  use AdventOfCode, year: 2019, day: 05

  alias AdventOfCode.Year2019.Intcode

  @doc """
  After providing 1 to the only input instruction and passing all the tests, what diagnostic code
  does the program produce?
  """
  @impl AdventOfCode
  def part1 do
    pid = input_list() |> Intcode.start_link(self(), self())
    Intcode.run_program_async(pid)

    handle_io(pid, 1)
  end

  @doc """
  This time, when the TEST diagnostic program runs its input instruction to get the ID of the
  system to test, provide it 5, the ID for the ship's thermal radiator controller. This
  diagnostic test suite only outputs one number, the diagnostic code.

  What is the diagnostic code for system ID 5?
  """
  @impl AdventOfCode
  def part2 do
    pid = input_list() |> Intcode.start_link(self(), self())

    Intcode.run_program_async(pid)

    pid
    |> handle_io(5)
    |> List.first()
  end

  defp handle_io(pid, input, outputs \\ []) do
    receive do
      :halt ->
        outputs

      :input ->
        send(pid, input)
        handle_io(pid, input, outputs)

      {:output, value} ->
        handle_io(pid, input, [value | outputs])
    end
  end
end

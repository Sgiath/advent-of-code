defmodule AdventOfCode.Year2019.Intcode.IO do
  @moduledoc false

  @spec get_input(pid()) :: integer()
  def get_input(io_service) do
    send(io_service, :input)

    receive do
      {:output, val} -> val
      val -> val
    end
  end

  @spec set_output(pid(), integer(), nil | pid()) :: integer()
  def set_output(io_service, value, nil) do
    send(io_service, {:output, value})
  end

  def set_output(io_service, value, secondary) do
    send(io_service, {:output, value})
    send(secondary, {:output, value})
  end
end

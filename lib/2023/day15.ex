defmodule AdventOfCode.Year2023.Day15 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/15
  """
  use AdventOfCode, year: 2023, day: 15

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  @doc ~S"""
  Hash the given string according to the rules

  ## Examples

      iex> AdventOfCode.Year2023.Day15.hash("HASH")
      52

  """
  def hash(string), do: hash(String.to_charlist(string), 0)
  def hash([], hash), do: hash
  def hash([first | rest], hash), do: hash(rest, rem((hash + first) * 17, 256))

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    initial_boxes = Enum.map(0..255, fn _i -> [] end)

    input
    |> parse()
    |> Enum.map(&convert_instruction/1)
    |> Enum.reduce(initial_boxes, &apply_inst/2)
    |> Enum.with_index(&sum_box/2)
    |> Enum.sum()
  end

  @doc ~S"""
  Convert instruction to better structure

  ## Examples

      iex> AdventOfCode.Year2023.Day15.convert_instruction("df=1")
      {:add, AdventOfCode.Year2023.Day15.hash("df"), "df", 1}

      iex> AdventOfCode.Year2023.Day15.convert_instruction("df-")
      {:rem, AdventOfCode.Year2023.Day15.hash("df"), "df"}

  """
  def convert_instruction(instruction) do
    if String.contains?(instruction, "=") do
      [label, focal_len] = String.split(instruction, "=", trim: true)
      {:add, hash(label), label, String.to_integer(focal_len)}
    else
      label = String.trim_trailing(instruction, "-")
      {:rem, hash(label), label}
    end
  end

  # apply adding instruction
  def apply_inst({:add, box_id, label, focal_len}, boxes) do
    # retrieve the appropriate box
    box = Enum.at(boxes, box_id, [])

    new_box =
      if i = Enum.find_index(box, fn {l, _f} -> l == label end) do
        # if label already exists replace it
        List.replace_at(box, i, {label, focal_len})
      else
        # if label does not exists add it to the end
        [{label, focal_len} | box]
      end

    # update boxes with the new box
    List.replace_at(boxes, box_id, new_box)
  end

  # apply removing instruction
  def apply_inst({:rem, box_id, label}, boxes) do
    # retrieve the appropriate box
    box = Enum.at(boxes, box_id, [])

    new_box =
      if i = Enum.find_index(box, fn {l, _f} -> l == label end) do
        # if label already exists delete it
        List.delete_at(box, i)
      else
        # if label does not exists do nothing
        box
      end

    # update boxes with the new box
    List.replace_at(boxes, box_id, new_box)
  end

  @doc """
  Sum focal strengths of lenses in one box
  """
  def sum_box(lenses, i) do
    lenses
    # boxes are in reverse order
    |> Enum.reverse()
    # calculate focal strength for each lens
    |> Enum.with_index(fn {_label, focal_len}, j -> (i + 1) * (j + 1) * focal_len end)
    # sum them together
    |> Enum.sum()
  end
end

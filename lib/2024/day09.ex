defmodule AdventOfCode.Year2024.Day09 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/9
  """
  use AdventOfCode, year: 2024, day: 09

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    2333133121414131402
    """
  end

  def parse(input) do
    disk =
      input
      |> String.trim_trailing("\n")
      |> String.to_charlist()
      |> Enum.map(fn n -> n - ?0 end)

    files =
      disk
      |> Enum.take_every(2)
      |> Enum.with_index()
      |> Enum.map(fn {size, id} -> {:file, size, id} end)

    space =
      disk
      |> tl()
      |> Enum.take_every(2)
      |> Enum.map(fn size -> {:free, size} end)

    merge(files, space)
    |> List.flatten()
  end

  def merge([file], []), do: [file]
  def merge([a | files], [b | space]), do: [a, b | merge(files, space)]

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> compress()
    |> checksum()
  end

  def compress(disk) do
    runs =
      disk
      |> Enum.map(fn
        {:file, size, _id} -> size
        {:free, _size} -> 0
      end)
      |> Enum.sum()

    compress(disk, Enum.reverse(disk), runs)
  end

  # when I have proccessed the length of the original array
  def compress(_disk1, _disk2, runs) when runs <= 0, do: []

  # free disk at the end -> skip it
  def compress(disk1, [{:free, _size} | disk2], runs) do
    compress(disk1, disk2, runs)
  end

  # file at start -> use it
  def compress([{:file, size, id} | disk1], disk2, runs) do
    if size > runs do
      [{:file, runs, id}]
    else
      [{:file, size, id} | compress(disk1, disk2, runs - size)]
    end
  end

  # free disk is same size as file -> replace the space with file
  def compress([{:free, size} | disk1], [{:file, size, id} | disk2], runs) do
    [{:file, size, id} | compress(disk1, disk2, runs - size)]
  end

  def compress([{:free, free_s} | disk1], [{:file, file_s, id} | disk2], l)
      when free_s > file_s do
    [{:file, file_s, id} | compress([{:free, free_s - file_s} | disk1], disk2, l - file_s)]
  end

  def compress([{:free, free_s} | disk1], [{:file, file_s, id} | disk2], l)
      when free_s < file_s do
    [{:file, free_s, id} | compress(disk1, [{:file, file_s - free_s, id} | disk2], l - free_s)]
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> defragment()
    |> checksum()
  end

  def defragment(disk) do
    files =
      disk
      |> Enum.filter(&(elem(&1, 0) == :file))
      |> Enum.reverse()

    defragment(disk, files)
  end

  def defragment(disk, []), do: disk

  def defragment(disk, [file | files]) do
    disk
    |> find_space(file)
    |> defragment(files)
  end

  # found itself -> no space exists, return
  def find_space([file | rest], file) do
    [file | rest]
  end

  # foound exact space
  def find_space([{:free, size} | rest], {:file, size, _id} = file) do
    [file | replace_free(rest, file)]
  end

  # found bigger space
  def find_space([{:free, free_s} | rest], {:file, file_s, _id} = file) when free_s > file_s do
    [file, {:free, free_s - file_s} | replace_free(rest, file)]
  end

  # did not found space
  def find_space([other | rest], file), do: [other | find_space(rest, file)]

  def replace_free([file | disk], {:file, size, _id} = file), do: [{:free, size} | disk]
  def replace_free([other | disk], file), do: [other | replace_free(disk, file)]

  # =============================================================================================
  # Utils
  # =============================================================================================

  def checksum(disk) do
    disk
    |> Enum.map(fn
      {:file, size, id} -> List.duplicate(id, size)
      {:free, size} -> List.duplicate(0, size)
    end)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {id, index} -> id * index end)
    |> Enum.sum()
  end
end

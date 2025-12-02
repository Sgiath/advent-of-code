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
    input
    |> String.trim_trailing("\n")
    |> String.to_charlist()
    |> Enum.map(fn n -> n - ?0 end)
  end

  # =============================================================================================
  # Part 1 - Optimized with :array and two-pointer approach
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    sizes = parse(input)

    # Expand disk into array of individual blocks
    disk = expand_to_array(sizes)
    total_size = :array.size(disk)

    # Compress using two-pointer approach
    compressed = compress(disk, 0, total_size - 1)

    # Calculate checksum directly
    checksum_array(compressed)
  end

  # Expand sizes into an array where each element is either a file_id or :free
  defp expand_to_array(sizes) do
    {blocks, _} =
      sizes
      |> Enum.with_index()
      |> Enum.reduce({[], 0}, fn {size, idx}, {acc, file_id} ->
        if rem(idx, 2) == 0 do
          # File block
          blocks = List.duplicate(file_id, size)
          {[blocks | acc], file_id + 1}
        else
          # Free space
          blocks = List.duplicate(:free, size)
          {[blocks | acc], file_id}
        end
      end)

    blocks
    |> Enum.reverse()
    |> List.flatten()
    |> :array.from_list()
  end

  # Two-pointer compression: move file blocks from right to fill free spaces on left
  defp compress(disk, left, right) when left >= right do
    disk
  end

  defp compress(disk, left, right) do
    left_val = :array.get(left, disk)
    right_val = :array.get(right, disk)

    cond do
      # Left is not free, move left pointer forward
      left_val != :free ->
        compress(disk, left + 1, right)

      # Right is free, move right pointer backward
      right_val == :free ->
        compress(disk, left, right - 1)

      # Left is free and right is a file - swap them
      true ->
        disk = :array.set(left, right_val, disk)
        disk = :array.set(right, :free, disk)
        compress(disk, left + 1, right - 1)
    end
  end

  defp checksum_array(disk) do
    :array.foldl(
      fn idx, val, acc ->
        case val do
          :free -> acc
          file_id -> acc + idx * file_id
        end
      end,
      0,
      disk
    )
  end

  # =============================================================================================
  # Part 2 - Optimized with map-based disk and sorted free space list
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    sizes = parse(input)

    # Build initial state with files list and free spaces list (sorted by position)
    {files, free_spaces} = build_state(sizes)

    # Defragment by processing files in reverse ID order
    final_files = defragment(files, free_spaces)

    # Calculate checksum directly from final file positions
    checksum_files(final_files)
  end

  # Build initial state: list of files with positions, sorted list of free spaces
  defp build_state(sizes) do
    {files, free_spaces, _pos, _file_id} =
      sizes
      |> Enum.with_index()
      |> Enum.reduce({[], [], 0, 0}, fn {size, idx}, {files, free_spaces, pos, file_id} ->
        if size == 0 do
          # Skip zero-size entries
          if rem(idx, 2) == 0 do
            {files, free_spaces, pos, file_id + 1}
          else
            {files, free_spaces, pos, file_id}
          end
        else
          if rem(idx, 2) == 0 do
            # File block - store {pos, size, id}
            files = [{pos, size, file_id} | files]
            {files, free_spaces, pos + size, file_id + 1}
          else
            # Free space - store {pos, size}
            free_spaces = [{pos, size} | free_spaces]
            {files, free_spaces, pos + size, file_id}
          end
        end
      end)

    # Files are already in reverse order (highest ID first) from reduce
    # Free spaces need to be reversed to be in position order (ascending)
    {files, Enum.reverse(free_spaces)}
  end

  defp defragment(files, free_spaces) do
    defragment(files, free_spaces, [])
  end

  defp defragment([], _free_spaces, result), do: result

  defp defragment([{file_pos, file_size, file_id} | rest_files], free_spaces, result) do
    # Find first free space that can fit this file and is to the left of it
    case find_and_update_space(free_spaces, file_size, file_pos, []) do
      {:found, space_pos, updated_free_spaces} ->
        # File moves to space_pos
        defragment(rest_files, updated_free_spaces, [{space_pos, file_size, file_id} | result])

      :not_found ->
        # File stays in place
        defragment(rest_files, free_spaces, [{file_pos, file_size, file_id} | result])
    end
  end

  # Find first free space that fits and update the list in one pass
  # Returns {:found, pos, updated_list} or :not_found
  defp find_and_update_space([], _file_size, _file_pos, _acc), do: :not_found

  defp find_and_update_space([{space_pos, _} | _rest], _file_size, file_pos, _acc)
       when space_pos >= file_pos do
    # Past the file position, no valid space found
    :not_found
  end

  defp find_and_update_space([{space_pos, space_size} | rest], file_size, _file_pos, acc)
       when space_size >= file_size do
    # Found a fitting space
    updated_list =
      if space_size == file_size do
        # Exact fit - remove space entirely
        Enum.reverse(acc) ++ rest
      else
        # Partial use - shrink and shift position
        new_space = {space_pos + file_size, space_size - file_size}
        Enum.reverse(acc) ++ [new_space | rest]
      end

    {:found, space_pos, updated_list}
  end

  defp find_and_update_space([space | rest], file_size, file_pos, acc) do
    # Space too small, keep looking
    find_and_update_space(rest, file_size, file_pos, [space | acc])
  end

  # Calculate checksum directly from file positions
  defp checksum_files(files) do
    Enum.reduce(files, 0, fn {pos, size, file_id}, acc ->
      # Sum of positions from pos to pos+size-1, each multiplied by file_id
      sum_positions = size * pos + div(size * (size - 1), 2)
      acc + file_id * sum_positions
    end)
  end
end
